From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 6/6] target-arm: cpu.h document why env->spsr exists
Date: Wed, 04 Mar 2015 16:27:29 +0000
Message-ID: <87vbig683y.fsf@linaro.org>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org> <1425479753-18349-7-git-send-email-alex.bennee@linaro.org> <CAFEAcA9x_6jGfNTpMLYYbmEp19U7sOVjcgzCggwkwZiyCM5yug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <CAFEAcA9x_6jGfNTpMLYYbmEp19U7sOVjcgzCggwkwZiyCM5yug@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Peter Maydell <peter.maydell@linaro.org> writes:

> On 4 March 2015 at 23:35, Alex Benn=C3=A9e <alex.bennee@linaro.org> w=
rote:
>> I was getting very confused about the duplication of state. Perhaps =
we
>> should just get rid of env->spsr and use helpers that understand the
>> banking?
>
> Doesn't seem worth changing the current working code to something
> else that's strictly less efficient... spsr is by no means the
> only banked-by-mode register, and it works just like all the others.

=46air enough. I just wanted to make it clear it was a cached value for
the benefit of TCG.

>
> -- PMM

--=20
Alex Benn=C3=A9e
