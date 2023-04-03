using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Labo9A.Models
{
    [Keyless]
    public partial class VwListeArtiste
    {
        [Column("EmployeID")]
        public int EmployeId { get; set; }
        [Column("ArtisteID")]
        public int ArtisteId { get; set; }
        [StringLength(50)]
        public string Prenom { get; set; } = null!;
        [StringLength(50)]
        public string Nom { get; set; } = null!;
        [StringLength(20)]
        public string Specialite { get; set; } = null!;
        [StringLength(10)]
        [Unicode(false)]
        public string NoTel { get; set; } = null!;
        [StringLength(255)]
        public string? Courriel { get; set; }
        [Column(TypeName = "date")]
        public DateTime DateEmbauche { get; set; }
    }
}
