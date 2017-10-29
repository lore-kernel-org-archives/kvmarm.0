From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v5 21/20] arm/arm64: KVM: Load the timer state when enabling the timer
Date: Sun, 29 Oct 2017 02:48:56 +0100
Message-ID: <1509241736-99913-1-git-send-email-christoffer.dall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
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

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 2035cf2..4db54ff 100644
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
2.7.4
