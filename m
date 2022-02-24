Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329A8C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEEC14BD68;
	Thu, 24 Feb 2022 12:26:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7DqvnOhsWtoM; Thu, 24 Feb 2022 12:26:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF5764BDDA;
	Thu, 24 Feb 2022 12:26:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C277B4BD83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mb+bNYCYWyZr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:14 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23E6D4BDB7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:14 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 b9-20020a17090aa58900b001b8b14b4aabso1724129pjq.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KaCBuwIyBaYjU3K7NXFsCjZcUQNiR1GDNYO7qs8JETY=;
 b=fZLUwv+joWr/KbhO5KrM6woBx5STObKXzVBlyItFKgfFX2ppVopErWfQyAyqmXKCOx
 7jRwCDUOzx9jtL9EJrqyC/h3OjKVMzzyFz22XYWAHaCiZM7gegqLJnyaBcr8T5zHpdMc
 WxFEKpGgcJlSYHmcbY8TWDHaP1af46W4E8eFFpT51tXxeM+DuvDCrZzLSr9DJPPkwsQS
 T5eMRo5XWoO6q/1IOYfMQqIBfbOTzUbuS539VeFrhKfo6c8/nzkGGzldC/mEabJedqZ9
 yaiXtwieY8sApFSm6D1pDeaUqDdNWzspj3NWfIR4fKioNKKnUVMBh9ogvyH0g+Rk1pJ1
 zbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KaCBuwIyBaYjU3K7NXFsCjZcUQNiR1GDNYO7qs8JETY=;
 b=OYsnMhiCKOiwLQd5JP6lzXaAMQ+ROBAHvmjWnGY37yosu+RJjq3GGkTIiXQm3C3pJC
 u6OnDH7HOhJ346FKDI+vTmDew1S3eyNhEpX6YgrEIW3n1qLRgPio+Lo3uWJ2QkzvRvC8
 2PLnxFe781xEiuC1y9jcKoYb+qhXSchJCCy8QPAfhULuSV8y6cK/5VrmfCbRxhHMONbH
 ceXz6PrP8oxOXGeZoveTuOh6BX5bahOS/i3NABvv33etW471an01KoNS0nNsqtUmV3m6
 NZFkWEd7xufWcJaXkYkDAOP4TnrqZWrPpQ/X7VuGpDA9aguQGo98yxADvwYJ5o7Wb7kN
 KJkw==
X-Gm-Message-State: AOAM530REXV0bBFkyOy0mhik9DfR3EbmoIND8ogUEQCZ72yxprO3ShfY
 qonlPFSq1lA/ZkcWtObul9KKUz4gYPWI
X-Google-Smtp-Source: ABdhPJxMtaJZ3smrZYeKjDmBPhXAaNSzbfO+lVKvJuxUWaHxzZNzmp4RLYQj5GycYVgIiIBYBxCU6HzY8eFt
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:5ac6:0:b0:4df:34dc:d6c5 with SMTP id
 o189-20020a625ac6000000b004df34dcd6c5mr3940421pfb.9.1645723573162; Thu, 24
 Feb 2022 09:26:13 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:49 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-4-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 03/13] KVM: arm64: Encode the scope for firmware registers
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

The psuedo-firmware registers, KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1
and KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, can be scopped as per-VM
registers. Hence, during the KVM_GET_REG_LIST call, encode
KVM_REG_ARM_SCOPE_VM into the registers, but during
KVM_[GET|SET]_ONE_REG calls, clear the scope information such that
they can be processed like before.

For future expansion, helper functions such as
kvm_arm_reg_id_encode_scope() and kvm_arm_reg_id_clear_scope()
are introduced.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/guest.c            | 77 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c       | 31 +++++++++----
 3 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8132de6bd718..657733554d98 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -794,6 +794,8 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
+int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
+void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
 extern phys_addr_t hyp_mem_size;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8238e52d890d..eb061e64a7a5 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -61,6 +61,83 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
+/* Registers that are VM scopped */
+static const u64 kvm_arm_vm_scope_fw_regs[] = {
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
+};
+
+/**
+ * kvm_arm_reg_id_encode_scope - Encode the KVM_REG_ARM_SCOPE info into the
+ *				 register-id
+ * @vcpu: The vcpu pointer
+ * @reg_id: Pointer to the register
+ *
+ * The function adds the register's scoping information into its encoding.
+ * If it's explicitly marked as a per-VM register, it's encoded with
+ * KVM_REG_ARM_SCOPE_VM. Else, it's marked as KVM_REG_ARM_SCOPE_VCPU, which
+ * is also the default if KVM_CAP_ARM_REG_SCOPE is disabled.
+ *
+ * For any error cases, the function returns an error code, else it returns
+ * the integer value of the encoding.
+ */
+int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id)
+{
+	const u64 *vm_scope_reg_arr;
+	unsigned int arr_size, idx;
+
+	if (!READ_ONCE(vcpu->kvm->arch.reg_scope_enabled))
+		return KVM_REG_ARM_SCOPE_VCPU;
+
+	if (!reg_id)
+		return -EINVAL;
+
+	switch (*reg_id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_FW:
+		vm_scope_reg_arr = kvm_arm_vm_scope_fw_regs;
+		arr_size = ARRAY_SIZE(kvm_arm_vm_scope_fw_regs);
+		break;
+	default:
+		/* All the other register classes are currently
+		 * treated as per-vCPU registers.
+		 */
+		return KVM_REG_ARM_SCOPE_VCPU;
+	}
+
+	/* By default, all the registers encodings are scoped as vCPU.
+	 * Modify the scope only if a register is marked as per-VM.
+	 */
+	for (idx = 0; idx < arr_size; idx++) {
+		if (vm_scope_reg_arr[idx] == *reg_id) {
+			*reg_id |=
+				KVM_REG_ARM_SCOPE_VM << KVM_REG_ARM_SCOPE_SHIFT;
+			return KVM_REG_ARM_SCOPE_VM;
+		}
+	}
+
+	return KVM_REG_ARM_SCOPE_VCPU;
+}
+
+/**
+ * kvm_arm_reg_id_clear_scope - Clear the KVM_REG_ARM_SCOPE info from the
+ *				 register-id
+ * @vcpu: The vcpu pointer
+ * @reg_id: Pointer to the register
+ *
+ * The function clears the register's scoping information, which ultimately
+ * is the raw encoding of the register. Note that the result is same as that
+ * of re-encoding the register as KVM_REG_ARM_SCOPE_VCPU.
+ * The function can be helpful to the existing code that uses the original
+ * register encoding to operate on the register.
+ */
+void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id)
+{
+	if (!READ_ONCE(vcpu->kvm->arch.reg_scope_enabled) || !reg_id)
+		return;
+
+	*reg_id &= ~(1 << KVM_REG_ARM_SCOPE_SHIFT);
+}
+
 static bool core_reg_offset_is_vreg(u64 off)
 {
 	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 3c2fcf31ad3d..8624e6964940 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -160,10 +160,17 @@ int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	int i;
+	int i, ret;
+	u64 reg_id;
 
 	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
-		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
+		reg_id = kvm_arm_fw_reg_ids[i];
+
+		ret = kvm_arm_reg_id_encode_scope(vcpu, &reg_id);
+		if (ret < 0)
+			return ret;
+
+		if (put_user(reg_id, uindices++))
 			return -EFAULT;
 	}
 
@@ -214,21 +221,23 @@ static int get_kernel_wa_level(u64 regid)
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
+	u64 val, reg_id = reg->id;
 
-	switch (reg->id) {
+	kvm_arm_reg_id_clear_scope(vcpu, &reg_id);
+
+	switch (reg_id) {
 	case KVM_REG_ARM_PSCI_VERSION:
 		val = kvm_psci_version(vcpu, vcpu->kvm);
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
-		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
+		val = get_kernel_wa_level(reg_id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	default:
 		return -ENOENT;
 	}
 
-	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
+	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg_id)))
 		return -EFAULT;
 
 	return 0;
@@ -237,13 +246,15 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
+	u64 val, reg_id = reg->id;
 	int wa_level;
 
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-	switch (reg->id) {
+	kvm_arm_reg_id_clear_scope(vcpu, &reg_id);
+
+	switch (reg_id) {
 	case KVM_REG_ARM_PSCI_VERSION:
 	{
 		bool wants_02;
@@ -270,7 +281,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 
-		if (get_kernel_wa_level(reg->id) < val)
+		if (get_kernel_wa_level(reg_id) < val)
 			return -EINVAL;
 
 		return 0;
@@ -306,7 +317,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
 		 * other way around.
 		 */
-		if (get_kernel_wa_level(reg->id) < wa_level)
+		if (get_kernel_wa_level(reg_id) < wa_level)
 			return -EINVAL;
 
 		return 0;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
