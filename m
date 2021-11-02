Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B962C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 00:22:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCAFE60F5A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 00:22:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BCAFE60F5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 526B94B24C;
	Mon,  1 Nov 2021 20:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ao8l941I6QFW; Mon,  1 Nov 2021 20:22:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A81B54B232;
	Mon,  1 Nov 2021 20:22:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCC94B225
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 20:22:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NDDh47VZB0VZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Nov 2021 20:22:36 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E68544B204
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 20:22:34 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 c207-20020a621cd8000000b0048060050cfeso4524676pfc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Nov 2021 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NALAGHmxgx7zuM8oyYfEDkoub9zJsPFlJRLUtFgIAck=;
 b=dXWtApxl5gms1qPPG0RVxQ4mq3haQMJYuvojtTHjOAjrTjsHziwnuK9plCsnKpWYVK
 JVagrS4mCfUPLaDZIRdLVhOFH8VtH6y43Q07MBDa3oO7wH+cBSQJLf2hurHjBafft4Fs
 nA13INkYsaF1gPiDnKfRzfJlxH3uvIGN3uiDbeLwJIiZ7hcoSlCXjIaRUb7HzDiZ0+Dd
 NMQVVssXCWPf9RQHmqZpgBjUdgo/N/plL6ZYSngz8s1tK3K5WTVrjKyo5U+W/x14b8cy
 vwpfRUGfET93FmfJstu/401TocpsqlfCk6GMwJWaukKUBQ/6vqHLfkW3yaNtzRL0P1Pk
 DlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NALAGHmxgx7zuM8oyYfEDkoub9zJsPFlJRLUtFgIAck=;
 b=zY8Hhgg63l3dpJZZDD9ZnLVPgFCkz8ebqKIQnKVcWK+d2vKxwry9uLxtr3LHEvF4x3
 x1/PcY34Sp4cdv3aJDlRq0+08CsweiXVVdYsFNas0D1QSMYfi+8RS++3VA10nJZnMbaT
 onNRN+bTXP7dijzNoCMPQVF/oqgu4gP/qHx1UePFlXkgJNPP6p/RcpRVqKHIQHYbfq+U
 EgKHfdS8uYVYO/YV2dZK3lRkaBNNlSzp8DrAtxSifVYnPFndeP/msTlEuN++i434WY3I
 AbH6tJfv1Tlu9w0ZjEKXaJMTNFUAE/q7msq+NLDvz6NLM2EB9kc3Ufzfp1Jl5E2wwL33
 7WRA==
X-Gm-Message-State: AOAM53014StaAQF+L+OYgaCChkVRuJSlRXKFHUb7OFpxL91rR9fwJmDD
 CDDG826++Om1a79tLRGaBcdpGYdBMs80
X-Google-Smtp-Source: ABdhPJwMfnQu9lzOq3lchz+AtyDKvVv2NetvtywLAd6UERBeOKB19I65Sh2KO1yOdv3p5euteXTMrxI6QPUZ
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:13aa:b0:481:22b8:ba7a with SMTP
 id t42-20020a056a0013aa00b0048122b8ba7amr1347930pfg.28.1635812554109; Mon, 01
 Nov 2021 17:22:34 -0700 (PDT)
Date: Tue,  2 Nov 2021 00:22:00 +0000
In-Reply-To: <20211102002203.1046069-1-rananta@google.com>
Message-Id: <20211102002203.1046069-6-rananta@google.com>
Mime-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH 5/8] KVM: arm64: Add vendor hypervisor service calls
 firmware register
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Introduce the firmware register to hold the vendor specific
hypervisor service calls (owner value 6) as a bitmap. The
bitmap represents the features that'll be enabled for the
guest, as configured by the user-space. Currently, this
includes support only for Precision Time Protocol (PTP),
represented by bit-0.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/arm/hypercalls.rst | 23 +++++++++++-----
 arch/arm64/include/asm/kvm_host.h         |  1 +
 arch/arm64/include/uapi/asm/kvm.h         |  6 +++++
 arch/arm64/kvm/arm.c                      |  1 +
 arch/arm64/kvm/hypercalls.c               | 33 ++++++++++++++++++++++-
 include/kvm/arm_hypercalls.h              |  3 +++
 6 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index 2cb82c694868..61d95f4f1ddf 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -20,13 +20,14 @@ pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
 interface. These registers can be saved/restored by userspace, and set
 to a convenient value if required.
 
-The firmware registers, KVM_REG_ARM_STD and KVM_REG_ARM_STD_HYP exposes
-the hypercall services in the form of a feature bitmap. Upon VM creation,
-by default, KVM exposes all the features to the guest, which can be learnt
-using GET_ONE_REG interface. Conversely, the features can be enabled or
-disabled via the SET_ONE_REG interface. These registers allow the user-space
-modification only until the VM has started running, after which they turn to
-read-only registers. SET_ONE_REG in this scenario will return -EBUSY.
+The firmware registers, KVM_REG_ARM_STD, KVM_REG_ARM_STD_HYP and
+KVM_REG_ARM_VENDOR_HYP exposes the hypercall services in the form of a
+feature bitmap. Upon VM creation, by default, KVM exposes all the features
+to the guest, which can be learnt using GET_ONE_REG interface. Conversely,
+the features can be enabled or disabled via the SET_ONE_REG interface.
+These registers allow the user-space modification only until the VM has
+started running, after which they turn to read-only registers.
+SET_ONE_REG in this scenario will return -EBUSY.
 
 The following register is defined:
 
@@ -100,4 +101,12 @@ The following register is defined:
         The bit represents the Paravirtualized Time service (also known as stolen time) as
         represented by ARM DEN0057A.
 
+* KVM_REG_ARM_VENDOR_HYP
+    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
+
+    The following bits are accepted:
+
+      KVM_REG_ARM_STD_HYP_PTP:
+        The bit represents the Precision Time Protocol KVM service.
+
 .. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cee4f4b8a756..27861b3bd25f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -108,6 +108,7 @@ struct hvc_reg_desc {
 
 	u64 kvm_std_bmap;
 	u64 kvm_std_hyp_bmap;
+	u64 kvm_vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 46701da1a27d..a1d0e8e69eed 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -293,6 +293,12 @@ enum kvm_reg_arm_std_hyp_bmap {
 	KVM_REG_ARM_STD_HYP_BMAP_MAX,
 };
 
+#define KVM_REG_ARM_VENDOR_HYP		KVM_REG_ARM_FW_REG(5)
+enum kvm_reg_arm_vendor_hyp_bmap {
+	KVM_REG_ARM_VENDOR_HYP_PTP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP_MAX,
+};
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1c69d2a71b86..5c89db8336eb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -136,6 +136,7 @@ static void set_default_hypercalls(struct kvm *kvm)
 
 	hvc_desc->kvm_std_bmap = ARM_SMCCC_STD_FEATURES;
 	hvc_desc->kvm_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
+	hvc_desc->kvm_vendor_hyp_bmap = ARM_SMCCC_VENDOR_HYP_FEATURES;
 }
 
 /**
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 46064c515058..74ebe5355dc0 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -67,6 +67,8 @@ static u64 *kvm_fw_reg_to_bmap(struct kvm *kvm, u64 fw_reg)
 		return &hvc_desc->kvm_std_bmap;
 	case KVM_REG_ARM_STD_HYP:
 		return &hvc_desc->kvm_std_hyp_bmap;
+	case KVM_REG_ARM_VENDOR_HYP:
+		return &hvc_desc->kvm_vendor_hyp_bmap;
 	default:
 		return NULL;
 	}
@@ -93,6 +95,10 @@ static const struct kvm_hvc_func_map hvc_std_hyp_map[] = {
 	HVC_FUNC_MAP_DESC(ARM_SMCCC_HV_PV_TIME_ST, KVM_REG_ARM_STD_HYP_PV_TIME_ST),
 };
 
+static const struct kvm_hvc_func_map hvc_vendor_hyp_map[] = {
+	HVC_FUNC_MAP_DESC(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, KVM_REG_ARM_VENDOR_HYP_PTP),
+};
+
 bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -113,6 +119,11 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 		hvc_func_map = hvc_std_hyp_map;
 		map_sz = ARRAY_SIZE(hvc_std_hyp_map);
 		break;
+	case ARM_SMCCC_OWNER_VENDOR_HYP:
+		fw_reg = KVM_REG_ARM_VENDOR_HYP;
+		hvc_func_map = hvc_vendor_hyp_map;
+		map_sz = ARRAY_SIZE(hvc_vendor_hyp_map);
+		break;
 	default:
 		/* Allow all the owners that aren't mapped */
 		return true;
@@ -133,6 +144,7 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -204,7 +216,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
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
+		val[0] |= (hvc_desc->kvm_vendor_hyp_bmap << 1);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -230,6 +249,7 @@ static const u64 fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_STD,
 	KVM_REG_ARM_STD_HYP,
+	KVM_REG_ARM_VENDOR_HYP,
 };
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -310,6 +330,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP:
 		val = hvc_desc->kvm_std_hyp_bmap;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP:
+		val = hvc_desc->kvm_vendor_hyp_bmap;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -446,6 +469,14 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		hvc_desc->kvm_std_hyp_bmap = val;
 		return 0;
+
+	case KVM_REG_ARM_VENDOR_HYP:
+		if (val & ~ARM_SMCCC_VENDOR_HYP_FEATURES)
+			return -EINVAL;
+
+		hvc_desc->kvm_vendor_hyp_bmap = val;
+		return 0;
+
 	default:
 		return -ENOENT;
 	}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index bbb3b12b10e3..d8c17d161ee5 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -12,6 +12,9 @@
 #define ARM_SMCCC_STD_HYP_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_MAX - 1, 0)
 
+#define ARM_SMCCC_VENDOR_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_MAX - 1, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
