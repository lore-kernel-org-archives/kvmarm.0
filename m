Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DD984A3E
	for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745858293; cv=none; b=Jx4W2JaJ2sDlLyVi2Ax/F5STbbISTss22Cl/OzUFqUJ6VHjgVl5ho7TBiJHt9/OaWyKLY6PaoZjHiUyCmaXjDpaHwTd4yajXR4i9ythuiDitDTKwaU+drfuRUFG98JvzP3TbbNwbFM6rZ8P9WWwNR5tuJaRjHsNfRZErSaf+iH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745858293; c=relaxed/simple;
	bh=as0fHkDqschmmG0acy6npycklXoXqnAfzUKFccLY6/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImNdZ4/QqqKYPfwre5ilgUbxHqNAwF2NWeUnUpZw2wmOhPvRAEwgGWS/72Nm5Xj/nYpB0sVTioWzDavML7JNPkS1sNbNDaMHxpPm70nC2vTQdOWu4ORX+eJDr1zo1LsH/ZEp0GiBe1XkPzXWGTmYNN/oGEClgr72YJvnPb1IqJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eSfhlYSW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eSfhlYSW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745858290;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLeMmLBitMva57crvjAkV/QU3JbwDt0mhgNiT6DPem0=;
	b=eSfhlYSWt9rZIKmIhXoyXkzN5WpniKodgE/3d6LWl0RT8bo8f5LU5IFNzQOf+kQcBlCC5Y
	/26pw4kKz5BG6rYcPAgauMT53SI/CjDwmuKH9EAIsRj1DlmJ0luXRkgaO7732gZYCp7Z0O
	KwWEqYHoBWsf9Er9cvASRcNACzlbGO8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-ZSWZuXj5M_KTiE6vql2RNw-1; Mon, 28 Apr 2025 12:38:09 -0400
X-MC-Unique: ZSWZuXj5M_KTiE6vql2RNw-1
X-Mimecast-MFC-AGG-ID: ZSWZuXj5M_KTiE6vql2RNw_1745858288
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf446681cso28979505e9.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 09:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745858288; x=1746463088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLeMmLBitMva57crvjAkV/QU3JbwDt0mhgNiT6DPem0=;
        b=Qs5llv+DXe22oQAOEWGMIgkEP7HBYA0a5ZHZgVsLOwZ4kP8pWiRfkXfbyZlfQqZNDa
         VOwilvE9N87vbCj8VE42vjyiPysbIE71+GNeVEI82FqH/TaLSHKMCvWSR+seY/Odbrgo
         iZAXeL2ycB+jnbCIqx1OBNz74wyoVJj+bMvC1JmknSd9Ig8ivPisw4h6hEpdzs5K2Jxy
         Gv2Vasa3JXe9Z6jkpeXp5xuQyeF4eeo7M3x4/dI51W81orHjrIIwbFG06MsHsTx1uE6q
         ODiADibXN/0OOj0Y++aoMo4huSgbYRTBEESkTDhT1JtBNFe3CntjQDmgTqt7CA+6nDA5
         vrvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzgQCYpvPfg0kWBtlFYnDWhdE3vN5FTfVIAT7QWm34dOeNAJ8JObt+xIWOIjL7S/NNL2d+y/4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb5+3nhkYlW4waElrGKAN1OJbPY4lL/GcbOPh8xQTw2sHUBomu
	8A9H8eZvG9d89+mAvSRm/fwwn73bwAQ1ohynUQn2raVl/T4ixKIR+Ypni2dvjaDuW7SGiZ6cA+g
	vdPkycYlQgmFWPzF346j7TZ9nG1o4I2iymSgU0Ljn9UWKVaTaVdpf8w==
X-Gm-Gg: ASbGncs5DEHF+Gjg7C0exBGt2CuuZB/ZRkYEw+olAEnhS/uWb3NGlOoVFI/wh3HjIHN
	+XmPJr1zDME6XvoQzUpRAL/kot+jdFJ/jkDjj4iz2rAxwllBvl9jT0eKoAgrTS/bAHYutp6OIsC
	dPorSzchctiRkfFbewW1yxLmK1qYzH+ZGhliSdQa1aVf6J25SUclrJ8jI1i0AwZI6UBnusEJT6M
	cARawuWveQ8xLe4wOsFLn2TA9AEEHqykMBSKjDqLyi/ZpMTo7oyM63hGDPfgnRDRA1EaNnUp1dv
	tqlNqEUlAmH8BXvizMvEkw9yP3c7cRPos7RjsPeSn1acK6BqddzBOpn9aHE=
X-Received: by 2002:a05:600c:348b:b0:43d:54a:221c with SMTP id 5b1f17b1804b1-441ac861d66mr20985e9.18.1745858288296;
        Mon, 28 Apr 2025 09:38:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF09OX4DldWlH3xXjtGa0wqs9dyZdcDrIN5MrAKJLX78b0Nv/aKDVbTMellSTBrJhFR1500IQ==
X-Received: by 2002:a05:600c:348b:b0:43d:54a:221c with SMTP id 5b1f17b1804b1-441ac861d66mr20685e9.18.1745858287840;
        Mon, 28 Apr 2025 09:38:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a531dc6csm128148625e9.24.2025.04.28.09.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 09:38:07 -0700 (PDT)
Message-ID: <4218aec4-473e-44cc-9d9b-999e6c9e160b@redhat.com>
Date: Mon, 28 Apr 2025 18:38:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH for-10.1 v5 13/13] arm/cpu: switch to a generated
 cpu-sysregs.h.inc
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250409144304.912325-1-cohuck@redhat.com>
 <20250409144304.912325-14-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250409144304.912325-14-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JO8XNWRp_VWagUqpsH5KwTroTlwgwew3InoKFCXNTTA_1745858288
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/25 4:43 PM, Cornelia Huck wrote:
> Generated against Linux 6.14-rc1.
>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  target/arm/cpu-sysregs.h.inc | 43 +++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 13 deletions(-)
>
> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
> index 6c9f9981cc5d..02aae133eb67 100644
> --- a/target/arm/cpu-sysregs.h.inc
> +++ b/target/arm/cpu-sysregs.h.inc
> @@ -1,18 +1,8 @@
> -DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
> -DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
> -DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
> -DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
> -DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
> -DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
> -DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
> -DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
> -DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
> -DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
> -DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
> -DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
> +
>  DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>  DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>  DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
> +DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
>  DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
>  DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
>  DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
> @@ -23,13 +13,40 @@ DEF(ID_ISAR2_EL1, 3, 0, 0, 2, 2)
>  DEF(ID_ISAR3_EL1, 3, 0, 0, 2, 3)
>  DEF(ID_ISAR4_EL1, 3, 0, 0, 2, 4)
>  DEF(ID_ISAR5_EL1, 3, 0, 0, 2, 5)
> -DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
>  DEF(ID_ISAR6_EL1, 3, 0, 0, 2, 7)
> +DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
>  DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
>  DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
>  DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
>  DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
>  DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
>  DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
> +DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
> +DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
> +DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
>  DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
> +DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
> +DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
> +DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
> +DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
> +DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
> +DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
> +DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
> +DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
> +DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
> +DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
> +DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
> +DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
> +DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
> +DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
> +DEF(CSSELR_EL1, 3, 2, 0, 0, 0)
>  DEF(CTR_EL0, 3, 3, 0, 0, 1)
> +DEF(DCZID_EL0, 3, 3, 0, 0, 7)
> +

