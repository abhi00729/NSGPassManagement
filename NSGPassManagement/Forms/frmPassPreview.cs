using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace NSGPassManagement.Forms
{
    public partial class frmPassPreview : Form
    {
        public frmPassPreview()
        {
            InitializeComponent();
        }

        private void PassPreview_Load(object sender, EventArgs e)
        {
            pictureBox1.ImageLocation = @"D:\MyProjects\NSGPassManagement\Pass Images\Civilian Labour Part 1.JPG";
        }
    }
}
