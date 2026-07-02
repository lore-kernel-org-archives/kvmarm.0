Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03D24DB56E
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002582; cv=none; b=V9cHwtJldwAgAdy9S5umsq/t/z4Y9lGdNyyoC1u/dX+HbkjWMElVG2XtUfxKSKpdZ/KhCr5+OvbuzbU2fRWKS9Q5P0sMDz4Z5BrhLd8UbNzMMylgEGfuKi3mnR2dCtvhzZUp3TB7AdbH+sC1WHJEQj4a9BQcTYFFmhB6qHiNX8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002582; c=relaxed/simple;
	bh=w+NbXwKAIW7ubnglHnIYpYU4wgga2hwuJJ22J62RMhE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyPZy9dKBK2spXMhrI4c8LyFJO1SmnicZEJQ4hjQ9HSe7bN2/IKmHun1yEXZ/RIRMkpHPoLqd0uTJt8HeWdL+kCaM8h/L4wBV9J0DYOjEVTEQFWzXMW3NjMcgMBNv1wX/uVCmCAHBjS0ZTkIqDVvL7p1/d0xCpnsmHzspYRb96g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dyikDXoM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dyikDXoM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B034B35A9;
	Thu,  2 Jul 2026 07:29:35 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14D143F673;
	Thu,  2 Jul 2026 07:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783002580; bh=w+NbXwKAIW7ubnglHnIYpYU4wgga2hwuJJ22J62RMhE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dyikDXoMmatQc4kbecYjPHK+sjxUtKJu9fZ7dqWWWLF5EwO3YkW4ojNEJ+bjKhOuT
	 IKJSHuVGDPGJnyv1cUkulMXf/r9d3BBJh7eQnk4cZmaeLfyd/s1ucUrtmvC++QqVwa
	 s5ufSILacqw3WrVX+mmjf+1gOjRYIiGKMVSgP4D8=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	seanjc@google.com,
	david.hildenbrand@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com
Subject: [RFC PATCH 3/3] KVM: arm64: Allow dirty page logging for guest_memfd-only memslots
Date: Thu,  2 Jul 2026 15:29:12 +0100
Message-ID: <20260702142912.6395-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702142912.6395-1-alexandru.elisei@arm.com>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place to allow dirty page logging for guest_memfd-only
memslots, advertise it to userspace.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/arm.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/mmu.c |  3 ++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..e92e5d7b533a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -393,6 +393,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
 	case KVM_CAP_ARM_SEA_TO_USER:
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	case KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -493,6 +496,25 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_arch_supports_gmem_mmap_dirty_logging(struct kvm *kvm)
+{
+	/*
+	 * Protected pKVM VMs don't allow dirty page logging, fail early here
+	 * instead of in kvm_arch_prepare_memory_region().
+	 *
+	 * KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES is not available for a
+	 * protected pKVM VM, and returning false means that
+	 * KVM_SET_USER_MEMORY_REGION2 fails with EINVAL, which is consistent
+	 * with unsupported memslot flags.
+	 */
+	if (!is_protected_kvm_enabled())
+		return true;
+
+	return kvm_pkvm_ext_allowed(kvm, KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES);
+}
+#endif
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..f6e6de153ce2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1648,7 +1648,8 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		return ret;
 	}
 
-	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY) &&
+	    (!kvm_slot_dirty_track_enabled(s2fd->memslot) || write_fault))
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
-- 
2.43.0

