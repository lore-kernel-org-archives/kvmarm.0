From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 07/10] ARM: Introduce MPIDR_LEVEL_SHIFT macro
Date: Mon, 12 Sep 2016 15:49:21 +0100
Message-ID: <1473691764-29424-8-git-send-email-vladimir.murzin@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 070B9412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 10:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MGFVTh6kCmbn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Sep 2016 10:41:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD7E49B30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2016 10:41:13 -0400 (EDT)
In-Reply-To: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

vgic-v3 driver uses architecture specific MPIDR_LEVEL_SHIFT macro to
encode the affinity in a form compatible with ICC_SGI* registers.
Unfortunately, that macro is missing on ARM, so let's add it.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/cputype.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index 1ee94c7..e2d94c1 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -55,6 +55,7 @@
 
 #define MPIDR_LEVEL_BITS 8
 #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
+#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
 
 #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
 	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
-- 
1.7.9.5
