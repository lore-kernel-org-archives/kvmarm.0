From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 15/15] arm: gic: allow 32-bit compilation
Date: Wed, 20 Jul 2016 18:04:35 +0100
Message-ID: <20160720170435.28090-16-andre.przywara@arm.com>
References: <20160720170435.28090-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFD049B78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 12:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4510XbCq4dLM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 12:58:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ADBA49B74
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 12:57:58 -0400 (EDT)
In-Reply-To: <20160720170435.28090-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GIC code is shared between ARM and arm64, though the header
files from the Linux kernel are actually different, reflecting the
different level of GIC emulation support between the two architectures.
Since it is conceivable that ARM will gain GICv3 (and possibly ITS)
emulation support too, lets conditionally define those missing
symbols in the source file until an upcoming ARM header update eventually
includes those.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 7fd0768..cd4f518 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -19,6 +19,14 @@
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
 #endif
 
+#ifndef KVM_VGIC_ITS_ADDR_TYPE
+#define KVM_VGIC_ITS_ADDR_TYPE 4
+#endif
+
+#ifndef KVM_VGIC_V3_ITS_SIZE
+#define KVM_VGIC_V3_ITS_SIZE (2 * SZ_64K)
+#endif
+
 #define IRQCHIP_GIC 0
 
 static int gic_fd = -1;
-- 
2.9.0
