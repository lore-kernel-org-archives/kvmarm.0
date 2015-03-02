From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: tlbi  va, vaa vs. val, vaal
Date: Mon, 02 Mar 2015 11:26:26 -0800
Message-ID: <54F4B962.7040009@samsung.com>
References: <54EFB670.2070501@samsung.com> <20150227102435.GC3628@arm.com>
 <54F0DE8D.3030306@samsung.com>
 <20150302162337.GR22541@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1964B47766
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 14:20:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5MpK-ZiU-Dh1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 14:20:32 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15598476CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 14:20:31 -0500 (EST)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKL003DGNC4KD10@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 02 Mar 2015 14:26:28 -0500 (EST)
In-reply-to: <20150302162337.GR22541@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/02/2015 08:23 AM, Catalin Marinas wrote:
> On Fri, Feb 27, 2015 at 01:15:57PM -0800, Mario Smarduch wrote:
>> On 02/27/2015 02:24 AM, Will Deacon wrote:
>>> On Fri, Feb 27, 2015 at 12:12:32AM +0000, Mario Smarduch wrote:
>>>> I noticed kernel tlbflush.h use tlbi va*, vaa* variants instead of
>>>> val, vaal ones. Reading the manual D.5.7.2 it appears that
>>>> va*, vaa* versions invalidate intermediate caching of
>>>> translation structures.
>>>>
>>>> With stage2 enabled that may result in 20+ memory lookups
>>>> for a 4 level page table walk. That's assuming that intermediate
>>>> caching structures cache mappings from stage1 table entry to
>>>> host page.
>>>
>>> Yeah, Catalin and I discussed improving the kernel support for this,
>>> but it requires some changes to the generic mmu_gather code so that we
>>> can distinguish the leaf cases. I'd also like to see that done in a way
>>> that takes into account different granule sizes (we currently iterate
>>> over huge pages in 4k chunks). Last time I touched that, I entered a
>>> world of pain and don't plan to return there immediately :)
>>>
>>> Catalin -- feeling brave?
>>>
>>> FWIW: the new IOMMU page-table stuff I just got merged *does* make use
>>> of leaf-invalidation for the SMMU.
>>
>>   thanks for the background. I'm guessing how much of PTWalk
>> is cached is implementation dependent. One old paper quotes upto 40%
>> improvement for some industry benchmarks that cache all stage1/2 PTWalk
>> entries.
> 
> Is it caching in the TLB or in the level 1 CPU cache?

AFAICT this is caching in what other vendors call page walk cache.
It's likely for host - improvements may not be that
dramatic. For Guest 1st stage table/pte lookups
are 2nd stage n-level walks. I would think
performance will vary on CPU implementation of this
intermediate cache especially if nested page entries
are cached. I guess it's likely onc CPU will show
huge improvement and others may not.

> 
> I would indeed expect some improvement without many drawbacks. The only
> thing we need in Linux is to distinguish between leaf TLBI and TLBI for
> page table tearing down. It's not complicated, it just needs some
> testing (strangely enough, I tried to replace all user TLBI with the L
> variants on a Juno board and no signs of any crashes).

I tried that too it worked, but with very minimal test. But
I think I understand what the concern is using the 'L'
variant may leave intermediate table entries cached and corrupt
another process PTW.

- Mario

> 
