Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54092E0410
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263261; cv=none; b=EWnuDIqSb+PyqFlwk9ONqi75kWRMxxLxOSAMr/W+CfLBhdlhToFmXHyQTx5TM5vwmZBkzoqvzqMBPotANg+8yIrvjcy3ArLdb0745Umnz4kvURuNHn4m7HP92B2O3HzPQp20C+uPGusTXIZ2wMKXfe03NDyBDH8lhSkmXuWmtAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263261; c=relaxed/simple;
	bh=WNftygtxSL6IMWGCxSRkwNbV5nPIgoHk2RbEmkARluA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqGKWv3ihcCWTqUm7gaCv+xvGOYa+JM1wVagQDWjXiGJ845tDx0DP59KHYteaepT3QMTU0+VZiQCNZABwBRlD/NxPFToce+X2byUc6q1/+nOkd9zMoD5qY4qf/0FdNZkA9p64BFqJmnoOtj3Zf2LFAKdIkqPVBoAWy8MTarZHHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlUtFnZs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlUtFnZs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764263258;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mV2UP49qvKkyyXIhJrLysCKXjPL5fKqw41mRBMGCnN8=;
	b=WlUtFnZsltqoMfgwpceEo5aH5IUks4CfOgXXHe/i2zVUpEbYssU4QJ16bxIab8hp9HsnWn
	9E4NG3mIG8W7HZJTM2alv2H8yMMHNbh1C/aDxd/s9MzFTmjT08GvQNLKA8YD3dPcD2Iz4x
	3QXhs89Wfsex7k1xVDp0yDMyjeNUWJM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-wDNYkQzwMISUkaSlkuaPJw-1; Thu, 27 Nov 2025 12:07:31 -0500
X-MC-Unique: wDNYkQzwMISUkaSlkuaPJw-1
X-Mimecast-MFC-AGG-ID: wDNYkQzwMISUkaSlkuaPJw_1764263251
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2e4b78e35so182703385a.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 09:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764263251; x=1764868051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV2UP49qvKkyyXIhJrLysCKXjPL5fKqw41mRBMGCnN8=;
        b=elUlLd7hio/7XI6V7+y/ZPFK9ZFbiY/MUcuhIp/jgjITPXARV96aC+aOvUq/Sp1b3C
         21uOealcCMxuamzG1AGOSy0ioahdJkuT3OkB7Eyvu3nPpXNX9U6V9ntpRfdaaicE+qRl
         O59BjCVBcodtrZsKIHsETE9WOMboLDhXbOLnrRUnno6LRm40VZN89nWFvrlE0hAtw6Hr
         5vxm+KjjVLBsKXUOKZG0P9mXuykSxxt/WMIX0G5FPZ6x3VzhrClK1aCJhQxZ4TgGk1Wv
         gRo5gQeOCEAYo+aPSR8WL+SPRr2eaiR/S7sQBuKVERnFVjWtr5IfqawLT0ZFbODU0pB5
         9n6g==
X-Forwarded-Encrypted: i=1; AJvYcCUBJsJzv2lTEe7pyFGA0WoNoa5Y8tqxvSopi2kAZQXwxwb+OjcDTNAaaVg2rmP4j6pXDZF3t1k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIV6BjTfS7hzxEac61JbWNCo5COZFimnnImPho8WlZE4eyFNQ6
	kVycm0yqhxjhgmXyCm/rUm+ln2GZ8WZUxoL/1h4Jm/hz7tFy3obqc1KXJFZdHV2DY7omsl6VS2v
	ykQ0BmWsjPjEvnda7lYfIU0MOW+KJPUsQH6qWbs5kFvOjNR7o7uR2PsVMUJiDT3faGQ==
X-Gm-Gg: ASbGncu86edVlkYlHXd6zjCPUZipEXCbfskEEv5Kxb+TwE+d1kvMfpQAliXiVOP15bg
	pvUaDPpt/wDWRr14PL2YQWkuZEVuczf+x9jZorHsS6JTaPTD/5U9OuPIov1tw0DNyCGFUqEph5e
	5PFWD8ZNoXuzUK8UOmvMp9LvMkJYE6msjyyePDzV1iliQ4M7Kw+9O+AdhVtUqraZfW87Q9tMql+
	PP5h7froF7kptbSaR6F3TriBU4W2GevB75oDVF6DS74Xh/2COmqnT8updh9t/8U4SdgRm/Rdbus
	YR6CSxNLmBrTkuPixnajgtoi/ylycDeDxYkwp+izIUT4l6Ss0580ZaBw5FSNV5Q2F/Zn5oi4G7h
	qlBgnfaPK3NhmfG0RG505sIDjNByI4kJ5w2GihWKbebEDw9RcVdLVQOLReQ==
X-Received: by 2002:ac8:5f93:0:b0:4ee:12e0:f071 with SMTP id d75a77b69052e-4efbda335afmr149294901cf.20.1764263251185;
        Thu, 27 Nov 2025 09:07:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6lyi76KYE/oBFzG9aDg5WUkrTUPkQ/7sKsHxhci6KoegKW5WMzobiAFfIQE8n+bHCDtPTPg==
X-Received: by 2002:ac8:5f93:0:b0:4ee:12e0:f071 with SMTP id d75a77b69052e-4efbda335afmr149294261cf.20.1764263250688;
        Thu, 27 Nov 2025 09:07:30 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b73542sm12559736d6.44.2025.11.27.09.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 09:07:30 -0800 (PST)
Message-ID: <e4ffc74b-ae94-4304-9985-7e1f2df2767f@redhat.com>
Date: Thu, 27 Nov 2025 18:07:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 01/10] arm64: drop to EL1 if booted at
 EL2
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-2-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-2-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kgMz-hv-CyDqU37L9X9c4eACDiKqiFc0NkuQApJ50xc_1764263251
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> EL2 is not currently supported, drop to EL1 to conitnue booting.
continue
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/cstart64.S         | 47 +++++++++++++++++++++++++++++++++++++++---
>  lib/arm64/asm/sysreg.h | 14 +++++++++++++
>  2 files changed, 58 insertions(+), 3 deletions(-)
>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 014c9c7b..79b93dd4 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -15,6 +15,46 @@
>  #include <asm/thread_info.h>
>  #include <asm/sysreg.h>
>  
> +.macro init_el, tmp

init_el2? but also likely to fall back to EL1. At least add a doc comment to explain what the function does.

> +	mrs	\tmp, CurrentEL
> +	cmp	\tmp, CurrentEL_EL2
> +	b.ne	1f
> +	/* EL2 setup */
> +	mrs	\tmp, mpidr_el1
> +	msr	vmpidr_el2, \tmp
> +	mrs	\tmp, midr_el1
> +	msr	vpidr_el2, \tmp
> +	/* clear trap registers */
clear FGT registers if FGT feature supported
> +	mrs	\tmp, id_aa64mmfr0_el1
> +	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> +	cbz	\tmp, .Lskip_fgt_\@
> +	mov	\tmp, #0
> +	msr_s	SYS_HFGRTR_EL2, \tmp
> +	msr_s	SYS_HFGWTR_EL2, \tmp
> +	msr_s	SYS_HFGITR_EL2, \tmp
> +	mrs	\tmp, id_aa64mmfr0_el1
> +	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> +	cmp	\tmp, #ID_AA64MMFR0_EL1_FGT_FGT2
> +	bne	.Lskip_fgt_\@
> +	mov	\tmp, #0
> +	msr_s	SYS_HFGRTR2_EL2, \tmp
> +	msr_s	SYS_HFGWTR2_EL2, \tmp
> +	msr_s	SYS_HFGITR2_EL2, \tmp
> +.Lskip_fgt_\@:
> +	mov	\tmp, #0
> +	msr	cptr_el2, \tmp
> +	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
> +	msr	hcr_el2, \tmp
> +	mov	\tmp, PSR_MODE_EL1t
> +	msr	spsr_el2, \tmp
> +	adrp	\tmp, 1f
> +	add	\tmp, \tmp, :lo12:1f
> +	msr	elr_el2, \tmp
> +	eret
> +1:
> +.endm

I read in the coverletter you chose to not reuse include/asm/el2_setup.h
which indeed would look overkill given the reduced scope that we target
here. However compared to init_el2_state we seem to do very few things
in the EL2 setup before switching to EL1. I would give a bit more info
in the commit msg about what you keep and what you dropped and why it is
reasonable (stage2, timers, debug at least).

> +
> +
>  #ifdef CONFIG_EFI
>  #include "efi/crt0-efi-aarch64.S"
>  #else
> @@ -56,15 +96,15 @@ start:
>  	add     x6, x6, :lo12:reloc_end
>  1:
>  	cmp	x5, x6
> -	b.hs	1f
> +	b.hs	reloc_done
>  	ldr	x7, [x5]			// r_offset
>  	ldr	x8, [x5, #16]			// r_addend
>  	add	x8, x8, x4			// val = base + r_addend
>  	str	x8, [x4, x7]			// base[r_offset] = val
>  	add	x5, x5, #24
>  	b	1b
> -
> -1:
> +reloc_done:
> +	init_el x4
>  	/* zero BSS */
>  	adrp	x4, bss
>  	add	x4, x4, :lo12:bss
> @@ -185,6 +225,7 @@ get_mmu_off:
>  
>  .globl secondary_entry
>  secondary_entry:
> +	init_el x0
>  	/* enable FP/ASIMD and SVE */
>  	mov	x0, #(3 << 20)
>  	orr	x0, x0, #(3 << 16)
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index e537bb46..ed776716 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -77,6 +77,9 @@ asm(
>  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
>  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
>  
> +#define ID_AA64MMFR0_EL1_FGT_SHIFT	56
> +#define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
> +
>  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
>  #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> @@ -113,6 +116,17 @@ asm(
>  #define SCTLR_EL1_TCF0_SHIFT	38
>  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>  
> +#define HCR_EL2_RW		_BITULL(31)
> +
> +#define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)

I don't really understand the renaming

> +
> +#define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
> +#define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)
> +#define SYS_HFGITR_EL2		sys_reg(3, 4, 1, 1, 6)
> +#define SYS_HFGRTR2_EL2		sys_reg(3, 4, 3, 1, 2)
> +#define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
> +#define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
> +
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>  			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
Thanks

Eric

