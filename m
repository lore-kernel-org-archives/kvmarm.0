Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17FEC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 01:16:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EF0A4B1AF;
	Wed,  6 Apr 2022 21:16:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oZQUU89qNEcX; Wed,  6 Apr 2022 21:16:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E21E4B16F;
	Wed,  6 Apr 2022 21:16:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E330049F4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1f-Lyh4FaBEw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 21:16:18 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92E544B1F0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 21:16:18 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 q7-20020a17090a7a8700b001ca823ceb16so2197100pjf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 18:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nVjr47POGBC3EXh5NnqgjDaWypqAXR5XHk3JbhNyB5Q=;
 b=UEHOviag/BPM19H+OoV8/7haDhyLRHPmFT6c36z/LhTHTL9XgN7R6UoUHz00VXYzWK
 q0WFP3B4ycjNKRSSpdSG6gAkiiN61agfFYlh5CUuCAhWINLpY2ILHm3mI+ybDfQH49yd
 Pfitp3CWvCIFGSBal/d9c6GKiXGrJGSxKU0fiMSzMlAGZ0POtU5cIZR8mUOacnFGy5dq
 hIWa/NfNhNYdGSAN77qgHlWn6IKNolWI8LKU/fB+3KvuU9rK5TN2oqjR3R0icroTkrnh
 sp6xwTtw0jmeGayySb0faJwkub8h1KOvf6mkLlxbp7aUiDHREJO46cEumeJT9wrOO+Z5
 x6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nVjr47POGBC3EXh5NnqgjDaWypqAXR5XHk3JbhNyB5Q=;
 b=skHovFSghMZFjUd9xFYJ4b+TawRv/ypWF0vs8zWeawIkstQoohOGkr06vNYzMmothT
 l5XQUQvNocm6wGfkp5XgcSWJyN8oHHcLEoGqUFxyq3n+yJAe0NLUCjS0TT2sH5neTAOU
 moRsnFQDawcliBrzszq2qx840od2qEyPTWbKXyn0ZEElWcWvZrZyJ/NKcFW3Lq9+aYjK
 I27MvrvOc1kKcAls/K7ps0W81xl4qaXiJkyAFDE5eAPF4t/akfV4Ko65q8922Y5wXG9D
 Dwq+FhC396dBLI4ULqUcfnyNAFXbCSMvBbgpsRvcdR7MFxO4n2+ndADIp640sPxku0AE
 m6KA==
X-Gm-Message-State: AOAM530RGTdTZbKbV/kqfYXQec+AoD2uHhrOWwXaLUaSrZb9C5BDFzfC
 4Q1mtdYoEHzRXD5M/PkuoYL3+mBd1tKV
X-Google-Smtp-Source: ABdhPJwc+GoBjiuo/AxxjHJhbzj+oGH5DanT5ZUY9CMxN11S7Op0CsHjzsHMm0TNj0CkPK8p+4CTjr7SCvXQ
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:cecb:b0:154:6f46:a5d6 with SMTP id
 d11-20020a170902cecb00b001546f46a5d6mr11461482plg.92.1649294177690; Wed, 06
 Apr 2022 18:16:17 -0700 (PDT)
Date: Thu,  7 Apr 2022 01:15:58 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-4-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 03/10] KVM: arm64: Add standard hypervisor firmware register
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
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  3 +++
 arch/arm64/kvm/hypercalls.c       | 21 ++++++++++++++++++---
 include/kvm/arm_hypercalls.h      |  4 ++++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6e663383d7b4..20165242ebd9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
  * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
  *
  * @std_bmap: Bitmap of standard secure service calls
+ * @std_hyp_bmap: Bitmap of standard hypervisor service calls
  */
 struct kvm_smccc_features {
 	u64 std_bmap;
+	u64 std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 56e4bc58a355..67353bf4e69d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -341,6 +341,9 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index cf04b5ee5f56..64ae6c7e7145 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -65,8 +65,6 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 static const u32 hvc_func_default_allowed_list[] = {
 	ARM_SMCCC_VERSION_FUNC_ID,
 	ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-	ARM_SMCCC_HV_PV_TIME_FEATURES,
-	ARM_SMCCC_HV_PV_TIME_ST,
 	ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
 	ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
 	ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
@@ -100,6 +98,10 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_bmap,
 						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		return kvm_hvc_call_default_allowed(vcpu, func_id);
 	}
@@ -107,6 +109,7 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -170,7 +173,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val[0] = SMCCC_RET_SUCCESS;
+			if (kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
+				val[0] = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
@@ -216,6 +221,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -223,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
 
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
+	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -312,6 +319,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 		val = READ_ONCE(smccc_feat->std_bmap);
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		val = READ_ONCE(smccc_feat->std_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -334,6 +344,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &smccc_feat->std_bmap;
 		fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		fw_reg_bmap = &smccc_feat->std_hyp_bmap;
+		fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -438,6 +452,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
+	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index fd3ff350ee9d..b0915d8c5b81 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -8,10 +8,14 @@
 
 /* Last valid bits of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
 
 #define KVM_ARM_SMCCC_STD_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
 
+#define KVM_ARM_SMCCC_STD_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
