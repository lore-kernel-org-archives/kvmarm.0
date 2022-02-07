Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8009AC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDCC24B137;
	Tue,  8 Feb 2022 08:58:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5DGfcYbQePdx; Tue,  8 Feb 2022 08:58:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62D614B187;
	Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378584A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 18:54:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sah0Ft8D0L4G for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 18:54:33 -0500 (EST)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 582CB410DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 18:54:33 -0500 (EST)
Received: by mail-il1-f181.google.com with SMTP id m17so12518837ilj.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 15:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=qe1HIsobsjsqqovhNg1dTepKFqWmN+a6KPj6qtwUnWY=;
 b=GNyOq+vpsfpSC9QIrBb/7GjblKlADOIqWX4+fMq9/u1WfMddHB0fS49onDPdtXoVPt
 yTQvKiWdujbtWyWuNAJBCFXj/ug/r2yHinspBGhhYNX9TqH1ysSKBypJBXi/iWqGag0w
 GMI/AX5J2nDV5UGYQOPFsIy1vpNwRbZOqz5ok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=qe1HIsobsjsqqovhNg1dTepKFqWmN+a6KPj6qtwUnWY=;
 b=NiLC9ReKvjrpftThZibEJ/2NyK8xlWxyygFUAimmPNQU3lZ2ZKT5Qv9la8fQoaTR/+
 3WSMnZGU6CppVmBQ7fjraJCpzlH22ZViSlZlhjTwBA2pXLkR6PK228eWyJGYYoUgLspS
 YkOB3uNapGEgA79WOplUXO6QDifTUWS8ea62oEm/o08QLHkoAoPvIat+jLakg+cAXKAn
 8+wcSOWO2VODvwJWDZQFPxmASA8IK7JoKkWdHCutJWIjlojFOa01k1WmwgiXiW9CP3+7
 aVbimCOFoqkEi4MshYwtx69mcmiTWBO3AlrW4AWESNtZkNbTEpTG+M6xuTf8fh2Yie5Q
 XgSg==
X-Gm-Message-State: AOAM531zr6dpZVYRUr3eCUvq8ns2QWnLCy6Y+pRbNfPl7rBM7CMwrfej
 3bZl/WhnJNBjSsUAEX0ple/JDQ==
X-Google-Smtp-Source: ABdhPJyCgVME8X/bAItiYGT5c+rfQjilh5rsHieEvdLoeWX2msU9HoQD9yLg5PgDg85hVcKDwatsDw==
X-Received: by 2002:a05:6e02:1aaf:: with SMTP id
 l15mr874954ilv.31.1644278072703; 
 Mon, 07 Feb 2022 15:54:32 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id o7sm6317885ilo.17.2022.02.07.15.54.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 15:54:32 -0800 (PST)
Subject: Re: [PATCH v11 05/40] kselftest/arm64: signal: Allow tests to be
 incompatible with features
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-6-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <10072dd0-8853-81fe-0c94-a00638b12f9a@linuxfoundation.org>
Date: Mon, 7 Feb 2022 16:54:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-6-broonie@kernel.org>
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

On 2/7/22 8:20 AM, Mark Brown wrote:
> Some features may invalidate some tests, for example by supporting an
> operation which would trap otherwise. Allow tests to list features that
> they are incompatible with so we can cover the case where a signal will
> be generated without disruption on systems where that won't happen.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   .../selftests/arm64/signal/test_signals.h     |  1 +
>   .../arm64/signal/test_signals_utils.c         | 34 ++++++++++++++-----
>   .../arm64/signal/test_signals_utils.h         |  2 ++
>   3 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/arm64/signal/test_signals.h b/tools/testing/selftests/arm64/signal/test_signals.h
> index ebe8694dbef0..f909b70d9e98 100644
> --- a/tools/testing/selftests/arm64/signal/test_signals.h
> +++ b/tools/testing/selftests/arm64/signal/test_signals.h
> @@ -53,6 +53,7 @@ struct tdescr {
>   	char			*name;
>   	char			*descr;
>   	unsigned long		feats_required;
> +	unsigned long		feats_incompatible;
>   	/* bitmask of effectively supported feats: populated at run-time */
>   	unsigned long		feats_supported;
>   	bool			initialized;
> diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.c b/tools/testing/selftests/arm64/signal/test_signals_utils.c
> index 2f8c23af3b5e..5743897984b0 100644
> --- a/tools/testing/selftests/arm64/signal/test_signals_utils.c
> +++ b/tools/testing/selftests/arm64/signal/test_signals_utils.c
> @@ -36,6 +36,8 @@ static inline char *feats_to_string(unsigned long feats)
>   {
>   	size_t flen = MAX_FEATS_SZ - 1;
>   
> +	feats_string[0] = '\0';
> +
>   	for (int i = 0; i < FMAX_END; i++) {
>   		if (feats & (1UL << i)) {
>   			size_t tlen = strlen(feats_names[i]);
> @@ -256,7 +258,7 @@ int test_init(struct tdescr *td)
>   		td->minsigstksz = MINSIGSTKSZ;
>   	fprintf(stderr, "Detected MINSTKSIGSZ:%d\n", td->minsigstksz);
>   
> -	if (td->feats_required) {
> +	if (td->feats_required || td->feats_incompatible) {
>   		td->feats_supported = 0;
>   		/*
>   		 * Checking for CPU required features using both the
> @@ -267,15 +269,29 @@ int test_init(struct tdescr *td)
>   		if (getauxval(AT_HWCAP) & HWCAP_SVE)
>   			td->feats_supported |= FEAT_SVE;
>   		if (feats_ok(td)) {
> -			fprintf(stderr,
> -				"Required Features: [%s] supported\n",
> -				feats_to_string(td->feats_required &
> -						td->feats_supported));
> +			if (td->feats_required & td->feats_supported)
> +				fprintf(stderr,
> +					"Required Features: [%s] supported\n",
> +					feats_to_string(td->feats_required &
> +							td->feats_supported));
> +			if (!(td->feats_incompatible & td->feats_supported))
> +				fprintf(stderr,
> +					"Incompatible Features: [%s] absent\n",
> +					feats_to_string(td->feats_incompatible));
>   		} else {
> -			fprintf(stderr,
> -				"Required Features: [%s] NOT supported\n",
> -				feats_to_string(td->feats_required &
> -						~td->feats_supported));
> +			if ((td->feats_required & td->feats_supported) !=
> +			    td->feats_supported)
> +				fprintf(stderr,
> +					"Required Features: [%s] NOT supported\n",
> +					feats_to_string(td->feats_required &
> +							~td->feats_supported));
> +			if (td->feats_incompatible & td->feats_supported)
> +				fprintf(stderr,
> +					"Incompatible Features: [%s] supported\n",
> +					feats_to_string(td->feats_incompatible &
> +							~td->feats_supported));
> +
> +
>   			td->result = KSFT_SKIP;
>   			return 0;
>   		}
> diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.h b/tools/testing/selftests/arm64/signal/test_signals_utils.h
> index 6772b5c8d274..f3aa99ba67bb 100644
> --- a/tools/testing/selftests/arm64/signal/test_signals_utils.h
> +++ b/tools/testing/selftests/arm64/signal/test_signals_utils.h
> @@ -18,6 +18,8 @@ void test_result(struct tdescr *td);
>   
>   static inline bool feats_ok(struct tdescr *td)
>   {
> +	if (td->feats_incompatible & td->feats_supported)
> +		return false;
>   	return (td->feats_required & td->feats_supported) == td->feats_required;
>   }
>   
> 

Assuming default_handler() will skip test and return skip test when
feature is unsupported?

Looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
