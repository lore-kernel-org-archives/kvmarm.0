From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 02/18] thread_info: Add update_thread_flag() helpers
Date: Wed, 23 May 2018 14:57:32 +0100
Message-ID: <20180523135732.GK13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-3-git-send-email-Dave.Martin@arm.com>
 <87po1mtrg3.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <87po1mtrg3.fsf@linaro.org>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 02:46:52PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > There are a number of bits of code sprinkled around the kernel to
> > set a thread flag if a certain condition is true, and clear it
> > otherwise.
> >
> > To help make those call sites terser and less cumbersome, this
> > patch adds a new family of thread flag manipulators
> >
> > 	update*_thread_flag([...,] flag, cond)
> >
> > which do the equivalent of:
> >
> > 	if (cond)
> > 		set*_thread_flag([...,] flag);
> > 	else
> > 		clear*_thread_flag([...,] flag);
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  include/linux/sched.h       |  6 ++++++
> >  include/linux/thread_info.h | 11 +++++++++++
> >  2 files changed, 17 insertions(+)
> >

[...]

> > diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> > index cf2862b..8d8821b 100644
> > --- a/include/linux/thread_info.h
> > +++ b/include/linux/thread_info.h
> > @@ -60,6 +60,15 @@ static inline void clear_ti_thread_flag(struct threa=
d_info *ti, int flag)
> >  	clear_bit(flag, (unsigned long *)&ti->flags);
> >  }
> >
> > +static inline void update_ti_thread_flag(struct thread_info *ti, int f=
lag,
> > +					 bool value)
> > +{
> > +	if (value)
> > +		set_ti_thread_flag(ti, flag);
> > +	else
> > +		clear_ti_thread_flag(ti, flag);
> > +}
> > +
> =

> value does seem a bit of vanilla non-informative name for a condition
> flag but whatever:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

I guess, though I couldn't some up with an obviously better name.

I support "condition" would have worked, but it's more verbose.

Thanks for the review
---Dave
