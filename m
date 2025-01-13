Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340EF1C5D4C
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736783025; cv=none; b=HmiPmHFJSDjyOjRb7qt3kSRSiL0WwzmX4C9JFJ8+kVy8P8ZYfcmRUS2OwHpC+EBUJaKqty01kax+yW3f9hI4XoizKuyVvcwKnWzOugvgjtPPSaFwaSawRJaFxw9rQTzDO0ihya0RaJSLI5HxwvCZ24DFTnt3G2bTLe1ML7CzEZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736783025; c=relaxed/simple;
	bh=gGT5O+5jGSnq3FXOduFRfbgLcgYYNBiLos8tPqRNUJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WyZ8HsyoK/QZuABf85ivSd6V9alPcyFfdYqsm2cTdOE68Idsi7PaTDa64Wt8DLDu0SfqzijyNFDVl1k0rOO7qsxibk8dGB7N6GZKvVnOxe/ZCRMymrdg8jlRoR0bQye5t/HUTcizDaiG5BvTrtydxnChcOEoCBH4nLZuysCpiog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WsVq8oSI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WsVq8oSI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43621d27adeso30993645e9.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 07:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736783021; x=1737387821; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=onYqQa61OGFyF4QvM2h8YBVOy4czv714EXLgoMhI3Xc=;
        b=WsVq8oSIDNiPeYwhu49Bipv3rPf1xFmMMuOLy91luft2/lT6ZAWa3v0opT7kjNoG+V
         CKxMviobdxXZORh7VnGWxi2sWW1kv/6rIqUwwJbl2N898OcGFuY5nnmaDyWfMj9C0Yiq
         2FstT+ai6/3WrXxr/XffbzkBMnFvnD775oBUdPUY1yUV2OYDyV2WymPAh3SpQl3KdyKa
         UwFtJjiVtZ8zvO+Jo4HieYi2m/DdlT0uaJFFcHAwx2VLo9KoN5QfjvViuwM7kNyC0+AW
         H9SnjMJCTNDLu5mkckV0w7VPkaP9s+vMEhvsEusL2LffODiDjTKT2wFHF/Zj4bay/W9r
         /3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736783021; x=1737387821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=onYqQa61OGFyF4QvM2h8YBVOy4czv714EXLgoMhI3Xc=;
        b=C44iwT2MkGUa6Mid+gcam5fuvP9O75AkUhtfl5Use1Vko1STNboz40hf3ko7WYr/Yp
         2GmVcbgpE0s7GX0PN3U9cw3/xrP9ZJChZmyos2IW1BDpy+BecfmyZjbhlT9jgf3OlIGf
         l1q6Djk7IYXQWkWKLVIuHICcBoV8jyRClMa6uQVoUtjJlLPnrdX6KKkx5ansYOZFLZww
         zd78+bXwnMWFbzeWPV3wLHb5smx/9IserydaolpDKBiqaZTt3RQJ3LpFS7OVMbM1tI1T
         7Cb9N3c3C1aHREi8ABJlZikk6fote04LqCjHLDyMmJBqgVrXnn09YHYUOmHfdpKsftFD
         bJNg==
X-Gm-Message-State: AOJu0Yyxmfvs+XiYA7XHuHmi5MmG8ueHYLzfEeqNUS7CLju3b2oCllsT
	9F35IOvPb8T04aUA5fFiX1i2GnifJYWe/cqOmsk26uKa0Y3RhJ9GJQzWs+Fy8Gg=
X-Gm-Gg: ASbGncvtlH4SrK5TbqHqPk8xz0K+i8D7CQqg16kxdso3lsq9Yc62TkVfPeGDqS/JzpY
	SEF5z1XbZx62ZaMW+M4arBmxJY+BujSiju+WcFzZRuJSeFgFfqGlB5KnkXSpskRG+m3LDxIwS5c
	i1W2o2Cazn1oJ7LU2wHTdtriNp5KP7vcs4F0Bd8VCxffwJejbQ2+PBsuKP5YXXP7kAxICVpbGrP
	st2Oz+BluuTbmenAb1XSrcXTyKZTyC1QLIHdtgf2ZudWG2B70rWGeovNVirwPSokzar
X-Google-Smtp-Source: AGHT+IGQr4kpiFB9wczlaOYRTmEvbwC5k8AQlqeQKyaHs7iqTu2Ox0YvNOuXblM8h6c/Pixyirgj0Q==
X-Received: by 2002:a05:600c:1c28:b0:434:a734:d268 with SMTP id 5b1f17b1804b1-436e2699dfbmr216122595e9.14.1736783021472;
        Mon, 13 Jan 2025 07:43:41 -0800 (PST)
Received: from [192.168.68.163] ([212.105.145.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e89f29sm181691685e9.28.2025.01.13.07.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 07:43:41 -0800 (PST)
Message-ID: <760969b6-18b7-42ac-9524-2f1f845b3703@linaro.org>
Date: Mon, 13 Jan 2025 15:43:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg
 file should be sorted
To: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, James Clark <james.clark@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 "Rob Herring (Arm)" <robh@kernel.org>, Shiqi Liu <shiqiliu@hust.edu.cn>,
 James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-5-james.clark@linaro.org>
 <87frloqjso.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <87frloqjso.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/01/2025 12:49 pm, Marc Zyngier wrote:
> On Tue, 07 Jan 2025 11:32:41 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>> From: James Clark <james.clark@arm.com>
>>
>> There are a few entries particularly at the end of the file that aren't
>> in order. To avoid confusion, add a comment that might help new entries
>> to be added in the right place.
>>
>> Reviewed-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: James Clark <james.clark@arm.com>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/tools/sysreg | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index b081b54d6d22..4ba167089e2a 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -48,6 +48,8 @@
>>   # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
>>   # item ACCDATA) though it may be more taseful to do something else.
>>   
>> +# Please try to keep entries in this file sorted by sysreg encoding.
>> +
>>   Sysreg	OSDTRRX_EL1	2	0	0	0	2
>>   Res0	63:32
>>   Field	31:0	DTRRX
> 
> "Do as I say, don't do as I do".
> 
> I don't think this makes any sense if we don't actually sort the file
> the first place.
> 
> 	M.
> 

I think it's ok if it avoids review comments that new entries should be 
sorted. Or maybe we do the opposite and the comment should say this file 
is allowed to be unsorted...

