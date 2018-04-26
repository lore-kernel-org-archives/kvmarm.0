From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 08/17] kvm: arm/arm64: Prepare for VM specific stage2
 translations
Date: Thu, 26 Apr 2018 14:35:10 +0100
Message-ID: <7f67fca2-b936-25d9-0fe8-aece1fadafdc@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-9-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-9-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 27/03/18 14:15, Suzuki K Poulose wrote:
> Right now the stage2 page table for a VM is hard coded, assuming
> an IPA of 40bits. As we are about to add support for per VM IPA,
> prepare the stage2 page table helpers to accept the kvm instance
> to make the right decision for the VM. No functional changes.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm/include/asm/kvm_arm.h                |   3 +-
>   arch/arm/include/asm/kvm_mmu.h                |  15 +++-
>   arch/arm/include/asm/stage2_pgtable.h         |  42 ++++-----
>   arch/arm64/include/asm/kvm_mmu.h              |   7 +-
>   arch/arm64/include/asm/stage2_pgtable-nopmd.h |  18 ++--
>   arch/arm64/include/asm/stage2_pgtable-nopud.h |  16 ++--
>   arch/arm64/include/asm/stage2_pgtable.h       |  49 ++++++-----
>   virt/kvm/arm/arm.c                            |   2 +-
>   virt/kvm/arm/mmu.c                            | 119 +++++++++++++-------------
>   virt/kvm/arm/vgic/vgic-kvm-device.c           |   2 +-
>   10 files changed, 148 insertions(+), 125 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
> index 3ab8b37..c3f1f9b 100644
> --- a/arch/arm/include/asm/kvm_arm.h
> +++ b/arch/arm/include/asm/kvm_arm.h
> @@ -133,8 +133,7 @@
>    * space.
>    */
>   #define KVM_PHYS_SHIFT	(40)
> -#define KVM_PHYS_SIZE	(_AC(1, ULL) << KVM_PHYS_SHIFT)
> -#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - _AC(1, ULL))

I assume you are moving them to kvm_mmu.h in order to match the arm64 
side, right? If so, would not it make sense to make KVM_PHYS_SHIFT with it?

[...]

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 7faed6e..594c4e6 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -134,8 +134,11 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>    * We currently only support a 40bit IPA.
>    */
>   #define KVM_PHYS_SHIFT	(40)
> -#define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
> -#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
> +
> +#define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
> +#define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))

NIT: is the _AC(...) necessary? It does not look like this function is 
going to be usable in assembly.

> +#define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))

Same here.

-- 
Julien Grall
