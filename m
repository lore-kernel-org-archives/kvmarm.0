From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 04/12] arm64: Initialise high_memory global variable earlier
Date: Mon,  4 Dec 2017 14:13:05 +0000
Message-ID: <20171204141313.31604-5-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B12C49D32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jdApK9SWKw9I for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8981C49D80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:30 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The high_memory global variable is used by
cma_declare_contiguous(.) before it is defined.

We don't notice this as we compute __pa(high_memory - 1), and it looks
like we're processing a VA from the direct linear map.

This problem becomes apparent when we flip the kernel virtual address
space and the linear map is moved to the bottom of the kernel VA space.

This patch moves the initialisation of high_memory before it used.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/mm/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5960bef0170d..00e7b900ca41 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -476,6 +476,8 @@ void __init arm64_memblock_init(void)
 
 	reserve_elfcorehdr();
 
+	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
+
 	dma_contiguous_reserve(arm64_dma_phys_limit);
 
 	memblock_allow_resize();
@@ -502,7 +504,6 @@ void __init bootmem_init(void)
 	sparse_init();
 	zone_sizes_init(min, max);
 
-	high_memory = __va((max << PAGE_SHIFT) - 1) + 1;
 	memblock_dump_all();
 }
 
-- 
2.11.0
