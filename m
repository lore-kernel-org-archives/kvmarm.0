From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 37/56] KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register
 handlers
Date: Mon, 16 May 2016 10:53:25 +0100
Message-ID: <1463392481-26583-38-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4770349B8D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Imu+g1k4aCDZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:52:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F304049B8A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:01 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Changelog v3 .. v4:
- move accessor width check into dispatcher
- use IRQ number accessor macro

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index b893284..7b9340b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -75,6 +75,41 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	int intid = VGIC_ADDR_TO_INTID(addr, 64);
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+
+	if (!irq)
+		return 0;
+
+	return extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
+}
+
+static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
+{
+	int intid = VGIC_ADDR_TO_INTID(addr, 64);
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+
+	if (!irq)
+		return;
+
+	/* The upper word is WI for us since we don't implement Aff3. */
+	if (addr & 4)
+		return;
+
+	spin_lock(&irq->irq_lock);
+
+	/* We only care about and preserve Aff0, Aff1 and Aff2. */
+	irq->mpidr = val & GENMASK(23, 0);
+	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
+
+	spin_unlock(&irq->irq_lock);
+}
+
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 					      gpa_t addr, unsigned int len)
 {
@@ -170,7 +205,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 64,
+		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
-- 
2.8.2
