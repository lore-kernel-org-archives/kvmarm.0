From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Sun, 20 Mar 2016 22:07:04 +0100
Message-ID: <20160320210704.GD24948@cbox>
References: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
 <20160318180708.GI4645@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D330640F9B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Mar 2016 17:06:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FniSf3FXW7li for <kvmarm@lists.cs.columbia.edu>;
 Sun, 20 Mar 2016 17:06:05 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9081140F90
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Mar 2016 17:06:05 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id l68so130662838wml.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Mar 2016 14:06:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160318180708.GI4645@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 18, 2016 at 06:07:09PM +0000, Catalin Marinas wrote:
> On Fri, Mar 18, 2016 at 05:25:59PM +0000, Marc Zyngier wrote:
> > When running with VHE, there is no need to translate kernel pointers
> > to the EL2 memory space, since we're already there (and we have a much
> > saner memory map to start with).
> > 
> > Unfortunately, kvm_ksym_ref is getting in the way, and the first
> > call into the "hypervisor" section is going to end up in fireworks,
> > since we're now branching into nowhereland. Meh.
> > 
> > A potential solution is to test if VHE is engaged or not, and only
> > perform the translation in the negative case. With this in place,
> > VHE is able to run again.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 226f49d..282f907 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -26,7 +26,13 @@
> >  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
> >  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
> >  
> > -#define kvm_ksym_ref(sym)		phys_to_virt((u64)&sym - kimage_voffset)
> > +#define kvm_ksym_ref(sym)						\
> > +	({								\
> > +		void *val = sym;					\
> 
> Should we not use &sym, for consistency and just in case we ever pass
> something other than a function.
> 

we already do, we pass the symbox for an extern char _foo[] array, but
that should work just the same with sym and &sym.

Given the effort put in to avoid these kinds of branches for the VHE
code, it may be worth optimizing this later on with the use of
instruction patching or static keys to avoid the branch on every vm
entry/exit?

> > +		if (!is_kernel_in_hyp_mode())				\
> > +			val = phys_to_virt((u64)&sym - kimage_voffset);	\
> > +		val;							\
> > +	 })
> 
> Otherwise:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks, I can change to &sym and queue this patch (not assuming you plan
on taking it directly via the arm64 tree).

-Christoffer
