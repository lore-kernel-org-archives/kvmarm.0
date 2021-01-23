Return-Path: <SRS0=6Z91=G2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40503C433DB
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:04:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE80723159
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE80723159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E9EF4B14A;
	Sat, 23 Jan 2021 09:04:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RrhtUdIizLlm; Sat, 23 Jan 2021 09:04:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C8C4B151;
	Sat, 23 Jan 2021 09:04:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 665E74B14A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:04:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wFoUzodEF4Er for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jan 2021 09:04:37 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87D644B08D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:04:37 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D92B222B51;
 Sat, 23 Jan 2021 14:04:33 +0000 (UTC)
Date: Sat, 23 Jan 2021 14:04:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 13/21] arm64: Allow ID_AA64MMFR1_EL1.VH to be
 overridden from the command line
Message-ID: <YAws76q0mEoB5NZh@Catalins-MacBook-Air.local>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-14-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-14-maz@kernel.org>
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jan 18, 2021 at 09:45:25AM +0000, Marc Zyngier wrote:
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index fe0130d6c0ff..80a5f423444e 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -814,6 +814,9 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
>  	return 8;
>  }
>  
> +extern u64 id_aa64mmfr1_val;
> +extern u64 id_aa64mmfr1_mask;
> +
>  u32 get_kvm_ipa_limit(void);
>  void dump_cpu_features(void);
>  
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 48a011935d8c..5b9343d2e9f0 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -555,6 +555,9 @@ static const struct arm64_ftr_bits ftr_raz[] = {
>  
>  #define ARM64_FTR_REG(id, table) ARM64_FTR_REG_OVERRIDE(id, table, NULL, NULL)
>  
> +u64 id_aa64mmfr1_val;
> +u64 id_aa64mmfr1_mask;
> +
>  static const struct __ftr_reg_entry {
>  	u32			sys_id;
>  	struct arm64_ftr_reg 	*reg;
> @@ -602,7 +605,8 @@ static const struct __ftr_reg_entry {
>  
>  	/* Op1 = 0, CRn = 0, CRm = 7 */
>  	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
> -	ARM64_FTR_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1),
> +	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1,
> +			       &id_aa64mmfr1_val, &id_aa64mmfr1_mask),
>  	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
>  
>  	/* Op1 = 0, CRn = 1, CRm = 2 */
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 392f93b67103..75d9845f489b 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -10,6 +10,7 @@
>  #include <linux/libfdt.h>
>  
>  #include <asm/cacheflush.h>
> +#include <asm/cpufeature.h>
>  #include <asm/setup.h>
>  
>  struct reg_desc {
> @@ -22,7 +23,18 @@ struct reg_desc {
>  	} 			fields[];
>  };
>  
> +static const struct reg_desc mmfr1 __initdata = {
> +	.name		= "id_aa64mmfr1",
> +	.val		= &id_aa64mmfr1_val,
> +	.mask		= &id_aa64mmfr1_mask,
> +	.fields		= {
> +	        { "vh", ID_AA64MMFR1_VHE_SHIFT },
> +		{}
> +	},
> +};
> +
>  static const struct reg_desc * const regs[] __initdata = {
> +	&mmfr1,
>  };

I'm ok in principle with how all these link together. I wonder however
if we could skip the separate u64 variables and just have a struct
reg_override with val and mask u64 rather than pointers. The
ARM64_FTR_REG_OVERRIDE macro takes a pointer to this new struct
reg_override and can access val/mask directly. Some 'const' may need to
be dropped.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
