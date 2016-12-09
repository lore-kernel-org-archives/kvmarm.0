From: Caraman Mihai Claudiu-B02008 <mike.caraman@nxp.com>
Subject: [RFC] arm64: KVM: Honor guest device memory type mappings
Date: Fri, 9 Dec 2016 22:59:24 +0200
Message-ID: <1481317164-2511-1-git-send-email-mike.caraman@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F30B44022C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 16:00:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j8-DOy+gQ8fy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2016 16:00:15 -0500 (EST)
Received: from NAM03-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam03on0081.outbound.protection.outlook.com [104.47.42.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D39D40430
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 16:00:15 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: david.lapp@nxp.com, roy.pledge@nxp.com, stuart.yoder@nxp.com, Mihai Caraman <mike.caraman@nxp.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mihai Caraman <mike.caraman@nxp.com>

Stage 2 non-Gathering and non-Reordering memory attributes have precedence over stage 1
Gathering and Reordering attributes. Honor guest device memory type mappings using GRE
memory type at stage 2.

This is a preamble for a bigger change that will honor guest normal memory mappings for
targets connected to HN-F interfaces.

Signed-off-by: Mihai Caraman <mike.caraman@nxp.com>
---
 arch/arm64/include/asm/memory.h       | 2 +-
 arch/arm64/include/asm/pgtable-prot.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b71086d..d4834ba 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -134,7 +134,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
-#define MT_S2_DEVICE_nGnRE	0x1
+#define MT_S2_DEVICE_GRE	0x3
 
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 2142c77..11b43f7 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -61,7 +61,7 @@
 #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
 
 #define PAGE_S2			__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
-#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_UXN)
+#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_GRE) | PTE_S2_RDONLY | PTE_UXN)
 
 #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_PXN | PTE_UXN)
 #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
-- 
1.9.3
