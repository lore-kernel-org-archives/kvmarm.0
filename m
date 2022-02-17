Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA82C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 18:40:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 581A749EC1;
	Thu, 17 Feb 2022 13:40:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XO4Vofy47BrD; Thu, 17 Feb 2022 13:40:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A69949F07;
	Thu, 17 Feb 2022 13:40:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E03949EBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 13:40:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jao8jzChOuU3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 13:40:12 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4ADC49ECE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 13:40:11 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6EBE761B90;
 Thu, 17 Feb 2022 18:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74284C340F1;
 Thu, 17 Feb 2022 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645123210;
 bh=0AXo15yBYZFWMH8ykOuG3qsr78Xojpop/gHZzCMvs6A=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nWuSPtBUj7EMYZ/Wi++d/iL10sqRqgVtv0TY+/J7+I3KQ4Iy3A6jQryUG4Z2iqFxJ
 3OSPreK/+oyJUHhG9b/uUX0Y5X6SQNKmv31x7MaiJQ5YqcS5e3Qe9rmZSCG785l/Ut
 tUFoz9GFWGBIkzumhfy+7BUZjC6yIuCYAjDLs4cBFvIl1vqNJl2pAq2b20E4YWoSOE
 6h19VnrNi6KD/9I87N2AU91hDjZi7SW2/Yw/oNp8o40orc/WKX6crPNyIMOs8K6Gie
 pOzYPwCE1xw7jP7E0RuUvNFi/nrsGXhNtudoyk+X7A9BDp2fl52XGrSCKI8axZvrzF
 mSNEjbzN8FN7A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/3] KVM: arm64: Bump guest PSCI version to 1.1
Date: Thu, 17 Feb 2022 18:39:59 +0000
Message-Id: <20220217184001.11753-2-will@kernel.org>
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

Expose PSCI version v1.1 to the guest by default. The only difference
for now is that an updated version number is reported by PSCI_VERSION.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/psci.c  | 12 +++++++++---
 include/kvm/arm_psci.h |  3 ++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3eae32876897..70d07477e712 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -305,16 +305,19 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
+static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 feature;
 	unsigned long val;
 	int ret = 1;
 
+	if (minor > 1)
+		return -EINVAL;
+
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
-		val = KVM_ARM_PSCI_1_0;
+		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
 		break;
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		feature = smccc_get_arg1(vcpu);
@@ -393,8 +396,10 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
+	case KVM_ARM_PSCI_1_1:
+		return kvm_psci_1_x_call(vcpu, 1);
 	case KVM_ARM_PSCI_1_0:
-		return kvm_psci_1_0_call(vcpu);
+		return kvm_psci_1_x_call(vcpu, 0);
 	case KVM_ARM_PSCI_0_2:
 		return kvm_psci_0_2_call(vcpu);
 	case KVM_ARM_PSCI_0_1:
@@ -511,6 +516,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			return 0;
 		case KVM_ARM_PSCI_0_2:
 		case KVM_ARM_PSCI_1_0:
+		case KVM_ARM_PSCI_1_1:
 			if (!wants_02)
 				return -EINVAL;
 			vcpu->kvm->arch.psci_version = val;
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 5b58bd2fe088..4a1003323a0c 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -13,8 +13,9 @@
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
+#define KVM_ARM_PSCI_1_1	PSCI_VERSION(1, 1)
 
-#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_1
 
 /*
  * We need the KVM pointer independently from the vcpu as we can call
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
