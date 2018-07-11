From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 3/7] KVM: arm64: Support dirty page tracking for PUD
 hugepages
Date: Wed, 11 Jul 2018 14:03:02 +0100
Message-ID: <dd3ab2b5-a0c3-3847-a048-94bc6de481ff@arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
 <20180709144124.29164-1-punit.agrawal@arm.com>
 <20180709144124.29164-3-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709144124.29164-3-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/18 15:41, Punit Agrawal wrote:
> In preparation for creating PUD hugepages at stage 2, add support for
> write protecting PUD hugepages when they are encountered. Write
> protecting guest tables is used to track dirty pages when migrating
> VMs.
> 
> Also, provide trivial implementations of required kvm_s2pud_* helpers
> to allow sharing of code with arm32.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h   | 16 ++++++++++++++++
>   arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
>   virt/kvm/arm/mmu.c               | 11 +++++++----
>   3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index d095c2d0b284..c23722f75d5c 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -80,6 +80,22 @@ void kvm_clear_hyp_idmap(void);
>   
>   #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
>   
> +/*
> + * The following kvm_*pud*() functionas are provided strictly to allow

nit: s/functionas/functions/

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
