Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AFFC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A86C60F55
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0A86C60F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7914B306;
	Fri, 12 Nov 2021 20:23:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Ap-qOWgMyyW; Fri, 12 Nov 2021 20:23:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D13444B302;
	Fri, 12 Nov 2021 20:22:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B204B2F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q2vV0CfinQe6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:22:57 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4815B4B31E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:57 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 c140-20020a624e92000000b0044d3de98438so6559591pfb.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VI4xUZX2SgaAUorlezds0frm9PtlAxFmUgo0ykk1Vjg=;
 b=scMwAu8uHMha4/BUOYBN/DHwd5kD3H4etP4vODOnebCHMA5+ZMA6XA+9WcxolUgdlA
 IkEEIKMtuSTcrV3AYHRHnSDc2WcM9fgefTudv5cKtUUbV8uM+vXW4BebOqMzPNm2bk5n
 1+Vzc5z+PGUzjyUPowlblOoOucYN25e/FMjNFU1M2x2NJ+Fzmg2z1O18lKq7B0fl44BU
 TTE3twuBRh3rrmNb4KjlyuzgT+l8jbGHkSsMgeFNAM3UvIkAaukhITdb7IXe5VZwRt0X
 By2MwSmIrgjScbvutz1/X08WcUy+yFlER9yr/Evb6Md//Nc8ZM021XHHRfypv+vq8SYF
 GXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VI4xUZX2SgaAUorlezds0frm9PtlAxFmUgo0ykk1Vjg=;
 b=FXHjpd1DC4xffglrbRin8sWxlmATRQ6d3M7jed0FDFj3dYXAlN3KL8IHukWpaF2cVs
 HHxqUQBu0CYSHx4+hFfcwOPNjNef0kq0AfmNidUfMCmd236QceFcsea+sC7qgYQuLbbw
 r7PrBKaGnKN9uHMCPW5dTkQ22+aJ0cUJfnsAa+mvOVsnTMyXBVVhPvxqKkaJhT4gtHIn
 9rZUMHjlNtJzXL81jvA/3QlMFvOLkSeMpy3IRZmJeoNSbqU1mN77qwzehYt7ArRroyxK
 urNBOzVqUs/GtN/4N/W7wSNz0hfeObozF4mZt1lgY2ZIMdiMBKLmc3vyLUDnSNghCeJ5
 xRSA==
X-Gm-Message-State: AOAM531DDr4uA23HXfmZ7di2TW+YfC6/8TkJt8G2czI//qziuqhNX9vF
 Scn2CoNBEujR71uaVB411y3/DiPSH2f5
X-Google-Smtp-Source: ABdhPJwqzrBvcTPCYoT1Tldzfbztz8BwdLZEi5012/xMNTVOkaH29q73tnA2xy0RwfBuUM0JzfMABilP0mzT
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:1b06:: with SMTP id
 nu6mr23110635pjb.155.1636766576513; Fri, 12 Nov 2021 17:22:56 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:28 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-6-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 05/11] KVM: arm64: Add standard hypervisor firmware
 register
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Introduce the firmware register to hold the standard hypervisor
service calls (owner value 5) as a bitmap. The bitmap represents
the features that'll be enabled for the guest, as configured by
the user-space. Currently, this includes support only for
Paravirtualized time, represented by bit-0.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/pvtime.c           |  3 +++
 include/kvm/arm_hypercalls.h      |  3 +++
 5 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1546a2f973ef..e8e540bd1fe5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -113,6 +113,7 @@ struct hvc_reg_desc {
 	bool fw_reg_bmap_enabled;
 
 	struct hvc_fw_reg_bmap hvc_std_bmap;
+	struct hvc_fw_reg_bmap hvc_std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d6e099ed14ef..5890cbcd6385 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -285,6 +285,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0	/* Last valid bit */
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_REG(4)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME	BIT(0)
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0	/* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index f5df7bc61146..b3320adc068c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -84,6 +84,10 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_bmap,
 					KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -109,6 +113,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
 		feature = smccc_get_arg1(vcpu);
+		if (!kvm_hvc_call_supported(vcpu, feature))
+			break;
+
 		switch (feature) {
 		case ARM_SMCCC_ARCH_WORKAROUND_1:
 			switch (arm64_get_spectre_v2_state()) {
@@ -194,6 +201,7 @@ static const u64 fw_reg_ids[] = {
 
 static const u64 fw_reg_bmap_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 static void kvm_arm_fw_reg_init_hvc(struct hvc_reg_desc *hvc_desc,
@@ -212,6 +220,8 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 
 	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_bmap,
 				KVM_REG_ARM_STD_BMAP, ARM_SMCCC_STD_FEATURES);
+	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_hyp_bmap,
+			KVM_REG_ARM_STD_HYP_BMAP, ARM_SMCCC_STD_HYP_FEATURES);
 }
 
 static void kvm_arm_fw_reg_sanitize(struct hvc_fw_reg_bmap *fw_reg_bmap)
@@ -259,6 +269,7 @@ void kvm_arm_sanitize_fw_regs(struct kvm *kvm)
 		goto out;
 
 	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_bmap);
+	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_hyp_bmap);
 
 out:
 	spin_unlock(&hvc_desc->lock);
@@ -310,6 +321,9 @@ static int kvm_arm_fw_reg_set_bmap(struct kvm *kvm,
 	case KVM_REG_ARM_STD_BMAP:
 		fw_reg_features = ARM_SMCCC_STD_FEATURES;
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
@@ -432,6 +446,13 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (ret)
 			return ret;
 
+		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		ret = kvm_arm_fw_reg_get_bmap(kvm,
+					&hvc_desc->hvc_std_hyp_bmap, &val);
+		if (ret)
+			return ret;
+
 		break;
 	default:
 		return -ENOENT;
@@ -523,6 +544,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
 		return kvm_arm_fw_reg_set_bmap(kvm, &hvc_desc->hvc_std_bmap, val);
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		return kvm_arm_fw_reg_set_bmap(kvm,
+					&hvc_desc->hvc_std_hyp_bmap, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 78a09f7a6637..4fa436dbd0b7 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -37,6 +37,9 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	u32 feature = smccc_get_arg1(vcpu);
 	long val = SMCCC_RET_NOT_SUPPORTED;
 
+	if (!kvm_hvc_call_supported(vcpu, feature))
+		return val;
+
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 	case ARM_SMCCC_HV_PV_TIME_ST:
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 8c6300d1cbaf..77c30e335f44 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -9,6 +9,9 @@
 #define ARM_SMCCC_STD_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
 
+#define ARM_SMCCC_STD_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
