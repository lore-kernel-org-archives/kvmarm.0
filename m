Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC11472F87;
	Sun, 20 Sep 2026 21:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939765; cv=none; b=EUJynf2MEq9GqGXYnOWFwIg7Rb7+DS1CG2fbN19N0iIKW2g2+AyMd5SvkBRt3lqltaDK2gFHHqBmXGFXWQuRuSBt7PLOLHrdLRolaQ/unWvObqVbwEzvQgrl6Ulw6QTFZ4nTA09Wy3geAri+NRkhkTMWvHCJHlkTnLbRfvvEI2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939765; c=relaxed/simple;
	bh=JgXE0rr4qyjcXJrQNfZT66xw8lalmDIFDQaKP8JhxgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAVpUsBzsaqlm7tGWuhSRDMSuQewNABJ4c4aWk67sTmehRhPrqMae2sL27CL6Ba8AHa+kbKwpgWwzjblsitRk9bXgFyVUrRJ2AJ+bWs0ufpEEsNGrW5Ueoyggg7A8+KsdQ58+j8rqHvOV0B/e3CbgsEbDh0ifJDnH/mPdPiCDB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VB+DU5Z4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VB+DU5Z4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60F081596;
	Sun, 20 Sep 2026 14:29:14 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 268FC3F632;
	Sun, 20 Sep 2026 14:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939757; bh=JgXE0rr4qyjcXJrQNfZT66xw8lalmDIFDQaKP8JhxgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB+DU5Z4tLYk/1V+rYNt4Xtj9IfCefxJgsb3EAue9TZQb5GyKRNVq45XW89+x67Vq
	 RnN4XyvaDMrgp3UQvEQ7OPLZmmldJeyyX2R0ksaW4lyFBwMeLcMJuih6v/JLv0Cd0z
	 pf86AclXVC0PI9b0lBoCwLRt0dZtZr8NXwSSyRns=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v19 05/20] KVM: arm64: Track the type of VM in kvm_arch
Date: Sun, 20 Sep 2026 22:28:30 +0100
Message-ID: <20260920212845.707-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
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
that we are about to add.

Adds __VM_PROTECTED marker vm flavor to generalize kvm_vm_is_protected()
to predicate all confidential guests running on KVM. In later patches, we
would add Realm VMs, which would also be classified as protected.

Add explicit helper to detect if a given VM is a "protected" VM under pKVM.
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

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
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
 arch/arm64/include/asm/kvm_host.h | 22 +++++++++++++++++++---
 arch/arm64/include/asm/kvm_pkvm.h |  4 ++--
 arch/arm64/kvm/arm.c              | 31 ++++++++++++++++++++++++++-----
 arch/arm64/kvm/handle_exit.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 +++++-
 arch/arm64/kvm/mmu.c              |  2 +-
 arch/arm64/kvm/pkvm.c             |  6 ++----
 7 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 286489a69dff5..9b1cf9c59e81f 100644
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
+	VM_FLAVOR_MAX,
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
+	enum kvm_arm_vm_flavor vm_flavor;
 	/*
 	 * Fine-Grained UNDEF, mimicking the FGT layout defined by the
 	 * architecture. We track them globally, as we present the
@@ -1504,10 +1513,17 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
-
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
+#define kvm_vm_is_protected_pkvm(kvm)		\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
+#define vcpu_is_protected_pkvm(vcpu)	kvm_vm_is_protected_pkvm(vcpu->kvm)
+
+#define kvm_vm_is_unprotected_pkvm(kvm)		\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
+
+
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
index db36815630790..8c784b266a8e8 100644
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
index 459bd9eb7e4bc..57e2eef6d7426 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -432,7 +432,11 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
-	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
+	if (kvm_vm_is_protected(host_kvm))
+		hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
+	else
+		hyp_vm->kvm.arch.vm_flavor = VM_PKVM;
+
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 
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

