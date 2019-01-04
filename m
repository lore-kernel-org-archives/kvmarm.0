From: lantianyu1986@gmail.com
Subject: [PATCH 10/11] KVM: Add flush parameter for kvm_age_hva()
Date: Fri,  4 Jan 2019 16:54:04 +0800
Message-ID: <20190104085405.40356-11-Tianyu.Lan@microsoft.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0A44A382
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vb-uqBIfDG-n for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 03:55:35 -0500 (EST)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1F7B4A369
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 03:55:35 -0500 (EST)
Received: by mail-pf1-f195.google.com with SMTP id c123so18010136pfb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jan 2019 00:55:35 -0800 (PST)
In-Reply-To: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patch is to add flush parameter for kvm_aga_hva() and inside code
can check whether tlb flush is necessary when associated sptes are changed.
The platform may just flush affected address tlbs instead of entire
table's.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/arm/include/asm/kvm_host.h     | 3 ++-
 arch/arm64/include/asm/kvm_host.h   | 3 ++-
 arch/mips/include/asm/kvm_host.h    | 3 ++-
 arch/mips/kvm/mmu.c                 | 3 ++-
 arch/powerpc/include/asm/kvm_host.h | 3 ++-
 arch/powerpc/kvm/book3s.c           | 3 ++-
 arch/powerpc/kvm/e500_mmu_host.c    | 3 ++-
 arch/x86/include/asm/kvm_host.h     | 3 ++-
 arch/x86/kvm/mmu.c                  | 5 +++--
 virt/kvm/arm/mmu.c                  | 3 ++-
 virt/kvm/kvm_main.c                 | 4 ++--
 11 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4f3400a74a17..7d7f9ff27500 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -229,7 +229,8 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 063886be25ad..6f4539e13a26 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -361,7 +361,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 71c3f21d80d5..ae1b079ad740 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -934,7 +934,8 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 /* Emulation */
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index f36ccb2d43ec..b69baf01dbac 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -582,7 +582,8 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	return pte_young(*gpa_pte);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush)
 {
 	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
 }
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 0f98f00da2ea..d160e6b8ccfb 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -70,7 +70,8 @@
 
 extern int kvm_unmap_hva_range(struct kvm *kvm,
 			       unsigned long start, unsigned long end);
-extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		       bool flush);
 extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 extern int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index bd1a677dd9e4..430a8b81ef81 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -841,7 +841,8 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 	return kvm->arch.kvm_ops->unmap_hva_range(kvm, start, end);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush)
 {
 	return kvm->arch.kvm_ops->age_hva(kvm, start, end);
 }
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index c3f312b2bcb3..e2f6c23ec39a 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -745,7 +745,8 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 	return 0;
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush)
 {
 	/* XXX could be more clever ;) */
 	return 0;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 22dbaa8fba32..4f3ff9d5b631 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1518,7 +1518,8 @@ asmlinkage void kvm_spurious_fault(void);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 30ed7a79335b..a5728f51bf7d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1995,9 +1995,10 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
+	return kvm_handle_hva_range(kvm, start, end, flush, kvm_age_rmapp);
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 232007ff3208..bbea7cfd6909 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2110,7 +2110,8 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 		return pte_young(*pte);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end,
+		bool flush)
 {
 	if (!kvm->arch.pgd)
 		return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bcbe059d98be..afec5787fc1d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -432,7 +432,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 
-	young = kvm_age_hva(kvm, start, end);
+	young = kvm_age_hva(kvm, start, end, true);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
 
@@ -465,7 +465,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	young = kvm_age_hva(kvm, start, end);
+	young = kvm_age_hva(kvm, start, end, false);
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.14.4
