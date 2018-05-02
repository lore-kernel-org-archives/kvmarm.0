From: Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 1/1] KVM: arm/arm64: vgic_init: Cleanup reference to process_maintenance
Date: Wed,  2 May 2018 11:53:03 +0100
Message-ID: <1525258383-14178-1-git-send-email-valentin.schneider@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, trivial@kernel.org, christoffer.dall@arm.com, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

One comment still mentioned process_maintenance operations after
commit af0614991ab6 ("KVM: arm/arm64: vgic: Get rid of unnecessary
process_maintenance operation") 

Update the comment to point to vgic_fold_lr_state instead, which
is where maintenance interrupts are taken care of.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 743ca5c..7f1a467 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -440,7 +440,7 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	 * We cannot rely on the vgic maintenance interrupt to be
 	 * delivered synchronously. This means we can only use it to
 	 * exit the VM, and we perform the handling of EOIed
-	 * interrupts on the exit path (see vgic_process_maintenance).
+	 * interrupts on the exit path (see vgic_fold_lr_state).
 	 */
 	return IRQ_HANDLED;
 }
--
2.7.4
