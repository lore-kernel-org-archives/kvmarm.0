Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8FC29B214
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648833; cv=none; b=ooP3wJCxuYwDvhgsiUKq9hjdz3qOGbR5M1FrALC4T/1q6ELssKc7tvLKXtbSqK8sBmVy4unCsqrirUtLRuduWxVWOAiXn9SAYojNf/kw/iy2JB8GtJ5E/ot7vgp56ySO5p+f9RrfOsYZGou7MVCbQQnc9gyAeKjWyFD9bR00A7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648833; c=relaxed/simple;
	bh=hpf2XueJIoNKejpgsS6eEy+779j23jPnOsrhXYz7b+s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dSFQAA2tTu2JIQF7ujjO6Gs7UZP9Vyb2oCwkeuOvWp3gLUn47eHeXz9eoo4lsve5xwL2/20oyNKifZgY7h8lWwL4AFoAjdUU5ZLu+gC19WjMbUYgwsNbSLnvuGhw+rukjOq9smkahA4uuDXh5PdkV4OLYQjPGIbNZwSuTeqo+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kdekqocq; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kdekqocq"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so4365736f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648829; x=1750253629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GhEdb4XSRH5QZbPC7u52jNBRkWh7Zb0cdMH+s2fESHE=;
        b=kdekqocquTWkX9fGlM9F7BGcbjMTqzAjnBtLjyG7TasPtjHrsA8WYCwocfMa9UTTVU
         VoXXWLtMMbGpJPjwxhKrkZGgQhwtvfCq/FVgtjR0WFnzCffOTvjnuSohm8P8RN+Rr/Na
         nUS6P/1c1eWwACOsEB/2nT2kSqHK9JGMLIMntjpX5y2xwiU4pMfYfNuDsW9LqRrv2yMB
         Lay0Vy1chaCMsaHrW4hHLPr5uRApG4KODt13zOb6IEUsNa6ANI81fqe0aXWqlz97Pa95
         USzFFnvRRMikDVbhSGUIBXdFX3hr9zzp5/gjvP2uQ+LotM6N1urfHJb7fqW4N2TzFMaF
         kgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648829; x=1750253629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GhEdb4XSRH5QZbPC7u52jNBRkWh7Zb0cdMH+s2fESHE=;
        b=o6JuQ3XmqC7VnMIn35Qmf7JYcJapPmPdcXL0IWGiXAbfHldIV0sFCo8Tpizz1mjq/g
         gcW0cYDgV9k7qDIBMhYattcLiwmsFVfZdSTzEwUKP9O7SwsvfCQD29TYpIA1z+GE0tA7
         symnlqX7M6QekZ/yMLuMFfaYR2TmH+4zXKSL+Udlrf5VW87OnEGP7PA4Go5RQgS8ttLv
         jUcWSBt7jILzPNegBMk7dvMdt34fVvd4UcIVcloXWqKCz+0qXzygJ7bDr4JIYj16qtYS
         41sOG3/5wiS65GOG6eDevyTjr+P3WZxksgfe9vNsM7ypxBINNB1B8Da2bojNW0RYGJA4
         GNBg==
X-Forwarded-Encrypted: i=1; AJvYcCXyEGtR0vKO5KPcFL4sxz2amazPOUw+EgT+9UYhgYXU70J7D2mSmJyKDGtu+XVIuX6zV+DxEXk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxV6EVrvFeFkbPfedy//MBV//MBDMRcgwlzV/updFBA2vs63fun
	zxjta5KYbMlMZbndroHrfvUIKbUtf9QeyMiyMtmQXQc4d6tUmeW8VP22uCS8bJPgZQSNlbil/30
	sCg==
X-Google-Smtp-Source: AGHT+IHEd86idQu16yNMsd/8yL8nqu5HVRSk9EU79tULRTu402KZNrREDQmVRg+XHZj/Hl7vzp0Q2cBjwQ==
X-Received: from wma7.prod.google.com ([2002:a05:600c:8907:b0:441:aaa8:fb65])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1a87:b0:3a5:1c3c:8d8d
 with SMTP id ffacd0b85a97d-3a558af983fmr2481697f8f.55.1749648828461; Wed, 11
 Jun 2025 06:33:48 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:20 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-9-tabba@google.com>
Subject: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
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

This patch enables support for shared memory in guest_memfd, including
mapping that memory from host userspace.

This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
flag at creation time.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 13 +++++++
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         |  4 +++
 virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9a6712151a74..6b63556ca150 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Returns true if this VM supports shared mem in guest_memfd.
+ *
+ * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
+ * guest_memfd is enabled.
+ */
+#if !defined(kvm_arch_supports_gmem_shared_mem)
+static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d00b85cb168c..cb19150fd595 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 559c93ad90be..e90884f74404 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GMEM
+
+config KVM_GMEM_SHARED_MEM
+       select KVM_GMEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6db515833f61..06616b6b493b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_shared(struct inode *inode)
+{
+	const u64 flags = (u64)inode->i_private;
+
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
+		return false;
+
+	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+}
+
+static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
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
+	.fault = kvm_gmem_fault_shared,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!kvm_gmem_supports_shared(file_inode(file)))
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
@@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_supports_gmem_shared_mem(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.50.0.rc0.642.g800a2b2222-goog

