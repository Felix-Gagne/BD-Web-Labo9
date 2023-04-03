using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Labo9A.Models
{
    [Table("Employe", Schema = "Employes")]
    public partial class Employe
    {
        public Employe()
        {
            Artistes = new HashSet<Artiste>();
        }

        [Key]
        [Column("EmployeID")]
        public int EmployeId { get; set; }
        [StringLength(50)]
        public string Prenom { get; set; } = null!;
        [StringLength(50)]
        public string Nom { get; set; } = null!;
        [StringLength(10)]
        [Unicode(false)]
        public string NoTel { get; set; } = null!;
        [StringLength(255)]
        public string? Courriel { get; set; }
        [Column(TypeName = "date")]
        public DateTime DateEmbauche { get; set; }

        [InverseProperty("Employe")]
        public virtual ICollection<Artiste> Artistes { get; set; }
    }
}
