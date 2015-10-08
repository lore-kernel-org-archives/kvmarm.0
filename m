From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 08 Oct 2015 15:04:12 +0300
Message-ID: <008c01d101c1$735a03d0$5a0e0b70$@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <20151008101408.GA20936@cbox> <56164BC4.80104@arm.com>
 <5616503A.7060504@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <5616503A.7060504@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Yes, I am looking at merging this. From the discussion with Pavel I
> remember some things that I disagreed with, so I may propose a follow-up
> patch. I will give this a try tomorrow.

 I reply to this thread, because this relates to the whole changeset. After the merge, some pieces
are missing, considering my live migration W.I.P (see patch below). Together with this, vITS v3
backported to v4.2.2 and...

Tested-by: Pavel Fedin <p.fedin@samsung.com>

---
>From b08e9ba1da69f9cf5731c89a4ff39561cd16e6ea Mon Sep 17 00:00:00 2001
From: Pavel Fedin <p.fedin@samsung.com>
Date: Thu, 8 Oct 2015 14:43:23 +0300
Subject: [PATCH] Missing vITS pieces for live migration and safety

1. Split up vits_init() and perform allocations on PENDBASER access. Fixes
   crash when setting LPI registers from userspace before any vCPU has
   been run. The bug is triggered by reset routine in qemu.

2. Properly handle LPIs in vgic_unqueue_irqs(). Does not corrupt memory any
   more if LPI happens to get in there.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/its-emul.c     | 26 +++++++++++++++++++-------
 virt/kvm/arm/its-emul.h     |  1 +
 virt/kvm/arm/vgic-v3-emul.c | 11 ++++++++++-
 virt/kvm/arm/vgic.c         | 15 +++++++++++----
 4 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index b40a7fc..b1d61df 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -1117,7 +1117,9 @@ int vits_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_its *its = &dist->its;
-	int ret;
+
+	if (dist->pendbaser)
+		return 0;
 
 	dist->pendbaser = kcalloc(dist->nr_cpus, sizeof(u64), GFP_KERNEL);
 	if (!dist->pendbaser)
@@ -1132,18 +1134,27 @@ int vits_init(struct kvm *kvm)
 	INIT_LIST_HEAD(&its->device_list);
 	INIT_LIST_HEAD(&its->collection_list);
 
-	ret = vgic_register_kvm_io_dev(kvm, dist->vgic_its_base,
-				       KVM_VGIC_V3_ITS_SIZE, vgicv3_its_ranges,
-				       -1, &its->iodev);
-	if (ret)
-		return ret;
-
 	its->enabled = false;
 	dist->msis_require_devid = true;
 
 	return 0;
 }
 
+int vits_map_resources(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_its *its = &dist->its;
+	int ret;
+
+	ret = vits_init(kvm);
+	if (ret)
+		return ret;
+
+	return vgic_register_kvm_io_dev(kvm, dist->vgic_its_base,
+				       KVM_VGIC_V3_ITS_SIZE, vgicv3_its_ranges,
+				       -1, &its->iodev);
+}
+
 void vits_destroy(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -1182,6 +1193,7 @@ void vits_destroy(struct kvm *kvm)
 	kfree(its->buffer_page);
 	kfree(dist->pendbaser);
 
+	dist->pendbaser = NULL;
 	its->enabled = false;
 	spin_unlock(&its->lock);
 }
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
index 95e56a7..236f153 100644
--- a/virt/kvm/arm/its-emul.h
+++ b/virt/kvm/arm/its-emul.h
@@ -34,6 +34,7 @@
 
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vits_init(struct kvm *kvm);
+int vits_map_resources(struct kvm *kvm);
 void vits_destroy(struct kvm *kvm);
 
 int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 3e262f3..b340202 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -693,6 +693,15 @@ static bool handle_mmio_pendbaser_redist(struct kvm_vcpu *vcpu,
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	int mode = ACCESS_READ_VALUE;
 
+	/*
+	 * This makes sure that dist->pendbaser is allocated.
+	 * We don't use any locks here because the actual initialization will
+	 * happen either during register access from userspace, or upon first
+	 * run. Both situations are already single-threaded.
+	 */
+	if (vits_init(vcpu->kvm))
+		return false;
+
 	/* Storing a value with LPIs already enabled is undefined */
 	mode |= dist->lpis_enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
 	vgic_reg64_access(mmio, offset,
@@ -880,7 +889,7 @@ static int vgic_v3_map_resources(struct kvm *kvm,
 	}
 
 	if (vgic_has_its(kvm)) {
-		ret = vits_init(kvm);
+		ret = vits_map_resources(kvm);
 		if (ret)
 			goto out_unregister;
 	}
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index b32baa0..8dbbb1a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -711,6 +711,7 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
  */
 void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	u64 elrsr = vgic_get_elrsr(vcpu);
 	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
@@ -737,8 +738,10 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * interrupt then move the active state to the
 		 * distributor tracking bit.
 		 */
-		if (lr.state & LR_STATE_ACTIVE)
-			vgic_irq_set_active(vcpu, lr.irq);
+		if (lr.state & LR_STATE_ACTIVE) {
+			if (lr.irq < dist->nr_irqs)
+				vgic_irq_set_active(vcpu, lr.irq);
+		}
 
 		/*
 		 * Reestablish the pending state on the distributor and the
@@ -746,8 +749,12 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * is fine, then we are only setting a few bits that were
 		 * already set.
 		 */
-		if (lr.state & LR_STATE_PENDING)
-			vgic_dist_irq_set_pending(vcpu, lr.irq);
+		if (lr.state & LR_STATE_PENDING) {
+			if (lr.irq < dist->nr_irqs)
+				vgic_dist_irq_set_pending(vcpu, lr.irq);
+			else
+				vgic_unqueue_lpi(vcpu, lr.irq);
+		}
 
 		/*
 		 * Mark the LR as free for other use.
-- 
2.4.4


Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


