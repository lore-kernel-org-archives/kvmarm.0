From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before
 ICH_APR0Rn_EL2
Date: Wed, 24 Feb 2016 12:53:24 +0100
Message-ID: <20160224115324.GC18451@cbox>
References: <1455723312-23896-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455723312-23896-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 03:35:12PM +0000, Marc Zyngier wrote:
> The GICv3 architecture spec says:
> 
> Writing to the active priority registers in any order other than
> the following order will result in UNPREDICTABLE behavior:
> - ICH_AP0R<n>_EL2.
> - ICH_AP1R<n>_EL2.
> 
> So let's not pointlessly go against the rule...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 9142e082..93f6c5c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -149,16 +149,6 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  
>  	switch (nr_pri_bits) {
>  	case 7:
> -		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
> -		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
> -	case 6:
> -		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
> -	default:
> -		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
> -	}	 	                           
> -		 	                           
> -	switch (nr_pri_bits) {
> -	case 7:
>  		 write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
>  		 write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
>  	case 6:
> @@ -167,6 +157,16 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  		 write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
>  	}
>  
> +	switch (nr_pri_bits) {
> +	case 7:
> +		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
> +		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
> +	case 6:
> +		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
> +	default:
> +		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
> +	}	 	                           
> +		 	                           

could you prune that extra pointless white space while you're at it?

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,
-Christoffer

>  	switch (max_lr_idx) {
>  	case 15:
>  		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)], ICH_LR15_EL2);
> -- 
> 2.1.4
> 
