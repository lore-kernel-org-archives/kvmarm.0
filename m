From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 34/59] KVM: arm/arm64: vgic-new: Add SGIPENDR register handlers
Date: Tue, 24 May 2016 11:09:28 +0200
Message-ID: <1464080993-10884-35-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A79F49C29
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ZaYzRdMeL2J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:07:04 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4152349BE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:57 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id n129so15348288wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:30 -0700 (PDT)
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

As this register is v2 specific, its implementation lives entirely
in vgic-mmio-v2.c.
This register allows setting the source mask of an IPI.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 62 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index c884e9b..3925d4c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -146,6 +146,64 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 	}
 }
 
+static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	u32 intid = addr & 0x0f;
+	int i;
+	u64 val = 0;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		val |= (u64)irq->source << (i * 8);
+	}
+	return val;
+}
+
+static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	u32 intid = addr & 0x0f;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		irq->source &= ~((val >> (i * 8)) & 0xff);
+		if (!irq->source)
+			irq->pending = false;
+
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
+static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	u32 intid = addr & 0x0f;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		irq->source |= (val >> (i * 8)) & 0xff;
+
+		if (irq->source) {
+			irq->pending = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq);
+		} else {
+			spin_unlock(&irq->irq_lock);
+		}
+	}
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -184,10 +242,10 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		vgic_mmio_read_sgipend, vgic_mmio_write_sgipendc, 16,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 };
 
-- 
2.1.2.330.g565301e.dirty
