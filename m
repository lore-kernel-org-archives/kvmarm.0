From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: KVM: Fix stage-2 PGD allocation to have
 per-page refcounting
Date: Wed, 11 Mar 2015 13:13:03 +0000
Message-ID: <55003F5F.6050706@arm.com>
References: <1426014421-5579-1-git-send-email-marc.zyngier@arm.com>
 <1426014421-5579-2-git-send-email-marc.zyngier@arm.com>
 <20150311121635.GA12888@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6099C485FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 09:06:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wd2siCvbljuC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 09:06:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42B74485F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 09:06:46 -0400 (EDT)
In-Reply-To: <20150311121635.GA12888@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 11/03/15 12:16, Christoffer Dall wrote:
> Hi Marc,
> 
> On Tue, Mar 10, 2015 at 07:06:59PM +0000, Marc Zyngier wrote:
>> We're using __get_free_pages with to allocate the guest's stage-2
>> PGD. The standard behaviour of this function is to return a set of
>> pages where only the head page has a valid refcount.
>>
>> This behaviour gets us into trouble when we're trying to increment
>> the refcount on a non-head page:
>>
>> page:ffff7c00cfb693c0 count:0 mapcount:0 mapping:          (null) index:0x0
>> flags: 0x4000000000000000()
>> page dumped because: VM_BUG_ON_PAGE((*({ __attribute__((unused)) typeof((&page->_count)->counter) __var = ( typeof((&page->_count)->counter)) 0; (volatile typeof((&page->_count)->counter) *)&((&page->_count)->counter); })) <= 0)
>> BUG: failure at include/linux/mm.h:548/get_page()!
>> Kernel panic - not syncing: BUG!
>> CPU: 1 PID: 1695 Comm: kvm-vcpu-0 Not tainted 4.0.0-rc1+ #3825
>> Hardware name: APM X-Gene Mustang board (DT)
>> Call trace:
>> [<ffff80000008a09c>] dump_backtrace+0x0/0x13c
>> [<ffff80000008a1e8>] show_stack+0x10/0x1c
>> [<ffff800000691da8>] dump_stack+0x74/0x94
>> [<ffff800000690d78>] panic+0x100/0x240
>> [<ffff8000000a0bc4>] stage2_get_pmd+0x17c/0x2bc
>> [<ffff8000000a1dc4>] kvm_handle_guest_abort+0x4b4/0x6b0
>> [<ffff8000000a420c>] handle_exit+0x58/0x180
>> [<ffff80000009e7a4>] kvm_arch_vcpu_ioctl_run+0x114/0x45c
>> [<ffff800000099df4>] kvm_vcpu_ioctl+0x2e0/0x754
>> [<ffff8000001c0a18>] do_vfs_ioctl+0x424/0x5c8
>> [<ffff8000001c0bfc>] SyS_ioctl+0x40/0x78
>> CPU0: stopping
>>
>> A possible approach for this is to split the compound page using
>> split_page() at allocation time, and change the teardown path to
>> free one page at a time.
>>
>> While we're at it, the PGD allocation code is reworked to reduce
>> duplication.
>>
>> This has been tested on an X-Gene platform with a 4kB/48bit-VA host
>> kernel, and kvmtool hacked to place memory in the second page of
>> the hardware PGD (PUD for the host kernel). Also regression-tested
>> on a Cubietruck (Cortex-A7).
>>
>> Reported-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_mmu.h   |  9 ++---
>>  arch/arm/kvm/mmu.c               | 77 +++++++++++++++++++++++++++++++---------
>>  arch/arm64/include/asm/kvm_mmu.h | 46 +++---------------------
>>  3 files changed, 66 insertions(+), 66 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>> index 0187606..ff56f91 100644
>> --- a/arch/arm/include/asm/kvm_mmu.h
>> +++ b/arch/arm/include/asm/kvm_mmu.h
>> @@ -162,18 +162,13 @@ static inline bool kvm_page_empty(void *ptr)
>>  
>>  #define KVM_PREALLOC_LEVEL	0
>>  
>> -static inline int kvm_prealloc_hwpgd(struct kvm *kvm, pgd_t *pgd)
>> -{
>> -	return 0;
>> -}
>> -
>> -static inline void kvm_free_hwpgd(struct kvm *kvm) { }
>> -
>>  static inline void *kvm_get_hwpgd(struct kvm *kvm)
>>  {
>>  	return kvm->arch.pgd;
>>  }
>>  
>> +static inline unsigned int kvm_get_hwpgd_order(void) { return S2_PGD_ORDER; }
>> +
>>  struct kvm;
>>  
>>  #define kvm_flush_dcache_to_poc(a,l)	__cpuc_flush_dcache_area((a), (l))
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 69c2b4c..0a5457c 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -634,6 +634,31 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
>>  				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
>>  }
>>  
>> +/* Free the HW pgd, one page at a time */
>> +static void kvm_free_hwpgd(unsigned long hwpgd)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < (1 << kvm_get_hwpgd_order()); i += PAGE_SIZE)
>> +		free_page(hwpgd + i);
>> +}
>> +
>> +/* Allocate the HW PGD, making sure that each page gets its own refcount */
>> +static int kvm_alloc_hwpgd(unsigned long *hwpgdp)
> 
> I think this can be simplified somewhat by just returning an unsigned
> long that can be 0 in the error case which will make the caller look
> a little nicer too.

Sure.

>> +{
>> +	unsigned long hwpgd;
>> +	unsigned int order = kvm_get_hwpgd_order();
>> +
>> +	hwpgd = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
>> +	if (!hwpgd)
>> +		return -ENOMEM;
>> +
>> +	split_page(virt_to_page((void *)hwpgd), order);
> 
> nit: alloc_pages_exact() and free_pages_exact() seem to do this for us,
> is it worth using those instead?

Ah, I didn't know about these.

> It would look something like this on top of your changes:
> 
> 
>  arch/arm/include/asm/kvm_mmu.h   |  5 ++++-
>  arch/arm/kvm/mmu.c               | 32 ++++++++++----------------------
>  arch/arm64/include/asm/kvm_mmu.h |  6 +++---
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index fc05ba8..4cf48c3 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -168,7 +168,10 @@ static inline void *kvm_get_hwpgd(struct kvm *kvm)
>  	return kvm->arch.pgd;
>  }
>  
> -static inline unsigned int kvm_get_hwpgd_order(void) { return S2_PGD_ORDER; }
> +static inline unsigned int kvm_get_hwpgd_size(void)
> +{
> +	return PTRS_PER_S2_PGD * sizeof(pgd_t);
> +}
>  
>  struct kvm;
>  
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 8e91bea3..5656d79 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -633,28 +633,17 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
>  }
>  
>  /* Free the HW pgd, one page at a time */
> -static void kvm_free_hwpgd(unsigned long hwpgd)
> +static void kvm_free_hwpgd(void *hwpgd)
>  {
> -	int i;
> -
> -	for (i = 0; i < (1 << kvm_get_hwpgd_order()); i += PAGE_SIZE)
> -		free_page(hwpgd + i);
> +	free_pages_exact(hwpgd, kvm_get_hwpgd_size());
>  }
>  
>  /* Allocate the HW PGD, making sure that each page gets its own refcount */
> -static int kvm_alloc_hwpgd(unsigned long *hwpgdp)
> +static void *kvm_alloc_hwpgd(void)
>  {
> -	unsigned long hwpgd;
> -	unsigned int order = kvm_get_hwpgd_order();
> -
> -	hwpgd = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
> -	if (!hwpgd)
> -		return -ENOMEM;
> -
> -	split_page(virt_to_page((void *)hwpgd), order);
> +	unsigned int size = kvm_get_hwpgd_size();
>  
> -	*hwpgdp = hwpgd;
> -	return 0;
> +	return alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
>  }
>  
>  /**
> @@ -670,18 +659,17 @@ static int kvm_alloc_hwpgd(unsigned long *hwpgdp)
>   */
>  int kvm_alloc_stage2_pgd(struct kvm *kvm)
>  {
> -	int ret;
>  	pgd_t *pgd;
> -	unsigned long hwpgd;
> +	void *hwpgd;
>  
>  	if (kvm->arch.pgd != NULL) {
>  		kvm_err("kvm_arch already initialized?\n");
>  		return -EINVAL;
>  	}
>  
> -	ret = kvm_alloc_hwpgd(&hwpgd);
> -	if (ret)
> -		return ret;
> +	hwpgd = kvm_alloc_hwpgd();
> +	if (!hwpgd)
> +		return -ENOMEM;
>  
>  	/* When the kernel uses more levels of page tables than the
>  	 * guest, we allocate a fake PGD and pre-populate it to point
> @@ -829,7 +817,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>  		return;
>  
>  	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
> -	kvm_free_hwpgd((unsigned long)kvm_get_hwpgd(kvm));
> +	kvm_free_hwpgd(kvm_get_hwpgd(kvm));
>  	if (KVM_PREALLOC_LEVEL > 0)
>  		kfree(kvm->arch.pgd);
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 3668110..bbfb600 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -189,11 +189,11 @@ static inline void *kvm_get_hwpgd(struct kvm *kvm)
>  	return pmd_offset(pud, 0);
>  }
>  
> -static inline unsigned int kvm_get_hwpgd_order(void)
> +static inline unsigned int kvm_get_hwpgd_size(void)
>  {
>  	if (KVM_PREALLOC_LEVEL > 0)
> -		return PTRS_PER_S2_PGD_SHIFT;
> -	return S2_PGD_ORDER;
> +		return PTRS_PER_S2_PGD * PAGE_SIZE;
> +	return PTRS_PER_S2_PGD * sizeof(pgd_t);
>  }
>  
>  static inline bool kvm_page_empty(void *ptr)

Looks good to me. I'll fold that into the patch, amend the commit
message and resend.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
