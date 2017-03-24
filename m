From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 24 Mar 2017 19:30:44 +0100
Message-ID: <20170324183044.GK25903@cbox>
References: <20170315160727.16465-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1052F40BE3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 14:28:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z1meFeMwZkDf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 14:28:54 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 323E640966
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 14:28:53 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id n11so19613162wma.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 11:30:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170315160727.16465-1-james.morse@arm.com>
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
Cc: punit.agrawal@arm.com, Marc Zyngier <marc.zyngier@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, gengdongjiu <gengdj.1984@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 15, 2017 at 04:07:27PM +0000, James Morse wrote:
> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64[0], notifications for
> broken memory can call memory_failure() in mm/memory-failure.c to deliver
> SIGBUS to any user space process using the page, and notify all the
> in-kernel users.
> 
> If the page corresponded with guest memory, KVM will unmap this page
> from its stage2 page tables. The user space process that allocated
> this memory may have never touched this page in which case it may not
> be mapped meaning SIGBUS won't be delivered.
> 
> When this happens KVM discovers pfn == KVM_PFN_ERR_HWPOISON when it
> comes to process the stage2 fault.
> 
> Do as x86 does, and deliver the SIGBUS when we discover
> KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb
> as this matches the user space mapping size.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> CC: gengdongjiu <gengdj.1984@gmail.com>
> ---
>  Without this patch both kvmtool and Qemu exit as the KVM_RUN ioctl() returns
>  EFAULT.
>  QEMU: error: kvm run failed Bad address
>  LVKM: KVM_RUN failed: Bad address
> 
>  With this patch both kvmtool and Qemu receive SIGBUS ... and then exit.
>  In the future Qemu can use this signal to notify the guest, for more details
>  see hwpoison[1].
> 
>  [0] https://www.spinics.net/lists/arm-kernel/msg560009.html
>  [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/vm/hwpoison.txt
> 
> 
>  arch/arm/kvm/mmu.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 962616fd4ddd..9d1aa294e88f 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -20,8 +20,10 @@
>  #include <linux/kvm_host.h>
>  #include <linux/io.h>
>  #include <linux/hugetlb.h>
> +#include <linux/sched/signal.h>
>  #include <trace/events/kvm.h>
>  #include <asm/pgalloc.h>
> +#include <asm/siginfo.h>
>  #include <asm/cacheflush.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_mmu.h>
> @@ -1237,6 +1239,23 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
>  	__coherent_cache_guest_page(vcpu, pfn, size);
>  }
>  
> +static void kvm_send_hwpoison_signal(unsigned long address, bool hugetlb)
> +{
> +	siginfo_t info;
> +
> +	info.si_signo   = SIGBUS;
> +	info.si_errno   = 0;
> +	info.si_code    = BUS_MCEERR_AR;
> +	info.si_addr    = (void __user *)address;
> +
> +	if (hugetlb)
> +		info.si_addr_lsb = PMD_SHIFT;
> +	else
> +		info.si_addr_lsb = PAGE_SHIFT;
> +
> +	send_sig_info(SIGBUS, &info, current);
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  unsigned long fault_status)
> @@ -1306,6 +1325,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	smp_rmb();
>  
>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
> +	if (pfn == KVM_PFN_ERR_HWPOISON) {
> +		kvm_send_hwpoison_signal(hva, hugetlb);

The way this is called means that we'll only notify userspace of a huge
mapping if userspace is mapping hugetlbfs, and not because the stage2
mapping may or may not have used transparent huge pages when the error
was discovered.  Is this the desired semantics?

Also notice that the hva is not necessarily aligned to the beginning of
the huge page, so can we be giving userspace wrong information by
pointing in the middle of a huge page and telling it there was an
address error in the size of the PMD ?

> +		return 0;
> +	}
>  	if (is_error_noslot_pfn(pfn))
>  		return -EFAULT;
>  
> -- 
> 2.10.1
> 

Thanks,
-Christoffer
