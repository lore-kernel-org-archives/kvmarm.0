From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/10] KVM: arm/arm64: vgic-v3: Don't pretend to support
 IRQ/FIQ bypass
Date: Thu,  9 Mar 2017 09:55:31 +0000
Message-ID: <20170309095539.14512-3-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC2F40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:54:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1+IL+mbtokY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:54:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 798C140BE3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:54:46 -0500 (EST)
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

Our GICv3 emulation always presents ICC_SRE_EL1 with DIB/DFB set to
zero, which implies that there is a way to bypass the GIC and
inject raw IRQ/FIQ by driving the CPU pins.

Of course, we don't allow that when the GIC is configured, but
we fail to indicate that to the guest. The obvious fix is to
set these bits (and never let them being changed again).

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 2 ++
 virt/kvm/arm/vgic/vgic-v3.c        | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 672cfef72fc8..97cbca19430d 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -373,6 +373,8 @@
 #define ICC_IGRPEN0_EL1_MASK		(1 << ICC_IGRPEN0_EL1_SHIFT)
 #define ICC_IGRPEN1_EL1_SHIFT		0
 #define ICC_IGRPEN1_EL1_MASK		(1 << ICC_IGRPEN1_EL1_SHIFT)
+#define ICC_SRE_EL1_DIB			(1U << 2)
+#define ICC_SRE_EL1_DFB			(1U << 1)
 #define ICC_SRE_EL1_SRE			(1U << 0)
 
 /*
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index edc6ee2dc852..be0f4c3e0142 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -229,10 +229,13 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	/*
 	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
 	 * way, so we force SRE to 1 to demonstrate this to the guest.
+	 * Also, we don't support any form of IRQ/FIQ bypass.
 	 * This goes with the spec allowing the value to be RAO/WI.
 	 */
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
-		vgic_v3->vgic_sre = ICC_SRE_EL1_SRE;
+		vgic_v3->vgic_sre = (ICC_SRE_EL1_DIB |
+				     ICC_SRE_EL1_DFB |
+				     ICC_SRE_EL1_SRE);
 		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
 	} else {
 		vgic_v3->vgic_sre = 0;
-- 
2.11.0
