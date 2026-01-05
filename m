Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554493074B1
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628271; cv=none; b=VyQZgoSed//U/lCH0mH9jSyvIrNOInPQk+OugVcyWb9D35FEgFQah5jHL40FEC+fDGudMEoDUX4VzwvxS1MKF+E8vwVdyRB4zMc6730l+3rUqL9wN31dW6Cgu49tTwFe5nQIbRwnxfaOiW6NzHnh3mhZHFIpwBaoTkBIsGwdljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628271; c=relaxed/simple;
	bh=PIpPot3/pD5boU8yFENrmwU3G9yh83bvfpd7l2yKSuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aT5yJXOMR+8yt+3hrnEBeOaROa14IIKY1+3McziOm19DU0d2wA/fya5kGehu2fsIAAW9sOMgrbbCpqIly8JFKNetKxI/13pQtnca6Pit+Gz3YQ3jNAHfuxDZyLEruk0p8PYfbwg8/jqXMtvIwJVP7z6cF/CXsniOO/6crXWgmkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rSGSPNUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSGSPNUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F75DC116D0;
	Mon,  5 Jan 2026 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628270;
	bh=PIpPot3/pD5boU8yFENrmwU3G9yh83bvfpd7l2yKSuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSGSPNUbL2hvK9MU8TEnvyTJ6aWhN/RYDnGXpOtHAfYOGSTcMQASlCDRPAcibyOCu
	 jV9OZ/KbkhkFIVJzP5DwRLAX37KD+071ryOjOhWRFIMZO/WFoQPpyxRWXT67mH6mvw
	 70Ld7RpkfPABHlTUIP1zgKuokZAKxa52e4/2MCOYGESXVtJbvQba+OtmBCh5bZJCcb
	 HdV9Cez9epDIvhI2QGiD4JsTlInVQEHn5rRBvxnUERPeEOg5bP+Es8UPQGQbJcXX2p
	 k4577eZ5YdQgezr3x7xwS7YrofrntquU23jBJ5fZEV4jcLqJUZrFgB08oCuuZuCMjl
	 HWFVMTTBztUjQ==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 26/30] KVM: arm64: Allow userspace to create protected VMs when pKVM is enabled
Date: Mon,  5 Jan 2026 15:49:34 +0000
Message-ID: <20260105154939.11041-27-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
index 5a71d25febca..507d9c53e2eb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -16,7 +16,7 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
-int pkvm_init_host_vm(struct kvm *kvm);
+int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 4f803fd1c99a..47fa06c9da94 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -83,4 +83,14 @@ config PTDUMP_STAGE2_DEBUGFS
 
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
index 4f80da0c0d1d..66f472774da7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -157,6 +157,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	if (type & ~KVM_VM_TYPE_ARM_MASK)
+		return -EINVAL;
+
 	mutex_init(&kvm->arch.config_lock);
 
 #ifdef CONFIG_LOCKDEP
@@ -188,9 +191,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		 * If any failures occur after this is successful, make sure to
 		 * call __pkvm_unreserve_vm to unreserve the VM in hyp.
 		 */
-		ret = pkvm_init_host_vm(kvm);
+		ret = pkvm_init_host_vm(kvm, type);
 		if (ret)
 			goto err_free_cpumask;
+	} else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
+		ret = -EINVAL;
+		goto err_free_cpumask;
 	}
 
 	kvm_vgic_early_init(kvm);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fafedcbd516d..3c7aca86961d 100644
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
index 14865907610c..6d6b1ef1cc62 100644
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
index dddb781b0507..9316a827a826 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -689,6 +689,11 @@ struct kvm_enable_cap {
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
2.52.0.351.gbe84eed79e-goog

