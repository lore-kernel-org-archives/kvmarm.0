From: Heyi Guo <guoheyi@huawei.com>
Subject: Re: [RFC] arm/cpu: fix soft lockup panic after resuming from stop
Date: Tue, 19 Mar 2019 22:39:25 +0800
Message-ID: <ff1db661-13c2-50ff-940e-4a1d71bd0309@huawei.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
 <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
 <136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
 <22f57e8a-bdb0-ffeb-ab78-3e9e41cac66b@arm.com>
 <20190315085948.GB10950@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45DB94A3BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 10:39:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kW8IW-JWmUXI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 10:39:31 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C8F14A3B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 10:39:31 -0400 (EDT)
In-Reply-To: <20190315085948.GB10950@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-arm <qemu-arm@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer and Steve,


On 2019/3/15 16:59, Christoffer Dall wrote:
> Hi Steve,
>
> On Wed, Mar 13, 2019 at 10:11:30AM +0000, Steven Price wrote:
>> Personally I think what we need is:
>>
>> * Either a patch like the one from Heyi Guo (save/restore CNTVCT_EL0) or
>> alternatively hooking up KVM_KVMCLOCK_CTRL to prevent the watchdog
>> firing when user space explicitly stops scheduling the guest for a while.
> If we save/restore CNTVCT_EL0 and the warning goes away, does the guest
> wall clock timekeeping get all confused and does it figure this out
> automagically somehow?
What's the source for guest wall clock timekeeping in current ARM64 implementation? Is it the value from CNTP_TVAL_EL0? Will guest OS keep track of this? Or is the wall clock simply platform RTC?

I tested the RFC change and did not see anything unusual. Did I miss someting?

>
> Does KVM_KVMCLOCK_CTRL solve that problem?
It seems KVM_KVMCLOCK_CTRL is dedicated for guest pause/resume scenario, but it relies on pvclock both in KVM and Guest and right now only X86 supports it :(

Could Steve provide more insights about the whole thing?

Thanks,
Heyi

>
>> * KVM itself saving/restoring CNTVCT_EL0 during suspend/resume so the
>> guest doesn't see time pass during a suspend.
> This smells like policy to me so I'd much prefer keeping as much
> functionality in user space as possible.  If we already have the APIs we
> need from KVM, let's use them.
>
>> * Something equivalent to MSR_KVM_WALL_CLOCK_NEW for arm which allows
>> the guest to query the wall clock time from the host and provides an
>> offset between CNTVCT_EL0 to wall clock time which the KVM can update
>> during suspend/resume. This means that during a suspend/resume the guest
>> can observe that wall clock time has passed, without having to be
>> bothered about CNTVCT_EL0 jumping forwards.
>>
> Isn't the proper Arm architectural solution for this to read the
> physical counter for wall clock time keeping ?
>
> (Yes that will require a trap on physical counter reads after migration
> on current systems, but migration sucks in terms of timekeeping
> already.)
>
>
> Thanks,
>
>      Christoffer
>
> .
>
