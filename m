Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DFB481B3
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535523; cv=none; b=GB5FKNFT6UfP5Z+yOEOEjZ45K544SmPckvyJPhvB2NjItWe+4plJKFCWzH9rty68L9jJ17JsZb6SovWmvXM5VOcZoHEZYF7Ae3PQc2Y4ZynFwLxIDiWaeaNsLbnRiRUyCdg/CPu++HtpCZftmPe7qhKXRvPLi/tvztyMxBtofbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535523; c=relaxed/simple;
	bh=PfrG7g8bb7tfwQVGg7Tlg/HK+kIeQF1zRnBiUj0aphI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3SMmoj+Xd0Xk1AMvjTcpU/pcNf3+OERnvqzU7ZeCeLM8VG9MegXbPMGJniH51d1sS/NZyWI0NmAXQH1yPVJc1WVz/1OZ5izfKheVMwgWEZY87QHDtFX1UC+ZNxGJFoTuZinazRZzHDQ3NsY1XECEyFSbIIx9FjFmiATiCRoUJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QgmwJFVI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QgmwJFVI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bb8SbH0SWAjKb1gb/9FXdc53gmPrM5vUCMKfctQg3cA=;
	b=QgmwJFVIuttl/rUxF14+5I090qsHMKYNPBP8Y2bjxiKI2ol8wGir278zM2D4/C/iQqQWAA
	s7T6g7lSyxxMp2mJaWnglYNu5Bqfzrs3WtBtjbcVG5zpHHGQZsnthgl9JlcPxRTdwzGsrU
	K7v3GJMYf80ECwVKy9JBIHYIQBQS1ns=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-yAcNpsipPhu2A1fuN15aBA-1; Wed, 18 Dec 2024 10:25:18 -0500
X-MC-Unique: yAcNpsipPhu2A1fuN15aBA-1
X-Mimecast-MFC-AGG-ID: yAcNpsipPhu2A1fuN15aBA
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4675749a982so125177001cf.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:25:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535518; x=1735140318;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb8SbH0SWAjKb1gb/9FXdc53gmPrM5vUCMKfctQg3cA=;
        b=QetI6OM/JgqTf5R9OTHHI59T17iXTHHdsSp/QumIWHv5YT4A+wJdubf+Yq1kPaa4MH
         cYwuh1QmCD7AVMmOjK/KwDtB0ZA2zfrLi/nFU7WSqqeFSqc7p6gq3Qq3d1zjHnZr3kC1
         +O+rf8Up4eMf/zZYrLWk/8Qkv3qclMZ9SV7FqBK0Av4Xf2l5Yk05e86sKS7GydUpGEvM
         xL9U34W3aMK+pe+BQVLRkWIy+bjcSpS017qqLkiRFI1usvF7FFQfjMUUKeWKaJLlELDr
         ie1bbUiR3CfPJ8Ol5PUVZ7js+zbBeWP1/hy9u900vJnRMIcfUuk6Gxh/dePVlMYxBoeO
         rkXA==
X-Forwarded-Encrypted: i=1; AJvYcCUmDWr6p7+/sUlk/wj8yJNmxyNeVFdUxwiOaHKv4gHysujj2JDZ8zRIolcJon7qXsyjn23LJR8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxooQFe3F+7qRcIyCBeppyG/vaDMMJLwe0V0GKyg1TOz6UxLLOJ
	mpBSHxZ5YaJrjL9bpVYcXZ81GZxnoHLodgl6nLdVFVzdufGIY9DmCt/WsLskkolgfgms/UjqxRY
	5UuQSTQf39VgV2PxISqlhFtghyeBnskAmc/RkshsyYqVdRBTV7WZ31A==
X-Gm-Gg: ASbGncsyR4lk1Y+rAG/svj/BzeQxTNf/BfpxKOzyrlvzKxeWGfF42R4ij5f+URCRjDY
	rB7Dt10E0AgcaLM0SFVCKWjZRh6R3BIxqY9ILAIkmkLALf7oq9hjt/HhfYVBOj6dkqMEIeuxLp7
	X5YjpSAXmD9uevMRpZisL6FkTRU56vmi71CvRJBbllG4VfVwDZJ/WCicdP+4FFJe4CFZdJASVDF
	HFXPFoJX/5jEseNfFQwZqTemZBKYxj31H1N98ovF6JTUIBceAMfIQjX6vwHUb/hvXmSkICL+t3X
	GE5LddDztDqBtUie8dJ46WM=
X-Received: by 2002:ac8:580d:0:b0:467:770f:70a0 with SMTP id d75a77b69052e-46908db0cefmr57709891cf.10.1734535518307;
        Wed, 18 Dec 2024 07:25:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGboScQSGm0961Iu1cY4M+nB+Aon69Uxo4T6WWww0R+Ugx69ka2j99u17brjAoLU0VR+pwF4w==
X-Received: by 2002:ac8:580d:0:b0:467:770f:70a0 with SMTP id d75a77b69052e-46908db0cefmr57709351cf.10.1734535517981;
        Wed, 18 Dec 2024 07:25:17 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-467b2ca0a76sm51869261cf.25.2024.12.18.07.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:25:17 -0800 (PST)
Message-ID: <b92db5c5-199f-406f-83d4-9d694701359f@redhat.com>
Date: Wed, 18 Dec 2024 16:25:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 10/46] arm64/sysreg: Add register fields for MDSELR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-11-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-11-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w20ye_q6LjTcB0PzUkT71IUfOnoIrM9TCxfvZ5BkCqU_1734535518
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for MDSELR_EL1 as per the definitions based
> on DDI0601 2024-09.
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
>  arch/arm64/tools/sysreg | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 30a0d3ee71a7..be0091060350 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -93,6 +93,17 @@ Res0	63:32
>  Field	31:0	DTRTX
>  EndSysreg
>  
> +Sysreg	MDSELR_EL1	2	0	0	4	2
> +Res0	63:6
> +Enum	5:4	BANK
> +	0b00	BANK_0
> +	0b01	BANK_1
> +	0b10	BANK_2
> +	0b11	BANK_3
> +EndEnum
> +Res0	3:0
> +EndSysreg
> +
>  Sysreg	OSECCR_EL1	2	0	0	6	2
>  Res0	63:32
>  Field	31:0	EDECCR

