From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] ARM: kvm: fix a bad BSYM() usage
Date: Sat, 9 May 2015 22:07:17 +0200
Message-ID: <20150509200717.GA30634@cbox>
References: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EE6D50E9A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 May 2015 15:58:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6IAZ0WPEVWFU for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 May 2015 15:58:18 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E06450E94
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 May 2015 15:58:17 -0400 (EDT)
Received: by lbcga7 with SMTP id ga7so72452117lbc.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 May 2015 13:07:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: kvm@vger.kernel.org, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Dave P Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 08, 2015 at 05:08:42PM +0100, Russell King wrote:
> BSYM() should only be used when refering to local symbols in the same
> assembly file which are resolved by the assembler, and not for
> linker-fixed up symbols.  The use of BSYM() with panic is incorrect as
> the linker is involved in fixing up this relocation, and it knows
> whether panic() is ARM or Thumb.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/kvm/interrupts.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 79caf79b304a..87847d2c5f99 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -309,7 +309,7 @@ ENTRY(kvm_call_hyp)
>  THUMB(	orr	r2, r2, #PSR_T_BIT	)
>  	msr	spsr_cxsf, r2
>  	mrs	r1, ELR_hyp
> -	ldr	r2, =BSYM(panic)
> +	ldr	r2, =panic
>  	msr	ELR_hyp, r2
>  	ldr	r0, =\panic_str
>  	clrex				@ Clear exclusive monitor
> -- 
> 1.8.3.1
> 
Indeed, the linker figures it out as it should.  It does seem like the
right result is produced with the BSYM() macro as well so not sure what
the harm is.

Anyway, I've queued this to merge via the KVM tree.

Thanks,
-Christoffer
