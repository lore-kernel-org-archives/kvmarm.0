From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 16/26] KVM: arm/arm64: GICv4: Handle INVALL applied to a vPE
Date: Fri,  6 Oct 2017 16:33:51 +0100
Message-ID: <20171006153401.5481-17-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Since when updating the properties one LPI at a time, there is no
need to perform an INV each time we read one. Instead, we rely
on the final VINVALL that gets sent to the ITS to do the work.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2e77c7c83942..eb72eb027060 100644
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
@@ -297,7 +297,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	}
 
 	if (irq->hw)
-		return its_prop_update_vlpi(irq->host_irq, prop, true);
+		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
 
 	return 0;
 }
@@ -1096,7 +1096,7 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 	if (!ite)
 		return E_ITS_INV_UNMAPPED_INTERRUPT;
 
-	return update_lpi_config(kvm, ite->irq, NULL);
+	return update_lpi_config(kvm, ite->irq, NULL, true);
 }
 
 /*
@@ -1131,12 +1131,15 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
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
2.14.1
