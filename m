Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33B191499
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 08:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200495; cv=none; b=tg3M7PGlGH2GD+9e2CxxPm4fOU8RyH2zclIhSsn2Vd+wFKu3VSdpnLugYPGaMRHTwk3ud7auuuAf0ud4xieEyMloQhd+1jJDgZsSauCGOnsSBmrMhi8E/FPXkjDkV880/xumIjoFhSmUWkmkv3lTb0qw/euDo2O4xqwkFopJ2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200495; c=relaxed/simple;
	bh=8JgS+u2cAzs4Co0pwnNJuP6j1MhdRfZk5OsrHuRYFt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDypBcmIRjCouruWSEqeA6DpEirN219guwJv3WZFrX1iYCcqzzlYJYVokar9smbZNkHNOVWt+VDl5fo3/gGPtjRaYZ4WPzkh9VWwibEjsPCV8sljf4NNwdgg3jOi6murMU4qfhbXBuXzxYLnK4eQ24nM9eQ2eUFXlXu7NrXPk4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6XHa0oQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6XHa0oQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742200493;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Nm+DfMNs1ddAyATqlb7pZj2Xsa+iVIwiCGiBBFTXtU=;
	b=f6XHa0oQD2YV8gVg1TNLmRUKX36C/gQzD579lndRRECdAkw4OJFyPVd06iuYkgbV4vA2FZ
	mQHkvRYku2k/8oYpR6UuIWMVj4faZbr249giGmH5qRTzYLvcMNpMbXaO7v2N9qAkKy+918
	o/T2sACn8oX2adGr5NxzbltOPxvkiwg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-JRvNNnOcNTmf-MP-Nt6doA-1; Mon, 17 Mar 2025 04:34:51 -0400
X-MC-Unique: JRvNNnOcNTmf-MP-Nt6doA-1
X-Mimecast-MFC-AGG-ID: JRvNNnOcNTmf-MP-Nt6doA_1742200491
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d43c0dbe6aso88205585ab.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 01:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200491; x=1742805291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Nm+DfMNs1ddAyATqlb7pZj2Xsa+iVIwiCGiBBFTXtU=;
        b=Pq7u7CdiJpDGrVYboxo/nXozFO70JlHKR7uqQtmICuVoAiPgCfVpNi/AepjBIL8/BI
         oKKrsbfRzYWHSw/p9/pFOM9yfDDuhO8kktgUw9P4x5xnCwIZolGhqZqyMLe2KCinhGBY
         K7x2nLNii+zvbL66QkyaubdFsjDwbGtmNKs70RnFAmAUloLbYTBaPbf0ASABUO6X6tBI
         vXzf1NLX0ZI7bdgdqi5ou09M9qzAE24S0Ybkn1C+Mltl1ByBXMwQnj74I5Fkus4xo8Z2
         23Ak+uf09V0ISMguJFCFmmRf55DncEu2Ug0RewkGOY2D9g7AQ/MFpAxRHUE0ui8+CFuo
         MJug==
X-Gm-Message-State: AOJu0YwTp+0nRhKi4FvevbO3qbdCheL1PHaXn3GzRe/pU7r0KoozQq2w
	R8CXXhsdwEIp46r6nLOSHwejIn9L3puixb9EqcsM2mXwQA/BdIEh79HJxb+XAVKoxFjYVAjx4IK
	aNp7Zq92ELOvqRQkIifGQmPHI1XJplgk5IOtCiqKhFPYRMVtj4OatyQ==
X-Gm-Gg: ASbGncuvVz9g7ebvnAqfh3xb0Vb4xIWplY5dEkLwOWAnczR9bWtxfvi3WV5Wap8E75/
	8fmK4sVyDm/nHWom68Dz53P6fBmvyd+m4d7IUd2Ft0t4Z3D2O7LNn3zVYDT+IVrKACuh3XtmfqR
	jbhQNlYHaWxNPIfEp9hHuWTd4teXXQ+ldKveDwq7VRjWi1la2SxlNbdiertiX17F5s/htMeR6YW
	5d13UFdB1/qnt9uvUaO5ahevzAZ7eyWo58JVs8db3NZQrF7Bb7BO/c1FzCCOhospyGjx3KAiIQ+
	POWU3N3c07I6wfdTM4QIHVRVuHXJ5RJIQgw6N6T4cq0q4sLVrAGn/NjYSNYHGtE=
X-Received: by 2002:a05:6e02:1a26:b0:3d4:3556:741 with SMTP id e9e14a558f8ab-3d483a636e0mr118980605ab.17.1742200491121;
        Mon, 17 Mar 2025 01:34:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXeeNMofiOfDClXrxvr5QBbj3fKlOQKb5SMWlRsPSseOxhMX7fmpLthdjxkcqMtcHa1MAfRA==
X-Received: by 2002:a05:6e02:1a26:b0:3d4:3556:741 with SMTP id e9e14a558f8ab-3d483a636e0mr118980485ab.17.1742200490827;
        Mon, 17 Mar 2025 01:34:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a83817dsm25926785ab.61.2025.03.17.01.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:34:49 -0700 (PDT)
Message-ID: <eedd9e34-7c9a-4379-818e-3420cc8177d0@redhat.com>
Date: Mon, 17 Mar 2025 09:34:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/5] arm64: Implement the ./configure
 --processor option
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-5-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-5-jean-philippe@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -iCoOk701f5mncdGX37ndxRnNX8tdAy1_iu82IEBh0s_1742200491
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> The help text for the ./configure --processor option says:
>
>     --processor=PROCESSOR  processor to compile for (cortex-a57)
>
> but, unlike arm, the build system does not pass a -mcpu argument to the
> compiler. Fix it, and bring arm64 at parity with arm.
>
> Note that this introduces a regression, which is also present on arm: if
> the --processor argument is something that the compiler doesn't understand,
> but qemu does (like 'max'), then compilation fails. This will be fixed in a
> following patch; another fix is to specify a CPU model that gcc implements
> by using --cflags=-mcpu=<cpu>.
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/Makefile.arm    | 1 -
>  arm/Makefile.common | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 7fd39f3a..d6250b7f 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -12,7 +12,6 @@ $(error Cannot build arm32 tests as EFI apps)
>  endif
>  
>  CFLAGS += $(machine)
> -CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -mno-unaligned-access
>  
>  ifeq ($(TARGET),qemu)
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f828dbe0..a5d97bcf 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -25,6 +25,7 @@ AUXFLAGS ?= 0x0
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>  
> +CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
>  CFLAGS += -O2

