Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C61F0E2C
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535053; cv=none; b=ncY72/d+NrCsJ9v/1vFUb29AAlQWwt1sp6JETN3gAXFj//2kktJ/hhP4ryBr4evF7KZLPILoz6EI7cUPi488H7N4DXNKGzyNGMktxWbUMgwITiVlY48OPmrLhbHArcphJ7C2bLZQ8EAVHZhZsZg9x0Z++AOBT4eV09e/jFx6jxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535053; c=relaxed/simple;
	bh=RBT/vMzEFtft7xsZs51igQIXkMbvXQVfqZwujbycU14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=an/DQSPlApfFGOhrdDiOV5PJ7kR9i4EaRHWxeCcXZF1FJxolLZeAUKSIDJEhDxJL00SX+qpJPBsuThGImzXALV2ZEbLYc9ChAAZ5BLCNDDoEfdp8JFlap8YgR3l+ZT0vuLoWczrxCK/H+VobMAJ80WwJEygzBI0xKFSkCxHF/mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNYrpeZ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNYrpeZ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhT23Y8TQCYCMf1leRBky+No7WqbvnjK1DeY+t6D5qA=;
	b=fNYrpeZ9pDkrjIS9LPIX7mtKboVxsshdqRZbpzAWkVTNdJFlyXqwtPvJKduSU9jsC8AQC9
	NFN94eEDLcrKpBfE18w5ysGaDkxekjcPUXnX/tG9DQKb3P9SpU+c+NKDGneUsuRjc0+YPm
	AM6GjIFo/pC1qw6sZjB96gCJLCSzKsk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-DZuL_g2cP8O_LHNk_S9Xbg-1; Wed, 18 Dec 2024 10:17:30 -0500
X-MC-Unique: DZuL_g2cP8O_LHNk_S9Xbg-1
X-Mimecast-MFC-AGG-ID: DZuL_g2cP8O_LHNk_S9Xbg
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b6e23e2b8fso544851985a.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:17:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535049; x=1735139849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vhT23Y8TQCYCMf1leRBky+No7WqbvnjK1DeY+t6D5qA=;
        b=n4AaJE5ddHd3JQmPm9A1WBrUOdvZQThfNpsyS001dJycPqYMsNKfdY94LiCEJZTlKq
         7Oduh4YQpqQqLHxJ47KOgIvBBtZoTmWbpucpADgG02ZMSme2DhNk0YjkC4TA54L+ZjB2
         NqUU7GlsNSllQ0Oysc1k38hMx2DsR7pvTRrFdOqPBsSAYIk6uTHI/I27WdkD7P/mnXM6
         aF97csh8/dBiegtk0sgf4MGKSc7PC83LyBhWcEjdAd4QjAt7hZW/rrREDehsUiLb/hAp
         CtcgPqMEpIxjdP6rTLY8K41caed0okLJ/Z2mJayZNhtxkkZPwDjaKPz+cHQrCXQ4W3k0
         2Anw==
X-Forwarded-Encrypted: i=1; AJvYcCUQJwk2AjpGGy+/bP7lCCf4K51B7C+phJffo0W0OCSDjKYQ1yB9ezPgqzLsrUBUFtJj2Pxgxgw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBLXfiZwj4e5wd0al8kqeqCcYMvVrKU8nJjxY9vLIVjEmPUlsr
	H42Wam053fsz3ee0tDeU+dvO3OsIUEl9o6/mlPMHqWDTssJ7Y6qysLxGObMiXI8fIhIj2shKop+
	SFCSckAwQNAJY61teWsmMj4DNnohVeTfESAFzgHAK+q+THkeSgUOTq1QhKe9iWA==
X-Gm-Gg: ASbGncv9qcutUDV6Szx2GLUYwYacOnTTj/dtsgqIQICgAIGJKqhlfK2IoCPVOXhnpNh
	a9iuovjHKFGr97cd5QimZyrqf9Qpvoxt749gJvDJZq9SGCjFJ72/cG4FtjlNZ/ZfJPPczgHsQW5
	vykGxW273Hf+apD/L1O0+BhF7iOoptZ5qjOkVC92mr6tJjWMVcPyifT/0HOO7aZgENj6NQaJGOF
	EaG20/H48YyEbrxgdbwtu0UMdaE8KjDvDRM+0plUlSUuE0p0uHtfxkM1h3RxBkD9aZDSCULr+PL
	PC5hojbu3OVC33VqJ5LoLhA=
X-Received: by 2002:a05:620a:2995:b0:7b6:6826:2032 with SMTP id af79cd13be357-7b8637ad636mr472108385a.47.1734535049146;
        Wed, 18 Dec 2024 07:17:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+8HXh2pOBEtMvt59N3VE03WXdQuEXvRIA6SyRQfE/shKCr8OrtALWoDrSxjUGryMWNIGM8A==
X-Received: by 2002:a05:620a:2995:b0:7b6:6826:2032 with SMTP id af79cd13be357-7b8637ad636mr472105185a.47.1734535048912;
        Wed, 18 Dec 2024 07:17:28 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b7047aa729sm434042585a.12.2024.12.18.07.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:17:28 -0800 (PST)
Message-ID: <f6f7ab18-1bfc-4f38-a48a-afebed370a44@redhat.com>
Date: Wed, 18 Dec 2024 16:17:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 07/46] arm64/sysreg: Add register fields for
 HFGITR2_EL2
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-8-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-8-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Oy9QXEhYpsD63d2AzCOAbtx5MvIsL12Og2FsMkjc_GI_1734535050
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for HFGITR2_EL2 as per the definitions based
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
>  arch/arm64/tools/sysreg | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1a7d8c03f844..9d339f735648 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2791,6 +2791,12 @@ Field	1	AMEVCNTR00_EL0
>  Field	0	AMCNTEN0
>  EndSysreg
>  
> +Sysreg	HFGITR2_EL2	3	4	3	1	7
> +Res0	63:2
> +Field	1	nDCCIVAPS
> +Field	0	TSBCSYNC
> +EndSysreg
> +
>  Sysreg	ZCR_EL2	3	4	1	2	0
>  Fields	ZCR_ELx
>  EndSysreg

