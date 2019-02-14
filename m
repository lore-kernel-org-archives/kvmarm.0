From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] kvm: arm64: Fix comment for KVM_PHYS_SHIFT
Date: Thu, 14 Feb 2019 10:11:38 +0000
Message-ID: <f14b90b1-ca81-e57e-9c42-6c8a4608cf72@arm.com>
References: <1550108746-14704-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 731994A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 05:11:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oR5bb89Fg97o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Feb 2019 05:11:45 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 676C449E3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 05:11:45 -0500 (EST)
In-Reply-To: <1550108746-14704-1-git-send-email-yuzenghui@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: yuzenghui@huawei.com, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi

On 14/02/2019 01:45, Zenghui Yu wrote:
> Since Suzuki K Poulose's work on Dynamic IPA support, KVM_PHYS_SHIFT will
> be used only when machine_type's bits[7:0] equal to 0 (by default). Thus
> the outdated comment should be fixed.
> 
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 8af4b1b..a12bf48 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -138,7 +138,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>   	})
>   
>   /*
> - * We currently only support a 40bit IPA.
> + * We currently support using a VM-specified IPA size. For backward
> + * compatibility, the default IPA size is fixed to 40bits.
>    */
>   #define KVM_PHYS_SHIFT	(40)

Thanks for the fix.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
