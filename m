Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287881A2C04
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535174; cv=none; b=GcgYQs76yeYa7kUD/e2l/9pFaAgcEPLc/frb+k8IbFYa8KVMrZOn49cuiktRX6MXrXOQ7RsVEPLUglJ37tJVlPO3x9v+TKvmLMbc01MUzjqagS+fjbrGUNqnxFaiyL8akwPNEhpYSEwUn/7uqu2XIhO4L9o65rjbmj33ODB/ztc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535174; c=relaxed/simple;
	bh=DyGCkBT40L20NaH3Pin2wSf4wxZvPtFkzqxS3HqQiFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9CeNV2YRkua6IIHCml68r2p/es+6ED1eqHnaMXjM20evMcV7PkyrN6OcAn3uPPDvNajCaRd7feEdU/SQqfc5F6MiMlkpFX0KPSlfXwS/aoh50AFiaRhyDywkQRtUsYItpWZ/T+HC4nSaU4rYW3/1ebyR7MLSqLLd45SAaGDz+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z2vanNG8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2vanNG8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lJSP7v7O+oDOfPrBvlBn9hMnhyj2hpIG70qFLCRuzJA=;
	b=Z2vanNG8DMj4ADtPsqhRCylZaC+aLsQ/2ZWEGaKzI20xdqQQ+vJZpRNvti69mD0oOkUC2C
	SW1vLEJvYrAWIs5htdW8t7mOz5FeyC9WPh5fZIPqHfDJPEkBAjAkVWjOT5rxfGIghVpAbP
	dQPgB1nTg6WyMrCbi1piIbSXjLQsALc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-DS8CAKsENy-651V7846fHQ-1; Wed, 18 Dec 2024 10:19:30 -0500
X-MC-Unique: DS8CAKsENy-651V7846fHQ-1
X-Mimecast-MFC-AGG-ID: DS8CAKsENy-651V7846fHQ
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6dcccc8b035so21622536d6.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:19:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535170; x=1735139970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJSP7v7O+oDOfPrBvlBn9hMnhyj2hpIG70qFLCRuzJA=;
        b=LeXJW+n/2nLNGU3MBPhj3mdY0FiV9PxHU27/ffMxANiQPgMS8AjCP7h7KlPH+VjxrL
         ivFkqIC72L8IKSe9ZMXZkY0xImTzKmnesw6G46rCGWJ4xVmK+gy0Mgvr7hyCdYcHT7gQ
         dN0PeSfpLE+wUBphv2dkoEzbZ92oiebS1rzbQr4TJUDY0UuFfUHQv/sl32zPRFBAEUCW
         k2vEGy8PrTW+zevqbY+gIKIW9MeUOUDIQ4mzA2gG0lilRx/inRd6kETKxo2l+Mkzq0vy
         XOajFF4GtcmTBA4tfJlqBgARLgBkurowT3SrcXy5HMVL63SpW12Jahk/gxbQQBg+EqRA
         LXUw==
X-Forwarded-Encrypted: i=1; AJvYcCU1shh0qw4AZ3bNibc7AgTkjkFXQtMzqunuiYfia56UFJCZ1VtlyhBO+MdTvMdwxQIcZItlRIw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6fgigvIpDoDBMZRWLexVpUcwqEpyEM1pzl7gK4AKXWZEmoxDf
	VkZTSfhyC+zYi85JFLhwqDx6npm5JwMdgXALk7tBUfJFwQq8ZeCjm1fY2U5qR2/V8H8dGf26TTP
	ME9H1hA6iob2LrdtT7EjxzPjs/bfWhZwTCmrWj6rUhP68UXGFIiGIBQ==
X-Gm-Gg: ASbGncsACgTMxu1/+Jk9EWn0CDB/neTJqIk2FjDeibI5Bq2yKZWjae9vgnA8DlGtYKb
	1avTTNEsoL26t7lz+Lre0Jqgo+dw5KGLs3pa/YWa9TaQ/8xgTlAHpg4G3PHHpVi4Gw5UN0IvMjR
	bvXiXqRtkI7HYrZ3Z+cA3p0PkSpQiyq/AXmin/Q8h27Wd/yCDh/yVHJkNwcAnuUfmDiHjqIvVQG
	qh3AKWAFwR5jk87/nv2wjE13IEnat5EFtaLqxW1FGg2LXeNv7oFXazXhMQKqmhnCd3Q1eGCnnlK
	6tABybWN47b5uToP3/S7+gs=
X-Received: by 2002:a05:6214:2487:b0:6d8:a9a6:83ef with SMTP id 6a1803df08f44-6dd09aae408mr56951436d6.20.1734535170209;
        Wed, 18 Dec 2024 07:19:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmeRQfKzOtSLywUp/ORft5eZda7HUnNeyjbDa8MumUrqjCzsC9niZRmKtWoztYMdJy7SLsAA==
X-Received: by 2002:a05:6214:2487:b0:6d8:a9a6:83ef with SMTP id 6a1803df08f44-6dd09aae408mr56950996d6.20.1734535169928;
        Wed, 18 Dec 2024 07:19:29 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd367f7csm50865876d6.94.2024.12.18.07.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:19:29 -0800 (PST)
Message-ID: <287abeb0-8660-49b0-bf69-97eaa5bbe6a2@redhat.com>
Date: Wed, 18 Dec 2024 16:19:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 08/46] arm64/sysreg: Add register fields for
 HFGRTR2_EL2
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-9-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-9-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n-qnOHcpub6qivQAJrzitlfrE8IFUAn9rGRbQrNzTM0_1734535170
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for HFGRTR2_EL2 as per the definitions based
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
>  arch/arm64/tools/sysreg | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 9d339f735648..9513ae05dc93 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2619,6 +2619,25 @@ Field	1	nPMIAR_EL1
>  Field	0	nPMECR_EL1
>  EndSysreg
>  
> +Sysreg	HFGRTR2_EL2	3	4	3	1	2
> +Res0	63:15
> +Field	14	nACTLRALIAS_EL1
> +Field	13	nACTLRMASK_EL1
> +Field	12	nTCR2ALIAS_EL1
> +Field	11	nTCRALIAS_EL1
> +Field	10	nSCTLRALIAS2_EL1
> +Field	9	nSCTLRALIAS_EL1
> +Field	8	nCPACRALIAS_EL1
> +Field	7	nTCR2MASK_EL1
> +Field	6	nTCRMASK_EL1
> +Field	5	nSCTLR2MASK_EL1
> +Field	4	nSCTLRMASK_EL1
> +Field	3	nCPACRMASK_EL1
> +Field	2	nRCWSMASK_EL1
> +Field	1	nERXGSR_EL1
> +Field	0	nPFAR_EL1
> +EndSysreg
> +
>  Sysreg HDFGRTR_EL2	3	4	3	1	4
>  Field	63	PMBIDR_EL1
>  Field	62	nPMSNEVFR_EL1

