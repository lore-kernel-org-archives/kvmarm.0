Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A2C1C5F1E
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734532827; cv=none; b=USLV7hU1BsjIr6Fe6YofMPbX89RAzHgkb+xIeMTIXib3y8IbcUNW+uNsXlrlFL7xmQkMrogkA61bRYuvN8Yudg9DgLKvaNIHtj/KdHjZIe4YkWHOxR17Uo852u8Mtb3eu3auYsxgFymylSc6zP9erLW8qayjO2Qj6tQCACbBCZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734532827; c=relaxed/simple;
	bh=4Psbr8Lu3xnhbMRxF6qUdwejGPSBIgp4q3PZ+oDeqFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3Gh9xpx+a+XORN3hpQSqpKxGtes7kjPvHpmPqsbIIvXWt/saWgSwGUM93Vt7Lf69LyhnuTcwfCX5uTg3ejlGMC9hAU22D87Fr/TQd/Uk/qcyHiitDVLSSKTD9Dcj9yoarT1m84aRVal9vuyWOZ+B9jggQL4BP0rjRasM5relLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MlKn56n4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MlKn56n4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734532824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzk6tWDuy93z5fSW/LgGI7zFwoVeRvip4+2VVd3waU8=;
	b=MlKn56n4TBSLJVNrqhW0uhoOZUT5rI4lu9IBMzoiJD4u1Ew/ML0LXIZNMIp3FQgJecoJbx
	X/AREl04qr0/V+L+ZWpv2U3C4IBXiwqsqJY0ARoKXLL788Z2CrJZT0JckWi9L91IhSPimi
	mKaqYoYVVJTMjsAkJ3jq3xMc8PUphlk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-e8EngqLMNwiyQ7Jo2MZTQg-1; Wed, 18 Dec 2024 09:40:23 -0500
X-MC-Unique: e8EngqLMNwiyQ7Jo2MZTQg-1
X-Mimecast-MFC-AGG-ID: e8EngqLMNwiyQ7Jo2MZTQg
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d895f91a7dso117557826d6.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 06:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734532823; x=1735137623;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzk6tWDuy93z5fSW/LgGI7zFwoVeRvip4+2VVd3waU8=;
        b=REFtPlFunPY2V5kptC723k4lLdjAUa5PHWKb+jePB+bscoV91AS/oy8Rc0XeqnVcMR
         Aia55XjxD1VvJDYd+BEKGzhrjR1pMawWGZN1Pbz9+AgltzHVQp0eW3OadVRBJs5/FShU
         Bd9c3UD2gFH+t7974K3L1SKnjdLgL4XhUBM46geAcruPcdgHE9TE3FJ5kTdyznZDgsdU
         xkxEofVF4p+OYWd9dh6K0+7z36xzyEZL9dR2YuFApFr/WL7LK8xmTUn4luE9XL27nNzw
         YsvwdItMjwUfx+z8y+LvjCbmnYEwaqPfLhm0DQaenw7QloDjzBBWgc7ZxITeQY5t8GXK
         2OPg==
X-Forwarded-Encrypted: i=1; AJvYcCVy2GmlsSCyumIj7VwFZIwh/vgro1Xk5mssQFltR4MlZDBs/5Lbq42E9h4i6n6gboYj7jrS2n4=@lists.linux.dev
X-Gm-Message-State: AOJu0YypydUCs+/BEjF7GH87260lV5LH0EPJBbO2Kh/QRZ5vsN6XVGMA
	PuWRq4tuP+OQ3IBCtlrdGGsCa88a6lV+JS4X0uAV6HHe0MPsnKn51uqUyDXWPRdyK4fahdrGnV0
	0OOC4AjyIDcsQmLiVNe/CAgsS01aIa/g4oVOTcPmy9PgBbO3qWWXg1w==
X-Gm-Gg: ASbGncvwh7RDcYh32REY6LMAo7T80oQyn9Q4FYRALbx6NVWi9rWKi55YmbfwFMNHbq9
	lv+zNa86ftlVkL36A1YqeEt2r81eqouI5nNm33jMtgfMQKOQtkWaQgi8AN62WcST5PouxqKlLP1
	Irb9fwRSXTG/VYPonOasoSe6rKm1GBEYjiVawk2TpCVFV2a8HDGzl33GiRlIOtViVOMEOJ7O3xi
	0V8H40u/3eJcxizm/loiTGyZ/SqT2F/kW0qZF8Twb+eTp4XN2iuBcZ87HTSzJu65uOXGef7uSwQ
	VVnlDeKy5Yl2xQr9DAWrx1g=
X-Received: by 2002:ad4:5b83:0:b0:6d8:7db7:1f2e with SMTP id 6a1803df08f44-6dd091ad741mr48614236d6.14.1734532822832;
        Wed, 18 Dec 2024 06:40:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyzRQGpvUZbqZgyLjVnHF5h72ppRppul+n4A1Jc6kVaEXZPHIuVIVlWdxlnn8Hf5Wge4oTTw==
X-Received: by 2002:ad4:5b83:0:b0:6d8:7db7:1f2e with SMTP id 6a1803df08f44-6dd091ad741mr48613946d6.14.1734532822513;
        Wed, 18 Dec 2024 06:40:22 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd3a4c5esm49404806d6.131.2024.12.18.06.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 06:40:21 -0800 (PST)
Message-ID: <5b46b684-3223-41d6-9da5-4e59a1de990b@redhat.com>
Date: Wed, 18 Dec 2024 15:40:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 03/46] arm64/sysreg: Update register fields for
 ID_AA64PFR0_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-4-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-4-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PtnWOB92pfd6lHHB-nI79-LapDDNepqq5G4CMkMwWaI_1734532823
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This updates ID_AA64PFR0_EL1.RAS and ID_AA64PFR0_EL1.RME register fields as
> per the definitions based on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/tools/sysreg | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index b5bda7c94689..59351931d907 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -873,6 +873,8 @@ EndEnum
>  UnsignedEnum	55:52	RME
>  	0b0000	NI
>  	0b0001	IMP
> +	0b0010	GPC2
> +	0b0011	GPC3
>  EndEnum
>  UnsignedEnum	51:48	DIT
>  	0b0000	NI
> @@ -899,6 +901,7 @@ UnsignedEnum	31:28	RAS
>  	0b0000	NI
>  	0b0001	IMP
>  	0b0010	V1P1
> +	0b0011	V2
>  EndEnum
>  UnsignedEnum	27:24	GIC
>  	0b0000	NI

