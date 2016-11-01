From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Add ARM arch timer interrupts ABI
Date: Tue, 1 Nov 2016 14:54:11 +0000
Message-ID: <CAFEAcA_mdrTUBBDV91X3Zo6pNzVaukQ7foN+cPt_41+ouBdEfQ@mail.gmail.com>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <20160927190806.22988-3-christoffer.dall@linaro.org>
 <CAFEAcA8x9Rt7SwXfqC8QOuXUEysrGBvYZW_=9ZA+pNgYu7HbTA@mail.gmail.com>
 <20161101145019.GB13677@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7DC34029B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 10:54:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wOU5Fgx8C4Tx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2016 10:54:21 -0400 (EDT)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
 [209.85.213.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EB1440286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 10:54:21 -0400 (EDT)
Received: by mail-vk0-f44.google.com with SMTP id d65so103705358vkg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2016 07:54:32 -0700 (PDT)
In-Reply-To: <20161101145019.GB13677@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 1 November 2016 at 14:50, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Tue, Nov 01, 2016 at 11:26:54AM +0000, Peter Maydell wrote:
>> Possible current and future outbound interrupt lines (some of these
>> would only show up in some unlikely or lots-of-implementation-needed
>> cases, I'm just trying to produce an exhaustive list):
>>  * virtual timer
>>  * physical timer
>>  * hyp timer (nested virtualization case)
>>  * secure timer (unlikely but maybe if EL3 is ever supported inside a VM)
>>  * gic maintenance interrupt (nested virt again)
>>  * PMU interrupt
>
> Thanks for the list, that's good to have around for the future.
>
> There's also the potential of the EL2 virtual timer for nested VHE
> support, right?

That's the one I meant by "hyp timer".

>> The kernel doesn't know which interrupt number these would be wired
>> up to, so they're all just arbitrary outputs, and you could put them
>> in one field or split them up into multiple fields, it doesn't make
>> much difference.
>>
>
> So if we keep this we're kind of suggesting that we'll have a field per
> device type later on.  Since this is a u8 and we are talking about up 5
> 5 timers already,

4.

> there's not much waste currently, and we have plenty
> of padding.  I suppose we an always add a 'other_devices' thing later,
> so I prefer just sticking with this one for now.

Yeah, it's not a big deal either way.

thanks
-- PMM
