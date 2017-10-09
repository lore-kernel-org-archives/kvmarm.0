From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] KVM: remove printing of vcpu address
Date: Mon,  9 Oct 2017 17:31:41 +1100
Message-ID: <1507530701-10777-1-git-send-email-me@tobin.cc>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, "Tobin C. Harding" <me@tobin.cc>
List-Id: kvmarm@lists.cs.columbia.edu

Code currently prints the address of the kvm_vcpu structure in an error
message. It is not immediately clear what value this address adds to
the error string, we can use the vcpu ID instead. Printing unnecessary
kernel addresses to dmesg poses a security risk.

Remove the address from error message output, show vcpu ID instead.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 virt/kvm/arm/arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 8e89d63005c7..ca6c331cad28 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -88,7 +88,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	 * interrupt at this point is a sure sign of some major
 	 * breakage.
 	 */
-	pr_warn("Unexpected interrupt %d on vcpu %p\n", irq, vcpu);
+	pr_warn("Unexpected interrupt %d on vcpu ID %d\n", irq, vcpu->vcpu_id);
 	return IRQ_HANDLED;
 }
 
-- 
2.7.4
