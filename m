Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CC4C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 16:04:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7103123F2A
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 16:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7103123F2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E38D4B1E4;
	Thu, 10 Dec 2020 11:04:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ma4gHfxxl2Es; Thu, 10 Dec 2020 11:04:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBACA4B2AA;
	Thu, 10 Dec 2020 11:04:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A894B273
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 11:04:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DDy0vt4H7tFZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 11:04:24 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C7084B296
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 11:04:20 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9E0D223D57;
 Thu, 10 Dec 2020 16:04:19 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1knONC-0008Di-ND; Thu, 10 Dec 2020 16:00:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 23/66] KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,
 FPEN} settings
Date: Thu, 10 Dec 2020 15:59:19 +0000
Message-Id: <20201210160002.1407373-24-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, jintack.lim@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Jintack Lim <jintack.lim@linaro.org>
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

From: Jintack Lim <jintack.lim@linaro.org>

Forward traps due to FP/ASIMD register accesses to the virtual EL2
if virtual CPTR_EL2.TFP is set (with HCR_EL2.E2H == 0) or
CPTR_EL2.FPEN is configure to do so (with HCR_EL2.E2h == 1).

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: account for HCR_EL2.E2H when testing for TFP/FPEN, with
 all the hard work actually being done by Chase Conklin]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    | 26 +++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c            | 16 +++++++++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h | 11 +++++++++--
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5c7dc659e8c4..a000e6e05091 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -11,12 +11,14 @@
 #ifndef __ARM64_KVM_EMULATE_H__
 #define __ARM64_KVM_EMULATE_H__
 
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
@@ -321,6 +323,30 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 	return mode != PSR_MODE_EL0t;
 }
 
+static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	if (!nested_virt_in_use(vcpu))
+		return false;
+
+	val = vcpu_read_sys_reg(vcpu, CPTR_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		return (val & CPTR_EL2_TFP);
+
+	switch (FIELD_GET(CPACR_EL1_FPEN, val)) {
+	case 0b00:
+	case 0b10:
+		return true;
+	case 0b01:
+		return vcpu_el2_tge_is_set(vcpu) && !vcpu_mode_el2(vcpu);
+	case 0b11:
+	default:		/* GCC is dumb */
+		return false;
+	}
+}
+
 static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a2437b2380f1..5276e8563367 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -96,11 +96,19 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Guest access to FP/ASIMD registers are routed to this handler only
- * when the system doesn't support FP/ASIMD.
+ * This handles the cases where the system does not support FP/ASIMD or when
+ * we are running nested virtualization and the guest hypervisor is trapping
+ * FP/ASIMD accesses by its guest guest.
+ *
+ * All other handling of guest vs. host FP/ASIMD register state is handled in
+ * fixup_guest_exit().
  */
-static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
+static int kvm_handle_fpasimd(struct kvm_vcpu *vcpu)
 {
+	if (guest_hyp_fpsimd_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	/* This is the case when the system doesn't support FP/ASIMD. */
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -243,7 +251,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
-	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
 	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 424b074e4377..e5e201314c87 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -223,11 +223,18 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	    esr_ec != ESR_ELx_EC_SVE)
 		return false;
 
-	/* Don't handle SVE traps for non-SVE vcpus here: */
-	if (!sve_guest)
+	/*
+	 * Don't handle SVE traps for non-SVE vcpus here. This
+	 * includes NV guests for the time being.
+	 */
+	if (!sve_guest) {
 		if (esr_ec != ESR_ELx_EC_FP_ASIMD)
 			return false;
 
+		if (guest_hyp_fpsimd_traps_enabled(vcpu))
+			return false;
+	}
+
 	/* Valid trap.  Switch the context: */
 
 	if (vhe) {
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
