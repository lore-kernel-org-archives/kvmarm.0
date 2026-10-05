Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506694746BF
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194169; cv=none; b=YpmWbgpAbYZxhyaRqms8ryFTy5O3/wXpv615NliZdJqdoDf6P2BVEsa7O5MSr9r3IuDIHMOarHzmRqF3u+/6VQegyPlRf2Y87p8Z8VSndx0GfarUkaONIcws9mY/8i7JF5EECQvCg02UUL28Dlr505BdNc4vVo2p4xs7IETtJe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194169; c=relaxed/simple;
	bh=QQt1HrGUSSzTPXD1RDMqaM/Z7De0EqkM0gBCfOrfOqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HE/pcwhiZYExWUr3Mz7SLmYxHVVK1OOcE/kk6RkJ+BxDeoSWqBCQ1urA21/EtI3IHH7v++/7e49gXhQ6CJhTG6Hp/OwYT1+pnV11Oqlpl8RFfnyqCE7fdP4HdnAACAony6UP1Q46r9svuhbqmsaQk2GLs8CKfMkakm+Ws9Cunwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s6t0xcwq; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6t0xcwq"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2e36c3478aso219863966b.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 02:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194161; x=1791798961; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U0Fn4xuYRvi/Ep3my+xCHICO0ZIL+WrDmVGVP+HJwXw=;
        b=s6t0xcwqck/Z7ldHe0m+f18VmMcDr6OiRwrxJhhat/NCcre/HcxvxBoN137yXsUdbO
         ebwMnHePRJVAfDgDKgmIzXfphw8m1ycuGqp7010uEckgsqKrjtGY384tAVkhmbe3LbU5
         Cb5+o1CKq4LqX6sEwlKsjzK14CIxrULKKzhRQKxyFvvxgdRIyl3+i/upw/y6mvm5Fgqn
         bKm63tTgMtAZ3mw9IXfF5UkN4k/AHsZTOEYivan4NWLhJT4xRwkV89oBHoPwooMH/yEG
         toiVSI5KLVKMz74dgzzHRWM7ZIuSFA1EtkhhBBAu2biti2/QaJNavaf1QCKetwfA271i
         iORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194161; x=1791798961;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U0Fn4xuYRvi/Ep3my+xCHICO0ZIL+WrDmVGVP+HJwXw=;
        b=epVqa2MErkQ3YFQoyWMKpwsdG5vTmfSfGp8anCRaYLF4mawdzVuJRoUrBhHrXn/Yqd
         IocV0Y8/ZJbzRcDoEszJSeWM4r+20p3WoWMqxrsDzO4ycXXTmsuuW92w1GvgGwDtvMo4
         VwyZzqHBpf+UwOo/tBQVW9wDT6XbxJzBsJDD3cpilBoWLYt66xk6X8Fr+tnOAcRP6GF2
         GeiZZKMFtnjApcVltqtLhvuO7ppjICW4CzfuQ2o/Vw4A9Jqian3sZuY23LKS1g7uZ19W
         D/n4NySFzQ/BlUgc12i4tJMjx8xcXxqQUuD/rv3NCJzh7QSrggbu6537bkfwIAdXTfDD
         Z56w==
X-Forwarded-Encrypted: i=1; AKwUvBwArByGSYsEoUTuAmNpBhRjvmgKcW0Lm+V9h3CNgoyf4QbeOyIgT4YW2GK7qrB9hNmBpls/mS8=@lists.linux.dev
X-Gm-Message-State: AFuF++lih0Pe8c2ZojmbDj6ElaPpHdwsEcZC3Qw92/RzCcqAi86gml0V
	aIvbYw6YQt5kj7gyIzJtBLckZqgh0Gre4KTOhHUNY373s1DUoN6b5e7N
X-Gm-Gg: AYBFou1T4MCu3q6TV8bFHF9fbcCkGcRshNiSlRF+EbJQ9WzVm2pvg+6RD1qEpQxrycV
	DPJWNGLyY88nqVwNSF7dq+vlFn+Xrq3LY1dgacxt+3RhnPrdMd6rejuGRYqSS9HwFnr8GfcIqXn
	LpexOXJkTQ5708NytPOYzUcOKApIf0H4KYe1xzS3GvBbnL+EIrvI2jRf6b4Wj0+4Dt3Ooz2PsZp
	e5huxGmEK4aGHzq/fatDcR17IOMMCOO8iucLM7qj7e79A22eDLaWO4D2ILeUQStaHbRvxnFgfmI
	wTMGCMOkD9i6vuj5bJN+mrUcGtsHGEPyKEbbk9437IaDKASSTvIY139BdLicjk5xtLIymtaqSLo
	qgezJFnqHh0HZyCOiLI4ciBMyuAXj+OppJnIqGFE8KhKPGUdNpnJWuSmLBF4S0DxvMktIH+sPaf
	ZKJK3Xa/15KvkCQBbZPSWDl9jif3aqKY8TyQeyOAM7RroRJdjtMxcFOCv7JipJUJKxiHdaLkPoH
	yjHkSvpBJsxJDYKMxE7HUf5BN1qvhfaPobDfNbWcloSt2pEvXdWhR+VPujWy661HsMb+5DO/OKr
	Cv3eXCeOpay1Kf3kTCfJ9kerYD1bX2Bvu1o=
X-Received: by 2002:a17:907:3da8:b0:c2e:34b7:8899 with SMTP id a640c23a62f3a-c2e6edfb51dmr545128866b.30.1791194160845;
        Mon, 05 Oct 2026 02:56:00 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562aba16sm50753266b.23.2026.10.05.02.55.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 02:56:00 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH 5/6] KVM: guest_memfd: Add dma-buf backing
Date: Mon,  5 Oct 2026 09:55:51 +0000
Message-ID: <20261005095552.52748-6-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261005095552.52748-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261005095552.52748-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

A memory owner that exports a dma-buf should be able to use that one
object for both guest stage-2 mappings and device IOMMU mappings. A
second, KVM-specific backing interface would duplicate the description
of the memory layout and the rules for invalidating it.

Add GUEST_MEMFD_FLAG_USE_DMABUF and a dmabuf_fd field to
KVM_CREATE_GUEST_MEMFD. This backing has its own kvm_gmem_ops.
guest_memfd attaches to the buffer as a revocable importer without a
device. At creation, it asks for the run at offset 0 and refuses MMIO
or unknown attributes, so a buffer that KVM can never map fails early.
Offset 0 may be unbacked.

On a fault, guest_memfd takes the reservation once. It asks get_phys()
about the PUD-sized, PMD-sized and page-sized blocks around the faulting
page, in that order, and maps the first block that one aligned RAM run
covers. If the page is not backed or the run is not supported, the
fault returns -EFAULT. A READONLY run is mapped without stage-2 write
permission.

The invalidation callback only runs KVM's invalidation over the
affected range. It does not allocate memory or call the exporter. A
fault that read the layout during the change sees mmu_invalidate_seq
move and retries.

Callbacks can start as soon as guest_memfd attaches. A dma-buf-backed
file is therefore added to the inode's list of guest_memfd files under
filemap_invalidate_lock.

mmap() uses the exporter's dma-buf mmap. fallocate() and populate are
not supported. Import the DMA_BUF symbol namespace so that a
CONFIG_KVM=m build passes modpost.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 include/linux/kvm_host.h       |   1 +
 include/uapi/linux/kvm.h       |   6 +-
 tools/include/uapi/linux/kvm.h |   6 +-
 virt/kvm/Kconfig               |   1 +
 virt/kvm/guest_memfd.c         | 239 +++++++++++++++++++++++++++++++--
 5 files changed, 243 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f84f3ab44acf..0158dc46580b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -834,6 +834,7 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+	flags |= GUEST_MEMFD_FLAG_USE_DMABUF;
 
 	return flags;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8..f8c83013773d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1654,11 +1654,15 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_DMABUF	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	/* With USE_DMABUF, memory comes from this dma-buf's leading bytes. */
+	__s32 dmabuf_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d0c0c8605976..ebeb2bc353ed 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1644,11 +1644,15 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_DMABUF	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	/* With USE_DMABUF, memory comes from this dma-buf's leading bytes. */
+	__s32 dmabuf_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 794976b88c6f..7ac4c8a371eb 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -105,6 +105,7 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
 
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
+       select DMA_SHARED_BUFFER
        bool
 
 config HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4bf2cc5e8e..f401cc560eb4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/dma-buf.h>
+#include <linux/dma-resv.h>
+#include <linux/module.h>
 #include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
@@ -44,6 +47,8 @@ struct gmem_inode {
 	struct list_head gmem_file_list;
 
 	u64 flags;
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
 };
 
 static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
@@ -477,21 +482,37 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
-static int kvm_gmem_native_mmap(struct file *file, struct vm_area_struct *vma)
+static int kvm_gmem_validate_mmap(struct file *file,
+				  struct vm_area_struct *vma)
 {
 	if (!kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
-
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
-	    (VM_SHARED | VM_MAYSHARE)) {
+	    (VM_SHARED | VM_MAYSHARE))
 		return -EINVAL;
-	}
+	return 0;
+}
 
-	vma->vm_ops = &kvm_gmem_vm_ops;
+static int kvm_gmem_native_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int ret = kvm_gmem_validate_mmap(file, vma);
 
+	if (ret)
+		return ret;
+	vma->vm_ops = &kvm_gmem_vm_ops;
 	return 0;
 }
 
+static int kvm_gmem_dmabuf_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct dma_buf *dmabuf = GMEM_I(file_inode(file))->dmabuf;
+	int ret = kvm_gmem_validate_mmap(file, vma);
+
+	if (ret)
+		return ret;
+	return dma_buf_mmap(dmabuf, vma, vma->vm_pgoff);
+}
+
 /* File-op dispatchers — thin: they all go through the backing's ops table. */
 
 static int kvm_gmem_fops_release(struct inode *inode, struct file *file)
@@ -617,6 +638,172 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
+/* ---- a dma-buf behind the file ----------------------------------------- */
+
+/*
+ * Refuse a buffer whose first run guest_memfd can never map, such as MMIO,
+ * at creation rather than on every fault. A gap at offset 0 is legal. This
+ * is advisory: each fault checks the run it uses.
+ */
+static int gmem_dmabuf_check(struct dma_buf_attachment *attach, u64 size)
+{
+	struct phys_vec pv;
+	u32 attr;
+	int ret;
+
+	dma_resv_lock(attach->dmabuf->resv, NULL);
+	ret = dma_buf_get_phys(attach, 0, size, &pv, &attr);
+	dma_resv_unlock(attach->dmabuf->resv);
+	if (ret == -ENOENT)
+		return 0;
+	if (ret)
+		return ret;
+	if (!dma_buf_phys_attr_known(attr) ||
+	    dma_buf_phys_attr_type(attr) != DMA_BUF_PHYS_ATTR_RAM)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static void gmem_dmabuf_invalidate_range(struct dma_buf_attachment *attach,
+					 unsigned long offset,
+					 unsigned long len)
+{
+	struct inode *inode = attach->importer_priv;
+	pgoff_t npages = i_size_read(inode) >> PAGE_SHIFT;
+	pgoff_t start = offset >> PAGE_SHIFT;
+	pgoff_t end = min_t(pgoff_t, DIV_ROUND_UP(offset + len, PAGE_SIZE),
+			    npages);
+
+	if (start >= end)
+		return;
+	/* Lock order: dma-buf reservation, file invalidation, then mmu_lock. */
+	filemap_invalidate_lock(inode->i_mapping);
+	kvm_gmem_invalidate_start(inode, start, end);
+	kvm_gmem_invalidate_end(inode, start, end);
+	filemap_invalidate_unlock(inode->i_mapping);
+}
+
+static void gmem_dmabuf_invalidate(struct dma_buf_attachment *attach)
+{
+	struct inode *inode = attach->importer_priv;
+
+	gmem_dmabuf_invalidate_range(attach, 0, i_size_read(inode));
+}
+
+static const struct dma_buf_attach_ops gmem_dmabuf_attach_ops = {
+	.allow_peer2peer	= true,
+	.invalidate_mappings	= gmem_dmabuf_invalidate,
+	.invalidate_mappings_range = gmem_dmabuf_invalidate_range,
+};
+
+static int kvm_gmem_dmabuf_attach(struct inode *inode, int dmabuf_fd)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	struct dma_buf_attachment *attach;
+	struct dma_buf *dmabuf;
+	int ret;
+
+	dmabuf = dma_buf_get(dmabuf_fd);
+	if (IS_ERR(dmabuf))
+		return PTR_ERR(dmabuf);
+	if (dmabuf->size < i_size_read(inode)) {
+		ret = -EINVAL;
+		goto put;
+	}
+
+	gi->dmabuf = dmabuf;
+	attach = dma_buf_dynamic_attach(dmabuf, NULL, &gmem_dmabuf_attach_ops,
+					inode);
+	if (IS_ERR(attach)) {
+		ret = PTR_ERR(attach);
+		goto clear_put;
+	}
+	gi->attach = attach;
+	ret = gmem_dmabuf_check(attach, i_size_read(inode));
+	if (ret)
+		goto detach;
+	return 0;
+
+detach:
+	dma_buf_detach(dmabuf, attach);
+	gi->attach = NULL;
+clear_put:
+	gi->dmabuf = NULL;
+put:
+	dma_buf_put(dmabuf);
+	return ret;
+}
+
+static void kvm_gmem_dmabuf_release(struct inode *inode)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	if (!gi->dmabuf)
+		return;
+	dma_buf_detach(gi->dmabuf, gi->attach);
+	dma_buf_put(gi->dmabuf);
+	gi->attach = NULL;
+	gi->dmabuf = NULL;
+}
+
+static int gmem_dmabuf_get_pfn(struct file *file, struct kvm *kvm,
+			       struct kvm_memory_slot *slot, gfn_t gfn,
+			       kvm_pfn_t *pfn, struct page **page,
+			       int *max_order, bool *writable)
+{
+	static const int orders[] = { PUD_ORDER, PMD_ORDER, 0 };
+	struct gmem_inode *gi = GMEM_I(file_inode(file));
+	struct gmem_file *f = gmem_file_of(file);
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	pgoff_t npages = i_size_read(file_inode(file)) >> PAGE_SHIFT;
+	unsigned int oi;
+	int ret = -EFAULT;
+
+	if (file != READ_ONCE(slot->gmem.file))
+		return -EFAULT;
+	if (xa_load(&f->bindings, index) != slot)
+		return -EIO;
+
+	/* A block maps at an order only if one aligned RAM run covers it. */
+	dma_resv_lock(gi->dmabuf->resv, NULL);
+	for (oi = max_order ? 0 : ARRAY_SIZE(orders) - 1;
+	     oi < ARRAY_SIZE(orders); oi++) {
+		int order = orders[oi];
+		pgoff_t bs = ALIGN_DOWN(index, 1UL << order);
+		u64 blen = (u64)PAGE_SIZE << order;
+		struct phys_vec pv;
+		u32 attr;
+
+		if (bs + (1UL << order) > npages)
+			continue;
+		if (dma_buf_get_phys(gi->attach, (u64)bs << PAGE_SHIFT, blen,
+				     &pv, &attr) ||
+		    pv.len != blen || !IS_ALIGNED(pv.paddr, blen) ||
+		    !dma_buf_phys_attr_known(attr) ||
+		    dma_buf_phys_attr_type(attr) != DMA_BUF_PHYS_ATTR_RAM)
+			continue;
+
+		*pfn = PHYS_PFN(pv.paddr) + (index - bs);
+		*page = NULL;
+		if (max_order)
+			*max_order = order;
+		if (writable && (attr & DMA_BUF_PHYS_ATTR_READONLY))
+			*writable = false;
+		ret = 0;
+		break;
+	}
+	dma_resv_unlock(gi->dmabuf->resv);
+	return ret;
+}
+
+static int kvm_gmem_dmabuf_populate(struct file *file, struct kvm *kvm,
+				    struct kvm_memory_slot *slot, gfn_t gfn,
+				    kvm_pfn_t *pfn, struct page *src_page,
+				    int order)
+{
+	return -EOPNOTSUPP;
+}
+
 static int  kvm_gmem_native_bind(struct file *file, struct kvm *kvm,
 				 struct kvm_memory_slot *slot, loff_t offset);
 static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
@@ -654,7 +841,17 @@ static const struct kvm_gmem_ops kvm_gmem_native_ops = {
 	.fallocate = kvm_gmem_native_fallocate,
 };
 
-static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
+static const struct kvm_gmem_ops kvm_gmem_dmabuf_ops = {
+	.bind      = kvm_gmem_native_bind,
+	.unbind    = kvm_gmem_native_unbind,
+	.get_pfn   = gmem_dmabuf_get_pfn,
+	.populate  = kvm_gmem_dmabuf_populate,
+	.release   = kvm_gmem_native_release,
+	.mmap      = kvm_gmem_dmabuf_mmap,
+};
+
+static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags,
+			     int dmabuf_fd)
 {
 	static const char *name = "[kvm-gmem]";
 	struct gmem_file *f;
@@ -695,6 +892,12 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	GMEM_I(inode)->flags = flags;
 
+	if (flags & GUEST_MEMFD_FLAG_USE_DMABUF) {
+		err = kvm_gmem_dmabuf_attach(inode, dmabuf_fd);
+		if (err)
+			goto err_inode;
+	}
+
 	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
@@ -703,12 +906,17 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 
 	file->f_flags |= O_LARGEFILE;
 	file->private_data = &f->backing;
-	f->backing.ops = &kvm_gmem_native_ops;
+	f->backing.ops = flags & GUEST_MEMFD_FLAG_USE_DMABUF ?
+			 &kvm_gmem_dmabuf_ops : &kvm_gmem_native_ops;
 
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
 	xa_init(&f->bindings);
+	if (flags & GUEST_MEMFD_FLAG_USE_DMABUF)
+		filemap_invalidate_lock(inode->i_mapping);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
+	if (flags & GUEST_MEMFD_FLAG_USE_DMABUF)
+		filemap_invalidate_unlock(inode->i_mapping);
 
 	fd_install(fd, file);
 	return fd;
@@ -734,8 +942,11 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 
 	if (size <= 0 || !PAGE_ALIGNED(size))
 		return -EINVAL;
+	if (args->pad ||
+	    (!(flags & GUEST_MEMFD_FLAG_USE_DMABUF) && args->dmabuf_fd))
+		return -EINVAL;
 
-	return __kvm_gmem_create(kvm, size, flags);
+	return __kvm_gmem_create(kvm, size, flags, args->dmabuf_fd);
 }
 
 /*
@@ -1211,6 +1422,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	gi->dmabuf = NULL;
+	gi->attach = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
@@ -1225,11 +1438,19 @@ static void kvm_gmem_free_inode(struct inode *inode)
 	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	kvm_gmem_dmabuf_release(inode);
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+}
+
 static const struct super_operations kvm_gmem_super_operations = {
 	.statfs		= simple_statfs,
 	.alloc_inode	= kvm_gmem_alloc_inode,
 	.destroy_inode	= kvm_gmem_destroy_inode,
 	.free_inode	= kvm_gmem_free_inode,
+	.evict_inode	= kvm_gmem_evict_inode,
 };
 
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
@@ -1292,3 +1513,5 @@ void kvm_gmem_exit(void)
 	rcu_barrier();
 	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }
+
+MODULE_IMPORT_NS("DMA_BUF");
-- 
2.47.3

