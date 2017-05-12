From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC kvm-unit-tests PATCH 5/8] Makefile: add explicit mkdir for .o targets
Date: Fri, 12 May 2017 12:14:49 +0100
Message-ID: <87k25m4992.fsf@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org> <20170406190727.5624-6-alex.bennee@linaro.org> <a8eb190a-3487-1a89-0069-789b62860b3e@redhat.com> <87mvaj4din.fsf@linaro.org> <bac2056a-c771-6188-0066-7e3236719ff0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <bac2056a-c771-6188-0066-7e3236719ff0@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 11/05/2017 17:30, Alex Bennée wrote:
>>>>
>>>>  %.o: %.S
>>>> +	mkdir -p $(dir $@)
>>> Should this use @ for cleanliness?
>> > I'm not sure I follow. Did you mean use $(@D) directly?
>
> That too, but I was thinking of using "@mkdir" to avoid spamming the
> output with mkdir commands.

Gotcha.

>
> Paolo


--
Alex Bennée
