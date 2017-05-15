From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 2/2] kvm: arm/arm64: Fix use after free of stage2 page
 table
Date: Mon, 15 May 2017 18:51:26 +0100
Message-ID: <49fee867-bc83-52ec-e197-843dcafcb5d9@arm.com>
References: <1493821072-29713-1-git-send-email-suzuki.poulose@arm.com>
 <1493821072-29713-3-git-send-email-suzuki.poulose@arm.com>
 <20170515100017.GJ9309@cbox> <e8255936-1480-1306-edcb-5aef57271a5f@arm.com>
 <20170515174337.GC18755@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8304440905
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:48:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YyWHsgn+gTUg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 13:48:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 117D1408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:48:05 -0400 (EDT)
In-Reply-To: <20170515174337.GC18755@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/05/17 18:43, Christoffer Dall wrote:
> On Mon, May 15, 2017 at 02:36:58PM +0100, Suzuki K Poulose wrote:
>> On 15/05/17 11:00, Christoffer Dall wrote:
>>> Hi Suzuki,
>>> So I don't think this change is wrong, but I wonder if it's sufficient.
>>> For example, I can see that this function is called from
>>>
>>> stage2_unmsp_vm
>>> -> stage2_unmap_memslot
>>>   -> unmap_stage2_range
>>>
>>> and
>>>
>>> kvm_arch_flush_shadow_memslot
>>> -> unmap_stage2_range
>>>
>>> which never check if the pgd pointer is valid,
>>
>> You are right. Those two callers do not check it. We could fix all of this by simply
>> moving the check to the beginning of the loop.
>> i.e, something like this :
>>
>> @@ -295,6 +295,12 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
>> 	assert_spin_locked(&kvm->mmu_lock);
>> 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>> 	do {
>> +		/*
>> +		 * Make sure the page table is still active, as we could
>> +		 * another thread could have possibly freed the page table.
>> +		 */
>> +		if (!READ_ONCE(kvm->arch.pgd))
>> +			break;
>> 		next = stage2_pgd_addr_end(addr, end);
>> 		if (!stage2_pgd_none(*pgd))
>> 			unmap_stage2_puds(kvm, pgd, addr, next);
>>
>>
>>
>>
>>> and finally, kvm_free_stage2_pgd also checks the pgd pointer outside of holding the
>>> kvm->mmu_lock so why is this not racy?
>>
>> This has been fixed by patch 1 in the series. So should be fine.
>>
>>
>> I can respin the patch with the changes if you are OK with it.
>>
> Yes, absolutely.  I've already applied patch 1 so no need to include
> that in your respin.

I have made a minor change to the 1st patch, to make use of READ_ONCE/WRITE_ONCE,
to make sure we don't use the cached value of the kvm->arch.pgd. Something like :


@@ -829,22 +829,22 @@ void stage2_unmap_vm(struct kvm *kvm)
   * Walks the level-1 page table pointed to by kvm->arch.pgd and frees all
   * underlying level-2 and level-3 tables before freeing the actual level-1 table
   * and setting the struct pointer to NULL.
- *
- * Note we don't need locking here as this is only called when the VM is
- * destroyed, which can only be done once.
   */
  void kvm_free_stage2_pgd(struct kvm *kvm)
  {
-	if (kvm->arch.pgd == NULL)
-		return;
+	void *pgd = NULL;
  
  	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+	if (kvm->arch.pgd) {
+		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+		pgd = READ_ONCE(kvm->arch.pgd);
+		WRITE_ONCE(kvm->arch.pgd, NULL);
+	}
         spin_unlock(&kvm->mmu_lock);
  

Let me know if you could fix it up or I could send a fresh series. Sorry about that.

Suzuki
