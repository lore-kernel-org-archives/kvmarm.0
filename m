From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] Question about TLB flush while set Stage-2 huge pages
Date: Tue, 12 Mar 2019 11:32:53 +0000
Message-ID: <e2a94937-c324-e2d6-7e61-3f998e6e6e22@arm.com>
References: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Zheng Xiang <zhengxiang9@huawei.com>, christoffer.dall@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, suzuki.poulose@arm.com, james.morse@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Wang Haibin <wanghaibin.wang@huawei.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, lious.lilei@hisilicon.com, lishuo1@hisilicon.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Zheng,

On 11/03/2019 16:31, Zheng Xiang wrote:
> Hi all,
> 
> While a page is merged into a transparent huge page, KVM will invalidate Stage-2 for
> the base address of the huge page and the whole of Stage-1.
> However, this just only invalidates the first page within the huge page and the other
> pages are not invalidated, see bellow:
> 
>     +---------------+--------------+
>     |abcde       2MB-Page          |
>     +---------------+--------------+
> 
>     TLB before setting new pmd:
>     +---------------+--------------+
>     |      VA       |    PAGESIZE  |
>     +---------------+--------------+
>     |      a        |      4KB     |
>     +---------------+--------------+
>     |      b        |      4KB     |
>     +---------------+--------------+
>     |      c        |      4KB     |
>     +---------------+--------------+
>     |      d        |      4KB     |
>     +---------------+--------------+
> 
>     TLB after setting new pmd:
>     +---------------+--------------+
>     |      VA       |    PAGESIZE  |
>     +---------------+--------------+
>     |      a        |      2MB     |
>     +---------------+--------------+
>     |      b        |      4KB     |
>     +---------------+--------------+
>     |      c        |      4KB     |
>     +---------------+--------------+
>     |      d        |      4KB     |
>     +---------------+--------------+
> 
> When VM access *b* address, it will hit the TLB and result in TLB conflict aborts or other potential exceptions.

That's really bad. I can only imagine two scenarios:

1) We fail to unmap a,b,c,d (and potentially another 508 PTEs), loosing
the PTE table in the process, and place the PMD instead. I can't see
this happening.

2) We fail to invalidate on unmap, and that slightly less bad (but still
quite bad).

Which of the two cases are you seeing?

> For example, we need to keep tracking of the VM memory dirty pages when VM is in live migration.
> KVM will set the memslot READONLY and split the huge pages.
> After live migration is canceled and abort, the pages will be merged into THP.
> The later access to these pages which are READONLY will cause level-3 Permission Fault until they are invalidated.
> 
> So should we invalidate the tlb entries for all relative pages(e.g a,b,c,d), like __flush_tlb_range()?
> Or we can call __kvm_tlb_flush_vmid() to invalidate all tlb entries.

We should perform an invalidate on each unmap. unmap_stage2_range seems
to do the right thing. __flush_tlb_range only caters for Stage1
mappings, and __kvm_tlb_flush_vmid() is too big a hammer, as it nukes
TLBs for the whole VM.

I'd really like to understand what you're seeing, and how to reproduce
it. Do you have a minimal example I could run on my own HW?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
