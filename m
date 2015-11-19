From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 11/13] KVM: arm/arm64: vgic: implement clear active for non
 shared mapped IRQ
Date: Thu, 19 Nov 2015 14:54:01 +0000
Message-ID: <1447944843-17731-12-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 866DA49A3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W74vrt3YuDbG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:49 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A483049A19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:49 -0500 (EST)
Received: by wmec201 with SMTP id c201so29573605wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:29 -0800 (PST)
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

When disabling a non shared mapped IRQs, we must manually deactivate
the corresponding physical IRQ on top of removing the active state
from the distributor.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index bd500b4..98ae15f 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -604,14 +604,34 @@ bool vgic_handle_clear_active_reg(struct kvm *kvm,
 				  struct kvm_exit_mmio *mmio,
 				  phys_addr_t offset, int vcpu_id)
 {
-	u32 *reg;
+	u32 *reg, orig, cleared;
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, vcpu_id);
+	unsigned int i;
 
 	reg = vgic_bitmap_get_reg(&dist->irq_active, vcpu_id, offset);
+	orig = *reg;
 	vgic_reg_access(mmio, reg, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
 
 	if (mmio->is_write) {
+		cleared = orig ^ *reg;
+
+		for (i = 0; i < 32; i++) {
+			struct irq_phys_map *map;
+			unsigned int irq_num;
+
+			if (!(cleared && (1 << i)))
+				continue;
+			irq_num = (offset * 8) + i;
+			map = vgic_irq_map_search(vcpu, irq_num);
+			if (!map || (map && map->shared))
+				continue;
+			irq_set_irqchip_state(map->irq,
+					      IRQCHIP_STATE_ACTIVE,
+					      false);
+		}
+
 		vgic_update_state(kvm);
 		return true;
 	}
-- 
1.9.1
