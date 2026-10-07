Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B37540B373;
	Wed,  7 Oct 2026 07:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358571; cv=none; b=cxMUNqeqsG0PieC85e5IIs+GeIdZaXXGntrHwCVvAfGuY0hwCJHj4eeZSLprJgAXt4CNOVCXkCXHcAL1TVcLvMuozQppSGVdiK0JDm9fo5tycOD/ujPS0IU8kSIDO8UZl76EQi9i2mqfmV/qjaV9pV29eKGyoTV+wfahcg/Y4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358571; c=relaxed/simple;
	bh=ONwDFWEwBzX0Xy7V0LBO8xIyVnetN8tiWEFyPYK6S5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8DkFTwCfrU4QkvSpeM/AIcVRkQwTpppBUawwoRkzOoVY+yrIryl7fGRm4af58G5X3Qwu2V8m5ssWj6A2JnypraaV6dELhneowFkCSzzNyzivu63tuup5d3R62hUeChi/OfVmqj/IFAnsCqUMCDG9AP9G0wn4pn3+vnw1Y9rPRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I2yQ1Acg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I2yQ1Acg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 700A7152B;
	Wed,  7 Oct 2026 00:36:05 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 433723F763;
	Wed,  7 Oct 2026 00:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791358568; bh=ONwDFWEwBzX0Xy7V0LBO8xIyVnetN8tiWEFyPYK6S5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2yQ1AcgVMosJcVEZhzZ41fm5sdyIYtct7koxiLbXgHD1dXjaieFm5NfT4/vEcRCy
	 02kw+ABsocEIT0VTN3a8zC/etephENqBIHXuhIplrqxUb463dz79dKwCWpAjhymWD1
	 nZn+Ci2wtGJnnYr5vK//jQeUGfOkppelCZigTdkg=
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
Subject: [PATCH v23 05/14] KVM: arm64: Track the type of VM in kvm_arch
Date: Wed,  7 Oct 2026 08:35:28 +0100
Message-ID: <20261007073537.2454351-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007073537.2454351-1-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
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

While adding the vm_flavor, move the psci_version around to keep the structure
packed.

Suggested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v22:
 - Drop BUILD_BUG_ON and redefine {kvm_vm,vcpu}_is_protected() for nVHE
 - Drop {kvm_vm,vcpu}_is_protected_pkvm() macros
Changes since v21:
 - Drop kern_hyp_va() and restrict nvhe code to always use vcpu_is_protected_pkvm()
 - Drop kvm_vm_is_unprotected_pkvm() and open code the check
 - Move psci_version field in kvm_arch around to keep the structure packed
---
 arch/arm64/include/asm/kvm_host.h | 38 +++++++++++++++++++++++++++----
 arch/arm64/include/asm/kvm_pkvm.h |  4 ++--
 arch/arm64/kvm/arm.c              | 33 ++++++++++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 ++++-
 arch/arm64/kvm/mmio.c             |  1 +
 arch/arm64/kvm/pkvm.c             |  6 ++---
 6 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 286489a69dff5..1df0cb2b76e93 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -257,7 +257,6 @@ struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
-	bool is_protected;
 	bool is_created;
 
 	/*
@@ -306,9 +305,22 @@ enum fgt_group_id {
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
+	/* Mandated version of PSCI */
+	u32 psci_version;
+
 	/*
 	 * Fine-Grained UNDEF, mimicking the FGT layout defined by the
 	 * architecture. We track them globally, as we present the
@@ -332,9 +344,6 @@ struct kvm_arch {
 	/* Timers */
 	struct arch_timer_vm_data timer_data;
 
-	/* Mandated version of PSCI */
-	u32 psci_version;
-
 	/* Protects VM-scoped configuration data */
 	struct mutex config_lock;
 
@@ -1504,10 +1513,29 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
+#ifdef __KVM_NVHE_HYPERVISOR__
 
+#define kvm_vm_is_protected(kvm)			\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
+/*
+ * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
+ * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
+ * which is populated correctly and is gated on is_protected_kvm_enabled().
+ */
+#define vcpu_is_protected(vcpu)						\
+	({								\
+		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
+									\
+		(__kvm && kvm_vm_is_protected(__kvm));			\
+	})
+
+#else
+
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
+#endif	/* __KVM_NVHE_HYPERVISOR__ */
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 54a618d887fa4..2addc37c500e1 100644
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
+		return !kvm || (kvm->arch.vm_flavor == VM_PKVM);
 	}
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index db36815630790..bcec14c587119 100644
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
+		if (vcpu->kvm->arch.vm_flavor == VM_PKVM)
 			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
@@ -985,7 +1006,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 
 	if (is_protected_kvm_enabled()) {
 		/* Start with the vcpu in a dirty state */
-		if (!kvm_vm_is_protected(vcpu->kvm))
+		if (vcpu->kvm->arch.vm_flavor == VM_PKVM)
 			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 		ret = pkvm_create_hyp_vm(kvm);
 		if (ret)
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

