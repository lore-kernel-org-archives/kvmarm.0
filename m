Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472B5C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 12:25:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAC6E64F59
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 12:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAC6E64F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD474B75F;
	Thu, 18 Mar 2021 08:25:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lr7TUaJVUhZb; Thu, 18 Mar 2021 08:25:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 167514B77C;
	Thu, 18 Mar 2021 08:25:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CED64B767
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 08:25:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kWfH4bJmsfp2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 08:25:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7C444B6C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 08:25:48 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1BA9664F6F;
 Thu, 18 Mar 2021 12:25:48 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lMrik-002OZW-AQ; Thu, 18 Mar 2021 12:25:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH v2 06/11] KVM: arm64: Rework SVE host-save/guest-restore
Date: Thu, 18 Mar 2021 12:25:27 +0000
Message-Id: <20210318122532.505263-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210318122532.505263-1-maz@kernel.org>
References: <20210318122532.505263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com,
 daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 broonie@kernel.org, ascull@google.com, qperret@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 daniel.kiss@arm.com
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

In order to keep the code readable, move the host-save/guest-restore
sequences in their own functions, with the following changes:
- the hypervisor ZCR is now set from C code
- ZCR_EL2 is always used as the EL2 accessor

This results in some minor assembler macro rework.
No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/fpsimdmacros.h   |  8 +++--
 arch/arm64/include/asm/kvm_hyp.h        |  2 +-
 arch/arm64/kvm/hyp/fpsimd.S             |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 40 +++++++++++++++----------
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index e9b72d35b867..a2563992d2dc 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -232,8 +232,7 @@
 		str		w\nxtmp, [\xpfpsr, #4]
 .endm
 
-.macro sve_load nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
-		sve_load_vq	\xvqminus1, x\nxtmp, \xtmp2
+.macro __sve_load nxbase, xpfpsr, nxtmp
  _for n, 0, 31,	_sve_ldr_v	\n, \nxbase, \n - 34
 		_sve_ldr_p	0, \nxbase
 		_sve_wrffr	0
@@ -244,3 +243,8 @@
 		ldr		w\nxtmp, [\xpfpsr, #4]
 		msr		fpcr, x\nxtmp
 .endm
+
+.macro sve_load nxbase, xpfpsr, xvqminus1, nxtmp, xtmp2
+		sve_load_vq	\xvqminus1, x\nxtmp, \xtmp2
+		__sve_load	\nxbase, \xpfpsr, \nxtmp
+.endm
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index e8b0f7fcd86b..a3e89424ae63 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -86,7 +86,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 void __sve_save_state(void *sve_pffr, u32 *fpsr);
-void __sve_restore_state(void *sve_pffr, u32 *fpsr, unsigned int vqminus1);
+void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 95b22e10996c..3c635929771a 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -21,7 +21,7 @@ SYM_FUNC_START(__fpsimd_restore_state)
 SYM_FUNC_END(__fpsimd_restore_state)
 
 SYM_FUNC_START(__sve_restore_state)
-	sve_load 0, x1, x2, 3, x4
+	__sve_load 0, x1, 2
 	ret
 SYM_FUNC_END(__sve_restore_state)
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index fb68271c1a0f..8071e1cad289 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -196,6 +196,24 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
+{
+	struct thread_struct *thread;
+
+	thread = container_of(vcpu->arch.host_fpsimd_state, struct thread_struct,
+			      uw.fpsimd_state);
+
+	__sve_save_state(sve_pffr(thread), &vcpu->arch.host_fpsimd_state->fpsr);
+}
+
+static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
+{
+	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	__sve_restore_state(vcpu_sve_pffr(vcpu),
+			    &vcpu->arch.ctxt.fp_regs.fpsr);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
+}
+
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
@@ -251,28 +269,18 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
 		 */
-		if (sve_host) {
-			struct thread_struct *thread = container_of(
-				vcpu->arch.host_fpsimd_state,
-				struct thread_struct, uw.fpsimd_state);
-
-			__sve_save_state(sve_pffr(thread),
-					 &vcpu->arch.host_fpsimd_state->fpsr);
-		} else {
+		if (sve_host)
+			__hyp_sve_save_host(vcpu);
+		else
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
-		}
 
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
-	if (sve_guest) {
-		__sve_restore_state(vcpu_sve_pffr(vcpu),
-				    &vcpu->arch.ctxt.fp_regs.fpsr,
-				    vcpu_sve_vq(vcpu) - 1);
-		write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
-	} else {
+	if (sve_guest)
+		__hyp_sve_restore_guest(vcpu);
+	else
 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
-	}
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
