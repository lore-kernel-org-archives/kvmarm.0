From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 6/6] target-arm: cpu.h document why env->spsr exists
Date: Wed, 4 Mar 2015 23:46:03 +0900
Message-ID: <CAFEAcA9x_6jGfNTpMLYYbmEp19U7sOVjcgzCggwkwZiyCM5yug@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org> <1425479753-18349-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1425479753-18349-7-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 March 2015 at 23:35, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
> I was getting very confused about the duplication of state. Perhaps w=
e
> should just get rid of env->spsr and use helpers that understand the
> banking?

Doesn't seem worth changing the current working code to something
else that's strictly less efficient... spsr is by no means the
only banked-by-mode register, and it works just like all the others.

-- PMM
