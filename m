From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM:arm/arm64: dcache need be coherent unconditionally
Date: Fri, 9 Mar 2018 14:21:29 +0000
Message-ID: <90dba814-2aa3-e0e3-9021-4c349c9f9165@arm.com>
References: <1520633703-15121-1-git-send-email-peng.hao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520633703-15121-1-git-send-email-peng.hao2@zte.com.cn>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Peng Hao <peng.hao2@zte.com.cn>, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/03/18 22:15, Peng Hao wrote:
> For emulation devices just like vga, keeping coherent dcache between
> guest and host timely is needed.
> Now the display of vnc-viewer will not update continuously and the
> patch can fix up.
> 
> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> ---
>  virt/kvm/arm/mmu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index ec62d1c..4a28395e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1416,8 +1416,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			kvm_set_pfn_dirty(pfn);
>  		}
>  
> -		if (fault_status != FSC_PERM)
> -			clean_dcache_guest_page(pfn, PMD_SIZE);
> +		clean_dcache_guest_page(pfn, PMD_SIZE);
>  
>  		if (exec_fault) {
>  			new_pmd = kvm_s2pmd_mkexec(new_pmd);
> @@ -1438,8 +1437,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			mark_page_dirty(kvm, gfn);
>  		}
>  
> -		if (fault_status != FSC_PERM)
> -			clean_dcache_guest_page(pfn, PAGE_SIZE);
> +		clean_dcache_guest_page(pfn, PAGE_SIZE);
>  
>  		if (exec_fault) {
>  			new_pte = kvm_s2pte_mkexec(new_pte);
> 

I'm sorry, but I have to NAK this.

You're papering over the fundamental issue that you're accessing a
cacheable alias of a non cacheable memory. The architecture is very
clear about why this doesn't work, and KVM implements the architecture.

If you want this to work, map your VGA device as cacheable, add cache
maintenance to QEMU, or use another frame-buffer emulation that doesn't
require such a gack.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
