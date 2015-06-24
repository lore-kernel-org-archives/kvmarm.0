From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF once guest is running
Date: Wed, 24 Jun 2015 15:54:57 +0100
Message-ID: <1435157697-28579-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Userspace is allowed to set the guest's view of CNTVCT, which turns
into setting CNTVOFF for the whole VM. One thing userspace is not supposed
to do is to update that register while the guest is running. Time will
either move forward (best case) or backward (really bad idea). Either way,
this shouldn't happen.

This patch prevents userspace from touching CNTVOFF as soon as a vcpu
has been started. This ensures that time will keep monotonically increase.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---

QEMU seems to trigger this at boot time, and I have no idea why it does so.
It would be good to find out, hence the RFC tag.

 virt/kvm/arm/arch_timer.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 98c95f2..660f348 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -220,9 +220,26 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 	case KVM_REG_ARM_TIMER_CTL:
 		timer->cntv_ctl = value;
 		break;
-	case KVM_REG_ARM_TIMER_CNT:
-		vcpu->kvm->arch.timer.cntvoff = kvm_phys_timer_read() - value;
+	case KVM_REG_ARM_TIMER_CNT: {
+		struct kvm_vcpu *tmp;
+		int i;
+		u64 cntvoff = kvm_phys_timer_read() - value;
+
+		/*
+		 * If any of the vcpus has started, don't update
+		 * CNTVOFF. Userspace is severely brain damaged.
+		 */
+		kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+			if (tmp->arch.has_run_once) {
+				kvm_debug("Won't set CNTVOFF to %llx (%llx)\n",
+					  cntvoff,
+					  vcpu->kvm->arch.timer.cntvoff);
+				return -1;
+			}
+		}
+		vcpu->kvm->arch.timer.cntvoff = cntvoff;
 		break;
+	}
 	case KVM_REG_ARM_TIMER_CVAL:
 		timer->cntv_cval = value;
 		break;
-- 
2.1.4

