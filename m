Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D9621C9F6
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 09:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128944; cv=none; b=hfymfMhikjbhuvU5g7LVsux8vf1GnI7DtGjsExIuSJKXIZlCt3rQJS4vCoXf2fOBPqYpnw9xUo/ndaEk8kyxV3Q9bip9z9f4AU6e9gaYcAQudnsBGJ6RE1gFMmoQgaRC4Dx2uH0+PLGRHIusCmbsdid/qo3cf7Gwx/XJKhC7bBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128944; c=relaxed/simple;
	bh=m9nJ7Dow1bGOqjqvrslJ8vS7QvFrtSnA0WjHTjK2eYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r/LhCEhdI31phzsjFdFcq2bIPYEAkSkPa7EsaORU4VauFtqb2QFOSz8eVzUqnBGopgTSCNeq+JBKIQRjaVtRUEEbnqpFfgUt9SqOVyLgS41KbVkLwcUL2NcTm+nlwZnYuSqAPFo39XtC3Utd+aJoW6x6zng7LK7SySZWMPtgAgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUTYlZjh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUTYlZjh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747128942;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x2sEFkNhHYZ7GGQUEXzmazTwyDBnc/lAYLVVyCnVFpc=;
	b=cUTYlZjhjUlGa/fEKYdXYiAw0MCRZOm1JetnfXBj6doKTMd++Ki83Urns6mxSYQDpaJXh6
	sFqlq+m6AtrbxOW4cUIo/wneTCFSsLdrtwwHhK9iumn9YKlkmHn6/If8mru3OEZe/23mn6
	Jmeqbf50Xq60yk007YeDW8WZ+9L40yU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-vU6TTWCzNGqZhovNsEGVNw-1; Tue, 13 May 2025 05:35:38 -0400
X-MC-Unique: vU6TTWCzNGqZhovNsEGVNw-1
X-Mimecast-MFC-AGG-ID: vU6TTWCzNGqZhovNsEGVNw_1747128938
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso25863925e9.0
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 02:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747128938; x=1747733738;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2sEFkNhHYZ7GGQUEXzmazTwyDBnc/lAYLVVyCnVFpc=;
        b=jMjCSyR+34QQO2Af/KYriq1Jl9lF+Ht+UFx+VJ5M5Mz214gL9+Y2YERsmK0K9GYOK5
         cUzmP75x9mUxdApISHsg7vWh0uKpvz7FivEtqPz2/Yn6YcvKKCY7smfn9LdX1eaLnO9u
         0FYlxYzpUFXGwUL/deGCHEOdGq/4n3HFkBPgnp1rQGgqdv27kCNJu7PvkHdyJhAPGDgz
         m/a92n9i2KB2BBS1hoX1NRgmpA11e8uG5vxeDiyURE3Z+6Mq/TZJUPcZ5eXhznRR6Mtb
         NlOIUmEjfjD+oyb+h93ExIj5grFeQHyAgbC7F+mkPwp441e1JgIhn+VvPH9Ehavv0vLN
         vNhg==
X-Forwarded-Encrypted: i=1; AJvYcCV2ouvn+UZAUBem5JzxRtKCLVt9Fs1Kyvh0dyypW1twBBdsQOWBELyYYd84VDJr1yvxxjg+nSc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoKqw+ZaEWp2vr8qO3rbeEn37CrJ2NwD9KwfFBfh3eo666XN/C
	/NCZL6M3pBtaMXzIrKJDon7/zb/IWuzINXBQp4VoOpXaGmg9FGpaYzgKWc2+CQLdFogSPIpdl9n
	dPLUrN3PUic2gqxy5J7heCvQ9x5GesVtNGwmlhzJRz1qIxhSLYjYdvg==
X-Gm-Gg: ASbGncsvcfezR0xNEi5XWGle5tgX7h7Wk10zshmBTb+wZhu8EOQ6NdDk6NssTl98L51
	JHwXLVb8adcI4IsYuZ59IcVMme3v4SbC4SItSmFYBtEGXaljinqRZ4SxpsAWXCMEkO8cl/MzfXh
	WZfFxpizhdCkf9Fz8x7o91I9nfaH7mCOjSmG8gMKupcwOMs5vWW6N95fj7PxdRG2NvkcCF9sXtC
	0zkK73KF4/rPwfL4mE79NLvdrPISMNnjGNQMOkXXBF8SM9IK27JWIr6JkXnag6VMGRMyMJvZvcV
	wv/1r5V0H4jfYoe4XinxZ0Ksd00TzyPMubrDkVdhy0mQKfNAMiCTqMq+WGQ=
X-Received: by 2002:a05:600c:3e8c:b0:43d:fa58:81d3 with SMTP id 5b1f17b1804b1-442d6ddf4d7mr118849305e9.32.1747128937779;
        Tue, 13 May 2025 02:35:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCI4rgD0A88V6XQZo6DtnOn6uXQ6p6jHrD+3b6d48dahq9xWQ6xtY85o20G9s32vk3lb7GpQ==
X-Received: by 2002:a05:600c:3e8c:b0:43d:fa58:81d3 with SMTP id 5b1f17b1804b1-442d6ddf4d7mr118849015e9.32.1747128937420;
        Tue, 13 May 2025 02:35:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d687bdd6sm158275685e9.38.2025.05.13.02.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:35:36 -0700 (PDT)
Message-ID: <df944d74-335a-4131-a58b-3bf4dd6fc1b7@redhat.com>
Date: Tue, 13 May 2025 11:35:33 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v6 14/14] arm/kvm: use fd instead of fdarray[2]
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-15-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250506085234.855779-15-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lt4wabYtVl6VGzhK85nkdAv86wT4ESdW_5vetOi7BBM_1747128938
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 5/6/25 10:52 AM, Cornelia Huck wrote:
> We have fd, so might as well neaten things up.
>
> Suggested-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Cheers

Eric
> ---
>  target/arm/kvm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index abb63b7f617f..1ffd67a39056 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -387,11 +387,11 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>          err |= get_host_cpu_reg(fd, ahcf, ID_ISAR6_EL1_IDX);
>          err |= get_host_cpu_reg(fd, ahcf, ID_MMFR4_EL1_IDX);
>  
> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr0,
> +        err |= read_sys_reg32(fd, &ahcf->isar.mvfr0,
>                                ARM64_SYS_REG(3, 0, 0, 3, 0));
> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr1,
> +        err |= read_sys_reg32(fd, &ahcf->isar.mvfr1,
>                                ARM64_SYS_REG(3, 0, 0, 3, 1));
> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr2,
> +        err |= read_sys_reg32(fd, &ahcf->isar.mvfr2,
>                                ARM64_SYS_REG(3, 0, 0, 3, 2));
>          err |= get_host_cpu_reg(fd, ahcf, ID_PFR2_EL1_IDX);
>          err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
> @@ -429,7 +429,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>  
>          if (pmu_supported) {
>              /* PMCR_EL0 is only accessible if the vCPU has feature PMU_V3 */
> -            err |= read_sys_reg64(fdarray[2], &ahcf->isar.reset_pmcr_el0,
> +            err |= read_sys_reg64(fd, &ahcf->isar.reset_pmcr_el0,
>                                    ARM64_SYS_REG(3, 3, 9, 12, 0));
>          }
>  

