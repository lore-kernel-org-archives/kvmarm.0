Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DE034CDE
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 03:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344447; cv=none; b=u6yKX/DHpQuS+kJjkCmvxW04Kci+mYHK/yxHv7z1xdxN39tnz8M5bNwQaDtoatMOe9GCZ5dzYeKV7YdvR7d86UIsapc5MDmYRfaLMYypyR/GWk4KKu02X8IC5XzpHKvWbep0UMGQAUz1qrwIbYWZmUdMzhEyi+cnF7Jkdy4NwaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344447; c=relaxed/simple;
	bh=46nf+9knjoYuzqSmQelp2hgtcQEYzrUzEFvyH4C/XpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i6lS35uVCzAm1PF6qBuAaFbqVgdTT4E8KYftBJCNfrFgXAsDaW/KXqM+RaBmCcIBA5fp+q6vjFp2kLxSm/99UYW6zauwPDhrosIsB8FmwJSYCW70LxiQKd8lp5FbO4DYsiHqTgZQlAGBifZ+s76yu8GbBpj2xCsSVBovEf3bZbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKYfvaOh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKYfvaOh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730344443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cTKGoVCMzkDuH8fl/VeiFRqT8A+kvrBX0o55Pxkty9A=;
	b=BKYfvaOhZtp+EOzDCvNLxXqP0k6Zjoz0gjAXqiBov4xDbvgE+0merfmCEESxbSuf3pcZWO
	mf45SNVj2VVd0wjomIxJRe4P6iNrEzwgff2Q26jBImVb8KdXqRMSbtTAFMQIQsO4HoCZEb
	78jUdUk7S6FNB6cSQMiwQbePCvOAcPU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-1PQhDRiOP4K8UoQBmL1BoQ-1; Wed, 30 Oct 2024 23:14:01 -0400
X-MC-Unique: 1PQhDRiOP4K8UoQBmL1BoQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71e6241c002so477259b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 20:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730344441; x=1730949241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTKGoVCMzkDuH8fl/VeiFRqT8A+kvrBX0o55Pxkty9A=;
        b=l9sCncrKjNM6+VWJonM9HXtMezeyhDFuIwJA35hfhOcgX8SSfH2iRSPVTp0NXvFu/D
         /9FtpbRjFSakIOHM1aPZwniX49euWCQhOOtUNPAxd31G819NcFzs0wPFK0xi8Lzk9USh
         232fkXRMcZ8GPN2dA77iHnmTN8eE52IAYT8GHmOqQgVUpNQ7nCzsn0vhoiVfg6rRMwG9
         WdiMD/RRyMean1rvdHpus8zMulMvFWfg+fY536jbWuOHvGPevTC7W8ahJZJRePn8F1a7
         iKO1J2hVhEVvPMicxdaU391LbrxEFDM+gxF3y9PmaPiSsbG7mWkBGlhiudyufQsCI5Lv
         ls/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXb5zB+paouBqo0zSAAU0+6bVhFMVv4zrjpkHXsUA/THBrUIt9n/2o8gODoel2hsQkMwKMP7GM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuC2uqfkMlX1XhowiiywWMGzdwl6ilsOxGouJGqJnGfs27PpPG
	1ozobL3LysTLUUEGDxVqaWkm2cP621Ne9LKyUAA36qDj802jM2ep0pIznhlVryLLtsxat4HtBgY
	vPgj4bBrAp4NTedKVVYYS7mllHB2F2iyEqz7uFQnwZTv3vgaPkIsKcw==
X-Received: by 2002:a05:6a00:3cce:b0:71e:6f09:c0a8 with SMTP id d2e1a72fcca58-720bcf7cd87mr1439885b3a.10.1730344440767;
        Wed, 30 Oct 2024 20:14:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIm6yUfoX4+vV2bezpidPQJuqYiQkZymlRrV7eXlScNtQU40n2VYP2jaFihtlrXexOAiLh+A==
X-Received: by 2002:a05:6a00:3cce:b0:71e:6f09:c0a8 with SMTP id d2e1a72fcca58-720bcf7cd87mr1439851b3a.10.1730344440367;
        Wed, 30 Oct 2024 20:14:00 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee452a7f5bsm315261a12.24.2024.10.30.20.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 20:13:59 -0700 (PDT)
Message-ID: <1d96caa1-db0c-44c1-9f10-e7d94f80ad90@redhat.com>
Date: Thu, 31 Oct 2024 13:13:53 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't
 completely ignored
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 shameerali.kolothum.thodi@huawei.com, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
 <20241030160317.2528209-8-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241030160317.2528209-8-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 2:03 AM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> The ID_AA64PFR0.MPAM bit was previously accidentally exposed to guests,
> and is ignored by KVM. KVM will always present the guest with 0 here,
> and trap the MPAM system registers to inject an undef.
> 
> But, this value is still needed to prevent migration when the value
> is incompatible with the target hardware. Add a kvm unit test to try
> and write multiple values to ID_AA64PFR0.MPAM. Only the hardware value
> previously exposed should be ignored, all other values should be
> rejected.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   .../selftests/kvm/aarch64/set_id_regs.c       | 99 ++++++++++++++++++-
>   1 file changed, 98 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

