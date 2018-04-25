From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 1/3] arm/gic: remove extra 64K from ITS allocation
Date: Wed, 25 Apr 2018 11:09:43 +0100
Message-ID: <20180425100945.19171-2-andre.przywara@arm.com>
References: <20180425100945.19171-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903D540170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:01:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d7GbHga15GIi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 06:00:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD65649FF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:00:40 -0400 (EDT)
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

The KVM_VGIC_V3_ITS_SIZE macro from the Linux API header file already
covers the doorbell page, so we don't need to add that extra page size
in our code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index aca0b939..dd4d747d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -229,8 +229,8 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2:
 		break;
 	case IRQCHIP_GICV3_ITS:
-		/* We reserve the 64K page with the doorbell as well. */
-		gic_msi_size = KVM_VGIC_V3_ITS_SIZE + SZ_64K;
+		/* The 64K page with the doorbell is included. */
+		gic_msi_size = KVM_VGIC_V3_ITS_SIZE;
 		/* fall through */
 	case IRQCHIP_GICV3:
 		gic_redists_size = kvm->cfg.nrcpus * ARM_GIC_REDIST_SIZE;
-- 
2.14.1
