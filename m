From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 14/27] arm64/sve: Backend logic for setting the vector
 length
Date: Wed, 23 Aug 2017 18:29:52 +0100
Message-ID: <20170823172952.GB6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-15-git-send-email-Dave.Martin@arm.com>
 <87shgi9u4h.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shgi9u4h.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, gdb@sourceware.org, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 23, 2017 at 04:33:18PM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > This patch implements the core logic for changing a task's vector
> > length on request from userspace.  This will be used by the ptrace
> > and prctl frontends that are implemented in later patches.
> >
> > The SVE architecture permits, but does not require, implementations
> > to support vector lengths that are not a power of two.  To handle
> > this, logic is added to check a requested vector length against a
> > possibly sparse bitmap of available vector lengths at runtime, so
> > that the best supported value can be chosen.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/asm/fpsimd.h |   6 +++
> >  arch/arm64/kernel/fpsimd.c      | 116 ++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/prctl.h      |   5 ++
> >  3 files changed, 127 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> > index 7efd04e..39b26d2 100644
> > --- a/arch/arm64/include/asm/fpsimd.h
> > +++ b/arch/arm64/include/asm/fpsimd.h
> > @@ -70,11 +70,15 @@ extern void fpsimd_update_current_state(struct fpsimd_state *state);
> >
> >  extern void fpsimd_flush_task_state(struct task_struct *target);
> >
> > +#define SVE_VL_ARCH_MAX 0x100
> > +
> 
> Hmm this isn't the same as SVE_VL_MAX. Why aren't we using that?

There should probably be a comment on this.

SVE vector-length agnostic software needs to be able to assume that
VL <= 256 (the SVE maximum), because some instructions won't work as
expected if this is not the case, particularly TBL, where in a larger
vector there's no guarantee that a vector index (which might be as small
as a byte) can index a vector element (of which there could be >256).

I really don't want to expose SVE_VL_ARCH_MAX to userspace, so that
people are not tempted to design data structures and protocols that
can't handle up to SVE_VL_MAX.  Exposing both together seemed to carry
a high risk of confusion and misuse.

Instead, I silently clamp to an SVE-compatible length (i.e.,
SVE_VL_ARCH_MAX) in sve_set_vector_length().  If future architecture
revisions support larger vectors later on, my plan is to require an
extra "force flag" to be passed to override the clamp.

[...]

Cheers
---Dave
