Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8E0C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98D84B17C;
	Tue,  8 Feb 2022 08:58:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XTtRWFa-5qmT; Tue,  8 Feb 2022 08:58:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 050AB4B132;
	Tue,  8 Feb 2022 08:58:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F75E4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:24:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRcMoYLG7hxk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 19:24:29 -0500 (EST)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CD3D49F55
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:24:29 -0500 (EST)
Received: by mail-il1-f180.google.com with SMTP id e8so12557267ilm.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 16:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=Vgz3vJoxRCjSxOnu8bDTDSG6VAB8AKydsEfZW+RiuBU=;
 b=B5KTjIHd8JJqHtNAMC1PzjEXLhYAW2XGJzTUChMhTd6LR06BDZAjdj3VR8ZJl39Lhr
 UwjfvA8N+T9GscLNPUjTnG9su+HIUOkeeROhdU9c70mhjFhpbXH038YJob6suCbeGYtT
 C2cZOtAaQX3X8zHX7grA+riPzBbXH6x3G8Z+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Vgz3vJoxRCjSxOnu8bDTDSG6VAB8AKydsEfZW+RiuBU=;
 b=Yiey6PkuQvuJBY/hFWjzWhBXWE4FuwsRhLHLgFjZnXTYUSqni7lcw2GTUaCFj5ZAkK
 O/J3s7JF1AfULs0Lnq3IZyshYu/wvhRzgRTHbyJDd+nt9M4C4GB9LfDo+H8LON7iuLs7
 dVKE6nCI3koXyMmbdTREZoJBW9mVHrfez2Y+Q7K9RoZkJzHHqUpD+6pYAgsUfue+Qmij
 c6+Tge9Oi3969OzdQjaV1gNvlKQLro9g+rOPDSPk4KWJkDaocOxA4hS2eeauXlw7NCrV
 pRKEi47FeUiDrfOiU27ZhC4046FA5DKUTAalsdKhIW0Q7Ap5na2XNVuPGEz6E1Zsh5lP
 vaKw==
X-Gm-Message-State: AOAM532zHhud4IFomCzW/Md4/GkvnG6657K59Oj7WoLLYyj724VW8NBp
 rrMqT0mJDHeYKZ0iDfEqYN9hrw==
X-Google-Smtp-Source: ABdhPJxhj/ObwJzAC/vSnKWt7hzqF0me2g8ZGst3fT1kLBYK5mtfxm3nxbacAfWRZVou8UtBvqjbNg==
X-Received: by 2002:a92:5208:: with SMTP id g8mr963001ilb.310.1644279868967;
 Mon, 07 Feb 2022 16:24:28 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id t2sm2986140ilp.49.2022.02.07.16.24.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 16:24:28 -0800 (PST)
Subject: Re: [PATCH v11 33/40] kselftest/arm64: Extend vector configuration
 API tests to cover SME
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-34-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <32b86e20-8a4e-42ac-f5d9-188f1d80e412@linuxfoundation.org>
Date: Mon, 7 Feb 2022 17:24:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-34-broonie@kernel.org>
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
> Provide RDVL helpers for SME and extend the main vector configuration tests
> to cover SME.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/fp/.gitignore   |  1 +
>   tools/testing/selftests/arm64/fp/Makefile     |  3 ++-
>   tools/testing/selftests/arm64/fp/rdvl-sme.c   | 14 ++++++++++++++
>   tools/testing/selftests/arm64/fp/rdvl.S       | 10 ++++++++++
>   tools/testing/selftests/arm64/fp/rdvl.h       |  1 +
>   tools/testing/selftests/arm64/fp/vec-syscfg.c | 10 ++++++++++
>   6 files changed, 38 insertions(+), 1 deletion(-)
>   create mode 100644 tools/testing/selftests/arm64/fp/rdvl-sme.c
> 
> diff --git a/tools/testing/selftests/arm64/fp/.gitignore b/tools/testing/selftests/arm64/fp/.gitignore
> index c50d86331ed2..6e9a610c5e5d 100644
> --- a/tools/testing/selftests/arm64/fp/.gitignore
> +++ b/tools/testing/selftests/arm64/fp/.gitignore
> @@ -1,5 +1,6 @@
>   fp-pidbench
>   fpsimd-test
> +rdvl-sme
>   rdvl-sve
>   sve-probe-vls
>   sve-ptrace
> diff --git a/tools/testing/selftests/arm64/fp/Makefile b/tools/testing/selftests/arm64/fp/Makefile
> index 95f0b877a060..a224fff8082b 100644
> --- a/tools/testing/selftests/arm64/fp/Makefile
> +++ b/tools/testing/selftests/arm64/fp/Makefile
> @@ -3,7 +3,7 @@
>   CFLAGS += -I../../../../../usr/include/
>   TEST_GEN_PROGS := sve-ptrace sve-probe-vls vec-syscfg
>   TEST_PROGS_EXTENDED := fp-pidbench fpsimd-test fpsimd-stress \
> -	rdvl-sve \
> +	rdvl-sme rdvl-sve \
>   	sve-test sve-stress \
>   	vlset
>   
> @@ -13,6 +13,7 @@ fp-pidbench: fp-pidbench.S asm-utils.o
>   	$(CC) -nostdlib $^ -o $@
>   fpsimd-test: fpsimd-test.o asm-utils.o
>   	$(CC) -nostdlib $^ -o $@
> +rdvl-sme: rdvl-sme.o rdvl.o
>   rdvl-sve: rdvl-sve.o rdvl.o
>   sve-ptrace: sve-ptrace.o
>   sve-probe-vls: sve-probe-vls.o rdvl.o
> diff --git a/tools/testing/selftests/arm64/fp/rdvl-sme.c b/tools/testing/selftests/arm64/fp/rdvl-sme.c
> new file mode 100644
> index 000000000000..49b0b2e08bac
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/fp/rdvl-sme.c
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <stdio.h>
> +
> +#include "rdvl.h"
> +
> +int main(void)
> +{
> +	int vl = rdvl_sme();
> +
> +	printf("%d\n", vl);
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/arm64/fp/rdvl.S b/tools/testing/selftests/arm64/fp/rdvl.S
> index c916c1c9defd..20dc29996dc6 100644
> --- a/tools/testing/selftests/arm64/fp/rdvl.S
> +++ b/tools/testing/selftests/arm64/fp/rdvl.S
> @@ -1,6 +1,8 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   // Copyright (C) 2021 ARM Limited.
>   
> +#include "sme-inst.h"
> +
>   .arch_extension sve
>   
>   .globl rdvl_sve
> @@ -8,3 +10,11 @@ rdvl_sve:
>   	hint	34			// BTI C
>   	rdvl	x0, #1
>   	ret
> +
> +.globl rdvl_sme
> +rdvl_sme:
> +	hint	34			// BTI C
> +
> +	rdsvl	0, 1
> +
> +	ret
> diff --git a/tools/testing/selftests/arm64/fp/rdvl.h b/tools/testing/selftests/arm64/fp/rdvl.h
> index 7c9d953fc9e7..5d323679fbc9 100644
> --- a/tools/testing/selftests/arm64/fp/rdvl.h
> +++ b/tools/testing/selftests/arm64/fp/rdvl.h
> @@ -3,6 +3,7 @@
>   #ifndef RDVL_H
>   #define RDVL_H
>   
> +int rdvl_sme(void);
>   int rdvl_sve(void);
>   
>   #endif
> diff --git a/tools/testing/selftests/arm64/fp/vec-syscfg.c b/tools/testing/selftests/arm64/fp/vec-syscfg.c
> index c90658811a83..9bcfcdc34ee9 100644
> --- a/tools/testing/selftests/arm64/fp/vec-syscfg.c
> +++ b/tools/testing/selftests/arm64/fp/vec-syscfg.c
> @@ -51,6 +51,16 @@ static struct vec_data vec_data[] = {
>   		.prctl_set = PR_SVE_SET_VL,
>   		.default_vl_file = "/proc/sys/abi/sve_default_vector_length",
>   	},
> +	{
> +		.name = "SME",
> +		.hwcap_type = AT_HWCAP2,
> +		.hwcap = HWCAP2_SME,
> +		.rdvl = rdvl_sme,
> +		.rdvl_binary = "./rdvl-sme",
> +		.prctl_get = PR_SME_GET_VL,
> +		.prctl_set = PR_SME_SET_VL,
> +		.default_vl_file = "/proc/sys/abi/sme_default_vector_length",
> +	},
>   };
>   
>   static int stdio_read_integer(FILE *f, const char *what, int *val)
> 

Looks good to me.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
