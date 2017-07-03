From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Mon, 3 Jul 2017 10:48:03 +0200
Message-ID: <a7921cdb-a5e5-8fc0-92d5-807f07c59069@suse.de>
References: <1498231319-199734-1-git-send-email-agraf@suse.de>
 <20170703080313.GB4066@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E75C40D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 04:47:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2hip654pijuv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 04:47:47 -0400 (EDT)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AB17408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 04:47:47 -0400 (EDT)
In-Reply-To: <20170703080313.GB4066@cbox>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/03/2017 10:03 AM, Christoffer Dall wrote:
> Hi Alex,
>
> On Fri, Jun 23, 2017 at 05:21:59PM +0200, Alexander Graf wrote:
>> If we want to age an HVA while the VM is getting destroyed, we have a
>> tiny race window during which we may end up dereferencing an invalid
>> kvm->arch.pgd value.
>>
>>     CPU0               CPU1
>>
>>     kvm_age_hva()
>>                        kvm_mmu_notifier_release()
>>                        kvm_arch_flush_shadow_all()
>>                        kvm_free_stage2_pgd()
>>                        <grab mmu_lock>
>>     stage2_get_pmd()
>>     <wait for mmu_lock>
>>                        set kvm->arch.pgd = 0
>>                        <free mmu_lock>
>>     <grab mmu_lock>
>>     stage2_get_pud()
>>     <access kvm->arch.pgd>
>>     <use incorrect value>
> I don't think this sequence, can happen, but I think kvm_age_hva() can
> be called with the mmu_lock held and kvm->pgd already being NULL.
>
> Is that possible for the mmu notifiers to be calling clear(_flush)_young
> while also calling notifier_release?

I *think* the aging happens completely orthogonally to release. But 
let's ask Andrea - I'm sure he knows :).


Alex

>
> If so, the patch below looks good to me.
>
> Thanks,
> -Christoffer
>
>
>> This patch adds a check for that case.
>>
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>> ---
>>   virt/kvm/arm/mmu.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index f2d5b6c..227931f 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -861,6 +861,10 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
>>   	pgd_t *pgd;
>>   	pud_t *pud;
>>   
>> +	/* Do we clash with kvm_free_stage2_pgd()? */
>> +	if (!kvm->arch.pgd)
>> +		return NULL;
>> +
>>   	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>>   	if (WARN_ON(stage2_pgd_none(*pgd))) {
>>   		if (!cache)
>> -- 
>> 1.8.5.6
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
