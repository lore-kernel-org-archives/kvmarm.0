Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46A7384CD6;
	Wed, 15 Jul 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125780; cv=none; b=PUnDpbW8GM0gTSSK6xc0aAvcZiexeMq/MgbD83s1738yPr8bDd+ykXich+zhXTtvfgbe29x9dLR7qsHB19JGYkwLYRrLE//NjDNlfQ3MBmFkVtyzw6DheIvJFfoWBMfvNuUqzGUzix2tLvOqWoT2sPhyScm3QkLkypeAhoaRYOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125780; c=relaxed/simple;
	bh=zixYPQ+w+37O4gvY4lHd1xlI1aPi6dhUKtIpVG5gxWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmpmOSBcnPJgQ8UM5irnXAcnJxzJiZTSMp/Xs7ySNvrwSzCK6y3QAJfx8aPNQJS0UR9OEb/1x+MLjUbgnp77oHULGPwAFY+4DtHAxpBgmprFCZGgHHNb4fOjvQw7nkm8un0/myKWtti9aVtafZY998DCNyFK1UjIa7OiJRmkMNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q1n9fhcR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q1n9fhcR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C2071576;
	Wed, 15 Jul 2026 07:29:34 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B5793F7B4;
	Wed, 15 Jul 2026 07:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125778; bh=zixYPQ+w+37O4gvY4lHd1xlI1aPi6dhUKtIpVG5gxWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1n9fhcRpdoIR0XGyMLVabJHxznFgtVeFu8FAxAQEoRf7pA+4j6bcsRZkT4KUojOj
	 GGkSMq4IbgZ7ckgLDg78LeZO5+1tW+RYerumDWb4A7DxgeknRB7cgihtfMozrMxlSr
	 UD5G7ag5jwn25TRuKcdYYk18bfyoMTLVAsN3z7MU=
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
Subject: [PATCH v15 09/37] KVM: arm64: CCA: Allow passing the machine type in KVM creation
Date: Wed, 15 Jul 2026 15:28:11 +0100
Message-ID: <20260715142841.80544-10-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously machine type was used purely for specifying the physical
address size of the guest. Reserve the higher bits to specify an ARM
specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
used to create a realm guest.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v13:
 * Rework to use the two top bits for the machine type now that pKVM has
   merged and used the top bit for KVM_VM_TYPE_ARM_PROTECTED.
 * Update the documentation to include KVM_VM_TYPE_ARM_PROTECTED as
   well.
Changes since v9:
 * Explictly set realm.state to REALM_STATE_NONE rather than rely on the
   zeroing of the structure.
Changes since v7:
 * Add some documentation explaining the new machine type.
Changes since v6:
 * Make the check for kvm_rme_is_available more visible and report an
   error code of -EPERM (instead of -EINVAL) to make it explicit that
   the kernel supports RME, but the platform doesn't.
---
 Documentation/virt/kvm/api.rst | 18 ++++++++++++++++--
 arch/arm64/kvm/arm.c           | 11 +++++++++++
 include/uapi/linux/kvm.h       |  7 ++++++-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b38e090ad95d..e39d146b34a3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -181,8 +181,22 @@ flag KVM_VM_MIPS_VZ.
 ARM64:
 ^^^^^^
 
-On arm64, the physical address size for a VM (IPA Size limit) is limited
-to 40bits by default. The limit can be configured if the host supports the
+On arm64, the machine type identifier is used to encode a type and the
+physical address size for the VM. The lower byte (bits[7-0]) encode the
+address size and the upper bits[30-31] encode a machine type. The machine
+types that might be available are:
+
+ =========================   ============================================
+ KVM_VM_TYPE_ARM_NORMAL      A standard VM
+ KVM_VM_TYPE_ARM_REALM       A "Realm" VM using the Arm Confidential
+                             Compute extensions, the VM's memory is
+                             protected from the host.
+ KVM_VM_TYPE_ARM_PROTECTED   A "protected" VM using pKVM to isolate the
+                             VM from the host.
+ =========================   ============================================
+
+The physical address size for a VM (IPA Size limit) is limited to 40bits
+by default. The limit can be configured if the host supports the
 extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
 KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
 identifier, where IPA_Bits is the maximum width of any physical
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6f39831dcf5d..9881fd6c511c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -249,6 +249,17 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif
 
+	if ((type & KVM_VM_TYPE_ARM_PROTECTED) &&
+	    (type & KVM_VM_TYPE_ARM_REALM))
+		return -EINVAL;
+
+	if (type & KVM_VM_TYPE_ARM_REALM) {
+		if (!static_branch_unlikely(&kvm_rmi_is_available))
+			return -EINVAL;
+		kvm_set_realm_state(kvm, REALM_STATE_NONE);
+		kvm->arch.is_realm = true;
+	}
+
 	kvm_init_nested(kvm);
 
 	ret = kvm_share_hyp(kvm, kvm + 1);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0231ff174a50..adee3936d6ae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -700,14 +700,19 @@ struct kvm_enable_cap {
  * address size for the VM. Bits[7-0] are reserved for the guest
  * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
  * value 0 implies the default IPA size, 40bits.
+ *
+ * Bits[30-31] are reserved for the VM type
  */
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 
+#define KVM_VM_TYPE_ARM_NORMAL		0
+#define KVM_VM_TYPE_ARM_REALM		(1UL << 30)
 #define KVM_VM_TYPE_ARM_PROTECTED	(1UL << 31)
 #define KVM_VM_TYPE_ARM_MASK		(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
-					 KVM_VM_TYPE_ARM_PROTECTED)
+					 KVM_VM_TYPE_ARM_PROTECTED | \
+					 KVM_VM_TYPE_ARM_REALM)
 
 /*
  * ioctls for /dev/kvm fds:
-- 
2.43.0

