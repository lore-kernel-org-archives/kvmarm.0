Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65332BE7AB
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829749; cv=none; b=tjzIv+FwDYDB/k0Vi4p37bj5/8xzV/Lm9CJ+toPeOWhVPthsR1dPm3DUzqcRYQtMy29eAPahONs1CCQ3TWi7z1e1GaE/l4kvGWCssN/Pmr1cCi6e7L8uGIiTMb8nZC6fUXSWG99RqLJgBUDE8Ubp6KJdPOwiSbpGHcFBamMP6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829749; c=relaxed/simple;
	bh=Xbe974jAg04TIW9HfK3Y4I+nikYFzuKAbkXN+KFWFPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n78wbaglQbmX3LLCNnSGUXEWZmW0CzoHHRMrBFGhfZfba9Wy4jT6V00L/WoQxAXO1Mo7xcaTWJ8MZDa+LQAY7yB+BBldfAAkzM/sDwFbpbbExMAjonNH+VbX6LhXua4JuBBLRljHXWkUkVLVKGkLea8HhBPWSkLf2LgSGVzk7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xArr34VK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xArr34VK"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-237e6963f70so105911915ad.2
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829747; x=1754434547; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tn1mSBLO+YLVwstEyyon9JR/mQU0lWjJcGUdOXFvVvs=;
        b=xArr34VK5WcaE+Kk1HKFeh0d7Ytws6lZBFAGVBdaCRJ63m7mcC2aIL3Eppz652OAJq
         rvFWAsPlw8Q7bvJwb6SeRYhxzyH6t+IZIhKZsxGnG+Ae7nNFREWAasXY1tct1130xyIG
         PtcrLK44y+AlromI8X/kmsawTlHdvP2FveGubdWN1CDgvC7KRAekyRjAtWvFKjd3I6mp
         3ltbnOqUJNl+15nnV8ALKDIsCh5nRvCr/sHNUIr9cfhWwRqvNd41+gk7+TAdIm9TDYQf
         vjIvsn5SDPKwurpNIkMQLCJCLNXhFAjTedaogHAPdykpsirT667SjtQ1Tpb3n8zEhIF4
         /fKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829747; x=1754434547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tn1mSBLO+YLVwstEyyon9JR/mQU0lWjJcGUdOXFvVvs=;
        b=Qe6S9+sNCWmCtpL+F+bP4tLN5SfF4G3QG6B1IMxYvBkhMRVg20vjKrGN8/TczoUhuO
         8B93jKMuvOGDeZa3Xy243J2AxZSkDnrKz86xTb1AC+2VpzgtXIrKpOQBgq3T6iAoclcC
         pTcwpRN0fuyF7UB24HtqJX+KmKF1oGz4Ajv1OFzVA+sem8ZDccSQQWBAeO289tzTOV2G
         wD+KJ0oDL4thvHfsmNMxCwS9DID5bzgT8gj+HqZ3OPB83wY4LHakfms+DWgYUtTqAhpi
         Ptx0KiqXzaU4PpkGLNTeN/dRr7JC/nxUeAi2CHZ7vI3yzKIAHTia5vOsHA5B9bANAvEq
         QyKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcSvfSUwlklG28b30UG1MjOjB0d3iU32rVSnzbtTcH72alypgETZ79/7NpFtKLsGR85521NzY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5YUd67RIGpZ2m+8wzBq72bbqacr+m6Y+LDDKY+qLekCkHxbV4
	GcAgK83hR881Ny/vUlQsNrzNWJhJdeKWrqZBZnum7NY/9tscBy7mEqPg9zY2AnqTc1m8JMEynDy
	hzTeN1Q==
X-Google-Smtp-Source: AGHT+IHAFJZIedsHoBlxMRk1Os6nimsUyZRbs4o25k9lGhNMmtWWfdhx2zaS8kMkKKU+mHoV57Vx/+pszAo=
X-Received: from pjk4.prod.google.com ([2002:a17:90b:5584:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d505:b0:240:6740:6b11
 with SMTP id d9443c01a7336-24096b0faa3mr13034795ad.40.1753829746789; Tue, 29
 Jul 2025 15:55:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:41 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-11-seanjc@google.com>
Subject: [PATCH v17 10/24] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Introduce the core infrastructure to enable host userspace to mmap()
guest_memfd-backed memory. This is needed for several evolving KVM use
cases:

* Non-CoCo VM backing: Allows VMMs like Firecracker to run guests
  entirely backed by guest_memfd, even for non-CoCo VMs [1]. This
  provides a unified memory management model and simplifies guest memory
  handling.

* Direct map removal for enhanced security: This is an important step
  for direct map removal of guest memory [2]. By allowing host userspace
  to fault in guest_memfd pages directly, we can avoid maintaining host
  kernel direct maps of guest memory. This provides additional hardening
  against Spectre-like transient execution attacks by removing a
  potential attack surface within the kernel.

* Future guest_memfd features: This also lays the groundwork for future
  enhancements to guest_memfd, such as supporting huge pages and
  enabling in-place sharing of guest memory with the host for CoCo
  platforms that permit it [3].

Enable the basic mmap and fault handling logic within guest_memfd, but
hold off on allow userspace to actually do mmap() until the architecture
support is also in place.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
[3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 11 +++++++
 include/linux/kvm_host.h |  4 +++
 virt/kvm/guest_memfd.c   | 70 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..e5cd54ba1eaa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+/*
+ * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
+ * (the private vs. shared tracking needs to be moved into guest_memfd).
+ */
+bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return !kvm_arch_has_private_mem(kvm);
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
@@ -13531,6 +13541,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	kvm_x86_call(gmem_invalidate)(start, end);
 }
 #endif
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d1c44622056..26bad600f9fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -726,6 +726,10 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a99e11b8b77f..67e7cd7210ef 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,72 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_mmap(struct inode *inode)
+{
+	return false;
+}
+
+static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct folio *folio;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return VM_FAULT_SIGBUS;
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (IS_ERR(folio)) {
+		int err = PTR_ERR(folio);
+
+		if (err == -EAGAIN)
+			return VM_FAULT_RETRY;
+
+		return vmf_error(err);
+	}
+
+	if (WARN_ON_ONCE(folio_test_large(folio))) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		kvm_gmem_mark_prepared(folio);
+	}
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+
+out_folio:
+	if (ret != VM_FAULT_LOCKED) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return ret;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault_user_mapping,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!kvm_gmem_supports_mmap(file_inode(file)))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -391,6 +456,11 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
+bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return true;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	const char *anon_name = "[kvm-gmem]";
-- 
2.50.1.552.g942d659e1b-goog

