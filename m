From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 06/18] arm64: fpsimd: Generalise context saving for
 non-task contexts
Date: Thu, 24 May 2018 10:03:23 +0100
Message-ID: <20180524090322.GQ13470@e103592.cambridge.arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-7-git-send-email-Dave.Martin@arm.com>
 <87in7et9gw.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D51D49F8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 04:53:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TETdFtdtKfV4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 04:52:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86E2349F88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 04:52:46 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87in7et9gw.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 23, 2018 at 09:15:11PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > In preparation for allowing non-task (i.e., KVM vcpu) FPSIMD
> > contexts to be handled by the fpsimd common code, this patch adapts
> > task_fpsimd_save() to save back the currently loaded context,
> > removing the explicit dependency on current.
> >
> > The relevant storage to write back to in memory is now found by
> > examining the fpsimd_last_state percpu struct.
> >
> > fpsimd_save() does nothing unless TIF_FOREIGN_FPSTATE is clear, and
> > fpsimd_last_state is updated under local_bh_disable() or
> > local_irq_disable() everywhere that TIF_FOREIGN_FPSTATE is cleared:
> > thus, fpsimd_save() will write back to the correct storage for the
> > loaded context.
> >
> > No functional change.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  arch/arm64/kernel/fpsimd.c | 25 +++++++++++++------------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > index 9d85373..3aa100a 100644
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -270,13 +270,15 @@ static void task_fpsimd_load(void)
> >  }
> >
> >  /*
> > - * Ensure current's FPSIMD/SVE storage in thread_struct is up to date
> > - * with respect to the CPU registers.
> > + * Ensure FPSIMD/SVE storage in memory for the loaded context is up to
> > + * date with respect to the CPU registers.
> >   *
> >   * Softirqs (and preemption) must be disabled.
> >   */
> > -static void task_fpsimd_save(void)
> > +static void fpsimd_save(void)
> >  {
> > +	struct user_fpsimd_state *st =3D __this_cpu_read(fpsimd_last_state.st=
);
> > +
> =

> I thought I was missing something but the only write I saw of this was:
> =

>   __this_cpu_write(fpsimd_last_state.st, NULL);
> =

> which implied to me it is possible to have an invalid de-reference. I
> did figure it out eventually as fpsimd_bind_state_to_cpu uses a more
> indirect this_cpu_ptr idiom for tweaking this. I guess a reference to
> fpsimd_bind_[task|state]_to_cpu in the comment would have helped my
> confusion.

How about:

 static void fpsimd_save(void)
 {
 	struct user_fpsimd_state *st =3D __this_cpu_read(fpsimd_last_state.st);
+	/* set by fpsimd_bind_to_cpu() */
 =

 	WARN_ON(!in_softirq() && !irqs_disabled());


> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks
---Dave
