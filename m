From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/11] KVM: arm/arm64: vgic: Always initialize the group of
 private IRQs
Date: Thu,  7 Feb 2019 13:18:40 +0000
Message-ID: <20190207131843.157210-9-marc.zyngier@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968F34A469
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6E5GmYrHyTpH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Feb 2019 08:19:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B20F4A479
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:18 -0500 (EST)
In-Reply-To: <20190207131843.157210-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index dfbfcb1fe933..3bdb31eaed64 100644
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
@@ -281,7 +274,7 @@ int vgic_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu;
-	int ret = 0, i;
+	int ret = 0, i, idx;
 
 	if (vgic_initialized(kvm))
 		return 0;
@@ -298,6 +291,19 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
+	/* Initialize groups on CPUs created before the VGIC type was known */
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
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
2.20.1
