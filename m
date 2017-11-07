From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 14/26] KVM: arm/arm64: GICv4: Handle CLEAR applied to a
 VLPI
Date: Tue, 7 Nov 2017 22:04:59 +0100
Message-ID: <5bb9dd2f-2fdf-b705-56c2-f3829a7e86ad@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-15-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-15-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 27/10/2017 16:28, Marc Zyngier wrote:
> Handling CLEAR is pretty easy. Just ask the ITS driver to clear
> the corresponding pending bit (which will turn into a CLEAR
> command on the physical side).
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 42ffb9084bb7..5778b50911e8 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1070,6 +1070,10 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
>  
>  	ite->irq->pending_latch = false;
>  
> +	if (ite->irq->hw)
> +		return irq_set_irqchip_state(ite->irq->host_irq,
> +					     IRQCHIP_STATE_PENDING, false);
> +
nit: could be done before the pending_latch setting as this latter is
not used in that case.

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


>  	return 0;
>  }
>  
> 
