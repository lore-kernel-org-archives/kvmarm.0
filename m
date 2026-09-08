Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F39E577E33;
	Tue,  8 Sep 2026 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884581; cv=none; b=roahnEza7oKOgB4glZB1vcKE3F8xH4UGOs2oUUeZvNOID7hK4sxrB1nK9vV6OyM8kDthBT3kEOJB1v8Uv23ljI5b3DwAdiUoyEvFGLgogjTiNk2LIbnSbvN7nr1JIwh22Kgam0Xn3kwECd+HioR+wg+tdRJs0+SnsKPgowcgcns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884581; c=relaxed/simple;
	bh=8GFagwRPNrqblRIlYkC7acPkqx1bS3/JF6XjcUKUqO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJSZVsiJQo2RaLnlbuHmMnLRElAk5ChJQiKYrJ3ohQ7C6h0WR2pvRcyfiS7uy6KKxXa/z5UBTN6SgcuelezzfIMKD/HXXsQWXet7azgpDShVNjkRVf7pLAGmAWz6jKF0z+RX+URzzSr/XW5d78oN0d7VD6SX+MBum6dc73d3Ts4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E6wgGKzz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E6wgGKzz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C73C11476;
	Tue,  8 Sep 2026 09:22:55 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 309E03F7B4;
	Tue,  8 Sep 2026 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884579; bh=8GFagwRPNrqblRIlYkC7acPkqx1bS3/JF6XjcUKUqO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6wgGKzzvkAm7qWkNdDzcTLCWVILzEKx8FaZ55mPGxTS3qkHmTWVG3qKp6ztR3IlV
	 u0NaBfDDwmEShoghB3FHOFJV4gF01ilq8hSHP3wz8F0aBv0+uUK9gKv0WXiGsjnog2
	 tweZ+2Ah9PwinwedbxAeXSah3eu7w5xAn5PX0b8w=
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
Subject: [PATCH v17 03/20] KVM: arm64: Track the type of VM in kvm_arch
Date: Tue,  8 Sep 2026 17:22:06 +0100
Message-ID: <20260908162223.1683432-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM arm64 has different types of VMs with all the different modes in which the
hypervisor code can be run. e.g., VHE, nVHE, PKVM etc. Then there is protected
VM and normal VMs with PKVM. We might soon add other types, e.g., Arm CCA Realm.
So in an effort to make the handling of these different types of VMs a bit more
friendlier to the eyes, add a VM flavor to the kvm_arch and we could then add
handlers for different operations based on the VM type.

Keep the flavor initialisation at the beginning to allow for the detection
early enough and fail out on any unsupported requests. (e.g., protected on !PKVM)

With that, use the vm_flavor to detect if a VM is protected VM on PKVM.

Based on a patch by Marc Zyngier

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++++--
 arch/arm64/kvm/arm.c              | 27 ++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +-
 arch/arm64/kvm/pkvm.c             |  1 -
 4 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7a..d0dccc9ad6aa8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -257,7 +257,6 @@ struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
-	bool is_protected;
 	bool is_created;
 
 	/*
@@ -306,9 +305,18 @@ enum fgt_group_id {
 	__NR_FGT_GROUP_IDS__
 };
 
+enum kvm_arm_vm_flavor {
+	VM_NVHE,
+	VM_VHE,
+	VM_PKVM,		/* Normal guests on PKVM */
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
@@ -1504,7 +1512,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
 
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..67f1ff9bc4fbe 100644
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
@@ -260,9 +284,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		ret = pkvm_init_host_vm(kvm, type);
 		if (ret)
 			goto err_uninit_mmu;
-	} else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
-		ret = -EINVAL;
-		goto err_uninit_mmu;
 	}
 
 	kvm_vgic_early_init(kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..09961c0056f2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -432,7 +432,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
-	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
+	hyp_vm->kvm.arch.vm_flavor = READ_ONCE(host_kvm->arch.vm_flavor);
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec123..3948fa46f4d75 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -240,7 +240,6 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
 		return ret;
 
 	kvm->arch.pkvm.handle = ret;
-	kvm->arch.pkvm.is_protected = protected;
 	if (protected) {
 		pr_warn_once("kvm: protected VMs are experimental and for development only, tainting kernel\n");
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-- 
2.43.0

