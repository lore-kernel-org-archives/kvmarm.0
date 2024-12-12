Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94217222D75
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026718; cv=none; b=AFv7yB9HIkJ9ahBWqa3LY/D5/3tZcnAFW3Q5bUwOvujIgyAYI19laFe5gOGGuPEmReqCYd2yIe8UT9d2pGfBuR741egWe8BHDX0JREUM4X2QtNdfse1FQEJzAmmr8hpb4Avz36mFiTiOuVvHJfhGj24J5bdC16siKchnvoQjMgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026718; c=relaxed/simple;
	bh=kVQMROgLkRti3+tLSCiZf/Q7tBUqrvd9jH6yyXvlJ2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iED7vaKGWP4YyVZ6tRb9RgpUqe8YClwghaDAAO+XdUUkJ6yCTYqCpr/8oiWXIdViLFUv/rmrzRU0exAIBUz5T5Zwz3y4ru6grQ09BNuDLJHNE7QaPhmRKBKKJo677tNQv8bAQk0vAsw/YgmS8+wR+PXUnY/12sJPPJLN+Dfk2M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YcRuOG9p; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YcRuOG9p"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436228ebc5eso5624155e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026715; x=1734631515; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=is6Al2H2AiqMxaqLQL7gdzUm7OUxIBSFMLQ1Q2t4888=;
        b=YcRuOG9pOOXdK1neXoDNXronAnuQWkr0H+gpBv8/P6cSdnZMxUwZarVWxxSWYcCtgy
         Hxf37hCB4vE4DSaAE+6njiJDjjDAfpErGBoE5FY9uj2EI3G+g2fhEIUBgKPXZuXNFfZi
         75QU4qgVgpS23tlzE5T9S8Rseey43nI7EO3uR3g+Lg3+/sJ1F4eydex6sIETkLn1pdMd
         i7e4+BeS7CPyDNsKoAUpafXZoYFZbAc/my8wtDrTgPafoNioWHl0tu6HZ8tHftAhFgDc
         WUnZzgST0fB2hKTEq1XY6FhQnn0e7vsifNliC3q4PX823uuhgqjodro9q6xrFihv8y6Q
         I/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026715; x=1734631515;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=is6Al2H2AiqMxaqLQL7gdzUm7OUxIBSFMLQ1Q2t4888=;
        b=Ucv65mObLtOTyLkSzg6sc7c4jZyMKQCM0noyzBb5e46mbIoLirT1vaeVEk6NMSjk00
         zeqUdNrUAIkPTXiSmxOHyjJ5ft1MBFpKmxnky3NxiTGjbdOwHRVV3Dwe8Rs4hEk2Mg8y
         eBLHNDb3EM8E3pEtD31eoLGO2ffMEcDlpf+xWzXArddoPeecBlhqYwIoDRH5VFCFdUDr
         XhCQURuNp8Oe3mwzU3EbOmzRok+ULvFOg3wkT8/HaQbCc4x2M6XpgjQOk1tYUjPH8jho
         OZUy4qxK1kfQanRY5i7hkvrlUSkYeV9mw5jUzXWSr5WDF8lQIRAKY23q9u3pWsyMvPgs
         90Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVpwjFxzY7pd3hYOc8m+itgLrNix2ALpqsVbVET1MKWNg8xuD64WlXP5Q3PXrZvNiVJXk/yQP4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiJQcUBqPucMaEY4RQfZTLPz968oFZKyyLneWxUq8QZas6EGQh
	gWNgHEP6TZmAQ+xVC6txzsyuryO7kXvQZ1RFoW7Ui9nsfPylLdZvqo0/uEyvlyfuE8ww5+Uqt45
	nWZ0DOT2+GQ==
X-Google-Smtp-Source: AGHT+IHgLyGmzSPkmfPVAl03VtCFCec89plA2sOh31ATkaIn3otdhgvEhbA1+34qV92LIfAmgGb4yfu9wRTYfQ==
X-Received: from wmso20.prod.google.com ([2002:a05:600c:5114:b0:436:1abf:b8fe])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:350c:b0:434:ff9d:a370 with SMTP id 5b1f17b1804b1-4361c2b5351mr69806205e9.0.1734026715242;
 Thu, 12 Dec 2024 10:05:15 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:39 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-16-smostafa@google.com>
Subject: [RFC PATCH v2 15/58] KVM: arm64: iommu: Add a memory pool for the IOMMU
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch defines a new hypervisor allocator which is an instance of
the hyp buddy allocator.
This allocator would be used from the IOMMU drivers to be used for
the page tables, generally these pages have 2 properties:
- Can be multi order
- Can be non-coherent

The interface provide functions and wrappers for those types of
allocations.

The IOMMU hypervisor will leverage the allocator interface which
provides a standardized interface that can be called from the kernel
part of the IOMMU driver to top up the allocator, and can be
reclaimed through the shrinker for pKVM.

Also, the allocation function would automatically create a request
when it fails to allocate memory from the pool, so it=E2=80=99s sufficient
for the driver to return an error code and the kernel part of the
driver should check the requests in the return and fill the
hypervisor allocator.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 13 ++++
 arch/arm64/kvm/hyp/include/nvhe/mm.h    |  1 +
 arch/arm64/kvm/hyp/nvhe/alloc_mgt.c     |  2 +
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 86 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mm.c            | 17 +++++
 6 files changed, 120 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 54416cfea573..a3b5d8dd8995 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1625,6 +1625,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 =
val);
=20
 /* Allocator interface IDs. */
 #define HYP_ALLOC_MGT_HEAP_ID		0
+#define HYP_ALLOC_MGT_IOMMU_ID		1
=20
 unsigned long __pkvm_reclaim_hyp_alloc_mgt(unsigned long nr_pages);
=20
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/i=
nclude/nvhe/iommu.h
index 908863f07b0b..5f91605cd48a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -4,6 +4,8 @@
=20
 #include <asm/kvm_host.h>
=20
+#include <nvhe/alloc_mgt.h>
+
 /* Hypercall handlers */
 int kvm_iommu_alloc_domain(pkvm_handle_t domain_id, int type);
 int kvm_iommu_free_domain(pkvm_handle_t domain_id);
@@ -18,10 +20,21 @@ size_t kvm_iommu_unmap_pages(pkvm_handle_t domain_id, u=
nsigned long iova,
 			     size_t pgsize, size_t pgcount);
 phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long =
iova);
=20
+/* Flags for memory allocation for IOMMU drivers */
+#define IOMMU_PAGE_NOCACHE				BIT(0)
+void *kvm_iommu_donate_pages(u8 order, int flags);
+void kvm_iommu_reclaim_pages(void *p, u8 order);
+
+#define kvm_iommu_donate_page()		kvm_iommu_donate_pages(0, 0)
+#define kvm_iommu_donate_page_nc()	kvm_iommu_donate_pages(0, IOMMU_PAGE_NO=
CACHE)
+#define kvm_iommu_reclaim_page(p)	kvm_iommu_reclaim_pages(p, 0)
+
 struct kvm_iommu_ops {
 	int (*init)(void);
 };
=20
 int kvm_iommu_init(void);
=20
+extern struct hyp_mgt_allocator_ops kvm_iommu_allocator_ops;
+
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/incl=
ude/nvhe/mm.h
index 5d33aca7d686..7b425f811efb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -37,6 +37,7 @@ int __hyp_allocator_map(unsigned long start, phys_addr_t =
phys);
 int __pkvm_map_module_page(u64 pfn, void *va, enum kvm_pgtable_prot prot, =
bool is_protected);
 void __pkvm_unmap_module_page(u64 pfn, void *va);
 void *__pkvm_alloc_module_va(u64 nr_pages);
+int pkvm_remap_range(void *va, int nr_pages, bool nc);
 #ifdef CONFIG_NVHE_EL2_DEBUG
 void assert_in_mod_range(unsigned long addr);
 #else
diff --git a/arch/arm64/kvm/hyp/nvhe/alloc_mgt.c b/arch/arm64/kvm/hyp/nvhe/=
alloc_mgt.c
index 4a0f33b9820a..cfd903b30427 100644
--- a/arch/arm64/kvm/hyp/nvhe/alloc_mgt.c
+++ b/arch/arm64/kvm/hyp/nvhe/alloc_mgt.c
@@ -7,9 +7,11 @@
=20
 #include <nvhe/alloc.h>
 #include <nvhe/alloc_mgt.h>
+#include <nvhe/iommu.h>
=20
 static struct hyp_mgt_allocator_ops *registered_allocators[] =3D {
 	[HYP_ALLOC_MGT_HEAP_ID] =3D &hyp_alloc_ops,
+	[HYP_ALLOC_MGT_IOMMU_ID] =3D &kvm_iommu_allocator_ops,
 };
=20
 #define MAX_ALLOC_ID		(ARRAY_SIZE(registered_allocators))
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvh=
e/iommu/iommu.c
index 9022fd612a49..af6ae9b4dc51 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -5,15 +5,101 @@
  * Copyright (C) 2022 Linaro Ltd.
  */
 #include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
=20
 /* Only one set of ops supported, similary to the kernel */
 struct kvm_iommu_ops *kvm_iommu_ops;
=20
+/*
+ * Common pool that can be used by IOMMU driver to allocate pages.
+ */
+static struct hyp_pool iommu_host_pool;
+
+DECLARE_PER_CPU(struct kvm_hyp_req, host_hyp_reqs);
+
+static int kvm_iommu_refill(struct kvm_hyp_memcache *host_mc)
+{
+	if (!kvm_iommu_ops)
+		return -EINVAL;
+
+	return refill_hyp_pool(&iommu_host_pool, host_mc);
+}
+
+static void kvm_iommu_reclaim(struct kvm_hyp_memcache *host_mc, int target=
)
+{
+	if (!kvm_iommu_ops)
+		return;
+
+	reclaim_hyp_pool(&iommu_host_pool, host_mc, target);
+}
+
+static int kvm_iommu_reclaimable(void)
+{
+	if (!kvm_iommu_ops)
+		return 0;
+
+	return hyp_pool_free_pages(&iommu_host_pool);
+}
+
+struct hyp_mgt_allocator_ops kvm_iommu_allocator_ops =3D {
+	.refill =3D kvm_iommu_refill,
+	.reclaim =3D kvm_iommu_reclaim,
+	.reclaimable =3D kvm_iommu_reclaimable,
+};
+
+void *kvm_iommu_donate_pages(u8 order, int flags)
+{
+	void *p;
+	struct kvm_hyp_req *req =3D this_cpu_ptr(&host_hyp_reqs);
+	int ret;
+
+	p =3D hyp_alloc_pages(&iommu_host_pool, order);
+	if (p) {
+		/*
+		 * If page request is non-cacheable remap it as such
+		 * as all pages in the pool are mapped before hand and
+		 * assumed to be cacheable.
+		 */
+		if (flags & IOMMU_PAGE_NOCACHE) {
+			ret =3D pkvm_remap_range(p, 1 << order, true);
+			if (ret) {
+				hyp_put_page(&iommu_host_pool, p);
+				return NULL;
+			}
+		}
+		return p;
+	}
+
+	req->type =3D KVM_HYP_REQ_TYPE_MEM;
+	req->mem.dest =3D REQ_MEM_DEST_HYP_IOMMU;
+	req->mem.sz_alloc =3D (1 << order) * PAGE_SIZE;
+	req->mem.nr_pages =3D 1;
+	return NULL;
+}
+
+void kvm_iommu_reclaim_pages(void *p, u8 order)
+{
+	/*
+	 * Remap all pages to cacheable, as we don't know, may be use a flag
+	 * in the vmemmap or trust the driver to pass the cacheability same
+	 * as the allocation on free?
+	 */
+	pkvm_remap_range(p, 1 << order, false);
+	hyp_put_page(&iommu_host_pool, p);
+}
+
 int kvm_iommu_init(void)
 {
+	int ret;
+
 	if (!kvm_iommu_ops || !kvm_iommu_ops->init)
 		return -ENODEV;
=20
+	ret =3D hyp_pool_init_empty(&iommu_host_pool, 64);
+	if (ret)
+		return ret;
+
 	return kvm_iommu_ops->init();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 76bbb4c9012e..7a18b31538ae 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -564,3 +564,20 @@ int reclaim_hyp_pool(struct hyp_pool *pool, struct kvm=
_hyp_memcache *host_mc,
=20
 	return 0;
 }
+
+/* Remap hyp memory with different cacheability */
+int pkvm_remap_range(void *va, int nr_pages, bool nc)
+{
+	size_t size =3D nr_pages << PAGE_SHIFT;
+	phys_addr_t phys =3D hyp_virt_to_phys(va);
+	enum kvm_pgtable_prot prot =3D PKVM_HOST_MEM_PROT;
+	int ret;
+
+	if (nc)
+		prot |=3D KVM_PGTABLE_PROT_NORMAL_NC;
+	hyp_spin_lock(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)va, size) !=3D size);
+	ret =3D kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)va, size, phys, prot);
+	hyp_spin_unlock(&pkvm_pgd_lock);
+	return ret;
+}
--=20
2.47.0.338.g60cca15819-goog

