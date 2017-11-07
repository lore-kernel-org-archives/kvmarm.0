From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 16/26] KVM: arm/arm64: GICv4: Propagate property
 updates to VLPIs
Date: Tue, 7 Nov 2017 22:28:36 +0100
Message-ID: <6763d90f-93bf-ddbb-d456-5979b8870aa2@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-17-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-17-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 27/10/2017 16:28, Marc Zyngier wrote:
> Upon updating a property, we propagate it all the way to the physical
> ITS, and ask for an INV command to be executed there.
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 0b7e648e7a0c..2e77c7c83942 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -296,6 +296,9 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  		spin_unlock(&irq->irq_lock);
>  	}
>  
> +	if (irq->hw)
> +		return its_prop_update_vlpi(irq->host_irq, prop, true);
> +
>  	return 0;
>  }
I am confused by the vgic_queue_irq_unlock() on the "hw" path. Why is it
needed in hw mode?

Thanks

Eric

>  
> 
