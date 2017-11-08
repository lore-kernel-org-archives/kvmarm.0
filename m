From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 22/26] KVM: arm/arm64: GICv4: Enable virtual cpuif if
 VLPIs can be delivered
Date: Wed, 8 Nov 2017 09:46:29 +0100
Message-ID: <7eb443d1-b247-943b-36e6-a478b7a9d78f@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-23-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-23-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 27/10/2017 16:28, Marc Zyngier wrote:
> In order for VLPIs to be delivered to the guest, we must make
> sure that the 
virtual
cpuif is always enabled, irrespective of the
> presence of virtual interrupt in the LRs.
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 91728faa13fd..f5c3d6d7019e 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -258,7 +258,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
>  		}
>  	} else {
> -		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
> +		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
> +		    cpu_if->its_vpe.its_vm)
>  			write_gicreg(0, ICH_HCR_EL2);
>  
>  		cpu_if->vgic_elrsr = 0xffff;
> @@ -337,9 +338,11 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  		/*
>  		 * If we need to trap system registers, we must write
>  		 * ICH_HCR_EL2 anyway, even if no interrupts are being
> -		 * injected,
> +		 * injected. Same thing if GICv4 is used, as VLPI
> +		 * delivery is gated by ICH_HCR_EL2.En.
>  		 */
> -		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
> +		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
> +		    cpu_if->its_vpe.its_vm)
>  			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
>  	}
>  
> 
