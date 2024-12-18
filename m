Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761F1F2C4E
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734532836; cv=none; b=U32/4nP9gmlPxeVZ2sn9xiCImGGxxkBWmmGcq2/muy2exkdxrJBvpFwGtjEXwbkvZqr0GR/P2SSmw0+UIDsoxGrnGX1LTupt8/ZQgFsWRfDgRY03AOjZ+ga0d46Ojc0UVh2/YEcNqd8pTLdea3a6SlGzPinYhQWA6URpD2ZjvVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734532836; c=relaxed/simple;
	bh=rpvtG+uUK4oXbEt+ct1Q6jZ8WDOG5JK2NsYlG9vDPGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rY3CqbyIeHq6SM27ADQkXzsPe8Py8TB8LAOX7eX+EK1uscFFc1EkGA6Do3PXfQ7Jm6ebfrFl6BAQgp33fT5Fpurw5pfTWiHZUDrLJkVGZFb/VenyB4jjHXZNwVHePU+tG2CO3MGZKl3UEao6rUY0QJZhS6O66QlZ9ArvDLK91tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WAXpUxK6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WAXpUxK6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734532834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jesT8KSuZm6s5NxlSiXy7wDTw7JPpHC2A5ew+Rwns50=;
	b=WAXpUxK6cKeWbkX1bfaBrKfoD59t8w+K1+6OEQc9K7Bbt0jJUZrVth20DIZN/X1Nyz2F1a
	OkGdwdG4nNczXJyoP8T8OY4KDUT3469uUFs6IckMBXHqIJJTFJJxr+ptyq9zTNcSmhR0mu
	Efn6uriY6u9/K7E6sgMhgvRjGQiBMY4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-Yo5sgg6-MMu3ZxxxjUWeSg-1; Wed, 18 Dec 2024 09:40:33 -0500
X-MC-Unique: Yo5sgg6-MMu3ZxxxjUWeSg-1
X-Mimecast-MFC-AGG-ID: Yo5sgg6-MMu3ZxxxjUWeSg
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d8b3173b5bso98483976d6.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 06:40:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734532832; x=1735137632;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jesT8KSuZm6s5NxlSiXy7wDTw7JPpHC2A5ew+Rwns50=;
        b=tjxAlfxxGP+6X24iuiZx0N5ZhjrjxdTMy2FVVlcbpLRE5BZv7lLPF5csXu0ukCG6CQ
         BqT5NXgovQLw8r6RsjcQuevzHZPWL4a8y3eNQj6VyDqQyRJT2ejKaBzuWXooTyomrLrn
         6p2EYY401FkqAW0XQAJoVQJTewfFdodHUbGTw+cDcdYrtcz/o4pP86kEqrUlEG+iPBdL
         8oBuKPzqgU9OyJBG/EUeDceQwyzg0xTqaW+0Z1WIAZA3HfQ3yR1eOgA4Jef5p3BBrLV/
         FHW71uqb7cnrkNsadAFg4opapI+yPLxhSmEu5VskY/WdwsEVy3P29I1xxBSUxF4m+wF4
         knoA==
X-Forwarded-Encrypted: i=1; AJvYcCXmGjZ4d8S8OI5yoZ4mKmnexU1Ic1ucqA05XIeo+3rLSBHvyg8+Vf4772RZ1uJ/XuD9xNx7dAI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywrfa4jhBH2J4UZm6icxXjXCBNSZ6SW8jVPQ1DeX1U5L/uUq6s4
	WGxkW08TNswOhwoq3C5oCTuoaEr4Z8Aw/18rItiu++D+w6sMA9XpGWkuBHmtEV+7E9fdEAxaufo
	VtbUXfj20iDvokmiXqt1GbVy5d2aR8Xjda4/Rt4fVgkIlLbbfcTcsjg==
X-Gm-Gg: ASbGncu9esPzsvhB+z8zNOocw5cDvNLB99QkPUGaiIPEiv2crT1CpTN3U0h6XXPpT+l
	BdFD2BHO7FLBi5dr7Zqsoz/px0rNfpSkGwZUa2R0q7o264dIxvwXxoI5uJW0HElIoYqK0OBL7aH
	H3gt3O2ARFXkwWMKEVAYrHh1gUk92JSae3Bsb/GWc4v4N4yaebbYnbz5S7ZUUpIfOj3kYiCLZl1
	JIoTAVnHNDf4QH0OCkjqNv5UAeBwvDkAJrH2tcJXY44y26CR8BfLLPUNFSy0qpChvqRi2mz6i6Z
	TncZ9SIi2z3wbNVD+TRbEsw=
X-Received: by 2002:a05:6214:2481:b0:6d8:a148:9ab4 with SMTP id 6a1803df08f44-6dd09263fd8mr38794576d6.49.1734532832574;
        Wed, 18 Dec 2024 06:40:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUBhDILHEHyMdYZRoDvuz1fL+aEGZm9SpXTlAAUoL8ds8OGrn5wunFSwDZTGLqdLc/sUwhtQ==
X-Received: by 2002:a05:6214:2481:b0:6d8:a148:9ab4 with SMTP id 6a1803df08f44-6dd09263fd8mr38794316d6.49.1734532832294;
        Wed, 18 Dec 2024 06:40:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd3a4c5esm49404806d6.131.2024.12.18.06.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 06:40:31 -0800 (PST)
Message-ID: <ed883097-c1a1-498d-97af-f0a306893b26@redhat.com>
Date: Wed, 18 Dec 2024 15:40:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/46] arm64/sysreg: Update register fields for
 ID_AA64MMFR4_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-3-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-3-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -_V5VSHVCYH1SYrk9ctm_mjbRwrtZ0WBpz9diUq3USE_1734532832
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This updates ID_AA64MMFR4_EL1 register as per the definitions based on
> DDI0601 2024-09.
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
>  arch/arm64/tools/sysreg | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a6cbe0dcd63b..b5bda7c94689 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1872,12 +1872,21 @@ EndEnum
>  EndSysreg
>  
>  Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
> -Res0	63:40
> +Res0	63:48
> +UnsignedEnum	47:44	SRMASK
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +Res0	43:40
>  UnsignedEnum	39:36	E3DSE
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -Res0	35:28
> +Res0	35:32
> +UnsignedEnum	31:28	RMEGDI
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  SignedEnum	27:24	E2H0
>  	0b0000	IMP
>  	0b1110	NI_NV1
> @@ -1886,6 +1895,7 @@ EndEnum
>  UnsignedEnum	23:20	NV_frac
>  	0b0000	NV_NV2
>  	0b0001	NV2_ONLY
> +	0b0010	SOFTWARE
>  EndEnum
>  UnsignedEnum	19:16	FGWTE3
>  	0b0000	NI
> @@ -1905,7 +1915,10 @@ SignedEnum	7:4	EIESB
>  	0b0010	ToELx
>  	0b1111	ANY
>  EndEnum
> -Res0	3:0
> +UnsignedEnum	3:0	PoPS
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  EndSysreg
>  
>  Sysreg	SCTLR_EL1	3	0	1	0	0

