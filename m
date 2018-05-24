From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 13/18] arm64/sve: Move sve_pffr() to fpsimd.h and
 make inline
Date: Thu, 24 May 2018 12:22:42 +0100
Message-ID: <20180524112242.GU13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-14-git-send-email-Dave.Martin@arm.com>
 <8736yhtkvo.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <8736yhtkvo.fsf@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 11:20:59AM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > In order to make sve_save_state()/sve_load_state() more easily
> > reusable and to get rid of a potential branch on context switch
> > critical paths, this patch makes sve_pffr() inline and moves it to
> > fpsimd.h.
> >
> > <asm/processor.h> must be included in fpsimd.h in order to make
> > this work, and this creates an #include cycle that is tricky to
> > avoid without modifying core code, due to the way the PR_SVE_*()
> > prctl helpers are included in the core prctl implementation.
> >
> > Instead of breaking the cycle, this patch defers inclusion of
> > <asm/fpsimd.h> in <asm/processor.h> until the point where it is
> > actually needed: i.e., immediately before the prctl definitions.
> >
> > No functional change.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/include/asm/fpsimd.h    | 13 +++++++++++++
> >  arch/arm64/include/asm/processor.h |  3 ++-
> >  arch/arm64/kernel/fpsimd.c         | 12 ------------
> >  3 files changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/f=
psimd.h
> > index fb60b22..fa92747 100644
> > --- a/arch/arm64/include/asm/fpsimd.h
> > +++ b/arch/arm64/include/asm/fpsimd.h
> > @@ -18,6 +18,8 @@
> >
> >  #include <asm/ptrace.h>
> >  #include <asm/errno.h>
> > +#include <asm/processor.h>
> > +#include <asm/sigcontext.h>
> >
> >  #ifndef __ASSEMBLY__
> >
> > @@ -61,6 +63,17 @@ extern void sve_flush_cpu_state(void);
> >  /* Maximum VL that SVE VL-agnostic software can transparently support =
*/
> >  #define SVE_VL_ARCH_MAX 0x100
> >
> > +/* Offset of FFR in the SVE register dump */
> > +static inline size_t sve_ffr_offset(int vl)
> > +{
> > +	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
> > +}
> > +
> > +static inline void *sve_pffr(struct thread_struct *thread)
> > +{
> > +	return (char *)thread->sve_state + sve_ffr_offset(thread->sve_vl);
> > +}
> > +
> >  extern void sve_save_state(void *state, u32 *pfpsr);
> >  extern void sve_load_state(void const *state, u32 const *pfpsr,
> >  			   unsigned long vq_minus_1);
> > diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/as=
m/processor.h
> > index f902b6d..ebaadb1 100644
> > --- a/arch/arm64/include/asm/processor.h
> > +++ b/arch/arm64/include/asm/processor.h
> > @@ -40,7 +40,6 @@
> >
> >  #include <asm/alternative.h>
> >  #include <asm/cpufeature.h>
> > -#include <asm/fpsimd.h>
> >  #include <asm/hw_breakpoint.h>
> >  #include <asm/lse.h>
> >  #include <asm/pgtable-hwdef.h>
> > @@ -245,6 +244,8 @@ void cpu_enable_pan(const struct arm64_cpu_capabili=
ties *__unused);
> >  void cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *=
__unused);
> >  void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused);
> >
> > +#include <asm/fpsimd.h>
> > +
> =

> You really need a one-liner comment to note why the include is in a
> funny place to save someone just moving it back and then getting really
> confused. Maybe:
> =

>   /* included just in time to avoid circular inclusion issues */
>   #include <asm/fpsimd.h>
> =

> It still seems weird to me though :-/

How about

/*                                                                         =
     =

 * Not at the top of the file due to a direct #include cycle between       =
     =

 * <asm/fpsimd.h> and <asm/processor.h>.  Deferring this #include          =
     =

 * ensures that contents of processor.h are visible to fpsimd.h even if    =
     =

 * processor.h is included first.                                          =
     =

 *                                                                         =
     =

 * These prctl helpers are the only things in this file that require       =
     =

 * fpsimd.h.  The core code expects them to be in this header.             =
     =

 */

?

Cheers
---Dave

> =

> Otherwise:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
