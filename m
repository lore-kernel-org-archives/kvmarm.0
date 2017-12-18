From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 5/5] KVM: arm/arm64: Fix timer enable flow
Date: Mon, 18 Dec 2017 11:00:57 +0100
Message-ID: <20171218100057.7839-6-christoffer.dall@linaro.org>
References: <20171218100057.7839-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171218100057.7839-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When enabling the timer on the first run, we fail to ever restore the
state and mark it as loaded.  That means, that in the initial entry to
the VCPU ioctl, unless we exit to userspace for some reason such as a
pending signal, if the guest programs a timer and blocks, we will wait
forever, because we never read back the hardware state (the loaded flag
is not set), and so we think the timer is disabled, and we never
schedule a background soft timer.

The end result?  The VCPU blocks forever, and the only solution is to
kill the thread.

Fixes: 4a2c4da1250d ("arm/arm64: KVM: Load the timer state when enabling the timer")
Reported-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 14c018f990a7..cc29a8148328 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -846,10 +846,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 no_vgic:
 	preempt_disable();
 	timer->enabled = 1;
-	if (!irqchip_in_kernel(vcpu->kvm))
-		kvm_timer_vcpu_load_user(vcpu);
-	else
-		kvm_timer_vcpu_load_vgic(vcpu);
+	kvm_timer_vcpu_load(vcpu);
 	preempt_enable();
 
 	return 0;
-- 
2.14.2
