From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 05/25] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Mon, 5 Jun 2017 11:27:12 +0100
Message-ID: <CAFEAcA8VEU+wxnNV9OS7B41=QkH1gTGLOfbvXxRi6P8jE3v=zw@mail.gmail.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com> <20170601102117.17750-6-marc.zyngier@arm.com>
 <20170604202528.GH9464@cbox> <5b8acdaf-e5a5-25fd-fffe-5ff42d501ee0@arm.com> <20170605101609.GA12884@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170605101609.GA12884@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 5 June 2017 at 11:16, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Jun 05, 2017 at 10:58:57AM +0100, Marc Zyngier wrote:
>> From the ICC_BPR0_EL1 documentation:
>>
>> "An attempt to program the binary point field to a value less than the
>> minimum value sets the field to the minimum value."
>>
>> That's the only way you can find out about the minimum value (and the
>> kernel also uses this functionality to be in a known state, even if it
>> doesn't use preemption yet).
>>
>
> Hmm, the ICV_BPR0_EL1 says:
>   "An attempt to program the binary point field to a value less than the
>   minimum value sets the field to the minimum value. On a reset, the
>   binary point field is set to the minimum supported value."
>
> But then the ICV_BPR1_EL1 says:
>   "An attempt to program the binary point field to a value less than the
>   reset value sets the field to the reset value."
>
>   and
>
>   "Writing 0 to this field will set this field to its reset value, which
>   is IMPLEMENTATION DEFINED and non-zero."

It also later says that the ICV_BPR1_EL1 IMPDEF reset value is always
the ICV_BPR0_EL1 reset value plus one.

> So it seems like the spec is making some distinction between minimum or
> reset value and between the two registers, but I'm not sure if the spec
> is just having its fun with us, or if there's something important to be
> aware of here.

I think the plus-one is the only interesting difference and the
rest is just accidental difference of wording.

There is a difference between ICV_BPR* and ICC_BPR*, which is that
the latter reset to an UNKNOWN value, not necessarily the minimum.

thanks
-- PMM
