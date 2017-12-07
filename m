From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 15/30] arm64/sve: Signal handling support
Date: Thu, 7 Dec 2017 12:03:04 +0000
Message-ID: <20171207120245.GD22781@e103592.cambridge.arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
 <CAGXu5jJgsAg1VBMbx=mV3ep4hzs+1G46Sow4eeFqCK31b_sORA@mail.gmail.com>
 <20171207104948.GE31900@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207104948.GE31900@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha <libc-alpha@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 07, 2017 at 10:49:48AM +0000, Will Deacon wrote:
> Hi Kees,
> 
> On Wed, Dec 06, 2017 at 11:56:50AM -0800, Kees Cook wrote:
> > On Tue, Oct 31, 2017 at 8:51 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> > > Miscellaneous:
> > >
> > >  * Change inconsistent copy_to_user() calls to __copy_to_user() in
> > >    preserve_sve_context().
> > >
> > >    There are already __put_user_error() calls here.
> > >
> > >    The whole extended signal frame is already checked for
> > >    access_ok(VERIFY_WRITE) in get_sigframe().
> > 
> > Verifying all these __copy_to/from_user() calls is rather non-trivial.
> > For example, I had to understand that the access_ok() check actually
> > spans memory that both user->sigframe and user->next_frame point into.
> 
> I don't think that's particularly difficult -- you just have to read the
> four lines preceding the access_ok.
> 
> > And it isn't clear to me that all users of apply_user_offset() are
> > within this range too, along with other manually calculated offsets in
> > setup_sigframe().
> 
> The offsets passed into apply_user_offset are calculated by
> setup_sigframe_layout as the stack is allocated, so they're correct by
> construction. We could add a size check in apply_user_offset if you like?

Adding a BUG_ON(out of bounds) in apply_user_offset doesn't seem a
terrible idea.

> > And it's not clear if parse_user_sigframe() is safe either. Are
> > user->fpsimd and user->sve checked somewhere? It seems like it's
> > safely contained by in sf->uc.uc_mcontext.__reserved, but it's hard to
> > read, though I do see access_ok() checks against __reserved at the end
> > of the while loop.
> 
> This one is certainly more difficult to follow, mainly because it's spread
> about a bit and we have to check the extra context separately. However, the
> main part of the frame is checked in sys_rt_sigreturn before calling
> restore_sigframe, and the extra context is checked in parse_user_sigframe
> if we find it.
> 
> Dave, any thoughts on making this easier to understand?

I'm open to ideas myself -- I did screw this up previously with the
missing access_ok() check on the extra_context data area -- though
that wasn't catastrophic since that area is enforced to be contiguous
with the base frame which was always access_ok() checked.


During development, many essential invariants were "documented" using
BUG_ON()s.  Unfortunately we don't really distinguish between marking
invariants that should be derivable from each other and from the code,
and marking things that the developer merely hopes are true (or would
rather not think about at all).  Comprehensive annotation also
burdens the code with a lot of clutter...


It would be good if there were type annotations for pointers that have
passed through the access_ok() check that could be analysed by tools,
something like:

	void __user __user_write_ok(base_offset, size) *p;

Such type annotations could be derived via an access_ok() check, and
taken into account by checkers examining calls to __put_user() etc.:
ultimately __put_user() might be forbidden on types lacking an
annotation with sufficient bounds.

The devil is in the detail though, and to be most useful the
annotations would need to be bindable to runtime values, not
just constants.  This does not preclude static analysis, but it's
far from trivial.  Has anything like this been considered in the past?


For the sigframe code, here's my rationale -- I'm happy to base
comments on it, but the more rationale is documented in comments
the higher the risk that the code will drift away from it over
time without anybody noticing...

Would you pick anything out of this as particularly critical?


The basic flow is:

Signal delivery
---------------
 1. The location and size of each signal frame block is calculated
    in terms of offsets from the base of the frame.

    (Done by setup_sigframe_layout().)

 2. The base (user) address of the frame is calculated by subtracting
    the overall size of the computed frame from the initial user sp.

 3. access_ok() is done on the resulting address range.

    (Steps 2-3 are done by get_sigframe().)

 4. The signal frame is poked using addresses derived in two ways:

  a) Direct derivation from the user sp, within the bounds of the
     access_ok() check in get_sigframe().

  b) Addition to the sigframe base address, of offsets computed in (1);
     these fall with the access_ok() range by construction due to the
     way the access_ok() range is computed from those offsets in the
     first place.

     (b) is done by apply_user_offset(), with no further checks.


Signal return
-------------
 1. The base signal frame is access_ok()'d.

    (sys_rt_sigreturn())

 2. Contents of the base frame is read out and processed using the
    same base address and within the range that was access_ok()'d.

    (restore_sigframe())

 2. parse_user_sigframe() walks over its contents, picking out __user
    pointers to the records found.  The parse is bounded to within the
    access_ok()'d size by the limit variable in parse_user_sigframe().

    Only __user * pointers whose referent's full bounds fit within the
    limits are picked out.
   
 3. limit is updated only for extra_context, and only one extra_context
    is allowed (policed by the have_extra_context bool).

    The extension area that the extra_context block points to is
    required to be contiguous with the end of the (already access_ok()'d)
    sigframe.  The additional space is access_ok()'d and limit updated
    accordingly.

    Parsing then proceeds, still bounded by limit.

 4. The signal frame contents are read out and processed using pointers
    derived by parse_user_sigframe().


Cheers
---Dave
