Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F9E4ACC8B;
	Thu, 24 Sep 2026 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265943; cv=none; b=cPmznA0nWcuwgtRQBuTjJeTHJZzwsSEIjDFTx/zxu4z5cXYM42coMCSuIWGiqamEH6MbNJoerA3KzKualXiLJkXykESQV0yCmud0eCB+W7QHg475N2ybKbFgcsgWH5XCSZgTvIm//NwD9HetmLA1W2yZ8lOtdNoF0G0CEJwouP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265943; c=relaxed/simple;
	bh=T9eIctwVtxFtu2naBbqkNNQZ5lLsvNie+O2i9aydJAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE6U4FC8viSuIWU+ZPj43avz2Srewv35i9N97CraF8R6hcAZ8oVIyLIIoODfOV0z74aVN/uVEhGTpmQ36kYEx2wWlHgcucgTbsjTUy50B0XXyaec10vZ0cirx28ZAVKJY9G+ZjSftBkQ7cuhsveRmUcS3iCeBjMWeFmsBxUnmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hhbXYKX8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hhbXYKX8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29D1A152B;
	Thu, 24 Sep 2026 09:05:37 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F1C13F86C;
	Thu, 24 Sep 2026 09:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265940; bh=T9eIctwVtxFtu2naBbqkNNQZ5lLsvNie+O2i9aydJAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhbXYKX8qL9fxDGDDc54qs82TTNxw9xjxbN4cRRxhstUZVA5KuzmtSSfZ1cnJmdcE
	 TsjoWsUOXnOk7TPwduuDmYY3NgyTxhNtkEkuUVN9l4EkF4XuLTeS+AiUr7Zp2ZKcPz
	 NuSoxlDDAXfSiWjlims8oegIr54gmigBsuC3b4MY=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v20 05/22] KVM: arm64: Track the type of VM in kvm_arch
Date: Thu, 24 Sep 2026 17:04:47 +0100
Message-ID: <20260924160504.853911-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM arm64 has different types of VMs with all the different modes in which
the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
protected VM and normal VMs with pKVM. We might soon add other types,
e.g., Arm CCA Realm. So in an effort to make the handling of these
different types of VMs a bit more friendly to the eyes, add a VM flavor to
the kvm_arch and we could then add handlers for different operations based
on the VM type.

Keep the flavor initialisation at the beginning to allow for the detection
early enough and fail out on any unsupported requests.

With that, add wrappers for checking the "type" of a VM and replace the
existing users with the new wrappers.

Given we already have the construct of "kvm_vm_is_protected" in the core
KVM code, use that for all confidential compute guests including Realms
that we are about to add. Adds __VM_PROTECTED marker vm flavor to draw the
boundary for "protected VMs". In later patches, we would add Realm VMs,
 which would also be classified as protected.

Add a explicit helper to detect if a given VM is a "protected" VM under pKVM.
Change the existing users that precisely want to check the VM type. These
include :
  - kvm_arch_prepare_memory_region - For preventing memslot changes after
    pVM creation.

All the others are retained as a wider check for confidential guest VMs.
These are:
 - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset
   configuration
 - io_mem_abort for dabt handling without valid syndrome information

Both of which are true for Realms too.

Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
checks in the pkvm hyp specific code doesn't need to change, as the only
protected guests it deals with is "protected pKVM" guests. To tighten this
init_pkvm_hyp_vm() restricts the hyp copy of the vm_flavor to the ones it
supports.

vcpu_is_protected() usage from nVHE hyp code is tricky, as we need to
convert the vcpu->kvm to the HYP VA before checking the flavor. This
involves kern_hyp_va() usage in asm/kvm_host.h. To avoid build breaks,
include asm/kvm_mmu.h to arm64/kvm/mmio.c.

Suggested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - Fix vcpu_is_protected for nvhe hyp by using the kern_hyp_va() for
   vcpu->kvm - Gavin
 - Use READ_ONCE() to read the vm_flavor in EL2 pKVM code
 - Drop ',' after the end marker in vm_flavor enums
 - Replace !kvm_vm_is_protected() in kvm_arch_vcpu_put() with
   kvm_vm_is_unprotected_pkvm()
Changes since v18:
 - Merge the __VM_PROTECTED marker and the widening of kvm_vm_is_protected()
   to this patch.
 - Merge the use of kvm_vm_is_unprotected_pkvm() for !kvm_vm_is_protected()
   given the scope changes here.
 - Drop Fuad's review tag, as this patch has multiple merges
 - Restrict the VM flavors to the supported types in init_pkvm_hyp_vm().
 - Drop kvm_vm_hyp_is_pkvm() and revert to is_protected_kvm_enabled()
 - Use is_protected_kvm_enabled() to make the pKVM guest flavor checks.
 - s/PKVM/pKVM for commit descriptions too

Changes since v17:
 * s/PKVM/pKVM for the comments
 * Drop type argument for pkvm_init_host_vm and also drop protected variable.
 * Add helpers for checking if the VM is running on pKVM (kvm_vm_hyp_is_pkvm())
 * Use kvm_vm_hyp_is_pkvm() to replace is_protected_kvm_enabled() with valid
   kvm instance
---
 arch/arm64/include/asm/kvm_host.h | 51 +++++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_pkvm.h |  4 +--
 arch/arm64/kvm/arm.c              | 33 ++++++++++++++++----
 arch/arm64/kvm/handle_exit.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 +++-
 arch/arm64/kvm/mmio.c             |  1 +
 arch/arm64/kvm/mmu.c              |  2 +-
 arch/arm64/kvm/pkvm.c             |  6 ++--
 8 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 286489a69dff5..63bd1f76edb7b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -257,7 +257,6 @@ struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
-	bool is_protected;
 	bool is_created;
 
 	/*
@@ -306,9 +305,19 @@ enum fgt_group_id {
 	__NR_FGT_GROUP_IDS__
 };
 
+enum kvm_arm_vm_flavor {
+	VM_NVHE,
+	VM_VHE,
+	VM_PKVM,		/* Normal guests on pKVM */
+	MARKER(__VM_PROTECTED),
+	VM_PROTECTED_PKVM,	/* Protected VM */
+	VM_FLAVOR_MAX
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
+	enum kvm_arm_vm_flavor vm_flavor;
 	/*
 	 * Fine-Grained UNDEF, mimicking the FGT layout defined by the
 	 * architecture. We track them globally, as we present the
@@ -1504,9 +1513,45 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
+/*
+ * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
+ * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
+ * which is populated correctly.
+ */
+#define vcpu_is_protected(vcpu)						\
+	({								\
+		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
+		bool __protected = false;				\
+									\
+		if (__kvm) {						\
+			if (is_nvhe_hyp_code() &&			\
+			    !is_protected_kvm_enabled()) 		\
+				__kvm = kern_hyp_va(__kvm); 		\
+									\
+			__protected = kvm_vm_is_protected(__kvm);	\
+		}							\
+		__protected;						\
+	})
+
+#define kvm_vm_is_protected_pkvm(kvm)					\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
+
+/*
+ * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
+ * make sure the vcpu->kvm is always valid VA in the context
+ */
+#define vcpu_is_protected_pkvm(vcpu)					\
+	({								\
+		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
+									\
+		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
+	})
+
+
+#define kvm_vm_is_unprotected_pkvm(kvm)		\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
 
-#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 54a618d887fa4..e4ea80711bec6 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,7 +17,7 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
-int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
+int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
@@ -49,7 +49,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
 		return false;
 	default:
-		return !kvm || !kvm_vm_is_protected(kvm);
+		return !kvm || kvm_vm_is_unprotected_pkvm(kvm);
 	}
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index db36815630790..90547fbbc8ad7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -214,6 +214,26 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
+static int kvm_init_vm_flavor(struct kvm *kvm, unsigned long type)
+{
+	bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
+
+	if (is_protected_kvm_enabled()) {
+		if (protected)
+			kvm->arch.vm_flavor = VM_PROTECTED_PKVM;
+		else
+			kvm->arch.vm_flavor = VM_PKVM;
+	} else if (protected) {
+		return -EINVAL;
+	} else if (has_vhe()) {
+		kvm->arch.vm_flavor = VM_VHE;
+	} else {
+		kvm->arch.vm_flavor = VM_NVHE;
+	}
+
+	return 0;
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -236,6 +256,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif
 
+	ret = kvm_init_vm_flavor(kvm, type);
+	if (ret)
+		return ret;
+
 	kvm_init_nested(kvm);
 
 	ret = kvm_share_hyp(kvm, kvm + 1);
@@ -257,12 +281,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		 * If any failures occur after this is successful, make sure to
 		 * call __pkvm_unreserve_vm to unreserve the VM in hyp.
 		 */
-		ret = pkvm_init_host_vm(kvm, type);
+		ret = pkvm_init_host_vm(kvm);
 		if (ret)
 			goto err_uninit_mmu;
-	} else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
-		ret = -EINVAL;
-		goto err_uninit_mmu;
 	}
 
 	kvm_vgic_early_init(kvm);
@@ -751,7 +772,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
 
 		/* __pkvm_vcpu_put implies a sync of the state */
-		if (!kvm_vm_is_protected(vcpu->kvm))
+		if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
 			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
@@ -985,7 +1006,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 
 	if (is_protected_kvm_enabled()) {
 		/* Start with the vcpu in a dirty state */
-		if (!kvm_vm_is_protected(vcpu->kvm))
+		if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
 			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 		ret = pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index db37678dcb05c..384c5d258c7f8 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -490,7 +490,7 @@ static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_index)
 {
 	int exception_code = ARM_EXCEPTION_CODE(exception_index);
 
-	if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
+	if (!kvm_vm_is_unprotected_pkvm(vcpu->kvm))
 		return;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..ed51762aa4b5d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -432,7 +432,11 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
-	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
+	if (READ_ONCE(host_kvm->arch.vm_flavor) == VM_PROTECTED_PKVM)
+		hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
+	else
+		hyp_vm->kvm.arch.vm_flavor = VM_PKVM;
+
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index d1c3a352d5a22..ab1d2fef9a522 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..0f4e8b71fa85d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2624,7 +2624,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
-	if (kvm_vm_is_protected(kvm)) {
+	if (kvm_vm_is_protected_pkvm(kvm)) {
 		/* Cannot modify memslots once a pVM has run. */
 		if (pkvm_hyp_vm_is_created(kvm) &&
 		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec123..8e9176a700926 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -229,10 +229,9 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm)
 	mutex_unlock(&kvm->arch.config_lock);
 }
 
-int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
+int pkvm_init_host_vm(struct kvm *kvm)
 {
 	int ret;
-	bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
 
 	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
 	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
@@ -240,8 +239,7 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
 		return ret;
 
 	kvm->arch.pkvm.handle = ret;
-	kvm->arch.pkvm.is_protected = protected;
-	if (protected) {
+	if (kvm_vm_is_protected(kvm)) {
 		pr_warn_once("kvm: protected VMs are experimental and for development only, tainting kernel\n");
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
 	}
-- 
2.43.0

