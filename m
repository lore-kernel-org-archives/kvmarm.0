From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Wed, 7 Nov 2018 17:53:20 +0000
Message-ID: <CAFEAcA8mKCTeswpiznVWR3kSfVfjbot1aTSfemFVNjzXYdSJwA@mail.gmail.com>
References: <20181107171031.22573-1-alex.bennee@linaro.org> <CAFEAcA8LL0uC6o1V3W2T=2P47xZ0zGhMR5mEE+x=8qwmDKZL_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA8LL0uC6o1V3W2T=2P47xZ0zGhMR5mEE+x=8qwmDKZL_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 7 November 2018 at 17:39, Peter Maydell <peter.maydell@linaro.org> wrote=
:
> On 7 November 2018 at 17:10, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
>> Not all faults handled by handle_exit are instruction emulations. For
>> example a ESR_ELx_EC_IABT will result in the page tables being updated
>> but the instruction that triggered the fault hasn't actually executed
>> yet. We use the simple heuristic of checking for a changed PC before
>> seeing if kvm_arm_handle_step_debug wants to claim we stepped an
>> instruction.
>>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> What's the rationale for this change? Presumably it's fixing
> something, but the commit message doesn't really say what...
>
> This feels to me like it's working around the fact that
> we've separated two things ("advance pc (or set it if we're
> going to make the guest take an exception)" and "notice that
> we have completed a single step") that should be handled
> at one point in the code.

...so for instance if your guest PC is at the entrypoint for
an exception, and you singlestep and take the same exception
again, this should count as a single step completed, even
though the PC has not changed. Granted, that's a little
contrived, but it can happen in cases where the guest gets
completely confused and is sitting in a tight loop taking
exceptions because there's no ram at the vector table
address, or whatever.

thanks
-- PMM
