From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 01/19] arm64: asm-offsets: Avoid clashing DMA definitions
Date: Mon, 11 Dec 2017 14:49:19 +0000
Message-ID: <20171211144937.4537-2-marc.zyngier@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4317749D62
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4PugD65O+YPe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:46:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3464E49D6F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:23 -0500 (EST)
In-Reply-To: <20171211144937.4537-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

asm-offsets.h contains a few DMA related definitions that have
the exact same name than the enum members they are derived from.

While this is not a problem so far, it will become an issue if
both asm-offsets.h and include/linux/dma-direction.h: are pulled
by the same file.

Let's sidestep the issue by renaming the asm-offsets.h constants.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/asm-offsets.c | 6 +++---
 arch/arm64/mm/cache.S           | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 71bf088f1e4b..7e8be0c22ce0 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -87,9 +87,9 @@ int main(void)
   BLANK();
   DEFINE(PAGE_SZ,	       	PAGE_SIZE);
   BLANK();
-  DEFINE(DMA_BIDIRECTIONAL,	DMA_BIDIRECTIONAL);
-  DEFINE(DMA_TO_DEVICE,		DMA_TO_DEVICE);
-  DEFINE(DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
+  DEFINE(__DMA_BIDIRECTIONAL,	DMA_BIDIRECTIONAL);
+  DEFINE(__DMA_TO_DEVICE,	DMA_TO_DEVICE);
+  DEFINE(__DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
   BLANK();
   DEFINE(CLOCK_REALTIME,	CLOCK_REALTIME);
   DEFINE(CLOCK_MONOTONIC,	CLOCK_MONOTONIC);
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 7f1dbe962cf5..c1336be085eb 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -205,7 +205,7 @@ ENDPIPROC(__dma_flush_area)
  *	- dir	- DMA direction
  */
 ENTRY(__dma_map_area)
-	cmp	w2, #DMA_FROM_DEVICE
+	cmp	w2, #__DMA_FROM_DEVICE
 	b.eq	__dma_inv_area
 	b	__dma_clean_area
 ENDPIPROC(__dma_map_area)
@@ -217,7 +217,7 @@ ENDPIPROC(__dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(__dma_unmap_area)
-	cmp	w2, #DMA_TO_DEVICE
+	cmp	w2, #__DMA_TO_DEVICE
 	b.ne	__dma_inv_area
 	ret
 ENDPIPROC(__dma_unmap_area)
-- 
2.14.2
