Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BDC384CD9
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778854832; cv=none; b=XO91WC7jldgb8NwS6bskTGAubInHXrUu7UU7syIcbQzW554t9NKIxgmjlNQq4lyAmPILiEmF6tF5vdwXEGI4EJ+NPm+0a2qKHA7SSLtyQC2LA0T7ZdZ1kyKJTTR7e9NI2qlOviadxa6gwveOzIrndzGuQrfIDlrSK9knvh98Kg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778854832; c=relaxed/simple;
	bh=kLvkcaSaVivsDM31UsY0OiBAPIocQlbWGOkmuWAYDt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOh8+OlIB1y8HG0EuwCGxMdGmrE4pfYMD1Vip+Wa8kcXzgcjOy1I4pl1j0LYcYiFWB2Ln6WyXt8nFbKo3FRm1sA5smCnAY0iZziXTbQF6r8NqRwkNCQ8Xvx2CxCZlpQDdtYFWTCIGy5Q53g9sZfR8GDNXA3vU545CSulJFT24IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rvd8DAuE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rvd8DAuE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778854830;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3jJlzzgpDRe0nKg33oaFu46l0y/vmLScvSFm/S/f5E=;
	b=Rvd8DAuE4yDepU0XyeVknf7GO9mT0+GHm2ytRBFpKXiXXpW43Io0f/AHMJzESXYip22Rp3
	9GUCTXjlosXBQ9nJceC7QtvWg3XA6MVJn3dIijdfqx9NuY5zCURBW6BqE54z4DBLKJxTZH
	IuEu70LKkie64K0Xlga8auFJPrYuKSI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-jQTpI7lTM6Sr-iI1NOTr9w-1; Fri, 15 May 2026 10:20:27 -0400
X-MC-Unique: jQTpI7lTM6Sr-iI1NOTr9w-1
X-Mimecast-MFC-AGG-ID: jQTpI7lTM6Sr-iI1NOTr9w_1778854826
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso64831025e9.3
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 07:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778854826; x=1779459626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3jJlzzgpDRe0nKg33oaFu46l0y/vmLScvSFm/S/f5E=;
        b=J6d+mepJUsFm9HBiYra/MzQJATeQc6ZTe7PqvmB11G4GwF6eDBqWftbQp1Gtd8fnJe
         MMkG4IdpCF1iHP7omt5s9IP1vUoH8pb584W2/7+mqu3vjyf1MjDv/ii4R/vMj0C7UeIa
         cVIOpi1/AzmSTL74tDneEXad2gKoLrY1EmUxLwfGmyojrMs9AY3Qeexx86GoPZRwxEF5
         U6ppP8tx+0lzbYDAuQCYmpuCxH/gJygcudBoqDR2R3TS8I92RxzXUDfqzKOO9d5InTgd
         hlp5/fcwepdaQg5gjAEp8m311KZbcpq/hkqkGpZubRwXI/msECN1JfNkaPg+Ns/QMTTL
         JyUg==
X-Forwarded-Encrypted: i=1; AFNElJ9yx7PHb34gTyyn/VZzQUFmMQ3YAf2inUQqTMlqrYoxNu5bQeKabAWDhN5xIIKxLyb5TjOdLhM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw0NJ2jDdF/l3QyktLgyfEsfG7oN3A7HxjeIqBcYK5wqYoYiC0
	R9DysV3QIm0ANOqX8w2G9NAcbGgb/ws9n7sLgPPx+EDx+D9d6198Qr3aIMNK24z/Heb2aEWLtt8
	qWzbosRGOsXUTeKU21BLhilR/71BHdW6jgqvYmb+Eh9YMy1IDqpshkRB4dA==
X-Gm-Gg: Acq92OE+Aw1sqUd10QjvVRbyvzKX1T/WkTRFh85v8QrAvUhWoas25wBud1f7cT2pf35
	B/4B3QtHObDiLOhyZNO+W1Ik3Y/rUuhCd8AHGQFURdaKxkGskz83B3VX3iJuYm84CjhrGmMjy6P
	D6HTnvvOwT+au9N6681/08jxFtzxHP5DhFwdDwoGGQyUrgdSrsP7r4z6XSHhAEOGPAXlLt784Qf
	X0dDR2+3pCvlpEE9byqlNwD0GvvVp9iMObtjLhKV2FpLeZ0S1mh6QkA1SpmF2R8FrYuVO0LjmJ5
	x+Iowin/eUjf47eI7LMEirlXDXSWJ5bbOd9N71U7C+7b6W///YefGeu+dux7OoE5NlqzwHkRhrN
	6XiK/2gb2/OhQjKNBQ+E/f6/xBn09hqybHAPmDyD9QhIJQ5LQOCLNmteHNhydwv0p4+3WDIU6cE
	pvHUfl
X-Received: by 2002:a05:600c:46cf:b0:48e:8974:c377 with SMTP id 5b1f17b1804b1-48fe6626ba1mr57267205e9.29.1778854826009;
        Fri, 15 May 2026 07:20:26 -0700 (PDT)
X-Received: by 2002:a05:600c:46cf:b0:48e:8974:c377 with SMTP id 5b1f17b1804b1-48fe6626ba1mr57266545e9.29.1778854825433;
        Fri, 15 May 2026 07:20:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48feaa2c96csm16508605e9.2.2026.05.15.07.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:20:24 -0700 (PDT)
Message-ID: <a2e9e975-5fc0-4045-bbdf-762c4809b704@redhat.com>
Date: Fri, 15 May 2026 16:20:22 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v1 03/13] target/arm: named_cpu_model: initialise
 additional sysregs
To: Shaju Abraham <shaju.abraham@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
 skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
 Khushit Shah <khushit.shah@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-4-shaju.abraham@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260513163356.3033159-4-shaju.abraham@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ExToHKOolqd-jUq2pcHCEhJCHOv9i27hGTQvDfN2VS8_1778854826
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/13/26 6:33 PM, Shaju Abraham wrote:
> Add entries for sysregs MIDR_EL1, REVIDR_EL1, AIDR_EL1, ID_AA64PFR0_EL1,
> and ID_AA64ISAR3_EL1 to cpu-sysregs.h.inc.

Can't you reuse
[PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with automatic
generation

and associated python script to automate this. I think it contains all
the additions you bring here + some others.
for 
Eric
>
> Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
> Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
> ---
>  target/arm/cpu-sysregs.h.inc | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
> index 3d1ed40f04..82a83d9d5c 100644
> --- a/target/arm/cpu-sysregs.h.inc
> +++ b/target/arm/cpu-sysregs.h.inc
> @@ -41,3 +41,8 @@ DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>  DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
>  DEF(CTR_EL0, 3, 3, 0, 0, 1)
>  DEF(DCZID_EL0, 3, 3, 0, 0, 7)
> +DEF(MIDR_EL1, 3, 0, 0, 0, 0)
> +DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
> +DEF(AIDR_EL1, 3, 1, 0, 0, 7)
> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)

