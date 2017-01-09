From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 30/55] KVM: arm/arm64: Inject irqs to the guest hypervisor
Date: Mon,  9 Jan 2017 01:24:26 -0500
Message-ID: <1483943091-1364-31-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACE8A40194
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DGfs2uSxo3Ci for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:29 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4958408B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:29 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9MG018083
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:11 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 6A6E786
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:11 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 294F58E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:11 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QAe5005252
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:11 -0500
Received: by mail-qt0-f197.google.com with SMTP id k15so94307682qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:10 -0800 (PST)
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

If we have a pending IRQ for the guest and the guest expects IRQs
to be handled in its virtual EL2 mode (the virtual IMO bit is set)
and it is not already running in virtual EL2 mode, then we have to
emulate an IRQ exception.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 6440b56..4a98654 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -17,6 +17,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/list_sort.h>
+#include <asm/kvm_emulate.h>
 
 #include "vgic.h"
 
@@ -652,6 +653,28 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	/* Nuke remaining LRs */
 	for ( ; count < kvm_vgic_global_state.nr_lr; count++)
 		vgic_clear_lr(vcpu, count);
+
+	/*
+	 * If we have any pending IRQ for the guest and the guest expects IRQs
+	 * to be handled in its virtual EL2 mode (the virtual IMO bit is set)
+	 * and it is not already running in virtual EL2 mode, then we have to
+	 * emulate an IRQ exception to virtual IRQ. Note that a pending IRQ
+	 * means an irq of which state is pending but not active.
+	 */
+	if (vcpu_el2_imo_is_set(vcpu) && !vcpu_mode_el2(vcpu)) {
+		bool pending = false;
+
+		list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+			spin_lock(&irq->irq_lock);
+			pending = irq->pending && irq->enabled && !irq->active;
+			spin_unlock(&irq->irq_lock);
+
+			if (pending) {
+				kvm_inject_nested_irq(vcpu);
+				break;
+			}
+		}
+	}
 }
 
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
-- 
1.9.1
