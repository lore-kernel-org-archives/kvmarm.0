From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 07/31] KVM: arm/arm64: vgic-v3: Add accessors for the
 ICH_APxRn_EL2 registers
Date: Wed, 3 May 2017 16:32:01 +0100
Message-ID: <20170503153201.GC4951@leverpostej>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503104606.19342-8-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 03, 2017 at 11:45:42AM +0100, Marc Zyngier wrote:
> As we're about to access the Active Priority registers a lot more,
> let's define accessors that take the register number as a parameter.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 116 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 100 insertions(+), 16 deletions(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 32c3295929b0..990d9d1e85d0 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -118,6 +118,90 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
>  	}
>  }
>  
> +static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
> +{
> +	switch (n) {
> +	case 0:
> +		write_gicreg(val, ICH_AP0R0_EL2);
> +		break;
> +	case 1:
> +		write_gicreg(val, ICH_AP0R1_EL2);
> +		break;
> +	case 2:
> +		write_gicreg(val, ICH_AP0R2_EL2);
> +		break;
> +	case 3:
> +		write_gicreg(val, ICH_AP0R3_EL2);
> +		break;
> +	}

Is there any way we can get a build or runtime failure for an
out-of-bounds n value?

> +}

Given this is used with a constant n, you could make this:

#define __vgic_v3_write_ap0rn(v, n) \
	write_gicreg(v, ICH_AP0R##n##_EL2)

... which should also give you a warning for an out-of-bounds n.

Similar could apply for the other helpers here.

That would require some function -> macro conversion in later patches
though, so I can understand if you're not keen on that.

Thanks,
Mark.
