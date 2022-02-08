Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D16C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 13:58:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9456D4B1BC;
	Tue,  8 Feb 2022 08:58:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zr9XSJBv9MXM; Tue,  8 Feb 2022 08:58:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6A64B1BF;
	Tue,  8 Feb 2022 08:58:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A64A40658
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:40:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P3Zm5MxtDFNe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 19:40:11 -0500 (EST)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
 [209.85.166.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E50E749EF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 19:40:10 -0500 (EST)
Received: by mail-io1-f42.google.com with SMTP id i62so19220805ioa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Feb 2022 16:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=DXeBvPGPhYY+G0mgsEODvq+5edCNWHsu13flglIZ8UM=;
 b=PouLRfqDZfaw1BrQsKzh+xn99PLlR1bC33CV3R7yMYhNxvRWiYU/etVWr0UHoioj0L
 6g/cfYNtG27eRKW9sUplUKo4Ixiz0JVr1GVnaNCS4RbPY5IVon3GpPzQ36L4NjTu6tOL
 WCDDTQKmh7tBNLSGVFY4SqUv7dN6QprlpBePQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DXeBvPGPhYY+G0mgsEODvq+5edCNWHsu13flglIZ8UM=;
 b=bfv9ig64wMg5wHytGT8M05xdmhmOah/X8n0xw3w9IIem9OAeo63rkASRoSBSRgvs4b
 RiE+OHM4bUgtR0DPu2mzmczWn8X2qdnUlsoTEEK4apGkxaYkzwcXsimlwDQ3T9EAFbsB
 QGCK8d2a8Z7EUseNvu7ycFtvku04P8FygdiBbjjTnXCb56rj0L1DlZs9KxirpzDfIycw
 pdS3s/WJDWAnDFvjjxIPZi6qLQs2AT6/gBd/aZBHjAPDnS6XoHHdJnZKJf9OiYRnhDvN
 QkKxKwKFjnRblldcHfrDOpVe6sAT5O6bGnBmHCh06SSve14cru+qG3TN9tp5cb9B09YX
 blbA==
X-Gm-Message-State: AOAM530/b4tEpkaV+jrpXe4wn9J4UpIbg/4tca272Rt7kWO3hSUS3l4F
 6uOYxVlKbxEtfyQuVp6veOgXHQ==
X-Google-Smtp-Source: ABdhPJzeX0vLAAWRHPBAbA5cgmSlTkcN8+zoFIZE6KO/H/cq6RdFUbzERhuo/trd9mdX5FzHSG3mrw==
X-Received: by 2002:a05:6638:14cb:: with SMTP id
 l11mr1058327jak.292.1644280810350; 
 Mon, 07 Feb 2022 16:40:10 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id m12sm7043930iow.54.2022.02.07.16.40.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Feb 2022 16:40:09 -0800 (PST)
Subject: Re: [PATCH v11 34/40] kselftest/arm64: sme: Provide streaming mode
 SVE stress test
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-35-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3b173e0e-7651-b820-26c4-37d1cbe94224@linuxfoundation.org>
Date: Mon, 7 Feb 2022 17:40:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207152109.197566-35-broonie@kernel.org>
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
> One of the features of SME is the addition of streaming mode, in which we
> have access to a set of streaming mode SVE registers at the SME vector
> length. Since these are accessed using the SVE instructions let's reuse
> the existing SVE stress test for testing with a compile time option for
> controlling the few small differences needed:
> 
>   - Enter streaming mode immediately on starting the program.
>   - In streaming mode FFR is removed so skip reading and writing FFR.
> 
> In order to avoid requiring a cutting edge toolchain with SME support
> use the op/CR form for specifying SVCR.

A few words or pointer to op/CR form would help as education for
people that aren't familiar with the form (self included).

> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/fp/.gitignore  |  1 +
>   tools/testing/selftests/arm64/fp/Makefile    |  3 +
>   tools/testing/selftests/arm64/fp/ssve-stress | 59 ++++++++++++++++++++
>   tools/testing/selftests/arm64/fp/sve-test.S  | 20 +++++++
>   4 files changed, 83 insertions(+)
>   create mode 100644 tools/testing/selftests/arm64/fp/ssve-stress
> 
> diff --git a/tools/testing/selftests/arm64/fp/.gitignore b/tools/testing/selftests/arm64/fp/.gitignore
> index 6e9a610c5e5d..5729a5b1adfc 100644
> --- a/tools/testing/selftests/arm64/fp/.gitignore
> +++ b/tools/testing/selftests/arm64/fp/.gitignore
> @@ -5,5 +5,6 @@ rdvl-sve
>   sve-probe-vls
>   sve-ptrace
>   sve-test
> +ssve-test
>   vec-syscfg
>   vlset
> diff --git a/tools/testing/selftests/arm64/fp/Makefile b/tools/testing/selftests/arm64/fp/Makefile
> index a224fff8082b..e6643c9b0474 100644
> --- a/tools/testing/selftests/arm64/fp/Makefile
> +++ b/tools/testing/selftests/arm64/fp/Makefile
> @@ -5,6 +5,7 @@ TEST_GEN_PROGS := sve-ptrace sve-probe-vls vec-syscfg
>   TEST_PROGS_EXTENDED := fp-pidbench fpsimd-test fpsimd-stress \
>   	rdvl-sme rdvl-sve \
>   	sve-test sve-stress \
> +	ssve-test ssve-stress \
>   	vlset
>   
>   all: $(TEST_GEN_PROGS) $(TEST_PROGS_EXTENDED)
> @@ -19,6 +20,8 @@ sve-ptrace: sve-ptrace.o
>   sve-probe-vls: sve-probe-vls.o rdvl.o
>   sve-test: sve-test.o asm-utils.o
>   	$(CC) -nostdlib $^ -o $@
> +ssve-test: sve-test.S asm-utils.o
> +	$(CC) -DSSVE -nostdlib $^ -o $@
>   vec-syscfg: vec-syscfg.o rdvl.o
>   vlset: vlset.o
>   
> diff --git a/tools/testing/selftests/arm64/fp/ssve-stress b/tools/testing/selftests/arm64/fp/ssve-stress
> new file mode 100644
> index 000000000000..e2bd2cc184ad
> --- /dev/null
> +++ b/tools/testing/selftests/arm64/fp/ssve-stress
> @@ -0,0 +1,59 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright (C) 2015-2019 ARM Limited.
> +# Original author: Dave Martin <Dave.Martin@arm.com>
> +
> +set -ue
> +
> +NR_CPUS=`nproc`
> +
> +pids=
> +logs=
> +
> +cleanup () {
> +	trap - INT TERM CHLD
> +	set +e
> +
> +	if [ -n "$pids" ]; then
> +		kill $pids
> +		wait $pids
> +		pids=
> +	fi
> +
> +	if [ -n "$logs" ]; then
> +		cat $logs
> +		rm $logs
> +		logs=
> +	fi
> +}
> +
> +interrupt () {
> +	cleanup
> +	exit 0
> +}
> +
> +child_died () {
> +	cleanup
> +	exit 1

Is this a failure condition?

> +}
> +

With the comments explained or addressed:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
