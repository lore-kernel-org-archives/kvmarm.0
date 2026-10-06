Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7546D4A64EF
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311572; cv=none; b=gJV/JmAcrOql4b58qA22opvuqhKXoviRNZjbllF/nbBxPSR3Z+I7W9Nxf5JOLAywSbqU96BmxfTaynsejP0XMTGgElQHT+onYjphXYUxhLVl3J6B4HcOj2q1FYa4LcqAEXrKc/8oTLed4p+9za4OlgIhlvuC3eLS/fKUAM3Oncc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311572; c=relaxed/simple;
	bh=ik69NmqPV2K6lLBle0t9mEKQvNHOAqJiFEV+h81DJ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEFqVuikTmLcBv+/sI2h5llrP94eMQ6UIk4g1Wkj2Oi3ZsvQ1CT5gs3hNUR/ukz7gFdZJraK+7qCxS707gddpdCuaiY0YuqaFsEQKlnOrgmVslOQoMG8hC1fSkQRg40bl9tyoP0se9bVn0NoxTgnps6EhEIY5z96EsaQvMFJuTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJYuAB98; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJYuAB98"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c315a445752so143084666b.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 11:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311565; x=1791916365; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jr8aQIYF00Y8a8zgy2YM5LEShPLQDizEanjD5iCKtG0=;
        b=BJYuAB98sFbwDnGzg3dMWBRjEOJXcaGV6/H+ILMHulFQpoqKkJQTENXS4e3UHmjasW
         UwdPMNIArtg2/H/ZrcNywFEpDU8+7eBGv0L/Ern/lqnCIq0ytGulDous0gRutfQ/HtSD
         LqgjO7eDWlLve07YmpxUlXkXqjIhGOflz2knG80Jvtv4B5n8ZKAhCn7BTXtXw2e+IwTg
         sfb9skVqrSXg/5EpSUf8rszm8CtudLgwEt27ogj63PCPvmWL8wbTGX8FFhcPKH7iwz/y
         y3Gw9UC8sgnx/TWp5Zx/F21pnqqNvFQ28Qr8hUldr0lNfBt3ShdrmzjZhVz+8oLv6AA7
         g83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311565; x=1791916365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jr8aQIYF00Y8a8zgy2YM5LEShPLQDizEanjD5iCKtG0=;
        b=k2eE9kbbw7XjACZJH6ZIbyjhUBYpxnAlmb1l55IiegLs+7iVB6SHIInb1gl/Fr6jxM
         V6NmS39Hhymkf7d+qTdLqbIbK+v4PNrRpHQzhfZl24kGG+cIP83a6LJ4Bzf0u6RORqbD
         70bnJ1KJ1FvphZtHyKAw6TH6QwfgjzC4iKrcm8mTWNJBHdbznI6JwWK9EygepeCu+ivX
         +r+pq9OdSg5ByrGBZIW1bTe7muii7bB4+DXPnzzvOc7NOlYiB3l3OpM/e6wyAHEiAiT4
         f2jW5qPYGTvOxlbrMiqaKeVHxcARJvm3XPlG1JwFNkvnLM2a+YTtVpaEjXgTW3UnwbFl
         LUlQ==
X-Forwarded-Encrypted: i=1; AKwUvBywQ3Tj1QQx5FKNg6JBydSKeK9D9d/j470SZhtEAOJVgJms+7dZAn2bAX5DA5ZhVs5HGldYs+Y=@lists.linux.dev
X-Gm-Message-State: AFuF++kDsucphONKgNEemy8LdcurMziumRH47Jz+xlQMQIbj/92q6iQN
	xB/JrkbrWate30hczomQ9bMIOMMwZIpv6lsPGH9gRe19zZs8ecuIl2M4
X-Gm-Gg: AYBFou3f1EcvH6+oPO6Hobe6ZpGd2391HkF+vHi1CSdP0WHwYVJYd2PyDyud5GD5dzN
	1q6ff0TNHvIr/cvZ+xroQBh+xqx2SHEtNMUwLEyJkn3qiUWSVte0uxjA0qJleajiGccJq6DMdW/
	AV1yLjYvgKr0ZO9c8B0cTPcPT72QhzJGyK3w3+F28WRib457UroU/WbzXRFcFxMe5QjbFQoEuBc
	uz14LSA4d53Mlj41lMRDCOdsISYF9Zg/AC3m4vTOI5nfZo+UzvdDp50mqCdKeLatMgwMvwQNyvc
	aLdcjG/eJD6z/vG0NHzj6weH4A/yNpklr9IDBQbUOcq6U7+j/PDWvjZR+8VEeJ+5rFzk4Nel01l
	VjmckyXaj3MQdBwdGTdb8z1UQn0dhRVo61MDyWiNblqqCwcgxbCUSlLRI4bIBe7P1XKpNRaVfmF
	LwdXkba3qiYtHQsGyFaSuUpKVLGDs+2Wv7WIEOM+xJ1AUq3DcoJdGKeyyWDgw0sWUVOF9WNAHq+
	8KOnucpTwmmwx0qJW0rNChFSl90Qpo5qMQrTBYBo+Y/AhoA++/xwfDorflh6TXbr5OlasjIHp3H
	BVdWFqqGz786aWTLvmH5v3xG7KYoIh10CCf2gmHosxLiCA==
X-Received: by 2002:a17:907:5c3:b0:c2e:3124:2394 with SMTP id a640c23a62f3a-c316a0a5d98mr227739466b.41.1791311564942;
        Tue, 06 Oct 2026 11:32:44 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:44 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
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
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 5/9] iommufd: Map memory provider files
Date: Tue,  6 Oct 2026 18:32:31 +0000
Message-ID: <20261006183235.16576-6-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
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
backs now. A device that accesses the range in between faults.

Each frame gets a PAGE_SIZE entry, so a partial revoke never splits a
large IOMMU page. Holes stay unmapped, read-only pages are mapped
without IOMMU_WRITE, and MMIO pages with IOMMU_MMIO. A provider that
returns frame 0 makes the map fail with -EINVAL.

A revoke would race a dirty bitmap read and lose the dirty bits of the
range, so provider pages and a dirty tracking domain cannot share an
IOAS: whichever comes second fails with -EOPNOTSUPP. A provider
mapping cannot be split by a partial unmap, and in-kernel accesses to
it are refused.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/Kconfig        |   1 +
 drivers/iommu/iommufd/io_pagetable.c |  13 +-
 drivers/iommu/iommufd/io_pagetable.h |  23 ++-
 drivers/iommu/iommufd/pages.c        | 273 ++++++++++++++++++++++++++-
 include/uapi/linux/iommufd.h         |  11 +-
 5 files changed, 315 insertions(+), 6 deletions(-)

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
index 5389227eb6ff..3f65380e91d2 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -8,6 +8,7 @@
 #include <linux/dma-buf.h>
 #include <linux/interval_tree.h>
 #include <linux/kref.h>
+#include <linux/mem_provider.h>
 #include <linux/mutex.h>
 #include <linux/xarray.h>
 
@@ -48,6 +49,8 @@ struct iopt_area {
 	/* IOMMU_READ, IOMMU_WRITE, etc */
 	int iommu_prot;
 	bool prevent_access : 1;
+	/* The pages come from a memory provider and may have holes */
+	bool provider : 1;
 	unsigned int num_accesses;
 	unsigned int num_locks;
 };
@@ -191,6 +194,7 @@ enum iopt_address_type {
 	IOPT_ADDRESS_USER = 0,
 	IOPT_ADDRESS_FILE,
 	IOPT_ADDRESS_DMABUF,
+	IOPT_ADDRESS_PROVIDER,
 };
 
 /* An area of the pages mapped into a domain, for pages that are not pinned. */
@@ -214,6 +218,12 @@ struct iopt_pages_dmabuf {
 	bool is_cpu_ram;
 };
 
+struct iopt_pages_provider {
+	struct mem_provider_attachment att;
+	/* Byte offset in the provider file, always PAGE_SIZE aligned */
+	unsigned long start;
+};
+
 /*
  * This holds a pinned page list for multiple areas of IO address space. The
  * pages always originate from a linear chunk of userspace VA. Multiple
@@ -243,6 +253,8 @@ struct iopt_pages {
 		};
 		/* IOPT_ADDRESS_DMABUF */
 		struct iopt_pages_dmabuf dmabuf;
+		/* IOPT_ADDRESS_PROVIDER */
+		struct iopt_pages_provider provider;
 	};
 	bool writable:1;
 	u8 account_mode;
@@ -267,10 +279,15 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
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
@@ -292,6 +309,10 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
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
index d68f6eea836d..99c95602ac4e 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -52,6 +52,7 @@
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kthread.h>
+#include <linux/mem_provider.h>
 #include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
@@ -238,6 +239,35 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
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
@@ -245,6 +275,11 @@ static void iopt_area_unmap_domain_range(struct iopt_area *area,
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
@@ -1357,6 +1392,10 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 	    WARN_ON(last_index < start_index))
 		return -EINVAL;
 
+	/* Provider pages are read from the provider, see iopt_provider_map() */
+	if (WARN_ON(iopt_is_provider(pages)))
+		return -EINVAL;
+
 	rc = pfn_reader_init(pfns, pages, start_index, last_index);
 	if (rc)
 		return rc;
@@ -1688,6 +1727,215 @@ void iopt_pages_untrack_all_domains(struct iopt_area *area,
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
+	unsigned long first, last;
+
+	if (offset < 0 || len <= 0 || offset >= end || offset + len <= start)
+		return;
+	first = (max_t(u64, offset, start) - start) >> PAGE_SHIFT;
+	last = (min_t(u64, offset + len, end) - start - 1) >> PAGE_SHIFT;
+
+	guard(mutex)(&pages->mutex);
+	list_for_each_entry(track, &pages->tracker, elm) {
+		struct iopt_area *area = track->area;
+		unsigned long s = max(first, iopt_area_index(area));
+		unsigned long l = min(last, iopt_area_last_index(area));
+
+		if (s > l)
+			continue;
+		iopt_provider_unmap(area, track->domain, s, l);
+		if (iopt_provider_map(area, pages, track->domain, s, l))
+			pr_warn_ratelimited("iommufd: cannot map provider pages after a revoke\n");
+	}
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
@@ -1705,6 +1953,8 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
+	} else if (iopt_is_provider(pages)) {
+		mem_provider_detach(&pages->provider.att);
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1855,6 +2105,12 @@ static void iopt_area_unfill_partial_domain(struct iopt_area *area,
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
@@ -1898,6 +2154,11 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
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
@@ -1963,7 +2224,11 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
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
@@ -2402,7 +2667,7 @@ int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
-	if (iopt_is_dmabuf(pages))
+	if (iopt_is_dmabuf(pages) || iopt_is_provider(pages))
 		return -EINVAL;
 
 	if (pages->type != IOPT_ADDRESS_USER)
@@ -2491,6 +2756,10 @@ int iopt_area_add_access(struct iopt_area *area, unsigned long start_index,
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
