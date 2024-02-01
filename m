Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127A5208DD
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 08:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776173; cv=none; b=iB2NTnWwMa6NaiRXFex8E3UUfUBlrpNTC+FYLEc6vgqlVHvoEFinypZNojufJGe++M3hDqPdEknixA2JpXKADNzhLTfAtrvInuOHeXGOA6z2IW2QNw+OaRtOybRkwI9DWD32ChTomqLpzzHpoeimLJy+fHJ+C4MeeTbsoNB8a/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776173; c=relaxed/simple;
	bh=CiAbHUFATzrYRcqWkCE60XxX0mo7+aaPHgsV9bAEClA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmSM9I4aPpDuWxW84m8Gp6v5pb/c24g94bGo8xV+BRSaIN4rDzl9LY/FVWkIwyJYQ1Nkdc2cIKWRV9Xu0/vaWnN/uiTAzy4W8bNddrq707L0oUI7S+Wp1SqjT4pJFdlRTmWyevB0iPQbeCJCbm37pkgoUmFLrVjXH0EVvjDmhOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QhlpVT40; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhlpVT40"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776171;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmW2zyN5jXyC4AyMWYaUE5nqSrK+UeP5RxrZvT/F3Rk=;
	b=QhlpVT40Ji3oUu/9ovpPJcLOdH/CkIq/24miDjQI6ZE85ufH4wFsEpgTjZREVyca+1/H5T
	6RPNuHnXyX/6ZiPhYALApHapNt5MQ6qcnM1XKOWUtAxiff1p9BD9bt8AFMAV0Tij9EO3zN
	C2NtCQIlQwOd9z84rEA0dDbgQcJFiQg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-l2NZWS__PnqvfUnDBQWGgA-1; Thu, 01 Feb 2024 03:29:29 -0500
X-MC-Unique: l2NZWS__PnqvfUnDBQWGgA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40d62d3ae0cso3660705e9.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 00:29:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776167; x=1707380967;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmW2zyN5jXyC4AyMWYaUE5nqSrK+UeP5RxrZvT/F3Rk=;
        b=iPsVZJ226vemUw9Sxu7a5jwOHutX7isFanEyPyqNi9WHLM+7DasUhLt2VJRZHDNqba
         uBdH7vO0xyDGZA3eNWWBehEDX9qV3y1SqYAHcv25aI6wUofQbq1JDTToK5EDliJHdq5K
         FfuuHWiRGexM6hCYm1Tw0XAyzRFwMAS2apJ0kFKtBdCxjqmXEQzGyyxOJUQShxYJz+Xf
         t2XLIKiLwIRnFyBBrAPpiHoEzS6a6PLWc7u7J2dhOLSS9j9ZAW6zFQ+Qt0zy6OjMZvzn
         g9gfB6XwZ+vKslLXJO4+MbBNI1nCWp+tKe/5t7LywaeAVsElhaavJJ3EoyUVtG20I0yu
         i5hQ==
X-Gm-Message-State: AOJu0YwSU/rVz5g9o2K/JC8kO7zzGhHiYCX3hDE5YtVsglCEd68CbhhA
	bzdfn/1886TTVs25QlBnnbbvxPZ39RG3j45eLUIdiENIS/aAaDyWHQHhdRheC7n/IIZ7CNfqykw
	uswEYmjFE/Hh2zEC6mqymthVTFgpnwwNpxDCVEWmcXPqOpqx/8Nz7hA==
X-Received: by 2002:a05:600c:a52:b0:40e:ce9e:b543 with SMTP id c18-20020a05600c0a5200b0040ece9eb543mr3179665wmq.41.1706776167044;
        Thu, 01 Feb 2024 00:29:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHG9bnaWIWqqChKJKH+8bFPVEhs3XmbtnTafAVpyrfzeI4rjaWi2rcT4xfeb8Iq91GMwJ1hVg==
X-Received: by 2002:a05:600c:a52:b0:40e:ce9e:b543 with SMTP id c18-20020a05600c0a5200b0040ece9eb543mr3179657wmq.41.1706776166747;
        Thu, 01 Feb 2024 00:29:26 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWs4ivuRfh/fL0eD2SSxqCyS0TAPyLaai3I7GWzqXMhlcsmAvYJc4u4DSLEetDRHqUlzH4ipl2oPlHpTUSyFk7Fl/rz209k4JkMIebQGA3sRRgAGnd+LzhXsO+PjbHBulmSu2gM3ENR1CjT/UqJZI5jpCHlGkCnqCPjElgdyYaVB7kszKpjVRAR6rvDXR9hC1hV0tIoby2SczJJWtj97YfBtPJtVubduwogCH75+O1HPcT4FBBQcRWn6GwwOfPbCyNxMEVtaYmvHw1JtKcYkaNU65J05hE5kshmUAO/JQ3qAqOH8CfzvL0=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a1c790c000000b0040fba120c0bsm446368wme.0.2024.02.01.00.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:24 -0800 (PST)
Message-ID: <6810c7a7-2494-4bb3-9e74-98010f4d8d4a@redhat.com>
Date: Thu, 1 Feb 2024 09:29:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 03/24] arm/arm64: Move cpumask.h to
 common lib
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-29-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-29-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/24 15:23, Andrew Jones wrote:
> RISC-V will also make use of cpumask.h, so move it to the arch-common
> directory.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/arm/asm/gic-v2.h        | 2 +-
>  lib/arm/asm/gic-v3.h        | 2 +-
>  lib/arm/asm/gic.h           | 2 +-
>  lib/arm/asm/smp.h           | 2 +-
>  lib/arm/mmu.c               | 2 +-
>  lib/arm/smp.c               | 2 +-
>  lib/arm64/asm/cpumask.h     | 1 -
>  lib/{arm/asm => }/cpumask.h | 9 ++++-----
>  8 files changed, 10 insertions(+), 12 deletions(-)
>  delete mode 100644 lib/arm64/asm/cpumask.h
>  rename lib/{arm/asm => }/cpumask.h (94%)
>
> diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
> index 1fcfd43c8075..ff11afb15d30 100644
> --- a/lib/arm/asm/gic-v2.h
> +++ b/lib/arm/asm/gic-v2.h
> @@ -18,7 +18,7 @@
>  #define GICC_IAR_INT_ID_MASK		0x3ff
>  
>  #ifndef __ASSEMBLY__
> -#include <asm/cpumask.h>
> +#include <cpumask.h>
>  
>  struct gicv2_data {
>  	void *dist_base;
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index b4ce130e56c6..a1cc62a298b8 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -67,10 +67,10 @@
>  #include <asm/arch_gicv3.h>
>  
>  #ifndef __ASSEMBLY__
> +#include <cpumask.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
>  #include <asm/delay.h>
> -#include <asm/cpumask.h>
>  #include <asm/smp.h>
>  #include <asm/io.h>
>  
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 189840014b02..dc8cc18c0fbd 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -47,7 +47,7 @@
>  #define SPI(irq)			((irq) + GIC_FIRST_SPI)
>  
>  #ifndef __ASSEMBLY__
> -#include <asm/cpumask.h>
> +#include <cpumask.h>
>  
>  enum gic_irq_state {
>  	GIC_IRQ_STATE_INACTIVE,
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index dee4c1a883e7..bb3e71a55e8c 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -5,8 +5,8 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <cpumask.h>
>  #include <asm/thread_info.h>
> -#include <asm/cpumask.h>
>  
>  #define smp_processor_id()		(current_thread_info()->cpu)
>  
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 2f4ec815a35d..b16517a3200d 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -5,9 +5,9 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <cpumask.h>
>  #include <asm/setup.h>
>  #include <asm/thread_info.h>
> -#include <asm/cpumask.h>
>  #include <asm/mmu.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index 1d470d1aab45..78fc1656cefa 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -7,9 +7,9 @@
>   */
>  #include <libcflat.h>
>  #include <auxinfo.h>
> +#include <cpumask.h>
>  #include <asm/thread_info.h>
>  #include <asm/spinlock.h>
> -#include <asm/cpumask.h>
>  #include <asm/barrier.h>
>  #include <asm/mmu.h>
>  #include <asm/psci.h>
> diff --git a/lib/arm64/asm/cpumask.h b/lib/arm64/asm/cpumask.h
> deleted file mode 100644
> index d1421e7abe31..000000000000
> --- a/lib/arm64/asm/cpumask.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include "../../arm/asm/cpumask.h"
> diff --git a/lib/arm/asm/cpumask.h b/lib/cpumask.h
> similarity index 94%
> rename from lib/arm/asm/cpumask.h
> rename to lib/cpumask.h
> index 3fa57bfb17c6..d30e14cda09e 100644
> --- a/lib/arm/asm/cpumask.h
> +++ b/lib/cpumask.h
> @@ -1,12 +1,11 @@
> -#ifndef _ASMARM_CPUMASK_H_
> -#define _ASMARM_CPUMASK_H_
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * Simple cpumask implementation
>   *
>   * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> - *
> - * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#ifndef _CPUMASK_H_
> +#define _CPUMASK_H_
>  #include <asm/setup.h>
>  #include <bitops.h>
>  
> @@ -120,4 +119,4 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
>  			(cpu) < nr_cpus; 			\
>  			(cpu) = cpumask_next(cpu, mask))
>  
> -#endif /* _ASMARM_CPUMASK_H_ */
> +#endif /* _CPUMASK_H_ */

