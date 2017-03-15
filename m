From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 3/3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Wed, 15 Mar 2017 13:50:50 +0000
Message-ID: <92c9e125-860d-5f7a-d291-ae5fbb2b4e39@arm.com>
References: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
 <1489503154-20705-4-git-send-email-suzuki.poulose@arm.com>
 <20170315092147.GM1277@cbox> <314fbde3-17e6-414b-85e6-326de22bdc1c@arm.com>
 <20170315105639.GA31974@cbox> <0e5ff7f7-855c-ea28-fdee-73c062c3d289@arm.com>
 <20170315133542.GP1277@cbox> <635795ed-7b12-bfb3-3b11-4edcfbc7b1bc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1B7B40190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 09:49:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LW5dfU-3ECGf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 09:49:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B98DF40019
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 09:49:20 -0400 (EDT)
In-Reply-To: <635795ed-7b12-bfb3-3b11-4edcfbc7b1bc@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, andreyknvl@google.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, catalin.marinas@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 15/03/17 13:43, Marc Zyngier wrote:
> On 15/03/17 13:35, Christoffer Dall wrote:
>> On Wed, Mar 15, 2017 at 01:28:07PM +0000, Marc Zyngier wrote:
>>> On 15/03/17 10:56, Christoffer Dall wrote:
>>>> On Wed, Mar 15, 2017 at 09:39:26AM +0000, Marc Zyngier wrote:
>>>>> On 15/03/17 09:21, Christoffer Dall wrote:
>>>>>> On Tue, Mar 14, 2017 at 02:52:34PM +0000, Suzuki K Poulose wrote:
>>>>>>> In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
>>>>>>> unmap_stage2_range() on the entire memory range for the guest. This could
>>>>>>> cause problems with other callers (e.g, munmap on a memslot) trying to
>>>>>>> unmap a range.
>>>>>>>
>>>>>>> Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
>>>>>>> Cc: stable@vger.kernel.org # v3.10+
>>>>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>>>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>>> ---
>>>>>>>  arch/arm/kvm/mmu.c | 3 +++
>>>>>>>  1 file changed, 3 insertions(+)
>>>>>>>
>>>>>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>>>>>> index 13b9c1f..b361f71 100644
>>>>>>> --- a/arch/arm/kvm/mmu.c
>>>>>>> +++ b/arch/arm/kvm/mmu.c
>>>>>>> @@ -831,7 +831,10 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>>>>>>>  	if (kvm->arch.pgd == NULL)
>>>>>>>  		return;
>>>>>>>  
>>>>>>> +	spin_lock(&kvm->mmu_lock);
>>>>>>>  	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
>>>>>>> +	spin_unlock(&kvm->mmu_lock);
>>>>>>> +
>>>>>>
>>>>>> This ends up holding the spin lock for potentially quite a while, where
>>>>>> we can do things like __flush_dcache_area(), which I think can fault.
>>>>>
>>>>> I believe we're always using the linear mapping (or kmap on 32bit) in
>>>>> order not to fault.
>>>>>
>>>>
>>>> ok, then there's just the concern that we may be holding a spinlock for
>>>> a very long time.  I seem to recall Mario once added something where he
>>>> unlocked and gave a chance to schedule something else for each PUD or
>>>> something like that, because he ran into the issue during migration.  Am
>>>> I confusing this with something else?
>>>
>>> That definitely rings a bell: stage2_wp_range() uses that kind of trick
>>> to give the system a chance to breathe. Maybe we could use a similar
>>> trick in our S2 unmapping code? How about this (completely untested) patch:
>>>
>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>> index 962616fd4ddd..1786c24212d4 100644
>>> --- a/arch/arm/kvm/mmu.c
>>> +++ b/arch/arm/kvm/mmu.c
>>> @@ -292,8 +292,13 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
>>>  	phys_addr_t addr = start, end = start + size;
>>>  	phys_addr_t next;
>>>  
>>> +	BUG_ON(!spin_is_locked(&kvm->mmu_lock));

Nit: assert_spin_locked() is somewhat more pleasant (and currently looks
to expand to the exact same code).

Robin.

>>> +
>>>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>>>  	do {
>>> +		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
>>> +			cond_resched_lock(&kvm->mmu_lock);
>>> +
>>>  		next = stage2_pgd_addr_end(addr, end);
>>>  		if (!stage2_pgd_none(*pgd))
>>>  			unmap_stage2_puds(kvm, pgd, addr, next);
>>>
>>> The additional BUG_ON() is just for my own peace of mind - we seem to
>>> have missed a couple of these lately, and the "breathing" code makes
>>> it imperative that this lock is being taken prior to entering the
>>> function.
>>>
>>
>> Looks good to me!
> 
> OK. I'll stash that on top of Suzuki's series, and start running some
> actual tests... ;-)
> 
> Thanks,
> 
> 	M.
> 
