Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EBFC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 14:46:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9725222BE9
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 14:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9725222BE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04224B29C;
	Mon, 18 Jan 2021 09:46:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0r0k2uDg-5Nc; Mon, 18 Jan 2021 09:46:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC1B14B2A2;
	Mon, 18 Jan 2021 09:46:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7204B29E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 09:46:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mNjPMvaiKIMQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 09:46:40 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 345344B294
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 09:46:40 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id 7so9470547wrz.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XW5nfZgpoFkc4MpoG+G2l89kBAOPYjtlcQxlsdxxH1M=;
 b=r5Ai3uTZhku8aQJq9tizY3Yw68CMO7+HZYlNZhw8fTCzOvdRkrOudtY5rQmIi7ikxw
 t/CMV2AQ9R0fhx+/EvVBN/6PDz/r4J2cG9IL2uZpAWBgipgNXe/RSD30BPRfX1cqGdmQ
 wTPgdP7O+Yvj5qq/deZOtP16MzHNx9iUgC5vqf5VX6yOOMbgkLbGSqrIq8oeMYZcsUqJ
 sR+Ko4lPjPXDEpm/0EzgFnLOW5wuLfd4s0Jkbgm6/SEK36hxDfgs2q54TNs24GvqNDMA
 HxuSr9PrZaaDkTrO73wzvKh2WXoyVHOnojEXP/U9RA+lfRA63YwQjmDPV62/ZjAdU9Dn
 4MeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XW5nfZgpoFkc4MpoG+G2l89kBAOPYjtlcQxlsdxxH1M=;
 b=iZW6K+n+jc4exdA7ZYDl87OZ+3q7N8RW3cQnTHycMoK9o0O13+WI0IB4DAZPwMrbnp
 ewBbmUcItFfGX/S0HNNeAuQICFL8RiG8oinpQPMRJy/uEfohPg/zlZ+P7CcgkEOQPZRG
 cz8IEknUHPAMdPr5na9ear0YkkPJxGtov/bqFXVrGNx1Z9ryrRhohORUvtlb3Yc0fCJF
 jMKThdXKqmR8WX2GdM4PRLmfnaaNjp8qfgctXMJT672JEC62yw2eOz/pcI4mmgDG0sBn
 spGMYOVARE+JqZkt5VjHFC7eSyGk0H3/NQthqaiP0iphywtbBiVuhkHc3H6O82/TXpnk
 QbTg==
X-Gm-Message-State: AOAM530vzy9SgLzeDTcNW7k22q44wBjTG7c+y3ucNsYrVfSX3elDg/wh
 AOz+qpvdS+NCk6fpKa+rxvnilw==
X-Google-Smtp-Source: ABdhPJwRGpx3YsnEW08CMr1seaCnvmc8zx+6grzzj7e7TtfTpL/2RgskjlYeoxYD3YtuShG9uGetYA==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr26439606wrn.245.1610981199072; 
 Mon, 18 Jan 2021 06:46:39 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id g194sm27599927wme.39.2021.01.18.06.46.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 06:46:38 -0800 (PST)
Date: Mon, 18 Jan 2021 14:46:36 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 18/21] arm64: Move "nokaslr" over to the early
 cpufeature infrastructure
Message-ID: <20210118144636.kysdvnmcdm7it5zp@google.com>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-19-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-19-maz@kernel.org>
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 18, 2021 at 09:45:30AM +0000, Marc Zyngier wrote:
> Given that the early cpufeature infrastructure has borrowed quite
> a lot of code from the kaslr implementation, let's reimplement
> the matching of the "nokaslr" option with it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>

> ---
>  arch/arm64/kernel/idreg-override.c | 17 ++++++++++++++
>  arch/arm64/kernel/kaslr.c          | 37 +++---------------------------
>  2 files changed, 20 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 1db54878b2c4..143fe7b8e3ce 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -33,8 +33,24 @@ static const struct reg_desc mmfr1 __initdata = {
>  	},
>  };
>  
> +extern u64 kaslr_feature_val;
> +extern u64 kaslr_feature_mask;
> +
> +static const struct reg_desc kaslr __initdata = {
> +	.name		= "kaslr",
> +#ifdef CONFIG_RANDOMIZE_BASE
> +	.val		= &kaslr_feature_val,
> +	.mask		= &kaslr_feature_mask,
> +#endif
> +	.fields		= {
> +		{ "disabled", 0 },
> +		{}
> +	},
> +};
> +
>  static const struct reg_desc * const regs[] __initdata = {
>  	&mmfr1,
> +	&kaslr,
>  };
>  
>  static const struct {
> @@ -43,6 +59,7 @@ static const struct {
>  } aliases[] __initdata = {
>  	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
>  	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
> +	{ "nokaslr",			"kaslr.disabled=1" },
>  };
>  
>  static int __init find_field(const char *cmdline, const struct reg_desc *reg,
> diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
> index 5fc86e7d01a1..dcc4a5aadbe2 100644
> --- a/arch/arm64/kernel/kaslr.c
> +++ b/arch/arm64/kernel/kaslr.c
> @@ -51,39 +51,8 @@ static __init u64 get_kaslr_seed(void *fdt)
>  	return ret;
>  }
>  
> -static __init bool cmdline_contains_nokaslr(const u8 *cmdline)
> -{
> -	const u8 *str;
> -
> -	str = strstr(cmdline, "nokaslr");
> -	return str == cmdline || (str > cmdline && *(str - 1) == ' ');
> -}
> -
> -static __init bool is_kaslr_disabled_cmdline(void *fdt)
> -{
> -	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
> -		int node;
> -		const u8 *prop;
> -
> -		node = fdt_path_offset(fdt, "/chosen");
> -		if (node < 0)
> -			goto out;
> -
> -		prop = fdt_getprop(fdt, node, "bootargs", NULL);
> -		if (!prop)
> -			goto out;
> -
> -		if (cmdline_contains_nokaslr(prop))
> -			return true;
> -
> -		if (IS_ENABLED(CONFIG_CMDLINE_EXTEND))
> -			goto out;
> -
> -		return false;
> -	}
> -out:
> -	return cmdline_contains_nokaslr(CONFIG_CMDLINE);
> -}
> +u64 kaslr_feature_val __initdata;
> +u64 kaslr_feature_mask __initdata;
>  
>  /*
>   * This routine will be executed with the kernel mapped at its default virtual
> @@ -126,7 +95,7 @@ u64 __init kaslr_early_init(void)
>  	 * Check if 'nokaslr' appears on the command line, and
>  	 * return 0 if that is the case.
>  	 */
> -	if (is_kaslr_disabled_cmdline(fdt)) {
> +	if (kaslr_feature_val & kaslr_feature_mask & 0xf) {

nit: Isn't the 0xf redundant here? You don't re-mask for VH either.

>  		kaslr_status = KASLR_DISABLED_CMDLINE;
>  		return 0;
>  	}
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
