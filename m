Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320AC53ED01;
	Thu,  1 Oct 2026 21:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888910; cv=none; b=Xo+ev0hV6lWMLL+JOUH1BGN9a1/ym3uFnBpT4hfomsJe4tIs/E8rHmfnj6PQH8RX1yFpX9Y2gN20VEsZW9dObkr1ENxBHmkQMy+2Es7YCzESFBrzIPlP6Ul+HacQaddLxn2zBUuWUZ+rDOGGPXOLu7HKWmZhUUL6OiDPjE7yEcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888910; c=relaxed/simple;
	bh=jYs/CqVgb12982hl8QqakH6rehAK8MWESQyc8PenYOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8n8SjWcWvVQJcYult7HJmA+YS/0dCd+nf1VNs6nUXcxBerrnW2P0xCMTT0Bx7k1ZDVuMHbFl7cKuZZnvvxAhDWtDw5NkmgsdOIqkyDd1MIGlnF0nxCXDfa+TtfFi8wiqV+SxUyS9wRW1n6ph2QJKNZ3VhgX+q1+HH71eRiwz0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p0XIubY/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p0XIubY/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FBFE1476;
	Thu,  1 Oct 2026 14:08:24 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 28BFA3F86F;
	Thu,  1 Oct 2026 14:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888907; bh=jYs/CqVgb12982hl8QqakH6rehAK8MWESQyc8PenYOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0XIubY/PFVflolwkAdYdwQWClehjsRmRhYopyJe924bCiEr+j3njoRw3/ikoG82g
	 DZssMvZgqJYULyg+BINGUAJcvXQnfXejhC1YrqF3V25hVFrtBTByQv3NXWd029rgQx
	 P0m4We7zgkrpc9A6WJuUA9Nt4wArfaTdQwcy4/yg=
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
Subject: [PATCH v21 18/23] KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests
Date: Thu,  1 Oct 2026 22:06:58 +0100
Message-ID: <20261001210703.1597150-19-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001210703.1597150-1-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Limit the capabilities that are allowed for Realm VMs. Similarly block
the vm_ioctls backed by the capabilities.

Repurpose the kvm_pkvm_ioctl_allowed() to support both pKVM and Realm
ioctls. Rename the helper to kvm_vm_ioctl_allowed() and move it
into arch/arm64/kvm/arm.c. Also add a generic kvm_vm_ext_allowed()
to handle pKVM and Realm capability filtering and route them accordingly.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v20:
 * Allow KVM_CAP_DEVICE_CTRL for Realm, to allow SMCCC filtering
Changes since v18:
 * Bail out early for !pKVM && !Realm vms. Use kvm_vm_hyp_is_distrusting()
 * WARN_ON_ONCE(!kvm), we are only called from kvm_arch_vm_ioctl() with a
   valid kvm instance.
 * Move the kvm_realm_ext_allowed() to asm/kvm_rmi.h - Fuad
 * Rename kvm_arch_vm_*allowed => kvm_vm_*_allowed - Fuad
Changes since v17:
 * Drop superfluous !kvm check from kvm_vm_ioctl_enable_cap() - Sashiko
 * Drop KVM_CAP_CREATE_IRQCHIP, as we don't support VGIC_V2 for Realms
 * Filter out the vm_ioctls that are based on blocked cap.
 * Repurpose the pkvm plumbing for filtering the caps and ioctl to generic
   and plumb the Realm support in
Changes since v13:
 * Add missing check in kvm_vm_ioctl_enable_cap().
Changes since v10:
 * Add a kvm_realm_ext_allowed() function which limits which extensions
   are exposed to an allowlist. This removes the need for special casing
   various extensions.
Changes since v7:
 * Remove the helper functions and inline the kvm_is_realm() check with
   a ternary operator.
 * Rewrite the commit message to explain this patch.
---
 arch/arm64/include/asm/kvm_pkvm.h | 19 ------------
 arch/arm64/include/asm/kvm_rmi.h  | 24 +++++++++++++++
 arch/arm64/kvm/arm.c              | 49 +++++++++++++++++++++++++++++--
 3 files changed, 70 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index e4ea80711bec6..1bc4fe2726e9b 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -53,25 +53,6 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	}
 }
 
-/*
- * Check whether the KVM VM IOCTL is allowed in pKVM.
- *
- * Certain features are allowed only for non-protected VMs in pKVM, which is why
- * this takes the VM (kvm) as a parameter.
- */
-static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
-{
-	long ext;
-	int r;
-
-	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
-
-	if (WARN_ON_ONCE(r < 0))
-		return false;
-
-	return kvm_pkvm_ext_allowed(kvm, ext);
-}
-
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 44f5c75a27b5b..ea1450e0c8619 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <linux/kvm.h>
+
 /**
  * enum realm_state - State of a Realm
  *
@@ -58,4 +60,26 @@ struct realm {
 
 void kvm_init_rmi(void);
 
+static inline bool kvm_realm_ext_allowed(long ext)
+{
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_DEVICE_CTRL:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+	case KVM_CAP_MSI_DEVID:
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+	case KVM_CAP_ARM_SVE:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+	case KVM_CAP_SYNC_MMU:
+		return true;
+	}
+	return false;
+}
+
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0e77f59ded6d9..106b52e556e20 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -136,6 +136,49 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+static inline bool kvm_vm_ext_allowed(struct kvm *kvm, long ext)
+{
+	/*
+	 * We could be called with kvm as NULL, so can't use kvm_vm_* for pKVM
+	 * flavors
+	 */
+	if (is_protected_kvm_enabled())
+		return kvm_pkvm_ext_allowed(kvm, ext);
+	else if (kvm && kvm_vm_is_realm(kvm))
+		return kvm_realm_ext_allowed(ext);
+	else
+		return true;
+}
+
+/*
+ * Check whether the KVM VM IOCTL is allowed. For pKVM and Realm VMs, certain
+ * ioctls are not allowed. Further, certain features are allowed only for
+ * non-protected VMs in pKVM.
+ */
+static inline bool kvm_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
+{
+	long ext;
+	int r;
+
+	/*
+	 * We are guaranteed to be called with a valid kvm instance, as the
+	 * only caller is kvm_arch_vm_ioctl(). Catch any deviations, as we
+	 * rely on the kvm instance below.
+	 */
+	if (WARN_ON_ONCE(!kvm))
+		return false;
+
+	/* Cover both pKVM host and Realm VMs */
+	if (!kvm_vm_hyp_is_distrusting(kvm))
+		return true;
+
+	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
+	if (WARN_ON_ONCE(r < 0))
+		return false;
+
+	return kvm_vm_ext_allowed(kvm, ext);
+}
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -144,7 +187,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (cap->flags)
 		return -EINVAL;
 
-	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
+	if (!kvm_vm_ext_allowed(kvm, cap->cap))
 		return -EINVAL;
 
 	switch (cap->cap) {
@@ -403,7 +446,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
-	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
+	if (!kvm_vm_ext_allowed(kvm, ext))
 		return 0;
 
 	switch (ext) {
@@ -2144,7 +2187,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct kvm_device_attr attr;
 
-	if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, ioctl))
+	if (!kvm_vm_ioctl_allowed(kvm, ioctl))
 		return -EINVAL;
 
 	switch (ioctl) {
-- 
2.43.0

