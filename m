From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 13/26] KVM: arm/arm64: GICv4: Propagate affinity changes to
 the physical ITS
Date: Fri, 27 Oct 2017 15:28:42 +0100
Message-ID: <20171027142855.21584-14-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D717E40795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IerAg5qw0c4l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:28:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2BA49D6E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:20 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When the guest issues an affinity change, we need to tell the physical
ITS that we're now targetting a new vcpu.  This is done by extracting
the current mapping, updating the target, and reapplying the mapping.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c9b1c0967426..42ffb9084bb7 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -337,11 +337,25 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 
 static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 {
+	int ret = 0;
+
 	spin_lock(&irq->irq_lock);
 	irq->target_vcpu = vcpu;
 	spin_unlock(&irq->irq_lock);
 
-	return 0;
+	if (irq->hw) {
+		struct its_vlpi_map map;
+
+		ret = its_get_vlpi(irq->host_irq, &map);
+		if (ret)
+			return ret;
+
+		map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+
+		ret = its_map_vlpi(irq->host_irq, &map);
+	}
+
+	return ret;
 }
 
 /*
-- 
2.11.0
