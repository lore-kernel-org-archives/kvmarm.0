From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 83/85] KVM: arm/arm64: vgic-its: Fix potential overrun in
 vgic_copy_lpi_list
Date: Wed, 28 Mar 2018 13:52:52 +0100
Message-ID: <20180328125254.31380-84-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1629E4A0BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:03:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0HdLZ5dDnmUV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:02:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B7F84A07A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:38 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

vgic_copy_lpi_list() parses the LPI list and picks LPIs targeting
a given vcpu. We allocate the array containing the intids before taking
the lpi_list_lock, which means we can have an array size that is not
equal to the number of LPIs.

This is particularly obvious when looking at the path coming from
vgic_enable_lpis, which is not a command, and thus can run in parallel
with commands:

vcpu 0:                                        vcpu 1:
vgic_enable_lpis
  its_sync_lpi_pending_table
    vgic_copy_lpi_list
      intids = kmalloc_array(irq_count)
                                               MAPI(lpi targeting vcpu 0)
      list_for_each_entry(lpi_list_head)
        intids[i++] = irq->intid;

At that stage, we will happily overrun the intids array. Boo. An easy
fix is is to break once the array is full. The MAPI command will update
the config anyway, and we won't miss a thing. We also make sure that
lpi_list_count is read exactly once, so that further updates of that
value will not affect the array bound check.

Cc: stable@vger.kernel.org
Fixes: ccb1d791ab9e ("KVM: arm64: vgic-its: Fix pending table sync")
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 465095355666..a8f07243aa9f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -316,21 +316,24 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_irq *irq;
 	u32 *intids;
-	int irq_count = dist->lpi_list_count, i = 0;
+	int irq_count, i = 0;
 
 	/*
-	 * We use the current value of the list length, which may change
-	 * after the kmalloc. We don't care, because the guest shouldn't
-	 * change anything while the command handling is still running,
-	 * and in the worst case we would miss a new IRQ, which one wouldn't
-	 * expect to be covered by this command anyway.
+	 * There is an obvious race between allocating the array and LPIs
+	 * being mapped/unmapped. If we ended up here as a result of a
+	 * command, we're safe (locks are held, preventing another
+	 * command). If coming from another path (such as enabling LPIs),
+	 * we must be careful not to overrun the array.
 	 */
+	irq_count = READ_ONCE(dist->lpi_list_count);
 	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL);
 	if (!intids)
 		return -ENOMEM;
 
 	spin_lock(&dist->lpi_list_lock);
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		if (i == irq_count)
+			break;
 		/* We don't need to "get" the IRQ, as we hold the list lock. */
 		if (irq->target_vcpu != vcpu)
 			continue;
-- 
2.14.2
