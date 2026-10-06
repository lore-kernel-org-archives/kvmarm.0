Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D2A4A5C30
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 18:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311578; cv=none; b=tgl5WBDl53H6RJh4cVgra2QSGFC2lqqJ6LntWzY0kQ7S89q2HlqqaqSW76E6+C6ZtwOyNwGHvZlxevGj0ZIgdmfEC6QidGpVQ9P6F563LQ6VSnRFPtd+LH9tHG6EsQ7EstnSstRdW/BaVYUhJmMLovj8BPkQRXZghTmtQIz9q54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311578; c=relaxed/simple;
	bh=Wvb+FV1a/Ip0zfmgFMJBGc6mwew92je4EqUaQgs8i/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+0ey2quSoDU0xtWshU/uuJQEF/fLUJjBGTm8RYl9UqUns6ddooe6NPEgCsmH8Mo7mQ5M5PpiyYvY7hE3OFDC1c4vq/xEgFVtRGcgYKGhJauJzfVrREFv5gPJ2dRQC+pVFZEOpj5p1VxKzNuMu8MxHFaOI/TXTX6WVM1dGxwRp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4Kvyk6J; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4Kvyk6J"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e62319cfaso326047866b.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 11:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311570; x=1791916370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drh6ErUU2peV0xSdHj/I37HNFe8TgwEz/1p6UbIS+a4=;
        b=D4Kvyk6JmL4ZhbMkbXj6WOZyhz4mFEoPnsU5zIHtcytpR9IxmksFDmJ0wVl4rgouHJ
         8qC+GxWWuKHIUVe9UsRRt+DHSOLWUsq7D4HDgTFcKAYA3TU09cPKlWXQQxVoa4NilW5O
         3DHINtBBctuYIgUp74uoGC7Ib+nZ7U7Lki8MOSH8FlY70U0EnpeE9EN4KRVoHqpxAUXa
         R85G8cVjvfehRv1gMyAONPX+PTb+2ss0rmRpVJpEMFHirTEjuDmm3iU82NcKVr39nJDD
         pSJSQQMByEQ43jD3Qvj/i+FOdU7NJlQlhwn8UzynJGYpDG7Dmy5T4UQd6mluEoZShyOQ
         WkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311570; x=1791916370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=drh6ErUU2peV0xSdHj/I37HNFe8TgwEz/1p6UbIS+a4=;
        b=0E1a6dQAtwdvIt+1sKzn1aSMpuegLneIXy428+hkB9CoFS1+K21THDudfgisKz4NwU
         tgaPMqjiDW3/aaxNaC8xRC8LjktpSL9w++c5KiUR8PFwAC0L/O6F7aivpiaC7ba3NJd3
         L7tDNVLdWxEWcJe+0hxE1WnAbh/EmDHUh8pJSPV5dQeHxwPXiuCsVS7FBQaBZ8nUbprY
         IYhxi9aus1ZSORxsZWA4SwElicd2oSWWTrGRBIsE+Gw+/kY0vHohrONLKgJYtvQceTNu
         RUU71+FM3GtVmKNemKjZmSUgQJqBowcTAqdIaz4b5JdJ7g4cpbmcMMidUXaZbxPoKOy2
         QCOw==
X-Forwarded-Encrypted: i=1; AKwUvBwdhMGxKoT2zNmhNoD3PPtQ45eirtoTd/X/QHPwRCAjwGAVxC7rBlRmpCua+X9O9dItfLIeEjA=@lists.linux.dev
X-Gm-Message-State: AFuF++n5tZu8cL1AMlxJa3BbyueH/FdCnRzTQgdLwbmwlbBrLaq5vryE
	lRsekP7++vwi0dPLaxoP++Xv7fx1uNfJwbB1UMOZp/1Phx4TLeUYWDJ7
X-Gm-Gg: AYBFou1JEycdgLDq9889wWu6bCxk7YF9yeYmiSn953MA53Rhden6TM23NGNo7EwVveX
	6Ug7bCfBbtSdsF2k1m3OU6PoNqjVX/2g8fTEuaXkJWPfUIN150hDu+XP7ym3nhmovgGW5VWA1XP
	mlIENiiXUi9oLeyCjjyFLYpschgHys8XRq16i7vQfZAgH2h29WJIFTg2YxgJbBQE2Xk/oyF8qKP
	B4hVd9fcpgt3CHp6vqHyx0Ed4saW+AgFHEIG+nC/KsUgJD64nna5s0Ii08Tj6dJty0N5gslF84B
	/4JwjC8DNBimmzVYbDuMs0xqsybACkXM3VIW378HovzbZ4HG2UsgfG5npPxu/AygZ19bQlQRleb
	nm+wrQUlO30KRoIsiQ5YoJ+Ib2oVY18MITLn5M8CcQlMid8F5VWuOixtg5fifvvZr8+rjOlMFF5
	DAXQ94fCUeVbQvLKEfzrSdyEG5urRACoHHg/ZB9RLwfoxvxs6kpOyNsmMbDvoSVjbCAlMAbwFqN
	5srweNfywBIvpKlDph9IvNziAZoyEVKsxni5+plO+EJBP6GfWoFwxN8iR9Nr0jNkfnjXOrUH+gE
	2iptHUQ0VnFjXGm6TwPD3QSu8qKHsQsfPqw=
X-Received: by 2002:a17:907:a4cb:b0:c2e:4b90:3c56 with SMTP id a640c23a62f3a-c2e6ece5614mr1095900366b.13.1791311569727;
        Tue, 06 Oct 2026 11:32:49 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:49 -0700 (PDT)
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
Subject: [PATCH 8/9] samples/kvm: Add a memory provider sample
Date: Tue,  6 Oct 2026 18:32:34 +0000
Message-ID: <20261006183235.16576-9-griffoul@gmail.com>
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

The memory provider interface has no in-tree provider that a VMM can
use.

Add mem_provider_sample. It lends a region, either a fixed range given
with addr= and len= or memory from alloc_contig_pages(), as child files
that a VMM passes to both guest_memfd and iommufd. A control device
moves pages between children, takes them back and makes them read
only, and every change revokes the range. It uses no KVM, dma-buf or
iommufd symbol.

The fixed range is not System RAM, so the sample keeps a write-back
memremap() of it while a file over it may be mapped into userspace.
Without it, PAT would make the range uncached on x86, and the VMM's
mapping would be uncached while the guest's is write-back. The sample
is x86 only, as guest_memfd accepts providers only there.

David's gmem_provider sample is unchanged.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 MAINTAINERS                       |   1 +
 samples/Kconfig                   |  17 +
 samples/Makefile                  |   1 +
 samples/kvm/Makefile              |   1 +
 samples/kvm/mem_provider_sample.c | 855 ++++++++++++++++++++++++++++++
 samples/kvm/mem_provider_sample.h | 135 +++++
 6 files changed, 1010 insertions(+)
 create mode 100644 samples/kvm/mem_provider_sample.c
 create mode 100644 samples/kvm/mem_provider_sample.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6cab075a3ff7..b6b47e132e16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17366,6 +17366,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/mem_provider.h
 F:	mm/mem_provider.c
+F:	samples/kvm/mem_provider_sample.*
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
diff --git a/samples/Kconfig b/samples/Kconfig
index d26a03dea072..e4c4aface3ab 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -344,6 +344,23 @@ config SAMPLE_KVM_GMEM_PROVIDER
 
 	  If unsure, say N.
 
+config SAMPLE_KVM_MEM_PROVIDER
+	tristate "Build sample memory provider -- loadable module only"
+	depends on MEM_PROVIDER && CONTIG_ALLOC && X86_64 && m
+	help
+	  This builds a sample memory provider (include/linux/mem_provider.h).
+	  Its files can back a guest_memfd and be mapped by iommufd.  Loaded
+	  with addr= and len=, it lends a fixed physical range that has no
+	  struct page, for example memory hidden with memmap= on the command
+	  line.  Without them, it allocates a contiguous region with
+	  alloc_contig_pages().
+
+	  It shows how a memory owner moves pages between VMs, takes them
+	  back or makes them read only, and how guest_memfd and iommufd
+	  follow each change.
+
+	  If unsure, say N.
+
 endif # SAMPLES
 
 config HAVE_SAMPLE_FTRACE_DIRECT
diff --git a/samples/Makefile b/samples/Makefile
index e85397e5e34f..0565141d1f45 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -38,6 +38,7 @@ subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
 obj-$(CONFIG_SAMPLE_KMEMLEAK)		+= kmemleak/
 obj-$(CONFIG_SAMPLE_KVM_GMEM_PROVIDER)	+= kvm/
+obj-$(CONFIG_SAMPLE_KVM_MEM_PROVIDER)	+= kvm/
 obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+= coresight/
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
diff --git a/samples/kvm/Makefile b/samples/kvm/Makefile
index dcad6e53ea78..a885b5313804 100644
--- a/samples/kvm/Makefile
+++ b/samples/kvm/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_SAMPLE_KVM_GMEM_PROVIDER) += gmem_provider.o
+obj-$(CONFIG_SAMPLE_KVM_MEM_PROVIDER) += mem_provider_sample.o
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
new file mode 100644
index 000000000000..8180959ab78f
--- /dev/null
+++ b/samples/kvm/mem_provider_sample.c
@@ -0,0 +1,855 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * mem_provider_sample - a sample memory provider.
+ *
+ * The module owns a region of physical memory and lends it through provider
+ * files (include/linux/mem_provider.h).  A VMM passes the same file to
+ * KVM_CREATE_GUEST_MEMFD, for the guest, and to IOMMU_IOAS_MAP_FILE, for the
+ * guest's devices.  The module calls neither KVM nor iommufd: it answers
+ * "what is page N" and revokes a range when the answer changes.
+ *
+ * The region is either:
+ *
+ *  - a fixed range given with addr= and len=, which has no struct page, for
+ *    example memory hidden from the kernel with memmap= on the command line;
+ *  - or, without those parameters, a range from alloc_contig_pages().
+ *
+ * The control device /dev/mem_provider_sample creates provider files.
+ * SETUP makes one file over the whole region.  NEW_CHILD carves part of the
+ * region into a child file, and MOVE, DONATE and RECLAIM change which child
+ * has which page.  A page can also be taken away or made read only.  See
+ * mem_provider_sample.h.
+ *
+ * Confidential VMs are not supported.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/bitmap.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/mem_provider.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include "mem_provider_sample.h"
+
+static unsigned long long addr;
+module_param(addr, ullong, 0444);
+MODULE_PARM_DESC(addr,
+		 "Physical base of a region with no struct page (optional)");
+
+static unsigned long long len;
+module_param(len, ullong, 0444);
+MODULE_PARM_DESC(len, "Size in bytes of that region (optional)");
+
+/*
+ * One provider file.
+ *
+ * Lock order: mps_root.lock, then mps_info.lock, then the consumers' locks
+ * (taken by their revoke callbacks).  get_page() takes no lock, so a
+ * consumer can call it from its fault paths and its revoke callback.
+ */
+struct mps_info {
+	struct mem_provider_file mpf;
+	struct mutex lock;		/* the bitmaps */
+
+	unsigned long base_pfn;
+	unsigned long npages;
+	struct page *cma_pages;		/* from alloc_contig_pages(), or NULL */
+	bool fixed;			/* a SETUP file over addr=/len= */
+	bool mmap_capable;
+	bool fixed_wb;			/* holds a ref on the fixed-region WB alias */
+
+	unsigned long *absent;		/* taken away by CTL_SET_PRESENT */
+	unsigned long *readonly;
+
+	/*
+	 * A child of the root: its first page in the root, and the pages it
+	 * has.  NULL @owned for a file made by SETUP, which has all its pages.
+	 */
+	unsigned long root_index;
+	unsigned long *owned;
+	struct list_head root_link;	/* mps_root.children, mps_root.lock */
+};
+
+/*
+ * The root region, owned by the control device.  Changes of ownership run
+ * under @lock, which is taken before any child's lock.
+ */
+static struct mps_root {
+	struct mutex lock;		/* everything below */
+	unsigned long base_pfn;
+	unsigned long npages;
+	struct page *cma_pages;
+	unsigned long *owned;		/* pages that a child has */
+	unsigned long *donated;		/* pages kept at the root */
+	struct list_head children;
+	/*
+	 * The addr=/len= region is used either by one SETUP file or by the
+	 * root, never by both, so that its frames have one owner.
+	 */
+	bool fixed_setup;
+	/* Files over the fixed region that may be mapped into userspace. */
+	unsigned int fixed_wb_users;
+} mps_root;
+
+/*
+ * A write-back mapping of the addr=/len= region, held while any file over it
+ * may be mapped into userspace (counted by mps_root.fixed_wb_users).  Without
+ * it, PAT makes the range uncached on x86, and the VMM's mapping would be
+ * uncached while the guest's is write-back.  PAT may still give a weaker type
+ * if the MTRRs do not mark the range write-back.
+ */
+static void *mps_fixed_wb;
+
+/* A file over the fixed region whose pages the host may map. */
+static bool mps_over_fixed_mappable(struct mps_info *info)
+{
+	return addr && len && !info->cma_pages && info->mmap_capable;
+}
+
+/*
+ * Hold a write-back mapping of the fixed region while any file over it may be
+ * mapped into userspace.  Called under mps_root.lock.
+ */
+static int mps_fixed_wb_get(void)
+{
+	if (mps_root.fixed_wb_users == 0) {
+		mps_fixed_wb = memremap(addr, len, MEMREMAP_WB);
+		if (!mps_fixed_wb)
+			return -ENOMEM;
+	}
+	mps_root.fixed_wb_users++;
+	return 0;
+}
+
+static void mps_fixed_wb_put(void)
+{
+	if (--mps_root.fixed_wb_users == 0) {
+		memunmap(mps_fixed_wb);
+		mps_fixed_wb = NULL;
+	}
+}
+
+/* Does @info have page @index now?  Called with or without info->lock. */
+static bool mps_page_present(struct mps_info *info, unsigned long index)
+{
+	if (info->owned && !test_bit(index, info->owned))
+		return false;
+	return !test_bit(index, info->absent);
+}
+
+/*
+ * The length of the run from @index of pages with the same state as @index:
+ * present, and the same read-only bit.
+ */
+static unsigned long mps_run(struct mps_info *info, unsigned long index)
+{
+	unsigned long end = info->npages;
+
+	end = min(end, find_next_bit(info->absent, info->npages, index + 1));
+	if (info->owned)
+		end = min(end, find_next_zero_bit(info->owned, info->npages,
+						  index + 1));
+	if (test_bit(index, info->readonly))
+		end = min(end, find_next_zero_bit(info->readonly, info->npages,
+						  index + 1));
+	else
+		end = min(end, find_next_bit(info->readonly, info->npages,
+					     index + 1));
+	return end - index;
+}
+
+/* ---- Provider operations ------------------------------------------------ */
+
+static struct mem_provider_file *
+mps_mp_attach(struct file *file, loff_t size)
+{
+	struct mps_info *info = file->private_data;
+
+	if (size > (loff_t)info->npages << PAGE_SHIFT)
+		return ERR_PTR(-EINVAL);
+	return &info->mpf;
+}
+
+static void mps_mp_detach(struct mem_provider_file *mpf)
+{
+}
+
+/*
+ * Reads the bitmaps without info->lock.  A change runs under the lock and
+ * revokes the range afterwards, so an answer that a change makes out of date
+ * is dropped by the consumer.
+ */
+static int mps_mp_get_page(struct mem_provider_file *mpf, pgoff_t index,
+			   unsigned long *pfn, int *max_order, u32 *attrs)
+{
+	struct mps_info *info = container_of(mpf, struct mps_info, mpf);
+	unsigned long run;
+
+	if (index >= info->npages)
+		return -EINVAL;
+
+	if (!mps_page_present(info, index))
+		return -EFAULT;
+
+	/* The aligned block around @index must be one run. */
+	run = mps_run(info, index);
+	while (*max_order) {
+		unsigned long first = ALIGN_DOWN(index, 1UL << *max_order);
+
+		if (first + (1UL << *max_order) <= index + run &&
+		    (first == index || mps_page_present(info, first)) &&
+		    mps_run(info, first) >= 1UL << *max_order)
+			break;
+		(*max_order)--;
+	}
+
+	*pfn = info->base_pfn + index;
+	if (test_bit(index, info->readonly))
+		*attrs |= MEM_PROVIDER_ATTR_READONLY;
+	/* The creator of the file decides whether the host may map it. */
+	if (!info->mmap_capable)
+		*attrs |= MEM_PROVIDER_ATTR_NO_USER_MAP;
+	return 0;
+}
+
+static const struct mem_provider_ops mps_mp_ops = {
+	.attach		= mps_mp_attach,
+	.detach		= mps_mp_detach,
+	.get_page	= mps_mp_get_page,
+};
+
+/* Tell the consumers that pages [start, end) of @info changed. */
+static void mps_revoke(struct mps_info *info, unsigned long start,
+		       unsigned long end)
+{
+	if (end > start)
+		mem_provider_revoke(&info->mpf, (loff_t)start << PAGE_SHIFT,
+				    (loff_t)(end - start) << PAGE_SHIFT);
+}
+
+/* ---- Provider file ------------------------------------------------------ */
+
+/* Byte range [offset, offset + len) of @info as page indices. */
+static int mps_range(struct mps_info *info, u64 offset, u64 len,
+		     unsigned long *start, unsigned long *end)
+{
+	if (!len || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
+		return -EINVAL;
+	*start = offset >> PAGE_SHIFT;
+	*end = *start + (len >> PAGE_SHIFT);
+	if (*end > info->npages || *end < *start)
+		return -EINVAL;
+	return 0;
+}
+
+static void mps_set_readonly(struct mps_info *info, unsigned long start,
+			     unsigned long end, bool readonly)
+{
+	mutex_lock(&info->lock);
+	if (readonly)
+		bitmap_set(info->readonly, start, end - start);
+	else
+		bitmap_clear(info->readonly, start, end - start);
+	mps_revoke(info, start, end);
+	mutex_unlock(&info->lock);
+}
+
+static void mps_set_present(struct mps_info *info, unsigned long start,
+			    unsigned long end, bool present)
+{
+	mutex_lock(&info->lock);
+	if (present)
+		bitmap_clear(info->absent, start, end - start);
+	else
+		bitmap_set(info->absent, start, end - start);
+	mps_revoke(info, start, end);
+	mutex_unlock(&info->lock);
+}
+
+static long mps_get_stats(struct mps_info *info, void __user *uarg)
+{
+	struct mps_stats st = {};
+
+	mutex_lock(&info->lock);
+	st.region_offset = (u64)info->root_index << PAGE_SHIFT;
+	st.region_len = (u64)info->npages << PAGE_SHIFT;
+	st.owned_pages = info->owned ?
+		bitmap_weight(info->owned, info->npages) : info->npages;
+	st.absent_pages = bitmap_weight(info->absent, info->npages);
+	st.readonly_pages = bitmap_weight(info->readonly, info->npages);
+	mutex_unlock(&info->lock);
+
+	return copy_to_user(uarg, &st, sizeof(st)) ? -EFAULT : 0;
+}
+
+/*
+ * A child fd is read-only to its holder: only GET_STATS.  The owner changes a
+ * child's pages through the control device (MPS_CTL_SET_PRESENT and
+ * MPS_CTL_SET_READONLY), so a VMM that holds a child cannot.
+ */
+static long mps_file_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct mps_info *info = file->private_data;
+	void __user *uarg = (void __user *)arg;
+
+	if (cmd == MPS_GET_STATS)
+		return mps_get_stats(info, uarg);
+	return -ENOTTY;
+}
+
+/* Every consumer has detached: each one holds a reference to the file. */
+static int mps_file_release(struct inode *inode, struct file *file)
+{
+	struct mps_info *info = file->private_data;
+	unsigned long i;
+
+	/*
+	 * A child gives the pages it has back to the root.  Pages it donated
+	 * stay at the root, and pages moved out belong to another child.
+	 */
+	if (info->owned) {
+		mutex_lock(&mps_root.lock);
+		list_del(&info->root_link);
+		for_each_set_bit(i, info->owned, info->npages)
+			__clear_bit(info->root_index + i, mps_root.owned);
+		mutex_unlock(&mps_root.lock);
+		bitmap_free(info->owned);
+	}
+	if (addr && len && !info->cma_pages) {
+		mutex_lock(&mps_root.lock);
+		if (info->fixed)
+			mps_root.fixed_setup = false;
+		if (info->fixed_wb)
+			mps_fixed_wb_put();
+		mutex_unlock(&mps_root.lock);
+	}
+
+	if (info->cma_pages)
+		free_contig_range(info->base_pfn, info->npages);
+	bitmap_free(info->absent);
+	bitmap_free(info->readonly);
+	kfree(info);
+	return 0;
+}
+
+static const struct mem_provider_fops mps_file_fops = {
+	.fops = {
+		.owner		= THIS_MODULE,
+		.fop_flags	= FOP_MEM_PROVIDER,
+		.release	= mps_file_release,
+		.unlocked_ioctl	= mps_file_ioctl,
+		.compat_ioctl	= compat_ptr_ioctl,
+	},
+	.ops = &mps_mp_ops,
+};
+
+/*
+ * Make a provider file over [base_pfn, base_pfn + npages).  The fd is
+ * reserved but not installed, so that the caller can finish setting up
+ * @info before another thread can reach it.
+ */
+static int mps_new_file(unsigned long base_pfn, unsigned long npages,
+			u32 flags, struct mps_info **infop,
+			 struct file **filep)
+{
+	struct mps_info *info;
+	struct file *file;
+	int fd, ret;
+
+	info = kzalloc_obj(*info);
+	if (!info)
+		return -ENOMEM;
+	mem_provider_file_init(&info->mpf);
+	info->base_pfn = base_pfn;
+	info->npages = npages;
+	info->mmap_capable = flags & MPS_FLAG_MMAP_CAPABLE;
+	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
+	info->readonly = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!info->absent || !info->readonly) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+	mutex_init(&info->lock);
+	INIT_LIST_HEAD(&info->root_link);
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		ret = fd;
+		goto err_free;
+	}
+	file = anon_inode_getfile("[mem-provider-sample]", &mps_file_fops.fops,
+				  info, O_RDWR);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		ret = PTR_ERR(file);
+		goto err_free;
+	}
+	*infop = info;
+	*filep = file;
+	return fd;
+
+err_free:
+	bitmap_free(info->absent);
+	bitmap_free(info->readonly);
+	kfree(info);
+	return ret;
+}
+
+static struct page *mps_alloc_region(unsigned long npages)
+{
+	struct page *pages;
+
+	pages = alloc_contig_pages(npages, GFP_KERNEL | __GFP_ZERO,
+				   numa_node_id(), NULL);
+	return pages;
+}
+
+static long mps_ctl_setup(void __user *uarg)
+{
+	struct mps_setup setup;
+	unsigned long base_pfn, npages;
+	struct page *pages = NULL;
+	struct mps_info *info;
+	struct file *file;
+	int fd;
+
+	if (copy_from_user(&setup, uarg, sizeof(setup)))
+		return -EFAULT;
+	if ((setup.flags & ~MPS_FLAG_MMAP_CAPABLE) || setup.pad)
+		return -EINVAL;
+
+	if (addr && len) {
+		/* The fixed region has one owner: this file or the root. */
+		mutex_lock(&mps_root.lock);
+		if (mps_root.fixed_setup || mps_root.npages) {
+			mutex_unlock(&mps_root.lock);
+			return -EBUSY;
+		}
+		fd = mps_new_file(addr >> PAGE_SHIFT, len >> PAGE_SHIFT,
+				  setup.flags, &info, &file);
+		if (fd >= 0 && mps_over_fixed_mappable(info)) {
+			if (mps_fixed_wb_get()) {
+				put_unused_fd(fd);
+				fput(file);
+				fd = -ENOMEM;
+			} else {
+				info->fixed_wb = true;
+			}
+		}
+		if (fd >= 0) {
+			info->fixed = true;
+			mps_root.fixed_setup = true;
+		}
+		mutex_unlock(&mps_root.lock);
+		if (fd >= 0)
+			fd_install(fd, file);
+		return fd;
+	}
+
+	if (!setup.size || !PAGE_ALIGNED(setup.size))
+		return -EINVAL;
+	npages = setup.size >> PAGE_SHIFT;
+	pages = mps_alloc_region(npages);
+	if (!pages)
+		return -ENOMEM;
+	base_pfn = page_to_pfn(pages);
+
+	fd = mps_new_file(base_pfn, npages, setup.flags, &info, &file);
+	if (fd < 0) {
+		free_contig_range(base_pfn, npages);
+		return fd;
+	}
+	info->cma_pages = pages;
+	fd_install(fd, file);
+	return fd;
+}
+
+/* ---- Root and children -------------------------------------------------- */
+
+/* Create the root on the first NEW_CHILD, from addr=/len= or of @size. */
+static int mps_root_ensure(u64 size)
+{
+	struct page *pages = NULL;
+	unsigned long npages;
+
+	lockdep_assert_held(&mps_root.lock);
+	if (mps_root.npages)
+		return 0;
+
+	if (addr && len) {
+		if (mps_root.fixed_setup)
+			return -EBUSY;
+		mps_root.base_pfn = addr >> PAGE_SHIFT;
+		npages = len >> PAGE_SHIFT;
+	} else {
+		if (!size || !PAGE_ALIGNED(size))
+			return -EINVAL;
+		npages = size >> PAGE_SHIFT;
+		pages = mps_alloc_region(npages);
+		if (!pages)
+			return -ENOMEM;
+		mps_root.base_pfn = page_to_pfn(pages);
+	}
+	mps_root.owned = bitmap_zalloc(npages, GFP_KERNEL);
+	mps_root.donated = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!mps_root.owned || !mps_root.donated) {
+		bitmap_free(mps_root.owned);
+		bitmap_free(mps_root.donated);
+		mps_root.owned = NULL;
+		mps_root.donated = NULL;
+		if (pages)
+			free_contig_range(page_to_pfn(pages), npages);
+		return -ENOMEM;
+	}
+	mps_root.cma_pages = pages;
+	mps_root.npages = npages;
+	return 0;
+}
+
+static void mps_root_teardown(void)
+{
+	if (!mps_root.npages)
+		return;
+	WARN_ON(!list_empty(&mps_root.children));
+	if (mps_root.cma_pages)
+		free_contig_range(mps_root.base_pfn, mps_root.npages);
+	bitmap_free(mps_root.owned);
+	bitmap_free(mps_root.donated);
+}
+
+/* A page-aligned byte range of the root as page indices [first, last). */
+static int mps_root_range(u64 offset, u64 length, unsigned long *first,
+			  unsigned long *last)
+{
+	if (!length || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(length))
+		return -EINVAL;
+	*first = offset >> PAGE_SHIFT;
+	*last = *first + (length >> PAGE_SHIFT);
+	if (*last <= *first || *last > mps_root.npages)
+		return -EINVAL;
+	return 0;
+}
+
+/* Return a referenced child file made by NEW_CHILD. */
+static struct file *mps_get_child(int fd, struct mps_info **infop)
+{
+	struct file *file = fget(fd);
+
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &mps_file_fops.fops ||
+	    !((struct mps_info *)file->private_data)->owned) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+	*infop = file->private_data;
+	return file;
+}
+
+static long mps_ctl_new_child(void __user *uarg)
+{
+	struct mps_new_child nc;
+	unsigned long first, last, i, grant = 0;
+	struct mps_info *info;
+	unsigned long *owned;
+	struct file *file;
+	int fd, ret;
+
+	if (copy_from_user(&nc, uarg, sizeof(nc)))
+		return -EFAULT;
+	if ((nc.flags & ~MPS_FLAG_MMAP_CAPABLE) || nc.pad)
+		return -EINVAL;
+
+	mutex_lock(&mps_root.lock);
+	ret = mps_root_ensure(nc.offset + nc.len);
+	if (ret)
+		goto out_unlock;
+	ret = mps_root_range(nc.offset, nc.len, &first, &last);
+	if (ret)
+		goto out_unlock;
+
+	/* A child that would get no page is likely a mistake. */
+	for (i = first; i < last; i++)
+		if (!test_bit(i, mps_root.owned) &&
+		    !test_bit(i, mps_root.donated))
+			grant++;
+	if (!grant) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	owned = bitmap_zalloc(last - first, GFP_KERNEL);
+	if (!owned) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	fd = mps_new_file(mps_root.base_pfn + first, last - first, nc.flags,
+			  &info, &file);
+	if (fd < 0) {
+		bitmap_free(owned);
+		ret = fd;
+		goto out_unlock;
+	}
+	if (mps_over_fixed_mappable(info)) {
+		if (mps_fixed_wb_get()) {
+			put_unused_fd(fd);
+			fput(file);
+			bitmap_free(owned);
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		info->fixed_wb = true;
+	}
+
+	/* No other thread can reach the child until fd_install(). */
+	for (i = first; i < last; i++) {
+		if (test_bit(i, mps_root.owned) ||
+		    test_bit(i, mps_root.donated))
+			continue;
+		__set_bit(i - first, owned);
+		__set_bit(i, mps_root.owned);
+	}
+	info->owned = owned;
+	info->root_index = first;
+	list_add(&info->root_link, &mps_root.children);
+	mutex_unlock(&mps_root.lock);
+	fd_install(fd, file);
+	return fd;
+
+out_unlock:
+	mutex_unlock(&mps_root.lock);
+	return ret;
+}
+
+/* Take [first, last) of the root from @info.  Called under mps_root.lock. */
+static void mps_child_lose(struct mps_info *info, unsigned long first,
+			   unsigned long last)
+{
+	unsigned long s = first - info->root_index;
+	unsigned long e = last - info->root_index;
+
+	mutex_lock(&info->lock);
+	bitmap_clear(info->owned, s, e - s);
+	mps_revoke(info, s, e);
+	mutex_unlock(&info->lock);
+	bitmap_clear(mps_root.owned, first, last - first);
+}
+
+/* Give [first, last) of the root to @info.  Called under mps_root.lock. */
+static void mps_child_gain(struct mps_info *info, unsigned long first,
+			   unsigned long last)
+{
+	unsigned long s = first - info->root_index;
+	unsigned long e = last - info->root_index;
+
+	mutex_lock(&info->lock);
+	bitmap_set(info->owned, s, e - s);
+	mps_revoke(info, s, e);
+	mutex_unlock(&info->lock);
+	bitmap_set(mps_root.owned, first, last - first);
+}
+
+static bool mps_child_covers(struct mps_info *info, unsigned long first,
+			     unsigned long last)
+{
+	return first >= info->root_index &&
+	       last <= info->root_index + info->npages;
+}
+
+static bool mps_child_owns(struct mps_info *info, unsigned long first,
+			   unsigned long last)
+{
+	unsigned long s = first - info->root_index;
+	unsigned long e = last - info->root_index;
+
+	return mps_child_covers(info, first, last) &&
+	       find_next_zero_bit(info->owned, e, s) >= e;
+}
+
+static long mps_ctl_move(void __user *uarg)
+{
+	struct mps_move mv;
+	struct mps_info *src, *dst;
+	unsigned long first, last;
+	struct file *sf, *df;
+	long ret;
+
+	if (copy_from_user(&mv, uarg, sizeof(mv)))
+		return -EFAULT;
+	sf = mps_get_child(mv.src_fd, &src);
+	if (IS_ERR(sf))
+		return PTR_ERR(sf);
+	df = mps_get_child(mv.dst_fd, &dst);
+	if (IS_ERR(df)) {
+		fput(sf);
+		return PTR_ERR(df);
+	}
+
+	mutex_lock(&mps_root.lock);
+	ret = mps_root_range(mv.offset, mv.len, &first, &last);
+	if (ret)
+		goto out;
+	if (src == dst || !mps_child_owns(src, first, last) ||
+	    !mps_child_covers(dst, first, last)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	/* Revoke from the source before the destination gets the pages. */
+	mps_child_lose(src, first, last);
+	mps_child_gain(dst, first, last);
+out:
+	mutex_unlock(&mps_root.lock);
+	fput(df);
+	fput(sf);
+	return ret;
+}
+
+static long mps_ctl_donate(void __user *uarg, bool reclaim)
+{
+	struct mps_donate d;
+	unsigned long first, last;
+	struct mps_info *info;
+	struct file *file;
+	long ret;
+
+	if (copy_from_user(&d, uarg, sizeof(d)))
+		return -EFAULT;
+	if (d.pad)
+		return -EINVAL;
+	file = mps_get_child(d.fd, &info);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	mutex_lock(&mps_root.lock);
+	ret = mps_root_range(d.offset, d.len, &first, &last);
+	if (ret)
+		goto out;
+	if (!reclaim) {
+		if (!mps_child_owns(info, first, last)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		mps_child_lose(info, first, last);
+		bitmap_set(mps_root.donated, first, last - first);
+	} else {
+		if (!mps_child_covers(info, first, last) ||
+		    find_next_zero_bit(mps_root.donated, last, first) < last) {
+			ret = -EINVAL;
+			goto out;
+		}
+		bitmap_clear(mps_root.donated, first, last - first);
+		mps_child_gain(info, first, last);
+	}
+out:
+	mutex_unlock(&mps_root.lock);
+	fput(file);
+	return ret;
+}
+
+/*
+ * CTL_SET_READONLY and CTL_SET_PRESENT change a child's pages, by the owner on
+ * the control device.  A VMM that holds the child fd cannot, so it cannot undo
+ * them.
+ */
+static long mps_ctl_set_range(void __user *uarg, bool readonly)
+{
+	struct mps_ctl_range cr;
+	unsigned long start, end;
+	struct mps_info *info;
+	struct file *file;
+	int ret;
+
+	if (copy_from_user(&cr, uarg, sizeof(cr)))
+		return -EFAULT;
+	if (cr.value > 1)
+		return -EINVAL;
+	file = mps_get_child(cr.fd, &info);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ret = mps_range(info, cr.offset, cr.len, &start, &end);
+	if (!ret) {
+		if (readonly)
+			mps_set_readonly(info, start, end, cr.value);
+		else
+			mps_set_present(info, start, end, cr.value);
+	}
+	fput(file);
+	return ret;
+}
+
+static long mps_ctl_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case MPS_SETUP:
+		return mps_ctl_setup(uarg);
+	case MPS_NEW_CHILD:
+		return mps_ctl_new_child(uarg);
+	case MPS_MOVE:
+		return mps_ctl_move(uarg);
+	case MPS_DONATE:
+		return mps_ctl_donate(uarg, false);
+	case MPS_RECLAIM:
+		return mps_ctl_donate(uarg, true);
+	case MPS_CTL_SET_READONLY:
+		return mps_ctl_set_range(uarg, true);
+	case MPS_CTL_SET_PRESENT:
+		return mps_ctl_set_range(uarg, false);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations mps_ctl_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= mps_ctl_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+};
+
+static struct miscdevice mps_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "mem_provider_sample",
+	.fops	= &mps_ctl_fops,
+};
+
+static int __init mps_init(void)
+{
+	int ret;
+
+	if ((addr || len) &&
+	    (!addr || !len || !PAGE_ALIGNED(addr) || !PAGE_ALIGNED(len))) {
+		pr_err("mem_provider_sample: addr= and len= must both be set and page aligned\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&mps_root.lock);
+	INIT_LIST_HEAD(&mps_root.children);
+
+	ret = misc_register(&mps_dev);
+	if (ret)
+		return ret;
+	return 0;
+}
+module_init(mps_init);
+
+static void __exit mps_exit(void)
+{
+	misc_deregister(&mps_dev);
+	mps_root_teardown();
+	if (mps_fixed_wb)
+		memunmap(mps_fixed_wb);
+}
+module_exit(mps_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Sample memory provider for guest_memfd and iommufd");
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
new file mode 100644
index 000000000000..3be453756d84
--- /dev/null
+++ b/samples/kvm/mem_provider_sample.h
@@ -0,0 +1,135 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H
+#define _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/*
+ * A sample memory provider (include/linux/mem_provider.h).
+ *
+ * Every fd that this module returns is a provider file.  Pass it as
+ * provider_fd to KVM_CREATE_GUEST_MEMFD with GUEST_MEMFD_FLAG_USE_PROVIDER,
+ * and as fd to IOMMU_IOAS_MAP_FILE.  Both consumers follow every change that
+ * the ioctls below make.
+ */
+
+/* Flags for struct mps_setup and struct mps_new_child */
+/* The host may map the pages; otherwise they are NO_USER_MAP */
+#define MPS_FLAG_MMAP_CAPABLE	(1u << 0)
+
+/*
+ * ioctl on /dev/mem_provider_sample: create a provider fd.
+ *
+ * If the module was loaded with addr= and len=, the fd covers that fixed
+ * range, which has no struct page, and @size is ignored.  The fixed range
+ * then has one owner.  SETUP fails with -EBUSY while a SETUP file uses it,
+ * or once the first MPS_NEW_CHILD has made it the root of the children, which
+ * lasts until the module is unloaded.  MPS_NEW_CHILD fails with -EBUSY while
+ * a SETUP file uses it.  Otherwise the fd covers @size bytes from
+ * alloc_contig_pages().
+ */
+struct mps_setup {
+	__u32 flags;	/* MPS_FLAG_* */
+	__u32 pad;
+	__u64 size;	/* bytes, page aligned */
+};
+
+#define MPS_IOCTL_BASE		'P'
+#define MPS_SETUP \
+	_IOW(MPS_IOCTL_BASE, 1, struct mps_setup)
+
+/*
+ * ---- A tree of owners --------------------------------------------------
+ *
+ * The control device owns one region, the root.  NEW_CHILD carves part of
+ * it into a new provider fd for one VM.  The owner can MOVE pages between
+ * children, DONATE pages to the root, so that no child has them, and
+ * RECLAIM them.  Each change revokes the range, so KVM and iommufd follow.
+ *
+ * The owner changes a child's pages through the control device
+ * (CTL_SET_READONLY, CTL_SET_PRESENT).  A child fd is read-only to its
+ * holder: a VMM can only GET_STATS, never change the memory.
+ */
+
+/*
+ * ioctl on /dev/mem_provider_sample: carve [@offset, @offset + @len) of the
+ * root into a new child fd.  The child gets every page of the range that no
+ * other child has and that is not donated.  Ranges of children may overlap,
+ * which is how a page can MOVE between them.  Returns the child fd.
+ */
+struct mps_new_child {
+	__u32 flags;	/* MPS_FLAG_* */
+	__u32 pad;
+	__u64 offset;	/* bytes into the root, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_NEW_CHILD \
+	_IOW(MPS_IOCTL_BASE, 5, struct mps_new_child)
+
+/*
+ * ioctl on /dev/mem_provider_sample: move [@offset, @offset + @len) of the root
+ * from child @src_fd to child @dst_fd.  @src_fd must have every page of the
+ * range, and the range must be inside @dst_fd's.  The pages are revoked from
+ * the source before the destination gets them, so the consumers of the two
+ * children never map them at the same time.
+ */
+struct mps_move {
+	__s32 src_fd;
+	__s32 dst_fd;
+	__u64 offset;	/* bytes into the root, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_MOVE \
+	_IOW(MPS_IOCTL_BASE, 6, struct mps_move)
+
+/*
+ * ioctls on /dev/mem_provider_sample: DONATE takes [@offset, @offset + @len) of
+ * the root from child @fd, which must have all of it, and keeps it at the
+ * root.  RECLAIM gives a donated range to child @fd, whose range must
+ * contain it.  The sample does not scrub the pages.
+ */
+struct mps_donate {
+	__s32 fd;
+	__u32 pad;
+	__u64 offset;	/* bytes into the root, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_DONATE \
+	_IOW(MPS_IOCTL_BASE, 7, struct mps_donate)
+#define MPS_RECLAIM \
+	_IOW(MPS_IOCTL_BASE, 8, struct mps_donate)
+
+/* ioctl on a child fd: read the child's state, for tests. */
+struct mps_stats {
+	__u64 region_offset;	/* the child's range in the root */
+	__u64 region_len;
+	__u64 owned_pages;	/* pages the child has */
+	__u64 absent_pages;	/* pages taken away by CTL_SET_PRESENT */
+	__u64 readonly_pages;
+};
+
+#define MPS_GET_STATS \
+	_IOR(MPS_IOCTL_BASE, 10, struct mps_stats)
+
+/*
+ * ioctls on /dev/mem_provider_sample: CTL_SET_READONLY or CTL_SET_PRESENT on
+ * child @fd, by the owner.  @value is the readonly or present value, and
+ * @offset and @len are a byte range within the child, page aligned.
+ */
+struct mps_ctl_range {
+	__s32 fd;
+	__u32 value;
+	__u64 offset;	/* bytes into the child, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MPS_CTL_SET_READONLY \
+	_IOW(MPS_IOCTL_BASE, 11, struct mps_ctl_range)
+#define MPS_CTL_SET_PRESENT \
+	_IOW(MPS_IOCTL_BASE, 12, struct mps_ctl_range)
+
+#endif /* _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H */
