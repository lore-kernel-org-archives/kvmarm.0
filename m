Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9439B429812;
	Wed, 13 May 2026 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678385; cv=none; b=k28/ufiQhW+utftrVNNBBVOeM/EKpD3Yu8whhnxUu3VMAUnejzrl8apBaIoOAD3TCWOznlsVGW+gf5R4shdNkcivOeQjaobYn1K8QvieLR7iSJ/9lTq2QGYx8alcV0TG+72YiQ7JnFQiXbITjvhE3UPRWhtPeOUcAQ7mrYnUuS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678385; c=relaxed/simple;
	bh=xNaWtn8WVTxOvUcxuFEDgDbFnMMoLd5CjZXcFr0CCxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr8IZ++nLztkgUvqUlLkbQvek3Zuu/B7meWgcrRsV2ujii1N2BlGuECIcWbFrOjkCy7Tia+JOZnNtZnN6ScB4fJVCbwvKUQGha/QmXPir2ge9I/ObVKUHrC/Dn8itacCGnfVf1EtbuXr6rjhSa/0egxfj88nHrSfd86TEW1E6qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vZhQcG0a; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vZhQcG0a"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99C422444;
	Wed, 13 May 2026 06:19:38 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3EF83F836;
	Wed, 13 May 2026 06:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678383; bh=xNaWtn8WVTxOvUcxuFEDgDbFnMMoLd5CjZXcFr0CCxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZhQcG0ahSzAcJncs+tF0qXpFPLiZbGmJcGhg0QACTEJgcnf9uKL86nFkofqd2Zxk
	 WSqRAPyBrhorIHA05/QW49Zbc7NQPsfoisCr9eRxmK5K/MZaq46T/QUmc8IO2Pmj4X
	 DPv5Wv181FdEQgX+GxWo3aiQEs628GEnAJmUPJds=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v14 15/44] kvm: arm64: Don't expose unsupported capabilities for realm guests
Date: Wed, 13 May 2026 14:17:23 +0100
Message-ID: <20260513131757.116630-16-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

RMM v2.0 provides no mechanism for the host to perform debug operations
on the guest. So limit the extensions that are visible to an allowlist
so that only those capabilities we can support are advertised.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
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
 arch/arm64/kvm/arm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 18251e561524..c6ebc5913e40 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -133,6 +133,25 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+static bool kvm_realm_ext_allowed(long ext)
+{
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+	case KVM_CAP_MSI_DEVID:
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+	case KVM_CAP_ARM_RMI:
+		return true;
+	}
+	return false;
+}
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -144,6 +163,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
 		return -EINVAL;
 
+	if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(cap->cap))
+		return -EINVAL;
+
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 0;
@@ -378,6 +400,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
 		return 0;
 
+	if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(ext))
+		return 0;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
-- 
2.43.0

