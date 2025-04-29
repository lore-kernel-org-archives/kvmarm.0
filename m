Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E924395C
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745944036; cv=none; b=acV/UEY3nQ5k/Zc8LtSrM1v2ffqXkku+aurn4yngP4/BJEW+9wF9TaMfM+Igefbodon97pnbz7gv8A0ARxoVmDtXVXldccZUDTCeAnzdbq+PmzasHGMafWM+EbHrRlsAfmPmQthSIgTjIFDbSgZgLyr9MVQxFlIVMk9WEiXmw6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745944036; c=relaxed/simple;
	bh=icNnKrcjitENKnMgt+/1le49oHXtDjx9Ve3ZsEsYyxU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UVjFrVzXt0qp7wh6kH4PBgkKHvkff2joV2nLtYAW6o2upiZempP3WsEW+peRTF3EyE/sAIlG/kfMVGU2Nn3m5H4COJW7i8XbKJxA5yHP5vj6KKLAm0OuQghgeepXHeC/q7KG3/kOnPC96/zGgoOhWxKnMWM/zqFjF/91I8txdRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hodh21gH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hodh21gH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745944034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l50atMCuK0a/t6+OSsjycsY+3SVS0yqhWVsTT+GbMRY=;
	b=hodh21gHXwz0/EQmvEK6feMN9jSKcRW9hDEVgxTjTSTmjOR/hnf4T40Rgi4s5QBXAkzz7U
	tSvNt5HgeOepS5tcgy/1FKR80p+H2xy8tSOt4eAKIng/XUndojuwSyDUCXIpg5E8ipeGto
	Kjf8CXARCI/m84+vKV1CqRhWB4+HmAI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-u__zSRCgOMq79Qqe3uwIDA-1; Tue, 29 Apr 2025 12:27:12 -0400
X-MC-Unique: u__zSRCgOMq79Qqe3uwIDA-1
X-Mimecast-MFC-AGG-ID: u__zSRCgOMq79Qqe3uwIDA_1745944031
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cec217977so31187325e9.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 09:27:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745944031; x=1746548831;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l50atMCuK0a/t6+OSsjycsY+3SVS0yqhWVsTT+GbMRY=;
        b=BPYkuAxP1O8TtjWYSvJqpqhJ4UbUbiaWH0vSwy0sn33bjViuQ28EsTMY4s3hHme/+k
         G0ZBsBlG5QdZZE1Flh0qydPG5+/l/ck5JKTr/69RXgTDtJ64JbZ/3/WTbqoWfMaKX6Bi
         L4EF7Lf4uBQ31sFbGDsLqfs5BrLwCbtjotPEWucz0sDS9TbZ3jcmZH5dq6qB02F8Iqlc
         jM4IN6TcHwRCF/MynEtVtGdR+AzCK0BM0AQ1d4IuNj30nZFpFz82pWO4TyN6m/mVclq6
         51OjLJs+WrDzWQPO2T+DHHJuVVTukpX4brBKZ7HwGLHV3X2UNPTO8uKSGVcf/pkAjEdk
         RKQA==
X-Forwarded-Encrypted: i=1; AJvYcCUeoeEpMGJcqdsiriScnn4noeharUerb8wwzn3mtZMC+eokIlB2EP4kJovmxtUJGG7m3mDQn2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyafWJ3B1DGmWnhKReFPaAlwclytKD3qqYtqnj+C4EsqHhiB9r1
	Jq0SRi6KSI12JRTE9JUFCt6S6uHrFAFQrNGpVwimXDdKqMNmUwvwxeGK2m8l8tbZV2oJWmWoarx
	+9RpSaIP6hnP52WY4rYm9UWAtqxjzeceYGdQQEaCffMyA5vDNemTS/Q==
X-Gm-Gg: ASbGncuPZeQLWSVMvwsgUrh7F9NaOwBxE/3oX9E8rZ0f6Hxeq7QiZ1aAd4LMLlNRchS
	fXSoWrT6CF642fwB67EI6hiCrHplr4jmL1274odaUszqOTv/3rRX8XHzn9vYwfSS/WwF0B0YfTO
	K1R3CIJ0vEC1B3XXNKWZsll+JcynUz2tM6QX0hoDWA/1IVhBwRs1Kd2+Grpm04a/6Pacc/9oEdo
	TZRw57F6FKO+Le1BoPpp4T5veOv4pT4wE2pfgVxs72rDzSfLUl5MKnvW/lEeTmCeQLu65GHpEsa
	szuXtVZpxtRGOqG7ezAe3I911IzVzv6WD1+gokzPt1NXhmMlIcfZEMaTTl2M
X-Received: by 2002:a05:600c:4f8f:b0:43c:fffc:7886 with SMTP id 5b1f17b1804b1-440ab7aececmr117307575e9.8.1745944031420;
        Tue, 29 Apr 2025 09:27:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuUSzhkKqv0CBZmumvxFVHUHd6z0kkIg62q2bNYagDKXU1xaQJccG/XSf0llsSSRxcQQTkcg==
X-Received: by 2002:a05:600c:4f8f:b0:43c:fffc:7886 with SMTP id 5b1f17b1804b1-440ab7aececmr117307275e9.8.1745944031090;
        Tue, 29 Apr 2025 09:27:11 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a53044b3sm160787565e9.15.2025.04.29.09.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 09:27:10 -0700 (PDT)
Date: Tue, 29 Apr 2025 18:27:09 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
    qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, 
    armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
    jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com, 
    mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 05/10] arm/cpu: accessors for writable id registers
In-Reply-To: <20250414163849.321857-6-cohuck@redhat.com>
Message-ID: <bebefcad-d9db-a2b7-ab69-8eed34b9e63d@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com> <20250414163849.321857-6-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O3Kur4WPmV2ZOOq35kpR4di3Z3LpmNiXNw5Ex2h6e6E_1745944031
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 14 Apr 2025, Cornelia Huck wrote:
> Also add conversion between the different indices.
>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
> target/arm/cpu.h | 18 ++++++++++++++++++
> 1 file changed, 18 insertions(+)
>
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index bbee7ff2414a..775a8aebc5d3 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -876,6 +876,13 @@ typedef struct IdRegMap {
>     uint64_t regs[NR_ID_REGS];
> } IdRegMap;
>
> +#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               \
> +        ({                                                              \
> +                __u64 __op1 = (op1) & 3;                                \
> +                __op1 -= (__op1 == 3);                                  \
> +                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
> +        })
> +
> /* REG is ID_XXX */
> #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>     ({                                                                  \
> @@ -923,6 +930,17 @@ typedef struct IdRegMap {
>         i_->idregs[REG ## _EL1_IDX];                                    \
>     })
>
> +#define GET_IDREG_WRITABLE(MAP, REG)                                  \
> +    ({                                                                \
> +    const IdRegMap *m_ = (MAP);                                       \
> +    int index = ARM_FEATURE_ID_RANGE_IDX((sysreg >> 14) & 0x0000c000, \
> +                                         (sysreg >> 11) & 0x00003800, \
> +                                         (sysreg >> 7) & 0x00000780,  \
> +                                         (sysreg >> 3) & 0x00000078,  \
> +                                         sysreg & 0x00000007);        \
> +    m_->regs[index];                                                  \
> +    })
> +

s/sysreg/REG/

Also GET_IDREG_WRITABLE doesn't seem to be used in this series.

Sebastian

