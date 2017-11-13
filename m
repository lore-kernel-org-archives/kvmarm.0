From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 16/27] KVM: arm/arm64: GICv4: Handle INVALL applied to a vPE
Date: Mon, 13 Nov 2017 10:17:41 +0100
Message-ID: <20171113091752.10663-17-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

There is no need to perform an INV for each interrupt when updating
multiple interrupts.  Instead, we can rely on the final VINVALL that
gets sent to the ITS to do the work for all of them.

Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4768a0e21cc5..bf571f6d2b32 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -38,7 +38,7 @@ static int vgic_its_save_tables_v0(struct vgic_its *its);
 static int vgic_its_restore_tables_v0(struct vgic_its *its);
 static int vgic_its_commit_v0(struct vgic_its *its);
 static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
-			     struct kvm_vcpu *filter_vcpu);
+			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
@@ -106,7 +106,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * However we only have those structs for mapped IRQs, so we read in
 	 * the respective config data from memory here upon mapping the LPI.
 	 */
-	ret = update_lpi_config(kvm, irq, NULL);
+	ret = update_lpi_config(kvm, irq, NULL, false);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -273,7 +273,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
  * VCPU. Unconditionally applies if filter_vcpu is NULL.
  */
 static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
-			     struct kvm_vcpu *filter_vcpu)
+			     struct kvm_vcpu *filter_vcpu, bool needs_inv)
 {
 	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
 	u8 prop;
@@ -298,7 +298,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	}
 
 	if (irq->hw)
-		return its_prop_update_vlpi(irq->host_irq, prop, true);
+		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
 
 	return 0;
 }
@@ -1117,7 +1117,7 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 	if (!ite)
 		return E_ITS_INV_UNMAPPED_INTERRUPT;
 
-	return update_lpi_config(kvm, ite->irq, NULL);
+	return update_lpi_config(kvm, ite->irq, NULL, true);
 }
 
 /*
@@ -1152,12 +1152,15 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
 		if (!irq)
 			continue;
-		update_lpi_config(kvm, irq, vcpu);
+		update_lpi_config(kvm, irq, vcpu, false);
 		vgic_put_irq(kvm, irq);
 	}
 
 	kfree(intids);
 
+	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
+		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
+
 	return 0;
 }
 
-- 
2.14.2
