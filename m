Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1621DFF7
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536050; cv=none; b=cCakmaJOOLaELczJ6xVMz10C+RNwUK2gn6+Gy6fol2hJF9pKN2bq/G9yaMo1xQbHAuPUD8dKOow512eTJmHniixIKjeGUAUYgkmv4pqqF8VkmsjgLzsQ5jhJXcGeCC5VF6717ITbQfRZpMbu7s+p9Pq3D4a+QD5eU4LFIG+ee8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536050; c=relaxed/simple;
	bh=vNunLoghXHc8eidYl+9OKwDxs50R9VkoEPloglzr7bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qpc96Awm6BULTjBacgTxv8HkHihe6RCIouecWdhNfDG5uReOHYDCQ558Vv5Nr1croMHBD+ZxebEd3nhiTx/PwThgQy+eqv3avQvvU+ti5SOgjS6LnIwFlknHyY8tV6sZmLvT2PunUnpNFApdL6I7HgENTnc03hY6wl6TQ+5g1Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dKFj7VBf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKFj7VBf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734536047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ifEMhcU1n3ISsit8wDhT+/ZW4vWfULUicoIZW1rhC2g=;
	b=dKFj7VBfHhDnqYMnoGierfmyC/rjxL1XbStuxw7NZC4mQDavADfdy0azxaDCMrRHOXH3H7
	+lAy8nVLKJhyduxnlW7dqcZWvSUAy//DAEPO2EN8LE83baSyHu/jeTi2/k1brMi8+4K8kw
	DsLJRNhB5OQVD+ylyCaXdkXZ3xhyRBQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-GOFjBH0wPoWv9Rgt0OBcLw-1; Wed, 18 Dec 2024 10:34:06 -0500
X-MC-Unique: GOFjBH0wPoWv9Rgt0OBcLw-1
X-Mimecast-MFC-AGG-ID: GOFjBH0wPoWv9Rgt0OBcLw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e03f54d0so3036788f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536045; x=1735140845;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifEMhcU1n3ISsit8wDhT+/ZW4vWfULUicoIZW1rhC2g=;
        b=hkP8uKJ6/QKWp+mxh5IAQQr0bU0E06cJhYNs/0UT6s5oOFqdjN9sEiY5HFQ2zgdbeo
         if38VN2BljFvTMGGj6I36dh5teXuzLQ4U9Z5O9e6lS5uYdKIiJ1d8yPOmJfib92G39/k
         vDSJAzydK0VuaMqph9Pr/VZyRShlYV3dAnSLW2jttptmprx1s6Sxb+oloepdshSieZqO
         2FQUXID70mTaY7FVJ/HIn4yCtPSTef/fe9eZ2NR6QHr8GwAKpMoCDyKfO6+QtljRr8L6
         1/V+l2spcBnbWf2Tq7YoKckIEj3LEMakQQQ2W46hmf7+Jx0XinT+XL93tK5BJn2tJ17c
         Us1A==
X-Forwarded-Encrypted: i=1; AJvYcCWGDmklLIF5iVhfoaI98M18TETUgkWIKMwfLJNbeFYVXqO5eUwlXPpHAKifX3brZIvm5oagR10=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7Atm/aB8HSSQp+Fj5bYhLi5jHLWuKvds4EiPsYpOTSGACt4+w
	vFwciNi8u4ElJuH/BGqURAsye6rH2NMd2N4DFInWfBl4IYlGLl5O/G9gea1rz14UxmmxGkFW5Ej
	Pb0h4+lh708dYIt5u529SwwSRuEWUBMH6gUKRyuEbiTx1APSNyy5fqA==
X-Gm-Gg: ASbGncsgxbnrCgBmmOJYsPpNpuc7rIBlf2E+Cue8xvEq4EfSakokb/mI9fqDC9xBpjS
	y2zoHKcecwOGfcHAapqjdVKm24wiWqDIm4Zm6eIMAsobN3AklotFub/+7UkwRFJzHX99Z0sI3Au
	MIgDbhCIRYG9YWlNh+1UlfaNBHLEwbkWFyUrnRKbE+Z2LW/VJ31zRuFKwnMFGiBnC7zlWiVxrVD
	QxEeVqGGeJSVoF/njrlWt2lco2GBuDN/fgxKv8mw9lFOAYL5bu+SuXjQuro0Tm/9XL8alIT4cU4
	dm9VvssFTlaP4WbeqZazALA=
X-Received: by 2002:a5d:584b:0:b0:386:41bd:53b4 with SMTP id ffacd0b85a97d-388e4d5d2acmr3052369f8f.34.1734536045513;
        Wed, 18 Dec 2024 07:34:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHt71tuGORM7SCqa7JhgofooWAxdG1yrRL2hLTblveyS51eHb2FdxJIqS5eQRiGmCePdssbNg==
X-Received: by 2002:a5d:584b:0:b0:386:41bd:53b4 with SMTP id ffacd0b85a97d-388e4d5d2acmr3052345f8f.34.1734536045192;
        Wed, 18 Dec 2024 07:34:05 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b1a195sm23441825e9.36.2024.12.18.07.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:34:04 -0800 (PST)
Message-ID: <345a1627-edf7-40d4-a4a4-a7c00b994859@redhat.com>
Date: Wed, 18 Dec 2024 16:34:02 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 13/46] arm64/sysreg: Add register fields for
 PMSDSFR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-14-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-14-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bIQtOhxnoG7T7mWoMAeZgHjbPFgVk7CnU18EO5wqWVw_1734536045
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for PMSDSFR_EL1 as per the definitions based
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
>  arch/arm64/tools/sysreg | 67 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 78564b24b187..fcb4ecd85d35 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2245,6 +2245,73 @@ Field	16	COLL
>  Field	15:0	MSS
>  EndSysreg
>  
> +Sysreg	PMSDSFR_EL1	3	0	9	10	4
> +Field	63	S63
> +Field	62	S62
> +Field	61	S61
> +Field	60	S60
> +Field	59	S59
> +Field	58	S58
> +Field	57	S57
> +Field	56	S56
> +Field	55	S55
> +Field	54	S54
> +Field	53	S53
> +Field	52	S52
> +Field	51	S51
> +Field	50	S50
> +Field	49	S49
> +Field	48	S48
> +Field	47	S47
> +Field	46	S46
> +Field	45	S45
> +Field	44	S44
> +Field	43	S43
> +Field	42	S42
> +Field	41	S41
> +Field	40	S40
> +Field	39	S39
> +Field	38	S38
> +Field	37	S37
> +Field	36	S36
> +Field	35	S35
> +Field	34	S34
> +Field	33	S33
> +Field	32	S32
> +Field	31	S31
> +Field	30	S30
> +Field	29	S29
> +Field	28	S28
> +Field	27	S27
> +Field	26	S26
> +Field	25	S25
> +Field	24	S24
> +Field	23	S23
> +Field	22	S22
> +Field	21	S21
> +Field	20	S20
> +Field	19	S19
> +Field	18	S18
> +Field	17	S17
> +Field	16	S16
> +Field	15	S15
> +Field	14	S14
> +Field	13	S13
> +Field	12	S12
> +Field	11	S11
> +Field	10	S10
> +Field	9	S9
> +Field	8	S8
> +Field	7	S7
> +Field	6	S6
> +Field	5	S5
> +Field	4	S4
> +Field	3	S3
> +Field	2	S2
> +Field	1	S1
> +Field	0	S0
> +EndSysreg
> +
>  Sysreg	PMBIDR_EL1	3	0	9	10	7
>  Res0	63:12
>  Enum	11:8	EA

