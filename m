Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557EF1F37D8
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734532840; cv=none; b=KJ7/4rHb2q9AAoPQlYv2AMYmWdmjwq/ROX6ELHZ/G5TvKQqsrRna0AELi81nbi/jSucnH8E/DIP9u1zUApT16myLHBasea542EwU7N/9Sx3yFbR+m3UpUeETvnqUoZlXNobDFs5WvuRWiDgZOAvBJdXv8Oy2S5TkR3S1JpUN66A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734532840; c=relaxed/simple;
	bh=On7esrJGqG9MQgjgYogAYKFVkxcz5jjKUkBEs0oMSCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mwNNv+QNkbxV2ki99RXGdjGt1uId6BsNcMGZTL7hTonIy85ER/g9y3UPH+F2cL3t8cDzjPrnJ5ktWyB5sODtEnfTwVawsFApk6UtisHODsoG4RJbQpBhV7d6sgTiYHzyIwGM6WyuVmwVpJPRK0JPRbSCnpoxW6Pv8ESmNr8cyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nbw3tNTA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nbw3tNTA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734532838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JEcPzUK9cX5iNorTqYb7eanK3qwkXAuqANfm0OCEeZM=;
	b=Nbw3tNTAya+UZYgnHycUDu0OSPzfohPBDql9Ov2dTtS9wvtbmorG/9IHVSN5YqTYJ61dnb
	D8KRw5P00ErbAppcqTyiADnvyKpIukfX65bR3Joih10BNbht68Nd0pZM4BecXsKGe/75EN
	+UNYT9J8wQGyy7khFc+RRD+y79Rt9FA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-Qh-C0Pq1NYOE3gA3_xzwxQ-1; Wed, 18 Dec 2024 09:40:37 -0500
X-MC-Unique: Qh-C0Pq1NYOE3gA3_xzwxQ-1
X-Mimecast-MFC-AGG-ID: Qh-C0Pq1NYOE3gA3_xzwxQ
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d87d6c09baso97348426d6.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 06:40:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734532836; x=1735137636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEcPzUK9cX5iNorTqYb7eanK3qwkXAuqANfm0OCEeZM=;
        b=s+kk7MF8W4IC+uaBBzUY1dkzfHVZOlEpUG8NWVLETekSm8y9DJ78cPBoWXnXWxccfq
         297sTiFHPOK5alZgJrYUF6fZFt2JV0D3nGRMVCiWIDMhFnudwAv23FDiTeo0UN4msqyJ
         Rw70XrlIXqE7UEbZeQHhHr716HiT+uGTxnQ7ffro7Yuh97dqt0KgHmBahBK2w5aDUOoz
         7T/QEn/TX51a0fA54QWxZl5RvKuB+Ie7QnkY1ElFNzDhos8v8KA7mAzdNSWInE1T1Nqx
         NEwdleubwJNPqT7eLujteQyiwDBb2OUHsj69UFHMdz9cAASv/SsF0lo/KMpjXSv8Sp6r
         7UaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwgwDR/HZAJ2+VjvhwLJM/ojRJ4Ia10yuhyWkUqcgOK+zNiq0Fe4jfxO4eyYrWloyOVWrAx88=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+DmvlOTR3kff5OXWg4UZrO7/XUFGA5xtBPCgi+nLFS4yUlaBE
	YziSZnRQu+7voc9c9hN0AfexsR3BDMUNCXadMHmj5VYU633GMvgTQROFFcKVzxOWcJdx9GdM9ZU
	FT5xSF65sKWxuaK7cS04rURL50XPamXIA3dO2fAacXJIEMfnTvq9g2A==
X-Gm-Gg: ASbGnctpQw/Q6xAxgoB62XxEGVOU/NEAZvqIFmCl/J0Mv7slpXzDXY3/kEpxiNEIgXR
	rmJcFeQ7AYeEzgKxxm1zV8+PvVMpzMmzu3IhM56E/bfQMQ5rO2X+exGI8IAG+H/70uppbiB+hET
	0COKmL2QcBFXH1YoAOOB8Kic+z4kU3UhX+B8cjfaFH8wQgoVFEJU8BPtFhVyVPe4+C8IvtPzJqj
	9F5Sns9y7vEiKwLC3ACB9GKZEwHgcnsi2vVycPh8C6wCpTrGt3GaaPlhLgDNqCGE2pHiRk4OYLo
	3j2X1pRHgJTsfSqGbk1ZNDM=
X-Received: by 2002:a05:6214:1313:b0:6d8:d240:9f26 with SMTP id 6a1803df08f44-6dd091b09b3mr61206096d6.16.1734532836555;
        Wed, 18 Dec 2024 06:40:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjKpesR0qBccdpuFlt/EcrpLX6QMrNSuC3s3ippH3bVwCaymC2r7amx4iBAYxtx9xueQvbSQ==
X-Received: by 2002:a05:6214:1313:b0:6d8:d240:9f26 with SMTP id 6a1803df08f44-6dd091b09b3mr61205786d6.16.1734532836255;
        Wed, 18 Dec 2024 06:40:36 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd3a4c5esm49404806d6.131.2024.12.18.06.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 06:40:35 -0800 (PST)
Message-ID: <283bed34-4fe8-4c8e-aad3-b6d7f2e1a0bc@redhat.com>
Date: Wed, 18 Dec 2024 15:40:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 01/46] arm64/sysreg: Update register fields for
 ID_AA64MMFR0_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-2-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-2-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hROdUnHQENx7liEGfjfmpkDo5WWUK4MHANiYGGVkz_s_1734532836
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This updates ID_AA64MMFR0_EL1.FGT and ID_AA64MMFR0_EL1.PARANGE register
> fields as per the definitions based on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arch/arm64/tools/sysreg | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index b081b54d6d22..a6cbe0dcd63b 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1591,6 +1591,7 @@ EndEnum
>  UnsignedEnum	59:56	FGT
>  	0b0000	NI
>  	0b0001	IMP
> +	0b0010	FGT2
>  EndEnum
>  Res0	55:48
>  UnsignedEnum	47:44	EXS
> @@ -1652,6 +1653,7 @@ Enum	3:0	PARANGE
>  	0b0100	44
>  	0b0101	48
>  	0b0110	52
> +	0b0111	56
>  EndEnum
>  EndSysreg
>  

