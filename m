From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Sun, 11 Mar 2018 12:17:33 +0000
Message-ID: <20180311121733.643fb1a5@why.wild-wind.fr.eu.org>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
        <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
        <0a15633d-8944-cb9b-3e6b-b08ee5ec42b9@arm.com>
        <20180308161900.GC1917@lvm>
        <86r2oubho3.wl-marc.zyngier@arm.com>
        <20180309213612.GD1917@lvm>
        <86k1ukazr0.wl-marc.zyngier@arm.com>
        <CAEDV+g+29ZK6QQEn=2h_77dMZC7wmw+d4MZC-GU-CqeaK_xhMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEDV+g+29ZK6QQEn=2h_77dMZC7wmw+d4MZC-GU-CqeaK_xhMg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@kernel.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Auger Eric <eric.auger@redhat.com>, david.daney@cavium.com, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, linux-kernel <linux-kernel@vger.kernel.org>, Joey Zheng <yu.zheng@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, 11 Mar 2018 01:55:08 +0000
Christoffer Dall <cdall@kernel.org> wrote:

> On Sat, Mar 10, 2018 at 12:20 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On Fri, 09 Mar 2018 21:36:12 +0000,
> > Christoffer Dall wrote:  
> >>
> >> On Thu, Mar 08, 2018 at 05:28:44PM +0000, Marc Zyngier wrote:  
> >> > I'd be more confident if we did forbid P+A for such interrupts
> >> > altogether, as they really feel like another kind of HW interrupt.  
> >>
> >> How about a slightly bigger hammer:  Can we avoid doing P+A for level
> >> interrupts completely?  I don't think that really makes much sense, and
> >> I think we simply everything if we just come back out and resample the
> >> line.  For an edge, something like a network card, there's a potential
> >> performance win to appending a new pending state, but I doubt that this
> >> is the case for level interrupts.  
> >
> > I started implementing the same thing yesterday. Somehow, it feels
> > slightly better to have the same flow for all level interrupts,
> > including the timer, and we only use the MI on EOI as a way to trigger
> > the next state of injection. Still testing, but looking good so far.
> >
> > I'm still puzzled that we have this level-but-not-quite behaviour for
> > VFIO interrupts. At some point, it is going to bite us badly.
> >  
> 
> Where is the departure from level-triggered behavior with VFIO?  As
> far as I can tell, the GIC flow of the interrupts will be just a level
> interrupt, 

The GIC is fine, I believe. What is not exactly fine is the signalling
from the device, which will never be dropped until the EOI has been
detected.

> but we just need to make sure the resamplefd mechanism is
> supported for both types of interrupts.  Whether or not that's a
> decent mechanism seems orthogonal to me, but that's a discussion for
> another day I think.

Given that VFIO is built around this mechanism, I don't think we have a
choice but to support it. Anyway, I came up with the following patch,
which I tested on Seattle with mtty. It also survived my usual
hammering of cyclictest, hackbench  and bulk VM installs.

Shunyong, could you please give it a go?

Thanks,

	M.

>From 9ca96b9fb535cc6ab578bda85c4ecbc4a8c63cd7 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Fri, 9 Mar 2018 14:59:40 +0000
Subject: [PATCH] KVM: arm/arm64: vgic: Disallow Active+Pending for level
 interrupts

It was recently reported that VFIO mediated devices, and anything
that VFIO exposes as level interrupts, do no strictly follow the
expected logic of such interrupts as it only lowers the input
line when the guest has EOId the interrupt at the GIC level, rather
than when it Acked the interrupt at the device level.

The GIC's Active+Pending state is fundamentally incompatible with
this behaviour, as it prevents KVM from observing the EOI, and in
turn results in VFIO never dropping the line. This results in an
interrupt storm in the guest, which it really never expected.

As we cannot really change VFIO to follow the strict rules of level
signalling, let's forbid the A+P state altogether, as it is in the
end only an optimization. It ensures that we will transition via
an invalid state, which we can use to notify VFIO of the EOI.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 47 +++++++++++++++++++++++++++------------------
 virt/kvm/arm/vgic/vgic-v3.c | 47 +++++++++++++++++++++++++++------------------
 2 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 29556f71b691..9356d749da1d 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -153,8 +153,35 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
 	u32 val = irq->intid;
+	bool allow_pending = true;
 
-	if (irq_is_pending(irq)) {
+	if (irq->active)
+		val |= GICH_LR_ACTIVE_BIT;
+
+	if (irq->hw) {
+		val |= GICH_LR_HW;
+		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active)
+			allow_pending = false;
+	} else {
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			val |= GICH_LR_EOI;
+
+			/*
+			 * Software resampling doesn't work very well
+			 * if we allow P+A, so let's not do that.
+			 */
+			if (irq->active)
+				allow_pending = false;
+		}
+	}
+
+	if (allow_pending && irq_is_pending(irq)) {
 		val |= GICH_LR_PENDING_BIT;
 
 		if (irq->config == VGIC_CONFIG_EDGE)
@@ -171,24 +198,6 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		}
 	}
 
-	if (irq->active)
-		val |= GICH_LR_ACTIVE_BIT;
-
-	if (irq->hw) {
-		val |= GICH_LR_HW;
-		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
-		/*
-		 * Never set pending+active on a HW interrupt, as the
-		 * pending state is kept at the physical distributor
-		 * level.
-		 */
-		if (irq->active && irq_is_pending(irq))
-			val &= ~GICH_LR_PENDING_BIT;
-	} else {
-		if (irq->config == VGIC_CONFIG_LEVEL)
-			val |= GICH_LR_EOI;
-	}
-
 	/*
 	 * Level-triggered mapped IRQs are special because we only observe
 	 * rising edges as input to the VGIC.  We therefore lower the line
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 0ff2006f3781..6b484575cafb 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -135,8 +135,35 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u64 val = irq->intid;
+	bool allow_pending = true;
 
-	if (irq_is_pending(irq)) {
+	if (irq->active)
+		val |= ICH_LR_ACTIVE_BIT;
+
+	if (irq->hw) {
+		val |= ICH_LR_HW;
+		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active)
+			allow_pending = false;
+	} else {
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			val |= ICH_LR_EOI;
+
+			/*
+			 * Software resampling doesn't work very well
+			 * if we allow P+A, so let's not do that.
+			 */
+			if (irq->active)
+				allow_pending = false;
+		}
+	}
+
+	if (allow_pending && irq_is_pending(irq)) {
 		val |= ICH_LR_PENDING_BIT;
 
 		if (irq->config == VGIC_CONFIG_EDGE)
@@ -154,24 +181,6 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		}
 	}
 
-	if (irq->active)
-		val |= ICH_LR_ACTIVE_BIT;
-
-	if (irq->hw) {
-		val |= ICH_LR_HW;
-		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
-		/*
-		 * Never set pending+active on a HW interrupt, as the
-		 * pending state is kept at the physical distributor
-		 * level.
-		 */
-		if (irq->active && irq_is_pending(irq))
-			val &= ~ICH_LR_PENDING_BIT;
-	} else {
-		if (irq->config == VGIC_CONFIG_LEVEL)
-			val |= ICH_LR_EOI;
-	}
-
 	/*
 	 * Level-triggered mapped IRQs are special because we only observe
 	 * rising edges as input to the VGIC.  We therefore lower the line
-- 
2.14.2


-- 
Without deviation from the norm, progress is not possible.
