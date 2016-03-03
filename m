From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 17/17] arm64: KVM: vgic-v3: Do not save ICH_AP0Rn_EL2
 for GICv2 emulation
Date: Thu, 3 Mar 2016 20:21:54 +0100
Message-ID: <20160303192154.GJ9634@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455727249-24752-18-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 04:40:49PM +0000, Marc Zyngier wrote:
> The GICv3 specification mandates that ICH_AP0Rn_EL2 are set to
> zero when running guests that use the memory mapped registers.
> 
> This is fine, as we initialize all ICH_AP0Rn_EL2 registers to
> zero, and restore them on entry. But it also means that we
> do not need to save these registers on exit. Profit!
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 5f12c57..c2f173d 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -202,14 +202,17 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  			__gic_v3_set_lr(0, i);
>  		}
>  
> -		switch (nr_pri_bits) {
> -		case 7:
> -			cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
> -			cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
> -		case 6:
> -			cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
> -		default:
> -			cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
> +		/* ICH_AP0Rn is only valid for SRE==1 */
> +		if (cpu_if->vgic_sre & ICC_SRE_EL1_SRE) {
> +			switch (nr_pri_bits) {
> +			case 7:
> +				cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
> +				cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
> +			case 6:
> +				cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
> +			default:
> +				cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
> +			}
>  		}
>  
>  		switch (nr_pri_bits) {
> -- 
> 2.1.4
> 

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
