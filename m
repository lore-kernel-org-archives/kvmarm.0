Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B073AC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 15:24:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9F64B28F;
	Wed,  1 Dec 2021 10:24:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fXKEQMzWnCq8; Wed,  1 Dec 2021 10:24:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD434B288;
	Wed,  1 Dec 2021 10:24:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8221A4B284
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 10:24:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xc+foFKBlYts for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 10:24:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24BE14B280
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 10:24:49 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 697DC143B;
 Wed,  1 Dec 2021 07:24:48 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD2603F766;
 Wed,  1 Dec 2021 07:24:45 -0800 (PST)
Date: Wed, 1 Dec 2021 15:24:35 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
Message-ID: <YaeTs4rUZ9uNNQU7@monolith.localdoman>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211117064359.2362060-4-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On Tue, Nov 16, 2021 at 10:43:33PM -0800, Reiji Watanabe wrote:
> This patch lays the groundwork to make ID registers writable.
> 
> Introduce struct id_reg_info for an ID register to manage the
> register specific control of its value for the guest, and provide set
> of functions commonly used for ID registers to make them writable.
> 
> The id_reg_info is used to do register specific initialization,
> validation of the ID register and etc.  Not all ID registers must
> have the id_reg_info. ID registers that don't have the id_reg_info
> are handled in a common way that is applied to all ID registers.
> 
> At present, changing an ID register from userspace is allowed only
> if the ID register has the id_reg_info, but that will be changed
> by the following patches.
> 
> No ID register has the structure yet and the following patches
> will add the id_reg_info for some ID registers.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |   1 +
>  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
>  2 files changed, 218 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 16b3f1a1d468..597609f26331 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1197,6 +1197,7 @@
>  #define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
>  
>  #define ARM64_FEATURE_FIELD_BITS	4
> +#define ARM64_FEATURE_FIELD_MASK	((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
>  
>  /* Create a mask for the feature bits of the specified feature. */
>  #define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5608d3410660..1552cd5581b7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  		return read_zero(vcpu, p);
>  }
>  
> +/*
> + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> + * ftr_check_types of id_reg_info.
> + */
> +enum feature_check_type {
> +	FCT_LOWER_SAFE = 0,
> +	FCT_HIGHER_SAFE,
> +	FCT_HIGHER_OR_ZERO_SAFE,
> +	FCT_EXACT,
> +	FCT_EXACT_OR_ZERO_SAFE,
> +	FCT_IGNORE,	/* Don't check (any value is fine) */
> +};
> +
> +static int arm64_check_feature_one(enum feature_check_type type, int val,
> +				   int limit)
> +{
> +	bool is_safe = false;
> +
> +	if (val == limit)
> +		return 0;
> +
> +	switch (type) {
> +	case FCT_LOWER_SAFE:
> +		is_safe = (val <= limit);
> +		break;
> +	case FCT_HIGHER_OR_ZERO_SAFE:
> +		if (val == 0) {
> +			is_safe = true;
> +			break;
> +		}
> +		fallthrough;
> +	case FCT_HIGHER_SAFE:
> +		is_safe = (val >= limit);
> +		break;
> +	case FCT_EXACT:
> +		break;
> +	case FCT_EXACT_OR_ZERO_SAFE:
> +		is_safe = (val == 0);
> +		break;
> +	case FCT_IGNORE:

What happens if the a new feature is added and the field has a particular
meaning? How are you going to deal with old userspace implementations that
use a value here which now is not allowed or it affects the guest?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
