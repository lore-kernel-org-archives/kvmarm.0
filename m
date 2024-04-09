Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1617D094
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 11:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712663666; cv=none; b=sYpM3ErxzxxunpFDyHLlVWhXsydbjTAUgks6IHat3QDOCE4mSRNRHflo7fe5QAnwrXFABX7+SLXrgYFvC9sr38Bj9Q+MucJ8sYsGThXOOT3WnvC2VXjglaSvOb0HdY/kjNaFAUgdzDOF9RWgv6yl/+yJB6JAPKw1eWtxHkLYClI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712663666; c=relaxed/simple;
	bh=GS8GvRJ6BaCt0o3AYCPs2XHK43ZxOxCcabg8AvfGy+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hgXHlFFZMeguMWUwPhCpa0mI9YVq9kslYKl9792b0hplTTEBMaPVWCVyn1TjZ5Lkx4qHg4bCnKLtP7QG1oJSkB3yLjXchWeekSNFKf8l4iUHm4syxfO6EuTrRbFfuMa39oJCixOYbefqXasFliw+yHoYaqNEezOKMufaaNSgGa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SSbD7XUf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SSbD7XUf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712663664;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0V7BJQPs63SCGjmjUhhHSoA26CNksn5Km/sWe0wY30=;
	b=SSbD7XUfkJCviNZxIIf0P7b5s6ro2JYsDXw9fFo1KZO11Iy7VzGOgdTtLlUdsK20KE6PhY
	dJ2e1swlsrUQujvpyyzjN9AofyRZ7zI8PIF+eHQwlN+ekStkQ0t6cmVOI3viVclavqpPK2
	fWifqPbT/1DOOE9UYm90H2WLSI4hSjA=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-oz1uAZ_sP6uOTURP_PLU7w-1; Tue, 09 Apr 2024 07:54:23 -0400
X-MC-Unique: oz1uAZ_sP6uOTURP_PLU7w-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5aa22f4eab3so2453092eaf.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 04:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712663662; x=1713268462;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0V7BJQPs63SCGjmjUhhHSoA26CNksn5Km/sWe0wY30=;
        b=C6HaqR6hcjmSyswrH/tKn6pl4KhyCVmtRHx/mvemAk3r48pQ91oMtY1zZiDV0/dKwK
         Z+K6ghkm8yD9I+ppdCHlyqTNBll/IrQAzYbRySlJvZ9Up8UeJ/k3aYHla9yKkC3k1NQ5
         PrFwoAKdoeamN9acZihpsBaHpCahcNP4KX6KTPjEGXp0759SYRSai99V4ydecUFzJI02
         BOCreB3OJyVc2SWaZIij2DVx01FmTiLP18EHDzSbVBjoHrk+U0tRWQzT65apWqrKdfCJ
         y+F3APa7MgMmIhdOQGwnhtCFo9X1GjjdvtGhsqVy/iZ4XW7RvOz9wx+u6OWuX7JcyftL
         fYFw==
X-Forwarded-Encrypted: i=1; AJvYcCXk+wHwbzO2CcLQw/g0d7grsTqelK/ijNPoE7SykJwLSk5sTQHZpA9oizFYFSgEwGuCi+arEF33tPayXG0LnY+AeONOgxo3
X-Gm-Message-State: AOJu0Yw0kgIaRYK7CQv0YV3KYmjhNyo9QPUQYSVEu1xpzogfE0aBmyWN
	CQn0WbQZUlB2BqS+satRWmGOKR5ZPHOEOJJfb7ppdQEO9UJdufJmfphoCMIy+T18kBxJrm7JBfb
	ASy6Ki42H4Fgob4lJo0MwNQ7V0lbFn/8SJ61oa9dqnwDZXno+Wvn82w==
X-Received: by 2002:a05:6820:1524:b0:5aa:377c:641d with SMTP id ay36-20020a056820152400b005aa377c641dmr6989382oob.1.1712663662290;
        Tue, 09 Apr 2024 04:54:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcvmCceRmvxzrkDTR2QRn8h2Ux/gr3wTqE6d0IiOiXyfjY1R5q5KrH++pZX5kiPrHqPFoJWQ==
X-Received: by 2002:a05:6820:1524:b0:5aa:377c:641d with SMTP id ay36-20020a056820152400b005aa377c641dmr6989370oob.1.1712663662050;
        Tue, 09 Apr 2024 04:54:22 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bq24-20020a05622a1c1800b00434d5c93b1csm621293qtb.41.2024.04.09.04.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 04:54:21 -0700 (PDT)
Message-ID: <9f533f4e-d703-4de7-af3f-828dc2e1be45@redhat.com>
Date: Tue, 9 Apr 2024 13:54:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] arm64: Prepare for LPA2
To: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, nikos.nikoleris@arm.com, shahuang@redhat.com
References: <20240402132739.201939-5-andrew.jones@linux.dev>
 <20240402132739.201939-6-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240402132739.201939-6-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 4/2/24 15:27, Andrew Jones wrote:
> When checking for supported granules also check for the values
> which indicate support when LPA2 is implemented.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  lib/arm64/asm/processor.h | 49 +++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)
>
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 1c73ba32725a..bab9c26c2c9e 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -110,31 +110,36 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
>  #define ID_AA64MMFR0_TGRAN64_SHIFT	24
>  #define ID_AA64MMFR0_TGRAN16_SHIFT	20
>  
> -#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
> -#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
> -#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
> +#define ID_AA64MMFR0_TGRAN4_SUPPORTED(r)			\
> +({								\
> +	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN4_SHIFT) & 0xf;	\
> +	(__v) == 0 || (__v) == 1;				\
> +})
> +
> +#define ID_AA64MMFR0_TGRAN64_SUPPORTED(r)			\
> +({								\
> +	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN64_SHIFT) & 0xf;	\
> +	(__v) == 0;						\
> +})
> +
> +#define ID_AA64MMFR0_TGRAN16_SUPPORTED(r)			\
> +({								\
> +	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN16_SHIFT) & 0xf;	\
> +	(__v) == 1 || (__v) == 2;				\
> +})
>  
>  static inline bool system_supports_granule(size_t granule)
>  {
> -	u32 shift;
> -	u32 val;
> -	u64 mmfr0;
> -
> -	if (granule == SZ_4K) {
> -		shift = ID_AA64MMFR0_TGRAN4_SHIFT;
> -		val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
> -	} else if (granule == SZ_16K) {
> -		shift = ID_AA64MMFR0_TGRAN16_SHIFT;
> -		val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
> -	} else {
> -		assert(granule == SZ_64K);
> -		shift = ID_AA64MMFR0_TGRAN64_SHIFT;
> -		val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
> -	}
> -
> -	mmfr0 = get_id_aa64mmfr0_el1();
> -
> -	return ((mmfr0 >> shift) & 0xf) == val;
> +	u64 mmfr0 = get_id_aa64mmfr0_el1();
> +
> +	if (granule == SZ_4K)
> +		return ID_AA64MMFR0_TGRAN4_SUPPORTED(mmfr0);
> +
> +	if (granule == SZ_16K)
> +		return ID_AA64MMFR0_TGRAN16_SUPPORTED(mmfr0);
> +
> +	assert(granule == SZ_64K);
> +	return ID_AA64MMFR0_TGRAN64_SUPPORTED(mmfr0);
>  }
>  
>  #endif /* !__ASSEMBLY__ */

