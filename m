From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Thu, 8 Nov 2018 14:38:43 +0000
Message-ID: <CAFEAcA9v+XvAJBWpDMvEQPeJ7ALM15Yz5KY+wfGPmLG2a8yPRQ@mail.gmail.com>
References: <20181107171031.22573-1-alex.bennee@linaro.org>
 <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com>
 <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
 <87r2fv68us.fsf@linaro.org> <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com>
 <87pnvf63u2.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pnvf63u2.fsf@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 8 November 2018 at 14:28, Alex Benn=C3=A9e <alex.bennee@linaro.org> wrot=
e:
>
> Mark Rutland <mark.rutland@arm.com> writes:
>> One problem is that I couldn't spot when we advance the PC for an MMIO
>> trap. I presume we do that in the kernel, *after* the MMIO trap, but I
>> can't see where that happens.
>
> Nope it gets done before during decode_hsr in mmio.c:
>
>         /*
>          * The MMIO instruction is emulated and should not be re-executed
>          * in the guest.
>          */
>         kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));

I think that this attempt to do the PC-advance early is
probably an underlying problem that is not helping the
code structure here.

An enhancement that's been floated previously is that the
MMIO emulation in userspace should be able to report back
to KVM "nope, that access should generate a guest synchronous
external abort (with ESR_EL1.EA =3D 0/1)".
If we have that, then we definitely need to not advance the
PC until after userspace has done the emulation and told
us whether the memory access succeeded or not...

thanks
-- PMM
