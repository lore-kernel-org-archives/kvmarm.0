Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2C1C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 18:41:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDFA523AAC
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 18:41:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDFA523AAC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AF74B11F;
	Fri, 22 Jan 2021 13:41:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pn2V1wBWwn33; Fri, 22 Jan 2021 13:41:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAFE24B0EF;
	Fri, 22 Jan 2021 13:41:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9EB64B0D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 13:41:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fwBBp2OHk8ke for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 13:41:46 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 980BF4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 13:41:46 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCB82376F;
 Fri, 22 Jan 2021 18:41:42 +0000 (UTC)
Date: Fri, 22 Jan 2021 18:41:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 09/21] arm64: cpufeature: Add global feature override
 facility
Message-ID: <20210122184139.GG8567@gaia>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-10-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-10-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Mon, Jan 18, 2021 at 09:45:21AM +0000, Marc Zyngier wrote:
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 9a555809b89c..465d2cb63bfc 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -75,6 +75,8 @@ struct arm64_ftr_reg {
>  	u64				sys_val;
>  	u64				user_val;
>  	const struct arm64_ftr_bits	*ftr_bits;
> +	u64				*override_val;
> +	u64				*override_mask;
>  };
>  
>  extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e99eddec0a46..aaa075c6f029 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -544,13 +544,17 @@ static const struct arm64_ftr_bits ftr_raz[] = {
>  	ARM64_FTR_END,
>  };
>  
> -#define ARM64_FTR_REG(id, table) {		\
> -	.sys_id = id,				\
> -	.reg = 	&(struct arm64_ftr_reg){	\
> -		.name = #id,			\
> -		.ftr_bits = &((table)[0]),	\
> +#define ARM64_FTR_REG_OVERRIDE(id, table, v, m) {		\
> +		.sys_id = id,					\
> +		.reg = 	&(struct arm64_ftr_reg){		\
> +			.name = #id,				\
> +			.ftr_bits = &((table)[0]),		\
> +			.override_val = v,			\
> +			.override_mask = m,			\
>  	}}
>  
> +#define ARM64_FTR_REG(id, table) ARM64_FTR_REG_OVERRIDE(id, table, NULL, NULL)
> +
>  static const struct __ftr_reg_entry {
>  	u32			sys_id;
>  	struct arm64_ftr_reg 	*reg;
> @@ -760,6 +764,7 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
>  	u64 strict_mask = ~0x0ULL;
>  	u64 user_mask = 0;
>  	u64 valid_mask = 0;
> +	u64 override_val = 0, override_mask = 0;
>  
>  	const struct arm64_ftr_bits *ftrp;
>  	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
> @@ -767,9 +772,38 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
>  	if (!reg)
>  		return;
>  
> +	if (reg->override_mask && reg->override_val) {
> +		override_mask = *reg->override_mask;
> +		override_val = *reg->override_val;
> +	}
> +
>  	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
>  		u64 ftr_mask = arm64_ftr_mask(ftrp);
>  		s64 ftr_new = arm64_ftr_value(ftrp, new);
> +		s64 ftr_ovr = arm64_ftr_value(ftrp, override_val);
> +
> +		if ((ftr_mask & override_mask) == ftr_mask) {
> +			s64 tmp = arm64_ftr_safe_value(ftrp, ftr_ovr, ftr_new);
> +			char *str = NULL;
> +
> +			if (ftr_ovr != tmp) {
> +				/* Unsafe, remove the override */
> +				*reg->override_mask &= ~ftr_mask;
> +				*reg->override_val &= ~ftr_mask;

Do we need such clearing here? I don't think that's ever called again
for this feature/reg.

> +				tmp = ftr_ovr;
> +				str = "ignoring override";
> +			} else if (ftr_new != tmp) {
> +				/* Override was valid */
> +				ftr_new = tmp;
> +				str = "forced";
> +			}
> +
> +			if (str)
> +				pr_warn("%s[%d:%d]: %s to %llx\n",
> +					reg->name,
> +					ftrp->shift + ftrp->width - 1,
> +					ftrp->shift, str, tmp);
> +		}
>  
>  		val = arm64_ftr_set_value(ftrp, val, ftr_new);

I wonder whether we could call, after init_cpu_ftr_reg(), a new function
similar to update_cpu_ftr_reg() that takes a mask and value and leave
init_cpu_ftr_reg() unchanged. The only advantage would be if we can get
rid of the reg->override* fields. Anyway, I need to read the rest of the
series to see whether it's possible. Otherwise this patch looks fine.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
