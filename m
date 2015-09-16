From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm: LPAE: Incorrect device to IPA mapping
Date: Wed, 16 Sep 2015 11:33:37 +0100
Message-ID: <55F94581.2060002@arm.com>
References: <1442397895-2124-1-git-send-email-marek.majtyka@tieto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30A7741450
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 06:32:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VYfHkqL-e7ML for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2015 06:32:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E33BA4141D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 06:32:41 -0400 (EDT)
In-Reply-To: <1442397895-2124-1-git-send-email-marek.majtyka@tieto.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "marek.majtyka" <marek.majtyka@tieto.com>, christoffer.dall@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marek,

On 16/09/15 11:04, marek.majtyka wrote:
> From: Marek Majtyka <marek.majtyka@tieto.com>
> 
> A critical bug has been found in device memory stage1 translation for machines
> with more then 4GB of RAM. Once vm_pgoff size is smaller then pa (which is true
> for LPAE case, u32 and u64 respectively) some more significant bits of pa may
> be lost as a shift operation is performed on u32 and later cast onto u64.
> 
> Example: vm_pgoff(u32)=0x00210030, PAGE_SHIFT=12
>         expected pa(u64):   0x0000002010030000
>         produced pa(u64):   0x0000000010030000
> 
> A suggested fix is changing the order of operations (casting first onto
> phys_addr_t and then shifting), which works for both alternatives
> (with and without LPAE).

Well, you can't use KVM without LPAE, so that's a moot point. Also, the
issue is when you place things above 4GB, not when you have more than
4GB of RAM (I cannot see how you allocate that amount of memory from
userspace on 32bit).

> 
> A bug has been found, fixed and tested on kernel v3.19. However, it seems to be
> valid for most, if not all, newer version starting from v3.18.
> 
> Signed-off-by: Marek Majtyka <marek.majtyka@tieto.com>
> ---
>  arch/arm/kvm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 1366625..602bc63 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1408,7 +1408,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if (vma->vm_flags & VM_PFNMAP) {
>  			gpa_t gpa = mem->guest_phys_addr +
>  				    (vm_start - mem->userspace_addr);
> -			phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) +
> +			phys_addr_t pa =
> +				((phys_addr_t) vma->vm_pgoff << PAGE_SHIFT) +
>  					 vm_start - vma->vm_start;
>  
>  			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
> 

Looks perfectly valid to me (the formatting is horrible, but I can fix
that - I can only guess you've followed checkpatch's silly advise).

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Christoffer: if you're OK with that one, I'll add it to the next batch
of fixes.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
