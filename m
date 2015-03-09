From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 5/6] target-arm/kvm64: fix save/restore of SPSR regs
Date: Mon, 09 Mar 2015 16:25:58 +0000
Message-ID: <87r3syb0ix.fsf@linaro.org>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org> <1424880159-29348-7-git-send-email-alex.bennee@linaro.org> <20150302172212.GB10137@lvm> <874mq27222.fsf@linaro.org> <20150309125650.GA20559@cbox> <CAFEAcA_DqHx-sDMuhSr0-uQL20-uJzXXpBvr6YLUWmzMN2mL4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <CAFEAcA_DqHx-sDMuhSr0-uQL20-uJzXXpBvr6YLUWmzMN2mL4w@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Peter Maydell <peter.maydell@linaro.org> writes:

> On 9 March 2015 at 21:56, Christoffer Dall <christoffer.dall@linaro.o=
rg> wrote:
>> this function, however, is not used only when migration, but should
>> generally cover the case where you want to synchronize QEMU's state =
into
>> KVM's state, right?  So while it may not be harmful in currently
>> supported use cases, is there ever a situation where (is_a64(env) &&=
 el
>> =3D=3D 0) and env->spsr !=3D banked_spsr[el], and where env->spsr is
>> out-of-date?
>
> If EL =3D=3D 0 then you can't access any SPSR, so env->spsr is by
> definition out of date.

Indeed and in v2 the whole thing is wrapped in if (el > 0)

>
> -- PMM

--=20
Alex Benn=C3=A9e
