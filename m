Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269A4A840
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 11:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684842053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8vwN/9ONMx0u75LjIXt1q27M2hiO9w6JZhlO31A3kkY=;
	b=O8phUx42JpsEg9Di4lCBfou8zT2BY3sa+s50K0RMmlABoVoA6p6tpRHzrPhks99ifbOqtw
	vgQViUYlxqnniFCdPqhtNXoe/X339QlWuvwjyVhDwAoMdLFePAIpJXzvhwRBsCrQ64+oZ5
	enzBfFiKwRkZMTK9CF16LpTrD0UnTic=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-7Lk5SIY3OaWXiLJt9vuy1g-1; Tue, 23 May 2023 07:40:52 -0400
X-MC-Unique: 7Lk5SIY3OaWXiLJt9vuy1g-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-64d55045efeso879396b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 04:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684842051; x=1687434051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8vwN/9ONMx0u75LjIXt1q27M2hiO9w6JZhlO31A3kkY=;
        b=HdkXyWILvFRvIPJvNungAWEwccCvFuLesqL5kVwMoTZM550AYRT0zMTBq0BrujGVqW
         oXSwT61fji3kP052395WAUmc9s0c17gmzBB1RkwDaygnKKc6vM5Y5O5CTH60y58L/xJ/
         mhcCGYMPMLsBXDlltQQ2SzS242Ux6lRdNs7albWeOYauIUdazRh2hPwSljy8Cx4a190V
         h0VieYNu1ETNPpt8GS5UlfNuIMZdXdA3cm+3W5pUQ78CFCGcSPAfZgBO49WG6OaijxZ4
         fc5ldwTKy1C7+duflMDFE1u8MxAIuNpwHtnT2XMbRnwqHC9IZg18MfYMWXXqTYe2+dF5
         uEFg==
X-Gm-Message-State: AC+VfDyxw87hFTo4ShpGd3Yy38pZbITH3GKvLOWQtDI2UueGbQ2wVOxX
	XRWsoYZuygTrpicwbkw1tQrW28/0TnKQxGWxgYYRKDcXw95uI7pMNzmegyW6QhigyD8PGeAEa1K
	aI3FC3Qc215+KZSdk
X-Received: by 2002:a05:6a00:278d:b0:63d:344c:f123 with SMTP id bd13-20020a056a00278d00b0063d344cf123mr12547062pfb.1.1684842051529;
        Tue, 23 May 2023 04:40:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6KAkmKYimV0HIhjj7YW0o0S1TP50XzDvn3w+bGqWEzOjPBmCXpIIiCMMjpGdQLylkmEBtNuA==
X-Received: by 2002:a05:6a00:278d:b0:63d:344c:f123 with SMTP id bd13-20020a056a00278d00b0063d344cf123mr12547045pfb.1.1684842051182;
        Tue, 23 May 2023 04:40:51 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j18-20020aa783d2000000b0064f4aeedaa2sm313004pfn.105.2023.05.23.04.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:40:50 -0700 (PDT)
Message-ID: <c1dba172-930b-f3da-c4f3-8ce640297edf@redhat.com>
Date: Tue, 23 May 2023 19:40:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/5] arm64/sysreg: Convert MDSCR_EL1 to automatic register
 generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-3-936cd769cb9e@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v1-3-936cd769cb9e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/23 00:22, Mark Brown wrote:
> Convert MDSCR_EL1 to automatic register generation as per DDI0616 2023-03.
> No functional change.
> 
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   arch/arm64/include/asm/sysreg.h |  1 -
>   arch/arm64/tools/sysreg         | 28 ++++++++++++++++++++++++++++
>   2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 4e48bb4dca6a..4ecae92b56b5 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,7 +134,6 @@
>   #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>   #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>   
> -#define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
>   #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>   #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
>   #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1699e87bc0b4..a5ae0e19fc9f 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -55,6 +55,34 @@ Field	29	TX
>   Res0	28:0
>   EndSysreg
>   
> +Sysreg	MDSCR_EL1	2	0	0	2	2
> +Res0	63:36
> +Field	35	EHBWE
> +Field	34	EnSPM
> +Field	33	TTA
> +Field	32	EMBWE
> +Field	31	TFO
> +Field	30	RXfull
> +Field	29	TXfull
> +Res0	28
> +Field	27	RXO
> +Field	26	TXU
> +Res0	25:24
> +Field	23:22	INTdis
> +Field	21	TDA
> +Res0	20
> +Field	19	SC2
> +Res0	18:16
> +Field	15	MDE
> +Field	14	HDE
> +Field	13	KDE
> +Field	12	TDCC
> +Res0	11:7
> +Field	6	ERR
> +Res0	5:1
> +Field	0	SS
> +EndSysreg
> +
>   Sysreg ID_PFR0_EL1	3	0	0	1	0
>   Res0	63:32
>   UnsignedEnum	31:28	RAS
> 

-- 
Shaoqin

