//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace NSGPassManagement.DAL
{
    using System;
    
    public partial class PassHolderDetailsGet_Result
    {
        public long NSGPassID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public System.DateTime IssueDate { get; set; }
        public Nullable<System.DateTime> ExpiryDate { get; set; }
        public string PassTypeName { get; set; }
        public string CityName { get; set; }
        public string StateName { get; set; }
        public string VehicleNumber { get; set; }
        public string EntryBy { get; set; }
    }
}
