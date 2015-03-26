From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 08/11] KVM: arm/arm64: prepare GICv2 emulation to be
 handled by kvm_io_bus
Date: Thu, 26 Mar 2015 14:39:35 +0000
Message-ID: <1427380778-942-9-git-send-email-andre.przywara@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A69C349C3B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1RvjazJvHnjB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 10:32:42 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F0949C1E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:41 -0400 (EDT)
In-Reply-To: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Using the framework provided by the recent vgic.c changes we register
a kvm_io_bus device when initializing the virtual GICv2.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h      |    1 +
 virt/kvm/arm/vgic-v2-emul.c |   22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

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
index 1dd183e..7460b37 100644
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
@@ -530,18 +535,23 @@ static int vgic_v2_map_resources(struct kvm *kvm,
 	ret = vgic_init(kvm);
 	if (ret) {
 		kvm_err("Unable to allocate maps\n");
-		goto out;
+		goto out_unregister;
 	}
 
-	ret = kvm_phys_addr_ioremap(kvm, kvm->arch.vgic.vgic_cpu_base,
+	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 				    params->vcpu_base, KVM_VGIC_V2_CPU_SIZE,
 				    true);
 	if (ret) {
 		kvm_err("Unable to remap VGIC CPU to VCPU\n");
-		goto out;
+		goto out_unregister;
 	}
 
-	kvm->arch.vgic.ready = true;
+	dist->ready = true;
+	goto out;
+
+out_unregister:
+	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &dist->dist_iodev.dev);
+
 out:
 	if (ret)
 		kvm_vgic_destroy(kvm);
-- 
1.7.9.5
