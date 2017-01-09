From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 25/55] KVM: arm/arm64: Let vcpu thread modify its own active
 state
Date: Mon,  9 Jan 2017 01:24:21 -0500
Message-ID: <1483943091-1364-26-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E617E404FF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SCFOSu7sHdTs for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:26 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 515C54079A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:24 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWu5005289
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:05 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id DEECD8A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:05 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id E2B858A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:04 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q4rA042321
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:04 -0500
Received: by mail-qt0-f198.google.com with SMTP id f4so58596776qte.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:04 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently, if a vcpu thread tries to change its own active state when
the irq is already in AP list, it'll loop forever. Since the VCPU thread
has already synced back LR state to the struct vgic_irq, let it modify
its own state safely.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ebe1b9f..049c570 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -192,9 +192,9 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * If this virtual IRQ was written into a list register, we
 	 * have to make sure the CPU that runs the VCPU thread has
 	 * synced back LR state to the struct vgic_irq.  We can only
-	 * know this for sure, when either this irq is not assigned to
+	 * know this for sure, when this irq is not assigned to
 	 * anyone's AP list anymore, or the VCPU thread is not
-	 * running on any CPUs.
+	 * running on any CPUs, or current thread is the VCPU thread.
 	 *
 	 * In the opposite case, we know the VCPU thread may be on its
 	 * way back from the guest and still has to sync back this
@@ -202,6 +202,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * other thread sync back the IRQ.
 	 */
 	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
+	       irq->vcpu != vcpu && /* Current thread is not the VCPU thread */
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
-- 
1.9.1
