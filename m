From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 30/38] KVM: arm64: Allow the virtual EL2 to access
 EL2 states without trap
Date: Mon, 31 Jul 2017 11:37:15 +0200
Message-ID: <20170731093715.GQ5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-31-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-31-git-send-email-jintack.lim@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:56AM -0500, Jintack Lim wrote:
> When the virtual E2H bit is set, we can support EL2 register accesses
> via EL1 registers from the virtual EL2 by doing trap-and-emulate. A
> better alternative, however, is to allow the virtual EL2 to access EL2
> register states without trap. This can be easily achieved by not traping
> EL1 registers since those registers already have EL2 register states.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d513da9..fffd0c7 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -74,6 +74,7 @@ static hyp_alternate_select(__activate_traps_arch,
>  static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
> +	u64 vhcr_el2;
>  
>  	/*
>  	 * We are about to set CPTR_EL2.TFP to trap all floating point
> @@ -89,8 +90,26 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  		write_sysreg(1 << 30, fpexc32_el2);
>  		isb();
>  	}
> -	if (vcpu_mode_el2(vcpu))
> -		val |= HCR_TVM | HCR_TRVM;
> +
> +	if (is_hyp_ctxt(vcpu)) {
> +		/*
> +		 * For a guest hypervisor on v8.0, trap and emulate the EL1

this should be for a non-VHE guest hypervisor, or a guest hypervisor
which doesn't set the E2H bit.

> +		 * virtual memory control register accesses.
> +		 */
> +		if (!vcpu_el2_e2h_is_set(vcpu))
> +			val |= HCR_TVM | HCR_TRVM;
> +		/*
> +		 * For a guest hypervisor on v8.1 (VHE), allow to access the

Similarly here, it's not about the architecture level (you can have
kernels that er v8.3 aware as both the host and guest and run on v8.3
hardware, but still both of these cases are relevant.

> +		 * EL1 virtual memory control registers natively. These accesses
> +		 * are to access EL2 register states.
> +		 * Note that we stil need to respect the virtual HCR_EL2 state.

still

> +		 */

So this part could become:

		/*
		 * For a VHE guest hypervisor, we allow it to access EL1
		 * virtual memory control registers directly.
		 */

I don't actually understand why we want to respect the HCR_TVM and
HCR_TRVM bits when running in vEL2 ?  Isn't that only if the VM runs in
EL0 in the hyp context ?

> +		else {
> +			vhcr_el2 = vcpu_sys_reg(vcpu, HCR_EL2);
> +			val |= vhcr_el2 & (HCR_TVM | HCR_TRVM);
> +		}
> +	}
> +

There are also some style issues here, I would prefer:

		if (foo) {
			/* Foo */
			foo();
		} else {
			/* Bar */
			bar();
		}
		

>  	write_sysreg(val, hcr_el2);
>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>  	write_sysreg(1 << 15, hstr_el2);
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
