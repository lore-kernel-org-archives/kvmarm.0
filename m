Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0141DFD9C
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535724; cv=none; b=oH2oA8I8gLr/c1NVvPm7sr3nmq/3cYKV/mV+oA95+OyuXIc+ONSLbFnh5ByLwIubTfpOEpQ2BnA6HhZOi3eSM3bFsM2w8pmIKsLcSQRbUZbEh82/3XjRgEFBHvmSLdUWL+lp5mv6klxqBxg+Ugw5YzC4/bQNB5HaPIWwzfRnuqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535724; c=relaxed/simple;
	bh=5KAudT4G3fT2fToJHP8TAEi/u6MtXf3s46qh8H6j0GY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCUzjA4MO7ahZuQatMyx9AMHcKr9dEk8ZEpbYkWgxcYgNpWX11YGeoORO55fmBkBVTYQeFSa+FShHtmX8RBNveZOGWT1xZ13sPAD3LClvYr5iPafjuUw9IeUiIilOy+W3ySpY+RGpSQEMPS9Slzi2hqLHm4THK25kctUPGqGHN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAyMO4fE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAyMO4fE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sSHc2ApB1snPUa7jcz/r5fBTNNzq7YKYrFNPntkx7ik=;
	b=TAyMO4fE06EhbSB0o2vMW0gjOPvY3fmr9+5hsFjtPl0kGN9dZg9kUuKM3FDB6rerJFINbm
	94FRP0FWKBJOANBKjKn3PHArStdxNVr/1ebo0TAZHfvSna/3Ik9G9aAul4JuwkT/5GkSN7
	1sEvdMMhdzSz1BE4JstM+WgCOZ2T8+o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-_Nyj1CdiN_2PFjJ6P6qPJg-1; Wed, 18 Dec 2024 10:28:38 -0500
X-MC-Unique: _Nyj1CdiN_2PFjJ6P6qPJg-1
X-Mimecast-MFC-AGG-ID: _Nyj1CdiN_2PFjJ6P6qPJg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e2579507so2820884f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535717; x=1735140517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSHc2ApB1snPUa7jcz/r5fBTNNzq7YKYrFNPntkx7ik=;
        b=ilc0RVPq9P6GsZNy3prC0wnFl1tnV/TAW3HO8FkkMds2JnqJlcrVh9CxtRhLPoYIVg
         PbbEuyGYU6iYH6mcJEbO/KXrhUpRVKZFb/HchbPheTaOFy28LStdTbv/aUk2GNbUt550
         isqvhlNUwIMn08q688yedPx6BF3+SpSS21PGdA0Xojt5AI2OqC029zLucN8F3PgUt0fb
         n7Z+Ij+sP967vRID8FHPv7BLQUWFLGt7u7b7VWglBbruRBRQVoHjh5zbE3gWYKFkSsaK
         lJjbBiQTx+Okb+2bf1ASEvIU4dd9E9llu79LlTVd+yZxxspqs/ZcZieBrs186gQMVGAV
         +wFA==
X-Forwarded-Encrypted: i=1; AJvYcCWX2B1uUtyfGaTnE55TF8/iRlPgt3MZ//4REuY4Iksie0LBu/MdBPm48bWMljr6B/CzGWlx64k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqfWNLMQGF1JdmXJ+58x1S/5a7A0cgJmTlU6byMj3EO7Ceuc/a
	BlGw8ohG/JLdI3XMjdkcTRQ0V9qPQa9BdX4BEOxxcNY4C6Y0/No06joT89Oitlz7UYEwrcJEVF9
	yKmDsmbBgyy/jdKWY6ofnQPaV8cC6HJVO1hcr57/uqf+9vzrTnFc03A==
X-Gm-Gg: ASbGncu/lI0yxOmQ/9Qs9qkZilPbdhDvG6BjKj1FL7LAF8XbG6qCydAMgfUg+ZrGkJU
	vmgq+6HHjmojxKJUpIC4mJfehQRg0vgwwB+JJmXVI9WfqQTVunhSkLtA+gd5pvjrBa7I9B+zbHR
	G0LF2re00RQPdojrzCK53DBNVNRGKZ/rI39qvfN0xqYTusSb2cXTWVDvYYorbpu8suvq3LtykGh
	Nmjhk3lA6aNfEHzdn2KikRVcDI0BjuWqvEBoH/rOTxyr23Sqd+m9DYBPf21kSCym/h7ODT4jy0n
	WAAqJRfQUtQBAwNyVKVe5PE=
X-Received: by 2002:a5d:598d:0:b0:386:3dad:8147 with SMTP id ffacd0b85a97d-388e4d7ac44mr3121389f8f.32.1734535717310;
        Wed, 18 Dec 2024 07:28:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiv6kndOmgGJnN1137+7Dkjb518FlpmJgWwNyVe8dpcrKXQzcp17NV0VYD+o/4evBLu6qqIg==
X-Received: by 2002:a5d:598d:0:b0:386:3dad:8147 with SMTP id ffacd0b85a97d-388e4d7ac44mr3121369f8f.32.1734535717021;
        Wed, 18 Dec 2024 07:28:37 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c801a8bbsm14342588f8f.56.2024.12.18.07.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:28:36 -0800 (PST)
Message-ID: <a7988236-eb81-406d-a74a-5ad1355981e3@redhat.com>
Date: Wed, 18 Dec 2024 16:28:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 11/46] arm64/sysreg: Add register fields for PMSIDR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-12-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-12-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: krb5d2k4VBFe0_poRd3xaHvjidjg1bpfCwonjOpbbRw_1734535717
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for PMSIDR_EL1 as per the definitions based
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
>  arch/arm64/tools/sysreg | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index be0091060350..a5e31e4c4474 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2172,7 +2172,16 @@ Field	15:0	MINLAT
>  EndSysreg
>  
>  Sysreg	PMSIDR_EL1	3	0	9	9	7
> -Res0	63:25
> +Res0	63:33
> +Field	32	SME
> +UnsignedEnum	31:28	ALTCLK
> +	0b0000	NI
> +	0b0001	IMP
> +	0b1111	IMP_DEF
> +EndEnum
> +Field	27	FPF
> +Field	26	EFT
> +Field	25	CRR
>  Field	24	PBT
>  Field	23:20	FORMAT
>  Enum	19:16	COUNTSIZE
> @@ -2190,7 +2199,10 @@ Enum	11:8	INTERVAL
>  	0b0111	3072
>  	0b1000	4096
>  EndEnum
> -Res0	7
> +UnsignedEnum	7	FDS
> +	0b0	NI
> +	0b1	IMP
> +EndEnum
>  Field	6	FnE
>  Field	5	ERND
>  Field	4	LDS

