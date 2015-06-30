From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 05/10] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq
 for edge IRQs
Date: Tue, 30 Jun 2015 22:19:33 +0200
Message-ID: <20150630201933.GA11332@cbox>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433783045-8002-6-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 08, 2015 at 06:04:00PM +0100, Marc Zyngier wrote:
> We only set the irq_queued flag for level interrupts, meaning
> that "!vgic_irq_is_queued(vcpu, irq)" is a good enough predicate
> for all interrupts.
> 
> This will allow us to inject edge HW interrupts, for which the
> state ACTIVE+PENDING is not allowed.

I don't understand this; ACTIVE+PENDING is allowed for edge interrupts.
Do you mean that if we set the HW bit in the LR, then we are linking to
an HW interrupt where we don't allow that to be ACTIVE+PENDING on the HW
GIC side?

Why is this relevant here?  I feel like I'm missing context.

Thanks,
-Christoffer

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 78fb820..59ed7a3 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -377,7 +377,7 @@ void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
>  
>  static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
>  {
> -	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq);
> +	return !vgic_irq_is_queued(vcpu, irq);
>  }
>  
>  /**
> -- 
> 2.1.4
> 
