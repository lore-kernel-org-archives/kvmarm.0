From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 03/15] KVM: arm/arm64: add emulation model specific destroy
 function
Date: Fri, 10 Jul 2015 15:21:39 +0100
Message-ID: <1436538111-4294-4-git-send-email-andre.przywara@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E130B58585
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:10:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3W9l6jKckBSw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 10:10:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFF4A5856D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 10:10:22 -0400 (EDT)
In-Reply-To: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we destroy the VGIC emulation in one function that cares for
all emulated models. To be on par with init_model (which is model
specific), lets introduce a per-emulation-model destroy method, too.
Use it for a tiny GICv3 specific code already, later it will be handy
for the ITS emulation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/vgic-v3-emul.c |  9 +++++++++
 virt/kvm/arm/vgic.c         | 11 ++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2ccfa9a..b18e2c5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -144,6 +144,7 @@ struct vgic_vm_ops {
 	bool	(*queue_sgi)(struct kvm_vcpu *, int irq);
 	void	(*add_sgi_source)(struct kvm_vcpu *, int irq, int source);
 	int	(*init_model)(struct kvm *);
+	void	(*destroy_model)(struct kvm *);
 	int	(*map_resources)(struct kvm *, const struct vgic_params *);
 };
 
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e661e7f..d2eeb20 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -862,6 +862,14 @@ static int vgic_v3_init_model(struct kvm *kvm)
 	return 0;
 }
 
+static void vgic_v3_destroy_model(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	kfree(dist->irq_spi_mpidr);
+	dist->irq_spi_mpidr = NULL;
+}
+
 /* GICv3 does not keep track of SGI sources anymore. */
 static void vgic_v3_add_sgi_source(struct kvm_vcpu *vcpu, int irq, int source)
 {
@@ -874,6 +882,7 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 	dist->vm_ops.queue_sgi = vgic_v3_queue_sgi;
 	dist->vm_ops.add_sgi_source = vgic_v3_add_sgi_source;
 	dist->vm_ops.init_model = vgic_v3_init_model;
+	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
 	dist->vm_ops.map_resources = vgic_v3_map_resources;
 
 	kvm->arch.max_vcpus = KVM_MAX_VCPUS;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 394622c..cc8f5ed 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -100,6 +100,14 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
 }
 
+static void vgic_destroy_model(struct kvm *kvm)
+{
+	struct vgic_vm_ops *vm_ops = &kvm->arch.vgic.vm_ops;
+
+	if (vm_ops->destroy_model)
+		vm_ops->destroy_model(kvm);
+}
+
 /*
  * struct vgic_bitmap contains a bitmap made of unsigned longs, but
  * extracts u32s out of them.
@@ -1629,6 +1637,8 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	vgic_destroy_model(kvm);
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
 
@@ -1645,7 +1655,6 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	}
 	kfree(dist->irq_sgi_sources);
 	kfree(dist->irq_spi_cpu);
-	kfree(dist->irq_spi_mpidr);
 	kfree(dist->irq_spi_target);
 	kfree(dist->irq_pending_on_cpu);
 	kfree(dist->irq_active_on_cpu);
-- 
2.3.5
