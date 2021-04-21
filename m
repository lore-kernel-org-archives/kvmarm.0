Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C49C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 06:51:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3EDB61426
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 06:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3EDB61426
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 991B74B4CD;
	Wed, 21 Apr 2021 02:51:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tw9kQQ7P-is1; Wed, 21 Apr 2021 02:51:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA204B47D;
	Wed, 21 Apr 2021 02:51:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AAA04B4B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 02:51:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AMmmEKQwqonA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 02:51:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C83F84B4E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 02:51:25 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FBC06140A;
 Wed, 21 Apr 2021 06:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618987884;
 bh=WwPLwPVXamxGwz3XnxJZtbBgxUcm37L12EyoniuS4KM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fOyCWkASnw1cT4yIyK5E/Ie+9mJ0k4Y1CXnRzLtLADjL5dR/fX7BJVX2rEFOxOJzQ
 jJO1BV/mQQmw5Ico/y4eXm2B3yyF1RQzkBl0dBvMxUxFCVn9iVIkvuC9ugxOvrM9yi
 0VYsP/ofqFvRKKuOxRT/1oGTQNZ4R1j7bWCZlgh5sVgjXdhks+CXeZvW1c4y+swoQY
 aWoCJqV1ekaAyw2MWELumlWzRxIGJdjI5rzsEYJdeqQ2ez5jxv6WSprlV9paYPPsrk
 O+elVH3rvOLYX6rMlPW01AKQByKQwDhYvaopSURQltkx+DaRRNS/YVFMZ33yexO7/7
 XubR/UpdOQ73A==
From: Mike Rapoport <rppt@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/4] memblock: update initialization of reserved pages
Date: Wed, 21 Apr 2021 09:51:06 +0300
Message-Id: <20210421065108.1987-3-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210421065108.1987-1-rppt@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
MIME-Version: 1.0
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
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

From: Mike Rapoport <rppt@linux.ibm.com>

The struct pages representing a reserved memory region are initialized
using reserve_bootmem_range() function. This function is called for each
reserved region just before the memory is freed from memblock to the buddy
page allocator.

The struct pages for MEMBLOCK_NOMAP regions are kept with the default
values set by the memory map initialization which makes it necessary to
have a special treatment for such pages in pfn_valid() and
pfn_valid_within().

Split out initialization of the reserved pages to a function with a
meaningful name and treat the MEMBLOCK_NOMAP regions the same way as the
reserved regions and mark struct pages for the NOMAP regions as
PageReserved.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 include/linux/memblock.h |  4 +++-
 mm/memblock.c            | 28 ++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5984fff3f175..634c1a578db8 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -30,7 +30,9 @@ extern unsigned long long max_possible_pfn;
  * @MEMBLOCK_NONE: no special request
  * @MEMBLOCK_HOTPLUG: hotpluggable region
  * @MEMBLOCK_MIRROR: mirrored region
- * @MEMBLOCK_NOMAP: don't add to kernel direct mapping
+ * @MEMBLOCK_NOMAP: don't add to kernel direct mapping and treat as
+ * reserved in the memory map; refer to memblock_mark_nomap() description
+ * for futher details
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
diff --git a/mm/memblock.c b/mm/memblock.c
index afaefa8fc6ab..3abf2c3fea7f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -906,6 +906,11 @@ int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
+ * The memory regions marked with %MEMBLOCK_NOMAP will not be added to the
+ * direct mapping of the physical memory. These regions will still be
+ * covered by the memory map. The struct page representing NOMAP memory
+ * frames in the memory map will be PageReserved()
+ *
  * Return: 0 on success, -errno on failure.
  */
 int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
@@ -2002,6 +2007,26 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 	return end_pfn - start_pfn;
 }
 
+static void __init memmap_init_reserved_pages(void)
+{
+	struct memblock_region *region;
+	phys_addr_t start, end;
+	u64 i;
+
+	/* initialize struct pages for the reserved regions */
+	for_each_reserved_mem_range(i, &start, &end)
+		reserve_bootmem_region(start, end);
+
+	/* and also treat struct pages for the NOMAP regions as PageReserved */
+	for_each_mem_region(region) {
+		if (memblock_is_nomap(region)) {
+			start = region->base;
+			end = start + region->size;
+			reserve_bootmem_region(start, end);
+		}
+	}
+}
+
 static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
@@ -2010,8 +2035,7 @@ static unsigned long __init free_low_memory_core_early(void)
 
 	memblock_clear_hotplug(0, -1);
 
-	for_each_reserved_mem_range(i, &start, &end)
-		reserve_bootmem_region(start, end);
+	memmap_init_reserved_pages();
 
 	/*
 	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
