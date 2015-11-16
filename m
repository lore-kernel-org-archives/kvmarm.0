From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 17/21] arm64: KVM: Map the kernel RO section into HYP
Date: Mon, 16 Nov 2015 14:27:29 +0000
Message-ID: <20151116142728.GJ20696@leverpostej>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
 <1447679519-17888-18-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447679519-17888-18-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 01:11:55PM +0000, Marc Zyngier wrote:
> In order to run C code in HYP, we must make sure that the kernel's
> RO section in mapped into HYP (otherwise things break badly).

Somewhat tangential, but do we have any strong guarantees that the hyp
text is otherwise safe in its address space which differs from that of
the kernel proper?

i.e. do we need something like we did for the EFI stub in commit
e8f3010f7326c003 ("arm64/efi: isolate EFI stub from the kernel proper")?

Mark.

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/arm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index eab83b2..6c4549a 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -44,6 +44,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_psci.h>
> +#include <asm/sections.h>
>  
>  #ifdef REQUIRES_VIRT
>  __asm__(".arch_extension	virt");
> @@ -1072,6 +1073,12 @@ static int init_hyp_mode(void)
>  		goto out_free_mappings;
>  	}
>  
> +	err = create_hyp_mappings(__start_rodata, __end_rodata);
> +	if (err) {
> +		kvm_err("Cannot map rodata section\n");
> +		goto out_free_mappings;
> +	}
> +
>  	/*
>  	 * Map the Hyp stack pages
>  	 */
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
