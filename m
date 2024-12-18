Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334801A2C04
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535050; cv=none; b=EcvoWOs9RsFph/ppR3Tk3M405sE05YROdGCNhoxdb5xdf5WfFGPspnPIDEmq7DYRdd6MG6vTssCXEw/ooy6qSOuK7g1ud3Zu0RLZwR6+gc6hJFOxbkhoripz24Kewuyrn3ngar+6V4JZymjfvJwJE/TswlXDxBBsaQwmeLSzAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535050; c=relaxed/simple;
	bh=RBT/vMzEFtft7xsZs51igQIXkMbvXQVfqZwujbycU14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CLZjnjEAq8+Uw0LoxcKYMxpfowFn9hW+IvNtG9j5ZFrJIPSwDOi04C/d8uTs38SDgqkV/p5VX47oA2zRVVRbvChc8EEbW9L1dnXKnA3ex7UpLhu2bXL+8EeGMM12lgrZClOHN5DIC7A86V9Y2pYXVlhIFZAxHPQ6r+sowjLvd8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ay0C3rTD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ay0C3rTD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhT23Y8TQCYCMf1leRBky+No7WqbvnjK1DeY+t6D5qA=;
	b=ay0C3rTD4rpQtZ36128EmKkNJPFh3t8VsITRCVCUXaLG3Bg04U+CeH7cnAHBuNX+RfaxOk
	OoMg9wECyHVA29pFlQUpYIJQcXuASNpQb0x7KVaoqmM/Oe1Jafj9GW1iLRUyJ7F2wiTXA/
	ajOy1B8LJ9Vc2k9at08ACnLCTNcJMJ4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692--qYRg6o2PPWiI2chI3657A-1; Wed, 18 Dec 2024 10:17:26 -0500
X-MC-Unique: -qYRg6o2PPWiI2chI3657A-1
X-Mimecast-MFC-AGG-ID: -qYRg6o2PPWiI2chI3657A
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b6ef813ed1so947780385a.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535045; x=1735139845;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vhT23Y8TQCYCMf1leRBky+No7WqbvnjK1DeY+t6D5qA=;
        b=qtHi0snZ6PGw8yGCGPh8Vxln/eT35FBMcMKPb4cRa9qZROI9L1qkJS4am/JLNQAut2
         fknbv2M1Ls9Yy9J0DB1hVK+OcdxxcelmwI4DdseKRDuSM82gqBsXFJtlz5QZ/ez35l4B
         WfXqd9n2HBuKjhushdMttSQIPgqc1pcD4d+n4jk64pIKdm81O4IybpZJU9SI1/NK0yVI
         7um7Hg7z9dEUVOIcMpbwrSjVB4h2DbkIY4d66VDIsUian+wYLzkNeN5fpZVGeq478YnK
         sJ4pTK6EdZozZIU3AKBL1a+s61nyH894GSbLM3iJDU3XVuSQVAHqtPp+IWwlG1i3DOXr
         nvfg==
X-Forwarded-Encrypted: i=1; AJvYcCWe5oTZUJzO0pAuPRZF2Dlg6CklN+sI7l5m+MxSWyM4boogpbqND1FQ3K3AepUxg1AAOfEw0Q8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlOzsbeL+psSBma1DqGZUsOcs1hdClcaTpboJFrSInAG4oQxjT
	hiNE4aU4Jx39xfkM9PLeUBs3DJ1Z+e7tvS1mgzGVu9m8harBsWAUmWS6yqLek0JTeWeKgs/zv8R
	SflE4sDjfKhLMS4FxqpoGh8o7LnvZIsxu5gPqewcXcPAO3lJt5vRKNWCUidAxkg==
X-Gm-Gg: ASbGncsLKR2at8taXxZJmci3HJtuDENsXFzBXg/STqQMfxQip3+2/9RpXVMLEBUR5H8
	Kv48or1NXIO3m25JNwf8VHzoRsKX8ni46KIaR4y5BsnksOatYqTxRcExLmoMmJQgXO9v/4eRUQ5
	lPpqxLpNMX+ISLocMMUq1Gg0NI8Fdww599QGIytFw10BXIwlPmblcwzTiZWOFwQ13BEPrSx9p2y
	5jqr9QAZo0+qvA5ezwgWuYxmpUvKdADvhD0ETdTurn7GxGLI71S6d9aqQjsfBLmg06H8jv1WJHt
	h34G9dFN0wx+pZnY5FnCmVs=
X-Received: by 2002:a05:620a:29d1:b0:7b7:106a:19b8 with SMTP id af79cd13be357-7b863721022mr524513985a.20.1734535044985;
        Wed, 18 Dec 2024 07:17:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3yDOvoXP2F0eLylU5flUK2Asc5Xh1WkI3kixNyZ6h7T6Vryg/PEdvSGh5he+yNjx9RiU+ug==
X-Received: by 2002:a05:620a:29d1:b0:7b7:106a:19b8 with SMTP id af79cd13be357-7b863721022mr524510885a.20.1734535044717;
        Wed, 18 Dec 2024 07:17:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b7047aa729sm434042585a.12.2024.12.18.07.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:17:24 -0800 (PST)
Message-ID: <53889259-fc3e-46a2-9dc9-1aa7cd36e953@redhat.com>
Date: Wed, 18 Dec 2024 16:17:18 +0100
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
X-Mimecast-MFC-PROC-ID: -2fm3YyrQSE85JCF-_no9UYTu5nkUL0yNkDX-ydZW6w_1734535045
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

