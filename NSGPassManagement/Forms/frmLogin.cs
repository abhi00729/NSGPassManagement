﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Configuration;
using NSGPassManagement.Classes;
using NSGPassManagement.DAL;
using System.Data.SqlClient;
using NSGPassManagement.Forms;

namespace NSGPassManagement
{
    public partial class frmLogin : Form
    {
        private bool blnBeenHere;
        NSGPassManagementEntities DB = new NSGPassManagementEntities();

        public frmLogin()
        {
            InitializeComponent();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
            this.Dispose();
            Application.Exit(); 
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtUsername.Text))
            {
                txtUsername.Focus();
                MessageBox.Show("Please enter Username.", this.Text, MessageBoxButtons.OK,MessageBoxIcon.Information);
                return;
            }

            if (string.IsNullOrEmpty(txtPassword.Text))
            {
                txtPassword.Focus();
                MessageBox.Show("Please enter Password.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["LicenseExpiry"]))
            {
                if (DateTime.Today > DateTime.Parse(ConfigurationManager.AppSettings["LicenseExpiry"].ToString()))
                {
                    MessageBox.Show("Software License Expired, Please contact software administrator.");
                    return;
                }
            }

            this.btnLogin.Enabled = false;
            this.btnCancel.Enabled = false;
            this.Cursor = System.Windows.Forms.Cursors.WaitCursor;

            string username = txtUsername.Text.ToUpper();

            CoreUser coreUser = DB.CoreUsers.Where(cu => cu.UserName.ToUpper() == txtUsername.Text.ToUpper() && cu.UserPassword == txtPassword.Text).FirstOrDefault();
            
            if (coreUser != null)
            {
                GlobalClass.LoggedInUserID = coreUser.CoreUserID;
                GlobalClass.EmployeeName = coreUser.FirstName + " " + coreUser.LastName;

                NSGEmployee nsgEmp = DB.NSGEmployees.Where(em => em.NSGEmployeeCode == coreUser.EmployeeID).FirstOrDefault();

                if (coreUser.UserName.ToUpper() == "NSGADMIN")
                {
                    if (MessageBox.Show("Do you want to create user?", "Login", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    {
                        frmCreateUser createUserForm = new frmCreateUser();
                        this.Hide();
                        createUserForm.ShowDialog();
                        this.txtPassword.Text = string.Empty;
                        this.txtUsername.Text = string.Empty;
                        this.btnLogin.Enabled = true;
                        this.btnCancel.Enabled = true;
                        this.txtUsername.Focus();
                        this.Cursor = System.Windows.Forms.Cursors.Default;
                        this.Show();
                    }
                    else
                    {
                        //GlobalClass.LoggedInUserRank = DB.CoreRanks.Where(cr => cr.RankID == nsgEmp.RankID).FirstOrDefault().RankName;
                        //GlobalClass.LoggedInUserUnit = DB.CoreUnits.Where(cu => cu.UnitID == nsgEmp.UnitID).FirstOrDefault().UnitName;

                        this.btnLogin.Enabled = true;
                        this.btnCancel.Enabled = true;
                        this.Cursor = System.Windows.Forms.Cursors.Default;
                        this.Hide();
                        frmMainPage frmMainPage = new frmMainPage();
                        frmMainPage.ShowDialog();
                        this.Close();
                    }
                }
                else
                {
                    GlobalClass.LoggedInUserRank = DB.CoreRanks.Where(cr => cr.RankID == nsgEmp.RankID).FirstOrDefault().RankName;
                    GlobalClass.LoggedInUserUnit = DB.CoreUnits.Where(cu => cu.UnitID == nsgEmp.UnitID).FirstOrDefault().UnitName;

                    this.btnLogin.Enabled = true;
                    this.btnCancel.Enabled = true;
                    this.Cursor = System.Windows.Forms.Cursors.Default;
                    this.Hide();
                    frmMainPage frmMainPage = new frmMainPage();
                    frmMainPage.ShowDialog();
                    this.Close();
                }
            }
            else
            {
                MessageBox.Show("Invalid username or password!", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtPassword.Text = string.Empty;
                txtUsername.Text = string.Empty;
                txtUsername.Focus();
                this.btnLogin.Enabled = true;
                this.btnCancel.Enabled = true;
                this.Cursor = System.Windows.Forms.Cursors.Default;
                return;
            }
        }

        
        private void frmLogin_Activated(object sender, EventArgs e)
        {
            try
            {
                if (blnBeenHere == true)
                {
                    return;
                }

                blnBeenHere = true;

                if (DB.CoreUsers.Count() <= 0)
                {
                    MessageBox.Show("Currently there is no user created. You need to create a user to login into the application.", this.Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                    frmCreateUser createUserForm = new frmCreateUser();
                    this.Hide();
                    createUserForm.ShowDialog();
                    blnBeenHere = false;
                    this.Show();
                }
                else
                {
                    txtUsername.Focus();
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message, "Login Problem", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void frmLogin_Load(object sender, EventArgs e)
        {
            blnBeenHere = false;
            this.Text += " [" + GlobalClass.BuildVersion + "]";
            //txtUsername.Text = ConfigurationManager.AppSettings["DefaultUserName"].ToString();
            //txtPassword.Text = ConfigurationManager.AppSettings["DefaultUserPassword"].ToString();
        }

        private void txtUsername_KeyPress(object sender, KeyPressEventArgs e)
        {
            Validation.ValidateQuoteCharacter(txtUsername, e); 
        }

        private void txtPassword_KeyPress(object sender, KeyPressEventArgs e)
        {
            Validation.ValidateQuoteCharacter(txtPassword, e); 
        }
    }
}
