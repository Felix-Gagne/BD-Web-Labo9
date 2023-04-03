using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Labo9A.Models;

namespace Labo9A.Data
{
    public partial class Lab09_EmployesContext : DbContext
    {
        public Lab09_EmployesContext()
        {
        }

        public Lab09_EmployesContext(DbContextOptions<Lab09_EmployesContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Artiste> Artistes { get; set; } = null!;
        public virtual DbSet<Employe> Employes { get; set; } = null!;
        public virtual DbSet<VwListeArtiste> VwListeArtistes { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Name=BDEmployes");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Artiste>(entity =>
            {
                entity.HasOne(d => d.Employe)
                    .WithMany(p => p.Artistes)
                    .HasForeignKey(d => d.EmployeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Artiste_EmployeID");
            });

            modelBuilder.Entity<Employe>(entity =>
            {
                entity.Property(e => e.NoTel).IsFixedLength();
            });

            modelBuilder.Entity<VwListeArtiste>(entity =>
            {
                entity.ToView("VW_ListeArtistes", "Employes");

                entity.Property(e => e.NoTel).IsFixedLength();
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
