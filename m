Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837E26F305
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535372; cv=none; b=o6C2abPyPoqCI96aH9FRD3P9sV3wm8ODPOjAL1ztwHWfUuBzdIzgYhS/lZe0rHIdgLjFLUP7ZwOJUZL3npKz7F8/VmQujuwRtnwmIOj9cz3bNA9kJAWfQF9aDHVvQtQaLxjWbC5ayz62K1LaTaZikj3DEyBsPZd2xmmMsnrisak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535372; c=relaxed/simple;
	bh=Wy0++N495xzNH+uVamD5pjs+IZyRqs9bavIxX37s7PM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iq74tBfM6Lt0/gSi+xEKqmlbRf+xWwpD15uCUSeI+HNFi+XocXk551gUDyL5LCqYcReROgWmOQO9qK4u7Bdjfp0BNfbCRH8DHKTq9JsAuwzkWs5CFUKCVnyHe3Jb2Ehe39XdHyYjT/McrqyiFyVPEpig8stEJRn3wwLha4s/lyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=flZLwuEp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flZLwuEp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mxwx7T8xQX7F7d9YmlWUpy9SyCJUmBxMFMKphhhpq4Q=;
	b=flZLwuEpIgiGn+mgPnRAOx1s5HE+2IMxFliHz/7R8j0zfBFKTRSLAVOH23TaPzC3smZOBC
	uoUi6P1hhTxMRjCcKyQUk8WprJxH24+3a7otPgIakKsb/sdJX1C+2itkNNtQUZqNJjj+dW
	ysu3fQ6rdkGUXDVxEOC4Vi/FvGAADZk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-VS-3Z1dEP9GMWRlc9gRuzA-1; Wed, 18 Dec 2024 10:22:48 -0500
X-MC-Unique: VS-3Z1dEP9GMWRlc9gRuzA-1
X-Mimecast-MFC-AGG-ID: VS-3Z1dEP9GMWRlc9gRuzA
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6eeef7cb8so466366885a.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:22:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535368; x=1735140168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mxwx7T8xQX7F7d9YmlWUpy9SyCJUmBxMFMKphhhpq4Q=;
        b=VF80XasfyZLgFTdytWVgj6jceEGyMTt1It4it11TBJibq6NLE51tLVBiCLyV4ABKZJ
         EPiB/xZFQJIj1wPdhaw3Mb4+Ru4cuwUKkgFV6R/lWz1XTUv7P8cvcyRkfyrmE642T03c
         xv74s8Er8/Z9A6fTJ6UP8P2QUo07wIAygzTi1YN3a8RlVxa0/dFE0dQ0fKc9bVYUDUmq
         qt0iOT+lyddu68JDK8wwfuHsrYnQvgzfJb22Ux/Al3eWNG5WdJyww1RIA1sy1NPqeho4
         E4cmO/ju28nEAWPH4BoHNCEZVJaNN00XzNwnxr5zgoVNXO9gBaNpzMa80o+sI2YzjQ97
         JmGw==
X-Forwarded-Encrypted: i=1; AJvYcCXQTu390NP9NLOGaIwJyQP163wySmEvRwG5sJA1VJ1MSDvBwpz7fLtvvirHfprSZd0FLoFQ2c4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPEd9yqkpQEFTu0EpwOKA5eBefAaTA6lhzgYl86FZ7aoAKOASf
	/kbyxkJtdKaL6kyJyo/sL8N0MTMkryUl5WGaAJxrsSTZtj01A0aKDk8kf/zy1JdCFo7Jxlwbk7w
	7P/jbL2NslrzRoj2uKKik/lsy2Et2CoSUFeASfUMUWvJJ4kV8hwMnWQ==
X-Gm-Gg: ASbGncuGCwHUrHoYlAO2pePVKbjwqj/dvrkLE3ObXT6XwSjksR+heJRD4zklHDo5kJI
	8D5hUfs/I7TH8JhtEQz1PIGKHajAvHFCK2YMKAC5WVX74tog+JX/TYOAOh9oT8WWh3HwHEiCx82
	ZUYkM2+/jgUg7ikiPuAYlctBvipj/0KqFtf4e6uIFJkMZhQhGBl4lLS8S8BT/5ChlPeHISYWT+5
	9nRvpFwixxLGumzGFAAt2sBrgi77hDXdxf3b5RBqcGnc9CYwSUl0GInVyjIqIkr97U+u0oOad+8
	W1SpDuOthmF4yLBzsR9thME=
X-Received: by 2002:a05:622a:345:b0:466:8a95:d1cc with SMTP id d75a77b69052e-46908eccbbfmr50231331cf.47.1734535367907;
        Wed, 18 Dec 2024 07:22:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDphvG9D+OqeokedTCW6poW/8dGPSq+hi4s2HJPD6c7Y6vBGeH4Zz/CqDbOTkejk9pqrPBCA==
X-Received: by 2002:a05:622a:345:b0:466:8a95:d1cc with SMTP id d75a77b69052e-46908eccbbfmr50230991cf.47.1734535367576;
        Wed, 18 Dec 2024 07:22:47 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-467b2c69b10sm51678321cf.18.2024.12.18.07.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:22:47 -0800 (PST)
Message-ID: <b77f9c33-0161-4891-b3cc-a629c6380e63@redhat.com>
Date: Wed, 18 Dec 2024 16:22:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 09/46] arm64/sysreg: Add register fields for
 HFGWTR2_EL2
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-10-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-10-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yZ00TGmLgEx1ZI2nGFyWSGWqQ2jJxyG9NtESw6ROJHI_1734535368
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for HFGWTR2_EL2 as per the definitions based
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
> index 9513ae05dc93..30a0d3ee71a7 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2638,6 +2638,25 @@ Field	1	nERXGSR_EL1
>  Field	0	nPFAR_EL1
>  EndSysreg
>  
> +Sysreg	HFGWTR2_EL2	3	4	3	1	3
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
> +Res0	1
> +Field	0	nPFAR_EL1
> +EndSysreg
> +
>  Sysreg HDFGRTR_EL2	3	4	3	1	4
>  Field	63	PMBIDR_EL1
>  Field	62	nPMSNEVFR_EL1

