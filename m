From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 47/52] KVM: arm/arm64: GICv4: Propagate VLPI properties at
 map time
Date: Wed, 28 Jun 2017 16:04:06 +0100
Message-ID: <20170628150411.15846-48-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A9849C4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OMlotFqSycaq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7B649C60
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:48 -0400 (EDT)
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

When the VLPI gets mapped, it must inherit the configuration of
LPI configured at the vITS level. FOr that purpose, let's make
update_lpi_config globally available and call it just after
having performed the VLPI map operation.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 6 ++----
 virt/kvm/arm/vgic/vgic-v4.c  | 2 ++
 virt/kvm/arm/vgic/vgic.h     | 2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index b0790ca5e933..289c158aeee1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -37,8 +37,6 @@
 static int vgic_its_save_tables_v0(struct vgic_its *its);
 static int vgic_its_restore_tables_v0(struct vgic_its *its);
 static int vgic_its_commit_v0(struct vgic_its *its);
-static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
-			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
@@ -273,8 +271,8 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
  * If filter_vcpu is not NULL, applies only if the IRQ is targeting this
  * VCPU. Unconditionally applies if filter_vcpu is NULL.
  */
-static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
-			     struct kvm_vcpu *filter_vcpu, bool needs_inv)
+int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
+		      struct kvm_vcpu *filter_vcpu, bool needs_inv)
 {
 	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
 	u8 prop;
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 22cc3871bf03..a2d1a6db0490 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -118,6 +118,8 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	irq->hw		= true;
 	irq->host_irq	= virq;
 
+	/* Force the property update and invalidate */
+	update_lpi_config(kvm, irq, NULL, true);
 out:
 	mutex_unlock(&its->its_lock);
 	return 0;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 4dc47edce672..974e382297f9 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -228,6 +228,8 @@ void unlock_all_vcpus(struct kvm *kvm);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
+		      struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
-- 
2.11.0
