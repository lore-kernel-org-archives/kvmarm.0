From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 12/27] KVM: arm/arm64: GICv4: Propagate affinity changes to the physical ITS
Date: Mon, 13 Nov 2017 10:17:37 +0100
Message-ID: <20171113091752.10663-13-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When the guest issues an affinity change, we need to tell the physical
ITS that we're now targetting a new vcpu.  This is done by extracting
the current mapping, updating the target, and reapplying the mapping.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index ad14af8a4412..80bea7021e2e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -338,11 +338,25 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 
 static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 {
+	int ret = 0;
+
 	spin_lock(&irq->irq_lock);
 	irq->target_vcpu = vcpu;
 	spin_unlock(&irq->irq_lock);
 
-	return 0;
+	if (irq->hw) {
+		struct its_vlpi_map map;
+
+		ret = its_get_vlpi(irq->host_irq, &map);
+		if (ret)
+			return ret;
+
+		map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+
+		ret = its_map_vlpi(irq->host_irq, &map);
+	}
+
+	return ret;
 }
 
 /*
-- 
2.14.2
