From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/4] KVM: arm/arm64: Remove unnecessary CMOs when creating
 HYP page tables
Date: Thu, 24 May 2018 17:36:46 +0100
Message-ID: <4a60f80f-a2c7-2c97-72fc-72b26f7fff5b@arm.com>
References: <20180517103548.5622-1-marc.zyngier@arm.com>
 <20180517103548.5622-4-marc.zyngier@arm.com>
 <20180524155117.qdi25z33lnmkrsoe@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4636F4A0D4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:26:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OeeSUWeISAz1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 12:26:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A1749F8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:26:07 -0400 (EDT)
In-Reply-To: <20180524155117.qdi25z33lnmkrsoe@armageddon.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/05/18 16:51, Catalin Marinas wrote:
> On Thu, May 17, 2018 at 11:35:47AM +0100, Marc Zyngier wrote:
>> There is no need to perform cache maintenance operations when
>> creating the HYP page tables if we have the multiprocessing
>> extensions. ARMv7 mandates them with the virtualization support,
>> and ARMv8 just mandates them unconditionally.
>>
>> Let's remove these operations.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/mmu.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index ba66bf7ae299..acbfea09578c 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -578,7 +578,6 @@ static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
>>  		pte = pte_offset_kernel(pmd, addr);
>>  		kvm_set_pte(pte, pfn_pte(pfn, prot));
>>  		get_page(virt_to_page(pte));
>> -		kvm_flush_dcache_to_poc(pte, sizeof(*pte));
>>  		pfn++;
>>  	} while (addr += PAGE_SIZE, addr != end);
>>  }
>> @@ -605,7 +604,6 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
>>  			}
>>  			pmd_populate_kernel(NULL, pmd, pte);
>>  			get_page(virt_to_page(pmd));
>> -			kvm_flush_dcache_to_poc(pmd, sizeof(*pmd));
>>  		}
>>  
>>  		next = pmd_addr_end(addr, end);
>> @@ -638,7 +636,6 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
>>  			}
>>  			pud_populate(NULL, pud, pmd);
>>  			get_page(virt_to_page(pud));
>> -			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
>>  		}
>>  
>>  		next = pud_addr_end(addr, end);
>> @@ -675,7 +672,6 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
>>  			}
>>  			pgd_populate(NULL, pgd, pud);
>>  			get_page(virt_to_page(pgd));
>> -			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
>>  		}
>>  
>>  		next = pgd_addr_end(addr, end);
>> @@ -685,6 +681,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
>>  		pfn += (next - addr) >> PAGE_SHIFT;
>>  	} while (addr = next, addr != end);
>>  out:
>> +	dsb(ishst);
>>  	mutex_unlock(&kvm_hyp_pgd_mutex);
> 
> Why do we need the DSB here? A comment would help.

That's a combination of me being paranoid (we've just dropped a bunch of
CMOs that had DSBs there), and prior art (see dcadda146f4f -- adding
Mark who authored that change).

My understanding is also that we do need this as per K11.5.3 (ARMv8 ARM
rev C.a), which indicates that a DSB ISH "ensures visibility of the
update to translation table walks".

There is also this text:

<quote>

A translation table walk is considered to be a separate observer, and:
-  A write to the translation tables can be observed by that separate
observer at any time after the execution of the instruction that
performed that write, but is only guaranteed to be observable after the
execution of a DSB instruction by the PE that executed the instruction
that performed that write to the translation tables.

</quote>

I'm happy to add comment though.

> If a DMB is sufficient, I think mutex_unlock has release semantics.

I don't think it is, unfortunately.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
