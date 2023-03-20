Received: from out-48.mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE83848E
	for <kvmarm@lists.linux.dev>; Mon, 20 Mar 2023 22:10:42 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679350240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BleVbiTHM3U6e+5CL48uEeAFU36u/cNmIpr6f19CTEA=;
	b=o8/DtuYQ8iFp5uhMsr2bKeJS4NCpy/HEPSFJpBEiCWbkb03wWsN8NaYzWLV4lgfHzU3Z5e
	bKhDw8LH/YP/NgrNTHJsVfW4GcepQ1Fj/owPgZT3szJECDUzw6uArDc3X1RjzErTEBCB+C
	i61tgExTs3FOGK6S6xKoikQ4GCc7o3Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 07/11] KVM: arm64: Use a maple tree to represent the SMCCC filter
Date: Mon, 20 Mar 2023 22:09:58 +0000
Message-Id: <20230320221002.4191007-8-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
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
 arch/arm64/include/asm/kvm_host.h |  5 ++-
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/hypercalls.c       | 57 +++++++++++++++++++++++++++++++
 include/kvm/arm_hypercalls.h      |  1 +
 4 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d091d1c9890b..2682b3fd0881 100644
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
@@ -221,7 +222,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
-
+	/* SMCCC filter initialized for the VM */
+#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		6
 	unsigned long flags;
 
 	/*
@@ -242,6 +244,7 @@ struct kvm_arch {
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
+	struct maple_tree smccc_filter;
 
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b6e26c0e65e5..1202ac03bee0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -192,6 +192,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
+
+	kvm_arm_teardown_hypercalls(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 50145d2132ae..76d39297ed18 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -121,8 +121,58 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
+#define SMCCC_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
+#define SMCCC_ARCH_RANGE_END				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_32,		\
+			   0, ARM_SMCCC_FUNC_MASK)
+
+static void init_smccc_filter(struct kvm *kvm)
+{
+	int r;
+
+	mt_init(&kvm->arch.smccc_filter);
+
+	/*
+	 * Prevent userspace from handling any SMCCC calls in the architecture
+	 * range, avoiding the risk of misrepresenting Spectre mitigation status
+	 * to the guest.
+	 */
+	r = mtree_insert_range(&kvm->arch.smccc_filter,
+			       SMCCC_ARCH_RANGE_BEGIN, SMCCC_ARCH_RANGE_END,
+			       xa_mk_value(KVM_SMCCC_FILTER_ALLOW),
+			       GFP_KERNEL_ACCOUNT);
+	KVM_BUG_ON(r, kvm);
+}
+
+static u8 kvm_smccc_filter_get_action(struct kvm *kvm, u32 func_id)
+{
+	unsigned long idx = func_id;
+	void *val;
+
+	if (!test_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags))
+		return KVM_SMCCC_FILTER_ALLOW;
+
+	/*
+	 * But where's the error handling, you say?
+	 *
+	 * mt_find() returns NULL if no entry was found, which just so happens
+	 * to match KVM_SMCCC_FILTER_ALLOW.
+	 */
+	val = mt_find(&kvm->arch.smccc_filter, &idx, idx);
+	return xa_to_value(val);
+}
+
 static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
 {
+	/*
+	 * Intervening actions in the SMCCC filter take precedence over the
+	 * pseudo-firmware register bitmaps.
+	 */
+	u8 action = kvm_smccc_filter_get_action(vcpu->kvm, func_id);
+	if (action != KVM_SMCCC_FILTER_ALLOW)
+		return action;
+
 	if (kvm_smccc_test_fw_bmap(vcpu, func_id) ||
 	    kvm_smccc_default_allowed(func_id))
 		return KVM_SMCCC_FILTER_ALLOW;
@@ -256,6 +306,13 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
+
+	init_smccc_filter(kvm);
+}
+
+void kvm_arm_teardown_hypercalls(struct kvm *kvm)
+{
+	mtree_destroy(&kvm->arch.smccc_filter);
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 8f4e33bc43e8..fe6c31575b05 100644
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
2.40.0.rc1.284.g88254d51c5-goog

