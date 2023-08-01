Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B5120EA
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:13 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-686daaa5f3bso4030754b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903213; x=1691508013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=747YuA1Dx3SnOAWlrzcy+YkCaluTCLGvH8CPu7tzkC4=;
        b=OnA1/I6KmNJ9yAGgvDZXynSz1+x25gIwMims5hYLHC2K27+q5VlCMWe5iP2o9fTFH+
         VLWRYhVHAbmCQoeuVyZHfg/sFHWSdxe5kSFzDiS3HHc91Lsv/uq+MZU4kTdKe2pk6N1X
         6+fBa9EwMORKFZbxWn8IhvjqZjufoBIrm7LQpk0z/sJ02EiLZt38IqQ08jJKzEPZ4UK9
         jbXXlQeEdzx8JCqMr71sDZCKpY0GJO7L6IhuPtVI+R684jEWTs41enwkUEvRyyS2CSag
         PFOVlMZjrxfWrNU92p449qUxFS+xhVwLy5OgGnKdhGWHcheaJPtAcSyHblrf7nNrJHSO
         SCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903213; x=1691508013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=747YuA1Dx3SnOAWlrzcy+YkCaluTCLGvH8CPu7tzkC4=;
        b=CBYNmDPXRKC1x/7J66YYpgvNqgp2RPiAqhXGeIb14ToQa8sume9lYV3LEeWf9CnWZB
         JEeXif9WPMIrhG6+UESKeTwprzCa4Dt5jPjgQksYwRh5fnG3xar2GW3MCtT6d87HNeBI
         GL2jhRlvsnnLXHF27RU6RCLkW3hmuD6zK0UyDK9O7dk0U037H6puFkyVc64EHmgPYMh6
         gts///el+wsHjgXzV0iHk9quPqHdodVQ3ts+YdifBh6NyLJIpxTjJep+kP413umRZ9le
         Ym0yxJQ1JFBkj08E2WfH/mbrik5iG3+jFjJSepzq1EXfEKmoRCmwC37VV/AJqg6bS16j
         c14A==
X-Gm-Message-State: ABy/qLZoAWUtd8WdNQOCrMM2HbuZkkgwThaSa5BgMTEYiuFkumBTZGsA
	L6/KUoLLDxxQp5Yl/YCeSb1cPzlY2DwxKbxxOQ==
X-Google-Smtp-Source: APBJJlFYIduNuYy0wvIby8yBJwkrjNp6LvpOSugL72WbrXU69i6bGxB5cmDBygkjJXCN14JhWaFyNL7KmMaDXCMNOw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:21c3:b0:66a:4525:8264 with
 SMTP id t3-20020a056a0021c300b0066a45258264mr97688pfj.1.1690903213191; Tue,
 01 Aug 2023 08:20:13 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:19:57 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-2-jingzhangos@google.com>
Subject: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
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
	Jing Zhang <jingzhangos@google.com>
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
 arch/arm64/include/uapi/asm/kvm.h | 25 +++++++++++++++
 arch/arm64/kvm/arm.c              |  3 ++
 arch/arm64/kvm/sys_regs.c         | 51 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 83 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..3996a3707f4e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			       struct kvm_arm_copy_mte_tags *copy_tags);
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
+int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm,
+					       u64 __user *masks);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..2970c0d792ee 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,31 @@ struct kvm_smccc_filter {
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
+struct feature_id_writable_masks {
+	__u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..c9cd14057c58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1630,6 +1630,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 		return kvm_vm_set_attr(kvm, &attr);
 	}
+	case KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS: {
+		return kvm_vm_ioctl_get_feature_id_writable_masks(kvm, argp);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ca2973abe66..d9317b640ba5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3560,6 +3560,57 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
+int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm, u64 __user *masks)
+{
+	/* Wipe the whole thing first */
+	for (int i = 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
+		if (put_user(0, masks + i))
+			return -EFAULT;
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
index f089ab290978..86ffdf134eb8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1555,6 +1555,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS \
+			_IOR(KVMIO,  0xb6, struct feature_id_writable_masks)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.41.0.585.gd2178a4bd4-goog

