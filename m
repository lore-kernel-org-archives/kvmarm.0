Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270B5C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB91A4B150;
	Tue,  8 Feb 2022 08:58:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QHMVWk0ProMZ; Tue,  8 Feb 2022 08:58:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 956AE4B1AD;
	Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4CB4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:10:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xOC4hnRZne3U for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 19:10:37 -0500 (EST)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 855F449F3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:10:37 -0500 (EST)
Received: by mail-io1-f41.google.com with SMTP id 9so19184515iou.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 16:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=SrBqlkGqEVLCuNbr1CjFlCILvwaRUMqCDPVo0Ntr/o0=;
 b=M8Pw3UzPapDdWi2l1ctXXBMaMWbnfhNRRe8y/IVeu6nwyHObA4srpBSdptXAYPntEJ
 fr2XvaAgjjHmiUBdVR7Qn+T+t4y+/CdVH3jf+W1l9jo48cqHi+jRiWRJYv0OntDu5W0r
 myAW1P8pWHobosSqZtMLqjhIL05ytrF0BnjCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=SrBqlkGqEVLCuNbr1CjFlCILvwaRUMqCDPVo0Ntr/o0=;
 b=jb+5DZNz6f6e1ReDsGYkLbLlvofEuqLO/uBWwMDDQXLDCk/jnu/Mu+uskQyX5QIEfF
 HV6VaF+S6NgHFhsxMKLPvA3lmzS5nFkn2hDl0E+tOvxA3Qte5cDRxmIteMqGVogreMri
 +hMB3Bhg9tbrM3hR7ZE+paVI0rQ4CHlx+XGs1jL8nPSb+IjteOcNpY3EuQ4rXZIknIAB
 9buaMyxKLyrn15Z8F/hiXvagukfsXss3px+qFfC/Qof4Inldmz9poRd5cNqOPgf0jCM8
 UKETB/o7POQks3+GF9F+9ARiI3FGl6VIkLYhSI+S489iHW/918EoK3/ochXDGqmoz/Fu
 +lHw==
X-Gm-Message-State: AOAM533tHwsygZRfcZt797n/SMPqo9fTqVjstdV1Hpb6AXjnTJDBaJiV
 +CM1MR7ZZ7hQbrNTnt/SSvb/xQ==
X-Google-Smtp-Source: ABdhPJz96efCiEzcb2TCaOoSiUJ9kzp5Ms/xo65+4sdHjaY8FTOBmUmbwg4ZUlnUJMMPRZEDyXvyZQ==
X-Received: by 2002:a05:6638:328c:: with SMTP id
 f12mr972239jav.249.1644279036957; 
 Mon, 07 Feb 2022 16:10:36 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id l16sm3264042ilc.54.2022.02.07.16.10.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 16:10:36 -0800 (PST)
Subject: Re: [PATCH v11 06/40] arm64/sme: Provide ABI documentation for SME
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-7-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <49da0f58-7a20-e557-54c3-34bd7074f711@linuxfoundation.org>
Date: Mon, 7 Feb 2022 17:10:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-7-broonie@kernel.org>
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

Hi Mark,

On 2/7/22 8:20 AM, Mark Brown wrote:
> Provide ABI documentation for SME similar to that for SVE. Due to the very
> large overlap around streaming SVE mode in both implementation and
> interfaces documentation for streaming mode SVE is added to the SVE
> document rather than the SME one.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

A few typos and missing SPDX comments below.
> ---
>   Documentation/arm64/index.rst |   1 +
>   Documentation/arm64/sme.rst   | 432 ++++++++++++++++++++++++++++++++++
>   Documentation/arm64/sve.rst   |  70 +++++-
>   3 files changed, 493 insertions(+), 10 deletions(-)
>   create mode 100644 Documentation/arm64/sme.rst
> 
> diff --git a/Documentation/arm64/index.rst b/Documentation/arm64/index.rst
> index 4f840bac083e..ae21f8118830 100644
> --- a/Documentation/arm64/index.rst
> +++ b/Documentation/arm64/index.rst
> @@ -21,6 +21,7 @@ ARM64 Architecture
>       perf
>       pointer-authentication
>       silicon-errata
> +    sme
>       sve
>       tagged-address-abi
>       tagged-pointers
> diff --git a/Documentation/arm64/sme.rst b/Documentation/arm64/sme.rst
> new file mode 100644
> index 000000000000..15df3157c592
> --- /dev/null
> +++ b/Documentation/arm64/sme.rst
> @@ -0,0 +1,432 @@

Missing SPDX here?

> +===================================================
> +Scalable Matrix Extension support for AArch64 Linux
> +===================================================
> +


> +
> +When returning from a signal handler:
> +
> +* If there is no za_context record in the signal frame, or if the record is
> +  present but contains no register data as desribed in the previous section,

described

> +  then ZA is disabled.
> +

> +	PR_SME_SET_VL_ONEXEC
> +
> +	    Defer the requested vector length change until the next execve()
> +	    performed by this thread.
> +
> +	    The effect is equivalent to implicit exceution of the following

execution

> +	    call immediately after the next execve() (if any) by the thread:
> +

> +
> +[3] Documentation/arm64/cpu-feature-registers.rst
> +
> +[4] ARM IHI0055C
> +    http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055c/IHI0055C_beta_aapcs64.pdf
> +    http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
> +    Procedure Call Standard for the ARM 64-bit Architecture (AArch64)
> diff --git a/Documentation/arm64/sve.rst b/Documentation/arm64/sve.rst
> index 9d9a4de5bc34..93c2c2990584 100644
> --- a/Documentation/arm64/sve.rst
> +++ b/Documentation/arm64/sve.rst
> @@ -7,7 +7,9 @@ Author: Dave Martin <Dave.Martin@arm.com>
>   Date:   4 August 2017
>   

Missing SPDX perhaps?

>   This document outlines briefly the interface provided to userspace by Linux in
> -order to support use of the ARM Scalable Vector Extension (SVE).
> +order to support use of the ARM Scalable Vector Extension (SVE), including
> +interactions with Streaming SVE mode added by the Scalable Matrix Extension
> +(SME).
>   

Looks good otherwise.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
