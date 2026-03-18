Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7A13DB635;
	Wed, 18 Mar 2026 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849360; cv=none; b=FNlWybMqgpcvZzWA2kSu99aRi09+Ej9z9zLYLS8UbdT3P/wYilijBDQv+hzfv7oYk4i283+d3fw8LMW+z/ImXgWyOG3n2Ic6fwt1zVBBQVTno8yrKidTOJe03usL9ped1jY6+AT4K+e14KF06M2upmi9HKw0Cuzw5gPRegnQVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849360; c=relaxed/simple;
	bh=r54vVojRYi1BpmUl04G2e4ittTJNEjOjag3bz8lVVkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc+fJn5oUw4T14X8wf8hVRJB8Ysj9NRXQYKUUrYfaf/uMIr4Gg7dxFYph93cUpIwqthZUDRjexhzt7333OLkLQE1rVYXzgfB7O8ifkXjjyVdJEwh1oIuVguFaRrlbEDE6LKijVpRH91L5fM39JXmd/NBniGXZ+XtD+rpPzAV3+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E574201B;
	Wed, 18 Mar 2026 08:55:47 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 182023F73B;
	Wed, 18 Mar 2026 08:55:49 -0700 (PDT)
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
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 24/48] arm64: RMI: Allow populating initial contents
Date: Wed, 18 Mar 2026 15:53:48 +0000
Message-ID: <20260318155413.793430-25-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
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
 arch/arm64/kvm/rmi.c             | 111 +++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 46b0cbe6c202..bf663bb240c4 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -96,6 +96,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
 int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
 int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 
+struct kvm_arm_rmi_populate;
+
+int kvm_arm_rmi_populate(struct kvm *kvm,
+			 struct kvm_arm_rmi_populate *arg);
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   unsigned long size,
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 1cac6dfc0972..b495dfd3a8b4 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
 	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index badb94b398bc..43d05da7e694 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2089,6 +2089,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
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
index 13eed6f0b9eb..b48f4e12e4e0 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -718,6 +718,80 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
 		realm_unmap_private_range(kvm, start, end, may_block);
 }
 
+static int realm_create_protected_data_page(struct kvm *kvm,
+					    unsigned long ipa,
+					    kvm_pfn_t dst_pfn,
+					    kvm_pfn_t src_pfn,
+					    unsigned long flags)
+{
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	phys_addr_t dst_phys, src_phys;
+	int ret;
+
+	dst_phys = __pfn_to_phys(dst_pfn);
+	src_phys = __pfn_to_phys(src_pfn);
+
+	if (delegate_page(dst_phys))
+		return -ENXIO;
+
+	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
+	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+		/* Create missing RTTs and retry */
+		int level = RMI_RETURN_INDEX(ret);
+
+		KVM_BUG_ON(level == RMM_RTT_MAX_LEVEL, kvm);
+
+		ret = realm_create_rtt_levels(realm, ipa, level,
+					      RMM_RTT_MAX_LEVEL, NULL);
+		if (!ret) {
+			ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys,
+						    flags);
+		}
+	}
+
+	if (ret) {
+		if (WARN_ON(undelegate_page(dst_phys))) {
+			/* Undelegate failed, so we leak the page */
+			get_page(pfn_to_page(dst_pfn));
+		}
+	}
+
+	return ret;
+}
+
+static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+			      struct page *src_page, void *opaque)
+{
+	unsigned long data_flags = *(unsigned long *)opaque;
+	phys_addr_t ipa = gfn_to_gpa(gfn);
+
+	if (!src_page)
+		return -EOPNOTSUPP;
+
+	return realm_create_protected_data_page(kvm, ipa, pfn,
+						page_to_pfn(src_page),
+						data_flags);
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
+	mutex_lock(&kvm->slots_lock);
+	mmap_read_lock(current->mm);
+	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
+				populate_region_cb, &data_flags);
+	mmap_read_unlock(current->mm);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 enum ripas_action {
 	RIPAS_INIT,
 	RIPAS_SET,
@@ -815,6 +889,43 @@ static int realm_ensure_created(struct kvm *kvm)
 	return -ENXIO;
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
+	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
+	    !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
+	    !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
+		return -EINVAL;
+
+	ret = realm_ensure_created(kvm);
+	if (ret)
+		return ret;
+
+	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
+		data_flags |= RMI_MEASURE_CONTENT;
+
+	pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
+					  args->size >> PAGE_SHIFT,
+					  args->source_uaddr, data_flags);
+
+	if (pages_populated < 0)
+		return pages_populated;
+
+	args->size -= pages_populated << PAGE_SHIFT;
+	args->source_uaddr += pages_populated << PAGE_SHIFT;
+	args->base += pages_populated << PAGE_SHIFT;
+
+	return 0;
+}
+
 static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.43.0

