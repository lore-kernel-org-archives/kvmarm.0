Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD87C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:34:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9591820734
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vjvm13fr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9591820734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3294B23F;
	Wed, 10 Jun 2020 07:34:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BaMeA7-A6IC0; Wed, 10 Jun 2020 07:34:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245F54B150;
	Wed, 10 Jun 2020 07:34:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6044B237
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 07:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bmNkjRcC1S9r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 07:34:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DED064B193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 07:34:17 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1B0F6207C3;
 Wed, 10 Jun 2020 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591788857;
 bh=LrJuTKlNXi8lbOBqQ8upVYMPjpFyfQxm7kVAOe0pMNs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Vjvm13frrT8f8Ip+ua8E4EivlnNAo9a3KKODOQqwTbtsUCiZEy6vKShPP9jxcbe6g
 jOYjWgvAXRVtOUlFJINOHdQSuV3lgkLJoFcD30Q+geqe/8tXtNIDPOFQhJ4G5H6XoN
 sGgAvMeVJehuqkfYO0BabfwRRBmVaJTO7V8TxFBM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jiyzn-001lrp-L6; Wed, 10 Jun 2020 12:34:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/4] KVM: arm64: Handle PtrAuth traps early
Date: Wed, 10 Jun 2020 12:34:04 +0100
Message-Id: <20200610113406.1493170-3-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200610113406.1493170-1-maz@kernel.org>
References: <20200610113406.1493170-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 catalin.marinas@arm.com, mark.rutland@arm.com, ascull@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

The current way we deal with PtrAuth is a bit heavy handed:

- We forcefully save the host's keys on each vcpu_load()
- Handling the PtrAuth trap forces us to go all the way back
  to the exit handling code to just set the HCR bits

Overall, this is pretty cumbersome. A better approach would be
to handle it the same way we deal with the FPSIMD registers:

- On vcpu_load() disable PtrAuth for the guest
- On first use, save the host's keys, enable PtrAuth in the
  guest

Crucially, this can happen as a fixup, which is done very early
on exit. We can then reenter the guest immediately without
leaving the hypervisor role.

Another thing is that it simplify the rest of the host handling:
exiting all the way to the host means that the only possible
outcome for this trap is to inject an UNDEF.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c         | 17 +---------
 arch/arm64/kvm/handle_exit.c | 17 ++--------
 arch/arm64/kvm/hyp/switch.c  | 61 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c    | 13 +++-----
 4 files changed, 70 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 152049c5055d..14b747266607 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -337,12 +337,6 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-#define __ptrauth_save_key(regs, key)						\
-({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
-})
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
@@ -376,17 +370,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	if (vcpu_has_ptrauth(vcpu)) {
-		struct kvm_cpu_context *ctxt = vcpu->arch.host_cpu_context;
-
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
-
+	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
-	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 065251efa2e6..5a02d4c90559 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,25 +162,14 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-/*
- * Handle the guest trying to use a ptrauth instruction, or trying to access a
- * ptrauth register.
- */
-void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
-{
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu_ptrauth_enable(vcpu);
-	else
-		kvm_inject_undefined(vcpu);
-}
-
 /*
  * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
- * a NOP).
+ * a NOP). If we get here, it is that we didn't fixup ptrauth on exit, and all
+ * that we can do is give the guest an UNDEF.
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	kvm_arm_vcpu_ptrauth_trap(vcpu);
+	kvm_inject_undefined(vcpu);
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c07a45643cd4..d60c2ef0fe8c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -490,6 +490,64 @@ static bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool __hyp_text esr_is_ptrauth_trap(u32 esr)
+{
+	u32 ec = ESR_ELx_EC(esr);
+
+	if (ec == ESR_ELx_EC_PAC)
+		return true;
+
+	if (ec != ESR_ELx_EC_SYS64)
+		return false;
+
+	switch (esr_sys64_to_sysreg(esr)) {
+	case SYS_APIAKEYLO_EL1:
+	case SYS_APIAKEYHI_EL1:
+	case SYS_APIBKEYLO_EL1:
+	case SYS_APIBKEYHI_EL1:
+	case SYS_APDAKEYLO_EL1:
+	case SYS_APDAKEYHI_EL1:
+	case SYS_APDBKEYLO_EL1:
+	case SYS_APDBKEYHI_EL1:
+	case SYS_APGAKEYLO_EL1:
+	case SYS_APGAKEYHI_EL1:
+		return true;
+	}
+
+	return false;
+}
+
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt;
+	u64 val;
+
+	if (!vcpu_has_ptrauth(vcpu) ||
+	    !esr_is_ptrauth_trap(kvm_vcpu_get_hsr(vcpu)))
+		return false;
+
+	ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	__ptrauth_save_key(ctxt->sys_regs, APIA);
+	__ptrauth_save_key(ctxt->sys_regs, APIB);
+	__ptrauth_save_key(ctxt->sys_regs, APDA);
+	__ptrauth_save_key(ctxt->sys_regs, APDB);
+	__ptrauth_save_key(ctxt->sys_regs, APGA);
+
+	vcpu_ptrauth_enable(vcpu);
+
+	val = read_sysreg(hcr_el2);
+	val |= (HCR_API | HCR_APK);
+	write_sysreg(val, hcr_el2);
+
+	return true;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -524,6 +582,9 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (__hyp_handle_fpsimd(vcpu))
 		return true;
 
+	if (__hyp_handle_ptrauth(vcpu))
+		return true;
+
 	if (!__populate_fault_info(vcpu))
 		return true;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad1d57501d6d..564995084cf8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1034,16 +1034,13 @@ static bool trap_ptrauth(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *rd)
 {
-	kvm_arm_vcpu_ptrauth_trap(vcpu);
-
 	/*
-	 * Return false for both cases as we never skip the trapped
-	 * instruction:
-	 *
-	 * - Either we re-execute the same key register access instruction
-	 *   after enabling ptrauth.
-	 * - Or an UNDEF is injected as ptrauth is not supported/enabled.
+	 * If we land here, that is because we didn't fixup the access on exit
+	 * by allowing the PtrAuth sysregs. The only way this happens is when
+	 * the guest does not have PtrAuth support enabled.
 	 */
+	kvm_inject_undefined(vcpu);
+
 	return false;
 }
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
