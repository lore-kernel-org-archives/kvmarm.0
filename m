Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1274D2DECC2
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263347; cv=none; b=cG15DXvOh3130g/5mpEwv5sc46z6IV63EAJ2YbP1wwdIVRFoPgr6FEhiv3y14w1t2+RVpO2uaWd/3VttKSY/jueaLObXaC0ymgKSa55mv9byWJU2tCsX6taw139c3c9kMZYmZSwCbVInbzhZFIlVm674KcA/O8cMrUgGkSOuoYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263347; c=relaxed/simple;
	bh=vBvIKRWfPaQXkjoG7SlBmbYLMxL8M3S+eVL65Atr1dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoQBqPTf6kR5rQoUx0LrfwIuloM0OB+gSEjnBvEcAJTahXz0hBgGCBxDT8EFhHevl/TTIsOAE+ixvFip3or7uo77tdXmhQ0J1xGgUMgu1eUiNl67XWlESWqRrXjqeekscTAF0jKMB89EvoD8pDpWeApM5NYcBF9WeWwR6ukMVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FY8Vi4Pw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FY8Vi4Pw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764263345;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAb16FdwyMSYNIxUJ299HViLFfqQavTjzCEBKiggKc8=;
	b=FY8Vi4PwNPHAU3q/Vzj/w41hAgmFFUsHYbfvbiOEd7pphq8L1eKg5ceWFt6Flmb2cpTNhB
	QFVZue2E96vxUw0Seub6Wsgxj8Ii34B6OX97dWHLgtnDlO9nPOWywW+jcI9ljyX1BQrsz+
	ls6/O0ldtZyNkYjpBynwfNoiz9N0R60=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-9Jw4J8bHPj-vSJN-usrIyQ-1; Thu, 27 Nov 2025 12:09:02 -0500
X-MC-Unique: 9Jw4J8bHPj-vSJN-usrIyQ-1
X-Mimecast-MFC-AGG-ID: 9Jw4J8bHPj-vSJN-usrIyQ_1764263342
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ed69f9ce96so29259411cf.3
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 09:09:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764263342; x=1764868142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAb16FdwyMSYNIxUJ299HViLFfqQavTjzCEBKiggKc8=;
        b=kLG7ZaZuiKFjpsX8FytftY78lEDkg0lcnslKs0ieeZx3ced6qCQbqY+Z4lcMWBaRsJ
         54B5DcRrQ8ZPLTKd13XwwcfeE+hAFCthtuOmi8byB0WvJ1wiagZ5tpFrdbQsIgwHwuY2
         NuyFomYd7fwOopsypiTucud3eVe6W2xf+A8ZDE2v21OPe0GzEFV6KEBBG95r4q6B+4Q4
         +VH4HR7ldlEMwQ6h7+9426R/RvPxio3LWaaqE2I2auouM0vpul2RD+hpuYLvG9ZsBWoW
         TemkM1fJXBjer9LXeSTBp7vt1gx+4t6y4WTIyJKVBEbYlQ/uLvuwki9VcdcXvrGvUPU9
         SEww==
X-Forwarded-Encrypted: i=1; AJvYcCX0ZgLID90jPQO1RtzK2af1Rs1XdldzKKwwQ+DjUKSRujaZaMS8+Th++Eae1gSO1l2CY729B10=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJsK7rqynWUWgnSu/gNm50ZRjT2zeywuUOm08EEbNtxQbS1M6f
	/Xm/Q8/UMEy9vgiSJxaxMvaMbpDB0Uo4Y0pdwFxwjFKGlATO6IHqotakpfaGYmEnJe4dIGITq3R
	IqfZGCH0UGBQKtzHkCi830IFnhVPNSVnK1oSCVM5SIICVZ1agG30VliY9gQ==
X-Gm-Gg: ASbGncv1UcQTYnc6UPKI9H7X5M6REXEx2HCMjLTrFmOaJnVqJrSh3MGqL4Aq79gDrx1
	2AV5mkJKgdSvTDW0gj/U7f3W3gIr6WgXl2bK1wMd3xZrO+PzxAWKY8IvErsX2eltw+FDV9w4fiL
	tWrxYBSEMml8AEU208v8CWT1J7CuhBOkEQ1agsPAa/oz5/2S37pTG304hsC0aum183yGUkAjUi/
	+AOm4Y/zZ9Vd04T2vU3imnXycvTOkIHF5xJ0h/ZiguBW4jAgaIe1gqdnk3u6w5PPIARCh7iU8JW
	okoaR28L62vh7MMD1jcvuyEmStJ0fyZ46L0b4hTSiAgnlOxdwVckbPXhU0k1rKQSIzxMWUFvFA9
	mWntliETaV4VqVpZKYhlZO3HG0aEYRgi03pFWPX4fizT0Iyqb3FJFckyVDg==
X-Received: by 2002:a05:622a:294:b0:4ee:19f2:9f1b with SMTP id d75a77b69052e-4ee58a79321mr379318151cf.37.1764263342275;
        Thu, 27 Nov 2025 09:09:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7SDD1pz2kq89q4lSRs0L5SYetYPSbwxZB+UZXIRwmEKamSd3OD+efib0aN3YltOkmWfBspw==
X-Received: by 2002:a05:622a:294:b0:4ee:19f2:9f1b with SMTP id d75a77b69052e-4ee58a79321mr379317591cf.37.1764263341908;
        Thu, 27 Nov 2025 09:09:01 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524e5cfcsm13407616d6.19.2025.11.27.09.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 09:09:00 -0800 (PST)
Message-ID: <042f890a-cee4-4a87-a13e-f9fcca4381c9@redhat.com>
Date: Thu, 27 Nov 2025 18:08:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 03/10] arm64: efi: initialise the EL
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-4-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-4-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DMxNx7miy_ew606d1dxSy2z7U0_qGhx2i8TDmI1G0Cg_1764263342
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> Initialise the exception level, which may include dropping to EL1 from EL2, if
> VHE is not supported.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/efi/crt0-efi-aarch64.S | 5 +++++
>  lib/arm/asm/setup.h        | 2 ++
>  lib/arm/setup.c            | 1 +
>  3 files changed, 8 insertions(+)
>
> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> index 71ce2794..5632fee0 100644
> --- a/arm/efi/crt0-efi-aarch64.S
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -147,6 +147,11 @@ _start:
>  0:	ldp		x29, x30, [sp], #32
>  	ret
>  
> +.globl do_init_el
> +do_init_el:
> +	init_el x16
> +	ret
> +
>  	.section	.data
>  
>  .balign 65536
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 4e60d552..bf05ffbb 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -29,8 +29,10 @@ void setup(const void *fdt, phys_addr_t freemem_start);
>  #include <efi.h>
>  
>  #ifdef __aarch64__
> +void do_init_el(void);
>  void setup_efi_sctlr(void);
>  #else
> +static inline void do_init_el(void) {}
>  static inline void setup_efi_sctlr(void) {}
>  #endif
>  
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 0aaa1d3a..5ff40b54 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -349,6 +349,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  {
>  	efi_status_t status;
>  
> +	do_init_el();
>  
>  	setup_efi_sctlr();
>  

