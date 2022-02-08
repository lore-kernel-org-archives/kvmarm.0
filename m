Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E669C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1464E4B177;
	Tue,  8 Feb 2022 08:58:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aAGzEnn-I9-f; Tue,  8 Feb 2022 08:58:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5744B1C5;
	Tue,  8 Feb 2022 08:58:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C10A349E48
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 20:01:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E0g3GSxFvBin for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 20:01:52 -0500 (EST)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com
 [209.85.166.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6609649EAC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 20:01:52 -0500 (EST)
Received: by mail-il1-f182.google.com with SMTP id z4so12656373ilz.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 17:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=+MSw8f2/WMFrNwenSrqO3coph/spjyCfBlyMTMFY/nk=;
 b=cPNkEM9iGfcJmQQG5GNFgSuiDqvjU/v/K45O/APMcWW5cUCBQR73fV9H94r8Alz1lK
 6oiDGMhJcO5rLXfq5xdzTTQ6QqyrPxTkFIE3KibvM23+VBpiDMb4vD97E12rzj1ovFkJ
 5KF3SojlyhGie/6lG4LcfosrR6z+q8sOa/UyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+MSw8f2/WMFrNwenSrqO3coph/spjyCfBlyMTMFY/nk=;
 b=QHa9nOJdt0EKjAUuXPeLU2p5KyI3GHptwWqVPKVP221MdAjiS+ll4YVTSIaCbqanHs
 jP9LRChrzxFnIC/E7jaO02LolsE5/JvXpHrxcfZcGKviddoI0kq6ycRkfzrRlA2noCgz
 1vjHPtni5kMOAaaRCp/oEjWakdKxgrrUW56POVl6iF7zEK2a8MkM8/AoxymBxxZR0T6g
 ef9MTN/bxcUA+2dmfmTg+tD6NHf0D+vVs0Z0m6VGryi69IlJu4eNdwZ7jBT6UIcU73IL
 Fzq4Pt/5v24qLpXJeM9plj/hFbcFgTlV7iAAO81xSr2LV2ETotrE3WFLy/na5UipTpzG
 q5VQ==
X-Gm-Message-State: AOAM532cMULYJqYiz95j1XEMWYDUI9Nc+Ha/Ok032GeRSaQZuIKUOhHd
 AUhBj5wOn7yfu94zXbRxoNMXIw==
X-Google-Smtp-Source: ABdhPJyGZReyBrJkI6hJYVU6PZGQBedUHSLPj5q18a333DDeJ2KPnz/9AFYXHaqc7vMPQWKU4pb/bQ==
X-Received: by 2002:a05:6e02:1b83:: with SMTP id
 h3mr997196ili.81.1644282111497; 
 Mon, 07 Feb 2022 17:01:51 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id o7sm6407298ilo.17.2022.02.07.17.01.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 17:01:50 -0800 (PST)
Subject: Re: [PATCH v11 35/40] kselftest/arm64: signal: Handle ZA signal
 context in core code
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-36-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c69632e7-45d1-b29f-79a9-1724cbb0a30b@linuxfoundation.org>
Date: Mon, 7 Feb 2022 18:01:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-36-broonie@kernel.org>
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
> As part of the generic code for signal handling test cases we parse all
> signal frames to make sure they have at least the basic form we expect
> and that there are no unexpected frames present in the signal context.
> Add coverage of the ZA signal frame to this code.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   .../arm64/signal/testcases/testcases.c        | 36 +++++++++++++++++++
>   .../arm64/signal/testcases/testcases.h        |  3 +-
>   2 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
> index 8c2a57fc2f9c..84c36bee4d82 100644
> --- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
> +++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
> @@ -75,6 +75,31 @@ bool validate_sve_context(struct sve_context *sve, char **err)
>   	return true;
>   }
>   
> +bool validate_za_context(struct za_context *za, char **err)
> +{
> +	/* Size will be rounded up to a multiple of 16 bytes */
> +	size_t regs_size
> +		= ((ZA_SIG_CONTEXT_SIZE(sve_vq_from_vl(za->vl)) + 15) / 16) * 16;
> +
> +	if (!za || !err)
> +		return false;
> +
> +	/* Either a bare za_context or a za_context followed by regs data */
> +	if ((za->head.size != sizeof(struct za_context)) &&
> +	    (za->head.size != regs_size)) {
> +		*err = "bad size for ZA context";
> +		return false;
> +	}
> +
> +	if (!sve_vl_valid(za->vl)) {
> +		*err = "SME VL in ZA context invalid";
> +
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>   bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
>   {
>   	bool terminated = false;
> @@ -82,6 +107,7 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
>   	int flags = 0;
>   	struct extra_context *extra = NULL;
>   	struct sve_context *sve = NULL;
> +	struct za_context *za = NULL;
>   	struct _aarch64_ctx *head =
>   		(struct _aarch64_ctx *)uc->uc_mcontext.__reserved;
>   
> @@ -120,6 +146,13 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
>   			sve = (struct sve_context *)head;
>   			flags |= SVE_CTX;
>   			break;
> +		case ZA_MAGIC:
> +			if (flags & ZA_CTX)
> +				*err = "Multiple ZA_MAGIC";

Is this considered an error?

> +			/* Size is validated in validate_za_context() */
> +			za = (struct za_context *)head;
> +			flags |= ZA_CTX;
> +			break;
>   		case EXTRA_MAGIC:
>   			if (flags & EXTRA_CTX)
>   				*err = "Multiple EXTRA_MAGIC";
> @@ -165,6 +198,9 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
>   		if (flags & SVE_CTX)
>   			if (!validate_sve_context(sve, err))
>   				return false;
> +		if (flags & ZA_CTX)
> +			if (!validate_za_context(za, err))

If validate_za_context() finds an error, the above "Multiple ZA_MAGIC" will
be overwritten? Is that the intent?

> +				return false;
>   
>   		head = GET_RESV_NEXT_HEAD(head);
>   	}
> diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.h b/tools/testing/selftests/arm64/signal/testcases/testcases.h
> index ad884c135314..49f1d5de7b5b 100644
> --- a/tools/testing/selftests/arm64/signal/testcases/testcases.h
> +++ b/tools/testing/selftests/arm64/signal/testcases/testcases.h
> @@ -16,7 +16,8 @@
>   
>   #define FPSIMD_CTX	(1 << 0)
>   #define SVE_CTX		(1 << 1)
> -#define EXTRA_CTX	(1 << 2)
> +#define ZA_CTX		(1 << 2)
> +#define EXTRA_CTX	(1 << 3)
>   
>   #define KSFT_BAD_MAGIC	0xdeadbeef
>   
> 

With these explained or fixed:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
