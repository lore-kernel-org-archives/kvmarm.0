Received: from out-19.mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A49813
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 02:01:39 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676079499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HTIjnmJEX0Ff4LF+cABR46hUjNT8pZt9yyzf6CFseOs=;
	b=KPzZE4RX0oxZ6YwfAsTX/G0myxSaZ/T2wRvxTx4kia842xF/FC9HmrH6j2YqapRkKV9adc
	miPxQnWUC0yIhnzT/QGCocnwz3HrNBpDZinSp2AaMt8WKR9tkfgTxSzgIqK+9YMdLsnkE6
	PM4bhRUIkGbnsWJHRgaQVvptASf0rqI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH v2 4/6] KVM: arm64: Use a maple tree to represent the SMCCC filter
Date: Sat, 11 Feb 2023 01:37:57 +0000
Message-Id: <20230211013759.3556016-5-oliver.upton@linux.dev>
In-Reply-To: <20230211013759.3556016-1-oliver.upton@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Maple tree is an efficient B-tree implementation that is intended for
storing non-overlapping intervals. Such a data structure is a good fit
for the SMCCC filter as it is desirable to sparsely allocate the 32 bit
function ID space.

To that end, add a maple tree to kvm_arch and correctly init/teardown
along with the VM. Wire in a test against the hypercall filter for HVCs
which does nothing until the controls are exposed to userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++-
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/hypercalls.c       | 38 +++++++++++++++++++++++++++++++
 include/kvm/arm_hypercalls.h      |  1 +
 4 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 012e94bc9e4a..a20875dde1f5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
+#include <linux/maple_tree.h>
 #include <linux/percpu.h>
 #include <linux/psci.h>
 #include <asm/arch_gicv3.h>
@@ -213,7 +214,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
-
+	/* SMCCC filter initialized for the VM */
+#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		6
 	unsigned long flags;
 
 	/*
@@ -234,6 +236,7 @@ struct kvm_arch {
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
+	struct maple_tree smccc_filter;
 
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 09efa893e03a..e04690caad77 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -202,6 +202,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
+
+	kvm_arm_teardown_hypercalls(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 980546b295b3..45b8371816fd 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -121,8 +121,39 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
+static bool kvm_smccc_filter_configured(struct kvm *kvm)
+{
+	return test_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
+}
+
+static u8 kvm_smccc_filter_get_action(struct kvm *kvm, u32 func_id)
+{
+	unsigned long index = func_id;
+	void *val;
+
+	if (!kvm_smccc_filter_configured(kvm))
+		return KVM_SMCCC_FILTER_ALLOW;
+
+	/*
+	 * But where's the error handling, you say?
+	 *
+	 * mt_find() returns NULL if no entry was found, which just so happens
+	 * to match KVM_SMCCC_FILTER_ALLOW.
+	 */
+	val = mt_find(&kvm->arch.smccc_filter, &index, index);
+	return xa_to_value(val);
+}
+
 static u8 kvm_hvc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
 {
+	/*
+	 * Intervening actions in the SMCCC filter take precedence over the
+	 * pseudo-firmware register bitmaps.
+	 */
+	u8 action = kvm_smccc_filter_get_action(vcpu->kvm, func_id);
+	if (action != KVM_SMCCC_FILTER_ALLOW)
+		return action;
+
 	if (kvm_smccc_default_call(func_id) ||
 	    kvm_smccc_test_fw_bmap(vcpu, func_id))
 		return KVM_SMCCC_FILTER_ALLOW;
@@ -256,6 +287,13 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
+
+	mt_init(&kvm->arch.smccc_filter);
+}
+
+void kvm_arm_teardown_hypercalls(struct kvm *kvm)
+{
+	mtree_destroy(&kvm->arch.smccc_filter);
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 1188f116cf4e..ae1ada68cdc2 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -43,6 +43,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 struct kvm_one_reg;
 
 void kvm_arm_init_hypercalls(struct kvm *kvm);
+void kvm_arm_teardown_hypercalls(struct kvm *kvm);
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-- 
2.39.1.581.gbfd45094c4-goog

