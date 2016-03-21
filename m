From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Mon, 21 Mar 2016 11:34:40 +0000
Message-ID: <20160321113439.GA25466@e104818-lin.cambridge.arm.com>
References: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
 <20160318180708.GI4645@e104818-lin.cambridge.arm.com>
 <20160320210704.GD24948@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160320210704.GD24948@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Mar 20, 2016 at 10:07:04PM +0100, Christoffer Dall wrote:
> On Fri, Mar 18, 2016 at 06:07:09PM +0000, Catalin Marinas wrote:
> > On Fri, Mar 18, 2016 at 05:25:59PM +0000, Marc Zyngier wrote:
> > > When running with VHE, there is no need to translate kernel pointers
> > > to the EL2 memory space, since we're already there (and we have a much
> > > saner memory map to start with).
> > > 
> > > Unfortunately, kvm_ksym_ref is getting in the way, and the first
> > > call into the "hypervisor" section is going to end up in fireworks,
> > > since we're now branching into nowhereland. Meh.
> > > 
> > > A potential solution is to test if VHE is engaged or not, and only
> > > perform the translation in the negative case. With this in place,
> > > VHE is able to run again.
> > > 
> > > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_asm.h | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index 226f49d..282f907 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -26,7 +26,13 @@
> > >  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
> > >  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
> > >  
> > > -#define kvm_ksym_ref(sym)		phys_to_virt((u64)&sym - kimage_voffset)
> > > +#define kvm_ksym_ref(sym)						\
> > > +	({								\
> > > +		void *val = sym;					\
> > 
> > Should we not use &sym, for consistency and just in case we ever pass
> > something other than a function.
> 
> we already do, we pass the symbox for an extern char _foo[] array, but
> that should work just the same with sym and &sym.

Just for consistency between "val = sym" and "phys_to_virt((u64)&sym..."

> Given the effort put in to avoid these kinds of branches for the VHE
> code, it may be worth optimizing this later on with the use of
> instruction patching or static keys to avoid the branch on every vm
> entry/exit?

Marc tried with run-time patching first but the code was still reading
kimage_voffset even with VHE. Anyway, it can be optimised later.

> > > +		if (!is_kernel_in_hyp_mode())				\
> > > +			val = phys_to_virt((u64)&sym - kimage_voffset);	\
> > > +		val;							\
> > > +	 })
> > 
> > Otherwise:
> > 
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Thanks, I can change to &sym and queue this patch (not assuming you plan
> on taking it directly via the arm64 tree).

Please feel free to merge this via the kvm tree.

-- 
Catalin
