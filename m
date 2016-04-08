From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 12/17] kvm-arm: Add explicit hyp page table modifiers
Date: Fri, 8 Apr 2016 17:25:07 +0200
Message-ID: <CAMJs5B-k0pB0kTefFvPfPzXQsFLtXADYk9BJCcDx4ctHYAsEYQ@mail.gmail.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-13-git-send-email-suzuki.poulose@arm.com>
 <20160408131537.GR8961@cbox> <5707C997.3030304@arm.com>
 <5707CCD0.2040606@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2DEA40F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 11:23:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tnw8RFE7-zRF for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 11:23:40 -0400 (EDT)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com
 [209.85.213.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC7EE407A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 11:23:40 -0400 (EDT)
Received: by mail-vk0-f52.google.com with SMTP id e185so141989708vkb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 08:25:07 -0700 (PDT)
In-Reply-To: <5707CCD0.2040606@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 8, 2016 at 5:22 PM, Suzuki K Poulose <Suzuki.Poulose@arm.com> wrote:
> On 08/04/16 16:09, Marc Zyngier wrote:
>>
>> On 08/04/16 14:15, Christoffer Dall wrote:
>>>
>>> On Mon, Apr 04, 2016 at 05:26:12PM +0100, Suzuki K Poulose wrote:
>>>>
>>>> We have common routines to modify hyp and stage2 page tables
>>>> based on the 'kvm' parameter. For a smoother transition to
>>>> using separate routines for each, duplicate the routines
>>>> and modify the copy to work on hyp.
>>>>
>>>> Marks the forked routines with _hyp_ and gets rid of the
>>>> kvm parameter which is no longer needed and is NULL for hyp.
>>>> Also, gets rid of calls to kvm_tlb_flush_by_vmid_ipa() calls
>>>> from the hyp versions. Uses explicit host page table accessors
>>>> instead of the kvm_* page table helpers.
>>>>
>>>> Suggested-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>
>
>>>> +static void unmap_hyp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t
>>>> end)
>>>> +{
>>>> +       pte_t *pte, *start_pte;
>>>> +
>>>> +       start_pte = pte = pte_offset_kernel(pmd, addr);
>>>> +       do {
>>>> +               if (!pte_none(*pte)) {
>>>> +                       pte_t old_pte = *pte;
>>>> +
>>>> +                       kvm_set_pte(pte, __pte(0));
>>>> +
>>>> +                       /* XXX: Do we need to invalidate the cache for
>>>> device mappings ? */
>>>
>>>
>>> no, we will not be swapping out any pages mapped in Hyp mode so you can
>>> get rid of both of the following two lines.
>
>
> OK, will remove this hunk.
>
>
>>>
>>>> +                       if (!kvm_is_device_pfn(pte_pfn(old_pte)))
>>>> +                               kvm_flush_dcache_pte(old_pte);
>>>> +
>>>> +                       put_page(virt_to_page(pte));
>>>> +               }
>>>> +       } while (pte++, addr += PAGE_SIZE, addr != end);
>>>> +
>>>> +       if (hyp_pte_table_empty(start_pte))
>>>> +               clear_hyp_pmd_entry(pmd);
>>>> +}
>>>> +
>>>> +static void unmap_hyp_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t
>>>> end)
>>>> +{
>>>> +       phys_addr_t next;
>>>> +       pmd_t *pmd, *start_pmd;
>>>> +
>>>> +       start_pmd = pmd = pmd_offset(pud, addr);
>>>> +       do {
>>>> +               next = pmd_addr_end(addr, end);
>>>> +               if (!pmd_none(*pmd)) {
>>>> +                       if (pmd_thp_or_huge(*pmd)) {
>>>
>>>
>>> do we ever actually map anything with section mappings in the Hyp
>>> mappings?
>>
>>
>> No, this is purely a page mapping so far. On my system, the HYP text is
>> just over 4 pages big (4k pages), so the incentive is pretty low, unless
>> we can demonstrate some big gains due to the reduced TLB impact.
>
>
>
>>>> +static void unmap_hyp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t
>>>> end)
>>>> +{
>>>> +       phys_addr_t next;
>>>> +       pud_t *pud, *start_pud;
>>>> +
>>>> +       start_pud = pud = pud_offset(pgd, addr);
>>>> +       do {
>>>> +               next = pud_addr_end(addr, end);
>>>> +               if (!pud_none(*pud)) {
>>>> +                       if (pud_huge(*pud)) {
>>>
>>>
>>> do we ever actually map anything with huge pud
>>> mappings for the Hyp space?
>>
>>
>> Same thing. Looks like there is some potential simplification here.
>
>
> Right, we don't map anything with section mapping. I can clean these up.
>
>>>> +static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
>>>> +{
>>>> +       pgd_t *pgd;
>>>> +       phys_addr_t addr = start, end = start + size;
>>>> +       phys_addr_t next;
>>>> +
>>>> +       pgd = pgdp + pgd_index(addr);
>>>> +       do {
>>>> +               next = pgd_addr_end(addr, end);
>>>> +               if (!pgd_none(*pgd))
>>>> +                       unmap_hyp_puds(pgd, addr, next);
>>>> +       } while (pgd++, addr = next, addr != end);
>>>
>>>
>>> shouldn't we flush the EL2 (hyp) TLB here, strictly speaking?
>>>
>>> Or do we rely on all mappings ever created/torn down here to always have
>>> the same VA/PA relationship?  Since we didn't flush the EL2 TLB in the
>>> existing code, that indeed does seem to be the case.
>>
>>
>> Actually, we never unmap anything from HYP.
>
>
> Except for the kvm tearing down where we clean up all the hyp table.
>
>> Once a structure (kvm, vcpu)is mapped there, it stays forever, whatever
>> happens
>> to the VM (that's because we'd otherwise have to refcount the number of
>> objects in a page,
>> and I'm lazy...).
>
>
> Thats one of my TODO list if there is sufficient interest in getting that
> done.
>
I think you can ignore it for now... I'm sure we have bigger fish to fry.

-Christoffer
