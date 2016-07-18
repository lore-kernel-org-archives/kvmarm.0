From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 4/7] ARM: update MPIDR accessors macro
Date: Mon, 18 Jul 2016 11:48:16 +0100
Message-ID: <1468838899-34909-5-git-send-email-vladimir.murzin@arm.com>
References: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D6F49B66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FXIDtYSP2jIN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 06:42:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F278249B44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:40 -0400 (EDT)
In-Reply-To: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

vgic-v3 driver queries CPU affinity level up to Aff3, which is valid
for arm64.  However, for arm up to Aff2 levels are supported, thus,
report zero for any affinity level above 2.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/cputype.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index 1ee94c7..96cef49 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -55,9 +55,10 @@
 
 #define MPIDR_LEVEL_BITS 8
 #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
+#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
 
 #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
-	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
+	((level < 3) ? ((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK) : 0)
 
 #define ARM_CPU_IMP_ARM			0x41
 #define ARM_CPU_IMP_INTEL		0x69
-- 
1.7.9.5
