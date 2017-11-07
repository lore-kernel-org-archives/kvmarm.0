From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 19/26] arm/arm64: KVM: Load the timer state when enabling the timer
Date: Tue,  7 Nov 2017 11:47:52 +0100
Message-ID: <20171107104800.30021-20-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

After being lazy with saving/restoring the timer state, we defer that
work to vcpu_load and vcpu_put, which ensure that the timer state is
loaded on the hardware timers whenever the VCPU runs.

Unfortunately, we are failing to do that the first time vcpu_load()
runs, because the timer has not yet been enabled at that time.  As long
as the initialized timer state matches what happens to be in the
hardware (a disabled timer, because we never leave the timer screaming),
this does not show up as a problem, but is nevertheless incorrect.

The solution is simple; disable preemption while setting the timer to be
enabled, and call the timer load function when first enabling the timer.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 2035cf251701..4db54ff08d9e 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -861,7 +861,11 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return ret;
 
 no_vgic:
+	preempt_disable();
 	timer->enabled = 1;
+	kvm_timer_vcpu_load_vgic(vcpu);
+	preempt_enable();
+
 	return 0;
 }
 
-- 
2.14.2
