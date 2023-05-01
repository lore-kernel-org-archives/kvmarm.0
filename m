Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C2720F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682944880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5GiG3wgCtX7mYiiVucX+fm0QBMXAYWeAETD8YBMKgWA=;
	b=COiumSTyyCSavZtVtCpNtNA3WNPfV7QOSiM5BVZE+W/opID19v6oL206A4a9FEL5k4oLjE
	8yqt+x3Y3jQ6YyunTvNmD3/I7xuaciNLpwPU9awd1orntbIaFRHgd8nR5hmdlJ4jJbWzAG
	Pnc2hB49/NJKnqfWXWRJqeqo3ONV8QA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-Si8kIZfQNN67GyBo-jM1QA-1; Mon, 01 May 2023 08:41:18 -0400
X-MC-Unique: Si8kIZfQNN67GyBo-jM1QA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1a6963bbb3dso2715905ad.0
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682944877; x=1685536877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5GiG3wgCtX7mYiiVucX+fm0QBMXAYWeAETD8YBMKgWA=;
        b=X5EsxN88LpTwKZaNxfh01npT5+Ag0S1l4H/bcvOZl3pz9sJCwavRoxsfzvm0CPUXHs
         g0v1NqKYMOgy/Is+y4z1RanlGcspb6py6pOe3XgXXMgBLQgYUv4A02HVNZYr5cofKwqw
         T2Lo/He34/5JiSb06VinfypPWRrjWdoB4l9gAugrqiiWY5BauOzf6CM6yCzjAvfCiUw2
         WQ/1a3pZBcQXBIoO3nyeJmcdJDCKZTSizsh+2pP0PSYrgre4emKMqIudPLeNJeRmXnRr
         MT4cemAHEEdH4Dv6u1f2LHvzFKxyMRPD4jUVS+q4Yea3WhNZh+6k03EPpGjFjixoYe3V
         /pwA==
X-Gm-Message-State: AC+VfDxMTU56dUL2ZfD4OyiQJWPG8MB7pzN4Z03tcLI46Po1ikJiMuIJ
	x4sENFpD+Be1DLuEuH5GI4cZdF9B/FXFp4qbxA+QQiJ0NuR/L+7n/E77CeWiiDJXPKh/aEVsToD
	mtA94PzPGmmukU6Pd
X-Received: by 2002:a17:902:e552:b0:19e:94ff:6780 with SMTP id n18-20020a170902e55200b0019e94ff6780mr16850184plf.6.1682944877719;
        Mon, 01 May 2023 05:41:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ40lpkbv20+infGM250AeSLajOiHyKpZ5m9hTq4ni8edFaK8Bivm1le2WH1iZrohAhApnCSsw==
X-Received: by 2002:a17:902:e552:b0:19e:94ff:6780 with SMTP id n18-20020a170902e55200b0019e94ff6780mr16850167plf.6.1682944877431;
        Mon, 01 May 2023 05:41:17 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bh7-20020a170902a98700b001a19cf1b37esm17834548plb.40.2023.05.01.05.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:41:17 -0700 (PDT)
Message-ID: <ca91fd53-1b35-4f60-2ca0-68a75c21fbb8@redhat.com>
Date: Mon, 1 May 2023 20:41:13 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 01/29] lib: Move acpi header and
 implementation to lib
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-2-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-2-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:03, Nikos Nikoleris wrote:
> Move acpi.h to lib to make it available for other architectures.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   x86/Makefile.common  | 2 +-
>   lib/x86/asm/setup.h  | 2 +-
>   lib/{x86 => }/acpi.h | 4 ++--
>   lib/{x86 => }/acpi.c | 0
>   x86/s3.c             | 2 +-
>   x86/vmexit.c         | 2 +-
>   6 files changed, 6 insertions(+), 6 deletions(-)
>   rename lib/{x86 => }/acpi.h (99%)
>   rename lib/{x86 => }/acpi.c (100%)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 365e199f..9f2bc93f 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -2,6 +2,7 @@
>   
>   all: directories test_cases
>   
> +cflatobjs += lib/acpi.o
>   cflatobjs += lib/pci.o
>   cflatobjs += lib/pci-edu.o
>   cflatobjs += lib/alloc.o
> @@ -18,7 +19,6 @@ cflatobjs += lib/x86/apic.o
>   cflatobjs += lib/x86/atomic.o
>   cflatobjs += lib/x86/desc.o
>   cflatobjs += lib/x86/isr.o
> -cflatobjs += lib/x86/acpi.o
>   cflatobjs += lib/x86/stack.o
>   cflatobjs += lib/x86/fault_test.o
>   cflatobjs += lib/x86/delay.o
> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
> index 1f384274..458eac85 100644
> --- a/lib/x86/asm/setup.h
> +++ b/lib/x86/asm/setup.h
> @@ -4,7 +4,7 @@
>   unsigned long setup_tss(u8 *stacktop);
>   
>   #ifdef CONFIG_EFI
> -#include "x86/acpi.h"
> +#include "acpi.h"
>   #include "x86/apic.h"
>   #include "x86/processor.h"
>   #include "x86/smp.h"
> diff --git a/lib/x86/acpi.h b/lib/acpi.h
> similarity index 99%
> rename from lib/x86/acpi.h
> rename to lib/acpi.h
> index 67ba3899..1e89840c 100644
> --- a/lib/x86/acpi.h
> +++ b/lib/acpi.h
> @@ -1,5 +1,5 @@
> -#ifndef _X86_ACPI_H_
> -#define _X86_ACPI_H_
> +#ifndef _ACPI_H_
> +#define _ACPI_H_
>   
>   #include "libcflat.h"
>   
> diff --git a/lib/x86/acpi.c b/lib/acpi.c
> similarity index 100%
> rename from lib/x86/acpi.c
> rename to lib/acpi.c
> diff --git a/x86/s3.c b/x86/s3.c
> index 6e41d0c4..378d37ae 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -1,5 +1,5 @@
>   #include "libcflat.h"
> -#include "x86/acpi.h"
> +#include "acpi.h"
>   #include "asm/io.h"
>   
>   static u32* find_resume_vector_addr(void)
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 2e8866e1..9260accc 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -1,9 +1,9 @@
>   #include "libcflat.h"
> +#include "acpi.h"
>   #include "smp.h"
>   #include "pci.h"
>   #include "x86/vm.h"
>   #include "x86/desc.h"
> -#include "x86/acpi.h"
>   #include "x86/apic.h"
>   #include "x86/isr.h"
>   

-- 
Shaoqin

