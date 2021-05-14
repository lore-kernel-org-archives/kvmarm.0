Return-Path: <SRS0=YHuQ=KK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07037C433ED
	for <kvmarm@archiver.kernel.org>; Sat, 15 May 2021 11:36:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C4CE61168
	for <kvmarm@archiver.kernel.org>; Sat, 15 May 2021 11:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C4CE61168
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A194B343;
	Sat, 15 May 2021 07:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jorCrL+XkUFW; Sat, 15 May 2021 07:36:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B1D4B438;
	Sat, 15 May 2021 07:36:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D5D4B893
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 22:18:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mc+QJP+aldI1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 22:18:29 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 101E94B8FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 22:18:29 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FhBvg3F1SzqV51;
 Fri, 14 May 2021 10:15:43 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 10:18:22 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
To: Mike Rapoport <rppt@kernel.org>
References: <82cfbb7f-dd4f-12d8-dc76-847f06172200@huawei.com>
 <b077916e-d3f7-ec6c-8c80-b5b642ee111f@huawei.com>
 <YJUWywpGwOpM8hzo@kernel.org>
 <33c67e13-dc48-9a2f-46d8-a532e17380fb@huawei.com>
 <YJd6QXcmVl+HM4Ob@kernel.org>
 <b91cd653-842b-0e77-5c00-17a0ac9c4b50@huawei.com>
 <YJpEwF2cGjS5mKma@kernel.org>
 <c3006cd0-fff6-ab45-da83-a216d40388f2@huawei.com>
 <YJuRPVWubjQKyKBj@kernel.org>
 <f0034620-b95b-3ba5-f7a2-c8be33d842c7@huawei.com>
 <YJ0Fhs5krPJ0FgiV@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <546307d6-790b-78d4-d832-84f143d4d40a@huawei.com>
Date: Fri, 14 May 2021 10:18:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YJ0Fhs5krPJ0FgiV@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Sat, 15 May 2021 07:36:51 -0400
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, Mike
 Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2021/5/13 18:55, Mike Rapoport wrote:
> On Thu, May 13, 2021 at 11:44:00AM +0800, Kefeng Wang wrote:
>> On 2021/5/12 16:26, Mike Rapoport wrote:
>>> On Wed, May 12, 2021 at 11:08:14AM +0800, Kefeng Wang wrote:
>>>>
>>>> On 2021/5/11 16:48, Mike Rapoport wrote:
>>>>> On Mon, May 10, 2021 at 11:10:20AM +0800, Kefeng Wang wrote:
>>>>>>
>>>>>>>> The memory is not continuous, see MEMBLOCK:
>>>>>>>>      memory size = 0x4c0fffff reserved size = 0x027ef058
>>>>>>>>      memory.cnt  = 0xa
>>>>>>>>      memory[0x0]    [0x80a00000-0x855fffff], 0x04c00000 bytes flags: 0x0
>>>>>>>>      memory[0x1]    [0x86a00000-0x87dfffff], 0x01400000 bytes flags: 0x0
>>>>>>>>      memory[0x2]    [0x8bd00000-0x8c4fffff], 0x00800000 bytes flags: 0x0
>>>>>>>>      memory[0x3]    [0x8e300000-0x8ecfffff], 0x00a00000 bytes flags: 0x0
>>>>>>>>      memory[0x4]    [0x90d00000-0xbfffffff], 0x2f300000 bytes flags: 0x0
>>>>>>>>      memory[0x5]    [0xcc000000-0xdc9fffff], 0x10a00000 bytes flags: 0x0
>>>>>>>>      memory[0x6]    [0xde700000-0xde9fffff], 0x00300000 bytes flags: 0x0
>>>>>>>> ...
>>>>>>>>
>>>>>>>> The pfn_range [0xde600,0xde700] => addr_range [0xde600000,0xde700000]
>>>>>>>> is not available memory, and we won't create memmap , so with or without
>>>>>>>> your patch, we can't see the range in free_memmap(), right?
>>>>>>>
>>>>>>> This is not available memory and we won't see the reange in free_memmap(),
>>>>>>> but we still should create memmap for it and that's what my patch tried to
>>>>>>> do.
>>>>>>>
>>>>>>> There are a lot of places in core mm that operate on pageblocks and
>>>>>>> free_unused_memmap() should make sure that any pageblock has a valid memory
>>>>>>> map.
>>>>>>>
>>>>>>> Currently, that's not the case when SPARSEMEM=y and my patch tried to fix
>>>>>>> it.
>>>>>>>
>>>>>>> Can you please send log with my patch applied and with the printing of
>>>>>>> ranges that are freed in free_unused_memmap() you've used in previous
>>>>>>> mails?
>>>>>
>>>>>> with your patch[1] and debug print in free_memmap,
>>>>>> ----> free_memmap, start_pfn = 85800,  85800000 end_pfn = 86800, 86800000
>>>>>> ----> free_memmap, start_pfn = 8c800,  8c800000 end_pfn = 8e000, 8e000000
>>>>>> ----> free_memmap, start_pfn = 8f000,  8f000000 end_pfn = 90000, 90000000
>>>>>> ----> free_memmap, start_pfn = dcc00,  dcc00000 end_pfn = de400, de400000
>>>>>> ----> free_memmap, start_pfn = dec00,  dec00000 end_pfn = e0000, e0000000
>>>>>> ----> free_memmap, start_pfn = e0c00,  e0c00000 end_pfn = e4000, e4000000
>>>>>> ----> free_memmap, start_pfn = f7000,  f7000000 end_pfn = f8000, f8000000
>>>>>
>>>>> It seems that freeing of the memory map is suboptimal still because that
>>>>> code was not designed for memory layout that has more holes than Swiss
>>>>> cheese.
>>>>>
>>>>> Still, the range [0xde600,0xde700] is not freed and there should be struct
>>>>> pages for this range.
>>>>>
>>>>> Can you add
>>>>>
>>>>> 	dump_page(pfn_to_page(0xde600), "");
>>>>>
>>>>> say, in the end of memblock_free_all()?
>>>>>
>>>> The range [0xde600,0xde700] is not memory, so it won't create struct page
>>>> for it when sparse_init?
>>>
>>> sparse_init() indeed does not create memory map for unpopulated memory, but
>>> it has pretty coarse granularity, i.e. 64M in your configuration. A hole
>>> should be at least 64M in order to skip allocation of the memory map for
>>> it.
>>>
>>> For example, your memory layout has a hole of 192M at pfn 0xc0000 and this
>>> hole won't have the memory map.
>>>
>>> However the hole 0xdca00 - 0xde70 will still have a memory map in the
>>> section  that covers 0xdc000 - 0xe0000.
>>>
>>> I've tried outline this in a sketch below, hope it helps.
>>>
>>> Memory:
>>>                             c0000      cc000                      dca00
>>> --------------------------+          +--------------------------+ +----+
>>>    memory bank              |<- hole ->| memory bank              | | mb |
>>> --------------------------+          +--------------------------+ +----+
>>>                                                                   de700  dea00
>>>
>>> Memory map:
>>>
>>> b0000    b4000            c0000      cc000   d0000    d8000    dc000
>>> +--------+--------+- ... -+          +--------+- ... -+--------+---------+
>>> | memmap | memmap | ...   |<- hole ->| memmap |  ...  | memmap | memmap  |
>>> +--------+--------+- ... -+          +--------+- ... -+--------+---------+
>>>
>>>
>> Thanks for the sketch, it is more clear,
>>
>>>> After apply patch[1], the dump_page log,
>>>>
>>>> page:ef3cc000 is uninitialized and poisoned
>>>> raw: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
>>>> page dumped because:
>>>
>>> This means that there is a memory map entry, and it got poisoned during the
>>> initialization and never got reinitialized to sensible values, which would
>>> be PageReserved() in this case.
>>>
>>> I believe this was fixed by commit 0740a50b9baa ("mm/page_alloc.c: refactor
>>> initialization of struct page for holes in memory layout") in the mainline
>>> tree.
>>>
>>> Can you backport it to your 5.10 tree and check if it helps?
>> Hi Mike, the 0740a50b9baa is already in 5.10, tags/v5.10.24~5
> 
> Ah, you are using stable 5.10.y.
>   
>> commit 4c84191cbc3eff49568d3c5cccb628fa382cf7fb
>> Author: Mike Rapoport <rppt@kernel.org>
>> Date:   Fri Mar 12 21:07:12 2021 -0800
>>
>>      mm/page_alloc.c: refactor initialization of struct page for holes in
>> memory layout
>>
>>      commit 0740a50b9baa4472cfb12442df4b39e2712a64a4 upstream.
>>
>> but check init_unavailable_range(), we need deal with the hole in the
>> range of one pageblock.
>>
>> For our scene, pageblock range: 0xde600,0xde7ff, but the available pfn begin
>> with 0xde700.
>>
>> If pfn(eg, 0xde600) is not valid, the step in init_unavailable_range is
>> pageblock_nr_pages, and ALIGN_DOWN(pfn, pageblock_nr_pages) from 0xde600
>> to 0xde700 is same, so the page range for pfn [0xde600,0xde700] won't be
>> initialized.
> 
> The pfn 0xde600 is valid in the sense that there is a memory map for that
> pfn. Yet, with ARM's custom pfn_valid() will treat it as invalid because
> there is a hole.
>   
>> After add the following patch, the oom test could passed,
>   
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index aaa1655cf682..0c7e04f86f9f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6484,13 +6484,14 @@ static u64 __meminit init_unavailable_range(unsigned
>> long spfn,
>>                                              unsigned long epfn,
>>                                              int zone, int node)
>>   {
>> -       unsigned long pfn;
>> +       unsigned long pfn, pfn_down;
>> +       unsigned long epfn_down = ALIGN_DOWN(epfn, pageblock_nr_pages);
>>          u64 pgcnt = 0;
>>
>>          for (pfn = spfn; pfn < epfn; pfn++) {
>> -               if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
>> -                       pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
>> -                               + pageblock_nr_pages - 1;
>> +               pfn_down = ALIGN_DOWN(pfn, pageblock_nr_pages);
>> +               if (!pfn_valid(pfn_down) && pfn_down != epfn_down) {
>> +                       pfn = pfn_down + pageblock_nr_pages - 1;
>>                          continue;
>>                  }
>>                  __init_single_page(pfn_to_page(pfn), pfn, zone, node);
> 
> I'd rather prefer to keep init_unavailable_range() and the assumption that
> the memory map always covers an entire pageblock.
> 
> Can you please try the below hack. Essentially, it makes arm with SPARSEMEM
> to use the generic pfn_valid() and updates the freeing of the memory map to
> have the entire pageblocks covered.
> 
> If this works I'll send formal patches for those changes.
> 
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 24804f11302d..86ee711a3fdb 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -73,7 +73,7 @@ config ARM
>   	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
>   	select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
>   	select HAVE_ARCH_MMAP_RND_BITS if MMU
> -	select HAVE_ARCH_PFN_VALID
> +#	select HAVE_ARCH_PFN_VALID
>   	select HAVE_ARCH_SECCOMP
>   	select HAVE_ARCH_SECCOMP_FILTER if AEABI && !OABI_COMPAT
>   	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 504435753259..0d7bef1b49c3 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1928,9 +1928,11 @@ static void __init free_unused_memmap(void)
>   	unsigned long start, end, prev_end = 0;
>   	int i;
>   
> +#ifndef CONFIG_ARM
>   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) ||
>   	    IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
>   		return;
> +#endif
>   
>   	/*
>   	 * This relies on each bank being in address order.
> @@ -1943,14 +1945,13 @@ static void __init free_unused_memmap(void)
>   		 * due to SPARSEMEM sections which aren't present.
>   		 */
>   		start = min(start, ALIGN(prev_end, PAGES_PER_SECTION));
> -#else
> +#endif
>   		/*
>   		 * Align down here since the VM subsystem insists that the
>   		 * memmap entries are valid from the bank start aligned to
>   		 * MAX_ORDER_NR_PAGES.
>   		 */
>   		start = round_down(start, MAX_ORDER_NR_PAGES);
> -#endif
>   
>   		/*
>   		 * If we had a previous bank, and there is a space
>   
> 

Without HAVE_ARCH_PFN_VALID, init_unavailable_range will set those page
with Reserved flag, and yes, it works for oom test.

On node 0 totalpages: 311551
   Normal zone: 1230 pages used for memmap
   Normal zone: 0 pages reserved
   Normal zone: 157440 pages, LIFO batch:31
   Normal zone: 55552 pages in unavailable ranges
   HighMem zone: 154111 pages, LIFO batch:31
   HighMem zone: 41985 pages in unavailable ranges

Thanks for your kindly guidance.

>> Before:
>> On node 0 totalpages: 311551
>>    Normal zone: 1230 pages used for memmap
>>    Normal zone: 0 pages reserved
>>    Normal zone: 157440 pages, LIFO batch:31
>>    Normal zone: 16384 pages in unavailable ranges
>>    HighMem zone: 154111 pages, LIFO batch:31
>>    HighMem zone: 1 pages in unavailable ranges
>>
>> page:ef3cc000 is uninitialized and poisoned
>> raw: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
>>
>> After:
>> On node 0 totalpages: 311551
>>    Normal zone: 1230 pages used for memmap
>>    Normal zone: 0 pages reserved
>>    Normal zone: 157440 pages, LIFO batch:31
>>    Normal zone: 17152 pages in unavailable ranges
>>    HighMem zone: 154111 pages, LIFO batch:31
>>    HighMem zone: 513 pages in unavailable ranges
>> ...
>> page:(ptrval) refcount:1 mapcount:0 mapping:00000000 index:0x0 pfn:0xde600
>> flags: 0xdd001000(reserved)
>> raw: dd001000 ef3cc004 ef3cc004 00000000 00000000 00000000 ffffffff 00000001
>>
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
