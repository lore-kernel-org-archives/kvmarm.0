Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107624772A9
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194180; cv=none; b=uYAPi+RkYNTam17R1gPrn/JQoXGcRfwVKw9RkmunY4DHt0uUdpjftBfSlAvMK0ACXfkhmVMEVScMXYvr8aDseItau2WDYQVU3+CAM65jFLz+G4lYNQy/+bj2U0wNO6PvliDa2cNNrKsHzBpiU8mr2rwtj4eNOo3gEsEqCmAhy6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194180; c=relaxed/simple;
	bh=v+KH5eGoYs2jCU53ABvnk9S9xhuQKnXpBbQSWqRUCqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjZxRy6yYUy80SVnzNihOHHHN2CKhoQkkJjtcnYXOJxmC7JLfKMrb/3ZI9aDROMbzmrsRvAU4s535DlYV9Ht+WMBEJhkX60HiQxT8Fn9wL36wEpNRrQ+L634I3KukHwv48IORukN96d6FKjfk+CsEP7fl9irzNq5Rca8x3YWMoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhX4U6ps; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhX4U6ps"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ff2313so108232566b.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 02:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194165; x=1791798965; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5gp4q2pW0A0O+bmNJzt/rU25g/oL0Xv5CCySLYbDEHs=;
        b=hhX4U6ps0rcempkyrqq5TJiUzHn1dWQ4KRcT8hTvCv0RLoLBwRE1acZhHuxro5/qBe
         GEJr0Gk56k6nIBe0tsQBb6UttY4htJVVbea3cySlN2cCmjmxTwJa9sFlsDvhDGxFHtX9
         vYywPx19UlgkHeQUGVmHLbwNhMpwiKvJWLlZLZwAV0m8BIkdArhH/wUe4xjsPIRHICmw
         ffrkSyrHYlOEx+cGxhRx3DdYT9dxBwZX1yRuXvvOI3Pz4xhhVirt+9fPXCcFe2ucwgTn
         4mRVT7jF9CzZ5YoLrb01sWOkl+tQhxx09VJoEiunvghHAEqvOqbj2wMzmwgZKl+xqY7J
         /aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194165; x=1791798965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5gp4q2pW0A0O+bmNJzt/rU25g/oL0Xv5CCySLYbDEHs=;
        b=htxKLyHCoawKuGsSY6DffYnrXsGGLNB4Cmqld89Mg3wLiVwII/dkIyUGzTlXmMT+sI
         66Wu/hr1tT+3gHipnzDJtHnJQU2u7bnjenXwKyH8YIoWgTUNcYG5fNaCw4HthP/yhiYR
         mkw+UulGOnshpcVIBDdAWgEX2jeTDnDmQiuq6A5VpZMOBxJVCS70SOsY2RTFSlpqrI5t
         FeVjSb8OTYP4xaM/OZM4t5RL5jSYJuHCG1rvR1ehLN2HDMBZ3QEw5j6LqoD2A9J86fQI
         GEHGZDfu5hN4m3NcCmqY8UwkPw3knHuWq8uT2P4VmFYcWPy3zyX8zFbVNiHynrE1EJMv
         gN5w==
X-Forwarded-Encrypted: i=1; AKwUvBxvnHSoD/dWqgmUzElpJBfm/TOP/wIbRKOvUktxut0kyLvK/+4VFdT1LvP4WCcUdPTEf5b5mMI=@lists.linux.dev
X-Gm-Message-State: AFq9FYI46m1CX1ukHqyvsE/yFmI1+N9Ka0xeDUspUac2d5G3AELAz+vb
	qa9cK7eF/UvMH/dzYtHpttBMu+SZEW4lTpjITEl99fuAF5i5sP9+lnvt
X-Gm-Gg: AYBFou3D0d71lCBURUj5ey9Zm+FoRQkCQKtRBbGD5YbzHMlc59Mr/u5bTAZ5LpmA7zC
	IH6YX0kU3P64DhxBdMgeoKSZZ730UsgpYtn62lF0QbjS1m3iUeIuyMGnHRWgBFcJMG0Uv8e/g93
	f28Fu3aVSZJaZ75HNrPr90nWPYwHlc9YLTufWYYbx+OsiTdghyqmyiezAU3Bepr4WE8es5RWhP9
	QCakJ8agt8D0tn9MxK8zQxVE59QOY4JsQZ6Jck6FuF4J6qsIqdmvHYSw5lInbhxz2LCE3h/h2U4
	v9ZjXGDoZCfwSoS0Dy5G1nEmg0S5YL2MKYOZIZhf7nvak70EwAWXOxG0cVxKWxcvcf+cFNvvMo6
	Ww53ZYnlmlZ7GCnzPCmoms3uFXNB1BBsiz5vtz8L5IGXXQliqToRc87aZm6XUjNWTC20HKgIOmP
	BRY6wuOS/Q1InMvZo0kDKJzLeO2Ghz2kQzc9DVaasvrzcOT2LKewxcN4gbHPRdzqe4UouehK20t
	PYeC++bSgtZ4w4TbWCjYeXxL8GnkpzcJbotEsnZ4Kt2i1XUBFIVW2PnuuEfMJcGZ4US/3dOwpd6
	79Bar16VIlZ/9yjTC3y6Zibp4d+ti8/fhxQ=
X-Received: by 2002:a17:907:3f1e:b0:c2e:902e:5208 with SMTP id a640c23a62f3a-c2e902e54a4mr220007966b.5.1791194162779;
        Mon, 05 Oct 2026 02:56:02 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562aba16sm50753266b.23.2026.10.05.02.56.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 02:56:01 -0700 (PDT)
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
Subject: [RFC PATCH 6/6] samples/kvm, selftests/kvm: Exercise dma-buf backing
Date: Mon,  5 Oct 2026 09:55:52 +0000
Message-ID: <20261005095552.52748-7-griffoul@gmail.com>
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
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Turn the sample into a dma-buf exporter, and move every supported test
to dma-buf-backed guest_memfd. Doing both in one commit avoids a state
where the sample and the tests use different interfaces.

The sample owns one root region and creates a child descriptor for each
VM. It supports moving, donating and reclaiming pages, absent pages,
read-only ranges, a scratch page and per-child ioctl allowlists.

The sample's get_phys() reports the run at the requested offset. It
uses bitmap searches to find where presence or read-only state changes.
An absent page returns -ENOENT. In scratch mode, an absent page of a
root child is reported as the read-only scratch page instead. Scratch
mode applies only to root children, because a mode change invalidates
only them. Every change of ownership sends a ranged invalidation.

Each test passes one dma-buf fd to both guest_memfd and iommufd. New
tests cover:

- two VMMs, checking what the guest, the device and the host see;
- SET_PRESENT and SET_READONLY racing with one KVM_CREATE_GUEST_MEMFD,
  so that lockdep checks attachment setup;
- a 2 MiB-aligned region in which every other page is replaced by the
  scratch page. The guest reads zeros and its own data, and KVM maps
  the region with 4 KiB pages. An untouched aligned region still maps
  at 2 MiB.

The sample sizes the CMA root before children overlap, and publishes
each child only after its ownership and allowlist are set. Confidential
VMs are out of scope; their test is an explicit skip.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 samples/kvm/gmem_provider.c                   | 1287 ++++++++++-------
 samples/kvm/gmem_provider.h                   |  144 +-
 tools/testing/selftests/kvm/Makefile.kvm      |    3 +-
 .../kvm/gmem_provider_nvme_dma_test.c         |   28 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   25 +-
 .../testing/selftests/kvm/x86/gmem_poc_test.c |  824 +++++++++++
 .../kvm/x86/gmem_provider_hugepage_test.c     |   30 +-
 .../kvm/x86/gmem_provider_iommufd_test.c      |   42 +-
 .../kvm/x86/gmem_provider_readonly_test.c     |  172 +++
 .../kvm/x86/gmem_provider_revoke_test.c       |   34 +-
 .../selftests/kvm/x86/gmem_provider_test.c    |  190 +--
 .../kvm/x86/gmem_provider_vfio_test.c         |   45 +-
 12 files changed, 2091 insertions(+), 733 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/gmem_poc_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c

diff --git a/samples/kvm/gmem_provider.c b/samples/kvm/gmem_provider.c
index b6824fe5d228..2cde5bcb71ca 100644
--- a/samples/kvm/gmem_provider.c
+++ b/samples/kvm/gmem_provider.c
@@ -1,43 +1,46 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * gmem_provider - sample external guest_memfd provider.
+ * gmem_provider - sample owner of page-less memory, shared as a dma-buf.
  *
- * Demonstrates the KVM guest_memfd provider ABI with two backing modes:
+ * A toy owner of physical memory: one root region carved into children, one
+ * child per VM, ranges that MOVE between children or are DONATEd to the root
+ * and RECLAIMed, a shared scratch frame for revoked pages, and a per-fd
+ * ioctl allowlist fixed by the creator.  The provider owns the frames and is
+ * the single authority for who may map them.
  *
- *  - External (page-less): loaded with addr=/len=, backs guest memory with a
- *    fixed physical range that has no struct page -- e.g. memory carved out of
- *    the kernel with mem= on the command line.  This is the case the provider
- *    ABI exists for; get_pfn() returns bare PFNs KVM treats as non-refcounted.
+ * It is a dma-buf exporter and nothing else.  A child fd hands out a dma-buf
+ * for the child's memory; a VMM gives that dma-buf to KVM_CREATE_GUEST_MEMFD
+ * for the guest and to iommufd for its devices.  An ownership change here is
+ * one ranged invalidation of the child's dma-bufs; every importer drops the
+ * changed view and re-reads the layout. The owner knows nothing of KVM, or which
+ * importer is a guest and which is a device.
  *
- *  - CMA fallback (page-backed): when addr=/len= are not given, allocates a
- *    physically contiguous region via alloc_contig_pages() sized by the setup
- *    ioctl.  Easier to run (no mem= boot param), and still exercises 2M/1G
- *    mappings.  Not preserved across kexec/live update.
- *
- * On SEV-SNP hosts, bind() resets the range's RMP entries to 4K shared so a
- * (new) SNP VM can re-encrypt it, which is what allows re-binding the range to
- * a fresh VM across a live update.
+ * Backing:
+ *  - External (page-less): loaded with addr=/len=, a fixed physical range with
+ *    no struct page, e.g. carved out with memmap= on the command line.
+ *  - CMA fallback: without addr=/len=, alloc_contig_pages() sized by SETUP.
  *
  * Usage:
- *   # page-less external range:
- *   insmod gmem_provider.ko addr=0x5D40000000 len=0x1000000
- *   # or CMA fallback (no params); size comes from the ioctl
- *   insmod gmem_provider.ko
- *   fd = open("/dev/gmem_provider"); ioctl(fd, GMEM_PROVIDER_SETUP, {kvm_fd, size});
- *   pass the returned fd + KVM_MEM_GUEST_MEMFD to KVM_SET_USER_MEMORY_REGION2.
+ *   insmod gmem_provider.ko addr=0x180000000 len=0x42000000
+ *   ctl = open("/dev/gmem_provider");
+ *   child = ioctl(ctl, GMEM_PROVIDER_NEW_CHILD, {offset, len, allow}); # control
+ *   dmabuf = ioctl(child, GMEM_PROVIDER_GET_DMABUF);                     # VMM
+ *   gmem = ioctl(vm, KVM_CREATE_GUEST_MEMFD, {size, USE_DMABUF, dmabuf});
+ *   KVM_SET_USER_MEMORY_REGION2(..., KVM_MEM_GUEST_MEMFD, gmem);
+ *   IOMMU_IOAS_MAP_FILE(ioas, dmabuf, ...);
+ *
+ * The one rule: change ownership state, drop the provider lock, then revoke.
  */
 
 #include <linux/anon_inodes.h>
-#include <linux/bitmap.h>
 #include <linux/dma-buf.h>
-#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
+#include <linux/bitmap.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
-#include <linux/kvm_host.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -50,7 +53,6 @@
 
 #include "gmem_provider.h"
 
-MODULE_IMPORT_NS("DMA_BUF");
 
 static unsigned long long addr;
 module_param(addr, ullong, 0444);
@@ -63,444 +65,294 @@ MODULE_PARM_DESC(len, "size in bytes of the external backing region (optional)")
 
 struct gmem_info {
 	/*
-	 * MUST be first: file->private_data points here.  is_kvm_gmem_file()
-	 * on the KVM side proves the reinterpretation is safe.
-	 */
-	struct kvm_gmem_backing backing;
-
-	/*
-	 * Protects everything below (except the immutable base_pfn/npages/
-	 * cma_pages fields set at setup).  Ordering: info->lock is a leaf;
-	 * do not acquire other locks under it.  KVM's slots_lock is already
-	 * held on the .bind/.unbind paths so info->lock is only needed to
-	 * serialise those against ioctl(SET_PRESENT).
+	 * Protects everything below except the immutable fields set at setup
+	 * and the dma-buf list.  Ordering: gmem_root.lock, then
+	 * info->dmabufs_lock, then a dma-buf reservation.  info->lock is a
+	 * leaf: it is dropped before any invalidation.
 	 */
 	struct mutex lock;
 
-	/* Kept locally: kvm_gmem_ops does not carry a kvm pointer. */
-	struct kvm *kvm;
-
-	/*
-	 * Single active memslot binding.  Used at release time to zap any
-	 * still-active guest mappings before the memory disappears.  NULL
-	 * when no memslot is bound (or the last one has been unbound).
-	 */
-	struct kvm_memory_slot *bound_slot;
 
-	bool mmap_capable;			/* -> KVM_MEMSLOT_GMEM_ONLY at bind */
+	bool mmap_capable;			/* child and dma-buf may be mmap()ed */
 
 	unsigned long base_pfn;
 	unsigned long npages;
-	struct page *cma_pages;			/* non-NULL if CMA-allocated */
-	gfn_t base_gfn;				/* recorded at bind, for revoke */
-	pgoff_t pgoff;				/* provider offset (pages) of the slot */
+	struct page *cma_pages;			/* non-NULL if CMA-allocated (SETUP path only) */
+
+	/*
+	 * Toy descriptor tree.  A child created by NEW_CHILD is a sub-range
+	 * of the root region: @root_index is its first page within the root,
+	 * @owned marks which of its pages are currently granted to it (a page
+	 * MOVEd out or DONATEd is not owned; a page revoked by SET_PRESENT is
+	 * owned but absent).  @allow is the ioctl allowlist.  SETUP-created
+	 * providers have no root and own everything.
+	 */
+	unsigned long root_index;
+	unsigned long *owned;			/* NULL for SETUP-created providers */
+	u32 allow;
+	struct list_head root_link;		/* gmem_root.children */
 	unsigned long *absent;			/* bitmap of currently-revoked pages */
-	struct list_head dmabufs;		/* struct gmem_dmabuf entries */
-	struct mutex dmabufs_lock;
+	unsigned long *readonly;		/* bitmap of pages the guest may not write */
+	struct address_space *mapping;		/* our file's: host windows live here */
+	struct list_head dmabufs;		/* exported dma-bufs (struct gmem_dmabuf) */
+	struct mutex dmabufs_lock;		/* protects @dmabufs */
 };
 
 static struct gmem_info *to_gmem_info(struct file *file)
 {
-	return container_of(file->private_data, struct gmem_info, backing);
+	return file->private_data;
 }
 
-/* Map a backing PFN for CPU access: page-backed via kmap, page-less via memremap. */
-static void *gmem_map_pfn(kvm_pfn_t pfn)
-{
-	if (pfn_valid(pfn))
-		return kmap_local_pfn(pfn);
-	return memremap(PFN_PHYS(pfn), PAGE_SIZE, MEMREMAP_WB);
-}
+/*
+ * The root of the toy descriptor tree: one backing region owned by the
+ * control device.  Children carve sub-ranges out of it.  All ownership
+ * transitions (NEW_CHILD, MOVE, DONATE, RECLAIM) run under root.lock, which
+ * is taken before any child's info->lock.
+ */
+static struct gmem_root {
+	struct mutex lock;			/* protects the fields below */
+	unsigned long base_pfn;
+	unsigned long npages;
+	struct page *cma_pages;
+	unsigned long *owned;			/* pages some child currently owns */
+	unsigned long *donated;			/* pages parked at the root */
+	struct list_head children;
+	bool scratch_enabled;
+} gmem_root;
 
-static void gmem_unmap_pfn(kvm_pfn_t pfn, void *vaddr)
-{
-	if (!vaddr)
-		return;
-	if (pfn_valid(pfn))
-		kunmap_local(vaddr);
-	else
-		memunmap(vaddr);
-}
+/*
+ * One zeroed scratch frame for the whole module.  When scratch mode is on,
+ * a revoked page of a root child reports this frame read-only to every
+ * importer, so a device that cannot tolerate an IOMMU fault lands here.
+ */
+static struct page *gmem_scratch_page;
 
-/* Largest order KVM may map at @gfn, snapped to 4K/2M/1G. */
-static int gmem_max_order(struct gmem_info *info, gfn_t gfn, unsigned long index)
+static inline unsigned long gmem_scratch_pfn(void)
 {
-	unsigned long pfn = info->base_pfn + index;
-	unsigned long remaining = info->npages - index;
-	unsigned int pud_order = PUD_SHIFT - PAGE_SHIFT;
-	unsigned int pmd_order = PMD_SHIFT - PAGE_SHIFT;
-	unsigned long absent_next;
-
-	/*
-	 * A hugepage may not span any revoked page.  Clamp by the distance to
-	 * the next absent bit; scanning is cheap because @absent is a plain
-	 * bitmap and the caller already checked test_bit(index).
-	 */
-	if (info->absent) {
-		absent_next = find_next_bit(info->absent, info->npages,
-					    index + 1);
-		remaining = min(remaining, absent_next - index);
-	}
-
-	if (IS_ALIGNED(pfn, 1UL << pud_order) &&
-	    IS_ALIGNED(gfn, 1UL << pud_order) &&
-	    remaining >= (1UL << pud_order))
-		return pud_order;
-
-	if (IS_ALIGNED(pfn, 1UL << pmd_order) &&
-	    IS_ALIGNED(gfn, 1UL << pmd_order) &&
-	    remaining >= (1UL << pmd_order))
-		return pmd_order;
-
-	return 0;
+	return page_to_pfn(gmem_scratch_page);
 }
 
-static int gmem_get_pfn(struct file *file, struct kvm *kvm,
-			struct kvm_memory_slot *slot, gfn_t gfn,
-			kvm_pfn_t *pfn, struct page **page, int *max_order,
-			bool *writable)
+/*
+ * Is page @index of @info currently reachable by the guest and devices?
+ * Callable with or without info->lock: every change to the bitmaps is
+ * followed by an invalidation of the range, so a lock-free answer is either
+ * current or about to be superseded.
+ */
+static inline bool gmem_page_present(struct gmem_info *info, unsigned long index)
 {
-	struct gmem_info *info = to_gmem_info(file);
-	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
-
-	if (index >= info->npages)
-		return -EINVAL;
-
-	/* Revoked (absent) page: behave like not-present so the fault fails. */
+	if (info->owned && !test_bit(index, info->owned))
+		return false;
 	if (info->absent && test_bit(index, info->absent))
-		return -EFAULT;
-
-	*pfn = info->base_pfn + index;
-	if (max_order)
-		*max_order = gmem_max_order(info, gfn, index);
-	return 0;
+		return false;
+	return true;
 }
 
-static int gmem_populate(struct file *file, struct kvm *kvm,
-			 struct kvm_memory_slot *slot, gfn_t gfn,
-			 kvm_pfn_t *pfn, struct page *src_page, int order)
-{
-	struct gmem_info *info = to_gmem_info(file);
-	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
-
-	if (index >= info->npages)
-		return -EINVAL;
-
-	*pfn = info->base_pfn + index;
+static void gmem_release(struct file *file);
+static int gmem_mmap(struct file *file, struct vm_area_struct *vma);
+static long gmem_fd_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
-	if (src_page) {
-		void *dst, *src;
 
-		/* Map dst first: memremap() may sleep, kmap_local_page() must not. */
-		dst = gmem_map_pfn(*pfn);
-		if (!dst)
-			return -ENOMEM;
-		src = kmap_local_page(src_page);
-		memcpy(dst, src, PAGE_SIZE);
-		kunmap_local(src);
-		gmem_unmap_pfn(*pfn, dst);
-	}
-	return 0;
-}
-
-static int gmem_bind(struct file *file, struct kvm *kvm,
-		     struct kvm_memory_slot *slot, loff_t offset)
+static void gmem_release(struct file *file)
 {
 	struct gmem_info *info = to_gmem_info(file);
-	struct kvm *old_kvm = NULL;
-	unsigned long start = offset >> PAGE_SHIFT;
-
-	if (offset < 0 || !PAGE_ALIGNED(offset) ||
-	    start + slot->npages > info->npages)
-		return -EINVAL;
 
 	/*
-	 * An mmap-capable backing hands the VMM a host mapping onto pages
-	 * that a hardware-encrypted VM (SEV, SEV-ES, SEV-SNP, TDX) will mark
-	 * private in the RMP/EPT; the mmap can only ever fault on those
-	 * pages.  Refuse rather than hand the VMM a useless (and misleading)
-	 * shared view.  SW_PROTECTED_VM has no hardware encryption and is
-	 * fine.
+	 * Every exported dma-buf holds a reference on this file, so none can
+	 * be alive here: no device and no guest_memfd still maps our frames.
 	 */
-#ifdef CONFIG_X86
-	if (info->mmap_capable &&
-	    (kvm->arch.vm_type == KVM_X86_SEV_VM ||
-	     kvm->arch.vm_type == KVM_X86_SEV_ES_VM ||
-	     kvm->arch.vm_type == KVM_X86_SNP_VM ||
-	     kvm->arch.vm_type == KVM_X86_TDX_VM))
-		return -EACCES;
-#endif
+	WARN_ON(!list_empty(&info->dmabufs));
 
-	/* Record the binding so the revoke ioctl can translate offset -> gfn. */
-	mutex_lock(&info->lock);
-	info->base_gfn = slot->base_gfn;
-	info->pgoff = start;
-	info->bound_slot = slot;
-	mutex_unlock(&info->lock);
-
-#if IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)
 	/*
-	 * Reset the RMP for the range to 4K shared so a (new) SEV-SNP VM can
-	 * transition it to private and re-encrypt it.  PSMASH any 2M entries
-	 * first.  Harmless on non-SNP hosts, where these return -ENODEV.
+	 * A child returns its carved range to the root.  Pages it still owned
+	 * become free again; pages it had DONATEd stay parked at the root
+	 * (still in gmem_root.donated) until RECLAIM or module exit; pages
+	 * MOVEd out belong to another child and are not ours to free.
 	 */
-	{
+	if (info->owned) {
 		unsigned long i;
-		unsigned long first_pmd_pfn = ALIGN(info->base_pfn + start,
-						    PTRS_PER_PMD);
-
-		for (i = first_pmd_pfn - (info->base_pfn + start);
-		     i + PTRS_PER_PMD <= slot->npages;
-		     i += PTRS_PER_PMD)
-			psmash(info->base_pfn + start + i);
 
-		for (i = 0; i < slot->npages; i++) {
-			unsigned long pfn = info->base_pfn + start + i;
-			int ret = rmp_make_shared(pfn, PG_LEVEL_4K);
-
-			if (ret && ret != -ENODEV)
-				pr_info_once("gmem_provider: rmp_make_shared(0x%lx) = %d\n",
-					     pfn, ret);
-		}
+		mutex_lock(&gmem_root.lock);
+		list_del(&info->root_link);
+		for_each_set_bit(i, info->owned, info->npages)
+			__clear_bit(info->root_index + i, gmem_root.owned);
+		mutex_unlock(&gmem_root.lock);
+		kvfree(info->owned);
 	}
-#endif
-
-	/*
-	 * Claim (or, on re-bind, transfer) VM ownership; pins the VM.
-	 * kvm_put_kvm(old_kvm) MUST run outside info->lock: if the put
-	 * drops the last ref, kvm_destroy_vm() runs inline and calls back
-	 * into our gmem_unbind() (via kvm_gmem_unbind() on each memslot),
-	 * which needs info->lock -- taking it here would self-deadlock.
-	 */
-	mutex_lock(&info->lock);
-	if (info->kvm != kvm) {
-		old_kvm = info->kvm;
-		kvm_get_kvm(kvm);
-		info->kvm = kvm;
-	}
-	mutex_unlock(&info->lock);
-	if (old_kvm)
-		kvm_put_kvm(old_kvm);
-
-	/*
-	 * Record the file on the slot (KVM's outer bind no longer does this
-	 * for us) and mark the slot gmem-only if this backing serves host
-	 * accesses through its own mmap.
-	 */
-	WRITE_ONCE(slot->gmem.file, file);
-	slot->gmem.pgoff = start;
-	if (info->mmap_capable)
-		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
-
-	return 0;
+	if (info->cma_pages)
+		free_contig_range(info->base_pfn, info->npages);
+	kvfree(info->absent);
+	kvfree(info->readonly);
+	kfree(info);
+	module_put(THIS_MODULE);
 }
 
-static void gmem_unbind(struct file *file, struct kvm *kvm,
-			struct kvm_memory_slot *slot)
+static vm_fault_t gmem_vm_fault(struct vm_fault *vmf)
 {
-	struct gmem_info *info = to_gmem_info(file);
-
-	mutex_lock(&info->lock);
-	if (info->bound_slot == slot)
-		info->bound_slot = NULL;
-	mutex_unlock(&info->lock);
-
-#if IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)
-	{
-		unsigned long start = slot->gmem.pgoff;
-		unsigned long first_pmd_pfn = ALIGN(info->base_pfn + start,
-						    PTRS_PER_PMD);
-		unsigned long i;
-
-		/*
-		 * Symmetric with gmem_bind(): PSMASH any 2M RMP entries first
-		 * so rmp_make_shared(PG_LEVEL_4K) can succeed on SNP hosts.
-		 * Harmless on non-SNP: psmash() returns -ENODEV.
-		 */
-		for (i = first_pmd_pfn - (info->base_pfn + start);
-		     i + PTRS_PER_PMD <= slot->npages;
-		     i += PTRS_PER_PMD)
-			psmash(info->base_pfn + start + i);
+	/* The VMA's file is ours or a dma-buf's; the child rides in vm_private_data. */
+	struct gmem_info *info = vmf->vma->vm_private_data;
+	unsigned long index = vmf->pgoff;
 
-		for (i = 0; i < slot->npages; i++) {
-			unsigned long pfn = info->base_pfn + start + i;
-
-			rmp_make_shared(pfn, PG_LEVEL_4K);
-		}
-	}
-#endif
+	if (index >= info->npages || !gmem_page_present(info, index))
+		return VM_FAULT_SIGBUS;
+	return vmf_insert_pfn(vmf->vma, vmf->address, info->base_pfn + index);
 }
 
-static void gmem_release(struct file *file);
-static int gmem_mmap(struct file *file, struct vm_area_struct *vma);
-static long gmem_fd_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-
-static const struct kvm_gmem_ops gmem_ops = {
-	.bind		= gmem_bind,
-	.unbind		= gmem_unbind,
-	.get_pfn	= gmem_get_pfn,
-	.populate	= gmem_populate,
-	.release	= gmem_release,
-	.mmap		= gmem_mmap,
-	.ioctl		= gmem_fd_ioctl,
+static const struct vm_operations_struct gmem_vm_ops = {
+	.fault = gmem_vm_fault,
 };
 
-static void gmem_release(struct file *file)
-{
-	struct gmem_info *info = to_gmem_info(file);
-	struct kvm_memory_slot *slot;
-
-	/*
-	 * If a memslot is still bound at close time, KVM has not yet had a
-	 * chance to call ops->unbind.  Zap the guest mappings for the range
-	 * and clear slot->gmem.file so the eventual unbind is a no-op.  This
-	 * matches native gmem's kvm_gmem_release() and prevents the guest
-	 * from continuing to hit backing memory after we free it below.
-	 */
-	mutex_lock(&info->lock);
-	slot = info->bound_slot;
-	if (slot && info->kvm) {
-		kvm_gmem_invalidate_range(info->kvm, slot->base_gfn,
-					  slot->base_gfn + slot->npages);
-		WRITE_ONCE(slot->gmem.file, NULL);
-		info->bound_slot = NULL;
-	}
-	mutex_unlock(&info->lock);
-
-	if (info->kvm)
-		kvm_put_kvm(info->kvm);
-	if (info->cma_pages)
-		free_contig_range(info->base_pfn, info->npages);
-	kvfree(info->absent);
-	kfree(info);
-	module_put(THIS_MODULE);
-}
-
 static int gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gmem_info *info = to_gmem_info(file);
 	unsigned long npages = vma_pages(vma);
 
-	/*
-	 * gmem_bind() refuses to bind an mmap-capable fd to a coco VM.  A fd
-	 * that was created without GMEM_PROVIDER_FLAG_MMAP_CAPABLE has no
-	 * such gate at bind time, so its mmap must not succeed at any point.
-	 */
+	/* A fd created without GMEM_PROVIDER_FLAG_MMAP_CAPABLE is never host-mappable. */
 	if (!info->mmap_capable)
 		return -EPERM;
 
 	if (vma->vm_pgoff + npages > info->npages)
 		return -EINVAL;
 
-	/* Page-less backing: map raw PFNs, not folios. */
+	/*
+	 * Page-less backing: raw PFNs, inserted on fault, never at mmap()
+	 * time, so that a window torn down on a revoke comes back by itself
+	 * once the page is the child's again.
+	 */
 	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	return remap_pfn_range(vma, vma->vm_start, info->base_pfn + vma->vm_pgoff,
-			       npages << PAGE_SHIFT, vma->vm_page_prot);
+	vma->vm_private_data = info;
+	vma->vm_ops = &gmem_vm_ops;
+	return 0;
 }
 
 /*
- * Dynamic dma-buf exporter over the provider's backing.
- *
- * Follows the same shape as drivers/vfio/pci/vfio_pci_dmabuf.c: a per-dmabuf
- * priv holding a phys_vec, a revocable dynamic attach, and a "private
- * interconnect" symbol iommufd looks up to fetch phys directly (instead of
- * mapping through the DMA API).
+ * The dma-buf a child exports.
  *
- * A revoke on the provider (SET_PRESENT present=0) fans out to every exported
- * dma-buf via dma_buf_invalidate_mappings(), so iommufd (which registered a
- * revocable importer) tears down the IOMMU mapping alongside KVM's NPT zap.
+ * A child may hand out several dma-bufs over its life (one per holder of the
+ * fd who asks); each covers the whole child and pins this file until it is
+ * released. Importers must accept ranged invalidation: every change to the
+ * child's pages is sent to them, and they re-read get_phys().
  */
 struct gmem_dmabuf {
 	struct dma_buf *dmabuf;
 	struct gmem_info *info;
 	struct file *provider_file;		/* holds info alive */
 	struct list_head list;			/* info->dmabufs */
-	struct phys_vec phys;			/* single contiguous range */
-	struct kref kref;
-	struct completion comp;
-	bool revoked;
 };
 
 static int gmem_dma_buf_attach(struct dma_buf *dmabuf,
 			       struct dma_buf_attachment *attach)
 {
-	struct gmem_dmabuf *priv = dmabuf->priv;
-
-	if (!attach->peer2peer)
-		return -EOPNOTSUPP;
-	if (priv->revoked)
-		return -ENODEV;
-	if (!dma_buf_attach_revocable(attach))
+	/* Only importers that can be told to re-read may attach. */
+	if (!attach->peer2peer || !dma_buf_attach_revocable(attach))
 		return -EOPNOTSUPP;
 	return 0;
 }
 
-static void gmem_dma_buf_done(struct kref *kref)
-{
-	struct gmem_dmabuf *priv = container_of(kref, struct gmem_dmabuf, kref);
-
-	complete(&priv->comp);
-}
-
 static struct sg_table *gmem_dma_buf_map(struct dma_buf_attachment *attach,
 					 enum dma_data_direction dir)
 {
-	struct gmem_dmabuf *priv = attach->dmabuf->priv;
-	struct sg_table *sgt;
-
-	dma_resv_assert_held(priv->dmabuf->resv);
-	if (priv->revoked)
-		return ERR_PTR(-ENODEV);
-
-	/* RAM, not P2P MMIO: no p2pdma_provider. */
-	sgt = dma_buf_phys_vec_to_sgt(attach, NULL, &priv->phys, 1,
-				      priv->phys.len, dir);
-	if (IS_ERR(sgt))
-		return sgt;
-
-	kref_get(&priv->kref);
-	return sgt;
+	/* DMA-API importers are not served; use get_phys() (iommufd does). */
+	return ERR_PTR(-EOPNOTSUPP);
 }
 
 static void gmem_dma_buf_unmap(struct dma_buf_attachment *attach,
-			       struct sg_table *sgt,
-			       enum dma_data_direction dir)
+			       struct sg_table *sgt, enum dma_data_direction dir)
 {
-	struct gmem_dmabuf *priv = attach->dmabuf->priv;
+}
+
+/* A host window through the dma-buf: the same rules as a window on the child. */
+static int gmem_dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
+{
+	struct gmem_dmabuf *priv = dmabuf->priv;
 
-	dma_resv_assert_held(priv->dmabuf->resv);
-	dma_buf_free_sgt(attach, sgt, dir);
-	kref_put(&priv->kref, gmem_dma_buf_done);
+	return gmem_mmap(priv->provider_file, vma);
 }
 
 static void gmem_dma_buf_release(struct dma_buf *dmabuf)
 {
 	struct gmem_dmabuf *priv = dmabuf->priv;
+	struct gmem_info *info = priv->info;
 
-	if (priv->info) {
-		mutex_lock(&priv->info->dmabufs_lock);
-		list_del_init(&priv->list);
-		mutex_unlock(&priv->info->dmabufs_lock);
-	}
-	if (priv->provider_file)
-		fput(priv->provider_file);
+	mutex_lock(&info->dmabufs_lock);
+	list_del(&priv->list);
+	mutex_unlock(&info->dmabufs_lock);
+	fput(priv->provider_file);
 	kfree(priv);
 }
 
-/* Report this flat sample region through the generic dma-buf operation. */
+/* Return the first bit whose value differs from @index. */
+static unsigned long gmem_bitmap_next_change(const unsigned long *bitmap,
+					     unsigned long nbits,
+					     unsigned long index)
+{
+	if (!bitmap)
+		return nbits;
+	if (test_bit(index, bitmap))
+		return find_next_zero_bit(bitmap, nbits, index + 1);
+	return find_next_bit(bitmap, nbits, index + 1);
+}
+
+/* Find a run with one present/read-only disposition, without a per-bit scan. */
+static unsigned long gmem_disposition_end(struct gmem_info *info,
+					  unsigned long index)
+{
+	bool present = gmem_page_present(info, index);
+	bool readonly = info->readonly && test_bit(index, info->readonly);
+	unsigned long pos = index;
+
+	for (;;) {
+		unsigned long next = info->npages;
+
+		next = min(next, gmem_bitmap_next_change(info->owned,
+						   info->npages, pos));
+		next = min(next, gmem_bitmap_next_change(info->absent,
+						   info->npages, pos));
+		next = min(next, gmem_bitmap_next_change(info->readonly,
+						   info->npages, pos));
+		if (next >= info->npages ||
+		    gmem_page_present(info, next) != present ||
+		    (!!(info->readonly && test_bit(next, info->readonly))) != readonly)
+			return next;
+		pos = next;
+	}
+}
+
+/*
+ * Describe the run at @offset from the child's ownership bitmaps. A present
+ * page extends to the next page whose presence or read-only state differs,
+ * found with bitmap searches. An absent page is not backed, unless scratch
+ * mode substitutes the shared read-only scratch frame for that one page.
+ * Scratch mode covers only children of the root: SET_SCRATCH invalidates
+ * those, so a SETUP provider must never report the scratch frame.
+ */
 static int gmem_dma_buf_get_phys(struct dma_buf_attachment *attach,
 				 u64 offset, u64 len,
 				 struct phys_vec *phys, u32 *attr)
 {
 	struct gmem_dmabuf *priv = attach->dmabuf->priv;
+	struct gmem_info *info = priv->info;
+	unsigned long index = offset >> PAGE_SHIFT;
+	unsigned long end, run_end;
 
-	dma_resv_assert_held(attach->dmabuf->resv);
-	if (priv->revoked)
-		return -ENODEV;
+	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
+		return -EINVAL;
+	end = (offset + len) >> PAGE_SHIFT;
+
+	if (!gmem_page_present(info, index)) {
+		if (!info->owned || !READ_ONCE(gmem_root.scratch_enabled))
+			return -ENOENT;
+		phys->paddr = PFN_PHYS(gmem_scratch_pfn());
+		phys->len = PAGE_SIZE;
+		*attr = DMA_BUF_PHYS_ATTR_RAM | DMA_BUF_PHYS_ATTR_READONLY;
+		return 0;
+	}
 
-	phys->paddr = priv->phys.paddr + offset;
-	phys->len = len;
+	run_end = min(gmem_disposition_end(info, index), end);
+	phys->paddr = PFN_PHYS(info->base_pfn + index);
+	phys->len = (u64)(run_end - index) << PAGE_SHIFT;
 	*attr = DMA_BUF_PHYS_ATTR_RAM;
+	if (info->readonly && test_bit(index, info->readonly))
+		*attr |= DMA_BUF_PHYS_ATTR_READONLY;
 	return 0;
 }
 
@@ -510,23 +362,9 @@ static const struct dma_buf_ops gmem_dma_buf_ops = {
 	.unmap_dma_buf	= gmem_dma_buf_unmap,
 	.release	= gmem_dma_buf_release,
 	.get_phys	= gmem_dma_buf_get_phys,
+	.mmap		= gmem_dma_buf_mmap,
 };
 
-/* Called with info->dmabufs_lock held on the revoke path. */
-static void gmem_dma_buf_revoke_all(struct gmem_info *info)
-{
-	struct gmem_dmabuf *priv;
-
-	list_for_each_entry(priv, &info->dmabufs, list) {
-		dma_resv_lock(priv->dmabuf->resv, NULL);
-		if (!priv->revoked) {
-			priv->revoked = true;
-			dma_buf_invalidate_mappings(priv->dmabuf);
-		}
-		dma_resv_unlock(priv->dmabuf->resv);
-	}
-}
-
 static int gmem_provider_get_dmabuf(struct file *file)
 {
 	struct gmem_info *info = to_gmem_info(file);
@@ -537,27 +375,19 @@ static int gmem_provider_get_dmabuf(struct file *file)
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-
 	priv->info = info;
 	priv->provider_file = get_file(file);
-	priv->phys.paddr = (u64)info->base_pfn << PAGE_SHIFT;
-	priv->phys.len = (u64)info->npages << PAGE_SHIFT;
-	kref_init(&priv->kref);
-	init_completion(&priv->comp);
-	INIT_LIST_HEAD(&priv->list);
-
 	exp_info.ops = &gmem_dma_buf_ops;
-	exp_info.size = priv->phys.len;
+	exp_info.size = (u64)info->npages << PAGE_SHIFT;
 	exp_info.flags = O_RDWR;
 	exp_info.priv = priv;
-
 	priv->dmabuf = dma_buf_export(&exp_info);
 	if (IS_ERR(priv->dmabuf)) {
 		fd = PTR_ERR(priv->dmabuf);
+		fput(priv->provider_file);
 		kfree(priv);
 		return fd;
 	}
-
 	mutex_lock(&info->dmabufs_lock);
 	list_add(&priv->list, &info->dmabufs);
 	mutex_unlock(&info->dmabufs_lock);
@@ -568,14 +398,132 @@ static int gmem_provider_get_dmabuf(struct file *file)
 	return fd;
 }
 
+/*
+ * Tell every importer of @info that [start, end) changed.  The caller has
+ * already updated the bitmaps and dropped info->lock: an importer re-reads
+ * get_phys() from inside this.
+ */
+static void gmem_revoke_range(struct gmem_info *info,
+			      unsigned long start, unsigned long end)
+{
+	struct gmem_dmabuf *priv;
+
+	lockdep_assert_not_held(&info->lock);
+	mutex_lock(&info->dmabufs_lock);
+	list_for_each_entry(priv, &info->dmabufs, list) {
+		dma_resv_lock(priv->dmabuf->resv, NULL);
+		dma_buf_invalidate_mappings_range(priv->dmabuf,
+						  (u64)start << PAGE_SHIFT,
+						  (u64)(end - start) << PAGE_SHIFT);
+		dma_resv_unlock(priv->dmabuf->resv);
+	}
+	mutex_unlock(&info->dmabufs_lock);
+}
+
+/*
+ * The child lost the frames behind [start, end): host windows over them go
+ * too.  Not for a read-only flip or a scratch toggle, where the VMM may be
+ * the page's writer; the VMM re-maps after a grant.
+ */
+static void gmem_unmap_host(struct gmem_info *info, unsigned long start,
+			    unsigned long end)
+{
+	loff_t off = (loff_t)start << PAGE_SHIFT, len = (loff_t)(end - start) << PAGE_SHIFT;
+	struct gmem_dmabuf *priv;
+
+	if (end <= start)
+		return;
+	unmap_mapping_range(info->mapping, off, len, 1);
+	/* Windows through a dma-buf live on the dma-buf's own file. */
+	mutex_lock(&info->dmabufs_lock);
+	list_for_each_entry(priv, &info->dmabufs, list)
+		unmap_mapping_range(priv->dmabuf->file->f_mapping, off, len, 1);
+	mutex_unlock(&info->dmabufs_lock);
+}
+
+/* Which allowlist bit gates each child-fd ioctl.  0 = not gated. */
+static u32 gmem_ioctl_allow_bit(unsigned int cmd)
+{
+	switch (cmd) {
+	case GMEM_PROVIDER_SET_PRESENT:	return GMEM_ALLOW_SET_PRESENT;
+	case GMEM_PROVIDER_SET_READONLY: return GMEM_ALLOW_SET_READONLY;
+	case GMEM_PROVIDER_GET_DMABUF:	return GMEM_ALLOW_GET_DMABUF;
+	case GMEM_PROVIDER_GET_STATS:	return GMEM_ALLOW_GET_STATS;
+	default:			return 0;
+	}
+}
+
+static long gmem_get_stats(struct gmem_info *info, void __user *uarg)
+{
+	struct gmem_provider_stats st = {};
+
+	mutex_lock(&info->lock);
+	st.region_offset = (u64)info->root_index << PAGE_SHIFT;
+	st.region_len = (u64)info->npages << PAGE_SHIFT;
+	st.owned_pages = info->owned ?
+		bitmap_weight(info->owned, info->npages) : info->npages;
+	st.absent_pages = info->absent ?
+		bitmap_weight(info->absent, info->npages) : 0;
+	st.readonly_pages = info->readonly ?
+		bitmap_weight(info->readonly, info->npages) : 0;
+	st.allow = info->allow;
+	mutex_unlock(&info->lock);
+
+	return copy_to_user(uarg, &st, sizeof(st)) ? -EFAULT : 0;
+}
+
 static long gmem_fd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct gmem_info *info = to_gmem_info(file);
 	struct gmem_provider_present p;
 	unsigned long start_index, end_index;
+	u32 need = gmem_ioctl_allow_bit(cmd);
+
+	/*
+	 * The allowlist is fixed by the creator at NEW_CHILD and checked here
+	 * before dispatch, so it also governs ioctls added later.  A SETUP
+	 * provider has no root and allows everything, as before.
+	 */
+	if (need && !(info->allow & need))
+		return -EPERM;
 
 	if (cmd == GMEM_PROVIDER_GET_DMABUF)
 		return gmem_provider_get_dmabuf(file);
+	if (cmd == GMEM_PROVIDER_GET_STATS)
+		return gmem_get_stats(info, (void __user *)arg);
+
+	if (cmd == GMEM_PROVIDER_SET_READONLY) {
+		struct gmem_provider_readonly r;
+
+		if (copy_from_user(&r, (void __user *)arg, sizeof(r)))
+			return -EFAULT;
+		if (!r.len || !PAGE_ALIGNED(r.offset) || !PAGE_ALIGNED(r.len) ||
+		    r.pad)
+			return -EINVAL;
+		start_index = r.offset >> PAGE_SHIFT;
+		end_index = start_index + (r.len >> PAGE_SHIFT);
+		if (end_index > info->npages || end_index < start_index)
+			return -EINVAL;
+
+		/*
+		 * Flip the bits, then invalidate the range so importers drop
+		 * their mappings and the next access re-reads get_phys() with
+		 * the new permission.  Making a range read-only must
+		 * tear down writable mappings; making it writable again is
+		 * also invalidated so a stale read-only mapping does not keep
+		 * exiting.
+		 */
+		mutex_lock(&info->lock);
+		if (r.readonly)
+			bitmap_set(info->readonly, start_index,
+				   end_index - start_index);
+		else
+			bitmap_clear(info->readonly, start_index,
+				     end_index - start_index);
+		mutex_unlock(&info->lock);
+		gmem_revoke_range(info, start_index, end_index);
+		return 0;
+	}
 
 	if (cmd != GMEM_PROVIDER_SET_PRESENT)
 		return -ENOTTY;
@@ -589,152 +537,495 @@ static long gmem_fd_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 	if (end_index > info->npages || end_index < start_index)
 		return -EINVAL;
 
-	if (p.present) {
-		/* Restore: next guest fault calls get_pfn() and re-maps. */
-		mutex_lock(&info->lock);
+	mutex_lock(&info->lock);
+	if (p.present)
 		bitmap_clear(info->absent, start_index, end_index - start_index);
-		mutex_unlock(&info->lock);
-	} else {
-		unsigned long clamped_start;
-
-		/* Revoke: mark absent, then zap the guest NPT/EPT for the range. */
-		mutex_lock(&info->lock);
+	else
 		bitmap_set(info->absent, start_index, end_index - start_index);
+	/*
+	 * Both directions invalidate: on revoke so the guest and devices stop
+	 * using the pages, on restore so importers that were shown a hole or
+	 * the scratch frame re-read and map the real frames again.
+	 */
+	mutex_unlock(&info->lock);
+	gmem_revoke_range(info, start_index, end_index);
+	if (!p.present)
+		gmem_unmap_host(info, start_index, end_index);
+	return 0;
+}
 
-		/*
-		 * Translate provider offset -> guest gfn.  Skip any part of
-		 * the range that falls outside the currently bound slot; a
-		 * naive subtraction would underflow.
-		 */
-		clamped_start = max_t(unsigned long, start_index, info->pgoff);
-		if (info->kvm && end_index > clamped_start)
-			kvm_gmem_invalidate_range(info->kvm,
-				info->base_gfn + clamped_start - info->pgoff,
-				info->base_gfn + end_index - info->pgoff);
-		mutex_unlock(&info->lock);
-
-		/*
-		 * Fan out to iommufd (and any other dma-buf importer): mark the
-		 * exported dma-buf(s) revoked and invalidate any active mappings.
-		 * The provider stays ignorant of scratch-page policy; that lives
-		 * in the importer.
-		 */
-		mutex_lock(&info->dmabufs_lock);
-		gmem_dma_buf_revoke_all(info);
-		mutex_unlock(&info->dmabufs_lock);
-	}
+static int gmem_fops_release(struct inode *inode, struct file *file)
+{
+	gmem_release(file);
 	return 0;
 }
 
-static long gmem_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+/* A child file owns its controls, host windows and dma-buf exports. */
+static const struct file_operations gmem_provider_fops = {
+	.owner		= THIS_MODULE,
+	.release	= gmem_fops_release,
+	.mmap		= gmem_mmap,
+	.unlocked_ioctl	= gmem_fd_ioctl,
+	.compat_ioctl	= gmem_fd_ioctl,
+};
+
+/*
+ * Allocate a child over [base_pfn, +npages) and return its fd. Shared by
+ * SETUP (standalone region) and NEW_CHILD (a root sub-range). The fd owns the
+ * module pin on success.
+ */
+static int gmem_new_provider_fd(unsigned long base_pfn,
+				unsigned long npages, struct page *cma_pages,
+				u32 flags, unsigned long root_index,
+				unsigned long *owned, u32 allow,
+				struct gmem_info **out)
 {
-	struct gmem_provider_setup setup;
+	struct file *file;
 	struct gmem_info *info;
-	struct file *kvm_file;
-	struct page *pages = NULL;
-	struct kvm *kvm;
-	unsigned long npages;
 	int fd, ret;
 
-	if (cmd != GMEM_PROVIDER_SETUP)
-		return -ENOTTY;
+	info = kzalloc_obj(*info);
+	if (!info)
+		return -ENOMEM;
+	info->base_pfn = base_pfn;
+	info->npages = npages;
+	info->cma_pages = cma_pages;
+	info->root_index = root_index;
+	info->owned = owned;
+	info->allow = allow;
+	info->absent = kvzalloc_objs(unsigned long, BITS_TO_LONGS(npages));
+	info->readonly = kvzalloc_objs(unsigned long, BITS_TO_LONGS(npages));
+	if (!info->absent || !info->readonly) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+	INIT_LIST_HEAD(&info->dmabufs);
+	INIT_LIST_HEAD(&info->root_link);
+	mutex_init(&info->dmabufs_lock);
+	mutex_init(&info->lock);
 
-	if (copy_from_user(&setup, (void __user *)arg, sizeof(setup)))
-		return -EFAULT;
-	if (setup.flags & ~GMEM_PROVIDER_FLAG_MMAP_CAPABLE)
-		return -EINVAL;
+	/* Pin THIS_MODULE while the provider fd is alive (release drops it). */
+	if (!try_module_get(THIS_MODULE)) {
+		ret = -ENODEV;
+		goto err_free;
+	}
+	info->mmap_capable = !!(flags & GMEM_PROVIDER_FLAG_MMAP_CAPABLE);
 
-	kvm_file = fget(setup.kvm_fd);
-	if (!kvm_file)
-		return -EBADF;
-	if (!file_is_kvm(kvm_file)) {
-		fput(kvm_file);
-		return -EINVAL;
+	/*
+	 * A private inode, not the shared anon one: host windows are torn
+	 * down by file range on revoke, which must not touch other files.
+	 */
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		ret = fd;
+		module_put(THIS_MODULE);
+		goto err_free;
 	}
-	kvm = kvm_file->private_data;
-	if (!kvm) {
-		fput(kvm_file);
-		return -EINVAL;
+	file = anon_inode_create_getfile("[gmem-provider]", &gmem_provider_fops,
+					 info, O_RDWR, NULL);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		ret = PTR_ERR(file);
+		module_put(THIS_MODULE);
+		goto err_free;
 	}
-	kvm_get_kvm(kvm);
-	fput(kvm_file);
+	info->mapping = file->f_mapping;
+	if (owned)
+		list_add(&info->root_link, &gmem_root.children);
+	fd_install(fd, file);
+	if (out)
+		*out = info;
+	return fd;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		ret = -ENOMEM;
-		goto err_put_kvm;
-	}
+err_free:
+	kvfree(info->absent);
+	kvfree(info->readonly);
+	kfree(info);
+	return ret;
+}
+
+static long gmem_ctl_setup(void __user *uarg)
+{
+	struct gmem_provider_setup setup;
+	struct page *pages = NULL;
+	unsigned long base_pfn, npages;
+	int fd;
+
+	if (copy_from_user(&setup, uarg, sizeof(setup)))
+		return -EFAULT;
+	if (setup.flags & ~GMEM_PROVIDER_FLAG_MMAP_CAPABLE)
+		return -EINVAL;
+	/* kvm_fd is legacy and ignored: binding happens in KVM_CREATE_GUEST_MEMFD. */
 
 	if (addr && len) {
 		/* External page-less range from module params. */
-		info->base_pfn = addr >> PAGE_SHIFT;
-		info->npages = len >> PAGE_SHIFT;
+		base_pfn = addr >> PAGE_SHIFT;
+		npages = len >> PAGE_SHIFT;
 	} else {
 		/* CMA fallback: allocate a contiguous, page-backed region. */
-		if (!setup.size || !PAGE_ALIGNED(setup.size)) {
-			ret = -EINVAL;
-			goto err_free_info;
-		}
+		if (!setup.size || !PAGE_ALIGNED(setup.size))
+			return -EINVAL;
 		npages = setup.size >> PAGE_SHIFT;
 		pages = alloc_contig_pages(npages, GFP_KERNEL, numa_node_id(), NULL);
-		if (!pages) {
-			ret = -ENOMEM;
-			goto err_free_info;
-		}
+		if (!pages)
+			return -ENOMEM;
 		/* Provider path skips KVM's folio-clear; zero to avoid data leak. */
 		memset(page_to_virt(pages), 0, (size_t)npages << PAGE_SHIFT);
-		info->base_pfn = page_to_pfn(pages);
-		info->npages = npages;
-		info->cma_pages = pages;
+		base_pfn = page_to_pfn(pages);
 	}
 
-	info->absent = kvzalloc(BITS_TO_LONGS(info->npages) * sizeof(unsigned long),
-				GFP_KERNEL);
-	if (!info->absent) {
-		ret = -ENOMEM;
-		goto err_free_pages;
+	fd = gmem_new_provider_fd(base_pfn, npages, pages, setup.flags, 0,
+				  NULL, GMEM_ALLOW_ALL, NULL);
+	if (fd < 0 && pages)
+		free_contig_range(page_to_pfn(pages), npages);
+	return fd;
+}
+
+/*
+ * Lazily create the root region on first NEW_CHILD.  Uses the module params
+ * if given (page-less), else a CMA region of @size bytes.  Idempotent once
+ * created; a later different @size is ignored.
+ */
+static int gmem_root_ensure(u64 size)
+{
+	unsigned long npages;
+	struct page *pages = NULL;
+
+	lockdep_assert_held(&gmem_root.lock);
+	if (gmem_root.npages)
+		return 0;
+
+	if (addr && len) {
+		gmem_root.base_pfn = addr >> PAGE_SHIFT;
+		npages = len >> PAGE_SHIFT;
+	} else {
+		if (!size || !PAGE_ALIGNED(size))
+			return -EINVAL;
+		npages = size >> PAGE_SHIFT;
+		pages = alloc_contig_pages(npages, GFP_KERNEL, numa_node_id(), NULL);
+		if (!pages)
+			return -ENOMEM;
+		memset(page_to_virt(pages), 0, (size_t)npages << PAGE_SHIFT);
+		gmem_root.base_pfn = page_to_pfn(pages);
 	}
+	gmem_root.owned = kvzalloc_objs(unsigned long, BITS_TO_LONGS(npages));
+	gmem_root.donated = kvzalloc_objs(unsigned long, BITS_TO_LONGS(npages));
+	if (!gmem_root.owned || !gmem_root.donated) {
+		kvfree(gmem_root.owned);
+		kvfree(gmem_root.donated);
+		gmem_root.owned = NULL;
+		gmem_root.donated = NULL;
+		if (pages)
+			free_contig_range(page_to_pfn(pages), npages);
+		return -ENOMEM;
+	}
+	gmem_root.cma_pages = pages;
+	gmem_root.npages = npages;
+	return 0;
+}
 
-	INIT_LIST_HEAD(&info->dmabufs);
-	mutex_init(&info->dmabufs_lock);
-	mutex_init(&info->lock);
+static void gmem_root_teardown(void)
+{
+	if (!gmem_root.npages)
+		return;
+	WARN_ON(!list_empty(&gmem_root.children));
+	if (gmem_root.cma_pages)
+		free_contig_range(gmem_root.base_pfn, gmem_root.npages);
+	kvfree(gmem_root.owned);
+	kvfree(gmem_root.donated);
+	memset(&gmem_root, 0, sizeof(gmem_root));
+	mutex_init(&gmem_root.lock);
+	INIT_LIST_HEAD(&gmem_root.children);
+}
+
+/* Validate a page-aligned [offset, +len) against the root; return page bounds. */
+static int gmem_root_range(u64 offset, u64 length,
+			   unsigned long *first, unsigned long *last)
+{
+	if (!length || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(length))
+		return -EINVAL;
+	*first = offset >> PAGE_SHIFT;
+	*last = *first + (length >> PAGE_SHIFT);		/* exclusive */
+	if (*last <= *first || *last > gmem_root.npages)
+		return -EINVAL;
+	return 0;
+}
+
+/* Resolve a child fd created by NEW_CHILD; returns a referenced file. */
+static struct file *gmem_get_child(int fd, struct gmem_info **infop)
+{
+	struct file *f = fget(fd);
+	struct gmem_info *info;
+
+	if (!f)
+		return ERR_PTR(-EBADF);
+	if (f->f_op != &gmem_provider_fops) {
+		fput(f);
+		return ERR_PTR(-EINVAL);
+	}
+	info = to_gmem_info(f);
+	if (!info->owned) {
+		fput(f);
+		return ERR_PTR(-EINVAL);
+	}
+	*infop = info;
+	return f;
+}
 
+static long gmem_ctl_new_child(void __user *uarg)
+{
+	struct gmem_provider_new_child nc;
+	struct gmem_info *info;
+	unsigned long first, last;
+	unsigned long *owned;
+	int fd, ret;
+
+	if (copy_from_user(&nc, uarg, sizeof(nc)))
+		return -EFAULT;
+	if ((nc.flags & ~GMEM_PROVIDER_FLAG_MMAP_CAPABLE) || nc.pad ||
+	    (nc.allow & ~GMEM_ALLOW_ALL))
+		return -EINVAL;
+
+	/* nc.kvm_fd is legacy and ignored: binding happens in KVM_CREATE_GUEST_MEMFD. */
+
+	mutex_lock(&gmem_root.lock);
+	ret = gmem_root_ensure(nc.offset + nc.len);
+	if (ret)
+		goto out_unlock;
+	ret = gmem_root_range(nc.offset, nc.len, &first, &last);
+	if (ret)
+		goto out_unlock;
 	/*
-	 * Pin THIS_MODULE while the provider fd is alive.  The fd is created
-	 * with kvm_gmem_fops (owned by kvm.ko), which does not pin us, so
-	 * rmmod of gmem_provider is otherwise free to run behind our ops.
+	 * A carve is the range this child may ever hold; it is the VM's whole
+	 * view of memory and becomes its memslot.  Carves may overlap: that is
+	 * how a range can later MOVE from one VM to another.  Ownership is
+	 * per page and exclusive.  The new child is granted every page of its
+	 * carve that no other child owns and the root has not parked; the
+	 * rest it can only receive by MOVE or RECLAIM.  A carve with nothing
+	 * to grant is refused as a likely mistake.
 	 */
-	if (!try_module_get(THIS_MODULE)) {
-		ret = -ENODEV;
-		goto err_free_pages;
+	if (find_next_zero_bit(gmem_root.owned, last, first) >= last) {
+		ret = -EBUSY;
+		goto out_unlock;
 	}
 
-	info->backing.ops = &gmem_ops;
-	info->kvm = kvm;
-	info->mmap_capable = !!(setup.flags & GMEM_PROVIDER_FLAG_MMAP_CAPABLE);
+	/*
+	 * Allocate the ownership bitmap before the fd exists, so a failure
+	 * here has nothing to unwind.  It is handed to the new info below.
+	 */
+	owned = kvzalloc_objs(unsigned long, BITS_TO_LONGS(last - first));
+	if (!owned) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	/* Establish the grant before publishing the fd. */
+	{
+		unsigned long i;
 
-	fd = anon_inode_getfd("[gmem-provider]", &kvm_gmem_fops,
-			      &info->backing, O_RDWR | O_CLOEXEC);
+		for (i = first; i < last; i++) {
+			if (test_bit(i, gmem_root.owned) ||
+			    test_bit(i, gmem_root.donated))
+				continue;
+			__set_bit(i - first, owned);
+			__set_bit(i, gmem_root.owned);
+		}
+	}
+	fd = gmem_new_provider_fd(gmem_root.base_pfn + first,
+				  last - first, NULL, nc.flags, first,
+				  owned, nc.allow, &info);
 	if (fd < 0) {
+		unsigned long i;
+
+		for_each_set_bit(i, owned, last - first)
+			__clear_bit(first + i, gmem_root.owned);
+		kvfree(owned);
 		ret = fd;
-		goto err_module_put;
+		goto out_unlock;
 	}
+	mutex_unlock(&gmem_root.lock);
 	return fd;
 
-err_module_put:
-	module_put(THIS_MODULE);
+out_unlock:
+	mutex_unlock(&gmem_root.lock);
+	return ret;
+}
 
-err_free_pages:
-	if (pages)
-		free_contig_range(page_to_pfn(pages), npages);
-err_free_info:
-	kvfree(info->absent);
-	kfree(info);
-err_put_kvm:
-	kvm_put_kvm(kvm);
+/*
+ * Take [first, last) away from @info: clear ownership, then revoke from both
+ * of its importers.  Ownership is cleared before the revoke so a racing fault
+ * that slips in re-reads "not owned" and gets the scratch frame or fails.
+ * Caller holds gmem_root.lock; we take info->lock inside it.
+ */
+static void gmem_child_lose(struct gmem_info *info,
+			    unsigned long first, unsigned long last)
+{
+	unsigned long s = first - info->root_index, e = last - info->root_index;
+
+	mutex_lock(&info->lock);
+	bitmap_clear(info->owned, s, e - s);
+	mutex_unlock(&info->lock);
+	gmem_revoke_range(info, s, e);
+	gmem_unmap_host(info, s, e);
+	bitmap_clear(gmem_root.owned, first, last - first);
+}
+
+/* Give [first, last) to @info and invalidate so its importers pick it up. */
+static void gmem_child_gain(struct gmem_info *info,
+			    unsigned long first, unsigned long last)
+{
+	unsigned long s = first - info->root_index, e = last - info->root_index;
+
+	mutex_lock(&info->lock);
+	bitmap_set(info->owned, s, e - s);
+	mutex_unlock(&info->lock);
+	gmem_revoke_range(info, s, e);
+	bitmap_set(gmem_root.owned, first, last - first);
+}
+
+/* Does child @info's carved range contain [first, last)? */
+static bool gmem_child_covers(struct gmem_info *info,
+			      unsigned long first, unsigned long last)
+{
+	return first >= info->root_index &&
+	       last <= info->root_index + info->npages;
+}
+
+/* Does child @info currently own every page of [first, last)? */
+static bool gmem_child_owns(struct gmem_info *info,
+			    unsigned long first, unsigned long last)
+{
+	unsigned long s = first - info->root_index, e = last - info->root_index;
+
+	return gmem_child_covers(info, first, last) &&
+	       find_next_zero_bit(info->owned, e, s) >= e;
+}
+
+static long gmem_ctl_move(void __user *uarg)
+{
+	struct gmem_provider_move mv;
+	struct gmem_info *src, *dst;
+	struct file *sf, *df;
+	unsigned long first, last;
+	long ret;
+
+	if (copy_from_user(&mv, uarg, sizeof(mv)))
+		return -EFAULT;
+	sf = gmem_get_child(mv.src_fd, &src);
+	if (IS_ERR(sf))
+		return PTR_ERR(sf);
+	df = gmem_get_child(mv.dst_fd, &dst);
+	if (IS_ERR(df)) {
+		fput(sf);
+		return PTR_ERR(df);
+	}
+
+	mutex_lock(&gmem_root.lock);
+	ret = gmem_root_range(mv.offset, mv.len, &first, &last);
+	if (ret)
+		goto out;
+	if (src == dst || !gmem_child_owns(src, first, last) ||
+	    !gmem_child_covers(dst, first, last)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	/*
+	 * Revoke on the source first, grant on the destination second.  No two
+	 * importers hold the range at once.  Both children's info->lock are
+	 * taken in turn under gmem_root.lock, never nested with each other.
+	 */
+	gmem_child_lose(src, first, last);
+	gmem_child_gain(dst, first, last);
+	ret = 0;
+out:
+	mutex_unlock(&gmem_root.lock);
+	fput(df);
+	fput(sf);
+	return ret;
+}
+
+static long gmem_ctl_donate(void __user *uarg, bool reclaim)
+{
+	struct gmem_provider_donate d;
+	struct gmem_info *info;
+	struct file *f;
+	unsigned long first, last;
+	long ret;
+
+	if (copy_from_user(&d, uarg, sizeof(d)))
+		return -EFAULT;
+	if (d.pad)
+		return -EINVAL;
+	f = gmem_get_child(d.fd, &info);
+	if (IS_ERR(f))
+		return PTR_ERR(f);
+
+	mutex_lock(&gmem_root.lock);
+	ret = gmem_root_range(d.offset, d.len, &first, &last);
+	if (ret)
+		goto out;
+	if (!reclaim) {
+		/* DONATE: the child must own it; park it at the root. */
+		if (!gmem_child_owns(info, first, last)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		gmem_child_lose(info, first, last);
+		bitmap_set(gmem_root.donated, first, last - first);
+	} else {
+		/* RECLAIM: must be donated and inside this child's range. */
+		if (!gmem_child_covers(info, first, last) ||
+		    find_next_zero_bit(gmem_root.donated, last, first) < last) {
+			ret = -EINVAL;
+			goto out;
+		}
+		bitmap_clear(gmem_root.donated, first, last - first);
+		gmem_child_gain(info, first, last);
+	}
+	ret = 0;
+out:
+	mutex_unlock(&gmem_root.lock);
+	fput(f);
 	return ret;
 }
 
+static long gmem_ctl_set_scratch(void __user *uarg)
+{
+	struct gmem_provider_scratch sc;
+	struct gmem_info *info;
+
+	if (copy_from_user(&sc, uarg, sizeof(sc)))
+		return -EFAULT;
+	if (sc.pad || sc.enable > 1)
+		return -EINVAL;
+
+	/*
+	 * Flipping the mode changes what every revoked page reports, so every
+	 * child is re-invalidated in full: cheap for a PoC, and it guarantees
+	 * no importer keeps a stale hole or a stale scratch mapping.
+	 */
+	mutex_lock(&gmem_root.lock);
+	WRITE_ONCE(gmem_root.scratch_enabled, !!sc.enable);
+	list_for_each_entry(info, &gmem_root.children, root_link)
+		gmem_revoke_range(info, 0, info->npages);
+	mutex_unlock(&gmem_root.lock);
+	return 0;
+}
+
+static long gmem_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case GMEM_PROVIDER_SETUP:	return gmem_ctl_setup(uarg);
+	case GMEM_PROVIDER_NEW_CHILD:	return gmem_ctl_new_child(uarg);
+	case GMEM_PROVIDER_MOVE:	return gmem_ctl_move(uarg);
+	case GMEM_PROVIDER_DONATE:	return gmem_ctl_donate(uarg, false);
+	case GMEM_PROVIDER_RECLAIM:	return gmem_ctl_donate(uarg, true);
+	case GMEM_PROVIDER_SET_SCRATCH:	return gmem_ctl_set_scratch(uarg);
+	default:			return -ENOTTY;
+	}
+}
+
 static const struct file_operations gmem_ctl_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= gmem_ctl_ioctl,
@@ -749,20 +1040,34 @@ static struct miscdevice gmem_dev = {
 
 static int __init gmem_provider_init(void)
 {
+	int ret;
+
 	if ((addr || len) &&
 	    (!addr || !len || !PAGE_ALIGNED(addr) || !PAGE_ALIGNED(len))) {
 		pr_err("gmem_provider: addr= and len= must both be set and page aligned\n");
 		return -EINVAL;
 	}
-	return misc_register(&gmem_dev);
+	gmem_scratch_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!gmem_scratch_page)
+		return -ENOMEM;
+	mutex_init(&gmem_root.lock);
+	INIT_LIST_HEAD(&gmem_root.children);
+
+	ret = misc_register(&gmem_dev);
+	if (ret)
+		__free_page(gmem_scratch_page);
+	return ret;
 }
 module_init(gmem_provider_init);
 
 static void __exit gmem_provider_exit(void)
 {
 	misc_deregister(&gmem_dev);
+	gmem_root_teardown();
+	__free_page(gmem_scratch_page);
 }
 module_exit(gmem_provider_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
 MODULE_DESCRIPTION("Sample guest_memfd provider (external page-less range or CMA fallback)");
diff --git a/samples/kvm/gmem_provider.h b/samples/kvm/gmem_provider.h
index 45f1b8257f60..1c8f5cacd2be 100644
--- a/samples/kvm/gmem_provider.h
+++ b/samples/kvm/gmem_provider.h
@@ -6,19 +6,18 @@
 #include <linux/types.h>
 
 /*
- * ioctl on /dev/gmem_provider: create a guest_memfd provider fd and return it
- * for use with KVM_SET_USER_MEMORY_REGION2.
+ * ioctl on /dev/gmem_provider: create a memory-owner fd and return it. The
+ * holder may mmap it and request a dma-buf for KVM or iommufd.
  *
  * If the module was loaded with addr=/len=, the fd is backed by that fixed
  * page-less physical range and @size is ignored.  Otherwise the fd is backed
  * by a @size-byte physically contiguous region from alloc_contig_pages().
  */
 /* Flags for struct gmem_provider_setup.flags */
-#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)	/* fd is mmap()-able; slot becomes gmem-only.
-								   Refused for coco VMs (SEV-SNP/TDX). */
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)	/* fd and its dma-bufs are mmap()-able */
 
 struct gmem_provider_setup {
-	__s32 kvm_fd;	/* an open KVM VM fd */
+	__s32 kvm_fd;	/* ignored */
 	__u32 flags;	/* GMEM_PROVIDER_FLAG_* */
 	__u64 size;	/* CMA fallback size in bytes, page aligned */
 };
@@ -27,10 +26,9 @@ struct gmem_provider_setup {
 #define GMEM_PROVIDER_SETUP		_IOW(GMEM_PROVIDER_IOCTL_BASE, 1, struct gmem_provider_setup)
 
 /*
- * ioctl on a provider fd (returned by SETUP): flip a byte range of the backing
- * between present and absent.  Revoking (present=0) marks the range absent and
- * zaps the guest's NPT/EPT so the next access re-faults; get_pfn() then refuses
- * the range until it is restored (present=1).  Models overcommit page reclaim.
+ * ioctl on an owner fd: flip a byte range between present and absent.
+ * Revoking a range invalidates every exported dma-buf, so importers discard
+ * their old mappings and observe a hole until the range is restored.
  */
 struct gmem_provider_present {
 	__u64 offset;	/* byte offset into the provider region, page aligned */
@@ -42,12 +40,134 @@ struct gmem_provider_present {
 #define GMEM_PROVIDER_SET_PRESENT	_IOW(GMEM_PROVIDER_IOCTL_BASE, 2, struct gmem_provider_present)
 
 /*
- * ioctl on a provider fd (returned by SETUP): export the backing region as a
- * dynamic dma-buf and return an fd for it, suitable for
+ * ioctl on a provider fd: make a byte range read-only for the guest, or
+ * writable again.  KVM maps a read-only page without write permission and a
+ * guest write to it exits to userspace with KVM_EXIT_MEMORY_FAULT.  Existing
+ * mappings of the range are dropped so the change takes effect on the next
+ * access.
+ */
+struct gmem_provider_readonly {
+	__u64 offset;	/* byte offset into the provider region, page aligned */
+	__u64 len;	/* byte length, page aligned */
+	__u32 readonly;	/* 1 = guest may not write, 0 = guest may write */
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_SET_READONLY \
+	_IOW(GMEM_PROVIDER_IOCTL_BASE, 4, struct gmem_provider_readonly)
+
+/*
+ * ioctl on an owner fd: export its memory as a dynamic dma-buf and return an
+ * fd suitable for
  * IOMMU_IOAS_MAP_FILE.  Revoking the region (SET_PRESENT present=0) fans out
- * to the exported dma-buf via dma_buf_invalidate_mappings(), causing iommufd
+ * to the exported dma-buf via dma_buf_invalidate_mappings_range(), causing importers
  * to tear down the IOMMU mapping so DMA to the reclaimed range faults.
  */
 #define GMEM_PROVIDER_GET_DMABUF	_IO(GMEM_PROVIDER_IOCTL_BASE, 3)
 
+/*
+ * ---- Toy descriptor tree (a memory owner as a provider) -------------------
+ *
+ * The control device owns one backing region (the "root").  NEW_CHILD carves a
+ * sub-range of it into a new provider fd bound to one VM.  A child's pages can
+ * be MOVEd to another child, DONATEd to the root (absent from every consumer)
+ * and RECLAIMed.  Every change revokes the range from KVM and from the
+ * child's exported dma-bufs.
+ *
+ * Every child fd carries an ioctl allowlist, fixed at NEW_CHILD by the
+ * creator.  Ioctls not in the list fail with -EPERM.
+ */
+
+/* Allowlist bits for struct gmem_provider_new_child.allow */
+#define GMEM_ALLOW_SET_PRESENT		(1u << 0)
+#define GMEM_ALLOW_SET_READONLY		(1u << 1)
+#define GMEM_ALLOW_GET_DMABUF		(1u << 2)
+#define GMEM_ALLOW_GET_STATS		(1u << 3)
+#define GMEM_ALLOW_ALL			(GMEM_ALLOW_SET_PRESENT | \
+					 GMEM_ALLOW_SET_READONLY | \
+					 GMEM_ALLOW_GET_DMABUF | \
+					 GMEM_ALLOW_GET_STATS)
+
+/*
+ * ioctl on /dev/gmem_provider: carve @len bytes at @offset of the root into a
+ * new child fd. The range must be available. Without addr=/len=, the first
+ * child fixes the CMA root size; create and close a sizing child first if
+ * later children extend beyond it. @allow becomes the child's ioctl allowlist.
+ */
+struct gmem_provider_new_child {
+	__s32 kvm_fd;	/* ignored */
+	__u32 flags;	/* GMEM_PROVIDER_FLAG_* */
+	__u64 offset;	/* byte offset into the root region, page aligned */
+	__u64 len;	/* byte length, page aligned */
+	__u32 allow;	/* GMEM_ALLOW_* */
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_NEW_CHILD	_IOW(GMEM_PROVIDER_IOCTL_BASE, 5, struct gmem_provider_new_child)
+
+/*
+ * ioctl on /dev/gmem_provider: move [@offset, @offset+@len) of the root region
+ * from child @src_fd to child @dst_fd.  The range must currently be owned by
+ * @src_fd and must fall inside @dst_fd's carved range. The source is
+ * invalidated first, then the destination is granted, so no two children own
+ * the range at once.
+ */
+struct gmem_provider_move {
+	__s32 src_fd;
+	__s32 dst_fd;
+	__u64 offset;	/* byte offset into the root region, page aligned */
+	__u64 len;	/* byte length, page aligned */
+};
+
+#define GMEM_PROVIDER_MOVE	_IOW(GMEM_PROVIDER_IOCTL_BASE, 6, struct gmem_provider_move)
+
+/*
+ * ioctl on /dev/gmem_provider: DONATE revokes [@offset, +@len) from the child
+ * that owns it and parks it at the root; RECLAIM returns a donated range to
+ * @fd, which must be the child whose carved range contains it.  The toy does
+ * no scrub and no hotplug; it models only the ownership state.
+ */
+struct gmem_provider_donate {
+	__s32 fd;	/* DONATE: owning child (checked); RECLAIM: recipient */
+	__u32 pad;
+	__u64 offset;	/* byte offset into the root region, page aligned */
+	__u64 len;	/* byte length, page aligned */
+};
+
+#define GMEM_PROVIDER_DONATE	_IOW(GMEM_PROVIDER_IOCTL_BASE, 7, struct gmem_provider_donate)
+#define GMEM_PROVIDER_RECLAIM	_IOW(GMEM_PROVIDER_IOCTL_BASE, 8, struct gmem_provider_donate)
+
+/*
+ * ioctl on /dev/gmem_provider: select what a revoked page reports to its
+ * consumers.  With @enable=0 (default) a revoked page is absent: get_phys()
+ * reports it as not backed, so a guest access exits and a device DMA faults.  With
+ * @enable=1 a revoked page reports the module's scratch frame, read-only, on
+ * both paths, so a device that cannot tolerate a fault lands on a harmless
+ * page.  Scratch mode applies to children created by NEW_CHILD only; a
+ * SETUP provider always reports a revoked page as absent.  Changing the mode
+ * re-invalidates every child so consumers re-read.
+ */
+struct gmem_provider_scratch {
+	__u32 enable;
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_SET_SCRATCH \
+	_IOW(GMEM_PROVIDER_IOCTL_BASE, 9, struct gmem_provider_scratch)
+
+/*
+ * ioctl on a child fd: read back the child's ownership state, for tests.
+ */
+struct gmem_provider_stats {
+	__u64 region_offset;	/* child's carved range within the root */
+	__u64 region_len;
+	__u64 owned_pages;	/* pages currently granted to this child */
+	__u64 absent_pages;	/* pages revoked (moved out, donated, or SET_PRESENT 0) */
+	__u64 readonly_pages;
+	__u32 allow;
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_GET_STATS	_IOR(GMEM_PROVIDER_IOCTL_BASE, 10, struct gmem_provider_stats)
+
 #endif /* _SAMPLES_KVM_GMEM_PROVIDER_H */
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 12004a487c32..6accbc56ae69 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -78,11 +78,12 @@ TEST_GEN_PROGS_x86 += x86/evmcs_smm_controls_test
 TEST_GEN_PROGS_x86 += x86/exit_on_emulation_failure_test
 TEST_GEN_PROGS_x86 += x86/fastops_test
 TEST_GEN_PROGS_x86 += x86/fix_hypercall_test
-TEST_GEN_PROGS_x86 += x86/gmem_provider_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_hugepage_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_revoke_test
+TEST_GEN_PROGS_x86 += x86/gmem_provider_readonly_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_iommufd_test
 TEST_GEN_PROGS_x86 += x86/gmem_provider_vfio_test
+TEST_GEN_PROGS_x86 += x86/gmem_poc_test
 TEST_GEN_PROGS_x86 += x86/hwcr_msr_test
 TEST_GEN_PROGS_x86 += x86/hyperv_clock
 TEST_GEN_PROGS_x86 += x86/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/gmem_provider_nvme_dma_test.c b/tools/testing/selftests/kvm/gmem_provider_nvme_dma_test.c
index 665b19028e13..b5ef6b9b1385 100644
--- a/tools/testing/selftests/kvm/gmem_provider_nvme_dma_test.c
+++ b/tools/testing/selftests/kvm/gmem_provider_nvme_dma_test.c
@@ -35,8 +35,8 @@ struct gmem_provider_setup {
 	__u64 size;
 };
 #define GMEM_PROVIDER_SETUP		_IOW('G', 1, struct gmem_provider_setup)
-#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
 #define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
 
 struct gmem_provider_present {
 	__u64 offset;
@@ -94,7 +94,7 @@ int main(void)
 	struct vfio_device_attach_iommufd_pt att = {};
 	struct vfio_region_info reg = {};
 	const char *cdev_path;
-	int gmem_ctl, gmem_fd, dmabuf_fd, iommufd_fd, vfio_fd;
+	int gmem_ctl, gmem_fd, dmabuf_fd, prov_fd, vm_fd = -1, iommufd_fd, vfio_fd;
 	void *provider_hva, *sq_buf, *cq_buf, *bar;
 	uint16_t pci_cmd;
 	uint16_t expected_vid;
@@ -120,22 +120,34 @@ int main(void)
 		vm = ioctl(kvm, KVM_CREATE_VM, 0);
 		TEST_ASSERT(vm >= 0, "KVM_CREATE_VM errno=%d", errno);
 		setup.kvm_fd = vm;
+		vm_fd = vm;
 		close(kvm);
 	}
 	setup.size = PROVIDER_SIZE;
-	gmem_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
-	TEST_ASSERT(gmem_fd >= 0, "SETUP errno=%d", errno);
+	prov_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(prov_fd >= 0, "SETUP errno=%d", errno);
+
+	/* Export once; KVM and iommufd import the same dma-buf. */
+	dmabuf_fd = ioctl(prov_fd, GMEM_PROVIDER_GET_DMABUF);
+	TEST_ASSERT(dmabuf_fd >= 0, "GET_DMABUF errno=%d", errno);
+	{
+		struct kvm_create_guest_memfd cgm = {
+			.size = PROVIDER_SIZE,
+			.flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_DMABUF,
+			.dmabuf_fd = dmabuf_fd,
+		};
+		gmem_fd = ioctl(vm_fd, KVM_CREATE_GUEST_MEMFD, &cgm);
+		TEST_ASSERT(gmem_fd >= 0, "KVM_CREATE_GUEST_MEMFD(dmabuf) errno=%d", errno);
+	}
 
 	provider_hva = mmap(NULL, PROVIDER_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
 			    gmem_fd, 0);
 	TEST_ASSERT(provider_hva != MAP_FAILED, "provider mmap errno=%d", errno);
 	memset(provider_hva, 0xcc, 0x1000);	/* poison first page */
 
-	/* IOAS + provider dma-buf. */
+	/* IOAS + the same dma-buf KVM imported. */
 	alloc.size = sizeof(alloc);
 	TEST_ASSERT(!ioctl(iommufd_fd, IOMMU_IOAS_ALLOC, &alloc), "IOAS_ALLOC");
-	dmabuf_fd = ioctl(gmem_fd, GMEM_PROVIDER_GET_DMABUF);
-	TEST_ASSERT(dmabuf_fd >= 0, "GET_DMABUF");
 	mapf.size = sizeof(mapf);
 	mapf.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_READABLE |
 		     IOMMU_IOAS_MAP_WRITEABLE;
@@ -367,10 +379,10 @@ int main(void)
 
 	munmap(bar, reg.size);
 	close(vfio_fd);
-	close(dmabuf_fd);
 	close(iommufd_fd);
 	munmap(provider_hva, PROVIDER_SIZE);
 	close(gmem_fd);
+	close(dmabuf_fd);
 	close(gmem_ctl);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 04a910164a29..c168c0880ebf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -664,17 +664,38 @@ static inline bool is_smt_on(void)
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
-static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
-					  u64 flags)
+static inline int __vm_create_guest_memfd_dmabuf(struct kvm_vm *vm,
+						 u64 size, u64 flags,
+						 int dmabuf_fd)
 {
 	struct kvm_create_guest_memfd guest_memfd = {
 		.size = size,
 		.flags = flags,
+		.dmabuf_fd = dmabuf_fd,
 	};
 
 	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
 }
 
+static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
+					  u64 flags)
+{
+	return __vm_create_guest_memfd_dmabuf(vm, size, flags, 0);
+}
+
+/* A guest_memfd that imports the dma-buf @dmabuf_fd for its memory. */
+static inline int vm_create_guest_memfd_dmabuf(struct kvm_vm *vm,
+					       u64 size, u64 flags,
+					       int dmabuf_fd)
+{
+	int fd = __vm_create_guest_memfd_dmabuf(vm, size,
+						  flags | GUEST_MEMFD_FLAG_USE_DMABUF,
+						  dmabuf_fd);
+
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_GUEST_MEMFD, fd));
+	return fd;
+}
+
 static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
 					u64 flags)
 {
diff --git a/tools/testing/selftests/kvm/x86/gmem_poc_test.c b/tools/testing/selftests/kvm/x86/gmem_poc_test.c
new file mode 100644
index 000000000000..bdb64fe949ad
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/gmem_poc_test.c
@@ -0,0 +1,824 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * gmem_poc_test - one provider, a control process and two VMMs.
+ *
+ * Two roles in one process, kept apart on purpose:
+ *
+ *  ctl:  owns /dev/gmem_provider (the root).  Creates a child per VM with a
+ *        narrowed allowlist, MOVEs a range between children, DONATEs and
+ *        RECLAIMs, flips scratch mode.  Never touches a VM.
+ *  vmm:  owns one child fd, one KVM VM and one iommufd IOAS.  Creates the
+ *        VM's guest_memfd with the child as provider fd, binds it to the
+ *        memslot, and maps the guest_memfd's dma-buf into the IOAS on a
+ *        mock domain.  The provider revokes into guest_memfd; KVM and the
+ *        device follow.  The VMM never touches the control fd, and its
+ *        allowlist would stop it.
+ *
+ * guest_memfd sees one flat fd per VM; every relationship between fds lives
+ * in the provider.  The scenarios:
+ *
+ *  1. Launch:    each guest runs on its child and its write lands.
+ *  2. Move:      a range leaves A for B.  A faults on it and exits to its VMM
+ *                with KVM_EXIT_MEMORY_FAULT; A's device mapping of it is a
+ *                hole and the rest is intact; B reads what A wrote there.
+ *  3. Donate:    a range leaves A for the root and comes back on RECLAIM.
+ *  4. Read-only: a guest write to a read-only page exits; after clearing
+ *                the bit the same write lands.
+ *  5. Scratch:   with scratch mode on, A's donated range resolves in the
+ *                IOAS to one frame that is none of A's, and reads as zero.
+ *  6. Fragment: alternate scratch and owned pages in one 2 MiB block read
+ *                correctly and map at 4K; an untouched block maps at 2M.
+ *  7. Allowlist: B's fd cannot reach an ioctl the control process did not grant.
+ *  8. Window:    a VMM window mmap()ed through the guest_memfd fd over a
+ *                range the provider donates faults afterwards: the
+ *                revoke tore the host PTEs down too.
+ *
+ * A's guest_memfd is created while another thread flips SET_PRESENT and
+ * SET_READONLY on its child, so attachment races exporter invalidation.
+ *
+ * Runs on the iommufd mock domain: no device needed.  Requires
+ * /dev/gmem_provider (samples/kvm/gmem_provider.ko) and /dev/iommu.
+ */
+#include <fcntl.h>
+#include <errno.h>
+#include <setjmp.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdatomic.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/iommufd.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * The iommufd mock domain's test ABI.  Only the three probes we need; the
+ * iommufd selftest helper header brings the kselftest harness and its own
+ * bitops with it, which do not coexist with the KVM selftest library.
+ */
+#include "../../../../../drivers/iommu/iommufd/iommufd_test.h"
+
+/* Mirrors samples/kvm/gmem_provider.h */
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
+#define GMEM_ALLOW_SET_PRESENT		(1u << 0)
+#define GMEM_ALLOW_SET_READONLY		(1u << 1)
+#define GMEM_ALLOW_GET_DMABUF		(1u << 2)
+#define GMEM_ALLOW_GET_STATS		(1u << 3)
+
+struct gmem_provider_present { __u64 offset, len; __u32 present, pad; };
+struct gmem_provider_readonly { __u64 offset, len; __u32 readonly, pad; };
+struct gmem_provider_new_child {
+	__s32 kvm_fd; __u32 flags; __u64 offset, len; __u32 allow, pad;
+};
+
+struct gmem_provider_move { __s32 src_fd, dst_fd; __u64 offset, len; };
+
+struct gmem_provider_donate { __s32 fd; __u32 pad; __u64 offset, len; };
+
+struct gmem_provider_scratch { __u32 enable, pad; };
+
+struct gmem_provider_stats {
+	__u64 region_offset, region_len, owned_pages, absent_pages, readonly_pages;
+	__u32 allow, pad;
+};
+
+#define GMEM_PROVIDER_SET_PRESENT	_IOW('G', 2, struct gmem_provider_present)
+#define GMEM_PROVIDER_SET_READONLY	_IOW('G', 4, struct gmem_provider_readonly)
+#define GMEM_PROVIDER_NEW_CHILD		_IOW('G', 5, struct gmem_provider_new_child)
+#define GMEM_PROVIDER_MOVE		_IOW('G', 6, struct gmem_provider_move)
+#define GMEM_PROVIDER_DONATE		_IOW('G', 7, struct gmem_provider_donate)
+#define GMEM_PROVIDER_RECLAIM		_IOW('G', 8, struct gmem_provider_donate)
+#define GMEM_PROVIDER_SET_SCRATCH	_IOW('G', 9, struct gmem_provider_scratch)
+#define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
+#define GMEM_PROVIDER_GET_STATS		_IOR('G', 10, struct gmem_provider_stats)
+
+#define PAGE		0x1000ULL
+#define CHILD_SIZE	0x800000ULL		/* 8 MiB per child */
+#define GPA		(1ULL << 32)		/* each VM maps its child here */
+#define IOVA		(1ULL << 28)		/* inside the mock domain's aperture */
+#define MAGIC_A		0xa11ce000a11ce000ULL
+#define MAGIC_B		0xb0bb0bb0b0bb0bb0ULL
+
+/*
+ * Layout of the root region.  A and B are carved so that they OVERLAP on
+ * [SHARED_OFF, +SHARED_LEN): a carve is the range a child may ever hold,
+ * ownership within it is per page.  the control process creates A owning its whole carve and
+ * B owning its carve minus the shared window, so the window starts with A
+ * and can MOVE to B.  This is the carve-out shape: two VMs, two fds,
+ * one range that changes hands, no shared object in guest_memfd.
+ */
+#define A_OFF		0ULL
+#define SHARED_LEN	(4 * PAGE)
+#define B_OFF		(CHILD_SIZE - SHARED_LEN)	/* B's carve begins at the window */
+#define SHARED_OFF	B_OFF				/* root offset of the window */
+#define ROOT_SIZE	(B_OFF + CHILD_SIZE)
+
+/* The shared window as each VM sees it. */
+#define A_SHARED_GPA	(GPA + (SHARED_OFF - A_OFF))
+#define B_SHARED_GPA	(GPA + (SHARED_OFF - B_OFF))
+#define A_SHARED_IOVA	(IOVA + (SHARED_OFF - A_OFF))
+
+/* A page of A's that is never moved, for read-only and control checks. */
+#define RO_OFF		(64 * PAGE)
+#define RO_GPA		(GPA + RO_OFF)
+
+/* A page B owns from the start (B's offset 0 is the window it lacks). */
+#define B_HOME_OFF	(CHILD_SIZE / 2)
+#define B_HOME_GPA	(GPA + B_HOME_OFF)
+
+#define FRAG_OFF	0ULL
+#define FRAG_LEN	0x200000ULL		/* one 2 MiB-aligned block */
+#define HUGE_OFF	0x200000ULL		/* untouched 2 MiB block */
+#define FRAG_MAGIC	0x5a5a5a5a5a5a5a5aULL
+
+/* ------------------------------------------------------------------------ */
+/* Guest: read args from a fixed GVA, act, report.                           */
+
+struct guest_args {
+	uint64_t write_gpa;	/* 0 = skip */
+	uint64_t write_val;
+	uint64_t read_gpa;	/* 0 = skip; value returned via GUEST_SYNC */
+	uint64_t scan_gpa;
+	uint64_t scan_pages;
+	uint64_t scan_value;
+};
+
+static void guest_code(struct guest_args *a)
+{
+	if (a->write_gpa)
+		*(volatile uint64_t *)a->write_gpa = a->write_val;
+	if (a->read_gpa)
+		GUEST_SYNC(*(volatile uint64_t *)a->read_gpa);
+	if (a->scan_pages) {
+		uint64_t i;
+
+		for (i = 0; i < a->scan_pages; i++) {
+			uint64_t value = *(volatile uint64_t *)(a->scan_gpa + i * PAGE);
+
+			GUEST_ASSERT_EQ(value, i & 1 ? a->scan_value : 0);
+		}
+	}
+	GUEST_DONE();
+}
+
+/* ------------------------------------------------------------------------ */
+/* the control process role: the only holder of the control fd.                              */
+
+struct vmm_control { int ctl; };
+
+static void ctl_open(struct vmm_control *c)
+{
+	c->ctl = open("/dev/gmem_provider", O_RDWR);
+	__TEST_REQUIRE(c->ctl >= 0, "gmem_provider not loaded");
+}
+
+static int ctl_new_child(struct vmm_control *c, int kvm_fd, uint64_t off, uint64_t len,
+			 uint32_t allow)
+{
+	struct gmem_provider_new_child nc = {
+		.kvm_fd = kvm_fd, .flags = GMEM_PROVIDER_FLAG_MMAP_CAPABLE,
+		.offset = off, .len = len, .allow = allow,
+	};
+	int fd = ioctl(c->ctl, GMEM_PROVIDER_NEW_CHILD, &nc);
+
+	TEST_ASSERT(fd >= 0, "NEW_CHILD(%#llx,%#llx) errno=%d",
+		    (unsigned long long)off, (unsigned long long)len, errno);
+	return fd;
+}
+
+static int ctl_move(struct vmm_control *c, int src, int dst, uint64_t off, uint64_t len)
+{
+	struct gmem_provider_move mv = { .src_fd = src, .dst_fd = dst,
+					 .offset = off, .len = len };
+
+	return ioctl(c->ctl, GMEM_PROVIDER_MOVE, &mv) ? -errno : 0;
+}
+
+static void ctl_donate(struct vmm_control *c, int fd, uint64_t off, uint64_t len, bool reclaim)
+{
+	struct gmem_provider_donate d = { .fd = fd, .offset = off, .len = len };
+
+	TEST_ASSERT(!ioctl(c->ctl, reclaim ? GMEM_PROVIDER_RECLAIM
+					   : GMEM_PROVIDER_DONATE, &d),
+		    "%s errno=%d", reclaim ? "RECLAIM" : "DONATE", errno);
+}
+
+static void ctl_scratch(struct vmm_control *c, bool on)
+{
+	struct gmem_provider_scratch sc = { .enable = on };
+
+	TEST_ASSERT(!ioctl(c->ctl, GMEM_PROVIDER_SET_SCRATCH, &sc),
+		    "SET_SCRATCH errno=%d", errno);
+}
+
+/* ------------------------------------------------------------------------ */
+/* VMM role: one child fd, one VM, one IOAS.                                 */
+
+struct vmm {
+	const char *name;
+	int child;			/* control fd: windows, stats, allowed ioctls */
+	int gmem;			/* the VM's memory object: memslot fd, window mmaps */
+	int dmabuf;			/* the child's dma-buf: what KVM and iommufd both import */
+	int iommufd;
+	uint32_t ioas, stdev, hwpt;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	void *hva;			/* host window over the whole child */
+	gva_t args_gva;
+};
+
+static void vmm_create(struct vmm *v)
+{
+	struct vm_shape shape = { .mode = VM_MODE_DEFAULT,
+				  .type = KVM_X86_SW_PROTECTED_VM };
+
+	v->vm = vm_create_shape_with_one_vcpu(shape, &v->vcpu, guest_code);
+	v->args_gva = vm_alloc_page(v->vm);
+}
+
+static int mock_domain_create(struct vmm *v)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MOCK_DOMAIN, .id = v->ioas,
+	};
+
+	if (ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd))
+		return -errno;
+	v->stdev = cmd.mock_domain.out_stdev_id;
+	v->hwpt = cmd.mock_domain.out_hwpt_id;
+	return 0;
+}
+
+static bool vmm_iova_mapped(struct vmm *v, uint64_t iova)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MD_CHECK_MAPPED, .id = v->hwpt,
+		.check_mapped = { .mapped = true, .iova = iova, .length = PAGE },
+	};
+
+	return !ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd);
+}
+
+static uint64_t vmm_iova_phys(struct vmm *v, uint64_t iova)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd), .op = IOMMU_TEST_OP_MD_IOVA_TO_PHYS, .id = v->hwpt,
+		.iova_to_phys = { .iova = iova },
+	};
+
+	if (ioctl(v->iommufd, IOMMU_TEST_CMD, &cmd))
+		return 0;
+	return cmd.iova_to_phys.out_phys;
+}
+
+/*
+ * Whether the importer understands the full get_phys() contract: several
+ * ranges, holes, and a ranged invalidation it answers by re-reading the
+ * layout.  Without that, iommufd maps only a buffer whose layout is one
+ * range (-EOPNOTSUPP otherwise), and any change to the buffer costs the
+ * device its whole mapping for good.  Detected at attach time from B,
+ * whose child has a hole at launch; the device-plane checks below say
+ * what to expect either way.
+ */
+static bool ranged_import = true;
+
+/* Map [off, off+len) of the child into the IOAS at the matching IOVA. */
+static int vmm_map_range(struct vmm *v, uint64_t off, uint64_t len)
+{
+	struct iommu_ioas_map_file map = {
+		.size = sizeof(map),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_READABLE |
+			 IOMMU_IOAS_MAP_WRITEABLE,
+		.ioas_id = v->ioas, .fd = v->dmabuf,
+		.start = off, .length = len, .iova = IOVA + off,
+	};
+
+	return ioctl(v->iommufd, IOMMU_IOAS_MAP_FILE, &map) ? -errno : 0;
+}
+
+/*
+ * the control process hands the VMM its child fd and the range it owns today.  The VMM
+ * creates the VM's guest_memfd from it (provider fd), binds the whole view
+ * to the memslot, and maps the owned part into the IOAS with
+ * IOMMU_IOAS_MAP_FILE on the guest_memfd's dma-buf.  iommufd refuses to map a range
+ * guest_memfd reports as a hole, so a VMM maps what it has and maps more
+ * when the control process tells it a range arrived (see scenario_move).
+ */
+struct create_race {
+	int child;
+	atomic_bool stop;
+	atomic_int error;
+};
+
+static void *create_race_thread(void *arg)
+{
+	struct create_race *race = arg;
+	struct gmem_provider_present present = { .offset = RO_OFF, .len = PAGE };
+	struct gmem_provider_readonly readonly = { .offset = RO_OFF, .len = PAGE };
+
+	while (!atomic_load(&race->stop)) {
+		present.present = 0;
+		if (ioctl(race->child, GMEM_PROVIDER_SET_PRESENT, &present))
+			break;
+		present.present = 1;
+		if (ioctl(race->child, GMEM_PROVIDER_SET_PRESENT, &present))
+			break;
+		readonly.readonly = 1;
+		if (ioctl(race->child, GMEM_PROVIDER_SET_READONLY, &readonly))
+			break;
+		readonly.readonly = 0;
+		if (ioctl(race->child, GMEM_PROVIDER_SET_READONLY, &readonly))
+			break;
+	}
+	if (!atomic_load(&race->stop))
+		atomic_store(&race->error, errno ?: EIO);
+	return NULL;
+}
+
+static void finish_create_race(struct create_race *race, pthread_t thread)
+{
+	struct gmem_provider_present present = {
+		.offset = RO_OFF, .len = PAGE, .present = 1,
+	};
+	struct gmem_provider_readonly readonly = {
+		.offset = RO_OFF, .len = PAGE, .readonly = 0,
+	};
+
+	atomic_store(&race->stop, true);
+	TEST_ASSERT(!pthread_join(thread, NULL), "pthread_join");
+	TEST_ASSERT(!atomic_load(&race->error), "create race errno=%d",
+		    atomic_load(&race->error));
+	TEST_ASSERT(!ioctl(race->child, GMEM_PROVIDER_SET_PRESENT, &present),
+		    "restore present errno=%d", errno);
+	TEST_ASSERT(!ioctl(race->child, GMEM_PROVIDER_SET_READONLY, &readonly),
+		    "restore writable errno=%d", errno);
+}
+
+static void vmm_attach(struct vmm *v, int child_fd, uint64_t own_off,
+		       uint64_t own_len, uint64_t gmem_flags, bool race_create)
+{
+	struct iommu_ioas_alloc alloc = { .size = sizeof(alloc) };
+	struct create_race race = { .child = child_fd };
+	void *reservation;
+	pthread_t thread;
+	int r;
+
+	v->child = child_fd;
+
+	/*
+	 * KVM leg: a guest_memfd whose memory the child provides.  The child
+	 * is the provider fd; guest_memfd is the VM's one memory object.  The
+	 * host window is the provider fd's mmap.
+	 */
+	v->dmabuf = ioctl(v->child, GMEM_PROVIDER_GET_DMABUF);
+	TEST_ASSERT(v->dmabuf >= 0, "GMEM_PROVIDER_GET_DMABUF errno=%d", errno);
+	if (race_create)
+		TEST_ASSERT(!pthread_create(&thread, NULL, create_race_thread, &race),
+			    "pthread_create");
+	v->gmem = vm_create_guest_memfd_dmabuf(v->vm, CHILD_SIZE, gmem_flags,
+					       v->dmabuf);
+	if (race_create)
+		finish_create_race(&race, thread);
+	reservation = mmap(NULL, CHILD_SIZE + FRAG_LEN, PROT_NONE,
+			   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	TEST_ASSERT(reservation != MAP_FAILED, "%s: reserve HVA errno=%d",
+		    v->name, errno);
+	v->hva = (void *)(((uintptr_t)reservation + FRAG_LEN - 1) &
+			  ~((uintptr_t)FRAG_LEN - 1));
+	v->hva = mmap(v->hva, CHILD_SIZE, PROT_READ | PROT_WRITE,
+		      MAP_SHARED | MAP_FIXED, v->child, 0);
+	TEST_ASSERT(v->hva != MAP_FAILED, "%s: mmap child errno=%d", v->name,
+		    errno);
+	r = __vm_set_user_memory_region2(v->vm, 10, KVM_MEM_GUEST_MEMFD, GPA,
+					 CHILD_SIZE, v->hva, v->gmem, 0);
+	TEST_ASSERT(!r, "%s: SET_USER_MEMORY_REGION2 r=%d errno=%d", v->name, r, errno);
+	virt_map(v->vm, GPA, GPA, CHILD_SIZE / PAGE);
+	/* Private, so every guest access goes through get_pfn(), not the HVA. */
+	vm_mem_set_private(v->vm, GPA, CHILD_SIZE);
+
+	/* DMA leg: the same guest_memfd, into an IOAS on a mock domain. */
+	v->iommufd = open("/dev/iommu", O_RDWR);
+	__TEST_REQUIRE(v->iommufd >= 0, "iommufd unavailable");
+	TEST_ASSERT(!ioctl(v->iommufd, IOMMU_IOAS_ALLOC, &alloc), "IOAS_ALLOC errno=%d", errno);
+	v->ioas = alloc.out_ioas_id;
+
+	/* A mock device on a mock domain, so the IOAS is really programmed. */
+	r = mock_domain_create(v);
+	TEST_ASSERT(!r, "%s: mock domain r=%d (CONFIG_IOMMUFD_TEST?)", v->name, r);
+
+	r = vmm_map_range(v, own_off, own_len);
+	if (r == -EOPNOTSUPP && own_off) {
+		/* B's layout has a hole at launch; only a ranged importer takes it. */
+		ranged_import = false;
+		pr_info("   iommufd maps one range; device checks expect full revoke\n");
+		return;
+	}
+	TEST_ASSERT(!r, "%s: IOAS_MAP_FILE(dma-buf) r=%d", v->name, r);
+}
+
+/*
+ * Continue the guest where it stopped.  KVM_RUN returns -EFAULT for
+ * KVM_EXIT_MEMORY_FAULT, which several scenarios expect, so do not assert
+ * on it here; the expect_*() helpers check the exit.
+ */
+static void vmm_resume(struct vmm *v)
+{
+	int r = _vcpu_run(v->vcpu);
+
+	TEST_ASSERT(!r || (errno == EFAULT &&
+			   v->vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT),
+		    "%s: KVM_RUN r=%d errno=%d exit=%s", v->name, r, errno,
+		    exit_reason_str(v->vcpu->run->exit_reason));
+}
+
+/* Run the guest from the top with fresh args. */
+static void vmm_run(struct vmm *v, uint64_t write_gpa, uint64_t write_val,
+		    uint64_t read_gpa)
+{
+	struct guest_args *a = addr_gva2hva(v->vm, v->args_gva);
+
+	a->write_gpa = write_gpa;
+	a->write_val = write_val;
+	a->read_gpa = read_gpa;
+	a->scan_pages = 0;
+	vcpu_arch_set_entry_point(v->vcpu, guest_code);
+	vcpu_args_set(v->vcpu, 1, v->args_gva);
+	vmm_resume(v);
+}
+
+static void vmm_scan(struct vmm *v, uint64_t gpa, uint64_t pages,
+		     uint64_t value)
+{
+	struct guest_args *a = addr_gva2hva(v->vm, v->args_gva);
+
+	memset(a, 0, sizeof(*a));
+	a->scan_gpa = gpa;
+	a->scan_pages = pages;
+	a->scan_value = value;
+	vcpu_arch_set_entry_point(v->vcpu, guest_code);
+	vcpu_args_set(v->vcpu, 1, v->args_gva);
+	vmm_resume(v);
+}
+
+static void expect_done(struct vmm *v)
+{
+	struct kvm_run *run = v->vcpu->run;
+	struct ucall uc;
+
+	TEST_ASSERT(run->exit_reason != KVM_EXIT_MEMORY_FAULT,
+		    "%s: unexpected memory fault gpa=%#llx size=%#llx flags=%#llx",
+		    v->name, (unsigned long long)run->memory_fault.gpa,
+		    (unsigned long long)run->memory_fault.size,
+		    (unsigned long long)run->memory_fault.flags);
+	TEST_ASSERT(get_ucall(v->vcpu, &uc) == UCALL_DONE, "%s: guest exit %s",
+		    v->name, exit_reason_str(run->exit_reason));
+}
+
+static uint64_t expect_sync_then_done(struct vmm *v)
+{
+	struct ucall uc;
+	uint64_t val;
+
+	TEST_ASSERT(get_ucall(v->vcpu, &uc) == UCALL_SYNC, "%s: guest exit %s",
+		    v->name, exit_reason_str(v->vcpu->run->exit_reason));
+	val = uc.args[1];
+	vmm_resume(v);
+	expect_done(v);
+	return val;
+}
+
+static void expect_memory_fault(struct vmm *v, uint64_t gpa)
+{
+	struct kvm_run *run = v->vcpu->run;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+		    "%s: want KVM_EXIT_MEMORY_FAULT, got %s", v->name,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->memory_fault.gpa == gpa, "%s: fault gpa %#llx, want %#llx",
+		    v->name, (unsigned long long)run->memory_fault.gpa,
+		    (unsigned long long)gpa);
+}
+
+static void vmm_stats(struct vmm *v, struct gmem_provider_stats *st)
+{
+	TEST_ASSERT(!ioctl(v->child, GMEM_PROVIDER_GET_STATS, st),
+		    "%s: GET_STATS errno=%d", v->name, errno);
+}
+
+static void vmm_destroy(struct vmm *v)
+{
+	kvm_vm_free(v->vm);
+	close(v->gmem);
+	close(v->iommufd);
+	munmap(v->hva, CHILD_SIZE);
+	close(v->child);
+}
+
+/* ------------------------------------------------------------------------ */
+/* Scenarios.                                                                 */
+
+static void scenario_launch(struct vmm *a, struct vmm *b)
+{
+	pr_info("1. launch\n");
+	vmm_run(a, GPA, MAGIC_A, 0);
+	expect_done(a);
+	vmm_run(b, B_HOME_GPA, MAGIC_B, 0);
+	expect_done(b);
+	TEST_ASSERT(*(volatile uint64_t *)a->hva == MAGIC_A, "A's write missing");
+	TEST_ASSERT(*(volatile uint64_t *)(b->hva + B_HOME_OFF) == MAGIC_B, "B's write missing");
+	TEST_ASSERT(vmm_iova_mapped(a, IOVA) && vmm_iova_mapped(a, A_SHARED_IOVA),
+		    "A: IOAS not fully mapped after launch");
+}
+
+static void scenario_move(struct vmm_control *c, struct vmm *a, struct vmm *b)
+{
+	struct gmem_provider_stats st;
+	int r;
+
+	pr_info("2. move A -> B\n");
+
+	/* A writes into the window while it still owns it. */
+	vmm_run(a, A_SHARED_GPA, MAGIC_A, 0);
+	expect_done(a);
+
+	/* B does not own the window yet: a read faults out to B's VMM ... */
+	vmm_run(b, 0, 0, B_SHARED_GPA);
+	expect_memory_fault(b, B_SHARED_GPA);
+	/* ... and iommufd refuses to map a hole (or a layout with one in it). */
+	r = vmm_map_range(b, SHARED_OFF - B_OFF, SHARED_LEN);
+	TEST_ASSERT(r == (ranged_import ? -EFAULT : -EOPNOTSUPP),
+		    "B: mapping an unowned window returned %d", r);
+
+	/* A move outside the destination's carve is refused. */
+	r = ctl_move(c, a->child, b->child, RO_OFF, PAGE);
+	TEST_ASSERT(r == -EINVAL, "MOVE outside B's carve returned %d", r);
+
+	/* The real move. */
+	r = ctl_move(c, a->child, b->child, SHARED_OFF, SHARED_LEN);
+	TEST_ASSERT(!r, "MOVE returned %d", r);
+
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE - SHARED_LEN / PAGE,
+		    "A owns %llu pages after move", (unsigned long long)st.owned_pages);
+	vmm_stats(b, &st);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE,
+		    "B owns %llu pages after move", (unsigned long long)st.owned_pages);
+
+	/* A's device mapping: exactly the window is a hole, neighbours intact. */
+	TEST_ASSERT(!vmm_iova_mapped(a, A_SHARED_IOVA), "A: moved IOVA still mapped");
+	TEST_ASSERT(!vmm_iova_mapped(a, A_SHARED_IOVA + SHARED_LEN - PAGE),
+		    "A: last moved IOVA still mapped");
+	if (ranged_import) {
+		TEST_ASSERT(vmm_iova_mapped(a, A_SHARED_IOVA - PAGE), "A: page before window lost");
+		TEST_ASSERT(vmm_iova_mapped(a, IOVA), "A: base lost");
+	} else {
+		/* Whole-buffer revocation: the untouched pages went with the window. */
+		TEST_ASSERT(!vmm_iova_mapped(a, IOVA), "A: base survived a whole-buffer revoke");
+	}
+
+	/* A's guest: the window is gone. */
+	vmm_run(a, 0, 0, A_SHARED_GPA);
+	expect_memory_fault(a, A_SHARED_GPA);
+
+	/* B's guest: the window is here, and it holds what A wrote. */
+	vmm_run(b, 0, 0, B_SHARED_GPA);
+	TEST_ASSERT(expect_sync_then_done(b) == MAGIC_A, "B does not see A's write");
+
+	/*
+	 * B's device: the control process told B's VMM the window arrived; now
+	 * it maps.  B's layout is one range from here on, so this works with
+	 * either importer.
+	 */
+	r = vmm_map_range(b, SHARED_OFF - B_OFF, SHARED_LEN);
+	TEST_ASSERT(!r, "B: mapping the received window r=%d", r);
+	TEST_ASSERT(vmm_iova_mapped(b, IOVA + (SHARED_OFF - B_OFF)), "B: window not mapped");
+}
+
+static void scenario_donate(struct vmm_control *c, struct vmm *a)
+{
+	struct gmem_provider_stats st;
+	uint64_t off = A_OFF + 8 * PAGE, gpa = GPA + 8 * PAGE, iova = IOVA + 8 * PAGE;
+
+	pr_info("3. donate + reclaim\n");
+	ctl_donate(c, a->child, off, 2 * PAGE, false);
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE - SHARED_LEN / PAGE - 2,
+		    "A owns %llu after donate", (unsigned long long)st.owned_pages);
+	if (ranged_import) {
+		TEST_ASSERT(!vmm_iova_mapped(a, iova) && !vmm_iova_mapped(a, iova + PAGE),
+			    "A: donated IOVAs still mapped");
+		TEST_ASSERT(vmm_iova_mapped(a, iova - PAGE) && vmm_iova_mapped(a, iova + 2 * PAGE),
+			    "A: neighbours of donation lost");
+	}
+	vmm_run(a, 0, 0, gpa);
+	expect_memory_fault(a, gpa);
+
+	ctl_donate(c, a->child, off, 2 * PAGE, true);
+	vmm_stats(a, &st);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE - SHARED_LEN / PAGE,
+		    "A owns %llu after reclaim", (unsigned long long)st.owned_pages);
+	if (ranged_import)
+		TEST_ASSERT(vmm_iova_mapped(a, iova), "A: reclaimed IOVA not remapped");
+	vmm_run(a, 0, 0, gpa);
+	expect_sync_then_done(a);
+}
+
+static void scenario_readonly(struct vmm *a)
+{
+	struct gmem_provider_readonly ro = { .offset = RO_OFF, .len = PAGE, .readonly = 1 };
+
+	pr_info("4. read-only\n");
+	TEST_ASSERT(!ioctl(a->child, GMEM_PROVIDER_SET_READONLY, &ro),
+		    "SET_READONLY errno=%d", errno);
+
+	vmm_run(a, RO_GPA, MAGIC_A, 0);
+	expect_memory_fault(a, RO_GPA);
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + RO_OFF) != MAGIC_A, "RO write landed");
+
+	/* Clear the bit and let the guest retry the same instruction. */
+	ro.readonly = 0;
+	TEST_ASSERT(!ioctl(a->child, GMEM_PROVIDER_SET_READONLY, &ro), "clear RO errno=%d", errno);
+	vmm_resume(a);
+	expect_done(a);
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + RO_OFF) == MAGIC_A,
+		    "write after clearing RO did not land");
+}
+
+static void scenario_scratch(struct vmm_control *c, struct vmm *a)
+{
+	uint64_t off = A_OFF + 8 * PAGE, gpa = GPA + 8 * PAGE, iova = IOVA + 8 * PAGE;
+	uint64_t own0, own_before, p0, p1;
+
+	pr_info("5. scratch\n");
+	if (!ranged_import) {
+		pr_info("   skipped: needs the device mapping A lost in scenario 2\n");
+		return;
+	}
+	own0 = vmm_iova_phys(a, IOVA);
+	own_before = vmm_iova_phys(a, iova - PAGE);
+	TEST_ASSERT(own0 && own_before, "A: expected pages unmapped before scratch test");
+
+	ctl_scratch(c, true);
+	ctl_donate(c, a->child, off, 2 * PAGE, false);
+
+	p0 = vmm_iova_phys(a, iova);
+	p1 = vmm_iova_phys(a, iova + PAGE);
+	TEST_ASSERT(p0 && p0 == p1, "scratch: donated IOVAs -> %#llx, %#llx; want one frame",
+		    (unsigned long long)p0, (unsigned long long)p1);
+	TEST_ASSERT(p0 != own0 && p0 != own_before, "scratch frame is one of A's own");
+	TEST_ASSERT(vmm_iova_phys(a, IOVA) == own0, "scratch: unrelated IOVA changed");
+
+	/* The guest reads the scratch page: no fault, and it is zero. */
+	vmm_run(a, 0, 0, gpa);
+	TEST_ASSERT(expect_sync_then_done(a) == 0, "scratch page must read as zero");
+
+	ctl_donate(c, a->child, off, 2 * PAGE, true);
+	ctl_scratch(c, false);
+	TEST_ASSERT(vmm_iova_phys(a, iova) != p0, "after reclaim IOVA still on scratch");
+}
+
+static void scenario_fragmented(struct vmm_control *c, struct vmm *a)
+{
+	uint64_t p4k_before, p2m_before, p4k_after, p2m_after;
+	unsigned long i;
+
+	pr_info("6. fragmented layout\n");
+	for (i = 0; i < (FRAG_LEN / PAGE); i++)
+		*(uint64_t *)(a->hva + FRAG_OFF + i * PAGE) = FRAG_MAGIC;
+	*(uint64_t *)(a->hva + HUGE_OFF) = FRAG_MAGIC;
+	p4k_before = vm_get_stat(a->vm, pages_4k);
+	p2m_before = vm_get_stat(a->vm, pages_2m);
+	ctl_scratch(c, true);
+	for (i = 0; i < (FRAG_LEN / PAGE); i += 2)
+		ctl_donate(c, a->child, A_OFF + FRAG_OFF + i * PAGE, PAGE, false);
+
+	vmm_scan(a, GPA + FRAG_OFF, FRAG_LEN / PAGE, FRAG_MAGIC);
+	expect_done(a);
+	p4k_after = vm_get_stat(a->vm, pages_4k);
+	TEST_ASSERT(p4k_after > p4k_before,
+		    "fragmented block did not add 4K mappings");
+	/* The fragmented block's own 2M mapping was zapped; measure from here. */
+	p2m_before = vm_get_stat(a->vm, pages_2m);
+
+	vmm_run(a, 0, 0, GPA + HUGE_OFF);
+	TEST_ASSERT(expect_sync_then_done(a) == FRAG_MAGIC,
+		    "untouched block data changed");
+	p2m_after = vm_get_stat(a->vm, pages_2m);
+	pr_info("   fragmented levels: 4K %llu->%llu, 2M %llu->%llu\n",
+		(unsigned long long)p4k_before, (unsigned long long)p4k_after,
+		(unsigned long long)p2m_before, (unsigned long long)p2m_after);
+	TEST_ASSERT(p2m_after > p2m_before,
+		    "untouched block did not add a 2M mapping");
+
+	for (i = 0; i < (FRAG_LEN / PAGE); i += 2)
+		ctl_donate(c, a->child, A_OFF + FRAG_OFF + i * PAGE, PAGE, true);
+	ctl_scratch(c, false);
+}
+
+static void scenario_allowlist(struct vmm *b)
+{
+	struct gmem_provider_present p = { .offset = 0, .len = PAGE, .present = 0 };
+	struct gmem_provider_stats st;
+
+	pr_info("7. allowlist\n");
+	TEST_ASSERT(ioctl(b->child, GMEM_PROVIDER_SET_PRESENT, &p) && errno == EPERM,
+		    "B: SET_PRESENT must be denied");
+	vmm_stats(b, &st);
+	TEST_ASSERT(!(st.allow & GMEM_ALLOW_SET_PRESENT), "B allow=%#x", st.allow);
+	TEST_ASSERT(st.owned_pages == CHILD_SIZE / PAGE, "B lost pages to a denied ioctl");
+}
+
+/* 8. A window through the gmem fd dies with the range it covers. */
+static sigjmp_buf window_jmp;
+static void window_sig(int sig)
+{
+	siglongjmp(window_jmp, sig);
+}
+
+static void scenario_window(struct vmm_control *c, struct vmm *a)
+{
+	uint64_t off = A_OFF + 8 * PAGE;
+	struct sigaction sa = { .sa_handler = window_sig }, old_bus, old_segv;
+	volatile uint64_t *win;
+	int sig;
+
+	pr_info("8. host window teardown\n");
+	win = mmap(NULL, PAGE, PROT_READ | PROT_WRITE, MAP_SHARED, a->gmem, off);
+	TEST_ASSERT(win != MAP_FAILED, "mmap(gmem, window) errno=%d", errno);
+	*win = MAGIC_A;
+	TEST_ASSERT(*(volatile uint64_t *)(a->hva + off) == MAGIC_A,
+		    "window write not visible through the child mapping");
+
+	ctl_donate(c, a->child, off, PAGE, false);
+
+	sigaction(SIGBUS, &sa, &old_bus);
+	sigaction(SIGSEGV, &sa, &old_segv);
+	sig = sigsetjmp(window_jmp, 1);
+	if (!sig) {
+		(void)*win;		/* must fault: the PTE was torn down */
+		sigaction(SIGBUS, &old_bus, NULL);
+		sigaction(SIGSEGV, &old_segv, NULL);
+		TEST_FAIL("window still readable after the range was donated");
+	}
+	sigaction(SIGBUS, &old_bus, NULL);
+	sigaction(SIGSEGV, &old_segv, NULL);
+	pr_info("   window access after donate: signal %d, as expected\n", sig);
+
+	ctl_donate(c, a->child, off, PAGE, true);
+	munmap((void *)win, PAGE);
+}
+
+int main(void)
+{
+	struct vmm_control ctl;
+	struct vmm a = { .name = "A" }, b = { .name = "B" };
+	int a_fd, b_fd, sizing_fd;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+	ctl_open(&ctl);
+	vmm_create(&a);
+	vmm_create(&b);
+
+	/* Size a CMA-backed root for both overlapping child windows. */
+	sizing_fd = ctl_new_child(&ctl, a.vm->fd, 0, ROOT_SIZE, 0);
+	close(sizing_fd);
+
+	/*
+	 * The control process carves the root. A carve is a VM's whole view;
+	 * carves may overlap, but page ownership is exclusive. A is created
+	 * first and gets its full carve, including the shared window. B is
+	 * created second and gets only unowned pages, so its view has a hole
+	 * until the control process MOVEs the window over.
+	 * Neither VMM gets a management ioctl; those live on the control fd.
+	 */
+	a_fd = ctl_new_child(&ctl, a.vm->fd, A_OFF, CHILD_SIZE,
+			     GMEM_ALLOW_SET_PRESENT | GMEM_ALLOW_SET_READONLY |
+			     GMEM_ALLOW_GET_DMABUF |
+			     GMEM_ALLOW_GET_STATS);
+	b_fd = ctl_new_child(&ctl, b.vm->fd, B_OFF, CHILD_SIZE,
+			     GMEM_ALLOW_GET_DMABUF | GMEM_ALLOW_GET_STATS);
+	vmm_attach(&a, a_fd, 0, CHILD_SIZE, GUEST_MEMFD_FLAG_MMAP, true);
+	vmm_attach(&b, b_fd, SHARED_LEN, CHILD_SIZE - SHARED_LEN, 0, false);
+
+	scenario_launch(&a, &b);
+	scenario_move(&ctl, &a, &b);
+	scenario_donate(&ctl, &a);
+	scenario_readonly(&a);
+	scenario_scratch(&ctl, &a);
+	scenario_fragmented(&ctl, &a);
+	scenario_allowlist(&b);
+	scenario_window(&ctl, &a);
+
+	vmm_destroy(&a);
+	vmm_destroy(&b);
+	close(ctl.ctl);
+	pr_info("gmem_poc: all scenarios passed\n");
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_hugepage_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_hugepage_test.c
index fbbef9761e64..9c3bcfbe2cae 100644
--- a/tools/testing/selftests/kvm/x86/gmem_provider_hugepage_test.c
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_hugepage_test.c
@@ -36,8 +36,18 @@ struct gmem_provider_setup {
 	__u64 size;
 };
 #define GMEM_PROVIDER_SETUP _IOW('G', 1, struct gmem_provider_setup)
+#define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
 #define GMEM_PROVIDER_FLAG_MMAP_CAPABLE (1u << 0)
 
+/* The dma-buf for a sample-provider child: what KVM and iommufd both import. */
+static int child_dmabuf(int child_fd)
+{
+	int fd = ioctl(child_fd, GMEM_PROVIDER_GET_DMABUF);
+
+	TEST_ASSERT(fd >= 0, "GMEM_PROVIDER_GET_DMABUF errno=%d", errno);
+	return fd;
+}
+
 #define DATA_SLOT	10
 #define DATA_GPA	(1ULL << 32)		/* 4G: 1G-aligned */
 #define DATA_SIZE	((uint64_t)SZ_1G + SZ_2M)
@@ -59,7 +69,8 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int gmem_ctl, gmem_fd, r;
+	int gmem_ctl, gmem_fd, dmabuf_fd, r;
+	int prov_fd;
 	void *resv, *hva;
 	uint64_t p4k, p2m, p1g;
 
@@ -73,8 +84,17 @@ int main(void)
 
 	setup.kvm_fd = vm->fd;
 	setup.size = DATA_SIZE;
-	gmem_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
-	TEST_ASSERT(gmem_fd >= 0, "GMEM_PROVIDER_SETUP failed, errno %d", errno);
+	prov_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(prov_fd >= 0, "GMEM_PROVIDER_SETUP failed, errno %d", errno);
+
+	/*
+	 * The provider fd is not a guest_memfd; it is the provider fd.  The
+	 * guest_memfd KVM returns is what the memslot binds, what the host
+	 * mmaps (through the provider's mmap), and what iommufd would map.
+	 */
+	dmabuf_fd = child_dmabuf(prov_fd);
+	gmem_fd = vm_create_guest_memfd_dmabuf(vm, DATA_SIZE,
+					       GUEST_MEMFD_FLAG_MMAP, dmabuf_fd);
 
 	/*
 	 * Map the provider at a 1G-aligned host VA so the slot's userspace_addr
@@ -86,7 +106,7 @@ int main(void)
 	TEST_ASSERT(resv != MAP_FAILED, "reserve VA failed, errno %d", errno);
 	hva = (void *)(((uintptr_t)resv + SZ_1G - 1) & ~((uintptr_t)SZ_1G - 1));
 	hva = mmap(hva, DATA_SIZE, PROT_READ | PROT_WRITE,
-		   MAP_SHARED | MAP_FIXED, gmem_fd, 0);
+		   MAP_SHARED | MAP_FIXED, prov_fd, 0);
 	TEST_ASSERT(hva != MAP_FAILED,
 		    "mmap(provider) failed, errno %d", errno);
 
@@ -125,6 +145,8 @@ int main(void)
 	kvm_vm_free(vm);
 	munmap(hva, DATA_SIZE);
 	close(gmem_fd);
+	close(dmabuf_fd);
+	close(prov_fd);
 	close(gmem_ctl);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_iommufd_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_iommufd_test.c
index 885dffa0b659..b5f4afae5383 100644
--- a/tools/testing/selftests/kvm/x86/gmem_provider_iommufd_test.c
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_iommufd_test.c
@@ -6,8 +6,8 @@
  * write is visible via the host mmap.
  *
  * The iommufd side exercises exactly the provider->iommufd path we just wired:
- * GET_DMABUF on the provider fd -> IOMMU_IOAS_MAP_FILE, which walks
- * iopt_map_dmabuf -> sym_..._iommufd_map -> gmem_provider_dma_buf_iommufd_map.
+ * GMEM_PROVIDER_GET_DMABUF on the child -> IOMMU_IOAS_MAP_FILE, which walks
+ * iopt_map_dmabuf -> dma_buf_get_phys -> the provider's get_phys op.
  *
  * The test opens the provider with GMEM_PROVIDER_FLAG_MMAP_CAPABLE at SETUP time; requires iommufd
  * available at /dev/iommu.  Actual IOMMU page-table programming happens once
@@ -36,8 +36,17 @@ struct gmem_provider_setup {
 	__u64 size;
 };
 #define GMEM_PROVIDER_SETUP		_IOW('G', 1, struct gmem_provider_setup)
-#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
 #define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
+
+/* The dma-buf for a sample-provider child: what KVM and iommufd both import. */
+static int child_dmabuf(int child_fd)
+{
+	int fd = ioctl(child_fd, GMEM_PROVIDER_GET_DMABUF);
+
+	TEST_ASSERT(fd >= 0, "GMEM_PROVIDER_GET_DMABUF errno=%d", errno);
+	return fd;
+}
 
 #define DATA_SLOT	10
 #define DATA_GPA	(1ULL << 32)
@@ -64,6 +73,7 @@ int main(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int gmem_ctl, gmem_fd, dmabuf_fd, iommufd, r;
+	int prov_fd;
 	void *hva;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
@@ -80,13 +90,23 @@ int main(void)
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 	setup.kvm_fd = vm->fd;
 	setup.size = DATA_SIZE;
-	gmem_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
-	TEST_ASSERT(gmem_fd >= 0, "GMEM_PROVIDER_SETUP failed errno=%d", errno);
+	prov_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(prov_fd >= 0, "GMEM_PROVIDER_SETUP failed errno=%d", errno);
+
+	/*
+	 * The provider fd is not a guest_memfd.  Export its dma-buf and hand
+	 * that to KVM as the provider fd; the guest_memfd KVM returns is what
+	 * the memslot binds and what the host mmaps (mmap goes through the
+	 * exporter).  iommufd would import the very same dma-buf.
+	 */
+	dmabuf_fd = child_dmabuf(prov_fd);
+	gmem_fd = vm_create_guest_memfd_dmabuf(vm, DATA_SIZE,
+					       GUEST_MEMFD_FLAG_MMAP, dmabuf_fd);
 
 	/*
 	 * 2) KVM side: host mmap + guest_memfd memslot (gmem-only when mmap-capable).
 	 */
-	hva = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, gmem_fd, 0);
+	hva = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, prov_fd, 0);
 	TEST_ASSERT(hva != MAP_FAILED,
 		    "provider mmap failed errno=%d", errno);
 	r = __vm_set_user_memory_region2(vm, DATA_SLOT, KVM_MEM_GUEST_MEMFD,
@@ -105,16 +125,15 @@ int main(void)
 	/*
 	 * 3) iommufd side: allocate IOAS, get a dma-buf from the SAME provider fd,
 	 *    and map it into the IOAS via IOMMU_IOAS_MAP_FILE.  This drives
-	 *    iopt_map_dmabuf -> gmem_provider_dma_buf_iommufd_map.
+	 *    iopt_map_dmabuf -> dma_buf_get_phys -> the get_phys op.
 	 */
 	alloc.size = sizeof(alloc);
 	r = ioctl(iommufd, IOMMU_IOAS_ALLOC, &alloc);
 	TEST_ASSERT(!r, "IOMMU_IOAS_ALLOC failed errno=%d", errno);
 	pr_info("iommufd: allocated ioas id=%u\n", alloc.out_ioas_id);
 
-	dmabuf_fd = ioctl(gmem_fd, GMEM_PROVIDER_GET_DMABUF);
-	TEST_ASSERT(dmabuf_fd >= 0, "GMEM_PROVIDER_GET_DMABUF failed errno=%d", errno);
-	pr_info("provider: exported dma-buf fd=%d\n", dmabuf_fd);
+	/* IOMMU_IOAS_MAP_FILE takes the same dma-buf KVM imported. */
+	pr_info("guest_memfd fd=%d imports dma-buf fd=%d\n", gmem_fd, dmabuf_fd);
 
 	map.size = sizeof(map);
 	map.flags = IOMMU_IOAS_MAP_FIXED_IOVA |
@@ -127,7 +146,7 @@ int main(void)
 	r = ioctl(iommufd, IOMMU_IOAS_MAP_FILE, &map);
 	TEST_ASSERT(!r,
 		    "IOMMU_IOAS_MAP_FILE(dma-buf) failed r=%d errno=%d\n"
-		    "	 (gmem_provider_dma_buf_iommufd_map path)",
+		    "	 (dma_buf_get_phys path)",
 		    r, errno);
 	pr_info("iommufd: mapped provider dma-buf @ IOVA 0x%llx (0x%llx bytes)\n",
 		(unsigned long long)map.iova, (unsigned long long)map.length);
@@ -153,6 +172,7 @@ int main(void)
 	close(iommufd);
 	munmap(hva, DATA_SIZE);
 	close(gmem_fd);
+	close(prov_fd);
 	close(gmem_ctl);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c
new file mode 100644
index 000000000000..a1b8b7ba5640
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * gmem_provider_readonly_test - exercise per-range read-only from a provider.
+ *
+ * Marks a provider-backed page read-only via an ioctl on the provider fd and
+ * checks that KVM honours the provider's answer: the guest can still read the
+ * page, a guest write exits to userspace with KVM_EXIT_MEMORY_FAULT rather than
+ * landing, and clearing the bit lets the write through. This is the mechanism
+ * a hypervisor uses to protect a page it shares with the guest, such as a
+ * information page a helper VM reads, without giving up the mapping.
+ *
+ * The test opens the provider with GMEM_PROVIDER_FLAG_MMAP_CAPABLE at SETUP time
+ * (gmem-only). Load the module with a backing region of at least DATA_SIZE.
+ */
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/* Mirrors samples/kvm/gmem_provider.h */
+struct gmem_provider_setup {
+	__s32 kvm_fd;
+	__u32 flags;
+	__u64 size;
+};
+
+struct gmem_provider_readonly {
+	__u64 offset;
+	__u64 len;
+	__u32 readonly;
+	__u32 pad;
+};
+
+#define GMEM_PROVIDER_SETUP		_IOW('G', 1, struct gmem_provider_setup)
+#define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
+#define GMEM_PROVIDER_SET_READONLY	_IOW('G', 4, struct gmem_provider_readonly)
+
+/* The dma-buf for a sample-provider child: what KVM and iommufd both import. */
+static int child_dmabuf(int child_fd)
+{
+	int fd = ioctl(child_fd, GMEM_PROVIDER_GET_DMABUF);
+
+	TEST_ASSERT(fd >= 0, "GMEM_PROVIDER_GET_DMABUF errno=%d", errno);
+	return fd;
+}
+
+#define DATA_SLOT	10
+#define DATA_GPA	(1ULL << 32)
+#define DATA_SIZE	0x200000ULL		/* 2 MiB region */
+#define MAGIC		0x1234abcdULL
+#define MAGIC2		0xfeedf00dULL
+
+/*
+ * Phase 1: read the page and report it.
+ * Phase 2: write to it.  With the page read-only this never returns to the
+ *          guest until userspace clears the bit; then it completes and the
+ *          guest reports what it wrote.
+ */
+static void guest_code(void)
+{
+	GUEST_SYNC(*(volatile uint64_t *)DATA_GPA);
+	*(volatile uint64_t *)DATA_GPA = MAGIC2;
+	GUEST_SYNC(*(volatile uint64_t *)DATA_GPA);
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_SW_PROTECTED_VM,
+	};
+	struct gmem_provider_setup setup = { .flags = GMEM_PROVIDER_FLAG_MMAP_CAPABLE };
+	struct gmem_provider_readonly req;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int gmem_ctl, gmem_fd, dmabuf_fd, r;
+	int prov_fd;
+	void *hva;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+
+	gmem_ctl = open("/dev/gmem_provider", O_RDWR);
+	__TEST_REQUIRE(gmem_ctl >= 0,
+		       "gmem_provider module not loaded (/dev/gmem_provider absent)");
+
+	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
+
+	setup.kvm_fd = vm->fd;
+	setup.size = DATA_SIZE;
+	prov_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(prov_fd >= 0, "GMEM_PROVIDER_SETUP failed, errno %d", errno);
+
+	/*
+	 * The provider fd is not a guest_memfd; it is the provider fd.  The
+	 * guest_memfd KVM returns is what the memslot binds, what the host
+	 * mmaps (through the provider's mmap), and what iommufd would map.
+	 */
+	dmabuf_fd = child_dmabuf(prov_fd);
+	gmem_fd = vm_create_guest_memfd_dmabuf(vm, DATA_SIZE,
+					       GUEST_MEMFD_FLAG_MMAP, dmabuf_fd);
+
+	hva = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, prov_fd, 0);
+	TEST_ASSERT(hva != MAP_FAILED, "mmap(provider) failed, errno %d", errno);
+
+	r = __vm_set_user_memory_region2(vm, DATA_SLOT, KVM_MEM_GUEST_MEMFD,
+					 DATA_GPA, DATA_SIZE, hva, gmem_fd, 0);
+	TEST_ASSERT(!r, "KVM_SET_USER_MEMORY_REGION2 failed: %d errno %d", r, errno);
+	virt_map(vm, DATA_GPA, DATA_GPA, 1);
+
+	/* Seed the page from the host before the guest ever touches it. */
+	*(volatile uint64_t *)hva = MAGIC;
+
+	/* 1) Make the page read-only for the guest. */
+	req = (struct gmem_provider_readonly){ .offset = 0, .len = 4096, .readonly = 1 };
+	r = ioctl(prov_fd, GMEM_PROVIDER_SET_READONLY, &req);
+	TEST_ASSERT(!r, "set readonly ioctl failed, errno %d", errno);
+
+	/* 2) Guest read must still work and see the host's value. */
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC, "expected UCALL_SYNC");
+	TEST_ASSERT(uc.args[1] == MAGIC, "guest read 0x%lx, want MAGIC",
+		    (unsigned long)uc.args[1]);
+	pr_info("read-only: guest read 0x%llx\n", MAGIC);
+
+	/* 3) Guest write must exit to userspace, not land. */
+	r = _vcpu_run(vcpu);
+	TEST_ASSERT(r == -1 && errno == EFAULT &&
+		    vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT,
+		    "read-only write: expected KVM_EXIT_MEMORY_FAULT (r=%d errno=%d exit_reason=%u %s)",
+		    r, errno, vcpu->run->exit_reason,
+		    exit_reason_str(vcpu->run->exit_reason));
+	TEST_ASSERT(*(volatile uint64_t *)hva == MAGIC,
+		    "guest write landed on a read-only page: host sees 0x%lx",
+		    (unsigned long)*(volatile uint64_t *)hva);
+	pr_info("read-only: guest write exited with KVM_EXIT_MEMORY_FAULT, page unchanged\n");
+
+	/* 4) Make it writable again; the retried write must complete. */
+	req.readonly = 0;
+	r = ioctl(prov_fd, GMEM_PROVIDER_SET_READONLY, &req);
+	TEST_ASSERT(!r, "clear readonly ioctl failed, errno %d", errno);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC, "expected UCALL_SYNC after clear");
+	TEST_ASSERT(uc.args[1] == MAGIC2, "after clear guest read 0x%lx, want MAGIC2",
+		    (unsigned long)uc.args[1]);
+	TEST_ASSERT(*(volatile uint64_t *)hva == MAGIC2,
+		    "host sees 0x%lx after guest write, want MAGIC2",
+		    (unsigned long)*(volatile uint64_t *)hva);
+	pr_info("writable: guest write 0x%llx landed -- read-only path works\n", MAGIC2);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE, "expected UCALL_DONE");
+
+	kvm_vm_free(vm);
+	munmap(hva, DATA_SIZE);
+	close(gmem_fd);
+	close(dmabuf_fd);
+	close(prov_fd);
+	close(gmem_ctl);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_revoke_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_revoke_test.c
index 415972aa8a7e..df2e9fbd91d8 100644
--- a/tools/testing/selftests/kvm/x86/gmem_provider_revoke_test.c
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_revoke_test.c
@@ -38,9 +38,19 @@ struct gmem_provider_present {
 	__u32 pad;
 };
 #define GMEM_PROVIDER_SETUP		_IOW('G', 1, struct gmem_provider_setup)
+#define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
 #define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
 #define GMEM_PROVIDER_SET_PRESENT	_IOW('G', 2, struct gmem_provider_present)
 
+/* The dma-buf for a sample-provider child: what KVM and iommufd both import. */
+static int child_dmabuf(int child_fd)
+{
+	int fd = ioctl(child_fd, GMEM_PROVIDER_GET_DMABUF);
+
+	TEST_ASSERT(fd >= 0, "GMEM_PROVIDER_GET_DMABUF errno=%d", errno);
+	return fd;
+}
+
 #define DATA_SLOT	10
 #define DATA_GPA	(1ULL << 32)
 #define DATA_SIZE	0x200000ULL		/* 2 MiB region */
@@ -64,7 +74,8 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	int gmem_ctl, gmem_fd, r;
+	int gmem_ctl, gmem_fd, dmabuf_fd, r;
+	int prov_fd;
 	void *hva;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
@@ -77,10 +88,19 @@ int main(void)
 
 	setup.kvm_fd = vm->fd;
 	setup.size = DATA_SIZE;
-	gmem_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
-	TEST_ASSERT(gmem_fd >= 0, "GMEM_PROVIDER_SETUP failed, errno %d", errno);
+	prov_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(prov_fd >= 0, "GMEM_PROVIDER_SETUP failed, errno %d", errno);
+
+	/*
+	 * The provider fd is not a guest_memfd; it is the provider fd.  The
+	 * guest_memfd KVM returns is what the memslot binds, what the host
+	 * mmaps (through the provider's mmap), and what iommufd would map.
+	 */
+	dmabuf_fd = child_dmabuf(prov_fd);
+	gmem_fd = vm_create_guest_memfd_dmabuf(vm, DATA_SIZE,
+					       GUEST_MEMFD_FLAG_MMAP, dmabuf_fd);
 
-	hva = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, gmem_fd, 0);
+	hva = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, prov_fd, 0);
 	TEST_ASSERT(hva != MAP_FAILED,
 		    "mmap(provider) failed, errno %d", errno);
 
@@ -98,7 +118,7 @@ int main(void)
 
 	/* 2) Revoke: mark absent and zap the guest NPT (provider->KVM). */
 	req = (struct gmem_provider_present){ .offset = 0, .len = 4096, .present = 0 };
-	r = ioctl(gmem_fd, GMEM_PROVIDER_SET_PRESENT, &req);
+	r = ioctl(prov_fd, GMEM_PROVIDER_SET_PRESENT, &req);
 	TEST_ASSERT(!r, "revoke ioctl failed, errno %d", errno);
 
 	/* 3) Guest re-reads -> re-fault into absent get_pfn -> must NOT see MAGIC. */
@@ -117,7 +137,7 @@ int main(void)
 
 	/* 4) Restore: mark present again. */
 	req.present = 1;
-	r = ioctl(gmem_fd, GMEM_PROVIDER_SET_PRESENT, &req);
+	r = ioctl(prov_fd, GMEM_PROVIDER_SET_PRESENT, &req);
 	TEST_ASSERT(!r, "restore ioctl failed, errno %d", errno);
 
 	/* 5) Re-enter: the fault re-maps via get_pfn, guest reads MAGIC again. */
@@ -130,6 +150,8 @@ int main(void)
 	kvm_vm_free(vm);
 	munmap(hva, DATA_SIZE);
 	close(gmem_fd);
+	close(dmabuf_fd);
+	close(prov_fd);
 	close(gmem_ctl);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_test.c
index d7caa11616df..d926b2033843 100644
--- a/tools/testing/selftests/kvm/x86/gmem_provider_test.c
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_test.c
@@ -1,195 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
-/*
- * gmem_provider_test - exercise the samples/kvm gmem_provider module through a
- * full SEV-SNP guest launch, then re-bind the same provider fd to a second VM
- * (the live-update path).
- *
- * The provider module must be loaded first, in either mode:
- *   insmod gmem_provider.ko addr=0x5D40000000 len=0x1000000   # page-less
- *   insmod gmem_provider.ko                                   # CMA fallback
- *
- * The test skips (KSFT_SKIP) if /dev/gmem_provider or SNP support is absent.
- *
- * Note: with the current kvm_gmem_populate() ABI the launch source is an
- * ordinary anonymous buffer (pinned via get_user_pages_fast); the provider's
- * populate() copies it into the backing.  No /dev/mem mapping is needed.
- */
+/* CoCo support for dma-buf-backed guest_memfd is outside this series. */
 #include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/ioctl.h>
-#include <sys/mman.h>
-#include <stdint.h>
-#include <linux/kvm.h>
-#include <asm/kvm.h>
 
-/* Mirrors samples/kvm/gmem_provider.h */
-struct gmem_provider_setup {
-	int32_t kvm_fd;
-	uint32_t pad;
-	uint64_t size;
-};
-#define GMEM_PROVIDER_SETUP _IOW('G', 1, struct gmem_provider_setup)
-
-#define KSFT_PASS 0
-#define KSFT_FAIL 1
 #define KSFT_SKIP 4
 
-#define GUEST_MEM_SIZE	(16UL * 1024 * 1024)
-#define PAGE_SIZE_4K	4096UL
-
-static int sev_ioctl(int vm_fd, int sev_fd, int cmd, void *data)
-{
-	struct kvm_sev_cmd sev_cmd = {
-		.id = cmd,
-		.data = (uint64_t)(unsigned long)data,
-		.sev_fd = sev_fd,
-	};
-	return ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &sev_cmd);
-}
-
-static int launch_snp_vm(int kvm_fd, int gmem_fd, void *src, int vm_num)
-{
-	int vm_fd, vcpu_fd, sev_fd, ret;
-
-	printf("[VM%d] KVM_CREATE_VM (SNP)\n", vm_num);
-	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, KVM_X86_SNP_VM);
-	if (vm_fd < 0) { perror("KVM_CREATE_VM"); return -1; }
-
-	sev_fd = open("/dev/sev", O_RDWR);
-	if (sev_fd < 0) { perror("open /dev/sev"); close(vm_fd); return -1; }
-
-	struct kvm_sev_init init = { 0 };
-	ret = sev_ioctl(vm_fd, sev_fd, KVM_SEV_INIT2, &init);
-	if (ret) { perror("KVM_SEV_INIT2"); goto out; }
-
-	struct kvm_userspace_memory_region2 region = {
-		.slot = 0,
-		.flags = KVM_MEM_GUEST_MEMFD,
-		.guest_phys_addr = 0,
-		.memory_size = GUEST_MEM_SIZE,
-		.userspace_addr = (uint64_t)(unsigned long)src,
-		.guest_memfd = gmem_fd,
-		.guest_memfd_offset = 0,
-	};
-	ret = ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION2, &region);
-	if (ret) { perror("KVM_SET_USER_MEMORY_REGION2"); goto out; }
-
-	struct kvm_memory_attributes attrs = {
-		.address = 0,
-		.size = GUEST_MEM_SIZE,
-		.attributes = KVM_MEMORY_ATTRIBUTE_PRIVATE,
-	};
-	ret = ioctl(vm_fd, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
-	if (ret) { perror("KVM_SET_MEMORY_ATTRIBUTES"); goto out; }
-
-	struct kvm_sev_snp_launch_start start = { .policy = 0x30000 };
-	ret = sev_ioctl(vm_fd, sev_fd, KVM_SEV_SNP_LAUNCH_START, &start);
-	if (ret) { perror("SNP_LAUNCH_START"); goto out; }
-
-	printf("[VM%d] SNP_LAUNCH_UPDATE (code + zero, %luMB)\n",
-	       vm_num, GUEST_MEM_SIZE >> 20);
-	struct kvm_sev_snp_launch_update update = {
-		.gfn_start = 0,
-		.uaddr = (uint64_t)(unsigned long)src,
-		.len = PAGE_SIZE_4K,
-		.type = KVM_SEV_SNP_PAGE_TYPE_NORMAL,
-	};
-	ret = sev_ioctl(vm_fd, sev_fd, KVM_SEV_SNP_LAUNCH_UPDATE, &update);
-	if (ret) { perror("SNP_LAUNCH_UPDATE code"); goto out; }
-
-	struct kvm_sev_snp_launch_update update_zero = {
-		.gfn_start = 1,
-		.uaddr = (uint64_t)(unsigned long)(src + PAGE_SIZE_4K),
-		.len = GUEST_MEM_SIZE - PAGE_SIZE_4K,
-		.type = KVM_SEV_SNP_PAGE_TYPE_ZERO,
-	};
-	ret = sev_ioctl(vm_fd, sev_fd, KVM_SEV_SNP_LAUNCH_UPDATE, &update_zero);
-	if (ret) { perror("SNP_LAUNCH_UPDATE zero"); goto out; }
-
-	struct kvm_sev_snp_launch_finish finish = { 0 };
-	ret = sev_ioctl(vm_fd, sev_fd, KVM_SEV_SNP_LAUNCH_FINISH, &finish);
-	if (ret) { perror("SNP_LAUNCH_FINISH"); goto out; }
-
-	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
-	if (vcpu_fd < 0) { perror("KVM_CREATE_VCPU"); ret = -1; goto out; }
-
-	printf("[VM%d] *** launch succeeded ***\n", vm_num);
-	close(vcpu_fd);
-	ret = 0;
-out:
-	close(sev_fd);
-	close(vm_fd);
-	return ret;
-}
-
 int main(void)
 {
-	int kvm_fd, gmem_ctl_fd, gmem_fd, tmp_vm;
-	void *src;
-
-	setbuf(stdout, NULL);
-
-	kvm_fd = open("/dev/kvm", O_RDWR);
-	if (kvm_fd < 0) {
-		printf("SKIP: cannot open /dev/kvm (%s)\n", strerror(errno));
-		return KSFT_SKIP;
-	}
-
-	gmem_ctl_fd = open("/dev/gmem_provider", O_RDWR);
-	if (gmem_ctl_fd < 0) {
-		printf("SKIP: /dev/gmem_provider not present -- load gmem_provider.ko (%s)\n",
-		       strerror(errno));
-		return KSFT_SKIP;
-	}
-
-	/* Provider setup needs a VM fd; ownership transfers to each VM on bind. */
-	tmp_vm = ioctl(kvm_fd, KVM_CREATE_VM, KVM_X86_SNP_VM);
-	if (tmp_vm < 0) {
-		printf("SKIP: cannot create SNP VM -- host not SNP-capable? (%s)\n",
-		       strerror(errno));
-		return KSFT_SKIP;
-	}
-
-	struct gmem_provider_setup setup = {
-		.kvm_fd = tmp_vm,
-		.size = GUEST_MEM_SIZE,
-	};
-	gmem_fd = ioctl(gmem_ctl_fd, GMEM_PROVIDER_SETUP, &setup);
-	if (gmem_fd < 0) {
-		perror("GMEM_PROVIDER_SETUP");
-		return KSFT_FAIL;
-	}
-	close(tmp_vm);
-	printf("provider gmem_fd = %d (persists across VMs)\n", gmem_fd);
-
-	/* Launch source: ordinary anonymous memory holding a HLT at gfn 0. */
-	src = mmap(NULL, GUEST_MEM_SIZE, PROT_READ | PROT_WRITE,
-		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (src == MAP_FAILED) { perror("mmap src"); return KSFT_FAIL; }
-	memset(src, 0, GUEST_MEM_SIZE);
-	((uint8_t *)src)[0] = 0xf4; /* HLT */
-
-	if (launch_snp_vm(kvm_fd, gmem_fd, src, 1) != 0) {
-		printf("FAIL: VM1 launch failed\n");
-		return KSFT_FAIL;
-	}
-
-	usleep(100000);
-
-	/* Re-bind the SAME provider fd to a fresh VM (live-update path). */
-	if (launch_snp_vm(kvm_fd, gmem_fd, src, 2) != 0) {
-		printf("FAIL: VM2 re-bind launch failed\n");
-		return KSFT_FAIL;
-	}
-
-	printf("PASS: page-less/provider-backed SNP launch + re-bind succeeded\n");
-	munmap(src, GUEST_MEM_SIZE);
-	close(gmem_fd);
-	close(gmem_ctl_fd);
-	close(kvm_fd);
-	return KSFT_PASS;
+	puts("SKIP: dma-buf-backed CoCo is outside this series");
+	return KSFT_SKIP;
 }
diff --git a/tools/testing/selftests/kvm/x86/gmem_provider_vfio_test.c b/tools/testing/selftests/kvm/x86/gmem_provider_vfio_test.c
index 97a66a295b14..7f3c640aea78 100644
--- a/tools/testing/selftests/kvm/x86/gmem_provider_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/gmem_provider_vfio_test.c
@@ -5,7 +5,7 @@
  *
  * Steps:
  *   1. SETUP provider (KVM VM shape not required for this test).
- *   2. iommufd IOAS + GET_DMABUF + IOMMU_IOAS_MAP_FILE - IOAS holds the
+ *   2. guest_memfd from the provider fd; IOMMU_IOAS_MAP_FILE on its dma-buf - IOAS holds the
  *      provider region.
  *   3. Open a vfio-pci cdev (default /dev/vfio/devices/vfio0, overridable
  *      via GMEM_VFIO_CDEV env), VFIO_DEVICE_BIND_IOMMUFD, then
@@ -39,8 +39,17 @@ struct gmem_provider_setup {
 	__u64 size;
 };
 #define GMEM_PROVIDER_SETUP		_IOW('G', 1, struct gmem_provider_setup)
-#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
 #define GMEM_PROVIDER_GET_DMABUF	_IO('G', 3)
+#define GMEM_PROVIDER_FLAG_MMAP_CAPABLE	(1u << 0)
+
+/* The dma-buf for a sample-provider child: what KVM and iommufd both import. */
+static int child_dmabuf(int child_fd)
+{
+	int fd = ioctl(child_fd, GMEM_PROVIDER_GET_DMABUF);
+
+	TEST_ASSERT(fd >= 0, "GMEM_PROVIDER_GET_DMABUF errno=%d", errno);
+	return fd;
+}
 
 #define DATA_SIZE	0x200000ULL
 #define IOVA_BASE	(1ULL << 34)
@@ -53,7 +62,7 @@ int main(void)
 	struct vfio_device_bind_iommufd bind = {};
 	struct vfio_device_attach_iommufd_pt att = {};
 	const char *cdev_path;
-	int gmem_ctl, gmem_fd, dmabuf_fd, iommufd_fd, vfio_fd, r;
+	int gmem_ctl, gmem_fd, dmabuf_fd, prov_fd, vm_fd = -1, iommufd_fd, vfio_fd, r;
 
 	gmem_ctl = open("/dev/gmem_provider", O_RDWR);
 	__TEST_REQUIRE(gmem_ctl >= 0, "gmem_provider module not loaded");
@@ -80,20 +89,34 @@ int main(void)
 		vm = ioctl(kvm, KVM_CREATE_VM, 0);
 		TEST_ASSERT(vm >= 0, "KVM_CREATE_VM errno=%d", errno);
 		setup.kvm_fd = vm;
+		vm_fd = vm;
 		close(kvm);
 	}
 	setup.size = DATA_SIZE;
-	gmem_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
-	TEST_ASSERT(gmem_fd >= 0, "GMEM_PROVIDER_SETUP errno=%d", errno);
+	prov_fd = ioctl(gmem_ctl, GMEM_PROVIDER_SETUP, &setup);
+	TEST_ASSERT(prov_fd >= 0, "GMEM_PROVIDER_SETUP errno=%d", errno);
+
+	/*
+	 * The provider fd is the provider fd of a guest_memfd, and iommufd maps
+	 * the dma-buf; a device and a guest import the same one.
+	 */
+	{
+		struct kvm_create_guest_memfd cgm;
+
+		dmabuf_fd = child_dmabuf(prov_fd);
+		cgm = (struct kvm_create_guest_memfd) {
+			.size = DATA_SIZE,
+			.flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_USE_DMABUF,
+			.dmabuf_fd = dmabuf_fd,
+		};
+		gmem_fd = ioctl(vm_fd, KVM_CREATE_GUEST_MEMFD, &cgm);
+		TEST_ASSERT(gmem_fd >= 0, "KVM_CREATE_GUEST_MEMFD(dmabuf) errno=%d", errno);
+	}
 
-	/* IOAS + provider dma-buf */
+	/* IOAS + the same dma-buf KVM imported. */
 	alloc.size = sizeof(alloc);
 	r = ioctl(iommufd_fd, IOMMU_IOAS_ALLOC, &alloc);
 	TEST_ASSERT(!r, "IOMMU_IOAS_ALLOC errno=%d", errno);
-
-	dmabuf_fd = ioctl(gmem_fd, GMEM_PROVIDER_GET_DMABUF);
-	TEST_ASSERT(dmabuf_fd >= 0, "GET_DMABUF errno=%d", errno);
-
 	map.size = sizeof(map);
 	map.flags = IOMMU_IOAS_MAP_FIXED_IOVA |
 		    IOMMU_IOAS_MAP_READABLE | IOMMU_IOAS_MAP_WRITEABLE;
@@ -126,8 +149,8 @@ int main(void)
 	pr_info("real passthrough device now has IOMMU domain covering provider region\n");
 
 	close(vfio_fd);
-	close(dmabuf_fd);
 	close(iommufd_fd);
+	close(dmabuf_fd);
 	close(gmem_fd);
 	close(gmem_ctl);
 	return 0;
-- 
2.47.3

