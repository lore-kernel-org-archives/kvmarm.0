From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 15/17] KVM: arm/arm64: implement IRQ bypass consumer functions
Date: Thu,  2 Jul 2015 15:17:25 +0200
Message-ID: <1435843047-6327-16-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

- kvm_arch_add_producer: perform VGIC/irqchip settings for forwarding
- kvm_arch_del_producer: same for inverse operation
- kvm_arch_stop_consumer: halt guest execution
- kvm_arch_resume_consumer resume guest execution

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/kvm/arm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 4be6715..f9b9b1e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1146,6 +1146,28 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	return NULL;
 }
 
+void kvm_arch_add_producer(struct irq_bypass_consumer *cons,
+			   struct irq_bypass_producer *prod)
+{
+	kvm_vgic_set_forward(cons->kvm, prod->irq, cons->gsi);
+}
+void kvm_arch_del_producer(struct irq_bypass_consumer *cons,
+			   struct irq_bypass_producer *prod)
+{
+	kvm_vgic_unset_forward(cons->kvm, prod->irq, cons->gsi,
+			       &prod->active);
+}
+
+void kvm_arch_stop_consumer(struct irq_bypass_consumer *cons)
+{
+	kvm_arm_halt_guest(cons->kvm);
+}
+
+void kvm_arch_resume_consumer(struct irq_bypass_consumer *cons)
+{
+	kvm_arm_resume_guest(cons->kvm);
+}
+
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
-- 
1.9.1
