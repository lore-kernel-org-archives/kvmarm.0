Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46FE3385A3
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764262193; cv=none; b=JnPcQb5cRbunZPa4Ga8jCDPpCJ2lyzAyHeIBOSmB5RgAH8Q7043OgVU6uZWDdTfObgWPQ32GyGjr1/NzHG9B9c1HFY9bAdpIGM83DnJBZ5bVwi5bkkGMNUWkVry5T3vORa2RoEj7l5W7jY+pW/9G8jgEn1vBztmTp6co4q7L5Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764262193; c=relaxed/simple;
	bh=2GkoMiW1aOXux7Oy2sMmlIrHWqkBrcbNDpdWRYEyKO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUzF3KtSiwquy9Vw5E7mvaxXW0Hs6cjBSaRhPOzhPjPhQzNhbLgH0pujGZ/e4FLXXasR2a+ama/xmo02CIBjIr+y7XKfO5whZHNDpFFli/xnUIO7fWwNa/+Iw/4CvYJifWgp3gFmGVwDNWJsaBAU4pHPvM17Fs+P3ymorUWtTMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i6JvHI56; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i6JvHI56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764262190;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7Uz86MWYfQL+y6cfsCHemHYwZCFKIe5X+o1N7gMtLs=;
	b=i6JvHI56yaVFxvBcBf/jv66Ez5ULlJBCjVHXK+TBJTsWo93OFBi9BOsBxgCUnnyu6Vnl5K
	8IuzGdvv/R43fhReInHDPydNM8B7zbvqLz/dMLs36xmbZNY0i6Jt5//7Ij+vZdLMQuNx9B
	sjZqo+bxn8+pQDEcPP/V7wV5RRXMJtc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-4PivukzUPL2ga7UzA6fZ8A-1; Thu, 27 Nov 2025 11:49:49 -0500
X-MC-Unique: 4PivukzUPL2ga7UzA6fZ8A-1
X-Mimecast-MFC-AGG-ID: 4PivukzUPL2ga7UzA6fZ8A_1764262189
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8a1c15daa69so267864585a.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 08:49:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764262188; x=1764866988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7Uz86MWYfQL+y6cfsCHemHYwZCFKIe5X+o1N7gMtLs=;
        b=FREbP7UJGMNrYFlpCWOBhKeoFKXe7KTNhuVlhsRTiCtvn3bflvfVZ5K3YXiupttVq8
         QvChXLTNtTWs+DYDqaSirrBvnP1ep8gf64JXYBelifA6+vgaqlhj0Ta75syC5Of8GIkN
         ffbRS3fZwhDas7rl+7I5JdYVCrVj7dsUrN5gHD6rZR7N1hHnZyIIYQQi4/CcMs/IkCwv
         5n/lc73npahZSo208cvYWV0vUNzw8VGvMhUdErLa800Lmj0oagRvif3h7tnxj2E+m/a/
         1IbM+xoXX3rdM4GBqSl9b1X38H3asXie4iqnYeFT/+BQL3xRz7JQGKcifQfsMh4jCyux
         ugPw==
X-Forwarded-Encrypted: i=1; AJvYcCXm4PAevfq4ZkBTf0s96lk6h8bukn5t9dVCG+DBv0wMHh4F7KsqwAwd2GLv3Idi6/8NPr8WxXA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxKjW/sfcBm7j3lK/HjHYSErYHT12SyW1LUib9Pp6nut8IgsMq
	VwRzpk/eTS0d4F57G7zhAF1Mgbp/SYdDN0+FdxEALK8fgFTDGJyD+9wTk64WEGfyhGaoTzuHw3E
	mXJ/vgYKP1FLo0cou4SP9HWZ9htqNM6Aj2sevZXUaPRO6Fv9UczxGW8CrjA==
X-Gm-Gg: ASbGnctv5QSJXKpThVKU3ATxuJrejWrN62zPK+MRguOatdgEjHGxhKQvqay/6dk/VG2
	ZQM2m9tREXrjYhGdvX++DvXmICFNP41PjmgP/5+oNkZYSJJNgr6ii0qcMk5LnakGJ5lvuaZbeSN
	7/0pNZUIwxXLVC98lvWZ0hRbmdNrpPndfXJ4QtWB0dJdvzySdrLN83fNcvK3huzVJrNmSvnRx0X
	Cb0c4DpDrF8Ej+lN6k1ayl4ZGXtbH2RwSjkkFzdrQps23ysWLJbtJc0pIS839J4OGGRsOTcDAcs
	FIj5P4Sf+wyWs1gjsR/HTHnVt0YC/G32iA1ZT9rRPD6fJ//fS3m5wyVPZZPQrVyJMVIy3He+GTL
	CNZqRmVlUu0FtmYV/iZgFFJ4okveoCKdodAzaaPibjyJHOSCOc5+PN4T16w==
X-Received: by 2002:a05:620a:25c7:b0:89e:67a9:fcf1 with SMTP id af79cd13be357-8b4ebdaea90mr1500116685a.52.1764262188696;
        Thu, 27 Nov 2025 08:49:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaTomno2Tlgqds4NSGAWNKA9Sj7QFcdWKkY4vTpNLJn+xX+6DRbAf650DtgDJ/AfspXBsVxA==
X-Received: by 2002:a05:620a:25c7:b0:89e:67a9:fcf1 with SMTP id af79cd13be357-8b4ebdaea90mr1500114285a.52.1764262188357;
        Thu, 27 Nov 2025 08:49:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b759esm137332485a.31.2025.11.27.08.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 08:49:47 -0800 (PST)
Message-ID: <92f27f98-e4c9-41d9-badc-635e5ba40552@redhat.com>
Date: Thu, 27 Nov 2025 17:49:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 02/10] arm64: efi: initialise SCTLR_ELx
 fully
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-3-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-3-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: erHl28DSETjYfv0wD634BW4yIBSwgOzfbI6gA4TAZUk_1764262189
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> Don't rely on the value of SCTLR_ELx when booting via EFI.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  lib/arm/asm/setup.h   |  6 ++++++
>  lib/arm/setup.c       |  3 +++
>  lib/arm64/processor.c | 12 ++++++++++++
>  3 files changed, 21 insertions(+)
>
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 9f8ef82e..4e60d552 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -28,6 +28,12 @@ void setup(const void *fdt, phys_addr_t freemem_start);
>  
>  #include <efi.h>
>  
> +#ifdef __aarch64__
> +void setup_efi_sctlr(void);
> +#else
> +static inline void setup_efi_sctlr(void) {}
> +#endif
> +
>  efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>  
>  #endif
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 67b5db07..0aaa1d3a 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -349,6 +349,9 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  {
>  	efi_status_t status;
>  
> +
spurious line
> +	setup_efi_sctlr();
> +
>  	exceptions_init();
>  
>  	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index eb93fd7c..edc0ad87 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <asm/ptrace.h>
>  #include <asm/processor.h>
> +#include <asm/setup.h>
>  #include <asm/thread_info.h>
>  
>  static const char *vector_names[] = {
> @@ -271,3 +272,14 @@ bool __mmu_enabled(void)
>  {
>  	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
>  }
> +
> +#ifdef CONFIG_EFI
> +
> +void setup_efi_sctlr(void)
> +{
> +	// EFI exits boot services with SCTLR_ELx.M=1, so keep
> +	// the MMU enabled.
I don't really understand the comment, if MMU was enabled why are we
mandated to set M bit again?

Eric
> +	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
> +}
> +
> +#endif

