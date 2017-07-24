From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests 2/3] arm64: timer: Fix test on APM X-Gene
Date: Mon, 24 Jul 2017 23:25:50 +0200
Message-ID: <CAMJs5B-CbRdDPO31XaWuDp0=um5KpePZGBVEw+mU9EnZkZFKwg@mail.gmail.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-3-cdall@linaro.org>
 <a58bfe11-19a0-aa92-5166-2c33e4cb8981@arm.com> <20170714154512.GC1535@lvm>
 <20170718100503.crn2dgqlalrirzqw@kamzik.brq.redhat.com>
 <20170718103512.GB14069@cbox>
 <20170718121527.ptemrr6mbhfwwbwe@kamzik.brq.redhat.com>
 <b7900fdf-bcc0-00af-bf5d-940eca09e4ae@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4881540D29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jul 2017 17:24:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pci09R8r-BMm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jul 2017 17:24:51 -0400 (EDT)
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com
 [209.85.161.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8372B40CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jul 2017 17:24:51 -0400 (EDT)
Received: by mail-yw0-f171.google.com with SMTP id a12so57010450ywh.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jul 2017 14:25:52 -0700 (PDT)
In-Reply-To: <b7900fdf-bcc0-00af-bf5d-940eca09e4ae@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 24, 2017 at 7:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 18/07/2017 14:15, Andrew Jones wrote:
>>>
>>> If we want to add a "the platform provides a timer with 56 valid bits in
>>> the counter and compare register", then I think it should be a separate
>>> test, and the the user can see that "basic stuff works", "architecture
>>> compliance not so much" and shrug accordingly.
>> Two separate tests sounds good to me. Although, if the value of 'now' is
>> large enough that now + 10s will set bit 31, then a mustang run (at least
>> mine) will fail - and most likely cause a lot of confusion, since it
>> normally does not. We should probably attempt to address that known issue
>> in some way as well.
>
> Is the value relative to vm startup or host startup?
>
For the virtual timer, KVM currently resets the counter to zero (so VM
startup) and for the physical timer it's since host startup.

I confirmed the behavior Drew reported on my mustang too, but it only
appears to apply for the vtimer when writing cval with bit 31 set, not
for the ptimer.  I was thinking that this may be a problem with KVM,
some sort of signed bit extension problem, but since the problem
doesn't show up on other platforms, it may just be a problem there.
Shrug.

Anyway, since it works with the ptimer, and we should have at least 56
bits of counter space at ~50 MHz, we should be fine here.

Thanks,
-Christoffer
