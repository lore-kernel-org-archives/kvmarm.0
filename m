Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B98C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:18:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2559122B49
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2559122B49
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9372E4B265;
	Mon, 18 Jan 2021 08:18:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PtRF+eqWvE13; Mon, 18 Jan 2021 08:18:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F11414B267;
	Mon, 18 Jan 2021 08:18:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82AED4B267
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:18:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VtfTxRUTVoPh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:18:42 -0500 (EST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89C584B265
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:18:42 -0500 (EST)
Received: by mail-wr1-f52.google.com with SMTP id 6so9142662wri.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dT8H6DDOS90XqFHWCI7TqFyOQmYmAu8E1f2CVSOpl/o=;
 b=EgspKE8oFCLCiFmdwKtBz2VjUuROfWzgFVAWJT2v2444A0T/mq8eQwih4wjcbDddGB
 kXj2hnBpS3W4vDilb//9GY6jrkUfIj44PxVpxH9MYX5ds+1WnMVw4MzIhG9J0reDPisi
 scE5mTvdAw5Hlnnn4IAsMJw8kncej6tCC3sqbl6YcHhuoYyKStMyGTHZ33dug43+iaLi
 /vLjOyriHbV/JZgpR6REiio1aSN9n5pXnhww3etjfo01vaa34iINw6EeAMAFbx+NYhgA
 rmoDjcd5wEqNg07GM1PnTNgJTYdRNnZMMnL9gFv1EMrC7g5IwYhcj+CIV849advE4KO/
 cG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dT8H6DDOS90XqFHWCI7TqFyOQmYmAu8E1f2CVSOpl/o=;
 b=ZmJaI4Vb9yo79qMM4nzs3p8eLBs6LqI1akdKQxRF3obS/Drt7MEvpdeU2sVj4DQ+CJ
 rFn7Nu57NxyPrMnWEZKlQR6wnr5HL8Ir/BWD2Y/0h1HmVjEFtEDpyjUPW671vkWsZula
 YTqqVP1tb8F2o1BDipozJP2eIBWQj2xcXEXyLFi3CjWWvKYmzh57TQAH4UgOlcWVGHIU
 3rjhXYTLfGH9vEwGNNOzlAUw4iz4OtqmX3Ud2w5o1zsPFxr6BlLGo/INHRgu8Bj2SzWU
 fIJKxlgG9wyeqvn2dTtrkGxyY8UPrVJxBfHfr65WPO/KKZigqj2Z7KlPyURESZdKAFXI
 uWiw==
X-Gm-Message-State: AOAM530bjHyVTz8EdF2Lb6rdXtn4R6fNeoGx//4SwiALQsv8IMmOjmF0
 tO2thIrKJiuTgiKvTRiAMKCwqg==
X-Google-Smtp-Source: ABdhPJwWobt6pVg/42LLNxfilYuO6c87nDIqhPBmiOFom1mvCywbxa/XGq5HBvenNWiYZUprwDAUKA==
X-Received: by 2002:adf:e883:: with SMTP id d3mr25756288wrm.139.1610975921450; 
 Mon, 18 Jan 2021 05:18:41 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id y14sm25110466wru.96.2021.01.18.05.18.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 05:18:40 -0800 (PST)
Date: Mon, 18 Jan 2021 13:18:39 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 15/21] arm64: Add an aliasing facility for the idreg
 override
Message-ID: <20210118131839.7ao33jeufq3dfnb4@google.com>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-16-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-16-maz@kernel.org>
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

On Mon, Jan 18, 2021 at 09:45:27AM +0000, Marc Zyngier wrote:
> In order to map the override of idregs to options that a user
> can easily understand, let's introduce yet another option
> array, which maps an option to the corresponding idreg options.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>

> ---
>  arch/arm64/kernel/idreg-override.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 75d9845f489b..16bc8b3b93ae 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -37,6 +37,12 @@ static const struct reg_desc * const regs[] __initdata = {
>  	&mmfr1,
>  };
>  
> +static const struct {
> +	const char * const	alias;
> +	const char * const	feature;
> +} aliases[] __initdata = {
> +};
> +
>  static int __init find_field(const char *cmdline, const struct reg_desc *reg,
>  			     int f, u64 *v)
>  {
> @@ -80,6 +86,18 @@ static void __init match_options(const char *cmdline)
>  	}
>  }
>  
> +static __init void match_aliases(const char *cmdline)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(aliases); i++) {
> +		char *str = strstr(cmdline, aliases[i].alias);
> +
> +		if ((str == cmdline || (str > cmdline && *(str - 1) == ' ')))

nit: Extract to a 'cmdline_contains' helper? Took me a good few seconds to
parse this in the previous patch. Giving it a name would help, and now it's
also shared.

> +			match_options(aliases[i].feature);
> +	}
> +}
> +
>  static __init void parse_cmdline(void)
>  {
>  	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
> @@ -100,6 +118,7 @@ static __init void parse_cmdline(void)
>  			goto out;
>  
>  		match_options(prop);
> +		match_aliases(prop);
>  
>  		if (!IS_ENABLED(CONFIG_CMDLINE_EXTEND))
>  			return;
> @@ -107,6 +126,7 @@ static __init void parse_cmdline(void)
>  
>  out:
>  	match_options(CONFIG_CMDLINE);
> +	match_aliases(CONFIG_CMDLINE);
>  }
>  
>  void __init init_shadow_regs(void)
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
