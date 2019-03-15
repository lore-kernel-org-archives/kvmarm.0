From: Zheng Xiang <zhengxiang9@huawei.com>
Subject: Re: [RFC] Question about TLB flush while set Stage-2 huge pages
Date: Fri, 15 Mar 2019 16:21:03 +0800
Message-ID: <d322e126-4da2-6dfd-a86d-088dfb3bf0f4@huawei.com>
References: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
 <e2a94937-c324-e2d6-7e61-3f998e6e6e22@arm.com>
 <1c0e07b9-73f0-efa4-c1b7-ad81789b42c5@huawei.com>
 <5188e3b9-5b5a-a6a7-7ef0-09b7b4f06af6@arm.com>
 <348d0b3b-c74b-7b39-ec30-85905c077c38@huawei.com>
 <20190314105537.GA15323@en101>
 <368bd218-ac1d-19b2-6e92-960b91afee8b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <368bd218-ac1d-19b2-6e92-960b91afee8b@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Wang Haibin <wanghaibin.wang@huawei.com>, lious.lilei@hisilicon.com, lishuo1@hisilicon.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

I have tested this patch, VM doesn't hang and we get expected WARNING log:

[  526.184452] pstate: 20400009 (nzCv daif +PAN -UAO)
[  526.184454] pc : user_mem_abort+0x484/0x9e0
[  526.184455] lr : user_mem_abort+0x478/0x9e0
[  526.184456] sp : ffff000084a038e0
[  526.184457] x29: ffff000084a038e0 x28: 000000012f600000
[  526.184458] x27: ffff8a2fa27ae918 x26: 0000000000200000
[  526.184460] x25: 0000000000000000 x24: 0000000000000000
[  526.184461] x23: 00400a269d0007fd x22: ffff0000849cd000
[  526.184462] x21: ffff00001181d000 x20: 00000a26eef72003
[  526.184463] x19: ffff8a2fb41d4bd8 x18: 00004fffb8b22000
[  526.184465] x17: 0000000000000000 x16: 0000000000000000
[  526.184466] x15: 0000000000000001 x14: ffff000008dd12a8
[  526.184467] x13: 0000000000000041 x12: ffff8a26eeca6e30
[  526.184468] x11: ffff8000fe4af800 x10: 0000000000000040
[  526.184469] x9 : ffff0000097c46c0 x8 : ffff8000ff400248
[  526.184471] x7 : 0000001000000000 x6 : 00000000000021f8
[  526.184472] x5 : 00000000a269d000 x4 : 0000000000000018
[  526.184473] x3 : 000000000000000a x2 : 0000000000000004
[  526.184474] x1 : 0000000000000000 x0 : 0000000000000000
[  526.184476] Call trace:
[  526.184477]  user_mem_abort+0x484/0x9e0
[  526.184479]  kvm_handle_guest_abort+0x11c/0x478
[  526.184480]  handle_exit+0x14c/0x1c8
[  526.184482]  kvm_arch_vcpu_ioctl_run+0x280/0x898
[  526.184483]  kvm_vcpu_ioctl+0x488/0x8a8
[  526.184485]  do_vfs_ioctl+0xc4/0x8c0
[  526.184486]  ksys_ioctl+0x8c/0xa0
[  526.184487]  __arm64_sys_ioctl+0x28/0x38
[  526.184489]  el0_svc_common+0xa0/0x180
[  526.184491]  el0_svc_handler+0x38/0x78
[  526.184492]  el0_svc+0x8/0xc

However, we also get the following unexpected log:

[  908.329900] BUG: Bad page state in process qemu-kvm  pfn:a2fb41cf
[  908.339415] page:ffff7e28bed073c0 count:-4 mapcount:0 mapping:0000000000000000 index:0x0
[  908.339416] flags: 0x4ffffe0000000000()
[  908.339418] raw: 4ffffe0000000000 dead000000000100 dead000000000200 0000000000000000
[  908.339419] raw: 0000000000000000 0000000000000000 fffffffcffffffff 0000000000000000
[  908.339420] page dumped because: nonzero _refcount
[  908.339437] CPU: 32 PID: 72599 Comm: qemu-kvm Kdump: loaded Tainted: G    B  W        5.0.0+ #1
[  908.339438] Call trace:
[  908.339439]  dump_backtrace+0x0/0x188
[  908.339441]  show_stack+0x24/0x30
[  908.339442]  dump_stack+0xa8/0xcc
[  908.339443]  bad_page+0xf0/0x150
[  908.339445]  free_pages_check_bad+0x84/0xa0
[  908.339446]  free_pcppages_bulk+0x4b8/0x750
[  908.339448]  free_unref_page_commit+0x13c/0x198
[  908.339449]  free_unref_page+0x84/0xa0
[  908.339451]  __free_pages+0x58/0x68
[  908.339452]  zap_huge_pmd+0x290/0x2d8
[  908.339454]  unmap_page_range+0x2b4/0x470
[  908.339455]  unmap_single_vma+0x94/0xe8
[  908.339457]  unmap_vmas+0x8c/0x108
[  908.339458]  exit_mmap+0xd4/0x178
[  908.339459]  mmput+0x74/0x180
[  908.339460]  do_exit+0x2b4/0x5b0
[  908.339462]  do_group_exit+0x3c/0xe0
[  908.339463]  __arm64_sys_exit_group+0x24/0x28
[  908.339465]  el0_svc_common+0xa0/0x180
[  908.339466]  el0_svc_handler+0x38/0x78
[  908.339467]  el0_svc+0x8/0xc

>> Marc and I had a discussion about this and it looks like we may have an
>> issue here. So with the cancellation of logging, we do not trigger the
>> mmu_notifiers (as the userspace memory mapping hasn't changed) and thus
>> have memory leaks while trying to install a huge mapping. Would it be
>> possible for you to try the patch below ? It will trigger a WARNING
>> to confirm our theory, but should not cause the hang. As we unmap
>> the PMD/PUD range of PTE mappings before reinstalling a block map.
> 
> Thanks for the reply. And I think this is alomst what Zheng Xiang wanted to say! We will test this patch tomorrow and give you some feedback.
> 
> BTW, we have noticed that X86 had also suffered from the similar issue. You may want to look into commit 3ea3b7fa9af0 ("kvm: mmu: lazy collapse small sptes into large sptes" 2015) :-)
> 
> 
> thanks,
> 
> zenghui
> 
>>
>>
>> ---8>---
>>
>> test: kvm: arm: Fix handling of stage2 huge mappings
>>
>> We rely on the mmu_notifier call backs to handle the split/merging
>> of huge pages and thus we are guaranteed that while creating a
>> block mapping, the entire block is unmapped at stage2. However,
>> we miss a case where the block mapping is split for dirty logging
>> case and then could later be made block mapping, if we cancel the
>> dirty logging. This not only creates inconsistent TLB entries for
>> the pages in the the block, but also leakes the table pages for
>> PMD level.
>>
>> Handle these corner cases for the huge mappings at stage2.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   virt/kvm/arm/mmu.c | 51 +++++++++++++++++++++++++++++++++++----------------
>>   1 file changed, 35 insertions(+), 16 deletions(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 66e0fbb5..04b0f9b 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1076,24 +1076,38 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>            * Skip updating the page table if the entry is
>>            * unchanged.
>>            */
>> -        if (pmd_val(old_pmd) == pmd_val(*new_pmd))
>> +        if (pmd_val(old_pmd) == pmd_val(*new_pmd)) {
>>               return 0;
>> -
>> +        } else if (WARN_ON_ONCE(!pmd_thp_or_huge(old_pmd))) {
>>           /*
>> -         * Mapping in huge pages should only happen through a
>> -         * fault.  If a page is merged into a transparent huge
>> -         * page, the individual subpages of that huge page
>> -         * should be unmapped through MMU notifiers before we
>> -         * get here.
>> -         *
>> -         * Merging of CompoundPages is not supported; they
>> -         * should become splitting first, unmapped, merged,
>> -         * and mapped back in on-demand.
>> +         * If we have PTE level mapping for this block,
>> +         * we must unmap it to avoid inconsistent TLB
>> +         * state. We could end up in this situation if
>> +         * the memory slot was marked for dirty logging
>> +         * and was reverted, leaving PTE level mappings
>> +         * for the pages accessed during the period.
>> +         * Normal THP split/merge follows mmu_notifier
>> +         * callbacks and do get handled accordingly.
>>            */
>> -        VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
>> +            unmap_stage2_range(kvm, (addr & S2_PMD_MASK), S2_PMD_SIZE);

It seems that kvm decreases the _refcount of the page twice in transparent_hugepage_adjust()
and unmap_stage2_range().

>> +        } else {
>>   -        pmd_clear(pmd);
>> -        kvm_tlb_flush_vmid_ipa(kvm, addr);
>> +            /*
>> +             * Mapping in huge pages should only happen through a
>> +             * fault.  If a page is merged into a transparent huge
>> +             * page, the individual subpages of that huge page
>> +             * should be unmapped through MMU notifiers before we
>> +             * get here.
>> +             *
>> +             * Merging of CompoundPages is not supported; they
>> +             * should become splitting first, unmapped, merged,
>> +             * and mapped back in on-demand.
>> +             */
>> +            WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
>> +
>> +            pmd_clear(pmd);
>> +            kvm_tlb_flush_vmid_ipa(kvm, addr);
>> +        }
>>       } else {
>>           get_page(virt_to_page(pmd));
>>       }
>> @@ -1122,8 +1136,13 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
>>           return 0;
>>         if (stage2_pud_present(kvm, old_pud)) {
>> -        stage2_pud_clear(kvm, pudp);
>> -        kvm_tlb_flush_vmid_ipa(kvm, addr);
>> +        /* If we have PTE level mapping, unmap the entire range */
>> +        if (WARN_ON_ONCE(!stage2_pud_huge(kvm, old_pud))) {
>> +            unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
>> +        } else {
>> +            stage2_pud_clear(kvm, pudp);
>> +            kvm_tlb_flush_vmid_ipa(kvm, addr);
>> +        }
>>       } else {
>>           get_page(virt_to_page(pudp));
>>       }
>>
> 
> 
> .
-- 

Thanks,
Xiang
