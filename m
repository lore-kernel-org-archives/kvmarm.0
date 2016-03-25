From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 22/45] KVM: arm/arm64: vgic-new: Add SGIPENDR register
 handlers
Date: Fri, 25 Mar 2016 02:04:45 +0000
Message-ID: <1458871508-17279-23-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC707409A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t5vTQv81Vz1x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C31C48531
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:58 -0400 (EDT)
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
 virt/kvm/arm/vgic/vgic_mmio.c | 79 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index a49726f..2ab8961 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -64,24 +64,6 @@ int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	return 0;
 }
 
-static int vgic_mmio_read_nyi(struct kvm_vcpu *vcpu,
-			      struct kvm_io_device *this,
-			      gpa_t addr, int len, void *val)
-{
-	pr_warn("KVM: handling unimplemented VGIC MMIO read: VCPU %d, address: 0x%llx\n",
-		vcpu->vcpu_id, (unsigned long long)addr);
-	return 0;
-}
-
-static int vgic_mmio_write_nyi(struct kvm_vcpu *vcpu,
-			       struct kvm_io_device *this,
-			       gpa_t addr, int len, const void *val)
-{
-	pr_warn("KVM: handling unimplemented VGIC MMIO write: VCPU %d, address: 0x%llx\n",
-		vcpu->vcpu_id, (unsigned long long)addr);
-	return 0;
-}
-
 static int vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
 				  struct kvm_io_device *this,
 				  gpa_t addr, int len, void *val)
@@ -556,6 +538,63 @@ static int vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *this,
+				  gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(this,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr - iodev->base_addr);
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		((u8 *)val)[i] = irq->source;
+		spin_unlock(&irq->irq_lock);
+	}
+	return 0;
+}
+
+static int vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *this,
+				    gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(this,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr - iodev->base_addr);
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		irq->source &= ~((u8 *)val)[i];
+		spin_unlock(&irq->irq_lock);
+	}
+	return 0;
+}
+
+static int vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *this,
+				    gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(this,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr - iodev->base_addr);
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		irq->source |= ((u8 *)val)[i];
+		spin_unlock(&irq->irq_lock);
+	}
+	return 0;
+}
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -582,9 +621,9 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
 		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+		vgic_mmio_read_sgipend, vgic_mmio_write_sgipendc, 16),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
 };
 
 /*
-- 
2.7.3
