Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2F1C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDB432081C
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDB432081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746484A537;
	Fri,  3 May 2019 08:45:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ncJFhahEg6Gk; Fri,  3 May 2019 08:45:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B1F4A4DE;
	Fri,  3 May 2019 08:45:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E923D4A4FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FM9bhgjdEFCc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:45:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECBB14A500
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 968E8169E;
 Fri,  3 May 2019 05:45:28 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F5AD3F220;
 Fri,  3 May 2019 05:45:25 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 13/56] KVM: arm64/sve: Context switch the SVE registers
Date: Fri,  3 May 2019 13:43:44 +0100
Message-Id: <20190503124427.190206-14-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

From: Dave Martin <Dave.Martin@arm.com>

In order to give each vcpu its own view of the SVE registers, this
patch adds context storage via a new sve_state pointer in struct
vcpu_arch.  An additional member sve_max_vl is also added for each
vcpu, to determine the maximum vector length visible to the guest
and thus the value to be configured in ZCR_EL2.LEN while the vcpu
is active.  This also determines the layout and size of the storage
in sve_state, which is read and written by the same backend
functions that are used for context-switching the SVE state for
host tasks.

On SVE-enabled vcpus, SVE access traps are now handled by switching
in the vcpu's SVE context and disabling the trap before returning
to the guest.  On other vcpus, the trap is not handled and an exit
back to the host occurs, where the handle_sve() fallback path
reflects an undefined instruction exception back to the guest,
consistently with the behaviour of non-SVE-capable hardware (as was
done unconditionally prior to this patch).

No SVE handling is added on non-VHE-only paths, since VHE is an
architectural and Kconfig prerequisite of SVE.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  6 +++
 arch/arm64/kvm/fpsimd.c           |  5 ++-
 arch/arm64/kvm/hyp/switch.c       | 75 +++++++++++++++++++++++--------
 3 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 22cf484b561f..4fabfd250de8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -228,6 +228,8 @@ struct vcpu_reset_state {
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
+	void *sve_state;
+	unsigned int sve_max_vl;
 
 	/* HYP configuration */
 	u64 hcr_el2;
@@ -323,6 +325,10 @@ struct kvm_vcpu_arch {
 	bool sysregs_loaded_on_cpu;
 };
 
+/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
+#define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
+				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
+
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
 #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 7053bf402131..6e3c9c8b2df9 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -87,10 +87,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
-					 NULL, SVE_VL_MIN);
+					 vcpu->arch.sve_state,
+					 vcpu->arch.sve_max_vl);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		clear_thread_flag(TIF_SVE);
+		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9d46066276b9..5444b9c6fb5c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -100,7 +100,10 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
 	val &= ~CPACR_EL1_ZEN;
-	if (!update_fp_enabled(vcpu)) {
+	if (update_fp_enabled(vcpu)) {
+		if (vcpu_has_sve(vcpu))
+			val |= CPACR_EL1_ZEN;
+	} else {
 		val &= ~CPACR_EL1_FPEN;
 		__activate_traps_fpsimd32(vcpu);
 	}
@@ -317,16 +320,48 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
+/* Check for an FPSIMD/SVE trap and handle as appropriate */
+static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
-	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
+	bool vhe, sve_guest, sve_host;
+	u8 hsr_ec;
 
-	if (has_vhe())
-		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
-			     cpacr_el1);
-	else
+	if (!system_supports_fpsimd())
+		return false;
+
+	if (system_supports_sve()) {
+		sve_guest = vcpu_has_sve(vcpu);
+		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
+		vhe = true;
+	} else {
+		sve_guest = false;
+		sve_host = false;
+		vhe = has_vhe();
+	}
+
+	hsr_ec = kvm_vcpu_trap_get_class(vcpu);
+	if (hsr_ec != ESR_ELx_EC_FP_ASIMD &&
+	    hsr_ec != ESR_ELx_EC_SVE)
+		return false;
+
+	/* Don't handle SVE traps for non-SVE vcpus here: */
+	if (!sve_guest)
+		if (hsr_ec != ESR_ELx_EC_FP_ASIMD)
+			return false;
+
+	/* Valid trap.  Switch the context: */
+
+	if (vhe) {
+		u64 reg = read_sysreg(cpacr_el1) | CPACR_EL1_FPEN;
+
+		if (sve_guest)
+			reg |= CPACR_EL1_ZEN;
+
+		write_sysreg(reg, cpacr_el1);
+	} else {
 		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
 			     cptr_el2);
+	}
 
 	isb();
 
@@ -335,24 +370,28 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
 		 */
-		if (system_supports_sve() &&
-		    (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE)) {
+		if (sve_host) {
 			struct thread_struct *thread = container_of(
-				host_fpsimd,
+				vcpu->arch.host_fpsimd_state,
 				struct thread_struct, uw.fpsimd_state);
 
-			sve_save_state(sve_pffr(thread), &host_fpsimd->fpsr);
+			sve_save_state(sve_pffr(thread),
+				       &vcpu->arch.host_fpsimd_state->fpsr);
 		} else {
-			__fpsimd_save_state(host_fpsimd);
+			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		}
 
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
-	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
-
-	if (vcpu_has_sve(vcpu))
+	if (sve_guest) {
+		sve_load_state(vcpu_sve_pffr(vcpu),
+			       &vcpu->arch.ctxt.gp_regs.fp_regs.fpsr,
+			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
 		write_sysreg_s(vcpu->arch.ctxt.sys_regs[ZCR_EL1], SYS_ZCR_EL12);
+	} else {
+		__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
+	}
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
@@ -388,10 +427,10 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * and restore the guest context lazily.
 	 * If FP/SIMD is not implemented, handle the trap and inject an
 	 * undefined instruction exception to the guest.
+	 * Similarly for trapped SVE accesses.
 	 */
-	if (system_supports_fpsimd() &&
-	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_FP_ASIMD)
-		return __hyp_switch_fpsimd(vcpu);
+	if (__hyp_handle_fpsimd(vcpu))
+		return true;
 
 	if (!__populate_fault_info(vcpu))
 		return true;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
