From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 2/3] arm/gic: avoid GICv2m MMIO frame overlap
Date: Wed, 25 Apr 2018 11:09:44 +0100
Message-ID: <20180425100945.19171-3-andre.przywara@arm.com>
References: <20180425100945.19171-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC624070F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:01:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ki4meR0Z+P-M for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 06:00:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129C54A037
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:00:42 -0400 (EDT)
In-Reply-To: <20180425100945.19171-1-andre.przywara@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we accidentally overlap the GICv2m MMIO frame with the CPU
interface region. Fix this by moving the v2m frame below the CPUI region.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/gic.c b/arm/gic.c
index dd4d747d..238a75c7 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -224,7 +224,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 	switch (type) {
 	case IRQCHIP_GICV2M:
 		gic_msi_size = KVM_VGIC_V2M_SIZE;
-		gic_msi_base = ARM_GIC_DIST_BASE - gic_msi_size;
+		gic_msi_base = ARM_GIC_CPUI_BASE - gic_msi_size;
 		break;
 	case IRQCHIP_GICV2:
 		break;
-- 
2.14.1
