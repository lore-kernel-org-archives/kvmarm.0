From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 51/59] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Fri, 4 Aug 2017 08:44:04 +0100
Message-ID: <8a35ee18-85a5-168b-b3d2-b9f51390b475@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-52-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-52-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/07/17 18:26, Marc Zyngier wrote:
> When a vPE is not running, a VLPI being made pending results in a
> doorbell interrupt being delivered. Let's handle this interrupt
> and update the pending_last flag that indicates that VLPIs are
> pending. The corresponding vcpu is also kicked into action.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v4.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 534d3051a078..6af3cde6d7d4 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -21,6 +21,19 @@
>  
>  #include "vgic.h"
>  
> +static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
> +{
> +	struct kvm_vcpu *vcpu = info;
> +
> +	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
> +		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +		kvm_vcpu_kick(vcpu);
> +	}

This code is so obviously broken that I completely overlooked it.

If we have take a doorbell interrupt, then it means nothing was
otherwise pending (because we'd have been kicked out of the blocking
state, and will have masked the doorbell). So checking for pending
interrupts is pointless.

Furthermore, calling kvm_vgic_vcpu_pending_irq() takes the ap_list
lock. If we take a doorbell interrupt while injecting a virtual
interrupt (from userspace, for example) on the same CPU, we end-up
in deadlock land. This would be solved by Christoffer's latest
crop of timer patches, but there is no point getting there the first
place.

The patchlet below solves it:

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 15feb1151797..48e4d6ebeaa8 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -94,11 +94,9 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 {
 	struct kvm_vcpu *vcpu = info;
 
-	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
-		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
-		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
-		kvm_vcpu_kick(vcpu);
-	}
+	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
 
 	return IRQ_HANDLED;
 }

and I've queued it for the next round.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
