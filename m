From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 1/3] kvm: arm/arm64: Take mmap_sem in stage2_unmap_vm
Date: Wed, 15 Mar 2017 10:17:55 +0100
Message-ID: <20170315091755.GL1277@cbox>
References: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
 <1489503154-20705-2-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489503154-20705-2-git-send-email-suzuki.poulose@arm.com>
Sender: stable-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, andreyknvl@google.com, dvyukov@google.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, mark.rutland@arm.com, ard.biesheuvel@linaro.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 14, 2017 at 02:52:32PM +0000, Suzuki K Poulose wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> We don't hold the mmap_sem while searching for the VMAs when
> we try to unmap each memslot for a VM. Fix this properly to
> avoid unexpected results.
> 
> Fixes: commit 957db105c997 ("arm/arm64: KVM: Introduce stage2_unmap_vm")
> Cc: stable@vger.kernel.org # v3.19+
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm/kvm/mmu.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 962616f..f2e2e0c 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -803,6 +803,7 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	int idx;
>  
>  	idx = srcu_read_lock(&kvm->srcu);
> +	down_read(&current->mm->mmap_sem);
>  	spin_lock(&kvm->mmu_lock);
>  
>  	slots = kvm_memslots(kvm);
> @@ -810,6 +811,7 @@ void stage2_unmap_vm(struct kvm *kvm)
>  		stage2_unmap_memslot(kvm, memslot);
>  
>  	spin_unlock(&kvm->mmu_lock);
> +	up_read(&current->mm->mmap_sem);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
>  
> -- 
> 2.7.4
> 

Are we sure that holding mmu_lock is valid while holding the mmap_sem?

Thanks,
-Christoffer
