Return-Path: <SRS0=jV2N=TX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30739C282DD
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFEA62177E
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFEA62177E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D34B4A4F6;
	Thu, 23 May 2019 06:35:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xTPeOWqCVzKf; Thu, 23 May 2019 06:35:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0917C4A319;
	Thu, 23 May 2019 06:35:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB07E4A4FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BoXl151dGE4C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 May 2019 06:35:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D304B4A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5757AA78;
 Thu, 23 May 2019 03:35:37 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 425933F718;
 Thu, 23 May 2019 03:35:35 -0700 (PDT)
From: Sudeep Holla <sudeep.holla@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 07/15] arm64: KVM: split debug save restore across vm/traps
 activation
Date: Thu, 23 May 2019 11:34:54 +0100
Message-Id: <20190523103502.25925-8-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

If we enable profiling buffer controls at EL1 generate a trap exception
to EL2, it also changes profiling buffer to use EL1&0 stage 1 translation
regime in case of VHE. To support SPE both in the guest and host, we
need to first stop profiling and flush the profiling buffers before
we activate/switch vm or enable/disable the traps.

In prepartion to do that, lets split the debug save restore functionality
into 4 steps:
1. debug_save_host_context - saves the host context
2. debug_restore_guest_context - restore the guest context
3. debug_save_guest_context - saves the guest context
4. debug_restore_host_context - restores the host context

Lets rename existing __debug_switch_to_{host,guest} to make sure it's
aligned to the above and just add the place holders for new ones getting
added here as we need them to support SPE in guests.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  6 ++++--
 arch/arm64/kvm/hyp/debug-sr.c    | 25 ++++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      | 12 ++++++++----
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 782955db61dd..1c5ed80fcbda 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -164,8 +164,10 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
-void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
-void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+void __debug_save_host_context(struct kvm_vcpu *vcpu);
+void __debug_restore_guest_context(struct kvm_vcpu *vcpu);
+void __debug_save_guest_context(struct kvm_vcpu *vcpu);
+void __debug_restore_host_context(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index fa51236ebcb3..618884df1dc4 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -149,20 +149,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -175,7 +168,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -199,6 +192,20 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
+void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Non-VHE: Disable and flush SPE data generation
+	 * VHE: The vcpu can run, but it can't hide.
+	 */
+	if (!has_vhe())
+		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
+{
+}
+
 u32 __hyp_text __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9b2461138ddc..844f0dd7a7f0 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -515,6 +515,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	/*
 	 * ARM erratum 1165522 requires us to configure both stage 1 and
@@ -531,7 +532,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -545,6 +546,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 
 	__deactivate_traps(vcpu);
 
@@ -553,7 +555,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	return exit_code;
 }
@@ -587,6 +589,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	__activate_vm(kern_hyp_va(vcpu->kvm));
 	__activate_traps(vcpu);
@@ -600,7 +603,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -614,6 +617,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	__sysreg_save_state_nvhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
@@ -630,7 +634,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
