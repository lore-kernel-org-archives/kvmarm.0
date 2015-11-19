From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 12/13] KVM: arm/arm64: vgic: implement clear pending for
 non shared mapped IRQ
Date: Thu, 19 Nov 2015 14:54:02 +0000
Message-ID: <1447944843-17731-13-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4059C49786
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0a4V5zu-7rPn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:51 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B8AF49A41
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:51 -0500 (EST)
Received: by wmec201 with SMTP id c201so121311012wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:30 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements the clear of a pending non shared mapped IRQ.
In case of an edge IRQ, we deactivate the physical IRQ that will never
be deactivated by the guest. In case of a level sensitive IRQ we check
the level of the input signal. If it is asserted we leave the virtual
IRQ pending. In the opposite, we remove the pending state and deactivate
the IRQ.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 98ae15f..4be5972 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -550,20 +550,50 @@ bool vgic_handle_clear_pending_reg(struct kvm *kvm,
 				   phys_addr_t offset, int vcpu_id)
 {
 	u32 *level_active;
-	u32 *reg, orig;
+	u32 *reg, orig, cleared;
 	int mode = ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT;
+	unsigned int i;
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, vcpu_id);
 
 	reg = vgic_bitmap_get_reg(&dist->irq_pending, vcpu_id, offset);
 	orig = *reg;
 	vgic_reg_access(mmio, reg, offset, mode);
 	if (mmio->is_write) {
-		/* Re-set level triggered level-active interrupts */
 		level_active = vgic_bitmap_get_reg(&dist->irq_level,
 					  vcpu_id, offset);
+		cleared = orig ^ *reg;
+
+		/* Re-set level triggered level-active interrupts */
 		reg = vgic_bitmap_get_reg(&dist->irq_pending, vcpu_id, offset);
 		*reg |= *level_active;
 
+		for (i = 0; i < 32; i++) {
+			struct irq_phys_map *map;
+			bool phys_pending;
+			unsigned int irq_num;
+
+			if (!(cleared && (1 << i)))
+				continue;
+			irq_num = (offset * 8) + i;
+			map = vgic_irq_map_search(vcpu, irq_num);
+			if (!map || (map && map->shared))
+				continue;
+			/* check whether the signal is asserted */
+			irq_get_irqchip_state(map->irq,
+					      IRQCHIP_STATE_PENDING,
+					      &phys_pending);
+			if (!vgic_irq_is_edge(vcpu, irq_num) && phys_pending) {
+				vgic_dist_irq_set_pending(vcpu, irq_num);
+				continue;
+			}
+
+			vgic_dist_irq_clear_pending(vcpu, irq_num);
+			irq_set_irqchip_state(map->irq,
+					      IRQCHIP_STATE_ACTIVE,
+					      false);
+		}
+
 		/* Ignore writes to SGIs */
 		if (offset < 2) {
 			*reg &= ~0xffff;
-- 
1.9.1
