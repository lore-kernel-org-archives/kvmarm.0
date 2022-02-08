Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A82C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D384B1B6;
	Tue,  8 Feb 2022 08:58:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1dIfu-SwMYpi; Tue,  8 Feb 2022 08:58:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 865774B17D;
	Tue,  8 Feb 2022 08:58:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D4A84B086
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 20:13:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yl5LPHox86p0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 20:13:33 -0500 (EST)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23E1B4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 20:13:33 -0500 (EST)
Received: by mail-io1-f45.google.com with SMTP id h7so19273698iof.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 17:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=RYJZkN72vfiiVbj4pZ257koXe7Ausm54bAvRbEl+V98=;
 b=haZIzlncbxoyd2fPB2xGOXiKsrOfxnr/lPN7ypNIhhz4MsgKw/NJBgAkJLfoJ/CtMt
 MW7pEpJ8532EQUAjy7/LlKPS5FL2B+t2xJlbI4sxYL8VJcoLfxPxttXyDz+ikTwMIRIl
 3Q0ukrjB18SSROe83+h7MJKr1jLA92EiyHMdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=RYJZkN72vfiiVbj4pZ257koXe7Ausm54bAvRbEl+V98=;
 b=ogQ41vTlndZzAPLnFjORr++ggPTW4R1DmIusphg+ZSnSj98lzOukLpZhyDLxSE/cXU
 l5PICMRr7f3i0p383Ms0OmzIIV8Pk52hqrZ3wxhPsck1/S5OPyhlyWCIWTyIyN3moZvx
 Bf/aoOMWUGymUpeFQD6ndNztQS/TXTa1O+J7HdV4nm/VWCYB7CbZINReGmev7Uc10/pO
 aS9krcy61GwLYAqdHplkWt0eKORixpUSbP/u9exCVc7c0c/UheWirWdMCB3QYKcKWF5l
 Ga7KelnT3VdFLGMqP9Kfrk7YZUF/HbH+44XID1psWff2CEYkLEwftXTgGFccRkOA/kYI
 G+dw==
X-Gm-Message-State: AOAM533EuJS9a9/mNWwO+QXsvlksnhinuNIrMg6el7cDKSOU8Ls1Kh2M
 CrnO0L+tPaAG/nJzBWQd27WMKQ==
X-Google-Smtp-Source: ABdhPJzrOn6T1Ct/a3GViSuBzvKW/bAiwmUukcSGbeEYMWarRM7/r3VWLOorVn7oLEqSCLREWV3Xtw==
X-Received: by 2002:a02:3b67:: with SMTP id i39mr1137219jaf.32.1644282812495; 
 Mon, 07 Feb 2022 17:13:32 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id ay35sm7118896iob.3.2022.02.07.17.13.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 17:13:32 -0800 (PST)
Subject: Re: [PATCH v11 38/40] kselftest/arm64: Add streaming SVE to SVE
 ptrace tests
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-39-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bab2028c-b22c-365b-a792-c7c1ee0fec36@linuxfoundation.org>
Date: Mon, 7 Feb 2022 18:13:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-39-broonie@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 08 Feb 2022 08:58:27 -0500
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2/7/22 8:21 AM, Mark Brown wrote:
> In order to allow ptrace of streaming mode SVE registers we have added a
> new regset for streaming mode which in isolation offers the same ABI as
> regular SVE with a different vector type. Add this to the array of regsets
> we handle, together with additional tests for the interoperation of the
> two regsets.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/fp/sve-ptrace.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
> index 4bd333768cc4..509b875cb7bb 100644
> --- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
> +++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
> @@ -26,6 +26,10 @@
>   #define NT_ARM_SVE 0x405
>   #endif
>   
> +#ifndef NT_ARM_SSVE
> +#define NT_ARM_SSVE 0x40b
> +#endif
> +
>   struct vec_type {
>   	const char *name;
>   	unsigned long hwcap_type;
> @@ -42,6 +46,13 @@ static const struct vec_type vec_types[] = {
>   		.regset = NT_ARM_SVE,
>   		.prctl_set = PR_SVE_SET_VL,
>   	},
> +	{
> +		.name = "Streaming SVE",
> +		.hwcap_type = AT_HWCAP2,
> +		.hwcap = HWCAP2_SME,
> +		.regset = NT_ARM_SSVE,
> +		.prctl_set = PR_SME_SET_VL,
> +	},
>   };
>   
>   #define VL_TESTS (((SVE_VQ_MAX - SVE_VQ_MIN) + 1) * 3)
> 

Looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
