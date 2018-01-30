From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 2/3] KVM: arm/arm64: Fix userspace_irqchip_in_use counting
Date: Tue, 30 Jan 2018 13:42:05 +0100
Message-ID: <20180130124206.12262-3-christoffer.dall@linaro.org>
References: <20180130124206.12262-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180130124206.12262-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We were not decrementing the static key count in the right location.
kvm_arch_vcpu_destroy() is only called to clean up after a failed
VCPU create attempt, whereas kvm_arch_vcpu_free() is called on teardown
of the VM as well.  Move the static key decrement call to
kvm_arch_vcpu_free().

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 639dca0c0560..04ee7a327870 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -295,6 +295,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		static_branch_dec(&userspace_irqchip_in_use);
+
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
@@ -304,8 +307,6 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		static_branch_dec(&userspace_irqchip_in_use);
 	kvm_arch_vcpu_free(vcpu);
 }
 
-- 
2.14.2
