From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 2 Jun 2017 00:22:35 +0200
Message-ID: <20170601222235.GN20919@cbox>
References: <20170524163250.29281-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A267640C4A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 18:18:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rao0tutB2eRZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 18:18:54 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0678940625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 18:18:53 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id d127so5789423wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jun 2017 15:22:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170524163250.29281-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 24, 2017 at 05:32:50PM +0100, James Morse wrote:
> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64, notifications for
> broken memory can call memory_failure() in mm/memory-failure.c to deliver
> SIGBUS to any user space process using the page, and notify all the
> in-kernel users.
> 
> If the page corresponded with guest memory, KVM will unmap this page
> from its stage2 page tables. The user space process that allocated
> this memory may have never touched this page in which case it may not
> be mapped meaning SIGBUS won't be delivered.

Sorry, I don't remember, what is the scenario where KVM can have a
mapping in stage 2 without there being a corresponding mapping for user
space?

> 
> This works well until a guest accesses that page, and KVM discovers
> pfn == KVM_PFN_ERR_HWPOISON when it comes to process the stage2 fault.
> 
> Do as x86 does, and deliver the SIGBUS when we discover
> KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb

But this part about the stage 2 mapping size is not what the code does.
It uses the granularity of the mmap region, if I'm not mistaken.

I lost track of what the right thing was, can you remind me?

Thanks,
-Christoffer


> as this matches the user space mapping size.
> 
> Cc: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> This will be needed once we enable ARCH_SUPPORTS_MEMORY_FAILURE for
> arm64[0]. It is harmless until then as KVM_PFN_ERR_HWPOISON will
> never be seen.
> 
> Changes since v1:
>  * Pass the vma to kvm_send_hwpoison_signal(), used Punit's huge_page_shift()
>    calculation to find the block size.
>  * ... tested against hugepage not transparent huge page ...
> 
> Today we will inherit some existing breakage between KVM, hugepages
> and hwpoison. Patch at [1].
> 
> 
> [0] https://www.spinics.net/lists/arm-kernel/msg581657.html
> [1] https://marc.info/?l=linux-mm&m=149564219918427&w=2
> 
>  virt/kvm/arm/mmu.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 313ee646480f..eaa29aeb7c5b 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -20,6 +20,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/io.h>
>  #include <linux/hugetlb.h>
> +#include <linux/sched/signal.h>
>  #include <trace/events/kvm.h>
>  #include <asm/pgalloc.h>
>  #include <asm/cacheflush.h>
> @@ -1249,6 +1250,24 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
>  	__coherent_cache_guest_page(vcpu, pfn, size);
>  }
>  
> +static void kvm_send_hwpoison_signal(unsigned long address,
> +				     struct vm_area_struct *vma)
> +{
> +	siginfo_t info;
> +
> +	info.si_signo   = SIGBUS;
> +	info.si_errno   = 0;
> +	info.si_code    = BUS_MCEERR_AR;
> +	info.si_addr    = (void __user *)address;
> +
> +	if (is_vm_hugetlb_page(vma))
> +		info.si_addr_lsb = huge_page_shift(hstate_vma(vma));
> +	else
> +		info.si_addr_lsb = PAGE_SHIFT;
> +
> +	send_sig_info(SIGBUS, &info, current);
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  unsigned long fault_status)
> @@ -1318,6 +1337,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	smp_rmb();
>  
>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
> +	if (pfn == KVM_PFN_ERR_HWPOISON) {
> +		kvm_send_hwpoison_signal(hva, vma);
> +		return 0;
> +	}
>  	if (is_error_noslot_pfn(pfn))
>  		return -EFAULT;
>  
> -- 
> 2.11.0
> 
