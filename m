From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] target-arm: kvm: save/restore mp state
Date: Tue, 03 Mar 2015 18:10:12 +0100
Message-ID: <54F5EAF4.2000206@redhat.com>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org> <1424880159-29348-2-git-send-email-alex.bennee@linaro.org> <CAFEAcA9oWeYGYcGtf8So6VrYLMXjWr4FiZ2tS+jBnDtv87jAKw@mail.gmail.com> <8761ai73j1.fsf@linaro.org> <54F595C0.5060004@redhat.com> <CAFEAcA8SaBuH6izzuD6CmknSU9mbQPo0YNO=knTgRCPZ2EvXcQ@mail.gmail.com> <87zj7u59hd.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87zj7u59hd.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 03/03/2015 17:30, Alex Benn=C3=A9e wrote:
>> >
>>> >>  Right now this is not migrated on ARM if I remember correctly, =
but
>>> >> perhaps you'll want to add it in the future.
>> >
>> > ...which is why we don't need to migrate this: it just means
>> > that migration during WFI causes an unnecessary-wakeup, which
>> > is architecturally fine.
> What happens when you boot a SMP system but only ever power up one of=
 the
> CPUs? You can't just randomly start the second CPU if it's in the
> powered off state, who knows what it would do?

The second CPU would not be in the WFI state, which is what Peter is
talking about.

I agree that this state should be saved/restored.  I'm just saying that
HALTED is not the right constant to use.

Paolo
