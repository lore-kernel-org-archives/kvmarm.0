From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v9 4/6] KVM: Move kvm_setup_default/empty_irq_routing declaration in arch specific header
Date: Fri, 22 Jul 2016 16:20:40 +0000
Message-ID: <1469204442-3220-5-git-send-email-eric.auger@redhat.com>
References: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

kvm_setup_default_irq_routing and kvm_setup_empty_irq_routing are
not used by generic code. So let's move the declarations in x86 irq.h
header instead of kvm_host.h.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Andre Przywara <andre.przywara@arm.com>

---

- new patch in v7
---
 arch/x86/kvm/irq.h       | 3 +++
 include/linux/kvm_host.h | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 61ebdc1..035731e 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -120,4 +120,7 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
 
 int apic_has_pending_timer(struct kvm_vcpu *vcpu);
 
+int kvm_setup_default_irq_routing(struct kvm *kvm);
+int kvm_setup_empty_irq_routing(struct kvm *kvm);
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e33e85e..49e8152 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1044,8 +1044,6 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 #define KVM_MAX_IRQ_ROUTES 1024
 #endif
 
-int kvm_setup_default_irq_routing(struct kvm *kvm);
-int kvm_setup_empty_irq_routing(struct kvm *kvm);
 int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *entries,
 			unsigned nr,
-- 
1.9.1

