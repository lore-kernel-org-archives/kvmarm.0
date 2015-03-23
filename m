From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 09/12] KVM: arm/arm64: prepare GICv2 emulation to be
 handled by kvm_io_bus
Date: Mon, 23 Mar 2015 15:58:26 +0000
Message-ID: <1427126309-11223-10-git-send-email-andre.przywara@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8BC749743
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f2A-1xAeIvv7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2015 11:51:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6CD4974F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:45 -0400 (EDT)
In-Reply-To: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Using the framework provided by the recent vgic.c changes we register
a kvm_io_bus device when initializing the virtual GICv2.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h      |    1 +
 virt/kvm/arm/vgic-v2-emul.c |   13 +++++++++----
 virt/kvm/arm/vgic.c         |   17 +++++++++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f90140c..4523984 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -251,6 +251,7 @@ struct vgic_dist {
 	unsigned long		*irq_active_on_cpu;
 
 	struct vgic_vm_ops	vm_ops;
+	struct vgic_io_device	dist_iodev;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1dd183e..69f27c8 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -506,6 +506,7 @@ static bool vgic_v2_queue_sgi(struct kvm_vcpu *vcpu, int irq)
 static int vgic_v2_map_resources(struct kvm *kvm,
 				 const struct vgic_params *params)
 {
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	if (!irqchip_in_kernel(kvm))
@@ -516,13 +517,17 @@ static int vgic_v2_map_resources(struct kvm *kvm,
 	if (vgic_ready(kvm))
 		goto out;
 
-	if (IS_VGIC_ADDR_UNDEF(kvm->arch.vgic.vgic_dist_base) ||
-	    IS_VGIC_ADDR_UNDEF(kvm->arch.vgic.vgic_cpu_base)) {
+	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
+	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
 		kvm_err("Need to set vgic cpu and dist addresses first\n");
 		ret = -ENXIO;
 		goto out;
 	}
 
+	vgic_register_kvm_io_dev(kvm, dist->vgic_dist_base,
+				 KVM_VGIC_V2_DIST_SIZE,
+				 vgic_dist_ranges, -1, &dist->dist_iodev);
+
 	/*
 	 * Initialize the vgic if this hasn't already been done on demand by
 	 * accessing the vgic state from userspace.
@@ -533,7 +538,7 @@ static int vgic_v2_map_resources(struct kvm *kvm,
 		goto out;
 	}
 
-	ret = kvm_phys_addr_ioremap(kvm, kvm->arch.vgic.vgic_cpu_base,
+	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 				    params->vcpu_base, KVM_VGIC_V2_CPU_SIZE,
 				    true);
 	if (ret) {
@@ -541,7 +546,7 @@ static int vgic_v2_map_resources(struct kvm *kvm,
 		goto out;
 	}
 
-	kvm->arch.vgic.ready = true;
+	dist->ready = true;
 out:
 	if (ret)
 		kvm_vgic_destroy(kvm);
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index e968179..9a732d0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -989,6 +989,21 @@ int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
 	return ret;
 }
 
+static void vgic_unregister_kvm_io_dev(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (!dist || !kvm->buses[KVM_MMIO_BUS])
+		return;
+
+	mutex_lock(&kvm->slots_lock);
+	/* We could get here without ever having registered a device. */
+	if (dist->dist_iodev.dev.ops)
+		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+					  &dist->dist_iodev.dev);
+	mutex_unlock(&kvm->slots_lock);
+}
+
 static int vgic_nr_shared_irqs(struct vgic_dist *dist)
 {
 	return dist->nr_irqs - VGIC_NR_PRIVATE_IRQS;
@@ -1705,6 +1720,8 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	vgic_unregister_kvm_io_dev(kvm);
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
 
-- 
1.7.9.5
