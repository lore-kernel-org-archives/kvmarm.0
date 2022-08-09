Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CCBC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CC94CA99;
	Tue,  9 Aug 2022 05:15:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sQHoxmlIoiMZ; Tue,  9 Aug 2022 05:15:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B07164C9DF;
	Tue,  9 Aug 2022 05:15:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52BC54C491
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XTja9Sajad1m for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C4EC4C411
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CBE0ED1;
 Tue,  9 Aug 2022 02:15:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 683073F67D;
 Tue,  9 Aug 2022 02:15:31 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 04/19] powerpc: Use the page allocator
Date: Tue,  9 Aug 2022 10:15:43 +0100
Message-Id: <20220809091558.14379-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: Laurent Vivier <lvivier@redhat.com>, kvm-ppc@vger.kernel.org
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

The spapr_hcall test makes two page sized allocations using the physical
allocator. Initialize the page allocator and use alloc_page() directly.

CC: Laurent Vivier <lvivier@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
CC: kvm-ppc@vger.kernel.org
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/powerpc/setup.c     | 8 ++++++++
 powerpc/Makefile.common | 1 +
 powerpc/spapr_hcall.c   | 5 +++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 1be4c030012b..bb39711af31c 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -15,6 +15,7 @@
 #include <devicetree.h>
 #include <alloc.h>
 #include <alloc_phys.h>
+#include <alloc_page.h>
 #include <argv.h>
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -111,6 +112,7 @@ static void mem_init(phys_addr_t freemem_start)
 	struct mem_region primary, mem = {
 		.start = (phys_addr_t)-1,
 	};
+	phys_addr_t base, top;
 	int nr_regs, i;
 
 	nr_regs = dt_get_memory_params(regs, NR_MEM_REGIONS);
@@ -149,6 +151,12 @@ static void mem_init(phys_addr_t freemem_start)
 	phys_alloc_init(freemem_start, primary.end - freemem_start);
 	phys_alloc_set_minimum_alignment(__icache_bytes > __dcache_bytes
 					 ? __icache_bytes : __dcache_bytes);
+
+	phys_alloc_get_unused(&base, &top);
+	base = PAGE_ALIGN(base);
+	top = top & PAGE_MASK;
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
+	page_alloc_ops_enable();
 }
 
 void setup(const void *fdt)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 12c280c15fff..260946844998 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -34,6 +34,7 @@ include $(SRCDIR)/scripts/asm-offsets.mak
 cflatobjs += lib/util.o
 cflatobjs += lib/getchar.o
 cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/alloc_page.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/powerpc/io.o
diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
index 823a574a4724..1a2015474b1c 100644
--- a/powerpc/spapr_hcall.c
+++ b/powerpc/spapr_hcall.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <util.h>
 #include <alloc.h>
+#include <alloc_page.h>
 #include <asm/hcall.h>
 
 #define PAGE_SIZE 4096
@@ -65,8 +66,8 @@ static void test_h_page_init(int argc, char **argv)
 	if (argc > 1)
 		report_abort("Unsupported argument: '%s'", argv[1]);
 
-	dst = memalign(PAGE_SIZE, PAGE_SIZE);
-	src = memalign(PAGE_SIZE, PAGE_SIZE);
+	dst = alloc_page();
+	src = alloc_page();
 	if (!dst || !src)
 		report_abort("Failed to alloc memory");
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
