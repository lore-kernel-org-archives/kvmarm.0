From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/10] KVM: arm/arm64: Let vcpu thread modify its own active
 state
Date: Thu,  9 Mar 2017 09:55:32 +0000
Message-ID: <20170309095539.14512-4-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B06240BC4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:54:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TUGM61SxgW02 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:54:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 636D140625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:54:51 -0500 (EST)
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Linu Cherian <linu.cherian@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack Lim <jintack@cs.columbia.edu>

Currently, if a vcpu thread tries to change the active state of an
interrupt which is already on the same vcpu's AP list, it will loop
forever. Since the VGIC mmio handler is called after a vcpu has
already synced back the LR state to the struct vgic_irq, we can just
let it proceed safely.

Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3654b4c835ef..2a5db1352722 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -180,21 +180,37 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool new_active_state)
 {
+	struct kvm_vcpu *requester_vcpu;
 	spin_lock(&irq->irq_lock);
+
+	/*
+	 * The vcpu parameter here can mean multiple things depending on how
+	 * this function is called; when handling a trap from the kernel it
+	 * depends on the GIC version, and these functions are also called as
+	 * part of save/restore from userspace.
+	 *
+	 * Therefore, we have to figure out the requester in a reliable way.
+	 *
+	 * When accessing VGIC state from user space, the requester_vcpu is
+	 * NULL, which is fine, because we guarantee that no VCPUs are running
+	 * when accessing VGIC state from user space so irq->vcpu->cpu is
+	 * always -1.
+	 */
+	requester_vcpu = kvm_arm_get_running_vcpu();
+
 	/*
 	 * If this virtual IRQ was written into a list register, we
 	 * have to make sure the CPU that runs the VCPU thread has
-	 * synced back LR state to the struct vgic_irq.  We can only
-	 * know this for sure, when either this irq is not assigned to
-	 * anyone's AP list anymore, or the VCPU thread is not
-	 * running on any CPUs.
+	 * synced back the LR state to the struct vgic_irq.
 	 *
-	 * In the opposite case, we know the VCPU thread may be on its
-	 * way back from the guest and still has to sync back this
-	 * IRQ, so we release and re-acquire the spin_lock to let the
-	 * other thread sync back the IRQ.
+	 * As long as the conditions below are true, we know the VCPU thread
+	 * may be on its way back from the guest (we kicked the VCPU thread in
+	 * vgic_change_active_prepare)  and still has to sync back this IRQ,
+	 * so we release and re-acquire the spin_lock to let the other thread
+	 * sync back the IRQ.
 	 */
 	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
+	       irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
-- 
2.11.0
