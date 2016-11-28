From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: head.S: Fix CNTHCTL_EL2 access on VHE system
Date: Mon, 28 Nov 2016 16:56:35 +0000
Message-ID: <871868f8-563c-98a1-e3f7-f3ac9457265e@arm.com>
References: <1480351438-11548-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1480351438-11548-1-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, christoffer.dall@linaro.org, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, julien.grall@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/11/16 16:43, Jintack Lim wrote:
> From: Jintack <jintack@cs.columbia.edu>
> 
> Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
> EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
> are 11th and 10th bits respectively when E2H is set.  Current code is
> unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set.
> 
> In fact, we don't need to set those two bits, which allow EL1 and EL0 to
> access physical timer and counter respectively, if E2H and TGE are set
> for the host kernel. They will be configured later as necessary. First,
> we don't need to configure those bits for EL1, since the host kernel
> runs in EL2.  It is a hypervisor's responsibility to configure them
> before entering a VM, which runs in EL0 and EL1. Second, EL0 accesses
> are configured in the later stage of boot process.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/kernel/head.S | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 332e331..bc3d2db 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -524,10 +524,16 @@ set_hcr:
>  	msr	hcr_el2, x0
>  	isb
>  
> -	/* Generic timers. */
> +	/*
> +	 * Allow Non-secure EL1 and EL0 to access physical timer and counter.
> +	 * This is not necessary for VHE, since the host kernel runs in EL2,
> +	 * and EL0 accesses are configured in the later stage of boot process.
> +	 */
> +	cbnz	x2, 1f
>  	mrs	x0, cnthctl_el2
>  	orr	x0, x0, #3			// Enable EL1 physical timers
>  	msr	cnthctl_el2, x0
> +1:
>  	msr	cntvoff_el2, xzr		// Clear virtual offset
>  
>  #ifdef CONFIG_ARM_GIC_V3
> 

Nice catch. It may be worth documenting that when HCR_EL2.E2H == 1,
CNTHCTL_EL2 has the same bit layout as CNTKCTL_EL1, allowing the kernel
designed to run at EL1 to transparently mess with the EL0 bits (as
CNTHCTL_EL2 and CNTKCTL_EL1 are the same register in this configuration).

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
