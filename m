Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C3FC433E1
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 02:11:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF28D20759
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 02:11:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF28D20759
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC9F14B6BE;
	Mon, 27 Jul 2020 22:11:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rbgLdK+hyqg7; Mon, 27 Jul 2020 22:11:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C22C4B74F;
	Mon, 27 Jul 2020 22:11:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3AD74B736
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 22:11:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o3XHhlyvy-r9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 22:11:20 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D6EA4B45E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 22:11:19 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 9222F7E9A918F4D075A6;
 Tue, 28 Jul 2020 10:11:11 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 10:11:00 +0800
Subject: Re: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
To: Marc Zyngier <maz@kernel.org>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
 <e120ec04-24d5-f1cb-3aa2-8baf3d6da1db@huawei.com>
 <015847afd67e8bd4f8a158b604854838@kernel.org>
 <4eee3e4c-db73-c4ce-ca3d-d665ee87d66a@huawei.com>
 <87mu43xy94.wl-maz@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <884bd32d-c8ba-6237-82f6-1769a83289f5@huawei.com>
Date: Tue, 28 Jul 2020 10:11:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87mu43xy94.wl-maz@kernel.org>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/7/13 22:53, Marc Zyngier wrote:
> Hi Keqian,
> 
> On Mon, 13 Jul 2020 03:47:25 +0100,
> zhukeqian <zhukeqian1@huawei.com> wrote:
>>
>> Hi Marc,
>>
>> Sorry for the delay reply.
>>
>> On 2020/7/6 15:54, Marc Zyngier wrote:
>>> Hi Keqian,
>>>
>>> On 2020-07-06 02:28, zhukeqian wrote:
>>>> Hi Catalin and Marc,
>>>>
>>>> On 2020/7/2 21:55, Keqian Zhu wrote:
>>>>> This patch series add support for dirty log based on HW DBM.
>>>>>
>>>>> It works well under some migration test cases, including VM with 4K
>>>>> pages or 2M THP. I checked the SHA256 hash digest of all memory and
>>>>> they keep same for source VM and destination VM, which means no dirty
>>>>> pages is missed under hardware DBM.
>>>>>
>>>>> Some key points:
>>>>>
>>>>> 1. Only support hardware updates of dirty status for PTEs. PMDs and PUDs
>>>>>    are not involved for now.
>>>>>
>>>>> 2. About *performance*: In RFC patch, I have mentioned that for every 64GB
>>>>>    memory, KVM consumes about 40ms to scan all PTEs to collect dirty log.
>>>>>    This patch solves this problem through two ways: HW/SW dynamic switch
>>>>>    and Multi-core offload.
>>>>>
>>>>>    HW/SW dynamic switch: Give userspace right to enable/disable hw dirty
>>>>>    log. This adds a new KVM cap named KVM_CAP_ARM_HW_DIRTY_LOG. We can
>>>>>    achieve this by change the kvm->arch.vtcr value and kick vCPUs out to
>>>>>    reload this value to VCTR_EL2. Then userspace can enable hw dirty log
>>>>>    at the begining and disable it when dirty pages is little and about to
>>>>>    stop VM, so VM downtime is not affected.
>>>>>
>>>>>    Multi-core offload: Offload the PT scanning workload to multi-core can
>>>>>    greatly reduce scanning time. To promise we can complete in time, I use
>>>>>    smp_call_fuction to realize this policy, which utilize IPI to dispatch
>>>>>    workload to other CPUs. Under 128U Kunpeng 920 platform, it just takes
>>>>>    about 5ms to scan PTs of 256 RAM (use mempress and almost all PTs have
>>>>>    been established). And We dispatch workload iterately (every CPU just
>>>>>    scan PTs of 512M RAM for each iteration), so it won't affect physical
>>>>>    CPUs seriously.
>>>>
>>>> What do you think of these two methods to solve high-cost PTs scaning? Maybe
>>>> you are waiting for PML like feature on ARM :-) , but for my test, DBM is usable
>>>> after these two methods applied.
>>>
>>> Useable, maybe. But leaving to userspace the decision to switch from one
>>> mode to another isn't an acceptable outcome. Userspace doesn't need nor
>>> want to know about this.
>>>
>> OK, maybe this is worth discussing. The switch logic can be
>> encapsulated into Qemu and can not be seen from VM users. Well, I
>> think it maybe acceptable. :)
> 
> I'm sorry, but no, this isn't acceptable. Userspace is concerned with
> finding out about the dirty pages, and nothing else. The method by
> which you exposes which pages are dirty is not the business of
> userspace *at all*.
OK.
> 
>>
>>> Another thing is that sending IPIs all over to trigger scanning may
>>> work well on a system that runs a limited number of guests (or some
>>> other userspace, actually), but I seriously doubt that it is impact
>>> free once you start doing this on an otherwise loaded system.
>>>
>> Yes, it is not suitable to send IPIs to all other physical
>> CPUs. Currently I just want to show you my idea and to prove it is
>> effective. In real cloud product, we have resource isolation
>> mechanism, so we will have a bit worse result (compared to 5ms) but
>> we won't effect other VMs.
> 
> If you limit the IPIs to the CPUs running the VM, they you are already
> in a situation where you effectively stop the guest to parse the S2
> page tables.
> 
>>
>>> You may have better results by having an alternative mapping of your
>>> S2 page tables so that they are accessible linearly, which would
>>> sidestep the PT parsing altogether, probably saving some cycles. But
>> Yeah, this is a good idea. But for my understanding, to make them
>> linear, we have to preserve enough physical memory at VM start (may
>> waste much memory), and the effect of this optimization *maybe* not
>> obvious.
> 
> Well, you'd have to have another set of PT to map the S2
> linearly. Yes, it consumes memory.
> 
>>
>>> this is still a marginal gain compared to the overall overhead of
>>> scanning 4kB of memory per 2MB of guest RAM, as opposed to 64 *bytes*
>>> per 2MB (assuming strict 4kB mappings at S2, no block mappings).
>>>
>> I ever tested scanning PTs by reading only one byte of each PTE and
>> the test result keeps same.  So, when we scan PTs using just one
>> core, the bottle-neck is CPU speed, instead of memory bandwidth.
> 
> But you are still reading the leaf entries of the PTs, hence defeating
> any sort of prefetch that the CPU could do for you. And my claim is
> that reading the bitmap is much faster than parsing the PTs. Are you
> saying that this isn't the case?
I am confused here. MMU DBM just updates the S2AP[1] of PTs, so dirty information
is not continuous. The smallest granularity of read instruction is one byte, we must
read one byte of each PTE to determine whether it is dirty. So I think the smallest
reading amount is 512 bytes per 2MB.

I write a demo and find that scanning linear PTs (without parsing) to sync dirty log
can reduce half of time, but this is still unacceptable for VM migration.
> 
>>> Finally, this doesn't work with pages dirtied from DMA, which is the
>>> biggest problem. If you cannot track pages that are dirtied behind your
>>> back, what is the purpose of scanning the dirty bits?
>>>
>>> As for a PML-like feature, this would only be useful if the SMMU
>>> architecture took part in it and provided consistent logging of
>>> the dirtied pages in the IPA space. Only having it at the CPU level
>>> would be making the exact same mistake.
>>
>> Even SMMU is equipped with PML like feature, we still rely on device
>> suspend to avoid omitting dirty pages, so I think the only advantage
>> of PML is reducing dirty log sync time compared to multi-core
>> offload. Maybe I missing something?
> 
> I don't see why you would rely on stopping DMA if you can track all
> the dirty pages in a unified way (SMMU + CPU sharing a single log). It
> doesn't matter anyway, since such HW doesn't exist, and won't exist
> for the foreseeable future.
For that it must take some time to send dirty page to destination host, during which, DMA
operation generates new dirty pages. If DMA can not be stopped, we can not find a time point
when all dirty memory is sent out. As for x86 MMU with hardware dirty log and PML, it also
need to stop vCPU when migration is about to complete.

> 
> As for the S2 DBM, I still remain unconvinced. My take still is that
> without a good story for tracking DMA, this only makes the S2 MMU code
> more complex, without any concrete benefit. Without DMA, what we have
> today is adequate, and doesn't require exposing yet another userspace
> interface.
> 
> If you solve the DMA issue, I'll be more than happy to reconsider.
> 
> Thanks,
> 
> 	M.
> 
Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
