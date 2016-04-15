From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 27/45] KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register
 handlers
Date: Fri, 15 Apr 2016 18:11:38 +0100
Message-ID: <1460740316-8755-28-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED76549BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ns4W62VYj9vN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F6C249C26
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:42 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Those set the affinity of a SPI interrupt.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Changelog RFC..v1:
- fold in and simplify vgic_v3_irq_change_affinity
---
 virt/kvm/arm/vgic/vgic_mmio.c | 73 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index dafa235..3f03101 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -74,24 +74,6 @@ int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	return 0;
 }
 
-static int vgic_mmio_read_nyi(struct kvm_vcpu *vcpu,
-			      struct kvm_io_device *dev,
-			      gpa_t addr, int len, void *val)
-{
-	pr_warn("KVM: handling unimplemented VGIC MMIO read: VCPU %d, address: 0x%llx\n",
-		vcpu->vcpu_id, (unsigned long long)addr);
-	return 0;
-}
-
-static int vgic_mmio_write_nyi(struct kvm_vcpu *vcpu,
-			       struct kvm_io_device *dev,
-			       gpa_t addr, int len, const void *val)
-{
-	pr_warn("KVM: handling unimplemented VGIC MMIO write: VCPU %d, address: 0x%llx\n",
-		vcpu->vcpu_id, (unsigned long long)addr);
-	return 0;
-}
-
 static int vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
 				  struct kvm_io_device *dev,
 				  gpa_t addr, int len, void *val)
@@ -755,6 +737,59 @@ static u32 compress_mpidr(unsigned long mpidr)
 	return ret;
 }
 
+static unsigned long decompress_mpidr(u32 value)
+{
+	unsigned long mpidr;
+
+	mpidr  = ((value >>  0) & 0xFF) << MPIDR_LEVEL_SHIFT(0);
+	mpidr |= ((value >>  8) & 0xFF) << MPIDR_LEVEL_SHIFT(1);
+	mpidr |= ((value >> 16) & 0xFF) << MPIDR_LEVEL_SHIFT(2);
+	mpidr |= (u64)((value >> 24) & 0xFF) << MPIDR_LEVEL_SHIFT(3);
+
+	return mpidr;
+}
+
+static int vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *dev,
+				  gpa_t addr, int len, void *val)
+{
+	int intid = (addr & 0x1fff) / 8;
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+
+	if (!irq) {
+		memset(val, 0, len);
+		return 0;
+	}
+
+	write_mask64(decompress_mpidr(irq->mpidr), addr & 7, len, val);
+
+	return 0;
+}
+
+static int vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *dev,
+				   gpa_t addr, int len, const void *val)
+{
+	int intid = (addr & 0x1fff) / 8;
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	u64 mpidr;
+
+	if (!irq)
+		return 0;
+
+	mpidr = decompress_mpidr(irq->mpidr);
+	mpidr = mask64(mpidr, addr & 7, len, val);
+
+	spin_lock(&irq->irq_lock);
+
+	irq->mpidr = compress_mpidr(mpidr);
+	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
+
+	spin_unlock(&irq->irq_lock);
+
+	return 0;
+}
+
 static int vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 				    struct kvm_io_device *dev,
 				    gpa_t addr, int len, void *val)
@@ -875,7 +910,7 @@ struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 64),
+		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
-- 
2.7.3
