From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 13/14] ARM: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
Date: Wed, 23 May 2018 11:50:50 +0100
Message-ID: <4187699a-fe7b-3807-4ffa-809bb918d6a2@arm.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFo-00064i-Hc@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A96074A0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 06:40:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Iig4nB4ZRuYu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 May 2018 06:40:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5BB49F93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 06:40:15 -0400 (EDT)
In-Reply-To: <E1fKjFo-00064i-Hc@rmk-PC.armlinux.org.uk>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 21/05/18 12:45, Russell King wrote:
> We want SMCCC_ARCH_WORKAROUND_1 to be fast. As fast as possible.
> So let's intercept it as early as we can by testing for the
> function call number as soon as we've identified a HVC call
> coming from the guest.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  arch/arm/kvm/hyp/hyp-entry.S | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
> index 918a05dd2d63..67de45685e29 100644
> --- a/arch/arm/kvm/hyp/hyp-entry.S
> +++ b/arch/arm/kvm/hyp/hyp-entry.S
> @@ -16,6 +16,7 @@
>   * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  
> +#include <linux/arm-smccc.h>
>  #include <linux/linkage.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> @@ -202,7 +203,7 @@ ENDPROC(__hyp_do_panic)
>  	lsr     r2, r2, #16
>  	and     r2, r2, #0xff
>  	cmp     r2, #0
> -	bne	guest_trap		@ Guest called HVC
> +	bne	guest_hvc_trap		@ Guest called HVC
>  
>  	/*
>  	 * Getting here means host called HVC, we shift parameters and branch
> @@ -253,6 +254,16 @@ THUMB(	orr	lr, #1)
>  	pop	{r2, lr}
>  	eret
>  
> +guest_hvc_trap:
> +	movw	ip, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
> +	movt	ip, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1

r12 is a live guest register, and only r0-r2 are saved at that stage.
You could additionally corrupt r3 though, once you've identified that
you're in the context of an SMCCC 1.1 call.

You should be able to replace r12 with r2.

> +	ldr	r0, [sp]		@ Guest's r0
> +	teq	r0, ip
> +	bne	guest_trap
> +	pop	{r0, r1, r2}

You could replace this slightly more efficient

	add	sp, sp, #12

since we don't need to restore those registers to the guest. r2 would be
left containing ARM_SMCCC_ARCH_WORKAROUND_1 (harmless), and r1 has the
HSR value (perfectly predictable).

> +	mov	r0, #0
> +	eret
> +
>  guest_trap:
>  	load_vcpu r0			@ Load VCPU pointer to r0
>  
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
