Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741AEC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 02:09:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBF4D206D5
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 02:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBF4D206D5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C0414B1F8;
	Mon, 25 May 2020 22:09:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0mdGysmO3liL; Mon, 25 May 2020 22:09:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 604A24B1FB;
	Mon, 25 May 2020 22:09:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D65514B19B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 22:09:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cc-sIaiGv4ox for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 22:09:14 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A6734B12B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 22:09:14 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id F30B0F64F7B95E6413C3;
 Tue, 26 May 2020 10:09:10 +0800 (CST)
Received: from [10.173.221.230] (10.173.221.230) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Tue, 26 May 2020 10:09:04 +0800
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Support stage2 hardware DBM
To: Marc Zyngier <maz@kernel.org>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
 <4b8a939172395bf38e581634abecf925@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <66deb797-726f-242b-82fb-0ddee975ef15@huawei.com>
Date: Tue, 26 May 2020 10:08:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <4b8a939172395bf38e581634abecf925@kernel.org>
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Sean
 Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020/5/25 23:44, Marc Zyngier wrote:
> On 2020-05-25 12:23, Keqian Zhu wrote:
>> This patch series add support for stage2 hardware DBM, and it is only
>> used for dirty log for now.
>>
>> It works well under some migration test cases, including VM with 4K
>> pages or 2M THP. I checked the SHA256 hash digest of all memory and
>> they keep same for source VM and destination VM, which means no dirty
>> pages is missed under hardware DBM.
>>
>> However, there are some known issues not solved.
>>
>> 1. Some mechanisms that rely on "write permission fault" become invalid,
>>    such as kvm_set_pfn_dirty and "mmap page sharing".
>>
>>    kvm_set_pfn_dirty is called in user_mem_abort when guest issues write
>>    fault. This guarantees physical page will not be dropped directly when
>>    host kernel recycle memory. After using hardware dirty management, we
>>    have no chance to call kvm_set_pfn_dirty.
> 
> Then you will end-up with memory corruption under memory pressure.
> This also breaks things like CoW, which we depend on.
>
Yes, these problems looks knotty. But I think x86 PML support will face these
problems too. I believe there must be some methods to solve them.
>>
>>    For "mmap page sharing" mechanism, host kernel will allocate a new
>>    physical page when guest writes a page that is shared with other page
>>    table entries. After using hardware dirty management, we have no chance
>>    to do this too.
>>
>>    I need to do some survey on how stage1 hardware DBM solve these problems.
>>    It helps if anyone can figure it out.
>>
>> 2. Page Table Modification Races: Though I have found and solved some data
>>    races when kernel changes page table entries, I still doubt that there
>>    are data races I am not aware of. It's great if anyone can figure them out.
>>
>> 3. Performance: Under Kunpeng 920 platform, for every 64GB memory, KVM
>>    consumes about 40ms to traverse all PTEs to collect dirty log. It will
>>    cause unbearable downtime for migration if memory size is too big. I will
>>    try to solve this problem in Patch v1.
> 
> This, in my opinion, is why Stage-2 DBM is fairly useless.
> From a performance perspective, this is the worse possible
> situation. You end up continuously scanning page tables, at
> an arbitrary rate, without a way to evaluate the fault rate.
> 
> One thing S2-DBM would be useful for is SVA, where a device
> write would mark the S2 PTs dirty as they are shared between
> CPU and SMMU. Another thing is SPE, which is essentially a DMA
> agent using the CPU's PTs.
> 
> But on its own, and just to log the dirty pages, S2-DBM is
> pretty rubbish. I wish arm64 had something like Intel's PML,
> which looks far more interesting for the purpose of tracking
> accesses.

Sure, PML is a better solution on hardware management of dirty state.
However, compared to optimizing hardware, optimizing software is with
shorter cycle time.

Here I have an optimization in mind to solve it. Scanning page tables
can be done parallel, which can greatly reduce time consumption. For there
is no communication between parallel CPUs, we can achieve high speedup
ratio.


> 
> Thanks,
> 
>         M.
Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
