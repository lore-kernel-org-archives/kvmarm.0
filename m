From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 39/59] KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register
 handlers
Date: Tue, 24 May 2016 11:09:33 +0200
Message-ID: <1464080993-10884-40-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A38049C37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HODsSknKWMyn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:07:05 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEC3449C17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:01 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id z87so15357681wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:35 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

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
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 41 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 22e512c..4dcef9e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -75,6 +75,45 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
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
+	/* The upper word is RAZ for us. */
+	if (addr & 4)
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
@@ -170,7 +209,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 64,
+		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
-- 
2.1.2.330.g565301e.dirty
