Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0E91E9B1C
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536814; cv=none; b=YmQqRFCZViwmCT4RMmjn7ypANdWfM4FCUG8r16Bhv184c7b4/NzbjvUaFlnQyj1rGnTFKdhtELIgRorTAa7vYaQKNzot6O0QUR5jWbnYZ8DOg8iQHqoV2XFtGT3FBo5UfcuGqgYv7voQrYPOdTHanH3HKYUqxbIPCoZKGl1Z4Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536814; c=relaxed/simple;
	bh=oSO7SlUSrk95C7cCnQVz65pkXLW7lNHTp4Lr3lJn43c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lB0p76Z1Dsg88ZyAWCCG8ka+/5QIiwEczUSj/xMABvraeq1LpaaTUVMLnACFSXHLSfHg+v961QP2CoZrLwhkDd9SWiZZo5olHPa34IApJ72DPvxHynN0dHQRZAc9X0ApIOAtEYaTiEcVMeCEqH/KAxZV9xn9grwyFs/s+9gJ2sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=irKGkGNf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="irKGkGNf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734536812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IiINDmFgi3CvvCGYNLW0/8flH+A9x/a7nz/XzFllaOU=;
	b=irKGkGNfNDj9lcTDG2svIKrOZ38cYHLd6HXKJJYKH4LtP3y0UYtqtyeznBuAKd9/Y3ODQS
	jKFTwEHMZpEJUg5L+k9NxtfY1zqnZgkUAralHD3S8lP1RGE4eqezQT+w2r3di2QaCb8IJA
	3p53Lwp6OAOnNNByi9Hy7B2pdaI56BE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-z8qH7yZ9MMmmOp6ApEu3hg-1; Wed, 18 Dec 2024 10:46:48 -0500
X-MC-Unique: z8qH7yZ9MMmmOp6ApEu3hg-1
X-Mimecast-MFC-AGG-ID: z8qH7yZ9MMmmOp6ApEu3hg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38634103b0dso3650926f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536807; x=1735141607;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IiINDmFgi3CvvCGYNLW0/8flH+A9x/a7nz/XzFllaOU=;
        b=SqBfKfn5RHdJLN4nNorWvZG+vYUH4fgKYGm2RBu8aBrgD85CHW1eiwwBHiHqb+ByJh
         WvvKV317eZ4/hcvO5Mb9TvclDINhIvUpR2A1ldYGywD5nl4hq2mR1tDHJvTW6VBtwOUe
         ClHGgc/9sToJIySesSr2900N6lXt25lJxE6BuRUezgUVG52JfL4BfEazLuEQjXYGWvDg
         f2P1KOG6j5qk0aROVNaaBZf+CVoNUfqpyrVEt4ZxjDooVtGhm37/SeePfCvDYj6pEatG
         JJIcqFKV2EZFt72pnWs2TFIj8bJe8GCwHSJR3QHgdXiHOwf01MnkP460wED8djSWAc0N
         4tFg==
X-Forwarded-Encrypted: i=1; AJvYcCVFp2EkqqHCt62rgE3Rb2rNzdYlS+XUcZdDAkNghY4Ng1SLccCPlDFgabZqqQ6v3KxpUKLW91Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8R2ZC8ncht5WKOtQ9VYsLFXN9O+ewzCjzjWCinmWxzgtTJ5EL
	OgYayHHCjwbs2cDBXtlHm+9l8T0Mnj2znmeTG6Fn47Sq7gudhGtqK96I40NGJJTiUXDlLp5rfa+
	Ano3k4yMSZibZGa2TSDSzYCdimEhm2qF3pZxWnY3pKVGtB8j6Az6g4Q==
X-Gm-Gg: ASbGncvpSBc9DJD7QSK4Ti2oFkPlbj9Lnav9fT+uHrqUBsHKGYK13QJExAZBB0oXlkv
	/QWzq7vY4CldwI/3WGrnYnBwdh2wQ0G6Sl12jWT50Nuhe5fQOKpRGstRNsIP8L5kgj97e1aCBD8
	dupagcHp+gMIuv4tOPHfgN21zQFB9/OsSuDd2QiJ1pGwoitpIYPC8VPvqn44p3JLbDMOQVhn1lC
	8Km8tUHHZnZiUVCf0SmqwORONqaImW+v0+E4dmeO+//S1TomnP17VpK/r5sZ1MumtTC+nnGye4P
	i/A6lvQQh67h9ANTyYxVdls=
X-Received: by 2002:a5d:64eb:0:b0:386:7fe:af8e with SMTP id ffacd0b85a97d-388e4d2f515mr3213061f8f.12.1734536807145;
        Wed, 18 Dec 2024 07:46:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFovgQ/USAGFlREJnD8NcVoejkKLPY8P9I8MWbW2wM5zOQziDgwJ0bp1yIxiLN+FxRbPY22Ig==
X-Received: by 2002:a5d:64eb:0:b0:386:7fe:af8e with SMTP id ffacd0b85a97d-388e4d2f515mr3213039f8f.12.1734536806816;
        Wed, 18 Dec 2024 07:46:46 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b01b73sm24471465e9.14.2024.12.18.07.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:46:46 -0800 (PST)
Message-ID: <7987c825-5ce1-4401-85ed-e7192e54e0b7@redhat.com>
Date: Wed, 18 Dec 2024 16:46:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 17/46] arm64/sysreg: Add register fields for PMECR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-18-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-18-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UQUAeWbsb-nAewQztjxJ4GKUWuW-R2kAAYt2rnRnix4_1734536807
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for PMECR_EL1 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/tools/sysreg | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index ff09da6c0b1e..214ad6da1dff 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2349,6 +2349,21 @@ Res0	63:5
>  Field	4:0	SEL
>  EndSysreg
>  
> +Sysreg	PMECR_EL1	3	0	9	14	5
> +Res0	63:5
> +UnsignedEnum	4:3	SSE
> +	0b00	DISABLED
> +	0b10	ENABLED_PROHIBITED
> +	0b11	ENABLED_ALLOWED
> +EndEnum
> +Field	2	KPME
> +UnsignedEnum	1:0	PMEE
> +	0b00	PMUIRQ_E_PMU_D
> +	0b10	PMUIRQ_D_PMU_D
> +	0b11	PMUIRQ_D_PMU_E
> +EndEnum
> +EndSysreg
> +
>  Sysreg	PMIAR_EL1	3	0	9	14	7
>  Field	63:0 ADDRESS
>  EndSysreg

