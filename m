Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B984CC43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 14:30:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E0A324685
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 14:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E0A324685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8064AE8D;
	Fri, 20 Dec 2019 09:30:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jSbLdSkoWrAF; Fri, 20 Dec 2019 09:30:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAA6E4ACD5;
	Fri, 20 Dec 2019 09:30:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F764AC65
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 09:30:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ppfoO0rfvO3B for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 09:30:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D67004AC77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 09:30:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CFB930E;
 Fri, 20 Dec 2019 06:30:45 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C12B3F718;
 Fri, 20 Dec 2019 06:30:43 -0800 (PST)
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 06/18] arm64: KVM: split debug save restore across vm/traps
 activation
Date: Fri, 20 Dec 2019 14:30:13 +0000
Message-Id: <20191220143025.33853-7-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Sudeep Holla <sudeep.holla@arm.com>

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
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  6 ++++--
 arch/arm64/kvm/hyp/debug-sr.c    | 25 ++++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      | 12 ++++++++----
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 97f21cc66657..011e7963f772 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -69,8 +69,10 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
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
index 98be2f11c16c..c803daebd596 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -168,20 +168,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
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
 
@@ -194,7 +187,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -218,6 +211,20 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
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
index 250f13910882..67b7c160f65b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -626,6 +626,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	/*
 	 * ARM erratum 1165522 requires us to configure both stage 1 and
@@ -642,7 +643,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -656,6 +657,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 
 	__deactivate_traps(vcpu);
 
@@ -664,7 +666,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	return exit_code;
 }
@@ -698,6 +700,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -716,7 +719,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -730,6 +733,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	__sysreg_save_state_nvhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
@@ -746,7 +750,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
