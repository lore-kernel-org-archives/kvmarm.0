Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF70431A33;
	Mon,  3 Aug 2026 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764786; cv=none; b=dh8p90eYs/PVzk7MJvdphrojpuZjhFEwoDB6TYGrgjeJfGpcjLU2a/BxRxu2yLzmPM1MNqs5J1GxvgqoxsJQNqMBxGeQT+6BJyj0H2Jlz3t5dyK1Enas+n7SxJ5SgoLGGbezmlu1ziGhtWdhBFdF/uAuAWsVQGUKYjdlSPfII+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764786; c=relaxed/simple;
	bh=eKE4/Sm5/GuxJ8UFVqD6W1rOa6RVJlIeYRdiWlAXcYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZigbDDfS3L99jX1buyQu8rZwVX+wBGmsq7wudExKVp4gvxNIwmKszJW35baoRkcj30BlZl0fCUgoN1LwwNyZALxkOvhvnZP24pMAZ03iukRMpCCq734PYwQJ9pmDjhfsJfWramaDE137yVcdyJ5v3P9UGanru92c+xmq5xIo9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lnKop/iQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lnKop/iQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 327EE1476;
	Mon,  3 Aug 2026 06:46:20 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3CEB3F66F;
	Mon,  3 Aug 2026 06:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764784; bh=eKE4/Sm5/GuxJ8UFVqD6W1rOa6RVJlIeYRdiWlAXcYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnKop/iQ1vBgwO3c98+NFveOLzdZl5BN79cNYbyzjdR0a5hDnfW+j44/XXRARHA1F
	 MnJAghBGoIZx63J99eUKA+YLh71dsj20fxRkv5vZoZLEwwgzb52ROJTE9HtVnOdsYl
	 1YaophYOu1qIb8iM84RtUxb7aCN6sJywHCpAQ+fY=
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
Subject: [PATCH v16 27/45] KVM: arm64: CCA: Allow populating initial contents
Date: Mon,  3 Aug 2026 14:43:43 +0100
Message-ID: <20260803134403.80630-28-steven.price@arm.com>
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

The VMM needs to populate the realm with some data before starting (e.g.
a kernel and initrd). This is measured by the RMM and used as part of
the attestation later on.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Handle negative error codes
Changes since v14:
 * Holding of locks slots_lock and config_lock have been moved up the
   callstack with lockdesp assertions placed in the lower functions.
 * Add overflow check into kvm_arm_rmi_populate().
Changes since v13:
 * Rename realm_create_protected_data_page() to realm_data_map_init().
Changes since v12:
 * The ioctl now updates the structure with the amount populated rather
   than returning this through the ioctl return code.
 * Use the new RMM v2.0 range based RMI calls.
 * Adapt to upstream changes in kvm_gmem_populate().
Changes since v11:
 * The multiplex CAP is gone and there's a new ioctl which makes use of
   the generic kvm_gmem_populate() functionality.
Changes since v7:
 * Improve the error codes.
 * Other minor changes from review.
Changes since v6:
 * Handle host potentially having a larger page size than the RMM
   granule.
 * Drop historic "par" (protected address range) from
   populate_par_region() - it doesn't exist within the current
   architecture.
 * Add a cond_resched() call in kvm_populate_realm().
Changes since v5:
 * Refactor to use PFNs rather than tracking struct page in
   realm_create_protected_data_page().
 * Pull changes from a later patch (in the v5 series) for accessing
   pages from a guest memfd.
 * Do the populate in chunks to avoid holding locks for too long and
   triggering RCU stall warnings.
---
 arch/arm64/include/asm/kvm_rmi.h |   4 ++
 arch/arm64/kvm/Kconfig           |   1 +
 arch/arm64/kvm/arm.c             |  13 ++++
 arch/arm64/kvm/rmi.c             | 119 +++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 90563183a717..03f8bd2d13a2 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -108,6 +108,10 @@ int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 int kvm_rec_handle_request(struct kvm_vcpu *vcpu);
 bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret);
 
+struct kvm_arm_rmi_populate;
+
+int kvm_arm_rmi_populate(struct kvm *kvm,
+			 struct kvm_arm_rmi_populate *arg);
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   unsigned long size,
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 189e8ad78b22..83b95e836b4d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	select ARM_RMM
 	help
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b7c308817d45..f1b26b263bf0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2154,6 +2154,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			return -EFAULT;
 		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
 	}
+	case KVM_ARM_RMI_POPULATE: {
+		struct kvm_arm_rmi_populate req;
+		int ret;
+
+		if (!kvm_is_realm(kvm))
+			return -ENXIO;
+		if (copy_from_user(&req, argp, sizeof(req)))
+			return -EFAULT;
+		ret = kvm_arm_rmi_populate(kvm, &req);
+		if (copy_to_user(argp, &req, sizeof(req)))
+			return -EFAULT;
+		return ret;
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index c8ec766d3dc0..d18c241f7eb2 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -609,6 +609,76 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
 		realm_unmap_private_range(kvm, start, end, may_block);
 }
 
+static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
+			       kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
+			       unsigned long flags)
+{
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	phys_addr_t dst_phys, src_phys;
+	long ret;
+
+	lockdep_assert_held(&kvm->slots_lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	dst_phys = __pfn_to_phys(dst_pfn);
+	src_phys = __pfn_to_phys(src_pfn);
+
+	if (rmi_delegate_page(dst_phys))
+		return -ENXIO;
+
+retry:
+	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
+	if (ret >= 0 && RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+		/* Create missing RTTs and retry */
+		int level = RMI_RETURN_INDEX(ret);
+
+		KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);
+
+		ret = realm_create_rtt_levels(realm, ipa, level,
+					      level + 1, NULL);
+		if (!ret)
+			goto retry;
+	}
+
+	if (ret && WARN_ON(rmi_undelegate_page(dst_phys))) {
+		/* Leak the page if the undelegate fails */
+		get_page(pfn_to_page(dst_pfn));
+	}
+
+	return ret <= 0 ? ret : -ENXIO;
+}
+
+static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+			      struct page *src_page, void *opaque)
+{
+	unsigned long data_flags = *(unsigned long *)opaque;
+	phys_addr_t ipa = gfn_to_gpa(gfn);
+
+	return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
+				   data_flags);
+}
+
+static long populate_region(struct kvm *kvm,
+			    gfn_t base_gfn,
+			    unsigned long pages,
+			    u64 uaddr,
+			    unsigned long data_flags)
+{
+	long ret = 0;
+
+	lockdep_assert_held(&kvm->slots_lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!uaddr)
+		return -EINVAL;
+
+	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
+				false, populate_region_cb, &data_flags);
+
+	return ret;
+}
+
 enum ripas_action {
 	RIPAS_INIT,
 	RIPAS_SET,
@@ -727,6 +797,55 @@ static int realm_ensure_created(struct kvm *kvm)
 	return realm_create_rd(kvm);
 }
 
+int kvm_arm_rmi_populate(struct kvm *kvm,
+			 struct kvm_arm_rmi_populate *args)
+{
+	unsigned long data_flags = 0;
+	unsigned long ipa_start = args->base;
+	unsigned long ipa_end = ipa_start + args->size;
+	long pages_populated;
+	int ret;
+
+	if (args->reserved ||
+	    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
+	    args->base + args->size < args->base ||
+	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
+	    !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
+	    !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
+		return -EINVAL;
+
+	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
+		data_flags |= RMI_MEASURE_CONTENT;
+
+	mutex_lock(&kvm->slots_lock);
+	mutex_lock(&kvm->arch.config_lock);
+
+	ret = realm_ensure_created(kvm);
+	if (ret)
+		goto out_unlock;
+
+	if (args->size == 0)
+		goto out_unlock;
+
+	pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
+					  args->size >> PAGE_SHIFT,
+					  args->source_uaddr, data_flags);
+
+	if (pages_populated < 0) {
+		ret = pages_populated;
+		goto out_unlock;
+	}
+
+	args->size -= pages_populated << PAGE_SHIFT;
+	args->source_uaddr += pages_populated << PAGE_SHIFT;
+	args->base += pages_populated << PAGE_SHIFT;
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
+}
+
 static int kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.43.0

