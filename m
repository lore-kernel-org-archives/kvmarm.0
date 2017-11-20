From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v5 1/8] KVM: arm/arm64: Remove redundant preemptible checks
Date: Mon, 20 Nov 2017 20:16:42 +0100
Message-ID: <20171120191649.17290-2-christoffer.dall@linaro.org>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120191649.17290-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The __this_cpu_read() and __this_cpu_write() functions already implement
checks for the required preemption levels when using
CONFIG_DEBUG_PREEMPT which gives you nice error messages and such.
Therefore there is no need to explicitly check this using a BUG_ON() in
the code (which we don't do for other uses of per cpu variables either).

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c13d74c083fe..28548aeaf164 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -71,7 +71,6 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
-	BUG_ON(preemptible());
 	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
 }
 
@@ -81,7 +80,6 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
  */
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
 {
-	BUG_ON(preemptible());
 	return __this_cpu_read(kvm_arm_running_vcpu);
 }
 
-- 
2.14.2
