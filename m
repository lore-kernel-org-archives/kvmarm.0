Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A95134A5
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685444142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWivZAPPoTwMn2PqCvk8Vr3Zya+QIDyyBfpmbjsuvGs=;
	b=Vv9EM6ZWRwbLPn14lxZdRCJaEHI60gcxI5Kqis7c+sNg2fN7eOlNkkGoDqCMLAUb8qNX+B
	XfnLyihWwaPKjRPMoGuZPSrHpp6L9BSvtfI1v5R7lR4DuL7gtS3r9C+fOKw+elmZ2YiT/f
	Q36fpe9GTT9fBuC4Z3QjTFWJZX0ZrN4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-xr0475_8MmSE59no8tv5qw-1; Tue, 30 May 2023 06:55:39 -0400
X-MC-Unique: xr0475_8MmSE59no8tv5qw-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-25622b4a2dbso527130a91.0
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 03:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685444138; x=1688036138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWivZAPPoTwMn2PqCvk8Vr3Zya+QIDyyBfpmbjsuvGs=;
        b=BMnL0Bb13TmkGWn8S3VM08fE3HKm4DLKsfMPwa9TjZjY+ckP14ph9kRSFYL0rEeJ8S
         aqOJVQ0hfPd2evnbmVQKSMxhwECrF6yNzkfJsjx5HI7cDu2bUwV4o0UJGxtJ/ysAYJxL
         FJ1WJ1WUEtFwhPzVNs7beWSmxX+vgskw4L2sXepLUOs/ybuguqAGcqJxX7SftIxuA2R1
         WKHng9fKc8TlnDUXRD3/aV88+5i0y0AIiwHIoUZ6pD9cLKYESzQqubjrI4a5Lug4MGCh
         6NFGYHRm3tQwiZeC2RFtm/jZwoocoeNng7JtGtkSdO33k1skDJKylova8dTR3Lr5rCxx
         mXQA==
X-Gm-Message-State: AC+VfDy9z+Mjki9Hn4d60TTWeg7C62E+0YGgqqV8gv9nCIXicf2w/sli
	Nh6levTeE302MSmsq3coinGR+CpIAr/PlYX+xXs88uG3/U6fwj+1GX6KDbodlZ7A6qOfYppLE4P
	+PHDQvj2FSkjR5D9L
X-Received: by 2002:a17:90b:1bd1:b0:256:9095:a368 with SMTP id oa17-20020a17090b1bd100b002569095a368mr2205052pjb.4.1685444138250;
        Tue, 30 May 2023 03:55:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4++9HNsnxqvzJd3BOTRkdURdiR/fa3CDpaKOeW3XErEioJiBnAV6i5XDK0Qq4H+CQo+1hMaw==
X-Received: by 2002:a17:90b:1bd1:b0:256:9095:a368 with SMTP id oa17-20020a17090b1bd100b002569095a368mr2205034pjb.4.1685444137977;
        Tue, 30 May 2023 03:55:37 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mq4-20020a17090b380400b00256c9165e96sm871238pjb.50.2023.05.30.03.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 03:55:37 -0700 (PDT)
Message-ID: <f910e97e-b3cf-335b-95e7-4037ff0e2b97@redhat.com>
Date: Tue, 30 May 2023 18:55:33 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 6/7] arm64/sysreg: Convert OSDTRTX_EL1 to automatic
 generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
 <20230419-arm64-syreg-gen-v2-6-4c6add1f6257@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v2-6-4c6add1f6257@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/24/23 02:37, Mark Brown wrote:
> Convert OSDTRTX_EL1 to automatic generation as per DDI0601 2023-03. No
> functional changes.
> 
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   arch/arm64/include/asm/sysreg.h | 1 -
>   arch/arm64/tools/sysreg         | 5 +++++
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index da954a6eba24..d9711f1e47b2 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,7 +134,6 @@
>   #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>   #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>   
> -#define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
>   #define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
>   #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>   #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e4653248dcac..e18ae1df41f4 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -88,6 +88,11 @@ Res0	5:1
>   Field	0	SS
>   EndSysreg
>   
> +Sysreg	OSDTRTX_EL1	2	0	0	3	2
> +Res0	63:32
> +Field	31:0	DTRTX
> +EndSysreg
> +
>   Sysreg	OSLAR_EL1	2	0	1	0	4
>   Res0	63:1
>   Field	0	OSLK
> 

-- 
Shaoqin

