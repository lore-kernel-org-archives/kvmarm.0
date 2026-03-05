Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173F73A7F72
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721955; cv=none; b=C6LIlA9jugD71v/nT4LfjHgAqaFNg9haL5jBYbHd8jPdbuj8PjGuhO9ArAy5M5nNCglwcH23NKoOh6VTN2zHQ95ftNDf0i+c+VYKc3lbRtH9am4i10MzN6mIQtvrLXmd+Yp1oqXSBjVPL8XLgyjbkxKma6979Qmg3beznl9KxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721955; c=relaxed/simple;
	bh=VQdIsZC5GfRSg/vKbiwcTXem/SqGLlNtcZq7UMf4eDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXxl04RYokB2ie7yOlaknL86rE9jB4d0Be+PAsjoJkfbgC5gTbdfgpv0Fi82oDbOq9LFoXU6zv5rzKEiLvV5Uwt4J/Y9a2nyWytIbzeMsC6jL7ycNlQDvkBf95E55hQbYYkohHrD5ZeWqEGV+l31O+zOx+VU93Xay9t6TUVS4jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzIfdT/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzIfdT/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E149DC2BCB3;
	Thu,  5 Mar 2026 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721954;
	bh=VQdIsZC5GfRSg/vKbiwcTXem/SqGLlNtcZq7UMf4eDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzIfdT/XLng0DYfnf80ryTE063ykp+nj/5yYUI2/pgHzwCuHXWgVIEdyJV8Bk1gAF
	 s3cIxAtSbPDsphj/nXhwURUSRfG4LzAKjR9G9K7Zo/KqiOYn4TqErpohzgt6bobicc
	 BCTHRCta++cgVGD9mLPWt6B1n4yJFet96KS9OBF2PIGipKk11GoRJxDWiqWTZs/Dwa
	 0cNV+pAAD4DyFyrD5Lj3JneLOqfcjzblf2zK+mv2o8FDHPw7Q0Oygxdz6+6XAmQMct
	 6rKEqRhSZTosFjyQE/PnpuEAj4gjG/AiiOlzt2uiHtap9vlN5bulP7a4RCwGKHXkRX
	 r4JRTJQ/b7OZw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 30/36] KVM: arm64: Allow userspace to create protected VMs when pKVM is enabled
Date: Thu,  5 Mar 2026 14:43:43 +0000
Message-ID: <20260305144351.17071-31-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new VM type for KVM/arm64 to allow userspace to request the
creation of a "protected VM" when the host has booted with pKVM enabled.

For now, this depends on CONFIG_EXPERT and results in a taint on first
use as many aspects of a protected VM are not yet protected!

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h |  2 +-
 arch/arm64/kvm/Kconfig            | 10 ++++++++++
 arch/arm64/kvm/arm.c              |  8 +++++++-
 arch/arm64/kvm/mmu.c              |  3 ---
 arch/arm64/kvm/pkvm.c             | 11 ++++++++++-
 include/uapi/linux/kvm.h          |  5 +++++
 6 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 7041e398fb4c..2954b311128c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,7 +17,7 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
-int pkvm_init_host_vm(struct kvm *kvm);
+int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 7d1f22fd490b..e71f7fb6e89a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -82,4 +82,14 @@ config PTDUMP_STAGE2_DEBUGFS
 
 	  If in doubt, say N.
 
+config PROTECTED_VM_UAPI
+	bool "Expose protected VMs to userspace (experimental)"
+	depends on KVM && EXPERT
+	help
+	  Say Y here to enable experimental (i.e. in development)
+	  support for creating protected virtual machines using KVM's
+	  KVM_CREATE_VM ioctl() when booted with pKVM enabled.
+
+	  Unless you are a KVM developer, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3589fc08266c..c2b666a46893 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -203,6 +203,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	if (type & ~KVM_VM_TYPE_ARM_MASK)
+		return -EINVAL;
+
 	mutex_init(&kvm->arch.config_lock);
 
 #ifdef CONFIG_LOCKDEP
@@ -234,9 +237,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		 * If any failures occur after this is successful, make sure to
 		 * call __pkvm_unreserve_vm to unreserve the VM in hyp.
 		 */
-		ret = pkvm_init_host_vm(kvm);
+		ret = pkvm_init_host_vm(kvm, type);
 		if (ret)
 			goto err_uninit_mmu;
+	} else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
+		ret = -EINVAL;
+		goto err_uninit_mmu;
 	}
 
 	kvm_vgic_early_init(kvm);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4e64528d86a6..7655e4c61c4e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -881,9 +881,6 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index da0a45dab203..d1eb6e23367e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -219,9 +219,13 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm)
 	mutex_unlock(&kvm->arch.config_lock);
 }
 
-int pkvm_init_host_vm(struct kvm *kvm)
+int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
+	bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
+
+	if (protected && !IS_ENABLED(CONFIG_PROTECTED_VM_UAPI))
+		return -EINVAL;
 
 	if (pkvm_hyp_vm_is_created(kvm))
 		return -EINVAL;
@@ -236,6 +240,11 @@ int pkvm_init_host_vm(struct kvm *kvm)
 		return ret;
 
 	kvm->arch.pkvm.handle = ret;
+	kvm->arch.pkvm.is_protected = protected;
+	if (protected) {
+		pr_warn_once("kvm: protected VMs are for development only, tainting kernel\n");
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 65500f5db379..50348efe3384 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -699,6 +699,11 @@ struct kvm_enable_cap {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+#define KVM_VM_TYPE_ARM_PROTECTED	(1UL << 31)
+#define KVM_VM_TYPE_ARM_MASK		(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
+					 KVM_VM_TYPE_ARM_PROTECTED)
+
 /*
  * ioctls for /dev/kvm fds:
  */
-- 
2.53.0.473.g4a7958ca14-goog

