From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 08/15] arm/arm64: KVM: Always have merged page tables
Date: Thu, 30 Jun 2016 13:27:05 +0100
Message-ID: <57751019.1090001@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-9-git-send-email-marc.zyngier@arm.com>
 <20160628214319.GR26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160628214319.GR26498@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/06/16 22:43, Christoffer Dall wrote:
> On Tue, Jun 07, 2016 at 11:58:28AM +0100, Marc Zyngier wrote:
>> We're in a position where we can now always have "merged" page
>> tables, where both the runtime mapping and the idmap coexist.
>>
>> This results in some code being removed, but there is more to come.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/mmu.c     | 74 +++++++++++++++++++++++---------------------------
>>  arch/arm64/kvm/reset.c | 31 +++++----------------
>>  2 files changed, 41 insertions(+), 64 deletions(-)
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index d6ecbf1..9a17e14 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -492,13 +492,12 @@ void free_boot_hyp_pgd(void)
>>  
>>  	if (boot_hyp_pgd) {
>>  		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>> -		unmap_hyp_range(boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
>>  		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
>>  		boot_hyp_pgd = NULL;
>>  	}
>>  
>>  	if (hyp_pgd)
>> -		unmap_hyp_range(hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
>> +		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>  
>>  	mutex_unlock(&kvm_hyp_pgd_mutex);
>>  }
>> @@ -1690,7 +1689,7 @@ phys_addr_t kvm_mmu_get_boot_httbr(void)
>>  	if (__kvm_cpu_uses_extended_idmap())
>>  		return virt_to_phys(merged_hyp_pgd);
>>  	else
>> -		return virt_to_phys(boot_hyp_pgd);
>> +		return virt_to_phys(hyp_pgd);
>>  }
>>  
>>  phys_addr_t kvm_get_idmap_vector(void)
>> @@ -1703,6 +1702,22 @@ phys_addr_t kvm_get_idmap_start(void)
>>  	return hyp_idmap_start;
>>  }
>>  
>> +static int kvm_map_idmap_text(pgd_t *pgd)
>> +{
>> +	int err;
>> +
>> +	/* Create the idmap in the boot page tables */
>> +	err = 	__create_hyp_mappings(pgd,
>> +				      hyp_idmap_start, hyp_idmap_end,
>> +				      __phys_to_pfn(hyp_idmap_start),
>> +				      PAGE_HYP);
>> +	if (err)
>> +		kvm_err("Failed to idmap %lx-%lx\n",
>> +			hyp_idmap_start, hyp_idmap_end);
>> +
>> +	return err;
>> +}
>> +
>>  int kvm_mmu_init(void)
>>  {
>>  	int err;
>> @@ -1718,27 +1733,25 @@ int kvm_mmu_init(void)
>>  	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
>>  
>>  	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
>> -	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
>> -
>> -	if (!hyp_pgd || !boot_hyp_pgd) {
>> +	if (!hyp_pgd) {
>>  		kvm_err("Hyp mode PGD not allocated\n");
>>  		err = -ENOMEM;
>>  		goto out;
>>  	}
>>  
>> -	/* Create the idmap in the boot page tables */
>> -	err = 	__create_hyp_mappings(boot_hyp_pgd,
>> -				      hyp_idmap_start, hyp_idmap_end,
>> -				      __phys_to_pfn(hyp_idmap_start),
>> -				      PAGE_HYP);
>> +	if (__kvm_cpu_uses_extended_idmap()) {
>> +		boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
>> +							 hyp_pgd_order);
>> +		if (!boot_hyp_pgd) {
>> +			kvm_err("Hyp boot PGD not allocated\n");
>> +			err = -ENOMEM;
>> +			goto out;
>> +		}
>>  
>> -	if (err) {
>> -		kvm_err("Failed to idmap %lx-%lx\n",
>> -			hyp_idmap_start, hyp_idmap_end);
>> -		goto out;
>> -	}
>> +		err = kvm_map_idmap_text(boot_hyp_pgd);
>> +		if (err)
>> +			goto out;
>>  
>> -	if (__kvm_cpu_uses_extended_idmap()) {
>>  		merged_hyp_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
>>  		if (!merged_hyp_pgd) {
>>  			kvm_err("Failed to allocate extra HYP pgd\n");
>> @@ -1746,29 +1759,10 @@ int kvm_mmu_init(void)
>>  		}
>>  		__kvm_extend_hypmap(boot_hyp_pgd, hyp_pgd, merged_hyp_pgd,
>>  				    hyp_idmap_start);
>> -		return 0;
>> -	}
>> -
>> -	/* Map the very same page at the trampoline VA */
>> -	err = 	__create_hyp_mappings(boot_hyp_pgd,
>> -				      TRAMPOLINE_VA, TRAMPOLINE_VA + PAGE_SIZE,
>> -				      __phys_to_pfn(hyp_idmap_start),
>> -				      PAGE_HYP);
>> -	if (err) {
>> -		kvm_err("Failed to map trampoline @%lx into boot HYP pgd\n",
>> -			TRAMPOLINE_VA);
>> -		goto out;
>> -	}
>> -
>> -	/* Map the same page again into the runtime page tables */
>> -	err = 	__create_hyp_mappings(hyp_pgd,
>> -				      TRAMPOLINE_VA, TRAMPOLINE_VA + PAGE_SIZE,
>> -				      __phys_to_pfn(hyp_idmap_start),
>> -				      PAGE_HYP);
>> -	if (err) {
>> -		kvm_err("Failed to map trampoline @%lx into runtime HYP pgd\n",
>> -			TRAMPOLINE_VA);
>> -		goto out;
>> +	} else {
>> +		err = kvm_map_idmap_text(hyp_pgd);
>> +		if (err)
>> +			goto out;
> 
> Something I'm not clear on:
> 
> how can we always have merged pgtables on 32-bit ARM at this point?
> 
> why is there not a potential conflict at this point in the series
> between the runtime hyp mappings and the idmaps?

The problem is slightly different. On 32bit, the HYP mapping completely
covers the whole address space, just like the kernel. But if your idmap
and the kernel VA overlap, you are in a very weird position. Actually,
you'll even have trouble booting into the kernel.

So my take on this is that it has already been solved by making sure the
kernel is loaded at an address that won't alias with the kernel VA. If
it hasn't, then they are probably not running mainline Linux.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
