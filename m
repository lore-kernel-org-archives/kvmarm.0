From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 09/17] kvm: arm64: Make stage2 page table layout
 dynamic
Date: Wed, 25 Apr 2018 17:35:48 +0100
Message-ID: <2359e848-8068-ea25-e44e-e8cfcbc9b467@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-10-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-10-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 27/03/18 14:15, Suzuki K Poulose wrote:
> So far we had a static stage2 page table handling code, based on a
> fixed IPA of 40bits. As we prepare for a configurable IPA size per
> VM, make the our stage2 page table code dynamic to do the right thing
> for a given VM.
> 
> Support for the IPA size configuration needs other changes in the way
> we configure the EL2 registers (VTTBR and VTCR). So, the IPA is still
> fixed to 40bits. The patch also moves the kvm_page_empty() in asm/kvm_mmu.h
> to the top, before including the asm/stage2_pgtable.h to avoid a forward
> declaration.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_mmu.h              |  16 +-
>   arch/arm64/include/asm/stage2_pgtable-nopmd.h |  42 ------
>   arch/arm64/include/asm/stage2_pgtable-nopud.h |  39 -----
>   arch/arm64/include/asm/stage2_pgtable.h       | 203 +++++++++++++++++---------
>   4 files changed, 145 insertions(+), 155 deletions(-)
>   delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
>   delete mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 594c4e6..bc133ce 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -18,9 +18,10 @@
>   #ifndef __ARM64_KVM_MMU_H__
>   #define __ARM64_KVM_MMU_H__
>   
> +#include <asm/cpufeature.h>
>   #include <asm/page.h>
>   #include <asm/memory.h>
> -#include <asm/cpufeature.h>

OOI, why was the include of cpufeature.h moved earlier?

Cheers,

-- 
Julien Grall
