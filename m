From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 13/26] KVM: arm/arm64: GICv4: Handle CLEAR applied to a VLPI
Date: Fri,  6 Oct 2017 16:33:48 +0100
Message-ID: <20171006153401.5481-14-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Handling CLEAR is pretty easy. Just ask the ITS driver to clear
the corresponding pending bit (which will turn into a CLEAR
command on the physical side).

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 42ffb9084bb7..5778b50911e8 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1070,6 +1070,10 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 
 	ite->irq->pending_latch = false;
 
+	if (ite->irq->hw)
+		return irq_set_irqchip_state(ite->irq->host_irq,
+					     IRQCHIP_STATE_PENDING, false);
+
 	return 0;
 }
 
-- 
2.14.1
