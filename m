From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 03/10] KVM: arm: guest debug, define API headers
Date: Wed, 1 Apr 2015 17:09:20 +0100
Message-ID: <CAFEAcA-Rv9JX_NGQ4=yP6M-6Dx=iXc73xgU-HA=y2LasMgbTCg@mail.gmail.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-4-git-send-email-alex.bennee@linaro.org>
 <20150401174646.74f695bd@thinkpad-w530> <87h9szyh0p.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87h9szyh0p.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, zhichao.huang@linaro.org, "J. Kiszka" <jan.kiszka@siemens.com>, Bharat Bhushan <r65777@freescale.com>, bp@suse.de, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 April 2015 at 17:01, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
>
> David Hildenbrand <dahi@linux.vnet.ibm.com> writes:

>>> +/*
>>> + * See ARM ARM D7.3: Debug Registers
>>
>> Maybe drop one ARM
>
> Well technically it is the ARM Architecture Reference Manual but that=
's
> quite long winded.

Dropping one "ARM" would be actively wrong, so don't do that.
You probably want to say 'v8 ARM ARM", assuming you mean that.

-- PMM
