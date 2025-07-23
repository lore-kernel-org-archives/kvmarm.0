Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FF22DFA46
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267649; cv=none; b=noIWv9+2Q+bGMC1D43DNZWAGTn/lNSZVaxcJG/qRtwlERz6Y27akmaV8vCtWVfqQCrJNQotniWKbhKDuKhduyvOzSUwGmGENoNK5Kq49HbpC0FiY7JyX9CDwM3D+FUyePma3qya9UhoMcXXcpwlrxsobyFO2gc7H8a5DByxvobw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267649; c=relaxed/simple;
	bh=QyxuUTWdkqfWwCRIlgMMsPpjhtM2I7WKCTsedQOzWL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=giC2z5z2w+xaUfuZzmgh/JjmYbRrU/OAmrnShWui24FXvt+kPiRfoPmp9jRHusTAtLhH7fwaqogxdDK9cvUuCyTSzog6QgpvolDH4rwB9jTxvCbXgSWNmyGrG7wOYF1s8rTiNi48mC+bQGe+YZ4duwzYBhLvFHTVEGLk+Wa8MTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RSbBTEVi; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RSbBTEVi"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a58939191eso2794976f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267645; x=1753872445; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fcETzHTWiEWR8GOIStOaS7XhZknr1voGGAhaPeQn9wI=;
        b=RSbBTEVipKeQfV3I7Y0Edl/ZqHt6EUPW4wh/BSOU333+PRpKkLQAsKvHO5E6WjCgLL
         5SJ1G1GeLAdtQCkydutJS6awn4V2JPhTp90KxcOj63P7Jq5GwGDYuHJDPzOIsfQJeX6r
         c788YIYPrUm6cvOW6KvrahQ8ftFxikn8JfApzJ94HBAFhWDcS3fylrflJyOu8+SQdf4Y
         sucAUm7MSyQZ9MK/U9Yv5r9n/wLLcahYXHyC6nd+hCQB6RCdyqU80+Q2s/RUraiU9mZV
         D4qN6bTe8SrUr7I2hQI48lR/6SL1/KQxWzND2fhaMveGec2eJ0y65mG8BSBitTHb+3e2
         4j+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267645; x=1753872445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcETzHTWiEWR8GOIStOaS7XhZknr1voGGAhaPeQn9wI=;
        b=jV5st0eqo6xCnaLO7lTTHV03RYQLUqdjbP0M0VZy4wOTRWa58Tsr7JeM7KPt4bNPMG
         z33+CfN2lPkZaBAbkVhkpwifJkNmSASoBJWf+aYd39Waj9SzXcJcRf4b+fiK8f3HeVOX
         SgeVmMpECq2ReKXjn6Xv5+hO/POov9m6bFR70ufUCRptqh1/aqEhNJD73h0dzzGnTgYz
         KjJ0sIO8TkkQ6W3mhE0EkjUomDcdZmtR6NLpGyv2PSc9iX33lzcfh/d7jHSp1RVpRxgy
         qbHuBKxkAPI91b2YdIWwaS8JLzfMOu7bK3TxX2SI+OhYWxRWRvLmMR5Zn8i+9f7GKozt
         TqeA==
X-Forwarded-Encrypted: i=1; AJvYcCWl1Bw5njYbHHSl6MSnYuDtVnl7UwTE8DH34sEvniNqDES0ESZvilXj1ASFuWW52FDY/MyGh7s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+QarVRmaPU1nJDrbD4OQNQePDa1m6FYOTYnQYB100Tvxd1LKO
	xtm1Ox2dawV6CSTJfYA7MOsnoV2MLIqfGvFwAz1sjRUaTwrrU65whYZOoqLs+AuUtLO1ktxuGRM
	xEQ==
X-Google-Smtp-Source: AGHT+IEe44MXl/ytA6bQwQoEc18ccfi02+HhAg/vYEYD6fmTIl5PZmuGxIaMa7BS20QwG080yszRIEU/kg==
X-Received: from wrbfx9.prod.google.com ([2002:a05:6000:2d09:b0:3a5:2220:5be3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:230d:b0:3b3:9c56:b834
 with SMTP id ffacd0b85a97d-3b768c9d38dmr1845396f8f.1.1753267645473; Wed, 23
 Jul 2025 03:47:25 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:02 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-11-tabba@google.com>
Subject: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

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
2.50.1.470.g6ba607880d-goog

