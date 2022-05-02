Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037D1C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 23:39:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 685544B1D3;
	Mon,  2 May 2022 19:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CmB1VCix829b; Mon,  2 May 2022 19:39:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CFC4B152;
	Mon,  2 May 2022 19:39:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 636364B1C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qguaS88VBW9c for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 19:39:06 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC33E4B26E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:05 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 s2-20020a17090302c200b00158ea215fa2so7208613plk.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 16:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vCT/mW6tmMqNECNexsaejuEkL5/lGF6Ji7YYb+efIJc=;
 b=D8Qv8CrEKL7ZZJQl2WuZVKn3sCmfdpKTNUMPgq1yqfWDaAQGnZTO5mBwed9MGIDGD4
 YI4lbC8LrGtIG6KqvO4w4m9LsAOpCXKsp0re2Jsxr9I5OIpmH+mjX9hRREj3V26zjAan
 MCzV5AmwUMlfnTGHIB+uGWgj03HgUaHisCZzj9hWTEuqLna+5IKbgeLDs3gpaF8HOgI+
 JHz/0wIe3Z0IhUCZnjNtezQTZRnTfBhX+2Ihyz6RxdxgEVyfssG47bnlAE62QEzsADKX
 9EE9DaInpTYezD0sS6tBmWJ+K0MIwOsPndiLeGs5+G1/9XuXzNpF/Cpylmq0Dyaq7JhH
 NnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vCT/mW6tmMqNECNexsaejuEkL5/lGF6Ji7YYb+efIJc=;
 b=O6psPQy3AOEIeD/esI8J8K3KdAlIqCfWCh40WGba73WNWj/Ys+Q4SmALcuYE7KOp2i
 591PXMCaveMIv1ZCIeS7VAfGJA9HTQ3FtcwVEB89Z6JCBKu/9gl8fdmZtBfnwPNXu8j0
 QlOazpEX2oB//pyuXMEHK4MB8gUPB6jdeHgMyf9LO+MRCnLeCG6EmyhSnDrreNmDHEXH
 bE44/Fs1kCCE+JRaHJG1Ajnz6bnP7nh2cH6uxuBFoXVcrNsLX5G2nT+bxkf1Eg97sOio
 NuKPL0QIBxgB2FLxAh/h7i1YQMiZCr3VkSGXmW27QEFJZDpuPdScFuORRPN6IunA3g7b
 G1Rg==
X-Gm-Message-State: AOAM532Cbtiep6XAIDdd46wwGD/PanAUKWUkCbVZoyagimrH4FHeG1Rw
 8HJvrhD9h7kYwyGkhQzRcturt5NocJi8
X-Google-Smtp-Source: ABdhPJzb8kwApWrNlqYhIjgtfeQtDRhDA6oB1Hw90FbM0L5E/ksrz7umT7RyvmjK2FYPtLmlM3VgUh49JZp+
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:903:94:b0:15c:f928:a373 with SMTP id
 o20-20020a170903009400b0015cf928a373mr13992600pld.26.1651534745043; Mon, 02
 May 2022 16:39:05 -0700 (PDT)
Date: Mon,  2 May 2022 23:38:48 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-5-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 4/9] KVM: arm64: Add vendor hypervisor firmware register
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
includes support for KVM-vendor features along with
reading the UID, represented by bit-0, and Precision Time
Protocol (PTP), represented by bit-1.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 23 ++++++++++++++++++-----
 include/kvm/arm_hypercalls.h      |  2 ++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 281dfcfd0a4e..35a60d766fba 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
  *
  * @std_bmap: Bitmap of standard secure service calls
  * @std_hyp_bmap: Bitmap of standard hypervisor service calls
+ * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
  */
 struct kvm_smccc_features {
 	unsigned long std_bmap;
 	unsigned long std_hyp_bmap;
+	unsigned long vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9eecc7ee8c14..e7d5ae222684 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
 #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		0
 
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	0
+#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		1
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 38440e0bd4b4..c4f2abd49e69 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -72,9 +72,6 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
 	 */
 	case ARM_SMCCC_VERSION_FUNC_ID:
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
-	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
-	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
-	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		return true;
 	default:
 		return kvm_psci_func_id_is_valid(func_id);
@@ -97,6 +94,13 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
 					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
 	default:
 		return kvm_hvc_call_default_allowed(func_id);
 	}
@@ -189,8 +193,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
-		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
-		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		val[0] = smccc_feat->vendor_hyp_bmap;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -217,6 +220,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -225,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -317,6 +322,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		val = READ_ONCE(smccc_feat->std_hyp_bmap);
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -343,6 +351,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &smccc_feat->std_hyp_bmap;
 		fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
+		fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -457,6 +469,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
 	case KVM_REG_ARM_STD_HYP_BMAP:
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 00f9f1b1dc16..7d4d953680f7 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -9,9 +9,11 @@
 /* Last valid bit of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
 
 #define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
 #define KVM_ARM_SMCCC_STD_HYP_FEATURES		GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
+#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES	GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
