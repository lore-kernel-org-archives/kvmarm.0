From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 24/28] KVM: arm/arm64: Handle CPU_PM_ENTER_FAILED
Date: Wed, 31 Jan 2018 10:35:03 +0100
Message-ID: <20180131093507.22219-25-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, James Morse <james.morse@arm.com>, stable@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

cpu_pm_enter() calls the pm notifier chain with CPU_PM_ENTER, then if
there is a failure: CPU_PM_ENTER_FAILED.

When KVM receives CPU_PM_ENTER it calls cpu_hyp_reset() which will
return us to the hyp-stub. If we subsequently get a CPU_PM_ENTER_FAILED,
KVM does nothing, leaving the CPU running with the hyp-stub, at odds
with kvm_arm_hardware_enabled.

Add CPU_PM_ENTER_FAILED as a fallthrough for CPU_PM_EXIT, this reloads
KVM based on kvm_arm_hardware_enabled. This is safe even if CPU_PM_ENTER
never gets as far as KVM, as cpu_hyp_reinit() calls cpu_hyp_reset()
to make sure the hyp-stub is loaded before reloading KVM.

Fixes: 67f691976662 ("arm64: kvm: allows kvm cpu hotplug")
Cc: <stable@vger.kernel.org> # v4.7+
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 59d8e04c19fa..639dca0c0560 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1262,6 +1262,7 @@ static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 			cpu_hyp_reset();
 
 		return NOTIFY_OK;
+	case CPU_PM_ENTER_FAILED:
 	case CPU_PM_EXIT:
 		if (__this_cpu_read(kvm_arm_hardware_enabled))
 			/* The hardware was enabled before suspend. */
-- 
2.14.2
