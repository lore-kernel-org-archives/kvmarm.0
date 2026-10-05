Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F5142AFB7;
	Mon,  5 Oct 2026 09:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191306; cv=none; b=DiRSxa9AVLRoFQvPkSc4OXcuXQ6rV2q9WGRzS0LORrdceNjQkOILCXcpGYokE3Rguo7IxhoB+fCo2F2DCS1qY3HgNZOoJRhGsMkzyrQHC9HbNG1gKc8gZ2CTmVnFarLMnDrz87uRY88z/UC+AWrATykmTHMk5EfFpaf+7RCQNHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191306; c=relaxed/simple;
	bh=3Pl6b3IcfLaOk9SncErUbM0ewtggkRIuq2bRudekJPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEpwXYeRiP7LQMRJ3/+fQGu1KsERWHTwlgtiv5/32HD7yJC+CvnNrClJb+nBJVnPPsEytr73q1Iq8lhaQwsFQJd8+4b3Rp2eQEmsSmSeHl4oC766j8rNKeJunn5acLk9Gx6UuG8lDFmbK/SPIsFZKyMZjZotCKrFO5AZhbISoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uidedSh7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uidedSh7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0204152B;
	Mon,  5 Oct 2026 02:08:19 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4B8AD3F66F;
	Mon,  5 Oct 2026 02:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191303; bh=3Pl6b3IcfLaOk9SncErUbM0ewtggkRIuq2bRudekJPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uidedSh7VjfWeBJvEzyNrbIo8g3HhNa2oXBHrw47omZL3yFr0zWLDaeaCQswZfHlk
	 VKTE33/zLew747EeloXCbRRGtfwqKnyAcbi5OWXP9FdU42pCAGpdkL83suzQUkqYEM
	 kWnavECYKVptWg2RVI5YLw54TAC82bPvKXdA628o=
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
Subject: [PATCH v22 05/23] KVM: arm64: Track the type of VM in kvm_arch
Date: Mon,  5 Oct 2026 10:07:36 +0100
Message-ID: <20261005090754.2140522-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
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

While at it move the psci_version around to keep the structure packed.

Suggested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v21:
 - Drop kern_hyp_va() and restrict nvhe code to always use vcpu_is_protected_pkvm()
 - Drop kvm_vm_is_unprotected_pkvm() and open code the check
 - Move psci_version field in kvm_arch around to keep the structure packed
---
 arch/arm64/include/asm/kvm_host.h      | 42 +++++++++++++++++++++++---
 arch/arm64/include/asm/kvm_pkvm.h      |  4 +--
 arch/arm64/kvm/arm.c                   | 33 ++++++++++++++++----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  6 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c       |  4 +--
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     |  2 +-
 arch/arm64/kvm/mmio.c                  |  1 +
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/arm64/kvm/pkvm.c                  |  6 ++--
 10 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 286489a69dff5..dedb5df15a803 100644
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
 
@@ -1504,9 +1513,32 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+/*
+ * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
+ * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
+ * which is populated correctly. Always vcpu_is_protected_pkvm(), which is
+ * gated on is_protected_kvm_enabled().
+ */
+#define vcpu_is_protected(vcpu)		BUILD_BUG_ON(1)
+#else
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
+#endif
+
+#define kvm_vm_is_protected_pkvm(kvm)					\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
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
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c904647d2f760..0acd78f4bc223 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -57,7 +57,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
-	return vcpu_is_protected(&hyp_vcpu->vcpu);
+	return vcpu_is_protected_pkvm(&hyp_vcpu->vcpu);
 }
 
 static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
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
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f36..2a3e6d83682d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -217,7 +217,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(vcpu_is_protected(vcpu)))
+	if (unlikely(vcpu_is_protected_pkvm(vcpu)))
 		return pvm_exit_handlers;
 
 	return hyp_exit_handlers;
@@ -238,7 +238,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * it.  The check below is based on the one in
 	 * kvm_arch_vcpu_ioctl_run().
 	 */
-	if (unlikely(vcpu_is_protected(vcpu) && vcpu_mode_is_32bit(vcpu))) {
+	if (unlikely(vcpu_is_protected_pkvm(vcpu) && vcpu_mode_is_32bit(vcpu))) {
 		/*
 		 * As we have caught the guest red-handed, decide that it isn't
 		 * fit for purpose anymore by making the vcpu invalid. The VMM
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9930657169133..17bd1ff621ab6 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -48,7 +48,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	 * or running a protected VM (we don't offset anything in this case).
 	 */
 	clr = CNTHCTL_EL1PCEN;
-	if (vcpu_is_protected(vcpu) ||
+	if (vcpu_is_protected_pkvm(vcpu) ||
 	    !timer_get_offset(vcpu_ptimer(vcpu)))
 		set |= CNTHCTL_EL1PCTEN;
 	else
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

