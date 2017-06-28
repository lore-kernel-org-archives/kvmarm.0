From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 46/52] KVM: arm/arm64: GICv4: Handle INVALL applied to a vPE
Date: Wed, 28 Jun 2017 16:04:05 +0100
Message-ID: <20170628150411.15846-47-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE65243C9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B5QGjJt4rNJL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C70C49C3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:46 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Since when updating the properties one LPI at a time, there is no
need to perform an INV each time we read one. Instead, we rely
on the final VINVALL that gets sent to the ITS to do the work.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2015246ab9f9..b0790ca5e933 100644
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
 
@@ -274,7 +274,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
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
@@ -1095,7 +1095,7 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 	if (!ite)
 		return E_ITS_INV_UNMAPPED_INTERRUPT;
 
-	return update_lpi_config(kvm, ite->irq, NULL);
+	return update_lpi_config(kvm, ite->irq, NULL, true);
 }
 
 /*
@@ -1130,12 +1130,15 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
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
2.11.0
