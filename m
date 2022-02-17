Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC06C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 18:40:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C0AF49EF5;
	Thu, 17 Feb 2022 13:40:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YzsSRBrbYAdu; Thu, 17 Feb 2022 13:40:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D3D49F01;
	Thu, 17 Feb 2022 13:40:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2665949EC1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 13:40:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0hzEH1q3F5lx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 13:40:14 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C214849EBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 13:40:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4D2DF61B8F;
 Thu, 17 Feb 2022 18:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6C3C340EC;
 Thu, 17 Feb 2022 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645123212;
 bh=AvpDsTJy33MMXHL+fb3Mjorlmhx4c1Iz104Hh8djs+k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZHJmbBUH+Du9K4eelGWklUpeIaMN0DUEnODhCluhEvmQQ8zQsMe6r6DJvN6k0QGd1
 YyT+aU2TEZ4racjn+QGfERZcT+uteJZH5XVD3J3uOKiY3HSuKa6+HJRjHLGMJ5iEo8
 QYc7F4uYfoFaVy2v84Oo0iVrydL0DpImYO1FDESQD7HqXmSe780/ArpBFq3lbbwBZc
 V1wRi14343rNB1p1bwm2Ah0EPGUBDmu7CoSAprl84PZPaLLohf/crTHP1MuOj0I0Km
 jeqOX3rBUzkSChEw9L+rFlgPiG1Kx7raDztNK/x/lMZ1fduTJsd71iUYnmlYH9YuPz
 5Hc+CN/ghDH5w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/3] KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
Date: Thu, 17 Feb 2022 18:40:00 +0000
Message-Id: <20220217184001.11753-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217184001.11753-1-will@kernel.org>
References: <20220217184001.11753-1-will@kernel.org>
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
caller to provide a vendor-specific "reset type" to request a particular
form of reset or shutdown.

Expose this call to the guest and handle it in the same way as PSCI
SYSTEM_RESET, along with some basic range checking on the argument.

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
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
