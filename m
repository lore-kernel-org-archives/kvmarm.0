Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C861BEF77
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734533135; cv=none; b=rUv+TaiOqHoxd+N8klfhola3bGGm1AiXHtLfRDlh+sp4yJKJ7hWbnoYNJcnHrxTcl8+4ktvf1Olb81Osj+wW+pxxg5v2o0CL3e1la6n/GmA3ajfSIRbVAHDLtUlcFzsAoyyaCrcfFjaLliVk8fomLyLXNhprpD7PfjFoysOpqdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734533135; c=relaxed/simple;
	bh=+Krt/4MoR5jfmROSX8kzlXcAehXxRKPaqAf02q83Fow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BntqxDd9XwtzDmEXyXTC/8wHUNOfxsSmkC7gakrdbcKz5QzxELPAmbSD+oyyX6+bKEe6A9BfLGsJ4uDOgjJfgPhKMzWVDTcwLTz/JSGc8oymxIAJ2+8/lHligupH4cFjkA9gX46xAe+8q1q3I37m4hPEpsPgzqYkVUahvnr7SeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E+13snnT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+13snnT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734533132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YmRqWPf6A/v7vancMq2qxbJScL8pAxI2UCO46uhFd0I=;
	b=E+13snnTPTbZc3vmMmsKWPY9Q/7yvYTvs9v81b5AAv1iWUJWB0fcDQhONAx1HpG+UemGvN
	zEzM/xdQrY3dpvGBXH5W32g9aV/10Dir6qBd2libz78M3VkZt4g4dQRj+oqdKXSRrV/Jsy
	mfu9wGsa+eS1Blq0NSgCR95aywOK16Y=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-Rb5-pnfdNfmNHpAucoFAyQ-1; Wed, 18 Dec 2024 09:45:31 -0500
X-MC-Unique: Rb5-pnfdNfmNHpAucoFAyQ-1
X-Mimecast-MFC-AGG-ID: Rb5-pnfdNfmNHpAucoFAyQ
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d895f91a7dso117647006d6.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 06:45:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734533131; x=1735137931;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmRqWPf6A/v7vancMq2qxbJScL8pAxI2UCO46uhFd0I=;
        b=AHroXBpwc7H1S4Syy9fjQi5U9xpQKvdC+t+Y2g/HLcArYTBxrtF0lTpxz9pdCLPwCZ
         hvi4tjoKJkpbenT/rV3R95p7C+zPcdav+MwI2IyEQAFuZARUtL0kmMYM/tLlxeQyZXD+
         7FHb9wedRikCMLjf1xl7haoiSHAavtqDfu3GnPdiDjyQxq+ZgYfjLpGLBa6W9zQvgI/x
         CPPTRGOQnK5/UAFqU8rnqsLhiWmbLSXMydK2uBFAEY+Q1DSGfJY5w76Uv+viAUO27xLQ
         eN7ASBQstBW/2xetx1ImnotAy175k3ZoHgUjwCHAIh8d4nap0uP5HoMBpOXGvUJTTAAm
         ZwJw==
X-Forwarded-Encrypted: i=1; AJvYcCWDxp0TgvXukiwnA+F3/ZTcO+RcaGh9VQs0d+MzrBMmpBsgge8R63yzyDOvMDY4h3kC0dzrizY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXJQjC6e/motYseEGZg+hzhQz8+srZ4IXdxzdwPjNPqvOQnwJL
	j+oVdkvltjRvH6yU39cUMp5aziBjyg4YxwIQLs5Nj033LASp82cXJCq9iNYq8nerw5TrWcgweKJ
	MIRZui2sEJyaV0faSgutuQ8jDDxEZo8ifv1LlaKco3bSYF2fX+zGWgA==
X-Gm-Gg: ASbGncvagxtMbUoQmnrG3kB05nJ1pwUYwx6sTf4lnGjcRNYq3jqW9H3mVlwnmo4KHa3
	yqje6xxZHsXI95nECR0beTluqn47JLhywX8PvKqktCWqLh/8/q3JEwygKM/w5iPr0UDW3EHHpK0
	7NANyL1n3KX6Cxcc/V6dFY7nnu+CvlYCpRlrixzF7ezR6Bp+Jj1grsp4B2gxBe5oKf31HMn9+h5
	otpqd0vrXpNniVy15q4hhdeH4RIlE0616m183eM32/TSl8x+RQ/MFZvg3q3tHhJDaZSjMbAZWTq
	DF+/mwr1Vh5ElVI3fn7Ektw=
X-Received: by 2002:a05:6214:c8b:b0:6d8:a48e:a027 with SMTP id 6a1803df08f44-6dd0918ab11mr56278606d6.2.1734533131250;
        Wed, 18 Dec 2024 06:45:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFWttORJMCyN+iMJ3WRwzS7ARy8gEQ5YZOy4Oer475wIqOW3FCeQiurtncC5G/NEy1cejOHQ==
X-Received: by 2002:a05:6214:c8b:b0:6d8:a48e:a027 with SMTP id 6a1803df08f44-6dd0918ab11mr56278126d6.2.1734533130927;
        Wed, 18 Dec 2024 06:45:30 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd26e426sm50550396d6.64.2024.12.18.06.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 06:45:30 -0800 (PST)
Message-ID: <4734d430-1d07-41ab-8679-d1fc39cebdf6@redhat.com>
Date: Wed, 18 Dec 2024 15:45:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/46] arm64/sysreg: Add register fields for
 HDFGRTR2_EL2
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-6-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-6-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ACas0CYbmz39aYldg2zsljnN8JWhVYqgmTtEVnoYKLI_1734533131
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for HDFGRTR2_EL2 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/tools/sysreg | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 10b1a0998d99..a56f7384d0db 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2562,6 +2562,35 @@ Field	1	ICIALLU
>  Field	0	ICIALLUIS
>  EndSysreg
>  
> +Sysreg HDFGRTR2_EL2	3	4	3	1	0
> +Res0	63:25
> +Field	24	nPMBMAR_EL1
> +Field	23	nMDSTEPOP_EL1
> +Field	22	nTRBMPAM_EL1
> +Res0	21
> +Field	20	nTRCITECR_EL1
> +Field	19	nPMSDSFR_EL1
> +Field	18	nSPMDEVAFF_EL1
> +Field	17	nSPMID
> +Field	16	nSPMSCR_EL1
> +Field	15	nSPMACCESSR_EL1
> +Field	14	nSPMCR_EL0
> +Field	13	nSPMOVS
> +Field	12	nSPMINTEN
> +Field	11	nSPMCNTEN
> +Field	10	nSPMSELR_EL0
> +Field	9	nSPMEVTYPERn_EL0
> +Field	8	nSPMEVCNTRn_EL0
> +Field	7	nPMSSCR_EL1
> +Field	6	nPMSSDATA
> +Field	5	nMDSELR_EL1
> +Field	4	nPMUACR_EL1
> +Field	3	nPMICFILTR_EL0
> +Field	2	nPMICNTR_EL0
> +Field	1	nPMIAR_EL1
> +Field	0	nPMECR_EL1
> +EndSysreg
> +
>  Sysreg HDFGRTR_EL2	3	4	3	1	4
>  Field	63	PMBIDR_EL1
>  Field	62	nPMSNEVFR_EL1

