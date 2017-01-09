From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 26/55] KVM: arm/arm64: Add VGIC data structures for the nesting
Date: Mon,  9 Jan 2017 01:24:22 -0500
Message-ID: <1483943091-1364-27-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E744F407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wxak-Ldsy4GB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:26 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2B33403F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:24 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5s9017972
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:06 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 4817F87
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:06 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 150C38C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:06 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5Am041113
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:06 -0500
Received: by mail-qk0-f199.google.com with SMTP id 11so31131373qkl.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:05 -0800 (PST)
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

From: Christoffer Dall <christoffer.dall@linaro.org>

This adds a couple of extra data structures:

The nested_vgic_vX structures contain the data manipulated by the guest
hypervisor when it faults/traps on accesses to the GICH_ interface.

The shadow_vgic_vX arrays contain the shadow copies of the LRs.  That
is, it is a modified version of the nested_vgic_vX->vgic_lr.  The reason
why we need a modified version is that for interrupts with the HW bit
set (those for the timer) the interrupt number must be that of the host
hardware number, and not the virtual one programmed by the guest
hypervisor.

The hw_vX_cpu_if pointers point to the registers that the lowvisor (EL2)
code actually copied into hardware when switching to the guest, so at
init time we set:

vgic_cpu->hw_v2_cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;

And we should change the vgic-sr function to read the LRs from the
hw_v2_lr pointer.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 include/kvm/arm_vgic.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 002f092..9a9cb27 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -246,6 +246,26 @@ struct vgic_cpu {
 	unsigned int used_lrs;
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
+	/* CPU vif control registers for the virtual GICH interface */
+	union {
+		struct vgic_v2_cpu_if	nested_vgic_v2;
+		struct vgic_v3_cpu_if	nested_vgic_v3;
+	};
+
+	/*
+	 * The shadow vif control register loaded to the hardware when
+	 * running a sted L2 guest with the virtual IMO bit set.
+	 */
+	union {
+		struct vgic_v2_cpu_if	shadow_vgic_v2;
+		struct vgic_v3_cpu_if	shadow_vgic_v3;
+	};
+
+	union {
+		struct vgic_v2_cpu_if	*hw_v2_cpu_if;
+		struct vgic_v3_cpu_if	*hw_v3_cpu_if;
+	};
+
 	spinlock_t ap_list_lock;	/* Protects the ap_list */
 
 	/*
-- 
1.9.1
