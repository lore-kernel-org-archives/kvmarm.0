Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CE4DDB41
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791970672; cv=none; b=bav0qFNpXcEIHqffW2vyHnIBpNU85ieZfvc1wpbG3hnRS4ai0w4A3DlGF+x5+F38vGlWzPa90S2161E2pf5epz0ow/bFKm0a1STTR+T+7Qv1YL1BYFTqAajH87qGaRl67bEDaTu6kkII50g5jXYlThXpIuq8SGdXPpcXibLU+Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791970672; c=relaxed/simple;
	bh=K1mSwoT1D80xTkV4YCgIqGUXnFVCqxaQ1FakjaNgS/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhxMdCa9/wMvjyB8LOsYIBTf+xVI681ksCYHMMwT8crzlw2k1sj7tw203WK1y5mpF8JbtZNmLLKrh+XjqABu6FSf0iGG/gfvB6z57aMXb0tlMyQXRzbuBFbB/DNGPGOwqQiMPC46O2UWi0AXKuVmPcnki0zRlbVDNkA9qaVnkjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuFmhK1P; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuFmhK1P"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c411d6615so2796609f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 02:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970664; x=1792575464; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UpAZ9bBqLpRDHKtCcUCoXD82CF9jsn5qbZ7SJ4GmbDo=;
        b=WuFmhK1P6Wcz/0cYO3EfuCowTMvi1cIC3L9/sI4i9VlDC3LuhQotJwgxF4m7F1373k
         ulD2yf3ExZtLplb8mNSQ9pCEtSWekq9BdVV23oSAy91ehsMaJXyskfd76p9UEFgduxOx
         0XcILC0IpjKGeA0Nsep0bQvlN9+OuAmtAQp0aS/J6pUlUVsfjBTmHkVQ1/UmQjNM3uUy
         BkJKddDV0Aa7/uR7vmT6yFVE+nNTwYvISXspc1Q3fBu+qnwr5GLQzp2SIDXjsY8kB4UK
         CKh/E7ntjnEQvpfulUSELQbSmDP6jxZo5K5j3xEeKAJsHnjUFrXJez/mscODB2F2rhxX
         wTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970664; x=1792575464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UpAZ9bBqLpRDHKtCcUCoXD82CF9jsn5qbZ7SJ4GmbDo=;
        b=iAvGIo8vndTMPO1dRMGYPG+SGLH9bhacFtEtODOJlLs1XOV/2HRwQY/8aoJjNiCCQ1
         0gnngPo7JWAbj/rH9nWITbK5OtUgfz31W8vxw3Qk8U08ZQfWTVFl0Ls30gJkj8Rii52t
         1IFNqW9SXQYMcK74u2llNFxgASXeWvvrJvZtlyKCBlGRNzDCNTaQmEErJWmFx9Xjw2Rk
         BIkDhdgNr67NDwdeJU88DFU9diOeSmhKV1FzX0WEMWnluPAZ9Crl+WBhzuohv2DTiKUK
         0aDIk83E7KHE0jEzFM2WGbr+JJ4gbHRQCMczd9UBQYgNbXdf65wJKvT4WD/4K1PZzRVR
         nSxg==
X-Forwarded-Encrypted: i=1; AKwUvByyKdR+a424GyxVB7AZEaaoGyaUvt4CetG1RCYV52qYQW+WFpMJLqOXGqaYNO+psDUdh5SnOes=@lists.linux.dev
X-Gm-Message-State: AFq9FYJuowB6dTM16m7oLOwQKEd+OcOOq1jO7p3ZDfNJ4H7KZAFvkH/K
	FDMhsKuVlIyjFq8R8LxjfKAiErNT85LHkaqcs5XznfGwanne8vzsgY+9
X-Gm-Gg: AYBFou0WXKGr40lbIhKhMhyPuDzbi8XIq6u81dlZ/E8WJN6HylqHSYaLch9hTsEz/a8
	OfsQpydjQF4UPWbgPSMEyOPMELWCsW2g6NJf71nbEl4e6tAUExe7QgvdVSUA09e+gKSSYT4CHDX
	CCYHSKv4E48rGrEzPsvJG7KIyCMIxGSwZ3MPx1Td0quro5go6FjA6m4XvCesQRuubf/r9UaMJ6I
	K7Tbgd9SEWu6jAlooS1U3odrXWcHkXIZc29k4IYJUC616DsCE29cLvEcBcA5W9PEXRThlTJKiHZ
	X3bCs3WNM+a8924b+phdDTPH2Nk0zs6MysN3jW1MtNwVUDM031gIAWx/Aq3b/fG4MC/PTlb00sM
	Y1LM+qIopQf2F+RQ2aMLcI3hdQEHIo44fT06QmgnYrWwvjZiaGFAtqvmXqQpFKuufmSsatlB6Bi
	D2AGzmpwtd3R/OUbgHdG1LvKE9V+lC5LC/AO/TDaBVZr9cCHexuInsw3rfQjTi/HeFRGjm9Aq+8
	qqbQK0crP9p60sgPXBjg4oxGj/fuZyCtB3FcOB4dS0NqbGnmi5XjMsUaY4vEpJzGj/U0D9Gm5I/
	bOR/ohRnTE0bx/ZNdu0/FYmGvtMH+lNvrXyY
X-Received: by 2002:a05:6000:469c:b0:48a:ef5c:fc2c with SMTP id ffacd0b85a97d-48dbacf86e2mr20371602f8f.48.1791970663608;
        Wed, 14 Oct 2026 02:37:43 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:43 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 06/11] iommufd: Map memory provider files
Date: Wed, 14 Oct 2026 09:37:28 +0000
Message-ID: <20261014093733.90312-7-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

IOMMU_IOAS_MAP_FILE pins the pages it maps, which cannot work for a
memory provider file: the frames may have no struct page, and the
provider can take any of them back at any time.

Accept a provider file. iommufd neither pins nor accounts its pages.
It asks the provider for each frame when it fills a domain, and on a
revoke it unmaps the range in every domain and maps what the provider
backs now. A device that accesses the range in between faults. A
revoke charges the page tables it allocates to the memory cgroup that
mapped the file, not to the task that revoked.

Each frame gets a PAGE_SIZE entry, so a partial revoke never splits a
large IOMMU page. The next patch maps larger blocks. Holes stay
unmapped, read-only pages are mapped without IOMMU_WRITE, and MMIO
pages with IOMMU_MMIO. Frame 0 is refused with -EINVAL: iova_to_phys()
returns 0 for an IOVA that is not mapped, so a revoke would take that
page for a hole and leave it mapped.

A revoke would race a dirty bitmap read and lose the dirty bits of the
range, so provider pages and a dirty tracking domain cannot share an
IOAS: whichever comes second fails with -EOPNOTSUPP. A provider
mapping cannot be split by a partial unmap, and in-kernel accesses to
it are refused.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/Kconfig        |   1 +
 drivers/iommu/iommufd/io_pagetable.c |  13 +-
 drivers/iommu/iommufd/io_pagetable.h |  27 ++-
 drivers/iommu/iommufd/pages.c        | 288 ++++++++++++++++++++++++++-
 include/uapi/linux/iommufd.h         |  11 +-
 5 files changed, 334 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 455bac0351f2..65d71e28c12b 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -8,6 +8,7 @@ config IOMMUFD
 	select INTERVAL_TREE
 	select INTERVAL_TREE_SPAN_ITER
 	select IOMMU_API
+	select MEM_PROVIDER
 	default n
 	help
 	  Provides /dev/iommu, the user API to control the IOMMU subsystem as
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index bcd531acc9dd..3eca7f4f83d3 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -217,6 +217,7 @@ static int iopt_insert_area(struct io_pagetable *iopt, struct iopt_area *area,
 		return -EPERM;
 
 	area->iommu_prot = iommu_prot;
+	area->provider = iopt_is_provider(pages);
 	area->page_offset = start_byte % PAGE_SIZE;
 	if (area->page_offset & (iopt->iova_alignment - 1))
 		return -EINVAL;
@@ -289,6 +290,9 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 		case IOPT_ADDRESS_DMABUF:
 			start = elm->start_byte + elm->pages->dmabuf.start;
 			break;
+		case IOPT_ADDRESS_PROVIDER:
+			start = elm->start_byte + elm->pages->provider.start;
+			break;
 		}
 		rc = iopt_alloc_iova(iopt, dst_iova, start, length);
 		if (rc)
@@ -515,8 +519,13 @@ int iopt_map_file_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 		if (!file)
 			return -EBADF;
 
-		pages = iopt_alloc_file_pages(file, start_byte, start, length,
-					      iommu_prot & IOMMU_WRITE);
+		/* A memory provider file, or else a memfd. */
+		pages = iopt_alloc_provider_pages(file, start, length,
+						  iommu_prot & IOMMU_WRITE);
+		if (PTR_ERR(pages) == -ENODEV)
+			pages = iopt_alloc_file_pages(file, start_byte, start,
+						      length,
+						      iommu_prot & IOMMU_WRITE);
 		fput(file);
 		if (IS_ERR(pages))
 			return PTR_ERR(pages);
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index ba539bfaac31..80d926c86c6c 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -8,11 +8,14 @@
 #include <linux/dma-buf.h>
 #include <linux/interval_tree.h>
 #include <linux/kref.h>
+#include <linux/mem_provider.h>
 #include <linux/mutex.h>
 #include <linux/xarray.h>
 
 #include "iommufd_private.h"
 
+struct mem_cgroup;
+
 struct iommu_domain;
 
 /*
@@ -48,6 +51,8 @@ struct iopt_area {
 	/* IOMMU_READ, IOMMU_WRITE, etc */
 	int iommu_prot;
 	bool prevent_access : 1;
+	/* The pages come from a memory provider and may have holes */
+	bool provider : 1;
 	unsigned int num_accesses;
 	unsigned int num_locks;
 };
@@ -191,6 +196,7 @@ enum iopt_address_type {
 	IOPT_ADDRESS_USER = 0,
 	IOPT_ADDRESS_FILE,
 	IOPT_ADDRESS_DMABUF,
+	IOPT_ADDRESS_PROVIDER,
 };
 
 /* An area of the pages mapped into a domain, for pages that are not pinned. */
@@ -207,6 +213,14 @@ struct iopt_pages_dmabuf {
 	unsigned long start;
 };
 
+struct iopt_pages_provider {
+	struct mem_provider_attachment att;
+	/* Byte offset in the provider file, always PAGE_SIZE aligned */
+	unsigned long start;
+	/* Charged for the page tables that a revoke allocates */
+	struct mem_cgroup *memcg;
+};
+
 /*
  * This holds a pinned page list for multiple areas of IO address space. The
  * pages always originate from a linear chunk of userspace VA. Multiple
@@ -236,6 +250,8 @@ struct iopt_pages {
 		};
 		/* IOPT_ADDRESS_DMABUF */
 		struct iopt_pages_dmabuf dmabuf;
+		/* IOPT_ADDRESS_PROVIDER */
+		struct iopt_pages_provider provider;
 	};
 	bool writable:1;
 	u8 account_mode;
@@ -260,10 +276,15 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
 	return pages->type == IOPT_ADDRESS_DMABUF;
 }
 
+static inline bool iopt_is_provider(struct iopt_pages *pages)
+{
+	return pages->type == IOPT_ADDRESS_PROVIDER;
+}
+
 /* The pages are not pinned, so their domains are tracked in pages->tracker. */
 static inline bool iopt_pages_tracked(struct iopt_pages *pages)
 {
-	return iopt_is_dmabuf(pages);
+	return iopt_is_dmabuf(pages) || iopt_is_provider(pages);
 }
 
 static inline bool iopt_dmabuf_revoked(struct iopt_pages *pages)
@@ -285,6 +306,10 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 					   unsigned long start_byte,
 					   unsigned long start,
 					   unsigned long length, bool writable);
+struct iopt_pages *iopt_alloc_provider_pages(struct file *file,
+					     unsigned long start,
+					     unsigned long length,
+					     bool writable);
 void iopt_release_pages(struct kref *kref);
 static inline void iopt_put_pages(struct iopt_pages *pages)
 {
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 660af3d46f5e..aa7740326ad6 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -52,6 +52,8 @@
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kthread.h>
+#include <linux/mem_provider.h>
+#include <linux/memcontrol.h>
 #include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
@@ -238,6 +240,35 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 	WARN_ON(ret != size);
 }
 
+/*
+ * Provider pages are mapped with PAGE_SIZE entries, and may have holes.  Some
+ * IOMMU drivers warn when asked to unmap an IOVA that is not mapped, so find
+ * the runs that are mapped and unmap each one, without touching the holes.
+ * iopt_provider_map() refuses frame 0, which iova_to_phys() reports for
+ * an IOVA that is not mapped.
+ */
+static void iopt_provider_unmap(struct iopt_area *area,
+				struct iommu_domain *domain,
+				unsigned long start_index,
+				unsigned long last_index)
+{
+	unsigned long iova = iopt_area_index_to_iova(area, start_index);
+	size_t left = (last_index - start_index + 1) * PAGE_SIZE;
+
+	while (left) {
+		size_t len = 0;
+
+		while (len < left && iommu_iova_to_phys(domain, iova + len))
+			len += PAGE_SIZE;
+		if (len)
+			iommu_unmap_nofail(domain, iova, len);
+		/* Step over the run and the hole page that ended it. */
+		len = min(len + PAGE_SIZE, left);
+		iova += len;
+		left -= len;
+	}
+}
+
 static void iopt_area_unmap_domain_range(struct iopt_area *area,
 					 struct iommu_domain *domain,
 					 unsigned long start_index,
@@ -245,6 +276,11 @@ static void iopt_area_unmap_domain_range(struct iopt_area *area,
 {
 	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
 
+	if (area->provider) {
+		iopt_provider_unmap(area, domain, start_index, last_index);
+		return;
+	}
+
 	iommu_unmap_nofail(domain, start_iova,
 			   iopt_area_index_to_iova_last(area, last_index) -
 				   start_iova + 1);
@@ -1349,6 +1385,10 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 	    WARN_ON(last_index < start_index))
 		return -EINVAL;
 
+	/* Provider pages are read from the provider, see iopt_provider_map() */
+	if (WARN_ON(iopt_is_provider(pages)))
+		return -EINVAL;
+
 	rc = pfn_reader_init(pfns, pages, start_index, last_index);
 	if (rc)
 		return rc;
@@ -1647,6 +1687,228 @@ void iopt_pages_untrack_all_domains(struct iopt_area *area,
 	}
 }
 
+static int iopt_provider_prot(struct iopt_area *area, u32 attrs)
+{
+	int prot = area->iommu_prot;
+
+	if (attrs & MEM_PROVIDER_ATTR_READONLY)
+		prot &= ~IOMMU_WRITE;
+	if (mem_provider_type(attrs) != MEM_PROVIDER_TYPE_RAM) {
+		prot &= ~IOMMU_CACHE;
+		prot |= IOMMU_MMIO;
+	}
+	return prot;
+}
+
+/*
+ * Map what the provider backs in [start_index, last_index] of the area into
+ * @domain, and leave the holes unmapped.  Each frame is mapped with a
+ * PAGE_SIZE entry, so that a revoke of part of a large block never has to
+ * split a larger IOMMU page.  On failure nothing in the range is mapped.
+ */
+static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *pages,
+			     struct iommu_domain *domain,
+			     unsigned long start_index,
+			     unsigned long last_index)
+{
+	unsigned long base = pages->provider.start >> PAGE_SHIFT;
+	unsigned long index = start_index;
+	int rc;
+
+	lockdep_assert_held(&pages->mutex);
+
+	if ((1UL << __ffs(domain->pgsize_bitmap)) > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
+	/*
+	 * A revoke unmaps under pages->mutex only, so it would race with a
+	 * dirty bitmap read, and lose the dirty bits of what it unmaps.
+	 * Provider pages are not mapped in a domain with dirty tracking.
+	 */
+	if (domain->dirty_ops)
+		return -EOPNOTSUPP;
+
+	while (index <= last_index) {
+		unsigned long pfn, iova, block_end, nr, i;
+		int order = PUD_ORDER;
+		u32 attrs;
+		int prot;
+
+		rc = mem_provider_get_page(&pages->provider.att, base + index,
+					   &pfn, &order, &attrs);
+		if (rc == -EFAULT) {
+			index++;
+			continue;
+		}
+		/* Frame 0 would look unmapped to iopt_provider_unmap(). */
+		if (!rc && !pfn)
+			rc = -EINVAL;
+		if (rc)
+			goto err_unmap;
+
+		block_end = ALIGN_DOWN(base + index, 1UL << order) +
+			    (1UL << order) - base;
+		nr = min(block_end, last_index + 1) - index;
+		iova = iopt_area_index_to_iova(area, index);
+		prot = iopt_provider_prot(area, attrs);
+
+		for (i = 0; i < nr; i++) {
+			rc = iommu_map_nosync(domain, iova + i * PAGE_SIZE,
+					      PFN_PHYS(pfn + i), PAGE_SIZE, prot,
+					      GFP_KERNEL_ACCOUNT);
+			if (rc)
+				break;
+		}
+		if (i) {
+			int sync_rc = iommu_sync_map(domain, iova, i * PAGE_SIZE);
+
+			if (!rc)
+				rc = sync_rc;
+		}
+		index += i;
+		if (rc)
+			goto err_unmap;
+	}
+	return 0;
+
+err_unmap:
+	if (index > start_index)
+		iopt_provider_unmap(area, domain, start_index, index - 1);
+	return rc;
+}
+
+/* Map the whole area into every domain of its io_pagetable. */
+static int iopt_provider_fill_domains(struct iopt_area *area,
+				      struct iopt_pages *pages)
+{
+	struct iommu_domain *domain, *undo;
+	unsigned long index, undo_index;
+	int rc;
+
+	xa_for_each(&area->iopt->domains, index, domain) {
+		rc = iopt_provider_map(area, pages, domain,
+				       iopt_area_index(area),
+				       iopt_area_last_index(area));
+		if (rc)
+			goto err_unmap;
+	}
+	return 0;
+
+err_unmap:
+	xa_for_each(&area->iopt->domains, undo_index, undo) {
+		if (undo_index >= index)
+			break;
+		iopt_provider_unmap(area, undo, iopt_area_index(area),
+				    iopt_area_last_index(area));
+	}
+	return rc;
+}
+
+/*
+ * The provider changed the frames behind [offset, offset + len).  In every
+ * domain, unmap the range and map what the provider backs now.  A device that
+ * accesses the range in between faults.
+ */
+static void iopt_provider_revoke(struct mem_provider_attachment *att,
+				 loff_t offset, loff_t len)
+{
+	struct iopt_pages *pages =
+		container_of(att, struct iopt_pages, provider.att);
+	u64 start = pages->provider.start;
+	u64 end = start + (u64)pages->npages * PAGE_SIZE;
+	struct iopt_pages_track *track;
+	struct mem_cgroup *old_memcg;
+	unsigned long first, last;
+	int rc;
+
+	if (offset < 0 || len <= 0 || offset >= end || offset + len <= start)
+		return;
+	first = (max_t(u64, offset, start) - start) >> PAGE_SHIFT;
+	last = (min_t(u64, offset + len, end) - start - 1) >> PAGE_SHIFT;
+
+	guard(mutex)(&pages->mutex);
+	/*
+	 * The task that revokes does not own these page tables: charge the
+	 * memory cgroup that mapped the file.
+	 */
+	old_memcg = set_active_memcg(pages->provider.memcg);
+	list_for_each_entry(track, &pages->tracker, elm) {
+		struct iopt_area *area = track->area;
+		unsigned long s = max(first, iopt_area_index(area));
+		unsigned long l = min(last, iopt_area_last_index(area));
+
+		if (s > l)
+			continue;
+		iopt_provider_unmap(area, track->domain, s, l);
+		rc = iopt_provider_map(area, pages, track->domain, s, l);
+		if (rc)
+			pr_warn_ratelimited("iommufd: cannot map provider pages at IOVA %#lx-%#lx after a revoke: %d\n",
+					    iopt_area_index_to_iova(area, s),
+					    iopt_area_index_to_iova(area, l) +
+						    PAGE_SIZE - 1, rc);
+	}
+	set_active_memcg(old_memcg);
+}
+
+/**
+ * iopt_alloc_provider_pages() - Pages backed by a memory provider file
+ * @file: The provider file
+ * @start: Byte offset in the file, PAGE_SIZE aligned
+ * @length: Number of bytes
+ * @writable: The pages may be mapped writable
+ *
+ * The pages are not pinned.  The provider can change the frames behind them
+ * at any time, and every domain that maps them follows.
+ *
+ * Return: the pages, ERR_PTR(-ENODEV) if @file is not a provider file,
+ * ERR_PTR(-EINVAL) if @start is not page aligned, or another ERR_PTR().
+ */
+struct iopt_pages *iopt_alloc_provider_pages(struct file *file,
+					     unsigned long start,
+					     unsigned long length,
+					     bool writable)
+{
+	static struct lock_class_key pages_provider_mutex_key;
+	struct iopt_pages *pages;
+	int rc;
+
+	if (length / PAGE_SIZE >= MAX_NPFNS)
+		return ERR_PTR(-EINVAL);
+
+	pages = iopt_alloc_pages(0, length, writable);
+	if (IS_ERR(pages))
+		return pages;
+
+	/*
+	 * The pages mutex of provider pages is never held while taking the
+	 * mmap_lock, but is taken from the provider's revoke.  Split the lock
+	 * class from the pinned pages.
+	 */
+	lockdep_set_class(&pages->mutex, &pages_provider_mutex_key);
+
+	/* Provider pages are not pinned, so they are not accounted. */
+	pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
+	pages->type = IOPT_ADDRESS_PROVIDER;
+	pages->provider.start = start;
+	pages->provider.memcg = get_mem_cgroup_from_current();
+
+	/*
+	 * The provider must cover the whole mapping, so the size is its end.
+	 * Check the alignment only once the file is known to be a provider
+	 * file: on -ENODEV the caller maps it as a memfd, which may start
+	 * anywhere.
+	 */
+	rc = mem_provider_attach(&pages->provider.att, file, start + length,
+				 iopt_provider_revoke);
+	if (!rc && !PAGE_ALIGNED(start))
+		rc = -EINVAL;
+	if (rc) {
+		iopt_put_pages(pages);
+		return ERR_PTR(rc);
+	}
+	return pages;
+}
+
 void iopt_release_pages(struct kref *kref)
 {
 	struct iopt_pages *pages = container_of(kref, struct iopt_pages, kref);
@@ -1664,6 +1926,9 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
+	} else if (iopt_is_provider(pages)) {
+		mem_provider_detach(&pages->provider.att);
+		mem_cgroup_put(pages->provider.memcg);
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1814,6 +2079,12 @@ static void iopt_area_unfill_partial_domain(struct iopt_area *area,
  */
 void iopt_area_unmap_domain(struct iopt_area *area, struct iommu_domain *domain)
 {
+	if (area->provider) {
+		iopt_provider_unmap(area, domain, iopt_area_index(area),
+				    iopt_area_last_index(area));
+		return;
+	}
+
 	iommu_unmap_nofail(domain, iopt_area_iova(area),
 			   iopt_area_length(area));
 }
@@ -1857,6 +2128,11 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
 	if (iopt_dmabuf_revoked(area->pages))
 		return 0;
 
+	if (iopt_is_provider(area->pages))
+		return iopt_provider_map(area, area->pages, domain,
+					 iopt_area_index(area),
+					 iopt_area_last_index(area));
+
 	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
 			      iopt_area_last_index(area));
 	if (rc)
@@ -1922,7 +2198,11 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 			goto out_unlock;
 	}
 
-	if (!iopt_dmabuf_revoked(pages)) {
+	if (iopt_is_provider(pages)) {
+		rc = iopt_provider_fill_domains(area, pages);
+		if (rc)
+			goto out_untrack;
+	} else if (!iopt_dmabuf_revoked(pages)) {
 		rc = pfn_reader_first(&pfns, pages, iopt_area_index(area),
 				      iopt_area_last_index(area));
 		if (rc)
@@ -2361,7 +2641,7 @@ int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
-	if (iopt_is_dmabuf(pages))
+	if (iopt_is_dmabuf(pages) || iopt_is_provider(pages))
 		return -EINVAL;
 
 	if (pages->type != IOPT_ADDRESS_USER)
@@ -2450,6 +2730,10 @@ int iopt_area_add_access(struct iopt_area *area, unsigned long start_index,
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
+	/* Provider frames may have no struct page, and are not pinned. */
+	if (iopt_is_provider(pages))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&pages->mutex);
 	access = iopt_pages_get_exact_access(pages, start_index, last_index);
 	if (access) {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 0425d452d41e..b4500fc21368 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -224,7 +224,7 @@ struct iommu_ioas_map {
  * @size: sizeof(struct iommu_ioas_map_file)
  * @flags: same as for iommu_ioas_map
  * @ioas_id: same as for iommu_ioas_map
- * @fd: the memfd or supported dma-buf file to map
+ * @fd: the memfd, memory provider file or supported dma-buf file to map
  * @start: byte offset from start of the file to map from
  * @length: same as for iommu_ioas_map
  * @iova: same as for iommu_ioas_map
@@ -235,6 +235,15 @@ struct iommu_ioas_map {
  * VFIO PCI dma-bufs exported through VFIO_DEVICE_FEATURE_DMA_BUF, and
  * other dma-bufs may be rejected. All other arguments and semantics match
  * those of IOMMU_IOAS_MAP.
+ *
+ * A file from a memory provider is also accepted; @start must then be
+ * page aligned. Its pages are not pinned. The provider may change the memory
+ * behind any range at any time, and the mapping follows: pages that the
+ * provider does not back are left unmapped, read-only pages are mapped
+ * without write permission, and device memory is mapped as MMIO. A device
+ * access to a page that is being changed, or that is not backed, faults. Such
+ * a mapping cannot be split by a partial unmap, and in-kernel accesses to it
+ * are refused. It is not supported in an IOAS with a dirty tracking domain.
  */
 struct iommu_ioas_map_file {
 	__u32 size;
-- 
2.47.3

