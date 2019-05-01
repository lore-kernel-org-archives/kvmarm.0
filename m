From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] KVM: arm64: fix ptrauth ID register masking logic
Date: Wed, 1 May 2019 17:16:57 +0100
Message-ID: <20190501161657.GD28109@fuggles.cambridge.arm.com>
References: <20190501161008.31498-1-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B999E4A4DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:17:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mCgT7KORsH8C for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 12:17:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BFA94A456
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:17:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190501161008.31498-1-kristina.martsenko@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 01, 2019 at 05:10:08PM +0100, Kristina Martsenko wrote:
> When a VCPU doesn't have pointer auth, we want to hide all four pointer
> auth ID register fields from the guest, not just one of them.
> 
> Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
> Reported-by: Andrew Murray <andrew.murray@arm.com>
> Fsck-up-by: Marc Zyngier <marc.zyngier@arm.com>

Past tense is "fscked" ;)

With that:

Acked-by: Will Deacon <will.deacon@arm.com>

Will

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9d02643bc601..857b226bcdde 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1088,10 +1088,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> -		val &= ~(0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -			(0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -			(0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -			(0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> +		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> +			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> +			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> +			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
>  	}
>  
>  	return val;
> -- 
> 2.11.0
> 
