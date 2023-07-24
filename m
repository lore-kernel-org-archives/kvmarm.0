Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089A38C1B
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690207367;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FfEEe087gtJ8bomRCouViQMVQyYh61kHLnxItw8U/fw=;
	b=akwndmayieV55EGqPbrava5AANhJ0p2anTfJv4gmfx3jp5COAiv3+0G6hM+ObcfxBHnlBE
	kcUqn+P4YW/1sDnua91lzkhLZSUc+/yxI6nu5zCuroYT48DLTRUnVEezo7wa+ix+lqV+7W
	F9buaRdEz1xJBmm9XQeP0MHh7p5XN3Y=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-Cr6SNRCnMV6LCEwOuH7Tzg-1; Mon, 24 Jul 2023 10:02:45 -0400
X-MC-Unique: Cr6SNRCnMV6LCEwOuH7Tzg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-63cceb8c21aso57436756d6.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 07:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690207364; x=1690812164;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfEEe087gtJ8bomRCouViQMVQyYh61kHLnxItw8U/fw=;
        b=PwU7w3yAQKoDbhNFFHbBdbTLnRrhCJnei7zvSvmamJAx+FMWOHx6uIQSbxYbFoN+VK
         1S8QoaOSBAvz541VGUUuGIp5tG2l21K74xS0pDztCZ2RmGu4znQvOSWMjWIRGYUPEq3j
         ulmB2A+Mu4motfQWxTTvg24GrmuEC1yOMARIkva5ujzZAN+o/nzZBnbbWpkslTlq9b9p
         AsxDaKlaQnZ3BA4irYOUQ88uVx59cKpDQqbaXtuwWxe/QiimOgtDscNIYs0Su+PWPOqQ
         16LaLWV5fkQB5nj6ScMEJbLrYAx+3iEi3qeW6pdKseSl/qoRS2dwVp5jx7mRzU95DcUI
         gkqQ==
X-Gm-Message-State: ABy/qLYM+ETbAkJpV02JcJ/W7aXCWxpYmi8qYSEakfiDlFA7pM/er6Tg
	4ULeTNzGBsGyiluUQh+ejgAzD1ha/JD8JxpunwZxLl6K4FssfxJVi99nkjNGI8RNLFqTQRfqHaL
	Dg7AnD5Db8yy1w4NM
X-Received: by 2002:a0c:8d02:0:b0:635:e303:ed6d with SMTP id r2-20020a0c8d02000000b00635e303ed6dmr7596825qvb.52.1690207364606;
        Mon, 24 Jul 2023 07:02:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEfGkjGXUcAxCWvO7NKJ5m00gD9bKWkJjrfhgjQcGMYWoRWaQoOiSOhwac92zPeZAQSWVik4w==
X-Received: by 2002:a0c:8d02:0:b0:635:e303:ed6d with SMTP id r2-20020a0c8d02000000b00635e303ed6dmr7596791qvb.52.1690207364158;
        Mon, 24 Jul 2023 07:02:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id j16-20020a0ce010000000b0062ff179a538sm3544041qvk.123.2023.07.24.07.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 07:02:43 -0700 (PDT)
Message-ID: <15693147-5361-b94f-9785-542d6d5bf19e@redhat.com>
Date: Mon, 24 Jul 2023 16:02:37 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 08/27] arm64: Fix HFGxTR_EL2 field naming
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-9-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-9-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/12/23 16:57, Marc Zyngier wrote:
> The HFGxTR_EL2 fields do not always follow the naming described
> in the spec, nor do they match the name of the register they trap
> in the rest of the kernel.
>
> It is a bit sad that they were written by hand despite the availability
> of a machine readable version...
>
> Fixes: cc077e7facbe ("arm64/sysreg: Convert HFG[RW]TR_EL2 to automatic generation")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/tools/sysreg | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1ea4a3dc68f8..65866bf819c3 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2017,7 +2017,7 @@ Field	0	SM
>  EndSysreg
>  
>  SysregFields	HFGxTR_EL2
> -Field	63	nAMIAIR2_EL1
> +Field	63	nAMAIR2_EL1
>  Field	62	nMAIR2_EL1
>  Field	61	nS2POR_EL1
>  Field	60	nPOR_EL1
> @@ -2032,9 +2032,9 @@ Field	52	nGCS_EL0
>  Res0	51
>  Field	50	nACCDATA_EL1
>  Field	49	ERXADDR_EL1
> -Field	48	EXRPFGCDN_EL1
> -Field	47	EXPFGCTL_EL1
> -Field	46	EXPFGF_EL1
> +Field	48	ERXPFGCDN_EL1
> +Field	47	ERXPFGCTL_EL1
> +Field	46	ERXPFGF_EL1
>  Field	45	ERXMISCn_EL1
>  Field	44	ERXSTATUS_EL1
>  Field	43	ERXCTLR_EL1
> @@ -2049,8 +2049,8 @@ Field	35	TPIDR_EL0
>  Field	34	TPIDRRO_EL0
>  Field	33	TPIDR_EL1
>  Field	32	TCR_EL1
> -Field	31	SCTXNUM_EL0
> -Field	30	SCTXNUM_EL1
> +Field	31	SCXTNUM_EL0
> +Field	30	SCXTNUM_EL1
>  Field	29	SCTLR_EL1
>  Field	28	REVIDR_EL1
>  Field	27	PAR_EL1
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

