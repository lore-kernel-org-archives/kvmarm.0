Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953E822A4E8
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137902; cv=none; b=R7Z3ofct8us3jc7u/4Vov/vNjdD6fQBBiVIQiFpLb0w71QNIk+T06CG/SUhRtLdQ1UjxkfemoocF27QiCVrwJ7KTWygGX58ebxGHO2bQi6k4O7Ew5DzE/n9lHIEVO7AiroXNcpq4pKhdfx1Okcm4Ya8RWUY5v2aKFUe1lw9r69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137902; c=relaxed/simple;
	bh=KeVoYtk1YfTE/wzFysihsCLmJLEbzerBsVgvKKHm9O0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NgZkbsJUIJOshGDVi2XB76a3uhXY7ra+EwmnM8Fz6qz6kjNooxF9pqeMNACSit5b9k3jVDZlOWahZ+HsVzBwWkRdSqUpTUHeY7nYSK8RR6I2NL5l4vqxDRw4RF8IDaiD9tsfmyTta7NgOM94hy587RLS/g05MskbIYlM54O7Pcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=20zPNsUH; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="20zPNsUH"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-440667e7f92so8343145e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137899; x=1749742699; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R4e32WJa+B4iCwI5nu4RLLyxxyZ6wYBS+apA8IG1UJc=;
        b=20zPNsUHrDoIbRxJdHjbveUyubYQBGYvOrkPLgY0iE/94J4OCh1l/Nr7m/BZivdJhL
         aDler5NY7p68psCJv0T1ZDdA8qHAFD0LRLm+a6LS+YVi2FfeDxfMwAiNy2n0x7I9CqrR
         tcNOYcq6ANHc3d1VQBU8FxmEOjrW/nDRIWyEuFIc1j6nAu4Ge+8Jg3kCn3vmzXyASxHK
         SjnwXANxI5ChtmdyqaT2PXompgRA1D//yMHwoK5plJyYzZscNzawvlCd4sYtE0TD1His
         WNjT4vmU57ROwnutD8Y9zerJc5RTOk7LcVxpJK3RYGZUn+0BSUtDLs2JbNrMUjILAuw7
         4Ynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137899; x=1749742699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4e32WJa+B4iCwI5nu4RLLyxxyZ6wYBS+apA8IG1UJc=;
        b=q67OdyqLc9uCRMUyS1r+zhpZZk06NsZWTi5d8Mvm/yOi0cyMdK3JKe/lmng1Nn8R6P
         /Un6GIKz9if+cWnwJYJEzsISLJ384qt0EYpeF63rDqhzuhUEeDffxGyjPxxmmFcZg0WJ
         pF2YVBKIyiRskqpPcMXti61EngBdvykntHYg3P0Jhd/4Y3ZDN31VrazCsjDGc5lipl23
         AxFFLrzejKBJUhrbGvz6AO4qBkgtAPEMfteKs9rwLR1dZsOf7xKMMA8a89pNEqf/P3WP
         30U+phYxflkRxmsKm4PHXzA8EUY9nEqqewZ8gz5zTyC7WuREixIVLSIlZrhVM4cQNcZy
         6I1g==
X-Forwarded-Encrypted: i=1; AJvYcCU16fJpSW3xTDkv3cCFgXkkXWvZskv5Jcep4P/ccAEmk9p4dlMeLvhfF6kCRg5DJTUwZlKujeA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdZEYxF0cgjDg8H+ut98bzARsxXygznBMvTcwdlxb9pfipDbsD
	a8l9kfOIHAhblP1ATwrjqgS2voR9WOZjqUIs8FHAN5n9nP0+vSDnCHwLZu/t4GHxmC2C86ZnW3K
	24Q==
X-Google-Smtp-Source: AGHT+IFsSXSPsIzzjG8cSs5qmMKIcMNndtU6bT4BIo+LmuAUzRynITV3oecnA+zrz7m1ALSccrGRPAfFeQ==
X-Received: from wmbel20.prod.google.com ([2002:a05:600c:3e14:b0:450:d104:29f8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1986:b0:442:ff8e:11ac
 with SMTP id 5b1f17b1804b1-451f0a74b01mr79236105e9.12.1749137899065; Thu, 05
 Jun 2025 08:38:19 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:50 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-9-tabba@google.com>
Subject: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
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

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 13 +++++++
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         |  4 +++
 virt/kvm/guest_memfd.c   | 76 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 80371475818f..640ce714cfb2 100644
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
index b6ae8ad8934b..c2714c9d1a0e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
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
index 6db515833f61..7a158789d1df 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,79 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_shared(struct inode *inode)
+{
+	u64 flags;
+
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
+		return false;
+
+	flags = (u64)inode->i_private;
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
@@ -428,6 +500,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	}
 
 	file->f_flags |= O_LARGEFILE;
+	allow_write_access(file);
 
 	inode = file->f_inode;
 	WARN_ON(file->f_mapping != inode->i_mapping);
@@ -463,6 +536,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_supports_gmem_shared_mem(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.49.0.1266.g31b7d2e469-goog

