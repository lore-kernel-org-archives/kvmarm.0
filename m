Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7AEC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 09:04:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD95140B03;
	Tue, 26 Apr 2022 05:04:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LaGayERdP-Ou; Tue, 26 Apr 2022 05:04:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A91B3408AA;
	Tue, 26 Apr 2022 05:04:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2D4404CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:04:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 84jtEssZItyd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 05:04:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B590649EF3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:04:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1558F23A;
 Tue, 26 Apr 2022 02:04:23 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 179BA3F73B;
 Tue, 26 Apr 2022 02:04:21 -0700 (PDT)
Date: Tue, 26 Apr 2022 10:04:23 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 2/2] KVM/arm64: Print sysreg table name when table is not
 sorted
Message-ID: <Yme1iccfS+9dUrUU@monolith.localdoman>
References: <20220425163904.859195-1-alexandru.elisei@arm.com>
 <20220425163904.859195-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220425163904.859195-4-alexandru.elisei@arm.com>
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

Hi,

Err.. this is a work-in-progress version of patch #2 ("KVM/arm64: Print
emulated register table name when it is unsorted").  I sent it by mistake
because I forgot to clean the patch directory before sending the series.

I'll resend the series without this patch.

Thanks,
Alex

On Mon, Apr 25, 2022 at 05:39:04PM +0100, Alexandru Elisei wrote:
> When a sysreg table entry is out-of-order, KVM attempts to print the
> address of the table:
> 
> [    0.143881] kvm [1]: sys_reg table (____ptrval____) out of order (0)
> 
> Printing the name of the table instead of a pointer is more helpful in this
> case:
> 
> [    0.143881] kvm [1]: sys_reg table sys_reg_descs out of order (0)
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 57302048afd0..7b62a2daf056 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2188,18 +2188,18 @@ static const struct sys_reg_desc cp15_64_regs[] = {
>  };
>  
>  static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
> -			       bool is_32)
> +			       const char *table_name, bool is_32)
>  {
>  	unsigned int i;
>  
>  	for (i = 0; i < n; i++) {
>  		if (!is_32 && table[i].reg && !table[i].reset) {
> -			kvm_err("sys_reg table %p entry %d lacks reset\n", table, i);
> +			kvm_err("sys_reg table %s entry %d lacks reset\n", table_name, i);
>  			return false;
>  		}
>  
>  		if (i && cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
> -			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
> +			kvm_err("sys_reg table %s out of order (%d)\n", table_name, i - 1);
>  			return false;
>  		}
>  	}
> @@ -2866,12 +2866,14 @@ int kvm_sys_reg_table_init(void)
>  	struct sys_reg_desc clidr;
>  
>  	/* Make sure tables are unique and in order. */
> -	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
> -	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
> -	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
> -	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
> -	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
> -	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
> +	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs),
> +				    "sys_reg_descs", false);
> +	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), "cp14_regs", true);
> +	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), "cp14_64_regs", true);
> +	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), "cp15_regs", true);
> +	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), "cp15_64_regs", true);
> +	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs),
> +				    "invariant_sys_regs", false);
>  
>  	if (!valid)
>  		return -EINVAL;
> -- 
> 2.36.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
