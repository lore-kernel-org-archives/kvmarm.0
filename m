From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC v2 02/10] KVM: arm/arm64: Move cntvoff to each timer context
Date: Mon, 30 Jan 2017 12:40:50 -0500
Message-ID: <CAHyh4xjixnBDS-wt5AoE2vhShKbZm+ngtJotyX9w2YMBrS-7WQ@mail.gmail.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-3-git-send-email-jintack@cs.columbia.edu>
 <867f5e9j4y.fsf@arm.com> <20170130144550.GA16459@cbox>
 <2453da50-d827-0aa5-1dea-beb35117d1ae@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F6A408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:40:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oPZdAEDdv9Rk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 12:40:35 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EB4B40838
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:40:34 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UHcK6i015155
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:40:52 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id DBD0D81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:40:52 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id BFC2486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:40:52 -0500 (EST)
Received: from mail-ua0-f198.google.com (mail-ua0-f198.google.com
 [209.85.217.198])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0UHeq4q046191
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 12:40:52 -0500
Received: by mail-ua0-f198.google.com with SMTP id 7so204511962uas.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:40:52 -0800 (PST)
Received: from mail-ua0-f176.google.com (mail-ua0-f176.google.com.
 [209.85.217.176])
 by smtp.gmail.com with ESMTPSA id j201sm5178358vkf.28.2017.01.30.09.40.51
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 30 Jan 2017 09:40:51 -0800 (PST)
Received: by mail-ua0-f176.google.com with SMTP id 35so255291010uak.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 09:40:51 -0800 (PST)
In-Reply-To: <2453da50-d827-0aa5-1dea-beb35117d1ae@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux@armlinux.org.uk, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 30, 2017 at 9:51 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 30/01/17 14:45, Christoffer Dall wrote:
>> On Sun, Jan 29, 2017 at 11:54:05AM +0000, Marc Zyngier wrote:
>>> On Fri, Jan 27 2017 at 01:04:52 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>>> Make cntvoff per each timer context. This is helpful to abstract kvm
>>>> timer functions to work with timer context without considering timer
>>>> types (e.g. physical timer or virtual timer).
>>>>
>>>> This also would pave the way for ever doing adjustments of the cntvoff
>>>> on a per-CPU basis if that should ever make sense.
>>>>
>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>> ---
>>>>  arch/arm/include/asm/kvm_host.h   |  6 +++---
>>>>  arch/arm64/include/asm/kvm_host.h |  4 ++--
>>>>  include/kvm/arm_arch_timer.h      |  8 +++-----
>>>>  virt/kvm/arm/arch_timer.c         | 26 ++++++++++++++++++++------
>>>>  virt/kvm/arm/hyp/timer-sr.c       |  3 +--
>>>>  5 files changed, 29 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>> index d5423ab..f5456a9 100644
>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>> @@ -60,9 +60,6 @@ struct kvm_arch {
>>>>     /* The last vcpu id that ran on each physical CPU */
>>>>     int __percpu *last_vcpu_ran;
>>>>
>>>> -   /* Timer */
>>>> -   struct arch_timer_kvm   timer;
>>>> -
>>>>     /*
>>>>      * Anything that is not used directly from assembly code goes
>>>>      * here.
>>>> @@ -75,6 +72,9 @@ struct kvm_arch {
>>>>     /* Stage-2 page table */
>>>>     pgd_t *pgd;
>>>>
>>>> +   /* A lock to synchronize cntvoff among all vtimer context of vcpus */
>>>> +   spinlock_t cntvoff_lock;
>>>
>>> Is there any condition where we need this to be a spinlock? I would have
>>> thought that a mutex should have been enough, as this should only be
>>> updated on migration or initialization. Not that it matters much in this
>>> case, but I wondered if there is something I'm missing.
>>>
>>
>> I would think the critical section is small enough that a spinlock makes
>> sense, but what I don't think we need is to add the additional lock.
>>
>> I think just taking the kvm->lock should be sufficient, which happens to
>> be a mutex, and while that may be a bit slower to take than the
>> spinlock, it's not in the critical path so let's just keep things
>> simple.
>>
>> Perhaps this what Marc also meant.
>
> That would be the logical conclusion, assuming that we can sleep on this
> path.

All right. I'll take kvm->lock there.

Thanks,
Jintack

>
> Thanks,
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
