Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12F9C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65CA4B18A;
	Tue,  8 Feb 2022 08:58:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8XH3O86KrlEK; Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 401024B18F;
	Tue,  8 Feb 2022 08:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16F6649EF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 18:45:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bsLAos1OZNRX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 18:45:42 -0500 (EST)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF5F049EE0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 18:45:42 -0500 (EST)
Received: by mail-io1-f41.google.com with SMTP id c188so19063999iof.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 15:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=+NtK+MtbClH0X1MQpNUl7kYgTKeiw8K+NzlTmVLxEXI=;
 b=XRKoi18G+9mwulJnEQ3gZIpKynRci7Mf24Un7f422FB0eEUFbAYtavNEkpyrdPhN0f
 a7rzu/0l89ECUvtizPXxOwIUWOrHFkFocqlL0+gwAMXc9YMWktraZKFIUKRZLdR15yR7
 9Gk5UmBEgU9bA1Zq6cKxJj7i2zL3emxV2QwQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+NtK+MtbClH0X1MQpNUl7kYgTKeiw8K+NzlTmVLxEXI=;
 b=IayXt1a/TfjlPA/tUNcqWBnlW54RTtIZQavzFyPkNF0xpA2sbzsbbXMxXsQEJrL+Yv
 eX35Ty/LVik9Nvswcnn6qOoc2X9HbVCOlsJIxCLOFQCG7eia+Fy4SlR7MX/pRv1hUuuG
 azZpGzI+XZYHw2Qoq3AUc68jMcaAiTx0CsyAmYxfWnFDihpI436doD1PmOCVWrT8Ncwu
 eA/wg72RxF/Ew8mtpFk7LOnkOSQpzfKCheFwjV/v4cqidGNOWYAypQyGMgzIaCUSRfwQ
 v9hkZtzJrH4lChGwsZPlO7DUtoe4Kv1k7OrLYGtBykbMtYb9GS85AWoTIXduiQY/MqCr
 bmeA==
X-Gm-Message-State: AOAM5325M7VH6YAjexWFC4jP0w3h5LzeyL+UDAA6/YjhWVUOr3wZoYvo
 TU2V7x8LQDdIQGRsk/ZbTebhMA==
X-Google-Smtp-Source: ABdhPJzpO1bKNmrLxG0itop7T1/GKIIEgHvPBDjKVCWthMAzwB529RsjYK96DPnNd3NQWFl82bLZSQ==
X-Received: by 2002:a05:6602:483:: with SMTP id y3mr897165iov.0.1644277542223; 
 Mon, 07 Feb 2022 15:45:42 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id z23sm6764095iol.11.2022.02.07.15.45.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 15:45:41 -0800 (PST)
Subject: Re: [PATCH v11 04/40] kselftest/arm64: Remove local ARRAY_SIZE()
 definitions
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-5-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3d009772-ae57-a617-c871-f8ce1e33852d@linuxfoundation.org>
Date: Mon, 7 Feb 2022 16:45:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-5-broonie@kernel.org>
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
> An ARRAY_SIZE() has been added to kselftest.h so remove the local versions
> in some of the arm64 selftests.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/abi/syscall-abi.c | 1 -
>   tools/testing/selftests/arm64/fp/sve-ptrace.c   | 2 --
>   2 files changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/arm64/abi/syscall-abi.c b/tools/testing/selftests/arm64/abi/syscall-abi.c
> index d8eeeafb50dc..1e13b7523918 100644
> --- a/tools/testing/selftests/arm64/abi/syscall-abi.c
> +++ b/tools/testing/selftests/arm64/abi/syscall-abi.c
> @@ -18,7 +18,6 @@
>   
>   #include "../../kselftest.h"
>   
> -#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
>   #define NUM_VL ((SVE_VQ_MAX - SVE_VQ_MIN) + 1)
>   
>   extern void do_syscall(int sve_vl);
> diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
> index a3c1e67441f9..4bd333768cc4 100644
> --- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
> +++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
> @@ -21,8 +21,6 @@
>   
>   #include "../../kselftest.h"
>   
> -#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
> -
>   /* <linux/elf.h> and <sys/auxv.h> don't like each other, so: */
>   #ifndef NT_ARM_SVE
>   #define NT_ARM_SVE 0x405
> 

Thank you for cleaning this up.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
