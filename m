From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 21/45] KVM: arm/arm64: vgic-new: Add SGIR register handler
Date: Fri, 25 Mar 2016 02:04:44 +0000
Message-ID: <1458871508-17279-22-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF4D840FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Xfq8iYgGEWx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:04:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9120D49B30
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:56 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic_mmio.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index cde153f..a49726f 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -512,6 +512,50 @@ static int vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
+				struct kvm_io_device *this,
+				gpa_t addr, int len, const void *val)
+{
+	int nr_vcpus = atomic_read(&source_vcpu->kvm->online_vcpus);
+	u32 value = *(u32 *)val;
+	int intid = value & 0xf;
+	int targets = (value >> 16) & 0xff;
+	int mode = (value >> 24) & 0x03;
+	int c;
+	struct kvm_vcpu *vcpu;
+
+	switch (mode) {
+	case 0x0:		/* as specified by targets */
+		break;
+	case 0x1:
+		targets = (1U << nr_vcpus) - 1;			/* all, ... */
+		targets &= ~(1U << source_vcpu->vcpu_id);	/* but self */
+		break;
+	case 0x2:		/* this very vCPU only */
+		targets = (1U << source_vcpu->vcpu_id);
+		break;
+	case 0x3:		/* reserved */
+		break;
+	}
+
+	kvm_for_each_vcpu(c, vcpu, source_vcpu->kvm) {
+		struct vgic_irq *irq;
+
+		if (!(targets & (1U << c)))
+			continue;
+
+		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
+
+		spin_lock(&irq->irq_lock);
+		irq->pending = true;
+		irq->source |= 1U << source_vcpu->vcpu_id;
+
+		vgic_queue_irq(source_vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -536,7 +580,7 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
 		vgic_mmio_read_config, vgic_mmio_write_config, 2),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 4),
+		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
 		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
-- 
2.7.3
