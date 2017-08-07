From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH] arm64: KVM: Reject non-compliant HVC calls from guest kernel
Date: Mon,  7 Aug 2017 14:03:28 -0500
Message-ID: <1502132608-26077-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A6B40D16
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Aug 2017 15:02:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GdwgTlfCANPH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Aug 2017 15:02:22 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F40340CE0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Aug 2017 15:02:22 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

The SMC/HVC instructions with an immediate value non-zero are not compliant
according to 'SMC calling convention system software document'. Add a
validation check in handle_hvc() to avoid malicious HVC calls from VM, and
inject an undefined instruction for those calls.

http://infocenter.arm.com/help/topic/com.arm.doc.den0028b/ARM_DEN0028B_SMC_Calling_Convention.pdf

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
 arch/arm64/include/asm/esr.h |  4 ++++
 arch/arm64/kvm/handle_exit.c | 12 +++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8cabd57..fa988e5 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -107,6 +107,9 @@
 #define ESR_ELx_AR 		(UL(1) << 14)
 #define ESR_ELx_CM 		(UL(1) << 8)
 
+/* ISS field definitions for HVC/SVC instruction execution traps */
+#define ESR_HVC_IMMEDIATE(esr)	((esr) & 0xFFFF)
+
 /* ISS field definitions for exceptions taken in to Hyp */
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
@@ -114,6 +117,7 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
 
+
 /* ESR value templates for specific events */
 
 /* BRK instruction trap from AArch64 state */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a16..a900dcd 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -42,13 +42,15 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
-	ret = kvm_psci_call(vcpu);
-	if (ret < 0) {
-		kvm_inject_undefined(vcpu);
-		return 1;
+	/* HVC immediate value must be zero for all compliant calls */
+	if (!ESR_HVC_IMMEDIATE(kvm_vcpu_get_hsr(vcpu))) {
+		ret = kvm_psci_call(vcpu);
+		if (ret >= 0)
+			return ret;
 	}
 
-	return ret;
+	kvm_inject_undefined(vcpu);
+	return 1;
 }
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
