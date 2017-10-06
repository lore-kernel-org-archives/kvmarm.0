From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 17/26] KVM: arm/arm64: GICv4: Propagate VLPI properties at map time
Date: Fri,  6 Oct 2017 16:33:52 +0100
Message-ID: <20171006153401.5481-18-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When the VLPI gets mapped, it must inherit the configuration of
the LPI configured at the vITS level. For that purpose, let's make
update_lpi_config globally available and call it just after
having performed the VLPI map operation.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 6 ++----
 virt/kvm/arm/vgic/vgic-v4.c  | 2 ++
 virt/kvm/arm/vgic/vgic.h     | 2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index eb72eb027060..f434748439ee 100644
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
@@ -272,8 +270,8 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
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
index ba1dd3162eba..b79a0450bb1c 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -147,6 +147,8 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	irq->hw		= true;
 	irq->host_irq	= virq;
 
+	/* Force the property update and invalidate */
+	update_lpi_config(kvm, irq, NULL, true);
 out:
 	mutex_unlock(&its->its_lock);
 	return ret;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c4105f613f57..1bd2e28ac097 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -239,6 +239,8 @@ static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
+		      struct kvm_vcpu *filter_vcpu, bool needs_inv);
 
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
-- 
2.14.1
