From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: tlbi  va, vaa vs. val, vaal
Date: Fri, 27 Feb 2015 10:44:15 +0000
Message-ID: <54F04A7F.1000703@arm.com>
References: <54EFB670.2070501@samsung.com> <20150227102435.GC3628@arm.com>
 <54F046F2.7020705@arm.com> <20150227103347.GE3628@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5A0346C55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 05:38:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nfAKNiH-mrkG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Feb 2015 05:38:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF60D46C54
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 05:38:29 -0500 (EST)
In-Reply-To: <20150227103347.GE3628@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 27/02/15 10:33, Will Deacon wrote:
> On Fri, Feb 27, 2015 at 10:29:06AM +0000, Marc Zyngier wrote:
>> On 27/02/15 10:24, Will Deacon wrote:
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
>> Now, talking about feeling brave: who will be silly enough to port KVM
>> to the IOMMU page table code? It should just work(tm), right?
> 
> I suspect you'll need to do some surgery to the interfaces, which currently
> map directly onto the IOMMU API and therefore make nice assumptions about
> what we get asked to map/unmap. You also probably want a wider range of
> permissions than we use on the SMMU. Finally, the runtime nature of the
> code (we make no assumptions about address sizes, page sizes etc) probably
> incurs a performance hit that you may or may not care about.

That's exactly what I want to evaluate. It would also help us to
decouple our page-table code from the kernel macros, which bite us time
and time again...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
