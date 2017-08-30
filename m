From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 51/59] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Wed, 30 Aug 2017 22:58:28 +0200
Message-ID: <20170830205828.GN24522@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-52-marc.zyngier@arm.com>
 <20170828181855.GM24649@cbox>
 <6d825d0f-eb99-8c9f-77f7-ab313e17a2cd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6d825d0f-eb99-8c9f-77f7-ab313e17a2cd@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 04:36:06PM +0100, Marc Zyngier wrote:
> On 28/08/17 19:18, Christoffer Dall wrote:
> > On Mon, Jul 31, 2017 at 06:26:29PM +0100, Marc Zyngier wrote:
> >> When a vPE is not running, a VLPI being made pending results in a
> >> doorbell interrupt being delivered. Let's handle this interrupt
> >> and update the pending_last flag that indicates that VLPIs are
> >> pending. The corresponding vcpu is also kicked into action.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-v4.c | 34 ++++++++++++++++++++++++++++++++++
> >>  1 file changed, 34 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> >> index 534d3051a078..6af3cde6d7d4 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v4.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> >> @@ -21,6 +21,19 @@
> >>  
> >>  #include "vgic.h"
> >>  
> >> +static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
> >> +{
> >> +	struct kvm_vcpu *vcpu = info;
> >> +
> >> +	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
> >> +		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
> >> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> >> +		kvm_vcpu_kick(vcpu);
> >> +	}
> > 
> > Can this ever fire while vgic_v4_init() is running and before te rest of
> > the system has been properly initialized with some entertaining results
> > to follow?  (I'm not sure if spurious doorbell non-resident vPE
> > interrupts is a thing or not).
> 
> It could if you only had this patch. The following patch makes sure that
> the interrupt does not get enabled at request time, meaning it will only
> get enabled when the vcpu will eventually block.
> 
> And yes, spurious doorbells are a real thing. And they suck.
> 

Ah, my abilities to forward read on a patch series are quite poor.

Thanks,
-Christoffer
