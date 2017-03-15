From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 2/3] kvm: arm/arm64: Take mmap_sem in
 kvm_arch_prepare_memory_region
Date: Wed, 15 Mar 2017 12:05:26 +0100
Message-ID: <20170315110526.GC31974@cbox>
References: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
 <1489503154-20705-3-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE7140A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 07:04:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C8-K9vlLeH-B for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 07:04:03 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A4DF40A7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 07:04:03 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id u48so8477967wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 04:05:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1489503154-20705-3-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, andreyknvl@google.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, catalin.marinas@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 14, 2017 at 02:52:33PM +0000, Suzuki K Poulose wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> We don't hold the mmap_sem while searching for VMAs (via find_vma), in
> kvm_arch_prepare_memory_region, which can end up in expected failures.
> 
> Fixes: commit 8eef91239e57 ("arm/arm64: KVM: map MMIO regions at creation time")
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Eric Auger <eric.auger@rehat.com>
> Cc: stable@vger.kernel.org # v3.18+
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> [ Handle dirty page logging failure case ]
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm/kvm/mmu.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index f2e2e0c..13b9c1f 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1803,6 +1803,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	    (KVM_PHYS_SIZE >> PAGE_SHIFT))
>  		return -EFAULT;
>  
> +	down_read(&current->mm->mmap_sem);
>  	/*
>  	 * A memory region could potentially cover multiple VMAs, and any holes
>  	 * between them, so iterate over all of them to find out if we can map
> @@ -1846,8 +1847,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  			pa += vm_start - vma->vm_start;
>  
>  			/* IO region dirty page logging not allowed */
> -			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES)
> -				return -EINVAL;
> +			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +				ret = -EINVAL;
> +				goto out;
> +			}
>  
>  			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
>  						    vm_end - vm_start,
> @@ -1859,7 +1862,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	} while (hva < reg_end);
>  
>  	if (change == KVM_MR_FLAGS_ONLY)
> -		return ret;
> +		goto out;
>  
>  	spin_lock(&kvm->mmu_lock);
>  	if (ret)
> @@ -1867,6 +1870,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	else
>  		stage2_flush_memslot(kvm, memslot);
>  	spin_unlock(&kvm->mmu_lock);
> +out:
> +	up_read(&current->mm->mmap_sem);
>  	return ret;
>  }
>  
> -- 
> 2.7.4
> 
