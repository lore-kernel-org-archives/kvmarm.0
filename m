Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484FC22A7E9
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 08:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664595; cv=none; b=aN/ilVPu56amQoPFXtw3fxW6n9r7kNu3qutTZP2NI278bsjGrMuIxIK36Zla0pobO/sArh5kLAYMjKtJGC7Z3Q5IaiCTbVBtn9WOybVfZnMG8Dd3UsEK5n8mGjEEul3pIN1BD67QkHfUBtVnskIqouqzOYMkFXw98+PpNEOa81g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664595; c=relaxed/simple;
	bh=Gz7vApITgIqPY132Zxq49IpiscM7OmK0CHhCAthSdJg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qFRvndh70VK19l9kzrwvFot7rD8x1UW4/S1GDXAtNM20bdBHgHuE87s5m++8x0WjkMPM/ODMvifvAhWJfzBTNRbR0RiTSfHTh3vwUnrCetJhIcVojwny9zmKUrDeCriIJ6IcH4o55YXfSpTl2uti5RwortvV3BwMVMtB1frgJhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CHCS5ORr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CHCS5ORr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764664592;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvfVo/tXrBwyrxovjX+VTgd/Lnc9aoy4HSw1ILNP5rA=;
	b=CHCS5ORrF4h54Aj2rlORBiBg0Bw6rXLXm7mPiJT2467k2Lg3GlXJDvN+v/gJ0MJCdp2t/a
	OMkTEgjrlBvi4HE+xYGZXNKtRNrVlLtb6I3vWBf2+dzrVG6mnIgyeCMqQh87ASUUAStkXX
	b0IgHNt3bDrSQLrw1x2gpJuXviFmBS0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-Q10c6ZmVMR-2juJOT9I-Jg-1; Tue, 02 Dec 2025 03:36:31 -0500
X-MC-Unique: Q10c6ZmVMR-2juJOT9I-Jg-1
X-Mimecast-MFC-AGG-ID: Q10c6ZmVMR-2juJOT9I-Jg_1764664591
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-88238449415so173234536d6.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 00:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664591; x=1765269391;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:reply-to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvfVo/tXrBwyrxovjX+VTgd/Lnc9aoy4HSw1ILNP5rA=;
        b=Wp4SzOzFx26ACCsjxqYjCxJbL76TqrYDhAjUHFkWV/sy9pViFbwRLaMsrNuWiFUNLW
         NLSOaG+yG9dfxw/KBn7JACEVT71qS/DCT91MjAlK1NztH8mRf1g+qcmpvwZXG8BCJkrA
         5PtzlpQWFy5XEP7FVuzZc003CisWsiYnEXJ+4yJczvJOhPrs2f1sXvsDFU8sV1ti2MYW
         h8ZeV+NZ5cTMCX/DCtq0zDbFWnAFVGEt0LtdgP7IDtgE3Mwbid3Y4UFd2glFCeXeW0HP
         aVD5tBRCbsyVDw6nmttYeow9Uo++LFbn/3nsWL6ePcOYfbdzQ8i33f1FKhr3OJ1CplWT
         jonQ==
X-Forwarded-Encrypted: i=1; AJvYcCUM0Imbi6w8j+/OUfYE2duqR4AJOEymRm+FxPEAoZXza1w/jJyA744MckfRL8OxKJ0+XL3KqtQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7jkIbZ1RlblKH5gaeeQPZy5nso+7zk4fD/uEZ0Cr+I8aGgjuJ
	nN9E7izBwzZ4/crXHYQHy6+/I+crpAXqexCEEL5SwN5NqKyr6njLsYVlXPl9QN4uB1eL1r8pP9r
	Z1+nRSh3MXfh1IBxVk0TQv11sBmzhFD8zis6sUZZ9bUTXY1ECWscl/M988A==
X-Gm-Gg: ASbGnctQzZCQF8K4D3nqDwGIQ3kH120SPM+e2/OPr3iygtXuPSYi4N8lFrfb+qtSjn8
	7VqRS0ai3rHC4v0wzZMwcY1YOQC9i8BM6l7fgX5bcMwlCmg8prgcVPL9682ENPzA1FnFWa6GIBv
	aF4DjP2Agb81aIHu/gclkr1j3Tf77gJNZLwIHm24zq23dHiKU0uMWaVTYra5rheIPGp4AZrdD41
	aoK9QYQrTYe9yO23NtYIOc6dCq0XVGpLVSwOph5N5utGAOfMjWX0FauBkH6PTEYfMAxcyV7kDrf
	pMybjRQFMThZoKgvH5RaXzzYfZfyL7Yct5Y3yMeY9Rb9DHAZXDs2MArkcod5kuEovbGxkR072EZ
	ksLSWSoJdgvZ4cFKm55HH3w5ayZ0tkpLhcpU2Al7ETWLbaWy76wnGo0iPiA==
X-Received: by 2002:a05:622a:514:b0:4e8:a941:4b81 with SMTP id d75a77b69052e-4ee58a6c025mr625414171cf.32.1764664590776;
        Tue, 02 Dec 2025 00:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIAnpUoT7sntSpUQUvxEen/nsZKDfNbEIvOfP9YAHn3QHjRKe70K7BiDefDj8DHnqBjrSyDw==
X-Received: by 2002:a05:622a:514:b0:4e8:a941:4b81 with SMTP id d75a77b69052e-4ee58a6c025mr625413971cf.32.1764664590357;
        Tue, 02 Dec 2025 00:36:30 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd345c34fsm90330451cf.35.2025.12.02.00.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 00:36:29 -0800 (PST)
Message-ID: <02742e7b-7f29-4960-b44c-51909a0e8c60@redhat.com>
Date: Tue, 2 Dec 2025 09:36:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 04/10] arm64: timer: use hypervisor
 timers when at EL2
Reply-To: eric.auger@redhat.com
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-5-joey.gouly@arm.com>
In-Reply-To: <20250925141958.468311-5-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y-eU_7GCAdDm4HukZej2tKbYrWstWkURGd5MT_wrjsg_1764664591
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> At EL2, with VHE:
>   CNT{P,V}_{TVAL,CTL}_EL0 is forwarded to CNTH{P,V}_{CVAL,TVAL,CTL}_EL0.
>
> Save the hypervisor physical and virtual timer IRQ numbers from the DT/ACPI.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/timer.c         | 10 ++++++++--
>  lib/acpi.h          |  2 ++
>  lib/arm/asm/timer.h | 11 +++++++++++
>  lib/arm/timer.c     | 19 +++++++++++++++++--
>  4 files changed, 38 insertions(+), 4 deletions(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index 2cb80518..c6287ca7 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -347,8 +347,14 @@ static void test_ptimer(void)
>  static void test_init(void)
>  {
>  	assert(TIMER_PTIMER_IRQ != -1 && TIMER_VTIMER_IRQ != -1);
nit: move above assert to 

if (current_level() == CurrentEL_EL1) block?

> -	ptimer_info.irq = TIMER_PTIMER_IRQ;
> -	vtimer_info.irq = TIMER_VTIMER_IRQ;
> +	if (current_level() == CurrentEL_EL1) {
> +		ptimer_info.irq = TIMER_PTIMER_IRQ;
> +		vtimer_info.irq = TIMER_VTIMER_IRQ;
> +	} else {
> +		assert(TIMER_HPTIMER_IRQ != -1 && TIMER_HVTIMER_IRQ != -1);
> +		ptimer_info.irq = TIMER_HPTIMER_IRQ;
> +		vtimer_info.irq = TIMER_HVTIMER_IRQ;
> +	}
>  
>  	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
>  	ptimer_info.read_ctl();
> diff --git a/lib/acpi.h b/lib/acpi.h
> index c330c877..66e3062d 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -290,6 +290,8 @@ struct acpi_table_gtdt {
>  	u64 counter_read_block_address;
>  	u32 platform_timer_count;
>  	u32 platform_timer_offset;
> +	u32 virtual_el2_timer_interrupt;
> +	u32 virtual_el2_timer_flags;
>  };
>  
>  /* Reset to default packing */
> diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
> index fd8f7796..0dcebc1c 100644
> --- a/lib/arm/asm/timer.h
> +++ b/lib/arm/asm/timer.h
> @@ -21,12 +21,23 @@ struct timer_state {
>  		u32 irq;
>  		u32 irq_flags;
>  	} vtimer;
> +	struct {
> +		u32 irq;
> +		u32 irq_flags;
> +	} hptimer;
> +	struct {
> +		u32 irq;
> +		u32 irq_flags;
> +	} hvtimer;
>  };
>  extern struct timer_state __timer_state;
>  
>  #define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
>  #define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
>  
> +#define TIMER_HPTIMER_IRQ (__timer_state.hptimer.irq)
> +#define TIMER_HVTIMER_IRQ (__timer_state.hvtimer.irq)
> +
>  void timer_save_state(void);
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/lib/arm/timer.c b/lib/arm/timer.c
> index ae702e41..57f504e2 100644
> --- a/lib/arm/timer.c
> +++ b/lib/arm/timer.c
> @@ -38,10 +38,11 @@ static void timer_save_state_fdt(void)
>  	 *      secure timer irq
>  	 *      non-secure timer irq            (ptimer)
>  	 *      virtual timer irq               (vtimer)
> -	 *      hypervisor timer irq
> +	 *      hypervisor timer irq            (hptimer)
> +	 *      hypervisor virtual timer irq    (hvtimer)
>  	 */
>  	prop = fdt_get_property(fdt, node, "interrupts", &len);
> -	assert(prop && len == (4 * 3 * sizeof(u32)));
> +	assert(prop && len >= (4 * 3 * sizeof(u32)));
>  
>  	data = (u32 *) prop->data;
>  	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */ );
> @@ -50,6 +51,14 @@ static void timer_save_state_fdt(void)
>  	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */ );
>  	__timer_state.vtimer.irq = PPI(fdt32_to_cpu(data[7]));
>  	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
> +	if (len == (5 * 3 * sizeof(u32))) {
> +		assert(fdt32_to_cpu(data[9]) == 1 /* PPI */ );
> +		__timer_state.hptimer.irq = PPI(fdt32_to_cpu(data[10]));
> +		__timer_state.hptimer.irq_flags = fdt32_to_cpu(data[11]);
> +		assert(fdt32_to_cpu(data[12]) == 1 /* PPI */ );
> +		__timer_state.hvtimer.irq = PPI(fdt32_to_cpu(data[13]));
> +		__timer_state.hvtimer.irq_flags = fdt32_to_cpu(data[14]);
> +	}
>  }
>  
>  #ifdef CONFIG_EFI
> @@ -72,6 +81,12 @@ static void timer_save_state_acpi(void)
>  
>  	__timer_state.vtimer.irq = gtdt->virtual_timer_interrupt;
>  	__timer_state.vtimer.irq_flags = gtdt->virtual_timer_flags;
> +
> +	__timer_state.hptimer.irq = gtdt->non_secure_el2_interrupt;
> +	__timer_state.hptimer.irq_flags = gtdt->non_secure_el2_flags;
> +
> +	__timer_state.hvtimer.irq = gtdt->virtual_el2_timer_interrupt;
> +	__timer_state.hvtimer.irq_flags = gtdt->virtual_el2_timer_flags;
>  }
>  
>  #else
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

