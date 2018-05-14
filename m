From: Jia He <hejianet@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: fix unaligned hva start and end in
 handle_hva_to_gpa
Date: Mon, 14 May 2018 10:30:31 +0800
Message-ID: <aa5b37dc-7ac3-2999-fa67-848cd693977f@gmail.com>
References: <1525244911-5519-1-git-send-email-hejianet@gmail.com>
 <04e6109f-cbbd-24b0-03bb-9247b930d42c@arm.com>
 <85e04362-05dd-c697-e9c4-ad5824e63819@gmail.com>
 <0f134188-12d5-7184-3fbd-0ec8204cf649@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0f134188-12d5-7184-3fbd-0ec8204cf649@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>, li.zhang@hxt-semitech.com
List-Id: kvmarm@lists.cs.columbia.edu



On 5/11/2018 9:39 PM, Suzuki K Poulose Wrote:
> Marc
>
> Thanks for looping me in. Comments below.
>
>
> On 03/05/18 03:02, Jia He wrote:
>> Hi Marc
>>
>> Thanks for the review
>>
>>
>> On 5/2/2018 10:26 PM, Marc Zyngier Wrote:
>>> [+ Suzuki]
>>>
>>> On 02/05/18 08:08, Jia He wrote:
>>>> From: Jia He <jia.he@hxt-semitech.com>
>>>>
>>>> In our armv8a server (QDF2400), I noticed a WARN_ON as follows:
>>>>
>>>> [  800.202850] WARNING: CPU: 33 PID: 255 at arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:1670 kvm_age_hva_handler+0xcc/0xd4
>>> Which kernel version is that? I don't have a WARN_ON() at this line in
>>> 4.17. Do you have a reproducer?
>> My running kernel version is v4.14-15, but I can reproduced it in 4.17 (start 20 guests and run memhog in the host)
>> In 4.17, the warn_on is at
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/virt/kvm/arm/mmu.c#n1826
>>>> [  800.213535] Modules linked in: vhost_net vhost tap xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm vfat fat iw_cm mlx5_ib ib_core dm_mirror dm_region_hash dm_log dm_mod crc32_ce i
 pmi_ssif sg nfsd
>>>> [  800.284115]  auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c mlx5_core ixgbe mlxfw devlink mdio ahci_platform libahci_platform qcom_emac libahci hdma hdma_mgmt i2c_qup
>>>> [  800.300382] CPU: 33 PID: 255 Comm: khugepaged Tainted: G        W       4.14.36+ #6
>>>> [  800.308030] Hardware name: <snip for confidential issues>
>>> Well, that's QDF2400, right? ;-)
>> yes, exactly :)
>>>> [  800.318717] task: ffff8017c949c000 task.stack: ffff8017c9498000
>>>> [  800.324629] PC is at kvm_age_hva_handler+0xcc/0xd4
>>>> [  800.329412] LR is at handle_hva_to_gpa+0xec/0x15c
>>>> [  800.334109] pc : [<ffff0000080b4f2c>] lr : [<ffff0000080b4838>] pstate: 20400145
>>>> [  800.341496] sp : ffff8017c949b260
>>>> [  800.344804] x29: ffff8017c949b260 x28: ffff801663e25008
>>>> [  800.350110] x27: 0000000000020000 x26: 00000001fb1a0000
>>>> [  800.355416] x25: 0000ffff605b0200 x24: 0000ffff605a0200
>>>> [  800.360722] x23: 0000000000000000 x22: 000000000000ffff
>>>> [  800.366028] x21: 00000001fb1a0000 x20: ffff8017c085a000
>>>> [  800.371334] x19: ffff801663e20008 x18: 0000000000000000
>>>> [  800.376641] x17: 0000000000000000 x16: 0000000000000000
>>>> [  800.381947] x15: 0000000000000000 x14: 3d646e655f617668
>>>> [  800.387254] x13: 2c30303230623530 x12: 36666666663d646e
>>>> [  800.392560] x11: 652c303032306135 x10: 3036666666663d74
>>>> [  800.397867] x9 : 0000000000003796 x8 : 655f6e66672c3030
>>>> [  800.403173] x7 : ffff00000859434c x6 : ffff8017f9c30cb8
>>>> [  800.408479] x5 : ffff8017f9c30cb8 x4 : ffff0000080b4e60
>>>> [  800.413786] x3 : 0000000000000000 x2 : 0000000000020000
>>>> [  800.419092] x1 : 00000001fb1a0000 x0 : 0000000020000000
>>>> [  800.424398] Call trace:
>>>> [  800.426838] Exception stack(0xffff8017c949b120 to 0xffff8017c949b260)
>>>> [  800.433272] b120: 0000000020000000 00000001fb1a0000 0000000000020000 0000000000000000
>>>> [  800.441095] b140: ffff0000080b4e60 ffff8017f9c30cb8 ffff8017f9c30cb8 ffff00000859434c
>>>> [  800.448918] b160: 655f6e66672c3030 0000000000003796 3036666666663d74 652c303032306135
>>>> [  800.456740] b180: 36666666663d646e 2c30303230623530 3d646e655f617668 0000000000000000
>>>> [  800.464563] b1a0: 0000000000000000 0000000000000000 0000000000000000 ffff801663e20008
>>>> [  800.472385] b1c0: ffff8017c085a000 00000001fb1a0000 000000000000ffff 0000000000000000
>>>> [  800.480208] b1e0: 0000ffff605a0200 0000ffff605b0200 00000001fb1a0000 0000000000020000
>>>> [  800.488030] b200: ffff801663e25008 ffff8017c949b260 ffff0000080b4838 ffff8017c949b260
>>>> [  800.495853] b220: ffff0000080b4f2c 0000000020400145 0000000000000001 ffff8017c949b2a0
>>>> [  800.503676] b240: ffffffffffffffff ffff8017c949b260 ffff8017c949b260 ffff0000080b4f2c
>>>> [  800.511498] [<ffff0000080b4f2c>] kvm_age_hva_handler+0xcc/0xd4
>>>> [  800.517324] [<ffff0000080b4838>] handle_hva_to_gpa+0xec/0x15c
>>>> [  800.523063] [<ffff0000080b6c5c>] kvm_age_hva+0x5c/0xcc
>>>> [  800.528194] [<ffff0000080a7c3c>] kvm_mmu_notifier_clear_flush_young+0x54/0x90
>>>> [  800.535324] [<ffff00000827a0e8>] __mmu_notifier_clear_flush_young+0x6c/0xa8
>>>> [  800.542279] [<ffff00000825a644>] page_referenced_one+0x1e0/0x1fc
>>>> [  800.548279] [<ffff00000827e8f8>] rmap_walk_ksm+0x124/0x1a0
>>>> [  800.553759] [<ffff00000825c974>] rmap_walk+0x94/0x98
>>>> [  800.558717] [<ffff00000825ca98>] page_referenced+0x120/0x180
>>>> [  800.564369] [<ffff000008228c58>] shrink_active_list+0x218/0x4a4
>>>> [  800.570281] [<ffff000008229470>] shrink_node_memcg+0x58c/0x6fc
>>>> [  800.576107] [<ffff0000082296c4>] shrink_node+0xe4/0x328
>>>> [  800.581325] [<ffff000008229c9c>] do_try_to_free_pages+0xe4/0x3b8
>>>> [  800.587324] [<ffff00000822a094>] try_to_free_pages+0x124/0x234
>>>> [  800.593150] [<ffff000008216aa0>] __alloc_pages_nodemask+0x564/0xf7c
>>>> [  800.599412] [<ffff000008292814>] khugepaged_alloc_page+0x38/0xb8
>>>> [  800.605411] [<ffff0000082933bc>] collapse_huge_page+0x74/0xd70
>>>> [  800.611238] [<ffff00000829470c>] khugepaged_scan_mm_slot+0x654/0xa98
>>>> [  800.617585] [<ffff000008294e0c>] khugepaged+0x2bc/0x49c
>>>> [  800.622803] [<ffff0000080ffb70>] kthread+0x124/0x150
>>>> [  800.627762] [<ffff0000080849f0>] ret_from_fork+0x10/0x1c
>>>> [  800.633066] ---[ end trace 944c130b5252fb01 ]---
>>>> -------------------------------------------------------------------------
>>>>
>>>> The root cause might be: we can't guarantee that the parameter start and end
>>>> in handle_hva_to_gpa is PAGE_SIZE aligned, let alone hva_start and hva_end.
>>> So why not aligning them the first place?
>> at the first place of handle_hva_to_gpa()?
>> but boundary check is needed in each loop of kvm_for_each_memslot. Am I missing anything here?
>
>>>> This bug is introduced by commit 056aad67f836 ("kvm: arm/arm64: Rework gpa
>>>> callback handlers")
>>>>
>>>> It fixes the bug by use pfn size converted.
>>>>
>>>> Fixes: 056aad67f836 ("kvm: arm/arm64: Rework gpa callback handlers")
>>>>
>>>> Signed-off-by: jia.he@hxt-semitech.com
>>>> Signed-off-by: li.zhang@hxt-semitech.com
>>>> ---
>>>>    virt/kvm/arm/mmu.c | 10 ++++++----
>>>>    1 file changed, 6 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index 7f6a944..9dd7ae4 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -1744,7 +1744,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
>>>>        /* we only care about the pages that the guest sees */
>>>>        kvm_for_each_memslot(memslot, slots) {
>>>>            unsigned long hva_start, hva_end;
>>>> -        gfn_t gpa;
>>>> +        gpa_t gpa, gpa_end;
>>>>            hva_start = max(start, memslot->userspace_addr);
>>>>            hva_end = min(end, memslot->userspace_addr +
>>>> @@ -1753,7 +1753,9 @@ static int handle_hva_to_gpa(struct kvm *kvm,
>>>>                continue;
>>>>            gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
>>>> -        ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
>>>> +        gpa_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot)
>>>> +                             << PAGE_SHIFT;
>>>> +        ret |= handler(kvm, gpa, (u64)(gpa_end - gpa), data);
>>> But we're looking for the mapping in the same memslot, so the distance
>>> between hva and hva_end is the same as the one between gpa and gpa_end
>>> if you didn't align it.
>> maybe not, sometimes hva_end-hva != gpa_end-gpa
>> start=fffdc37f0200,hva_start=fffdc37f0200,end=fffdc3800200,hva_end=fffdc3800000,gpa=3ff0000,gfn_end=4000000
>>
>> but sometimes it is:
>> start=ffff60590200,hva_start=ffff60590200,end=ffff605a0200,hva_end=ffff605a0200,gpa=1fb190000,gfn_end=1fb1b0000
>>
>> IMO, the unalignment is caused by the ksm stable page flag STABLE_FLAG. I will
>> propose another ksm patch to fix it。
>> But from handle_hva_to_gpa's point of view, arm kvm needs to void the followup
>> exception, just like what powerpc andx86 have done.
>
>
> As far as I can see this is triggered by someone (in this page_referenced_one via ksm?)
> triggering a clear_flush_young for a page, with a non-aligned page address.
>
> If you look at the code path, the __mmu_notifier_clear_flush_young is invoked
> via 2 code paths with the "given" address.
>
> ptep_clear_flush_young_notify(), in which case the end is set to + PAGE_SIZE
> pmdp_clear_flush_young_notify(), in which case the end is set to + PMD_SIZE
>
> We were supposed to only clear_flush_young for *the page* containing
> address (start), but we do a clear_flush_young for the next page
> as well, which (I think) is not something intended. So to me, it looks like, either
> page_referenced_one() or its caller must align the address to the PAGE_SIZE
> or PMD_SIZE depending on what it really wants to do, to avoid touching
> the adjacent entries (page or block pages).
>
> Suzuki

Suzuki, thanks for the comments.

I proposed another ksm patch https://lkml.org/lkml/2018/5/3/1042
The root cause is ksm will add some extra flags to indicate that the page
is in/not_in the stable tree. This makes address not be aligned with PAGE_SIZE.

 From arm kvm mmu point of view, do you think handle_hva_to_gpa still need to handle
the unalignment case?
IMO, the PAGE_SIZE alignment is still needed because we should not let the bottom function
kvm_age_hva_handler to handle the exception. Please refer to the implementation in X86 and
powerpc kvm_handle_hva_range(). They both aligned the hva with hva_to_gfn_memslot.

Cheers,
Jia

>>> So why not align both start and end and skip the double lookup?
>>>
>>>>        }
>>>>        return ret;
>>>> @@ -1823,7 +1825,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>>>>        pmd_t *pmd;
>>>>        pte_t *pte;
>>>> -    WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
>>>> +    WARN_ON((size & ~PAGE_MASK) != 0);
>>>>        pmd = stage2_get_pmd(kvm, NULL, gpa);
>>>>        if (!pmd || pmd_none(*pmd))    /* Nothing there */
>>>>            return 0;
>>>> @@ -1843,7 +1845,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
>>>>        pmd_t *pmd;
>>>>        pte_t *pte;
>>>> -    WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
>>>> +    WARN_ON((size & ~PAGE_MASK) != 0);
>>>>        pmd = stage2_get_pmd(kvm, NULL, gpa);
>>>>        if (!pmd || pmd_none(*pmd))    /* Nothing there */
>>>>            return 0;
>>>>
>>> I'll let Suzuki comment on this, but I'm a bit suspicious of this patch.
>> sure, more comments, more clear for the issue.
>>
>
