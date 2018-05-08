From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 06/14] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Tue, 8 May 2018 11:14:07 +0100
Message-ID: <20180508101404.GD7753@e103592.cambridge.arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
 <1525449935-31424-7-git-send-email-Dave.Martin@arm.com>
 <e87c6940-1c79-ccd4-c6ad-2d87790b2e00@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <e87c6940-1c79-ccd4-c6ad-2d87790b2e00@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 08, 2018 at 10:58:04AM +0100, Marc Zyngier wrote:
> On 04/05/18 17:05, Dave Martin wrote:
> > This patch refactors KVM to align the host and guest FPSIMD
> > save/restore logic with each other for arm64.  This reduces the
> > number of redundant save/restore operations that must occur, and
> > reduces the common-case IRQ blackout time during guest exit storms
> > by saving the host state lazily and optimising away the need to
> > restore the host state before returning to the run loop.
> > 
> > Four hooks are defined in order to enable this:
> > 
> >  * kvm_arch_vcpu_run_map_fp():
> >    Called on PID change to map necessary bits of current to Hyp.
> > 
> >  * kvm_arch_vcpu_load_fp():
> >    Set up FP/SIMD for entering the KVM run loop (parse as
> >    "vcpu_load fp").
> > 
> >  * kvm_arch_vcpu_park_fp():
> >    Get FP/SIMD into a safe state for re-enabling interrupts after a
> >    guest exit back to the run loop.
> > 
> >    For arm64 specifically, this involves updating the host kernel's
> >    FPSIMD context tracking metadata so that kernel-mode NEON use
> >    will cause the vcpu's FPSIMD state to be saved back correctly
> >    into the vcpu struct.  This must be done before re-enabling
> >    interrupts because kernel-mode NEON may be used my softirqs.
> 
> s/my/by/
> 
> I must admit being slightly confused by the word "park". I tend to read
> "park" as "stash away for later use", while it really is "update the
> kernel's view of who is actually in control of the FP registers".

I was thinking park as in parking disk heads, i.e., get things so we can
kick FPSIMD without doing damage.

(Or indeed, applying the handbrake so your car doesn't roll away
downhill while you're gone.)

But of a strained analogy though, I'll admit.

> No, I don't have a better name for it... ;-) But maybe something along
> the lines of "hwsync_fp", in order to be consistent with the rest of the
> code that deals with shared resources?

To me, "hw" carries too much of a suggestion that we would be flushing
the registers back to memory.  In fact, we don't touch the hardware
here, only kernel bookkeeping data.

Trying to come up with an intuitive name for this may be futile; how
about

 * _sync_ (which is suitably vague), or
 * _ctxsync_ (which will avoid fooling people into thinking they know
	what it does without looking at the code)

?

[...]

> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 469de8a..811097e 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -30,6 +30,7 @@
> >  #include <asm/kvm.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_mmio.h>
> > +#include <asm/thread_info.h>
> >  
> >  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> >  
> > @@ -238,6 +239,12 @@ struct kvm_vcpu_arch {
> >  
> >  	/* Pointer to host CPU context */
> >  	kvm_cpu_context_t *host_cpu_context;
> > +
> > +	struct thread_info *host_thread_info;	/* hyp VA */
> > +	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> > +	bool host_sve_in_use;	/* backup for host TIF_SVE while in guest */
> > +	bool fp_enabled;
> 
> Could we consider merging these two fields together with debug_flags?
> Overall, they share a common purpose (tracking the use of a resource
> shared between host and guest). Not necessarily something to do
> immediately though.

I expect so.  I added these as bools partly for simplicity and partly
because there was no general-purpose flags field already.

We could make debug_flags into a general-purpose flags field, though.

Once we've agreed about the park_fp renaming, I'll consider reworking
this also -- but I'll punt it to a separate patch if it turns out to be
non-trivial.

[...]

> Other than the couple of minor nits above,
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks
---Dave
