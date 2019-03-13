From: Zheng Xiang <zhengxiang9@huawei.com>
Subject: Re: [RFC] Question about TLB flush while set Stage-2 huge pages
Date: Wed, 13 Mar 2019 17:45:31 +0800
Message-ID: <348d0b3b-c74b-7b39-ec30-85905c077c38@huawei.com>
References: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
 <e2a94937-c324-e2d6-7e61-3f998e6e6e22@arm.com>
 <1c0e07b9-73f0-efa4-c1b7-ad81789b42c5@huawei.com>
 <5188e3b9-5b5a-a6a7-7ef0-09b7b4f06af6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5188e3b9-5b5a-a6a7-7ef0-09b7b4f06af6@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, suzuki.poulose@arm.com, james.morse@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Wang Haibin <wanghaibin.wang@huawei.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, lious.lilei@hisilicon.com, lishuo1@hisilicon.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2019/3/13 2:18, Marc Zyngier wrote:
> Hi Zheng,
> 
> On 12/03/2019 15:30, Zheng Xiang wrote:
>> Hi Marc,
>>
>> On 2019/3/12 19:32, Marc Zyngier wrote:
>>> Hi Zheng,
>>>
>>> On 11/03/2019 16:31, Zheng Xiang wrote:
>>>> Hi all,
>>>>
>>>> While a page is merged into a transparent huge page, KVM will invalidate Stage-2 for
>>>> the base address of the huge page and the whole of Stage-1.
>>>> However, this just only invalidates the first page within the huge page and the other
>>>> pages are not invalidated, see bellow:
>>>>
>>>>     +---------------+--------------+
>>>>     |abcde       2MB-Page          |
>>>>     +---------------+--------------+
>>>>
>>>>     TLB before setting new pmd:
>>>>     +---------------+--------------+
>>>>     |      VA       |    PAGESIZE  |
>>>>     +---------------+--------------+
>>>>     |      a        |      4KB     |
>>>>     +---------------+--------------+
>>>>     |      b        |      4KB     |
>>>>     +---------------+--------------+
>>>>     |      c        |      4KB     |
>>>>     +---------------+--------------+
>>>>     |      d        |      4KB     |
>>>>     +---------------+--------------+
>>>>
>>>>     TLB after setting new pmd:
>>>>     +---------------+--------------+
>>>>     |      VA       |    PAGESIZE  |
>>>>     +---------------+--------------+
>>>>     |      a        |      2MB     |
>>>>     +---------------+--------------+
>>>>     |      b        |      4KB     |
>>>>     +---------------+--------------+
>>>>     |      c        |      4KB     |
>>>>     +---------------+--------------+
>>>>     |      d        |      4KB     |
>>>>     +---------------+--------------+
>>>>
>>>> When VM access *b* address, it will hit the TLB and result in TLB conflict aborts or other potential exceptions.
>>>
>>> That's really bad. I can only imagine two scenarios:
>>>
>>> 1) We fail to unmap a,b,c,d (and potentially another 508 PTEs), loosing
>>> the PTE table in the process, and place the PMD instead. I can't see
>>> this happening.
>>>
>>> 2) We fail to invalidate on unmap, and that slightly less bad (but still
>>> quite bad).
>>>
>>> Which of the two cases are you seeing?
>>>
>>>> For example, we need to keep tracking of the VM memory dirty pages when VM is in live migration.
>>>> KVM will set the memslot READONLY and split the huge pages.
>>>> After live migration is canceled and abort, the pages will be merged into THP.
>>>> The later access to these pages which are READONLY will cause level-3 Permission Fault until they are invalidated.
>>>>
>>>> So should we invalidate the tlb entries for all relative pages(e.g a,b,c,d), like __flush_tlb_range()?
>>>> Or we can call __kvm_tlb_flush_vmid() to invalidate all tlb entries.
>>>
>>> We should perform an invalidate on each unmap. unmap_stage2_range seems
>>> to do the right thing. __flush_tlb_range only caters for Stage1
>>> mappings, and __kvm_tlb_flush_vmid() is too big a hammer, as it nukes
>>> TLBs for the whole VM.
>>>
>>> I'd really like to understand what you're seeing, and how to reproduce
>>> it. Do you have a minimal example I could run on my own HW?
>>
>> When I start the live migration for a VM, qemu then begins to log and count dirty pages.
>> During the live migration, KVM set the pages READONLY so that we can count how many pages
>> would be wrote afterwards.
>>
>> Anything is OK until I cancel the live migration and qemu stop logging. Later the VM gets hang.
>> The trace log shows repeatedly level-3 permission fault caused by a write on a same IPA. After
>> analyzing the source code, I find KVM always return from the bellow *if* statement in
>> stage2_set_pmd_huge() even if we only have a single VCPU:
>>
>>         /*
>>          * Multiple vcpus faulting on the same PMD entry, can
>>          * lead to them sequentially updating the PMD with the
>>          * same value. Following the break-before-make
>>          * (pmd_clear() followed by tlb_flush()) process can
>>          * hinder forward progress due to refaults generated
>>          * on missing translations.
>>          *
>>          * Skip updating the page table if the entry is
>>          * unchanged.
>>          */
>>         if (pmd_val(old_pmd) == pmd_val(*new_pmd))
>>             return 0;
>>
>> The PMD has already set the PMD_S2_RDWR bit. I doubt kvm_tlb_flush_vmid_ipa() does not invalidate
>> Stage-2 for the subpages of the PMD(except the first PTE of this PMD). Finally I add some debug
>> code to flush tlb for all subpages of the PMD, as shown bellow:
>>
>>         /*
>>          * Mapping in huge pages should only happen through a
>>          * fault.  If a page is merged into a transparent huge
>>          * page, the individual subpages of that huge page
>>          * should be unmapped through MMU notifiers before we
>>          * get here.
>>          *
>>          * Merging of CompoundPages is not supported; they
>>          * should become splitting first, unmapped, merged,
>>          * and mapped back in on-demand.
>>          */
>>         VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
>>
>>         pmd_clear(pmd);
>>         for (cnt = 0; cnt < 512; cnt++)
>>             kvm_tlb_flush_vmid_ipa(kvm, addr + cnt*PAGE_SIZE);
>>
>> Then the problem no longer reproduce.
> 
> This makes very little sense. We shouldn't be able to enter this path
> for anything else but a permission update, otherwise the VM_BUG_ON
> should fire.

Hmm, I think I didn't describe it very clearly.
Look at the following sequence:

1) Set a PMD READONLY and logging_active.

2) KVM handles permission fault caused by writing a subpage(assumpt *b*) within this huge PMD.

3) KVM dissolves PMD and invalidates TLB for this PMD. Then set a writable PTE.

4) Read another 511 PTEs and setup Stage-2 PTE table.

5) Now remove logging_active and keep another 511 PTEs READONLY.

6) VM continues to write a subpage(assumpt *c*) and cause permission fault.

7) KVM handles this new fault and makes a new writable PMD after transparent_hugepage_adjust().

8) KVM invalidates TLB for the first page(*a*) of the PMD.
   Here another 511 RO PTEs entries still stay in TLB, especially *c* which will be wrote later.

9) KVM then set this new writable PMD.
   Step 8-9 is what stage2_set_pmd_huge() does.

10) VM continues to write *c*, but this time it hits the RO PTE entry in TLB and causes permission fault again.
   Sometimes it can also cause TLB conflict aborts.

11) KVM repeats step 6 and goes to the following statement and return 0:

         * Skip updating the page table if the entry is
         * unchanged.
         */
        if (pmd_val(old_pmd) == pmd_val(*new_pmd))
            return 0;

12) Then it will repeat step 10-11 until the PTE entry is invalidated.

I think there is something abnormal in step 8.
Should I blame my hardware? Or is it a kernel bug?

-- 

Thanks,
Xiang
