From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 22/57] KVM: arm/arm64: vgic-new: Implement
 kvm_vgic_vcpu_pending_irq
Date: Thu, 19 May 2016 19:08:01 +0100
Message-ID: <1463681316-23039-23-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1FAB49B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRxnzZ4-SEeH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 14:05:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 392CA49B53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:26 -0400 (EDT)
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

Tell KVM whether a particular VCPU has an IRQ that needs handling
in the guest. This is used to decide whether a VCPU is runnable.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
Changelog RFC..v1:
- return false if distributor is disabled
- add vgic_kick_vcpus() implementations

Changelog v2 .. v3:
- remove vgic_kick_vcpus() implementation from this patch

 include/kvm/vgic/vgic.h  |  2 ++
 virt/kvm/arm/vgic/vgic.c | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 9506267..f663288 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -184,6 +184,8 @@ struct vgic_cpu {
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level);
 
+int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(false)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 719cef0..48fdaf3 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -520,3 +520,28 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 }
+
+int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq;
+	bool pending = false;
+
+	if (!vcpu->kvm->arch.vgic.enabled)
+		return false;
+
+	spin_lock(&vgic_cpu->ap_list_lock);
+
+	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		spin_lock(&irq->irq_lock);
+		pending = irq->pending && irq->enabled;
+		spin_unlock(&irq->irq_lock);
+
+		if (pending)
+			break;
+	}
+
+	spin_unlock(&vgic_cpu->ap_list_lock);
+
+	return pending;
+}
-- 
2.8.2
