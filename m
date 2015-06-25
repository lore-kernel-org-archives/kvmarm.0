From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 1/3] arm/arm64: Introduce mmu_disable
Date: Thu, 25 Jun 2015 20:45:09 +0200
Message-ID: <1435257911-9715-2-git-send-email-drjones@redhat.com>
References: <1435257911-9715-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435257911-9715-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Allow unit test cpus to disable the MMU. Why not? We want the
test framework to be as flexible as possible. Callers will have
to deal with the cache coherency fallout... Cache flush support
is still forthcoming to the framework though.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S          | 9 +++++++++
 arm/cstart64.S        | 8 ++++++++
 lib/arm/asm/mmu-api.h | 1 +
 lib/arm/mmu.c         | 8 ++++++++
 4 files changed, 26 insertions(+)

diff --git a/arm/cstart.S b/arm/cstart.S
index 2b7f8f3d200ef..3943867d2f219 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -159,6 +159,15 @@ asm_mmu_enable:
 
 	mov     pc, lr
 
+.globl asm_mmu_disable
+asm_mmu_disable:
+	/* SCTLR */
+	mrc	p15, 0, r0, c1, c0, 0
+	bic	r0, #CR_M
+	mcr	p15, 0, r0, c1, c0, 0
+	isb
+	mov     pc, lr
+
 /*
  * Vector stubs
  * Simplified version of the Linux kernel implementation
diff --git a/arm/cstart64.S b/arm/cstart64.S
index cdda13c17af9e..44cff32d0f18e 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -146,6 +146,14 @@ asm_mmu_enable:
 
 	ret
 
+.globl asm_mmu_disable
+asm_mmu_disable:
+	mrs	x0, sctlr_el1
+	bic	x0, x0, SCTLR_EL1_M
+	msr	sctlr_el1, x0
+	isb
+	ret
+
 /*
  * Vectors
  * Adapted from arch/arm64/kernel/entry.S
diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 68dc707d67241..c46c4b08b14cc 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -4,6 +4,7 @@ extern pgd_t *mmu_idmap;
 extern bool mmu_enabled(void);
 extern void mmu_set_enabled(void);
 extern void mmu_enable(pgd_t *pgtable);
+extern void mmu_disable(void);
 extern void mmu_enable_idmap(void);
 extern void mmu_init_io_sect(pgd_t *pgtable, unsigned long virt_offset);
 extern void mmu_set_range_sect(pgd_t *pgtable, unsigned long virt_offset,
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 732000a8eb088..5966b408cb455 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -35,6 +35,14 @@ void mmu_enable(pgd_t *pgtable)
 	mmu_set_enabled();
 }
 
+extern void asm_mmu_disable(void);
+void mmu_disable(void)
+{
+	struct thread_info *ti = current_thread_info();
+	cpumask_clear_cpu(ti->cpu, &mmu_enabled_cpumask);
+	asm_mmu_disable();
+}
+
 void mmu_set_range_ptes(pgd_t *pgtable, unsigned long virt_offset,
 			unsigned long phys_start, unsigned long phys_end,
 			pgprot_t prot)
-- 
2.4.3

