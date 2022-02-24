Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9B9C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C33254BD65;
	Thu, 24 Feb 2022 12:26:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LbJe3LW98jol; Thu, 24 Feb 2022 12:26:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3367F4BD88;
	Thu, 24 Feb 2022 12:26:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8520A4BD83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id inlch2lkGMgQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:18 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C85A4BD6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:18 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 r19-20020a170902be1300b0014edf03f82eso1416625pls.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BqUDVmORg3gJxeFJEfV8OScHbsxicE1Om/mYva4eJ3Y=;
 b=rAfqBnG3atJh2mL+uCW1tdA53b0IXTJ+VPS0KnWtbPZKPMPiwhoJtHfbmUC9cOP1CC
 Esdq4Vmtc0h627Wgs59KBX61NZ9rBrXkscv12jFkr/QWgGbVE19EuCdIpTWqs9Te9sKk
 hOH/GH7Z7xmkrIn3l2Bzpm8IXvAwf0ynzy56RDS0bBXG8cb+pIIT/A7h3qomxnXnFs2i
 rZgbME2ajd4E/OpooJHgKVtO704imaNfyZjNkSuUauyJL5/SE00lbar9bmXl6/SWh0+O
 tK4HXz3BM6sbDWY1fLQYGF5AUBRunJQHTIUQvGY0lZVxoqwBNTgTMw1sqENo16OnJQVo
 fuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BqUDVmORg3gJxeFJEfV8OScHbsxicE1Om/mYva4eJ3Y=;
 b=wl4Hm/U1VefCXUzfzyKV7k/weCjRJnYZf0YBl2fgoXN//kLRZO+WBsH8XOBpv0UKZv
 jxdtUkEzo+SYg0I0RVqZ7pcTxjFoUA60vLzkOI810D4LBwKezrh39BwhUX0QqTHuca1w
 vVlhcClIx+jxyZid32w0qCbmrjJm4/O+w2VLml46r8J+LSb9Ebq8PQbEWjTgXCDk8ufj
 6d4hQoDBrxo29CxOPEyglSnVDWDKMYZZX8UoeE7+Pahy9Z7dr7HwK+XrBcnmRR9nNF6O
 tOlSRuWnP+NUqMUaIhSj2RPz4LDPnyKtp5FzxObJ4sNV/jbh7JjL1VFNOG+wt0ku4JqK
 fK8g==
X-Gm-Message-State: AOAM533annu8sP8oIAwWWwewoE2XNGTT0srTI7lfyY87T3xxEcdL1N5K
 sXT3oGAWcpHMW4sl41Ji87MxfuM1CqKy
X-Google-Smtp-Source: ABdhPJw9sweD4GH/b1vbNTaysA645aiUNR6TCvzUOD00db8b0cDcuo3978PjhEE0J8cJAOIpo3t5U7+LD2pI
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9017:0:b0:4df:e33f:f1b4 with SMTP id
 m23-20020aa79017000000b004dfe33ff1b4mr3967296pfo.80.1645723577709; Thu, 24
 Feb 2022 09:26:17 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:51 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-6-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 05/13] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
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

KVM regularly introduces new hypercall services to the guests without
any consent from the userspace. This means, the guests can observe
hypercall services in and out as they migrate across various host
kernel versions. This could be a major problem if the guest
discovered a hypercall, started using it, and after getting migrated
to an older kernel realizes that it's no longer available. Depending
on how the guest handles the change, there's a potential chance that
the guest would just panic.

As a result, there's a need for the userspace to elect the services
that it wishes the guest to discover. It can elect these services
based on the kernels spread across its (migration) fleet. To remedy
this, extend the existing firmware psuedo-registers, such as
KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.

These firmware registers are categorized based on the service call
owners, and unlike the existing firmware psuedo-registers, they hold
the features supported in the form of a bitmap.

During the VM initialization, the registers holds an upper-limit of
the features supported by the corresponding registers. It's expected
that the VMMs discover the features provided by each register via
GET_ONE_REG, and writeback the desired values using SET_ONE_REG.
KVM allows this modification only until the VM has started.

Older userspace code can simply ignore the capability and the
hypercall services will be exposed unconditionally to the guests, thus
ensuring backward compatibility.

In this patch, the framework adds the register only for ARM's standard
secure services (owner value 4). Currently, this includes support only
for ARM True Random Number Generator (TRNG) service, with bit-0 of the
register representing mandatory features of v1.0. The register is also
added to the kvm_arm_vm_scope_fw_regs[] list as it maintains its state
per-VM. Other services are momentarily added in the upcoming patches.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++
 arch/arm64/include/uapi/asm/kvm.h |  8 ++++
 arch/arm64/kvm/arm.c              |  8 ++++
 arch/arm64/kvm/guest.c            |  1 +
 arch/arm64/kvm/hypercalls.c       | 78 +++++++++++++++++++++++++++++++
 include/kvm/arm_hypercalls.h      |  4 ++
 6 files changed, 111 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e823571e50cc..1909ced3208f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -101,6 +101,15 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+/**
+ * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
+ *
+ * @hvc_std_bmap: Bitmap of standard secure service calls
+ */
+struct kvm_hvc_desc {
+	u64 hvc_std_bmap;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -142,6 +151,9 @@ struct kvm_arch {
 
 	/* Capture first run of the VM */
 	bool has_run_once;
+
+	/* Hypercall firmware register' descriptor */
+	struct kvm_hvc_desc hvc_desc;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c35447cc0e0c..2decc30d6b84 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -287,6 +287,14 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
+/* Bitmap firmware registers, extension to the existing psuedo-register space */
+#define KVM_REG_ARM_FW_BMAP			KVM_REG_ARM_FW_REG(0xff00)
+#define KVM_REG_ARM_FW_BMAP_REG(r)		(KVM_REG_ARM_FW_BMAP | (r))
+
+#define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_BMAP_REG(0)
+#define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
+#define KVM_REG_ARM_STD_BMAP_BIT_MAX		0       /* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f61cd8d57eae..e9f9edb1cf55 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	kvm_arm_init_hypercalls(kvm);
 
 	return ret;
 out_free_stage2_pgd:
@@ -635,7 +636,14 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
+	/*
+	 * Grab kvm->lock such that the reader of has_run_once can finish
+	 * the necessary operation atomically, such as deciding whether to
+	 * block the writes to the firmware registers if the VM has run once.
+	 */
+	mutex_lock(&kvm->lock);
 	kvm->arch.has_run_once = true;
+	mutex_unlock(&kvm->lock);
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index eb061e64a7a5..d66e6c742bbe 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -65,6 +65,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 static const u64 kvm_arm_vm_scope_fw_regs[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
+	KVM_REG_ARM_STD_BMAP,
 };
 
 /**
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 8624e6964940..48c126c3da72 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -58,6 +58,29 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
+static bool kvm_arm_fw_reg_feat_enabled(u64 reg_bmap, u64 feat_bit)
+{
+	return reg_bmap & feat_bit;
+}
+
+static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
+
+	switch (func_id) {
+	case ARM_SMCCC_TRNG_VERSION:
+	case ARM_SMCCC_TRNG_FEATURES:
+	case ARM_SMCCC_TRNG_GET_UUID:
+	case ARM_SMCCC_TRNG_RND32:
+	case ARM_SMCCC_TRNG_RND64:
+		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
+						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	default:
+		/* By default, allow the services that aren't listed here */
+		return true;
+	}
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -65,6 +88,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 feature;
 	gpa_t gpa;
 
+	if (!kvm_hvc_call_supported(vcpu, func_id))
+		goto out;
+
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val[0] = ARM_SMCCC_VERSION_1_1;
@@ -143,6 +169,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		return kvm_psci_call(vcpu);
 	}
 
+out:
 	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return 1;
 }
@@ -151,8 +178,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_PSCI_VERSION,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
+	KVM_REG_ARM_STD_BMAP,
 };
 
+void kvm_arm_init_hypercalls(struct kvm *kvm)
+{
+	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
+
+	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
+}
+
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
 	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
@@ -220,6 +255,7 @@ static int get_kernel_wa_level(u64 regid)
 
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	void __user *uaddr = (void __user *)(long)reg->addr;
 	u64 val, reg_id = reg->id;
 
@@ -233,6 +269,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
 		val = get_kernel_wa_level(reg_id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
+	case KVM_REG_ARM_STD_BMAP:
+		val = READ_ONCE(hvc_desc->hvc_std_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -243,6 +282,43 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
+static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
+{
+	int ret = 0;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
+	u64 *fw_reg_bmap, fw_reg_features;
+
+	switch (reg_id) {
+	case KVM_REG_ARM_STD_BMAP:
+		fw_reg_bmap = &hvc_desc->hvc_std_bmap;
+		fw_reg_features = ARM_SMCCC_STD_FEATURES;
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	/* Check for unsupported bit */
+	if (val & ~fw_reg_features)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	/*
+	 * If the VM (any vCPU) has already started running, return success
+	 * if there's no change in the value. Else, return -EBUSY.
+	 */
+	if (kvm_arm_vm_has_run_once(&kvm->arch)) {
+		ret = *fw_reg_bmap != val ? -EBUSY : 0;
+		goto out;
+	}
+
+	WRITE_ONCE(*fw_reg_bmap, val);
+out:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
@@ -321,6 +397,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			return -EINVAL;
 
 		return 0;
+	case KVM_REG_ARM_STD_BMAP:
+		return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 5d38628a8d04..64d30b452809 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -6,6 +6,9 @@
 
 #include <asm/kvm_emulate.h>
 
+#define ARM_SMCCC_STD_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
@@ -42,6 +45,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 
 struct kvm_one_reg;
 
+void kvm_arm_init_hypercalls(struct kvm *kvm);
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
