From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 13/23] KVM: arm64/sve: Context switch the SVE
 registers
Date: Tue, 20 Nov 2018 17:18:37 +0000
Message-ID: <20181120171837.GB3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-14-git-send-email-Dave.Martin@arm.com>
 <87sgzxhvny.fsf@linaro.org>
 <20181119170303.GX3505@e103592.cambridge.arm.com>
 <87o9akhr6f.fsf@linaro.org>
 <20181120141659.GZ3505@e103592.cambridge.arm.com>
 <87muq3ix62.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0294A2AE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 12:18:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uksCVSs31qw7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Nov 2018 12:18:42 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B4024A2AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 12:18:42 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87muq3ix62.fsf@linaro.org>
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

On Tue, Nov 20, 2018 at 03:30:29PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:

[...]

> >> Put calculating guest_has_sve at the top of __hyp_switch_fpsimd make
> >> most of that go away and just moves things around a little bit. So I
> >> guess it could makes sense for the fast(ish) path although I'd be
> >> interested in knowing if it made any real difference to the numbers.
> >> After all the first read should be well cached and moving it through t=
he
> >> stack is just additional memory and register pressure.
> >
> > Hmmm, I will have a think about this when I respin.
> >
> > Explicitly caching guest_has_sve() does reduce the compiler's freedom to
> > optimise.
> >
> > We might be able to mark it as __pure or __attribute_const__ to enable
> > the compiler to decide whether to cache the result, but this may not be
> > 100% safe.
> >
> > Part of me would prefer to leave things as they are to avoid the risk of
> > breaking the code again...
> =

> Given that the only place you call __hyp_switch_fpsimd is here you could
> just roll in into __hyp_trap_is_fpsimd and have:
> =

> 	if (__hyp_trap_is_fpsimd(vcpu))
> 		return true;

Possibly, though the function should be renamed in this case, something
like __hyp_handle_fpsimd_trap() I guess.

Cheers
---Dave
