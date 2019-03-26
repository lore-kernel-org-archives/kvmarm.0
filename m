From: Heyi Guo <guoheyi@huawei.com>
Subject: Re: [RFC] arm/cpu: fix soft lockup panic after resuming from stop
Date: Tue, 26 Mar 2019 19:54:21 +0800
Message-ID: <662367df-e702-dd0a-da83-f1b448c5f203@huawei.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
 <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
 <136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
 <22f57e8a-bdb0-ffeb-ab78-3e9e41cac66b@arm.com>
 <20190315085948.GB10950@e113682-lin.lund.arm.com>
 <ff1db661-13c2-50ff-940e-4a1d71bd0309@huawei.com>
 <101c5f17-9811-e2d0-ff3c-a0e64beee921@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 435D44A37D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 07:54:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cAhCpqKitkwW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 07:54:28 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD03B4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 07:54:27 -0400 (EDT)
In-Reply-To: <101c5f17-9811-e2d0-ff3c-a0e64beee921@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-arm <qemu-arm@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Steven,

Thanks for your explanation. Please see my comments below.


On 2019/3/21 0:29, Steven Price wrote:
> On 19/03/2019 14:39, Heyi Guo wrote:
>> Hi Christoffer and Steve,
>>
>>
>> On 2019/3/15 16:59, Christoffer Dall wrote:
>>> Hi Steve,
>>>
>>> On Wed, Mar 13, 2019 at 10:11:30AM +0000, Steven Price wrote:
>>>> Personally I think what we need is:
>>>>
>>>> * Either a patch like the one from Heyi Guo (save/restore CNTVCT_EL0) or
>>>> alternatively hooking up KVM_KVMCLOCK_CTRL to prevent the watchdog
>>>> firing when user space explicitly stops scheduling the guest for a
>>>> while.
>>> If we save/restore CNTVCT_EL0 and the warning goes away, does the guest
>>> wall clock timekeeping get all confused and does it figure this out
>>> automagically somehow?
>> What's the source for guest wall clock timekeeping in current ARM64
>> implementation? Is it the value from CNTP_TVAL_EL0? Will guest OS keep
>> track of this? Or is the wall clock simply platform RTC?
>>
>> I tested the RFC change and did not see anything unusual. Did I miss
>> someting?
> Are you running ARM or ARM64? I'm assuming ARM64 here...
Yes, definitely :)

>
> Unless I'm mistaken you should see the time reported by the guest not
> progress when you have stopped it using the QEMU monitor console.
>
> Running something like "while /bin/true; do date; sleep 1; done" should
> allow you to see that without the patch time will jump in the guest
> (i.e. the time reflects wall-clock time). With the patch I believe it
> will not jump (i.e. the clock will be behind wall-clock time after the
> pause).
I did the test and the result was exactly like you said.
>
> However, this behaviour does depend on the exact system being emulated.
> >From drivers/clocksource/arm_arch_timer.c:
>
>> static void __init arch_counter_register(unsigned type)
>> {
>> 	u64 start_count;
>>
>> 	/* Register the CP15 based counter if we have one */
>> 	if (type & ARCH_TIMER_TYPE_CP15) {
>> 		if ((IS_ENABLED(CONFIG_ARM64) && !is_hyp_mode_available()) ||
>> 		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
>> 			arch_timer_read_counter = arch_counter_get_cntvct;
>> 		else
>> 			arch_timer_read_counter = arch_counter_get_cntpct;
>>
>> 		clocksource_counter.archdata.vdso_direct = vdso_default;
>> 	} else {
>> 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
>> 	}
> So we can see here that there are three functions for reading the
> counter - there's the memory interface for CNTVCT, the "CP15" interface
> also for CNTVCT, and an interface for CNTPCT. CNTPCT is only used for
> !ARM64 or if hyp mode is available (not relevant until nested
> virtualisation is added).
>
> The upshot is that on arm64 we're using the virtual counter (CNTVCT).
>
>>> Does KVM_KVMCLOCK_CTRL solve that problem?
>> It seems KVM_KVMCLOCK_CTRL is dedicated for guest pause/resume scenario,
>> but it relies on pvclock both in KVM and Guest and right now only X86
>> supports it :(
> KVM_KVMCLOCK_CTRL simply provides a mechanism for the host to inform the
> guest that a vCPU hasn't been scheduled for "a while". The guest can
> then use that information to avoid triggering the watchdog timeout. As
> you note it is only currently implemented for X86.
>
>> Could Steve provide more insights about the whole thing?
> I'll try - see below.
>
>> Thanks,
>> Heyi
>>
>>>> * KVM itself saving/restoring CNTVCT_EL0 during suspend/resume so the
>>>> guest doesn't see time pass during a suspend.
>>> This smells like policy to me so I'd much prefer keeping as much
>>> functionality in user space as possible.  If we already have the APIs we
>>> need from KVM, let's use them.
> The problem with suspend/resume is that user space doesn't get a
> look-in. There's no way (generically) for a user space application to
> save/restore registers during the suspend. User space simply sees time
> jump forwards - which is precisely what we're trying to hide from the
> guest (as it otherwise gets upset that it appears a vCPU has deadlocked
> for a while).
>
> So while I agree this is "policy", it's something we need the kernel to
> do on our behalf. Potentially we can put it behind an ioctl so that user
> space can opt-in to it.
>
>>>> * Something equivalent to MSR_KVM_WALL_CLOCK_NEW for arm which allows
>>>> the guest to query the wall clock time from the host and provides an
>>>> offset between CNTVCT_EL0 to wall clock time which the KVM can update
>>>> during suspend/resume. This means that during a suspend/resume the guest
>>>> can observe that wall clock time has passed, without having to be
>>>> bothered about CNTVCT_EL0 jumping forwards.
>>>>
>>> Isn't the proper Arm architectural solution for this to read the
>>> physical counter for wall clock time keeping ?
>>>
>>> (Yes that will require a trap on physical counter reads after migration
>>> on current systems, but migration sucks in terms of timekeeping
>>> already.)
> The physical counter is certainly tempting as it largely does what we
> want as a secondary counter. However I'm wary of using it because it
> starts to get "really interesting" when dealing with nested
> virtualisation. Any by "really interesting" I of course mean horribly
> broken :)
>
> Basically the problem is that with nested virtualisation the offset
> between the physical counter and the virtual counter is controlled by
> the virtual-EL2. Because we want certain behaviours of the virtual
> counter (pausing when the guest pauses) we have to replicate that onto
> the physical counter to maintain the offset between the two that the
> guest expects.
>
> Given that it seems to be a non-starter when you introduce nested virt I
> think we should just bite the bullet and implement a PV wall clock
> mechanism for arm64 (similar to MSR_KVM_WALL_CLOCK_NEW).

If we decide to implement something like pvclock, shall we increase the priority of this work? It seems there is much to do, including the spec, KVM, qemu and guest kernel driver...

Thanks,

Heyi

>
> This also has the advantage that it is going to be faster than the
> physical counter when that has to be trapped (e.g. after migration).
>
> Steve
>
> .
>
