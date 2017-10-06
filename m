From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 15/26] KVM: arm/arm64: GICv4: Propagate property updates to
 VLPIs
Date: Fri,  6 Oct 2017 16:33:50 +0100
Message-ID: <20171006153401.5481-16-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3FE749D2B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ABQ4Oqs8ktqR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Oct 2017 11:34:08 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C392B49D66
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:08 -0400 (EDT)
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Upon updating a property, we propagate it all the way to the physical
ITS, and ask for an INV command to be executed there.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 0b7e648e7a0c..2e77c7c83942 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -296,6 +296,9 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 		spin_unlock(&irq->irq_lock);
 	}
 
+	if (irq->hw)
+		return its_prop_update_vlpi(irq->host_irq, prop, true);
+
 	return 0;
 }
 
-- 
2.14.1
