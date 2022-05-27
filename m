Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BC9C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C5E749E20;
	Fri, 27 May 2022 04:06:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 456AySUuXlz7; Fri, 27 May 2022 04:06:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 072594B30B;
	Fri, 27 May 2022 04:06:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8C849E5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XWY5YiVZHL7H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:06:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D171849E20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638779;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JmejXcqy3igKfzXfj854zdtX6ccYIqInqbAINc4o8Ro=;
 b=RV6Mvk0iwwmM2RBL0L/4ArgCE+I50fnjajZWuWk76QrSuCKHDlYjO/KvAqWYqKEWAkqlHx
 EFEat1IdJiBq2N5HTMEn35CQCORc9G3FKOmzE5nKi6Ov12D36uuHEJULfu6OUlGdEAM/Qw
 L3iGiXdN6L3PRJVDUp/dI/fJ9bAADW4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-quDHT6L0NL646pHc2VDpBw-1; Fri, 27 May 2022 04:06:14 -0400
X-MC-Unique: quDHT6L0NL646pHc2VDpBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD19480418C;
 Fri, 27 May 2022 08:06:13 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 822C72026D64;
 Fri, 27 May 2022 08:06:05 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 18/22] KVM: arm64: Allow large sized pseudo firmware
 registers
Date: Fri, 27 May 2022 16:02:49 +0800
Message-Id: <20220527080253.1562538-19-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

Currently, the sizes of all pseudo firmware registers are 64 bits.
The value from user space is copied to a local 64-bits variable,
which is passed on in kvm_arm_set_fw_reg(). It works perfectly
until large sized pseudo firmware registers are added for SDEI
event handlers, states and context.

This copies the user space's value to local 64-bits variable
and passes the local variable on, only if the pseudo firmware
register is 64-bits in size. No functional change intended.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/hypercalls.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index aaa5197ffe83..8e0df54d1422 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -406,14 +406,20 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
-static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
+static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu,
+				   const struct kvm_one_reg *reg)
 {
 	int ret = 0;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
 	unsigned long *fw_reg_bmap, fw_reg_features;
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
 
-	switch (reg_id) {
+	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg->id) {
 	case KVM_REG_ARM_STD_BMAP:
 		fw_reg_bmap = &smccc_feat->std_bmap;
 		fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
@@ -454,15 +460,14 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 	int wa_level;
 
-	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
 	switch (reg->id) {
 	case KVM_REG_ARM_PSCI_VERSION:
 	{
 		bool wants_02;
 
 		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
+		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+			return -EFAULT;
 
 		switch (val) {
 		case KVM_ARM_PSCI_0_1:
@@ -483,6 +488,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+			return -EFAULT;
+
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 
@@ -492,6 +500,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+			return -EFAULT;
+
 		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
 			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
 			return -EINVAL;
@@ -529,7 +540,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 	case KVM_REG_ARM_STD_HYP_BMAP:
 	case KVM_REG_ARM_VENDOR_HYP_BMAP:
-		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
+		return kvm_arm_set_fw_reg_bmap(vcpu, reg);
 	default:
 		return -ENOENT;
 	}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
