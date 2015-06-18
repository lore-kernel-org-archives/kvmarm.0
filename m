From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic: Avoid injecting reserved IRQ numbers
Date: Thu, 18 Jun 2015 15:56:30 +0100
Message-ID: <1434639390-10450-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C764A55ED1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcDyI-A-U-iv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 10:45:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A780655ED0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:45:55 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Commit fd1d0ddf2ae9 (KVM: arm/arm64: check IRQ number on userland
injection) rightly limited the range of interrupts userspace can
inject in a guest, but failed to consider the (unlikely) case where
a guest is configured with 1024 interrupts.

In this case, interrupts ranging from 1020 to 1023 are unuseable,
as they have a special meaning for the GIC CPU interface.

Make sure that these number cannot be used as an IRQ. Also delete
a redundant (and similarily buggy) check in kvm_set_irq.

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: <stable@vger.kernel.org> # 4.1, 4.0, 3.19, 3.18
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 78fb820..950064a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1561,7 +1561,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 			goto out;
 	}
 
-	if (irq_num >= kvm->arch.vgic.nr_irqs)
+	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
 		return -EINVAL;
 
 	vcpu_id = vgic_update_irq_pending(kvm, cpuid, irq_num, level);
@@ -2161,10 +2161,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id,
 
 	BUG_ON(!vgic_initialized(kvm));
 
-	if (spi > kvm->arch.vgic.nr_irqs)
-		return -EINVAL;
 	return kvm_vgic_inject_irq(kvm, 0, spi, level);
-
 }
 
 /* MSI not implemented yet */
-- 
2.1.4
