From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/37] arm64: KVM: Cleanup tpidr_el2 init on non-VHE
Date: Mon, 13 Aug 2018 15:57:29 +0100
Message-ID: <20180813145755.16566-12-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D85B74A1DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7wLS0uazJfwz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3780C4A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:25 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When running on a non-VHE system, we initialize tpidr_el2 to
contain the per-CPU offset required to reach per-cpu variables.

Actually, we initialize it twice: the first time as part of the
EL2 initialization, by copying tpidr_el1 into its el2 counterpart,
and another time by calling into __kvm_set_tpidr_el2.

It turns out that the first part is wrong, as it includes the
distance between the kernel mapping and the linear mapping, while
EL2 only cares about the linear mapping. This was the last vestige
of the first per-cpu use of tpidr_el2 that came in with SDEI.
The only caller then was hyp_panic(), and its now using the
pc-relative get_host_ctxt() stuff, instead of kimage addresses
from the literal pool.

It is not a big deal, as we override it straight away, but it is
slightly confusing. In order to clear said confusion, let's
set this directly as part of the hyp-init code, and drop the
ad-hoc HYP helper.

Reviewed-by: James Morse <james.morse@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 21 ++++++++-------------
 arch/arm64/kvm/hyp-init.S         |  6 +++---
 arch/arm64/kvm/hyp/sysreg-sr.c    |  5 -----
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe8777b12f86..268619ce0154 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,14 +380,19 @@ int kvm_perf_teardown(void);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-void __kvm_set_tpidr_el2(u64 tpidr_el2);
 DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
 {
-	u64 tpidr_el2;
+	/*
+	 * Calculate the raw per-cpu offset without a translation from the
+	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
+	 * so that we can use adr_l to access per-cpu variables in EL2.
+	 */
+	u64 tpidr_el2 = ((u64)this_cpu_ptr(&kvm_host_cpu_state) -
+			 (u64)kvm_ksym_ref(kvm_host_cpu_state));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -396,17 +401,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!static_branch_likely(&arm64_const_caps_ready));
-	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
-
-	/*
-	 * Calculate the raw per-cpu offset without a translation from the
-	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
-	 * so that we can use adr_l to access per-cpu variables in EL2.
-	 */
-	tpidr_el2 = (u64)this_cpu_ptr(&kvm_host_cpu_state)
-		- (u64)kvm_ksym_ref(kvm_host_cpu_state);
-
-	kvm_call_hyp(__kvm_set_tpidr_el2, tpidr_el2);
+	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
 }
 
 static inline bool kvm_arch_check_sve_has_vhe(void)
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6fd91b31a131..ea9225160786 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -57,6 +57,7 @@ __invalid:
 	 * x0: HYP pgd
 	 * x1: HYP stack
 	 * x2: HYP vectors
+	 * x3: per-CPU offset
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
@@ -119,9 +120,8 @@ CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	mov	sp, x1
 	msr	vbar_el2, x2
 
-	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
-	mrs	x1, tpidr_el1
-	msr	tpidr_el2, x1
+	/* Set tpidr_el2 for use by HYP */
+	msr	tpidr_el2, x3
 
 	/* Hello, World! */
 	eret
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 35bc16832efe..9ce223944983 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -288,8 +288,3 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sysregs_loaded_on_cpu = false;
 }
-
-void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
-{
-	asm("msr tpidr_el2, %0": : "r" (tpidr_el2));
-}
-- 
2.18.0
