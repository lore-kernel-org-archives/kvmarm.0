Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F010C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 15:35:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94D44141A;
	Mon, 21 Feb 2022 10:35:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jrJjvUSovzcV; Mon, 21 Feb 2022 10:35:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F9A4B1E9;
	Mon, 21 Feb 2022 10:35:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 536E3411D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:35:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XW70JWaCb+LH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 10:35:35 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 909BB4101F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:35:35 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9532CB811CE;
 Mon, 21 Feb 2022 15:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7184C340F5;
 Mon, 21 Feb 2022 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645457734;
 bh=ioYnhhMN5iPvOyLNeAAzyks97Elblyc3LIWXTSvDI8A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=CRCEKmvwZgw6rBv8h6i49p2T7jUtVg536dQ8LOGoWo8sSfH6wjousopl+Qiq87aPS
 gl5ZynUJweBBAKTG7trMmnviPB3aYz4g6mEeijhnsI8cNEJR2t1O3gFh1+vY0qzg1l
 Ndi1Jyt+NdN/W0EenAqzuYGuN3IOaqJKiar9Hmv6coBB1/rbo17asNDCMYIN7yhZrL
 afM2umtI3zLpO8XOwGZDCt8BoO6f1DCl8l1i1aP4AtU/PF8dImArP/uAfFAgE2E5ei
 vEgQ1f5HLhKwLPfQBljBCYsTzKeipJdDqLd1EEk7KGWwqonr8s6dwIMfBPNr103Q2b
 HNAGX/rk3v6/g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/3] KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
Date: Mon, 21 Feb 2022 15:35:23 +0000
Message-Id: <20220221153524.15397-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220221153524.15397-1-will@kernel.org>
References: <20220221153524.15397-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

PSCI v1.1 introduces the optional SYSTEM_RESET2 call, which allows the
caller to provide a vendor-specific "reset type" and "cookie" to request
a particular form of reset or shutdown.

Expose this call to the guest and handle it in the same way as PSCI
SYSTEM_RESET, along with some basic range checking on the type argument.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/psci.c     | 33 +++++++++++++++++++++++++++++----
 include/uapi/linux/psci.h |  4 ++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 70d07477e712..30fcc5a99483 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -308,7 +308,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
 	u32 psci_fn = smccc_get_function(vcpu);
-	u32 feature;
+	u32 arg;
 	unsigned long val;
 	int ret = 1;
 
@@ -320,12 +320,12 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
 		break;
 	case PSCI_1_0_FN_PSCI_FEATURES:
-		feature = smccc_get_arg1(vcpu);
-		val = kvm_psci_check_allowed_function(vcpu, feature);
+		arg = smccc_get_arg1(vcpu);
+		val = kvm_psci_check_allowed_function(vcpu, arg);
 		if (val)
 			break;
 
-		switch(feature) {
+		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
 		case PSCI_0_2_FN64_CPU_SUSPEND:
@@ -341,11 +341,36 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
+		case PSCI_1_1_FN_SYSTEM_RESET2:
+		case PSCI_1_1_FN64_SYSTEM_RESET2:
+			if (minor >= 1) {
+				val = 0;
+				break;
+			}
+			fallthrough;
 		default:
 			val = PSCI_RET_NOT_SUPPORTED;
 			break;
 		}
 		break;
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		if (minor >= 1) {
+			arg = smccc_get_arg1(vcpu);
+
+			if (arg > PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET &&
+			    arg < PSCI_1_1_RESET_TYPE_VENDOR_START) {
+				val = PSCI_RET_INVALID_PARAMS;
+			} else {
+				kvm_psci_system_reset(vcpu);
+				val = PSCI_RET_INTERNAL_FAILURE;
+				ret = 0;
+			}
+			break;
+		};
+		fallthrough;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 2fcad1dd0b0e..2bf93c0d6354 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -82,6 +82,10 @@
 #define PSCI_0_2_TOS_UP_NO_MIGRATE		1
 #define PSCI_0_2_TOS_MP				2
 
+/* PSCI v1.1 reset type encoding for SYSTEM_RESET2 */
+#define PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET	0
+#define PSCI_1_1_RESET_TYPE_VENDOR_START	0x80000000U
+
 /* PSCI version decoding (independent of PSCI version) */
 #define PSCI_VERSION_MAJOR_SHIFT		16
 #define PSCI_VERSION_MINOR_MASK			\
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
