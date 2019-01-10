From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic: Always initialize the group of private
 IRQs
Date: Thu, 10 Jan 2019 15:33:52 +0100
Message-ID: <20190110143352.17295-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14C1D4A417
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:33:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wOTXsB4iJHVl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:33:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 021474A3FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:33:56 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently initialize the group of private IRQs during
kvm_vgic_vcpu_init, and the value of the group depends on the GIC model
we are emulating.  However, CPUs created before creating (and
initializing) the VGIC might end up with the wrong group if the VGIC
is created as GICv3 later.

Since we have no enforced ordering of creating the VGIC and creating
VCPUs, we can end up with part the VCPUs being properly intialized and
the remaining incorrectly initialized.  That also means that we have no
single place to do the per-cpu data structure initialization which
depends on knowing the emulated GIC model (which is only the group
field).

This patch removes the incorrect comment from kvm_vgic_vcpu_init and
initializes the group of all previously created VCPUs's private
interrupts in vgic_init in addition to the existing initialization in
kvm_vgic_vcpu_init.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
I tested this by modifying kvmtool to create the vgic in the middle of creating
the VCPUs, and looking in /sys/kernel/debug/kvm/<pid>/vgic-state showed the
first VCPU with private interrupts with group 0 for gicv3 and the secondary
VCPU with group 1 prior to this patch, and both VCPUs with group 1 following
this patch for GICv3 and both with group 0 with GICv2.

diff --git a/arm/kvm.c b/arm/kvm.c
index b824f63..c6c5fbc 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -82,10 +82,6 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
-
-	/* Create the virtual GIC. */
-	if (gic__create(kvm, kvm->cfg.arch.irqchip))
-		die("Failed to create virtual GIC");
 }
 
 #define FDT_ALIGN	SZ_2M
diff --git a/kvm-cpu.c b/kvm-cpu.c
index cc8385f..7a2fde0 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -253,6 +253,7 @@ panic_kvm:
 int kvm_cpu__init(struct kvm *kvm)
 {
 	int max_cpus, recommended_cpus, i;
+	bool gic_created = false;
 
 	max_cpus = kvm__max_cpus(kvm);
 	recommended_cpus = kvm__recommended_cpus(kvm);
@@ -281,6 +282,12 @@ int kvm_cpu__init(struct kvm *kvm)
 	}
 
 	for (i = 0; i < kvm->nrcpus; i++) {
+		if (i == 1) {
+			/* Create the virtual GIC. */
+			if (gic__create(kvm, kvm->cfg.arch.irqchip))
+				die("Failed to create virtual GIC");
+			gic_created = true;
+		}
 		kvm->cpus[i] = kvm_cpu__arch_init(kvm, i);
 		if (!kvm->cpus[i]) {
 			pr_warning("unable to initialize KVM VCPU");
@@ -288,6 +295,10 @@ int kvm_cpu__init(struct kvm *kvm)
 		}
 	}
 
+	/* Create the virtual GIC. */
+	if (!gic_created && gic__create(kvm, kvm->cfg.arch.irqchip))
+		die("Failed to create virtual GIC");
+
 	return 0;
 
 fail_alloc:

 virt/kvm/arm/vgic/vgic-init.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index c0c0b88af1d5..f935adc50626 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -231,13 +231,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 			irq->config = VGIC_CONFIG_LEVEL;
 		}
 
-		/*
-		 * GICv3 can only be created via the KVM_DEVICE_CREATE API and
-		 * so we always know the emulation type at this point as it's
-		 * either explicitly configured as GICv3, or explicitly
-		 * configured as GICv2, or not configured yet which also
-		 * implies GICv2.
-		 */
 		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
 			irq->group = 1;
 		else
@@ -298,6 +291,19 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
+	/* Initialize groups on CPUs created before the VGIC type was known */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
+			if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+				irq->group = 1;
+			else
+				irq->group = 0;
+		}
+	}
+
 	if (vgic_has_its(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
-- 
2.18.0
