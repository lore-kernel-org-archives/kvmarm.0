Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A8CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B095E4BD6A;
	Thu, 24 Feb 2022 12:26:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H5xId1Lf3Rm0; Thu, 24 Feb 2022 12:26:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E444BE69;
	Thu, 24 Feb 2022 12:26:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FB0A4BE01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u9kJXBNxt4C7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:21 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F1F14BD65
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:21 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 d9-20020a630e09000000b00374105253b2so1444145pgl.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=f7YVBmCb6IbcPz2I9pSRMYsNCE3tvWzh5vUe6Npy1Ak=;
 b=GIp3dFeze4hYb6KlcHmjeEgFI+VrVtEnbRgjGd32qlKA2YNcGaWP5tT+SNeDb5id8S
 OdR8AlBGI5a6PQqilkbfUfvxWLDDf+IXhx8WG/NOwhGsskYyy/CHYj+Zno+qpTUQEIZ2
 KaW+a/lIWjQmpI6XnKUUswrx/dBC3jyJp2SbUuhnRxsWZYjCUrDzAr/OCUvz7RrfQQSp
 V847UnL1nDMpusfG3u00l5lwbJkA8sSm6L1nHUC1cnsF35YkXe/TyPAjoHlSTAEQPe8k
 6QTrumKamOpp/qNO1f2Gc08fFiPg0Rz7NRXpzm4NEsT6QCisj6F+6SFEBlavPRBdSjqT
 A+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=f7YVBmCb6IbcPz2I9pSRMYsNCE3tvWzh5vUe6Npy1Ak=;
 b=mh2Y7y7K9flQkoQRX/pm2yXjxn6mev2IJA+w9gGDqFynRgD5UnWYQr8C5wk50AsfE4
 CCY+izwp64ymG6KYPzyzwUWB/d/FOdJ0A1x6EFoNUc8cFQC/w9IzoWKUVznY2G68jmwr
 1ZWGPsWB2dSXngKIPpDmEJ+DbdNIRlaqBTb82nqqgqrgSCLQG59SqgHdQZAeLfrUuMLz
 XtnOC27dV3GXSItIKqhUJ4k6D1KpPPzvipCqw44pxdDzsbSwstIEhzbhyYkF90/u/W1g
 YhSZGLoQ9EImj5Pl+mp3NzbwbdFO6jMoSEcpiGocxHrCKfaRSSjqfBOuSYteii7VaHuW
 PavA==
X-Gm-Message-State: AOAM531lxp96tmb4vrneiAnYyybzq/HvR1AZKVubJ7ZtJU6c7OAAiI+V
 Uv5CZQNrTcG5qs1mX/dspf6LMMlg3vyz
X-Google-Smtp-Source: ABdhPJxSCGu3k55BbAvghObP6sR447q+n09jYrxk+9b6zOi1NDp47823WoeG/9N4MDL4UVSEZtw++WwQmJLQ
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1aca:b0:4e1:a2b6:5b9 with SMTP id
 f10-20020a056a001aca00b004e1a2b605b9mr3807079pfv.4.1645723580479; Thu, 24 Feb
 2022 09:26:20 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:52 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-7-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 06/13] KVM: arm64: Add standard hypervisor firmware register
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

The register is also added to the kvm_arm_vm_scope_fw_regs[] list
as it maintains its state per-VM.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/guest.c            |  1 +
 arch/arm64/kvm/hypercalls.c       | 20 +++++++++++++++++++-
 include/kvm/arm_hypercalls.h      |  3 +++
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1909ced3208f..318148b69279 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
  * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
  *
  * @hvc_std_bmap: Bitmap of standard secure service calls
+ * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
  */
 struct kvm_hvc_desc {
 	u64 hvc_std_bmap;
+	u64 hvc_std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2decc30d6b84..9a2caead7359 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -295,6 +295,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0       /* Last valid bit */
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_BMAP_REG(1)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d66e6c742bbe..c42426d6137e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -66,6 +66,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 /**
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 48c126c3da72..ebc0cc26cf2e 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -75,6 +75,10 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
 						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -83,6 +87,7 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -134,7 +139,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val[0] = SMCCC_RET_SUCCESS;
+			if (kvm_arm_fw_reg_feat_enabled(
+					hvc_desc->hvc_std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
+				val[0] = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
@@ -179,6 +187,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -186,6 +195,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
 
 	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
+	hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -272,6 +282,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 		val = READ_ONCE(hvc_desc->hvc_std_bmap);
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -294,6 +307,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &hvc_desc->hvc_std_bmap;
 		fw_reg_features = ARM_SMCCC_STD_FEATURES;
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
+		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -398,6 +415,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
+	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 64d30b452809..a1cb6e839c74 100644
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
