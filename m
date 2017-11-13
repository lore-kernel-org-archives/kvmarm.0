From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 19/27] KVM: arm/arm64: GICv4: Use the doorbell interrupt as an
 unblocking source
Date: Mon, 13 Nov 2017 10:17:44 +0100
Message-ID: <20171113091752.10663-20-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58DBA49DAF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EbbunWwqL5e6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:14 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ADA149DA9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:14 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id r68so13278607wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:25 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The doorbell interrupt is only useful if the vcpu is blocked on WFI.
In all other cases, recieving a doorbell interrupt is just a waste
of cycles.

So let's only enable the doorbell if a vcpu is getting blocked,
and disable it when it is unblocked. This is very similar to
what we're doing for the background timer.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h      |  3 +++
 virt/kvm/arm/arm.c          |  2 ++
 virt/kvm/arm/vgic/vgic-v4.c | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2f750c770bf2..8c896540a72c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -381,4 +381,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 				 struct kvm_kernel_irq_routing_entry *irq_entry);
 
+void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
+void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 34a15c0c65ab..01e575b9f78b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -315,11 +315,13 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_schedule(vcpu);
+	kvm_vgic_v4_enable_doorbell(vcpu);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_unschedule(vcpu);
+	kvm_vgic_v4_disable_doorbell(vcpu);
 }
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 796e00c77903..1375a53054b9 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -233,3 +233,21 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	mutex_unlock(&its->its_lock);
 	return ret;
 }
+
+void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vgic_supports_direct_msis(vcpu->kvm)) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		if (irq)
+			enable_irq(irq);
+	}
+}
+
+void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vgic_supports_direct_msis(vcpu->kvm)) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		if (irq)
+			disable_irq(irq);
+	}
+}
-- 
2.14.2
