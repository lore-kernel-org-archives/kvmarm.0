From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] kvm: arm/arm64: Take mmap_sem in stage2_unmap_vm
Date: Wed, 15 Mar 2017 14:29:07 +0100
Message-ID: <07ccec83-8dbb-9d3a-e7f0-fef445d581a8@redhat.com>
References: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
 <1489503154-20705-2-git-send-email-suzuki.poulose@arm.com>
 <20170315091755.GL1277@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D3840284
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 09:27:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVdLOOXloHs9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 09:27:36 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FCDE400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 09:27:36 -0400 (EDT)
In-Reply-To: <20170315091755.GL1277@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, andreyknvl@google.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 15/03/2017 10:17, Christoffer Dall wrote:
> On Tue, Mar 14, 2017 at 02:52:32PM +0000, Suzuki K Poulose wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> We don't hold the mmap_sem while searching for the VMAs when
>> we try to unmap each memslot for a VM. Fix this properly to
>> avoid unexpected results.
>>
>> Fixes: commit 957db105c997 ("arm/arm64: KVM: Introduce stage2_unmap_vm")
>> Cc: stable@vger.kernel.org # v3.19+
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>  arch/arm/kvm/mmu.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 962616f..f2e2e0c 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -803,6 +803,7 @@ void stage2_unmap_vm(struct kvm *kvm)
>>  	int idx;
>>  
>>  	idx = srcu_read_lock(&kvm->srcu);
>> +	down_read(&current->mm->mmap_sem);
>>  	spin_lock(&kvm->mmu_lock);
>>  
>>  	slots = kvm_memslots(kvm);
>> @@ -810,6 +811,7 @@ void stage2_unmap_vm(struct kvm *kvm)
>>  		stage2_unmap_memslot(kvm, memslot);
>>  
>>  	spin_unlock(&kvm->mmu_lock);
>> +	up_read(&current->mm->mmap_sem);
>>  	srcu_read_unlock(&kvm->srcu, idx);
>>  }
>>  
>> -- 
>> 2.7.4
>>
> 
> Are we sure that holding mmu_lock is valid while holding the mmap_sem?

Sure, spinlock-inside-semaphore and spinlock-inside-mutex is always okay.

Paolo
