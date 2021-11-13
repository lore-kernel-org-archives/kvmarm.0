Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02452C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A895760724
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A895760724
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 592444B345;
	Fri, 12 Nov 2021 20:23:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xMeSkQbGlr1M; Fri, 12 Nov 2021 20:23:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B124B33D;
	Fri, 12 Nov 2021 20:23:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D044B2F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:23:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FMQTk3Z7ab-T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:22:59 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72C2A4B2F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:59 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 e4-20020a630f04000000b002cc40fe16afso5618783pgl.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Qw/clVNLM0HNZHqaD4lCmZow7BlWKfkgGErSltFYrjA=;
 b=XK/XfQZyOCv34OdPg13Gv7n46oxO77mh2e+k5qYG7JBdYFUE3ZvOs67O2HdEVwt7ay
 TDSCi5NN6WlIsUglBQmwVa0xCSQlrTU6V3LC0YtIxzPRDuj9aWXUvgUVV1paxUHYJjML
 dW9nV9gC0MUKl4mpGfYmdvaDaqnGYQaq0plREFfPfPNxgDWzkl+k1fGvZZEXZGbjmI+J
 jj9+pXb4NF9LeCdRyZkgfzX1CW9YWXRXGBHMC7YSLjshKl3o+KRs9DqUeOJO9yrdTV4F
 Q1ZAOxg5FqizoSGbzsMn3fbcyKLdWhKvIidT8om4gB+hh0c/DW3FX69+c23czcDm0V5J
 UNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Qw/clVNLM0HNZHqaD4lCmZow7BlWKfkgGErSltFYrjA=;
 b=qTqEIZkQ8xyO89UNZv4ICiNdUQZHzko9caLs2qzRa71Ra9Uyvzwms/z+MHYDBlxrn+
 6zMon1wWpLpsU2foTMmE1QK+W8Ppw2eBTSGMdguEEH0sJ9bBqaeoJuK+C5f74jVgIcLe
 7P47PZltGUsRDsgaliMMoRWJ/DVUIRxiaa6bSV18xju2Ek4Sc3RAoG1fhFo1iVKmDjoz
 kigND5BASUnDRbt6aTTyauq5I23qH+Lmjmg06w3w9NyJa+f/1y8tuvRC4ycsM8oicEr+
 YhPVZcFqA9oslIHitbqnisAj94bzObHaKXe73gn0jnI4aGdbfDxOiDane7d59XsSRM6L
 rorQ==
X-Gm-Message-State: AOAM530yw7SpA0eUksbFjnnzc9UP5h8Yhv10x7cbG/u8FSAHohQEW0xA
 B3v5zOwJprWDdbeifl0gQTWAZmSRjTHF
X-Google-Smtp-Source: ABdhPJy57fAHa9LRUb/E2nHa4PDT9a3BCQlcAHcEgns3RhXXXKmRA4HhXAK0WxiN2T67Dr6WLbiAMYiHpry3
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9dcd:0:b0:494:658c:3943 with SMTP id
 g13-20020aa79dcd000000b00494658c3943mr17575007pfq.19.1636766578705; Fri, 12
 Nov 2021 17:22:58 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:29 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-7-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 06/11] KVM: arm64: Add vendor hypervisor firmware
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

Introduce the firmware register to hold the vendor specific
hypervisor service calls (owner value 6) as a bitmap. The
bitmap represents the features that'll be enabled for the
guest, as configured by the user-space. Currently, this
includes support only for Precision Time Protocol (PTP),
represented by bit-0.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 30 +++++++++++++++++++++++++++++-
 include/kvm/arm_hypercalls.h      |  3 +++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e8e540bd1fe5..ef1d10bdf562 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -114,6 +114,7 @@ struct hvc_reg_desc {
 
 	struct hvc_fw_reg_bmap hvc_std_bmap;
 	struct hvc_fw_reg_bmap hvc_std_hyp_bmap;
+	struct hvc_fw_reg_bmap hvc_vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5890cbcd6385..8468e5d265df 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -289,6 +289,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME	BIT(0)
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0	/* Last valid bit */
 
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_REG(5)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		BIT(0)
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	0	/* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b3320adc068c..e1361029101e 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -88,6 +88,9 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_hyp_bmap,
 					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -99,6 +102,7 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -173,7 +177,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
-		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+
+		/*
+		 * The feature bits exposed to user-space doesn't include
+		 * ARM_SMCCC_KVM_FUNC_FEATURES. However, we expose this to
+		 * the guest as bit-0. Hence, left-shift the user-space
+		 * exposed bitmap by 1 to accommodate this.
+		 */
+		val[0] |= hvc_desc->hvc_vendor_hyp_bmap.bmap << 1;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -202,6 +213,7 @@ static const u64 fw_reg_ids[] = {
 static const u64 fw_reg_bmap_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP,
 };
 
 static void kvm_arm_fw_reg_init_hvc(struct hvc_reg_desc *hvc_desc,
@@ -222,6 +234,8 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 				KVM_REG_ARM_STD_BMAP, ARM_SMCCC_STD_FEATURES);
 	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_hyp_bmap,
 			KVM_REG_ARM_STD_HYP_BMAP, ARM_SMCCC_STD_HYP_FEATURES);
+	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_vendor_hyp_bmap,
+		KVM_REG_ARM_VENDOR_HYP_BMAP, ARM_SMCCC_VENDOR_HYP_FEATURES);
 }
 
 static void kvm_arm_fw_reg_sanitize(struct hvc_fw_reg_bmap *fw_reg_bmap)
@@ -270,6 +284,7 @@ void kvm_arm_sanitize_fw_regs(struct kvm *kvm)
 
 	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_bmap);
 	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_hyp_bmap);
+	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_vendor_hyp_bmap);
 
 out:
 	spin_unlock(&hvc_desc->lock);
@@ -324,6 +339,9 @@ static int kvm_arm_fw_reg_set_bmap(struct kvm *kvm,
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		fw_reg_features = ARM_SMCCC_VENDOR_HYP_FEATURES;
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
@@ -453,6 +471,13 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (ret)
 			return ret;
 
+		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		ret = kvm_arm_fw_reg_get_bmap(kvm,
+					&hvc_desc->hvc_vendor_hyp_bmap, &val);
+		if (ret)
+			return ret;
+
 		break;
 	default:
 		return -ENOENT;
@@ -547,6 +572,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_fw_reg_set_bmap(kvm,
 					&hvc_desc->hvc_std_hyp_bmap, val);
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		return kvm_arm_fw_reg_set_bmap(kvm,
+					&hvc_desc->hvc_vendor_hyp_bmap, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 77c30e335f44..94f56562fea8 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -12,6 +12,9 @@
 #define ARM_SMCCC_STD_HYP_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
 
+#define ARM_SMCCC_VENDOR_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
