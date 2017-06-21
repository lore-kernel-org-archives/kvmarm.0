From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Wed, 21 Jun 2017 15:42:05 +0800
Message-ID: <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com>
References: <20170524163250.29281-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5350340C07
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 03:38:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ZHilNw2xL64 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jun 2017 03:38:11 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9808040962
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jun 2017 03:38:10 -0400 (EDT)
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
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Huangshaoyu <huangshaoyu@huawei.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  I have a comment here:

On 2017/5/25 0:32, James Morse wrote:
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
I heard from our CPU hardware team, when happen HWpoison, CPU hardware does not record the IPA address in the HPFAR_EL2.
Only when the SEA error is related to the page table walk, the HPFAR_EL2 register is updated.
here we got the pfn/gfn from the register HPFAR_EL2, if CPU does not update the HPFAR_EL2 register, we may can not use this method to get the pfn/gfn.
could you confirm arm's armv8.0/armv8.2 standard CPU also use such design? if so, we may need to use other method to get the gfn/pfn/hva address.


>  	if (is_error_noslot_pfn(pfn))
>  		return -EFAULT;
