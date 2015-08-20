From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/25] arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
Date: Thu, 20 Aug 2015 17:28:52 +0100
Message-ID: <1440088143-4722-15-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As we now inject the timer interrupt when we're about to enter
the guest, it makes a lot more sense to make sure this happens
before the vgic code queues the pending interrupts.

Otherwise, we get the interrupt on the following exit, which is
not great for latency (and leads to all kind of bizarre issues
when using with active interrupts at the HW level).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9ce5cf0..1141d21 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -523,8 +523,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
 		if (vcpu->arch.pause)
 			vcpu_pause(vcpu);
=20
-		kvm_vgic_flush_hwstate(vcpu);
 		kvm_timer_flush_hwstate(vcpu);
+		kvm_vgic_flush_hwstate(vcpu);
=20
 		preempt_disable();
 		local_irq_disable();
@@ -540,8 +540,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
 		if (ret <=3D 0 || need_new_vmid_gen(vcpu->kvm)) {
 			local_irq_enable();
 			preempt_enable();
-			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			kvm_timer_sync_hwstate(vcpu);
 			continue;
 		}
=20
@@ -587,9 +587,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, =
struct kvm_run *run)
 		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 		preempt_enable();
=20
-
-		kvm_timer_sync_hwstate(vcpu);
 		kvm_vgic_sync_hwstate(vcpu);
+		kvm_timer_sync_hwstate(vcpu);
=20
 		ret =3D handle_exit(vcpu, run, ret);
 	}
--=20
2.1.4

