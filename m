From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 23/28] arm64/sve: KVM: Treat guest SVE use as
 undefined instruction execution
Date: Tue, 17 Oct 2017 15:58:29 +0200
Message-ID: <20171017135829.GU1845@lvm>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-24-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-24-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:40PM +0100, Dave Martin wrote:
> When trapping forbidden attempts by a guest to use SVE, we want the
> guest to see a trap consistent with SVE not being implemented.
> 
> This patch injects an undefined instruction exception into the
> guest in response to such an exception.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/kvm/handle_exit.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 7debb74..b712479 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -147,6 +147,13 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 1;
>  }
>  
> +static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	/* Until SVE is supported for guests: */
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -160,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
>  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> +	[ESR_ELx_EC_SVE]	= handle_sve,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
