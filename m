Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40477C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D84354B16F;
	Tue,  8 Feb 2022 08:58:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bNYXIYTqxJj0; Tue,  8 Feb 2022 08:58:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4394B1B4;
	Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8276749F55
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:15:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZAMHPTN87yOY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 19:15:41 -0500 (EST)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com
 [209.85.166.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DA8049F18
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:15:41 -0500 (EST)
Received: by mail-il1-f177.google.com with SMTP id z18so12596176ilp.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 16:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=BgvLO9hr2V7CyEad4Q9zhVhiiHX9h0qd8phe6mg68zg=;
 b=diok9UMph6A2H5uNb/Z6KYHIB6dvzX6ttLpuifYYoA6h5s8mSmC/WfCD6n5H1XDOEn
 lVguHrxhUHRz3IzbcJCaTLPuuRh4WxEZn3yRP09ANS/ytIPq0BzeEYQ6DDLsyP9NqqTx
 FgBluq9mgpMb5bE/0flXsb4pi3bJwMHofETjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=BgvLO9hr2V7CyEad4Q9zhVhiiHX9h0qd8phe6mg68zg=;
 b=0s46NHDXRfbV/1a67irO6DPoMVG22MRpPHuSLNLofwG6kiZPbwbeXzc5O9qwzIJwef
 hbFHWAsQvRKufEFTLF3xzMjP7DaMnh1V+ZU5uyR8x95Q9BT+ez+aNdk7RsasBqjlVxow
 3ptvGSTZrzcZR5wiNu1/ARQkNVMa185+qg/RLL0ZWSemkN5RrxyfLvaj6DnYKfC2Eho/
 wVeflQaMUZat9Q8ONF9xIBQCdYjfT8LdJs54xk2lcNMh1Cdh8meByWp3HktULewWlnj3
 6rPd3ilDjHOAH5ytdwTeIABxERbMpSitjb5phjV3hGFzajDqip/X4PtbQTKzTXOjJH0v
 Mz6w==
X-Gm-Message-State: AOAM532PpJ0wE+x6S2GTz/krEay8Ae4osQZarq9wBeUK7dzrODfz2v/0
 2+qOhgAlT+AkC0TPSD5+wTFl5w==
X-Google-Smtp-Source: ABdhPJxVvgElyB8fUYMMP/TOaUOJybzRRArhutl3SBXSxLmUM8fI5K7z6iWl6nKzUSAe8HoSX1giEQ==
X-Received: by 2002:a92:d24b:: with SMTP id v11mr928645ilg.1.1644279340709;
 Mon, 07 Feb 2022 16:15:40 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id b5sm1883555ilr.0.2022.02.07.16.15.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 16:15:40 -0800 (PST)
Subject: Re: [PATCH v11 31/40] kselftest/arm64: sme: Add SME support to vlset
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-32-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <fc0d4407-8124-2040-41f5-5de091de588f@linuxfoundation.org>
Date: Mon, 7 Feb 2022 17:15:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-32-broonie@kernel.org>
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
> The Scalable Matrix Extenions (SME) introduces additional register state
> with configurable vector lengths, similar to SVE but configured separately.
> Extend vlset to support configuring this state with a --sme or -s command
> line option.

It would be useful to add a -g command to get the current value.
-g would just do PR_SVE_GET_VL and print the value perhaps?

> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/fp/vlset.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/arm64/fp/vlset.c b/tools/testing/selftests/arm64/fp/vlset.c
> index 308d27a68226..76912a581a95 100644
> --- a/tools/testing/selftests/arm64/fp/vlset.c
> +++ b/tools/testing/selftests/arm64/fp/vlset.c
> @@ -22,12 +22,15 @@ static int inherit = 0;
>   static int no_inherit = 0;
>   static int force = 0;
>   static unsigned long vl;
> +static int set_ctl = PR_SVE_SET_VL;
> +static int get_ctl = PR_SVE_GET_VL;
>   
>   static const struct option options[] = {
>   	{ "force",	no_argument, NULL, 'f' },
>   	{ "inherit",	no_argument, NULL, 'i' },
>   	{ "max",	no_argument, NULL, 'M' },
>   	{ "no-inherit",	no_argument, &no_inherit, 1 },
> +	{ "sme",	no_argument, NULL, 's' },
>   	{ "help",	no_argument, NULL, '?' },
>   	{}
>   };
> @@ -50,6 +53,9 @@ static int parse_options(int argc, char **argv)
>   		case 'M':	vl = SVE_VL_MAX; break;
>   		case 'f':	force = 1; break;
>   		case 'i':	inherit = 1; break;
> +		case 's':	set_ctl = PR_SME_SET_VL;
> +				get_ctl = PR_SME_GET_VL;
> +				break;
>   		case 0:		break;
>   		default:	goto error;
>   		}
> @@ -125,14 +131,14 @@ int main(int argc, char **argv)
>   	if (inherit)
>   		flags |= PR_SVE_VL_INHERIT;
>   
> -	t = prctl(PR_SVE_SET_VL, vl | flags);
> +	t = prctl(set_ctl, vl | flags);
>   	if (t < 0) {
>   		fprintf(stderr, "%s: PR_SVE_SET_VL: %s\n",
>   			program_name, strerror(errno));
>   		goto error;
>   	}
>   
> -	t = prctl(PR_SVE_GET_VL);
> +	t = prctl(get_ctl);
>   	if (t == -1) {
>   		fprintf(stderr, "%s: PR_SVE_GET_VL: %s\n",
>   			program_name, strerror(errno));
> 

With the above comment addressed or explained:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
