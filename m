Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE5D1BEF79
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734532825; cv=none; b=p0vzCXQTitQ9aeObXwvh7z0wEXidFS2mvh+nAUcSTgvSq/orVDViDhtCMJYReGdvsfSRAJ59NVYGNq+w5vtKczt3fHKY+63QXTFPfDvlb/32Rm8lSPo3wjft1N2M6585wprXIu1tE1zAWJd+mylzvmxIqkDCrE7CyJEr6ZqOFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734532825; c=relaxed/simple;
	bh=MYWyZqQicrU2HLWP/vikxeUSbuV4UvRsmPuh67h43Qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kd+alCVVOZft7bNfDTQuB6KmfQrl3QYK9Ad3W41fpAjPkrocT8FvFO5LTNWVZq9/CIx65u7uUsL76Dzd4125cvjcrZAXig6xbz6bPhqCPqNEMHaxz07TMc8PiRX8noxYcHGqssYt5MNF+8EkOp7SOui4/jPQpbYhkY5zR/lScsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rax5FfHs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rax5FfHs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734532821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J1JS5UgW5KEKPW82arLRkpB87zDMMpNUIULtXsMrMZU=;
	b=Rax5FfHsX4iMglvCwURW3YxspBTF/kRqty9feZmkStOIQxXWSClFgE6yz2KhC5rckG8qFV
	LCYfKjbIDPA421DCt3SKzm0yRhL3OB6Ep9OElzCOCPgcwQ9PA634gBVNWOh6WLrB627N9E
	tpcwlqwflvt1boCagB2jUJzs/QaML20=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-pM8z0hbBOXmXNPyk29yvsA-1; Wed, 18 Dec 2024 09:40:20 -0500
X-MC-Unique: pM8z0hbBOXmXNPyk29yvsA-1
X-Mimecast-MFC-AGG-ID: pM8z0hbBOXmXNPyk29yvsA
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6d88ccf14aeso120274566d6.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 06:40:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734532820; x=1735137620;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1JS5UgW5KEKPW82arLRkpB87zDMMpNUIULtXsMrMZU=;
        b=mHoqYHdfa74kj4aubP0NmSpCAYP7CperNOkT8TeArDg5yQ2AiHmccsZoguXFNEg5k9
         JnLtrwV1WG3P4LXifLCtHuoaX4whtj/KKBjaqCFvV0rJLnN3jacTIbc2Rcs6RlklE1+d
         hdzJ94tiuEnV2trTEyKlYTIs+H+sOAspCIxFMU6nI3ds1+oCFMUY2CPeTsNDNBuwc29W
         PmWFNMptdq+ocPqlov6eU+Nt80fv1N2d+gaG6s88nxq+99eMlcg5/d8iFo9o+yp3tEBy
         CojnVAfiXLvXLWeN+DErI3AXnLeEC/wiMx7btUKY/6Nr/pNG+KkNxWyunMFpb0r6vKy8
         uU0A==
X-Forwarded-Encrypted: i=1; AJvYcCWDLHToOWAkv6I/QBTWvP94/BpX5NAowkaAxICK+1QvUdlojD2lVLmDBJawvZc4zLWmmRqz1J4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRo/97jU2xb785x6Rt0L9NRbr5nsZFQxjmtciDCF47OGFdCQkR
	LjnN7t0FI5OvG2FcjGNcLN1tedk5C0nLYCPQmiHWdJWYeKWz2/yjuPe2ze1BZ7vu9m0KLF+2H/m
	VejLSBLyofP5rEBbBV1oHCz/DZ0MBkshzDg8wUnoMdmoMjxz4o4bkFQ==
X-Gm-Gg: ASbGncsQuW5aTmoQ5uc5SgldXYleWi/tvEpm5BCLxpOtyVj2VSuzrzXdgkgYj+9AM6/
	H3+pf1gJWPQCOf6Wx64IEdqvVFHBoH21ZAQGj1NxLeP/BVwFTQVIt9J00MIbzzwKda7kHoQeKNg
	uqm1QIj24shwFadQqKb91Im4IqimsPtiBrZOpiV96bOt2ezYyVtZsuP9L3sWY4LBqoSnSz0tOgY
	THw6j7FRfCNU9Al8ZjawlId+FYxWH0lXo1CgqcymyQN5E/64vXRW1x8T4CBA1JVEVjNoNpYHuay
	jvVIm0Zgj/T3KIbMMfme/pc=
X-Received: by 2002:a05:6214:2a89:b0:6d8:8416:9c54 with SMTP id 6a1803df08f44-6dd091afdfemr59695126d6.16.1734532819761;
        Wed, 18 Dec 2024 06:40:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaOUhW5lOdJ2FuzpZIYF4vXjrAM20LoQL28HLXSIyoyy9x4+1Fgy3rctig226BDr/QRvLUMA==
X-Received: by 2002:a05:6214:2a89:b0:6d8:8416:9c54 with SMTP id 6a1803df08f44-6dd091afdfemr59694656d6.16.1734532819450;
        Wed, 18 Dec 2024 06:40:19 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd3a4c5esm49404806d6.131.2024.12.18.06.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 06:40:18 -0800 (PST)
Message-ID: <36aba488-26d7-4dc9-9ca0-a14e3de028e9@redhat.com>
Date: Wed, 18 Dec 2024 15:40:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 04/46] arm64/sysreg: Update register fields for
 TRBIDR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-5-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-5-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _pnVowAfosp8nus2tcK5QRKZt6StBnX5_czx_kWT6mE_1734532820
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Anshuman

On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for TRBIDR_EL1 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/tools/sysreg | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 59351931d907..10b1a0998d99 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3295,13 +3295,24 @@ Field	31:0	TRG
>  EndSysreg
>  
>  Sysreg	TRBIDR_EL1	3	0	9	11	7
> -Res0	63:12
> +Res0	63:48
> +Field	47:32	MaxBuffSize
> +Res0	31:16
> +UnsignedEnum	15:12	MPAM
> +	0b0000	NI
> +	0b0001	PMG
Out of curiosity how did you choose the PMG terminology?
I see "MPAM implemented by the Trace Buffer Unit, using default PARTID
and PMG values in External mode". Wouldn't be TBU more meaningful?

Eric
> +	0b0010	IMP
> +EndEnum
>  Enum	11:8	EA
>  	0b0000	NON_DESC
>  	0b0001	IGNORE
>  	0b0010	SERROR
>  EndEnum
> -Res0	7:6
> +UnsignedEnum 7:6	AddrMode
> +	0b00	VIRT_PHYS
> +	0b01	VIRT_ONLY
> +	0b10	PHYS_ONLY
> +EndEnum
>  Field	5	F
>  Field	4	P
>  Field	3:0	Align

