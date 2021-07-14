Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E32C07E9C
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E59A613AF
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E59A613AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5AF94B09F;
	Wed, 14 Jul 2021 05:55:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 14yIUkR99g3s; Wed, 14 Jul 2021 05:55:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EB294B080;
	Wed, 14 Jul 2021 05:55:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2F749E8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wYI4EyntrxX5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 05:55:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E1E407F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15011D6E;
 Wed, 14 Jul 2021 02:55:08 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08F453F774;
 Wed, 14 Jul 2021 02:55:06 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/5] KVM: arm64: Move vcpu_has_feature() to asm/kvm_host.h
Date: Wed, 14 Jul 2021 10:55:57 +0100
Message-Id: <20210714095601.184854-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714095601.184854-1-alexandru.elisei@arm.com>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Move the vcpu_has_feature() function to asm/kvm_host.h in preparation for
replacing test_bit() feature checks.

struct kvm_vcpu is defined in linux/kvm_host.h, which includes
asm/kvm_host.h; the function has been transformed into a macro to avoid
compiler errors about struct kvm_vcpu being undefined.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 5 -----
 arch/arm64/include/asm/kvm_host.h    | 3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fd418955e31e..6bf776c2399c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -466,9 +466,4 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
 }
 
-static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
-{
-	return test_bit(feature, vcpu->arch.features);
-}
-
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..0b087bcfcfeb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -774,6 +774,9 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
+#define vcpu_has_feature(vcpu, feature) \
+	(test_bit((feature), (vcpu)->arch.features))
+
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
