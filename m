Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C2C20F096
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736785747; cv=none; b=YKFwD3cwiZci7Vo8nl+spRP8BGLcdHiuD0W+TrPHYhTzv8NB8w8W5gtK3NfGhzmJS9amI3OOClfMOCUQlqqRecwQlzga8PTAnae0ZeG+7W0dBjUFvRGCof2qCjz1BtH5ZFx4NpJe5e/h3e3e+RIQpKF7b4znMMfr9RIGCfBCYdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736785747; c=relaxed/simple;
	bh=aRAJ97/cq2fpEQNhgoJxY3nhr8hcUtlaEsPCnUNWWrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qxj1XK3BBco9QwHGLVg5cd7r2ow3d0Jd496/AeRxXos15V3IqNZNMLnXlP80yT2h6tONBr1FoJMNsBYQWNpF3uOT6VI/2qukoFjJQx5PS+zP8t4qVfzhJ41Eos7U0i/3I1izIigVbtinxlvRsCsPrc6emD1nb8Y+PLIcz31MDgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jx7yf6Yo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jx7yf6Yo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-436249df846so31426105e9.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 08:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736785743; x=1737390543; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z0Q399qQBeFwQ2AAFvg5rIHC8O+bRX8lVMzO2SMae/g=;
        b=Jx7yf6Yo2eIvlxZRfRWYy4V1uJto6FLK8HJm67a/CjzpMGTaRQOC1FwPwAjq8TlQHE
         5q4aNf+Gctey7hjg6MnMSITiZ0x+GUzGNJkl8BAUQ/b++K5TG1G6rXgkcbOYcSNjAMEd
         Ki6yXAtCZv1PNXND2BvDUbE8Qw/yIO+zUYAeBZlRdI2yQOZoa+HGK7XGN0D24S7haeMX
         E3Ua8gyf6Do6SFiVKCW17RbTXpJLFdSrNrIRw6AnddbhMWn1Q6NAg+v9SvbQkdnUpeGf
         bjg52kp1zCleoN9P6jIudpUA8kRl2LEQLl/SlJY6GgpGYTGTrEYgmPwaHXe/jBNUqmJn
         DpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736785743; x=1737390543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z0Q399qQBeFwQ2AAFvg5rIHC8O+bRX8lVMzO2SMae/g=;
        b=OBsCAf37BY2GgWkLyCNKZBNNFkjK05QgpmVGxdI0oqtsKAvcke+FRbf9dwpaU6KP7C
         PAmooe1kfZRH/NlevyJQgylzYt3mD9/82ur4OTRqWMpdPc9CWxZbdwZUlbSO7hQoG82x
         1O5vVJvWbf9vTCJIwT4eAovQr+odL3ek2wJ+6Dc7Ccm0kKzpBVBH9qJUMVD2ab3ePJ7K
         82stbHZPHYy0XowMxJXlRFyvEFtknhGNPB9hbxYA1t0waeQPNBRCVqZ9BUY+Z3GMAp35
         vOXYtx3qiZgRRTUTI4w4xQFbMS3Z8TSesEixumV1yfDl8TfT0zHZuIjs9JhkKUmA+deD
         hNXA==
X-Gm-Message-State: AOJu0YwwYVyS0503IevCZib5gjxIcIgA+Mv5wgHUN37PJrefU/9urKbo
	ev3oPFKWfI75uoT66X708Y4MuRakH69eDbIILdflLD9mUGLMAJJB0s3Ms6QJ1II=
X-Gm-Gg: ASbGncsP4VPV5/1NO0kaZOXgrm2FK+RXrfrU5BlMOa9MhJsppWwl2340o6gAkxa6YHk
	iy9BLp4jTDwUpnaTTD1Ui9/O1UGTGjjxIwcePZfAzdeJxqsrCPNtIElL4K0IyT2naHBxF6U/vWl
	N0HZKKNuKheXTLEZXpjDZlTSkkoA4DCu6G7AMAG8J9HdFytQmNxtyU5ihQRYcMokCQAeev3ywwF
	G8cCicM0ScDjun28foTPy92PX6lyLGMp8p6hptY0GXLqw7bJO8Z2SiLYp8ofvzMengJ
X-Google-Smtp-Source: AGHT+IGulicDFCac9I2VZC0TgSd73omPyF97o27BxwW8eg456AUs6gMtMhOv1+x4cJrRYaETRuDLmA==
X-Received: by 2002:a5d:64a1:0:b0:38a:4b8a:ffec with SMTP id ffacd0b85a97d-38a872ef24cmr19513809f8f.33.1736785743184;
        Mon, 13 Jan 2025 08:29:03 -0800 (PST)
Received: from [192.168.68.163] ([212.105.145.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a9362947dsm11055865f8f.40.2025.01.13.08.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 08:29:02 -0800 (PST)
Message-ID: <e9331167-dd9c-44a6-8c59-7e95660959cd@linaro.org>
Date: Mon, 13 Jan 2025 16:29:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] arm64/sysreg/tools: Move TRFCR definitions to
 sysreg
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, James Clark <james.clark@arm.com>,
 Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>, Shiqi Liu <shiqiliu@hust.edu.cn>,
 James Morse <james.morse@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Fuad Tabba
 <tabba@google.com>, "Rob Herring (Arm)" <robh@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-7-james.clark@linaro.org>
 <87cygsqgkh.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <87cygsqgkh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/01/2025 1:58 pm, Marc Zyngier wrote:
> On Tue, 07 Jan 2025 11:32:43 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>> From: James Clark <james.clark@arm.com>
>>
>> Convert TRFCR to automatic generation. Add separate definitions for ELx
>> and EL2 as TRFCR_EL1 doesn't have CX. This also mirrors the previous
>> definition so no code change is required.
>>
>> Also add TRFCR_EL12 which will start to be used in a later commit.
>>
>> Unfortunately, to avoid breaking the Perf build with duplicate
>> definition errors, the tools copy of the sysreg.h header needs to be
>> updated at the same time rather than the usual second commit. This is
>> because the generated version of sysreg
>> (arch/arm64/include/generated/asm/sysreg-defs.h), is currently shared
>> and tools/ does not have its own copy.
>>
>> Reviewed-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: James Clark <james.clark@arm.com>
>> Signed-off-by: James Clark <james.clark@linaro.org>
> 
> I've added the following patch to the series, dropping the TCFCR_ELx
> construct and fixing the code that makes use of it.
> 
> 	M.
> 
>  From fc77862e06ca1c15e44b0c915da193bd8ed855bc Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sun, 12 Jan 2025 13:08:59 +0000
> Subject: [PATCH] arm64/sysreg: Get rid of TRFCR_ELx SysregFields
> 
> There is no such thing as TRFCR_ELx in the architecture.
> What we have is TRFCR_EL1, for which TRFCR_EL12 is an accessor.
> 
> Rename TRFCR_ELx_* to TRFCR_EL1_*, and fix the bit of code using
> these names.
> 
> Similarly, TRFCR_EL12 is redefined as a mapping to TRFCR_EL1.
> 

I saw your 'mapping' patch but didn't pull it in for whatever reason. LGTM.

Reviewed-by: James Clark <james.clark@linaro.org>

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> ---
>   arch/arm64/tools/sysreg                          |  8 ++------
>   .../hwtracing/coresight/coresight-etm4x-core.c   | 16 ++++++++--------
>   .../hwtracing/coresight/coresight-etm4x-sysfs.c  | 10 +++++-----
>   drivers/hwtracing/coresight/coresight-trbe.c     |  2 +-
>   4 files changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 4c2c9c6767c93..ac5202e1df862 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1999,7 +1999,7 @@ Field	17:16	ZEN
>   Res0	15:0
>   EndSysreg
>   
> -SysregFields TRFCR_ELx
> +Sysreg	TRFCR_EL1	3	0	1	2	1
>   Res0	63:7
>   UnsignedEnum	6:5	TS
>   	0b0001	VIRTUAL
> @@ -2011,10 +2011,6 @@ Field	1	ExTRE
>   Field	0	E0TRE
>   EndSysregFields
>   
> -Sysreg	TRFCR_EL1	3	0	1	2	1
> -Fields	TRFCR_ELx
> -EndSysreg
> -
>   Sysreg	SMPRI_EL1	3	0	1	2	4
>   Res0	63:4
>   Field	3:0	PRIORITY
> @@ -2991,7 +2987,7 @@ Mapping	ZCR_EL1
>   EndSysreg
>   
>   Sysreg	TRFCR_EL12	3	5	1	2	1
> -Fields	TRFCR_ELx
> +Mapping	TRFCR_EL1
>   EndSysreg
>   
>   Sysreg	SMCR_EL12	3	5	1	2	6
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
> index fbc4aa3785279..2c1a60577728e 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
> @@ -275,7 +275,7 @@ static void etm4x_prohibit_trace(struct etmv4_drvdata *drvdata)
>   	if (!drvdata->trfcr)
>   		return;
>   
> -	trfcr = drvdata->trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE);
> +	trfcr = drvdata->trfcr & ~(TRFCR_EL1_ExTRE | TRFCR_EL1_E0TRE);
>   
>   	write_trfcr(trfcr);
>   	kvm_tracing_set_el1_configuration(trfcr);
> @@ -286,9 +286,9 @@ static u64 etm4x_get_kern_user_filter(struct etmv4_drvdata *drvdata)
>   	u64 trfcr = drvdata->trfcr;
>   
>   	if (drvdata->config.mode & ETM_MODE_EXCL_KERN)
> -		trfcr &= ~TRFCR_ELx_ExTRE;
> +		trfcr &= ~TRFCR_EL1_ExTRE;
>   	if (drvdata->config.mode & ETM_MODE_EXCL_USER)
> -		trfcr &= ~TRFCR_ELx_E0TRE;
> +		trfcr &= ~TRFCR_EL1_E0TRE;
>   
>   	return trfcr;
>   }
> @@ -312,7 +312,7 @@ static void etm4x_allow_trace(struct etmv4_drvdata *drvdata)
>   		return;
>   
>   	if (drvdata->config.mode & ETM_MODE_EXCL_HOST)
> -		trfcr = drvdata->trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE);
> +		trfcr = drvdata->trfcr & ~(TRFCR_EL1_ExTRE | TRFCR_EL1_E0TRE);
>   	else
>   		trfcr = etm4x_get_kern_user_filter(drvdata);
>   
> @@ -320,7 +320,7 @@ static void etm4x_allow_trace(struct etmv4_drvdata *drvdata)
>   
>   	/* Set filters for guests and pass to KVM */
>   	if (drvdata->config.mode & ETM_MODE_EXCL_GUEST)
> -		guest_trfcr = drvdata->trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE);
> +		guest_trfcr = drvdata->trfcr & ~(TRFCR_EL1_ExTRE | TRFCR_EL1_E0TRE);
>   	else
>   		guest_trfcr = etm4x_get_kern_user_filter(drvdata);
>   
> @@ -1176,9 +1176,9 @@ static void cpu_detect_trace_filtering(struct etmv4_drvdata *drvdata)
>   	 * tracing at the kernel EL and EL0, forcing to use the
>   	 * virtual time as the timestamp.
>   	 */
> -	trfcr = (TRFCR_ELx_TS_VIRTUAL |
> -		 TRFCR_ELx_ExTRE |
> -		 TRFCR_ELx_E0TRE);
> +	trfcr = (TRFCR_EL1_TS_VIRTUAL |
> +		 TRFCR_EL1_ExTRE |
> +		 TRFCR_EL1_E0TRE);
>   
>   	/* If we are running at EL2, allow tracing the CONTEXTIDR_EL2. */
>   	if (is_kernel_in_hyp_mode())
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> index a9f19629f3f84..c767f8ae4cf1d 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> @@ -2319,11 +2319,11 @@ static ssize_t ts_source_show(struct device *dev,
>   		goto out;
>   	}
>   
> -	switch (drvdata->trfcr & TRFCR_ELx_TS_MASK) {
> -	case TRFCR_ELx_TS_VIRTUAL:
> -	case TRFCR_ELx_TS_GUEST_PHYSICAL:
> -	case TRFCR_ELx_TS_PHYSICAL:
> -		val = FIELD_GET(TRFCR_ELx_TS_MASK, drvdata->trfcr);
> +	switch (drvdata->trfcr & TRFCR_EL1_TS_MASK) {
> +	case TRFCR_EL1_TS_VIRTUAL:
> +	case TRFCR_EL1_TS_GUEST_PHYSICAL:
> +	case TRFCR_EL1_TS_PHYSICAL:
> +		val = FIELD_GET(TRFCR_EL1_TS_MASK, drvdata->trfcr);
>   		break;
>   	default:
>   		val = -1;
> diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
> index d6eb0d525a4d6..fff67aac84181 100644
> --- a/drivers/hwtracing/coresight/coresight-trbe.c
> +++ b/drivers/hwtracing/coresight/coresight-trbe.c
> @@ -1118,7 +1118,7 @@ static u64 cpu_prohibit_trace(void)
>   	u64 trfcr = read_trfcr();
>   
>   	/* Prohibit tracing at EL0 & the kernel EL */
> -	write_trfcr(trfcr & ~(TRFCR_ELx_ExTRE | TRFCR_ELx_E0TRE));
> +	write_trfcr(trfcr & ~(TRFCR_EL1_ExTRE | TRFCR_EL1_E0TRE));
>   	/* Return the original value of the TRFCR */
>   	return trfcr;
>   }

