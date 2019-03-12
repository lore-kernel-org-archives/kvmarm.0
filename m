From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm64: fix potential bug
Date: Tue, 12 Mar 2019 01:42:47 +0000
Message-ID: <2405014d-9370-c0d5-7a44-7ec336098c45@arm.com>
References: <20190312003243.6712-1-johngong0791@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190312003243.6712-1-johngong0791@gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: John Gong <johngong0791@gmail.com>, christoffer.dall@arm.com
Cc: Shengmin Gong <shengmin.gong@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, Julien Thierry <julien.thierry@arm.com>, Jia He <hejianet@gmail.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/03/2019 00:32, John Gong wrote:
Hi,

> Since intid always >= VGIC_NR_PRIVATE_IRQS,

How so? The PMU and the arch timer emulation use PPIs, so intid is
definitely < VGIC_NR_PRIVATE_IRQS there.

> so then even vcpu == NULL, it never return -EINVAL.

I am not sure I follow.
To uniquely identify an SPI interrupt, we just need the interrupt ID
(which is always >= 32). For PPIs and SGIs, we additionally need the
vCPU ID this private interrupt belongs to, as there are multiple
interrupts with the same INTID (one per VCPU).
The VCPU ID passed in for SPIs is just a dummy value (because we use the
same function to inject private and shared interrupts), so we don't need
to check for its validity.

Cheers,
Andre.

> 
> Signed-off-by: Shengmin Gong <shengmin.gong@gmail.com>
> Signed-off-by: John Gong <johngong0791@gmail.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index abd9c7352677..d3cb1ce880e2 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -424,7 +424,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  		return ret;
>  
>  	vcpu = kvm_get_vcpu(kvm, cpuid);
> -	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
> +	if (!vcpu)
>  		return -EINVAL;
>  
>  	irq = vgic_get_irq(kvm, vcpu, intid);
> 
