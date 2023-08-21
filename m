Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E0E125C1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:22:49 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-68a628f923dso923509b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652969; x=1693257769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2B7Qy6Kw5j/nTo/++b4jHC7ZtOMGC89Nxbhsckocxfk=;
        b=bJhawE4Uhw56ASBDjFYeOUlLqMZlQeCKQIJ7UYtdJOCDTJd68Ir9e9VfvRLfnTgX6H
         VLShYlvLVCw1aq4fZu3uTxVWGWpQhT/H9tK0L0FX9+6SuZTdn35543bhQtizWC3xXzyd
         lBqn+TNEyxr4YAHP5PGaYKvUst+Thd0/VOBSPWvgl6XyTD8ud+pwSCb2MjENzFhN3CJ9
         ualZc/+6TGm2R3NBNYPsvpxrEVvndkOhqWQvdYkuBQg9zr9y9CkoAgM4XrEFzYCK+tTA
         q5zeXbOCB2GKlHamZFmpTdLZYyDFc8BGf9uRieUSWHRr+Bs5X9HJyAjNacuj2q3hbGpD
         LFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652969; x=1693257769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2B7Qy6Kw5j/nTo/++b4jHC7ZtOMGC89Nxbhsckocxfk=;
        b=Yx4d17KrqaMq1AOyCDYED2Df2N6lAYjmgP2vSbf7B8p1AniuqXXILRJA/IILsCxaY3
         gJo5BBKdVA7bAr0wgcP/ZuXA2k/TXFrrNOA1QDv3Baq3IRMokg09IWEl5MMdgyGlO/7O
         YJdVt8GSlRmLpPJNkP3WXq3zmytRuMQhkl0ZKApkE+ZVZo+G9xsCbs/aZdl49yXUPBx3
         sw2svGnsOmPyICr3gVobLqfoFvLFQrmpoCMW9JLQMzjw2F7L6MHqlp3fRU+2MRdrTWB+
         mDH7nuq0amWYuTODp2EUSj45uMDAXa8AKUP3/fN3Jt6jYmMksGXaw9IZ5JaEyaaAI8+6
         cm5w==
X-Gm-Message-State: AOJu0YxuGpCagmwvxQj/XCOqp3vf1JesUKK8WZxokBgSJC23y/hJe75h
	Zvf7AP2eCjFcUIJk4CVRnI2+ALanuLJ1/n7/1A==
X-Google-Smtp-Source: AGHT+IFSEGdu2t4zwctottOZyfhvKMdc+9pCmvEQUmekmWTsy2kBSMFlsqmqWUe4mc3/Ykgfegb5kfjn1Y36WAIpIw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2d87:b0:67e:86c0:6bd3 with
 SMTP id fb7-20020a056a002d8700b0067e86c06bd3mr4675455pfb.1.1692652968987;
 Mon, 21 Aug 2023 14:22:48 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:33 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-2-jingzhangos@google.com>
Subject: [PATCH v9 01/11] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a VM ioctl to allow userspace to get writable masks for feature ID
registers in below system register space:
op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
This is used to support mix-and-match userspace and kernels for writable
ID registers, where userspace may want to know upfront whether it can
actually tweak the contents of an idreg or not.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h | 26 ++++++++++++++
 arch/arm64/kvm/arm.c              |  7 ++++
 arch/arm64/kvm/sys_regs.c         | 57 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 93 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..a328d362df5a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			       struct kvm_arm_copy_mte_tags *copy_tags);
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm,
+					struct reg_mask_range *range);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..7a21bbb8a0f7 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,32 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/* Get feature ID registers userspace writable mask. */
+/*
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all R/O registers that indicate anything useful feature
+ * wise, including the ID registers.
+ */
+#define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+struct reg_mask_range {
+	__u64 addr;		/* Pointer to mask array */
+	__u64 reserved[7];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d1cb298a58a0..cfb5e9ef43c4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1630,6 +1630,13 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 		return kvm_vm_set_attr(kvm, &attr);
 	}
+	case KVM_ARM_GET_REG_WRITABLE_MASKS: {
+		struct reg_mask_range range;
+
+		if (copy_from_user(&range, argp, sizeof(range)))
+			return -EFAULT;
+		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ca2973abe66..216905840c92 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3560,6 +3560,63 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+#define ARM64_FEATURE_ID_SPACE_INDEX(r)			\
+	ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(r),	\
+		sys_reg_Op1(r),				\
+		sys_reg_CRn(r),				\
+		sys_reg_CRm(r),				\
+		sys_reg_Op2(r))
+
+static bool is_feature_id_reg(u32 encoding)
+{
+	return (sys_reg_Op0(encoding) == 3 &&
+		(sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) == 3) &&
+		sys_reg_CRn(encoding) == 0 &&
+		sys_reg_CRm(encoding) <= 7);
+}
+
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *range)
+{
+	const void *zero_page = page_to_virt(ZERO_PAGE(0));
+	u64 __user *masks = (u64 __user *)range->addr;
+
+	/* Only feature id range is supported, reserved[7] must be zero. */
+	if (memcmp(range->reserved, zero_page, sizeof(range->reserved)))
+		return -EINVAL;
+
+	/* Wipe the whole thing first */
+	if (clear_user(masks, ARM64_FEATURE_ID_SPACE_SIZE * sizeof(__u64)))
+		return -EFAULT;
+
+	for (int i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *reg = &sys_reg_descs[i];
+		u32 encoding = reg_to_encoding(reg);
+		u64 val;
+
+		if (!is_feature_id_reg(encoding) || !reg->set_user)
+			continue;
+
+		/*
+		 * For ID registers, we return the writable mask. Other feature
+		 * registers return a full 64bit mask. That's not necessary
+		 * compliant with a given revision of the architecture, but the
+		 * RES0/RES1 definitions allow us to do that.
+		 */
+		if (is_id_reg(encoding)) {
+			if (!reg->val)
+				continue;
+			val = reg->val;
+		} else {
+			val = ~0UL;
+		}
+
+		if (put_user(val, (masks + ARM64_FEATURE_ID_SPACE_INDEX(encoding))))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	struct sys_reg_params params;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..424b6d00440b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1555,6 +1555,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.42.0.rc1.204.g551eb34607-goog

