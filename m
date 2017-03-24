From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm/arm64: KVM: send SIGBUS error to qemu
Date: Fri, 24 Mar 2017 17:44:20 +0800
Message-ID: <5b2bbc21-98a9-e6c5-b643-6fea009c3e26@huawei.com>
References: <1490274061-487-1-git-send-email-gengdongjiu@huawei.com>
 <58D3E469.8090408@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF85340AE8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 05:43:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VLN2iOtP1NH0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 05:43:30 -0400 (EDT)
Received: from dggrg01-dlp.huawei.com (unknown [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE00940296
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 05:43:29 -0400 (EDT)
In-Reply-To: <58D3E469.8090408@arm.com>
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
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, wangxiongfeng2@huawei.com, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
   thanks for your review.

On 2017/3/23 23:06, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 23/03/17 13:01, Dongjiu Geng wrote:
>> when the pfn is KVM_PFN_ERR_HWPOISON, it indicates to send
>> SIGBUS signal from KVM's fault-handling code to qemu, qemu
>> can handle this signal according to the fault address.
> 
> I'm afraid I beat you to it on this one:
> https://www.spinics.net/lists/arm-kernel/msg568919.html
> 
> (Are you the same gengdj who ask me to post that patch?:
>  https://lkml.org/lkml/2017/3/5/187 )

Oh, yes, it is me. recently I do not check my gmail and think you are not reply mail.
it is great that you upstream this patch.

> 
> We don't need upstream KVM to do this until either arm or arm64 has
> ARCH_SUPPORTS_MEMORY_FAILURE. Punit and Tyler have discovered problems with the
> way arm64's hugepage and hwpoison interact:
> https://www.spinics.net/lists/arm-kernel/msg568995.html
  ok, thanks James. do you know when the arm or arm64 will have ARCH_SUPPORTS_MEMORY_FAILURE?
> 
> 
> Some comments on the differences:
> 
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 962616fd4ddd..1307ec400de3 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -1237,6 +1237,20 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
>>  	__coherent_cache_guest_page(vcpu, pfn, size);
>>  }
>>  
>> +static void kvm_send_hwpoison_signal(unsigned long address,
>> +					struct task_struct *tsk)
>> +{
>> +	siginfo_t info;
>> +
>> +	info.si_signo	= SIGBUS;
>> +	info.si_errno	= 0;
>> +	info.si_code	= BUS_MCEERR_AR;
>> +	info.si_addr	= (void __user *)address;
>> +	info.si_addr_lsb = PAGE_SHIFT;
> 
> Any version of this patch should handle hugepage for the sizes KVM uses in its
> stage2 mappings. By just passing PAGE_SHIFT you let the guest fault for each
> page that makes up the hugepage.
> 
> 
>> +
>> +	send_sig_info(SIGBUS, &info, tsk);
>> +}
>> +
>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>  			  unsigned long fault_status)
>> @@ -1309,6 +1323,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (is_error_noslot_pfn(pfn))
>>  		return -EFAULT;
>>  
>> +	if (is_error_hwpoison_pfn(pfn)) {
>> +		kvm_send_hwpoison_signal(kvm_vcpu_gfn_to_hva(vcpu, gfn),
>> +								current);
>> +		return -EFAULT;
> 
> This will return -EFAULT from the KVM_RUN ioctl(). Is Qemu expected to know it
> should try again? This is indistinguishable from the is_error_noslot_pfn() error
> above.
> 
> x86 returns 0 from this path, kvm_handle_bad_page() in arch/x86/kvm/mmu.c as the
> SIGBUS should arrive first. If the SIGBUS is handled the error has been resolved
> and Qemu can call KVM_RUN again. Returning an error and sending SIGBUS suggests
> there are two problems.
  thanks for that. I think your Statement is reasonable.
> 
> 
>> +	}
>> +
>>  	if (kvm_is_device_pfn(pfn)) {
>>  		mem_type = PAGE_S2_DEVICE;
>>  		flags |= KVM_S2PTE_FLAG_IS_IOMAP;
> 
> 
> 
> Thanks,
> 
> James
> 
> 
> .
> 
