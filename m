Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA5A421250;
	Mon,  3 Aug 2026 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764720; cv=none; b=PPXagnY1mzKJPQO02lWVpzYpEMqcB75LxTatQTKXU70BKh3xazYFOHUmljiSwe8JbIy/Vb2psxoCzYnBW6FJqMn/xxfIIwIqEoe4+hs4tE34QXG1d41x7QjT44d/g+VeB/0GZ3IAXUi1/l4QedCjMPBqnWXv95RYbiqDs2TatWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764720; c=relaxed/simple;
	bh=W+mj+aqPxD9OUiQlGZIDCnrFnQ+H1UYPLtwRXKLa5sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie30Ywp2+0FlM007LWiAFupBND5LZZfIj+bcsTHIPFrQy4HSA7690CI1hLqsk8fOlF0zauCuXOv13UxLay8S+v4jQNAK64DlAnoBSHkM+q/EU2zy3fHYvZ2InIReBUVoRuPqvGUwd7UpiWTqAwLD9pR4yCKMCu6QgR8OEfqYbTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YvuycBeb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YvuycBeb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E04E143D;
	Mon,  3 Aug 2026 06:45:14 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A31F3F66F;
	Mon,  3 Aug 2026 06:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764718; bh=W+mj+aqPxD9OUiQlGZIDCnrFnQ+H1UYPLtwRXKLa5sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvuycBeb1X/WazYVlz1m2L9thez4M3rMZVzDqDbLfY278Cz6/+TbaTmglWNDDfXHC
	 1lH3jHSV8Ca4WpPjhI88b9w6t3/59d0oSTPzD1TCDPzWYXvoSqFFegaLwniGmW9mml
	 8EEvf7kRoHMvoUHEe0vl4a/wN/xewJPb4+a0qfIg=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 13/45] KVM: arm64: CCA: Define the user ABI
Date: Mon,  3 Aug 2026 14:43:29 +0100
Message-ID: <20260803134403.80630-14-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is one CAP (KVM_CAP_ARM_RMI) which identifies the presence of CCA,
and one ioctl.  The ioctl (KVM_ARM_RMI_POPULATE) is used to populate
memory during creation of the realm as this requires the RMM to copy
data from an unprotected address to the protected memory - CCA does not
support shared <-> private memory conversion where the memory contents
is preserved as this is incompatible with memory encryption.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Expand KVM_ARM_RMI_POPULATE documentation to be explicit that
   in-place shared-to-private conversion isn't supported.
Changes since v13:
 * KVM_ARM_VCPU_RMI_PSCI_COMPLETE removed.
 * KVM_ARM_RMI_POPULATE documentation updated to reflect that the
   structure is written by the kernel.
 * CAP number bumped.
Changes since v12:
 * Change KVM_ARM_RMI_POPULATE to update the structure with the amount
   that has been progressed rather than return the number of bytes
   populated.
 * Describe the flag KVM_ARM_RMI_POPULATE_FLAGS_MEASURE.
 * CAP number is bumped.
 * NOTE: The PSCI ioctl may be removed in a future spec release.
Changes since v11:
 * Completely reworked to be more implicit. Rather than having explicit
   CAP operations to progress the realm construction these operations
   are done when needed (on populating and on first vCPU run).
 * Populate and PSCI complete are promoted to proper ioctls.
Changes since v10:
 * Rename symbols from RME to RMI.
Changes since v9:
 * Improvements to documentation.
 * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
Changes since v8:
 * Minor improvements to documentation following review.
 * Bump the magic numbers to avoid conflicts.
Changes since v7:
 * Add documentation of new ioctls
 * Bump the magic numbers to avoid conflicts
Changes since v6:
 * Rename some of the symbols to make their usage clearer and avoid
   repetition.
Changes from v5:
 * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
   KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
---
 Documentation/virt/kvm/api.rst | 47 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 13 ++++++++++
 2 files changed, 60 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1de6fd5fc88c..ce588c05b26a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6642,6 +6642,44 @@ if the guest_memfd memory was pinned in IOMMU page tables.
 
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
+4.146 KVM_ARM_RMI_POPULATE
+--------------------------
+
+:Capability: KVM_CAP_ARM_RMI
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_rmi_populate (in/out)
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_arm_rmi_populate {
+	__u64 base;
+	__u64 size;
+	__u64 source_uaddr;
+	__u32 flags;
+	__u32 reserved;
+  };
+
+Populate the guest address range described by `base` and `size` with data from
+the userspace buffer at `source_uaddr`. The guest_memfd range backing the
+memory must have `KVM_MEMORY_ATTRIBUTE_PRIVATE` set.
+
+Arm CCA cannot perform an in-place shared-to-private conversion while
+preserving memory contents. Therefore, `source_uaddr` must be a valid,
+page-aligned userspace pointer. The operation uses `RMI_RTT_DATA_MAP_INIT`,
+which also sets the region to `RIPAS_RAM`.
+
+This is only valid before any VCPUs have been run. The ioctl might not populate
+the entire region and in this case the kernel updates the fields `base`, `size`
+and `source_uaddr`. User space may have to repeatedly call it until `size` is 0
+to populate the entire region.
+
+`flags` can be set to `KVM_ARM_RMI_POPULATE_FLAGS_MEASURE` to request that the
+populated data is hashed and added to the guest's Realm Initial Measurement
+(RIM) stored by the RMM. This can then be retrieved by the guest (using the RSI
+interface) to present to an attestation server.
+
 .. _kvm_run:
 
 5. The kvm_run structure
@@ -9025,6 +9063,15 @@ enabled, cmma can't be enabled anymore and pfmfi and the storage key
 interpretation are disabled. If cmma has already been enabled or the
 hpage_2g module parameter is not set to 1, -EINVAL is returned.
 
+7.48 KVM_CAP_ARM_RMI
+--------------------
+
+:Architectures: arm64
+:Target: VM
+:Parameters: None
+
+This capability indicates that support for CCA realms is available.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 129d6f630325..0231ff174a50 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -998,6 +998,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_S390_HPAGE_2G 249
 #define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 250
+#define KVM_CAP_ARM_RMI 251
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1686,4 +1687,16 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+/* Available with KVM_CAP_ARM_RMI, only for VMs with KVM_VM_TYPE_ARM_REALM */
+#define KVM_ARM_RMI_POPULATE	_IOWR(KVMIO, 0xd7, struct kvm_arm_rmi_populate)
+#define KVM_ARM_RMI_POPULATE_FLAGS_MEASURE	(1 << 0)
+
+struct kvm_arm_rmi_populate {
+	__u64 base;
+	__u64 size;
+	__u64 source_uaddr;
+	__u32 flags;
+	__u32 reserved;
+};
+
 #endif /* __LINUX_KVM_H */
-- 
2.43.0

