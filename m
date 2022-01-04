Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79481C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:49:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CBE749FE6;
	Tue,  4 Jan 2022 14:49:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1D2MPwGF1KZ0; Tue,  4 Jan 2022 14:49:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF39F4B0DD;
	Tue,  4 Jan 2022 14:49:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 297D34B0DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aWIHJya5qeBv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:44 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 590F749FE6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:43 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 d13-20020a63f24d000000b003424f1d4733so3627645pgk.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qpmBpYvIfh74VRk+g2dm6592JBegU/tRB3t7M+wG++0=;
 b=HafWKcODPc6bcRPfVgIR1qA+o4BzVA0IaOguqGx4tfhu1ipcTBki0Q+F9e350jK6DM
 +662xghUx4lgmlTJEU0l4vrVoubfB26LhbUipX33hJFZBTVgWJQcsTnpLcnrUcN5sOgG
 JsphNE9w6YRelz7MCyBe7t/DBOGx7ZMgh8tqE1WaL99XIrAsxxCB7xQf/xAEOSCddIRN
 AifypxImZVvhXvejdGqrHdfziLmc6sjr6mud0IuDFzQ+T2PYMxoZJ6Lpos3vV8P0bGDE
 fJujD2x5xr8CNhaHOAjdDzUMrLOkNJDdhueJopzwsh9N9Oj+5mI726IKnhi8leq4USPS
 kmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qpmBpYvIfh74VRk+g2dm6592JBegU/tRB3t7M+wG++0=;
 b=YLgCd3ORSrPG7D2ZD721RO8dTQqBtv3+n/FVzk2PDmQHeN6ddddZcv4rJLb/y7F5/F
 6qP7yEGspFW/c0Y+/B6r1ybO/Rbk19JmQbyfwiPwkX+dfGEMDIp3qAICZlf/gmJrnb6d
 HPUIZ6iUTbqlls2D6PwZX9nW8hdEVf28JaJkt8z5gL0lLAENd41eaL5Ma7NxCO3SA/Cd
 zMNb29n5Ji7hOIAVljEEewIRZ/vQLc/zYy3voUUET8w17nLoFt5JU676wTeaTYkUaWVD
 GZSMV8BtqGcBVLLGsYK7PZPFJgf+RWEQPVRujHbrynY+FH9M31pziyNaGLCrO9JM6y9T
 T+3A==
X-Gm-Message-State: AOAM533uyh1738e+g2F+FN/63p91CqLXrwp99c9hD4ZDTiqCCwI6lFVs
 vTgK36V51ph7ADNplUlTf5stFERlRIjZ
X-Google-Smtp-Source: ABdhPJz3xR6/5at0Y6VDoVuTCoFrJpI1sIDkjmMYQufw3QtAD5M1lgOAtItVB/5iysC+Go+ezul+hHZAqQ7E
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:b791:: with SMTP id
 m17mr5983481pjr.239.1641325782518; Tue, 04 Jan 2022 11:49:42 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:13 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-7-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 06/11] KVM: arm64: Add vendor hypervisor firmware
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
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 23 ++++++++++++++++++++++-
 include/kvm/arm_hypercalls.h      |  3 +++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1daf2c0b3b85..877096737ee1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -107,10 +107,12 @@ struct kvm_arch_memory_slot {
  *
  * @hvc_std_bmap: Bitmap of standard secure service calls
  * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
+ * @hvc_vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
  */
 struct kvm_hvc_desc {
 	u64 hvc_std_bmap;
 	u64 hvc_std_hyp_bmap;
+	u64 hvc_vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index af59c434ae33..7f076da55f30 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -289,6 +289,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
 
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_REG(5)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		BIT(0)
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 9df0221834a3..2403ad50d759 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -79,6 +79,9 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
 					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -87,6 +90,7 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -159,7 +163,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
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
+		val[0] |= hvc_desc->hvc_vendor_hyp_bmap << 1;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -188,6 +199,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 static const u64 kvm_arm_fw_reg_bmap_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -196,6 +208,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 
 	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
 	hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
+	hvc_desc->hvc_vendor_hyp_bmap = ARM_SMCCC_VENDOR_HYP_FEATURES;
 }
 
 int kvm_arm_num_fw_bmap_regs(void)
@@ -296,6 +309,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		kvm_arm_get_fw_reg_bmap(vcpu, hvc_desc->hvc_std_hyp_bmap, &val);
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		kvm_arm_get_fw_reg_bmap(vcpu, hvc_desc->hvc_vendor_hyp_bmap, &val);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -322,6 +338,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
 		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		fw_reg_bmap = &hvc_desc->hvc_vendor_hyp_bmap;
+		fw_reg_features = ARM_SMCCC_VENDOR_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -425,6 +445,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
 	case KVM_REG_ARM_STD_HYP_BMAP:
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 1a79b5f89a24..8f54cacfbf40 100644
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
