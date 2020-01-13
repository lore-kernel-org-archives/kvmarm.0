Return-Path: <SRS0=vgt5=3C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77831C33CAD
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 13:00:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 059DB207FF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 13:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ctTghAM/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 059DB207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C1A4AF0F;
	Mon, 13 Jan 2020 08:00:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ukAIut11cUfV; Mon, 13 Jan 2020 08:00:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DAB54AF01;
	Mon, 13 Jan 2020 08:00:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7928F4AEFC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 08:00:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7rTyYUdqhroK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jan 2020 08:00:52 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB704AEFB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 08:00:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578920452;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OwXlzBEQhwCa8wParpIDpsxijVGaBsk9N2BIUCVw5x0=;
 b=ctTghAM/hfah30ZLKEw2+hmIllJ6abAAsGGgyLYrMQQX6Uq890noNeUhxMltMLxp9JlIKP
 gaty78T6KAhx8Gvoau3OCj8SiwYejQbT75dMEOCVCkRViP5C2NfQy5Fh1gRVw1JG2AzEzo
 zStnxf+6w00D7N/bncIfZdwOoFC0Ny4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-SUHtmpXOOaWK3twCgs47zQ-1; Mon, 13 Jan 2020 08:00:48 -0500
X-MC-Unique: SUHtmpXOOaWK3twCgs47zQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4271218A6EC9;
 Mon, 13 Jan 2020 13:00:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0D30C6A846;
 Mon, 13 Jan 2020 13:00:45 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests 1/3] arm/arm64: Improve memory region management
Date: Mon, 13 Jan 2020 14:00:41 +0100
Message-Id: <20200113130043.30851-2-drjones@redhat.com>
In-Reply-To: <20200113130043.30851-1-drjones@redhat.com>
References: <20200113130043.30851-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add expected I/O regions and provide a way to check memory region
properties of a physical address. We also bump the initial number
of regions and even prepare for a unit test to reallocate for
growth if necessary.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/setup.h |  8 +++++--
 lib/arm/mmu.c       | 24 ++++++-------------
 lib/arm/setup.c     | 56 +++++++++++++++++++++++++++++++++------------
 3 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 81cac019b1d1..c8afb2493f8d 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -13,16 +13,20 @@
 extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
 extern int nr_cpus;
 
-#define NR_MEM_REGIONS		8
 #define MR_F_PRIMARY		(1U << 0)
+#define MR_F_IO			(1U << 1)
+#define MR_F_UNKNOWN		(1U << 31)
+
 struct mem_region {
 	phys_addr_t start;
 	phys_addr_t end;
 	unsigned int flags;
 };
-extern struct mem_region mem_regions[NR_MEM_REGIONS];
+extern struct mem_region *mem_regions;
 extern phys_addr_t __phys_offset, __phys_end;
 
+extern unsigned int mem_region_get_flags(phys_addr_t paddr);
+
 #define PHYS_OFFSET		(__phys_offset)
 #define PHYS_END		(__phys_end)
 
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 5fb56180d334..540a1e842d5b 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -152,6 +152,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 void *setup_mmu(phys_addr_t phys_end)
 {
 	uintptr_t code_end = (uintptr_t)&etext;
+	struct mem_region *r;
 
 	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
 	if (phys_end > (3ul << 30))
@@ -163,23 +164,12 @@ void *setup_mmu(phys_addr_t phys_end)
 
 	mmu_idmap = alloc_page();
 
-	/*
-	 * mach-virt I/O regions:
-	 *   - The first 1G (arm/arm64)
-	 *   - 512M at 256G (arm64, arm uses highmem=off)
-	 *   - 512G at 512G (arm64, arm uses highmem=off)
-	 */
-	mmu_set_range_sect(mmu_idmap,
-		0, 0, (1ul << 30),
-		__pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-#ifdef __aarch64__
-	mmu_set_range_sect(mmu_idmap,
-		(1ul << 38), (1ul << 38), (1ul << 38) | (1ul << 29),
-		__pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-	mmu_set_range_sect(mmu_idmap,
-		(1ul << 39), (1ul << 39), (1ul << 40),
-		__pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-#endif
+	for (r = mem_regions; r->end; ++r) {
+		if (!(r->flags & MR_F_IO))
+			continue;
+		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
+				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
+	}
 
 	/* armv8 requires code shared between EL1 and EL0 to be read-only */
 	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 4f02fca85607..385e135f4865 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -24,6 +24,8 @@
 
 #include "io.h"
 
+#define NR_INITIAL_MEM_REGIONS 16
+
 extern unsigned long stacktop;
 
 char *initrd;
@@ -32,7 +34,8 @@ u32 initrd_size;
 u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (u64)~0 };
 int nr_cpus;
 
-struct mem_region mem_regions[NR_MEM_REGIONS];
+static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
+struct mem_region *mem_regions = __initial_mem_regions;
 phys_addr_t __phys_offset, __phys_end;
 
 int mpidr_to_cpu(uint64_t mpidr)
@@ -65,41 +68,66 @@ static void cpu_init(void)
 	set_cpu_online(0, true);
 }
 
+unsigned int mem_region_get_flags(phys_addr_t paddr)
+{
+	struct mem_region *r;
+
+	for (r = mem_regions; r->end; ++r) {
+		if (paddr >= r->start && paddr < r->end)
+			return r->flags;
+	}
+
+	return MR_F_UNKNOWN;
+}
+
 static void mem_init(phys_addr_t freemem_start)
 {
-	struct dt_pbus_reg regs[NR_MEM_REGIONS];
+	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
 	struct mem_region primary, mem = {
 		.start = (phys_addr_t)-1,
 	};
 	phys_addr_t base, top;
-	int nr_regs, i;
+	int nr_regs, nr_io = 0, i;
 
-	nr_regs = dt_get_memory_params(regs, NR_MEM_REGIONS);
+	/*
+	 * mach-virt I/O regions:
+	 *   - The first 1G (arm/arm64)
+	 *   - 512M at 256G (arm64, arm uses highmem=off)
+	 *   - 512G at 512G (arm64, arm uses highmem=off)
+	 */
+	mem_regions[nr_io++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
+#ifdef __aarch64__
+	mem_regions[nr_io++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
+	mem_regions[nr_io++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
+#endif
+
+	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
 	assert(nr_regs > 0);
 
 	primary = (struct mem_region){ 0 };
 
 	for (i = 0; i < nr_regs; ++i) {
-		mem_regions[i].start = regs[i].addr;
-		mem_regions[i].end = regs[i].addr + regs[i].size;
+		struct mem_region *r = &mem_regions[nr_io + i];
+
+		r->start = regs[i].addr;
+		r->end = regs[i].addr + regs[i].size;
 
 		/*
 		 * pick the region we're in for our primary region
 		 */
-		if (freemem_start >= mem_regions[i].start
-				&& freemem_start < mem_regions[i].end) {
-			mem_regions[i].flags |= MR_F_PRIMARY;
-			primary = mem_regions[i];
+		if (freemem_start >= r->start && freemem_start < r->end) {
+			r->flags |= MR_F_PRIMARY;
+			primary = *r;
 		}
 
 		/*
 		 * set the lowest and highest addresses found,
 		 * ignoring potential gaps
 		 */
-		if (mem_regions[i].start < mem.start)
-			mem.start = mem_regions[i].start;
-		if (mem_regions[i].end > mem.end)
-			mem.end = mem_regions[i].end;
+		if (r->start < mem.start)
+			mem.start = r->start;
+		if (r->end > mem.end)
+			mem.end = r->end;
 	}
 	assert(primary.end != 0);
 	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
-- 
2.21.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
