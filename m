From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 36/54] KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register handlers
Date: Thu, 28 Apr 2016 17:45:55 +0100
Message-ID: <1461861973-26464-37-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since GICv3 supports much more than the 8 CPUs the GICv2 ITARGETSR
register can handle, the new IROUTER register covers the whole range
of possible target (V)CPUs by using the same MPIDR that the cores
report themselves.
In addition to translating this MPIDR into a vcpu pointer we store
the originally written value as well. The architecture allows to
write any values into the register, which must be read back as written.

Since we don't support affinity level 3, we don't need to take care
about the upper word of this 64-bit register, which simplifies the
handling a bit.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- fold in and simplify vgic_v3_irq_change_affinity

Changelog v1 .. v2:
- adapt to new MMIO framework

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 65 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index e6f2607..09c0324 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -86,6 +86,69 @@ static u32 compress_mpidr(unsigned long mpidr)
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
+static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	int intid = (addr & 0x1fff) / 8;
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	unsigned long mpidr;
+
+	if (!irq)
+		return 0;
+
+	mpidr = decompress_mpidr(irq->mpidr);
+	return extract_bytes(mpidr, addr & 7, len);
+}
+
+static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
+{
+	int intid = (addr & 0x1fff) / 8;
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	unsigned long mask = 0xffffffff;	/* upper word is WI */
+	u64 mpidr;
+
+	if (!irq)
+		return;
+
+	/*
+	 * There are only two supported options:
+	 * (1) aligned 64-bit access
+	 * (2) aligned 32-bit access
+	 *
+	 * TODO: make this check generic and move it to dispatch_...()
+	 */
+	if (len != 4 && len != 8)
+		return;
+
+
+	/* The upper word is WI for us since we don't implement Aff3. */
+	if (addr & 4)
+		return;
+
+	spin_lock(&irq->irq_lock);
+
+	mpidr = decompress_mpidr(irq->mpidr);
+	mpidr = (mpidr & ~mask) | (val & mask);
+	irq->mpidr = compress_mpidr(mpidr);
+	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
+
+	spin_unlock(&irq->irq_lock);
+}
+
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 					      gpa_t addr, unsigned int len)
 {
@@ -174,7 +237,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 64),
+		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
-- 
2.7.3

