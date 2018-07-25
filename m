From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 07/16] arm64/sve: Enable SVE state tracking for
 non-task contexts
Date: Wed, 25 Jul 2018 15:39:15 +0100
Message-ID: <20180725143914.GN4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-8-git-send-email-Dave.Martin@arm.com>
 <87a7qfto1m.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAD5A49F89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:39:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MBJaFCEuyDwP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 10:39:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABDDF4045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:39:19 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87a7qfto1m.fsf@linaro.org>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 25, 2018 at 02:58:29PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > The current FPSIMD/SVE context handling support for non-task (i.e.,
> > KVM vcpu) contexts does not take SVE into account.  This means that
> > only task contexts can safely use SVE at present.
> >
> > In preparation for enabling KVM guests to use SVE, it is necessary
> > to keep track of SVE state for non-task contexts too.
> >
> > This patch adds the necessary support, removing assumptions from
> > the context switch code about the location of the SVE context
> > storage.
> >
> > When binding a vcpu context, its vector length is arbitrarily
> > specified as sve_max_vl for now.  In any case, because TIF_SVE is
> > presently cleared at vcpu context bind time, the specified vector
> > length will not be used for anything yet.  In later patches TIF_SVE
> > will be set here as appropriate, and the appropriate maximum vector
> > length for the vcpu will be passed when binding.
> <snip>
> > --- a/arch/arm64/kernel/fpsimd.c
> > +++ b/arch/arm64/kernel/fpsimd.c
> > @@ -121,6 +121,8 @@
> >   */
> >  struct fpsimd_last_state_struct {
> >  	struct user_fpsimd_state *st;
> > +	void *sve_state;
> > +	unsigned int sve_vl;
> >  };
> =

> > -	struct user_fpsimd_state *st =3D __this_cpu_read(fpsimd_last_state.st=
);
> > +	struct fpsimd_last_state_struct const *last =3D
> > +		this_cpu_ptr(&fpsimd_last_state);
> <snip>
> > @@ -1074,6 +1082,8 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_=
state *st)
> >  	WARN_ON(!in_softirq() && !irqs_disabled());
> >
> >  	last->st =3D st;
> > +	last->sve_state =3D sve_state;
> > +	last->sve_vl =3D sve_vl;
> >  }
> =

> I'm suffering a little cognitive dissonance with the use of last here
> because isn't it really the state as it is now - as we bind to the cpu?

Yes, but it _will_ be the last state ;)

It could have been named along the lines of "current", which would have
been less confusing in some respects.  Anyway, the name crept in a while
ago (pre-SVE) and I'm not sure it's really worth fixing.

> =

> Anyway not super relevant to this patch as the name has already been
> chosen so:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks
---Dave
