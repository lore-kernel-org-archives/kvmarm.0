Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043222698BC
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 08:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747642617; cv=none; b=qHeXWurkWWWF5YZw2lX2TZsFiV//PE9JoVboHtEIsuBICLwD8diFI3hDDK9uMQLW2AoTa8XF4vXN1IBihWhdpzaT//I8cXsCZW58pcIEOm1UihlIC9QOi8M9vyGvIc13Rfq3QH8nQX2dQ3+trTfyPLfxLfn1tFE9hEKupc5iDBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747642617; c=relaxed/simple;
	bh=H8ajxtmiTCjvOOIE2ApRVZ9momS0HTXG8Sy481IZrjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vFu52lGpZZonOMcGPQDZbc3f/HJG9FXuwdC/iSQqGMpNPyqIlWNv9e4cOL2lxDzMgWemScKXVjic9r8X0LOTgObu1ifDtYuJP7GXUkTHZLZlTxlzeqb7TtbsrCoB2Ik744fepHZCTbwODJBOvqQMTW+yo6QO6I13RoWeQza1fuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F0rJboDJ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F0rJboDJ"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a3673e12c4so906760f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 01:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747642613; x=1748247413; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kUL9QUi3QxO33JzaB+qq5zCH3BOr2BvD/SOLCCy++Kg=;
        b=F0rJboDJ/bBsdLAtsHMNfyrwvIc077ECYUFMi+DIqZBMyl9b0V1rmbf8w64E7p6Nrt
         HWlJ9h+zrnIN+ZeCudDyAC4QTq2ckvgue5UbqmsY4cPYnvyY1Qz75XSGJu/shY/sCkH2
         30cd22dS/d9VXhunXslPHEi+C0hJdCrH0RzSKNjLTlpGnVSvUnUDDdtxQQWygenky7jt
         J+gYtZ0zatBSwpURLcAOUrLNKzbHacGH7gzo4Nqtg31Tt/KNEgFvTyLA6bcOWzhIheJo
         j+BogC9nzJJ0FMYOjISpbEPlQCahr7JJDBKJug72y42MvOqHtPY20ooxKu5A3ez9ssXa
         lNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747642613; x=1748247413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kUL9QUi3QxO33JzaB+qq5zCH3BOr2BvD/SOLCCy++Kg=;
        b=RrMPrFJmEvdad2sZ/VCcTSfNvTcLv01hxSU7iQtxO+JdzTT9ElWfNSCfGzz7iHfDNq
         ggZIEbiuyjRhYHWg7NBmYAi1AtmlATojnQkW/9pYQqL8vsL4dWQS1Dywg1SK7ZxPubiu
         Cu7Q9wG05FgXo48b+AvwvrWGqPDjetyqY7FXSRhZ3zSWApyhmqwvIK22dGBLwiBOTAuF
         urgEctvwKtClYZu+oDTlV6Cm0XY114jlzQ00iHgc56wlKlqEZuyjKyZRyMX+1YWLHbwo
         oTw42ZFa25kctlgYvc6GYQrujGEyAWV5TpKcx8aeVpjmXvxyUA3b7mwlpuF0hayF+fTH
         FlkA==
X-Forwarded-Encrypted: i=1; AJvYcCX7pZdG3mYjUJ4vwjgJThtqvJk0q1YX8L+PhPg9CK5WHaatf7CEUXKidG8Dh9MgB/jDuizjwPw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLSxIUF4uCYjMo1vLzmvUBYGUIYwHz5ISxARvBC/oZg5JTXiz4
	NUk0KX9+nK+01nJ2GUCTL990fOeszf4bGk09bsrux20ny1Gmyy5jhhBa/EKte3c+Zf8=
X-Gm-Gg: ASbGnctR9mfaBLaPL2Jbl6VMFF4X1RVyQbBu/6Y1Y8NsVXE7imF9/mR8Yumeow55NTK
	URImMEwjMcp2YTFX+X3WrF8tIHWoNPYqPkWTJuVSuwvm6m2FlplIaXKQmA9XDxaNTovhkl7j9Nb
	G2xs1vj61E4ko3Lh9PlgNcQk9cfHDmarChiPafsiBCNXRMtPqbgTEkkazkncjF0DF1nym+UnbRP
	UMt84Stxsvih2fJGikntIOlgE72PTOze20zq4NyUOOgDUh6+fgHkPRzE1oR6AidvungWkpDzjeu
	oo19Jx7OimFX8DGhyyn/WwmX79LmuPa/OFatBzqDnArwJSM/m4Q0Jdvt
X-Google-Smtp-Source: AGHT+IHSO1KA4bNQxfQbc4te6baDy9fxE6Gyb6malS9UHm7L4qyXIFr1J9YNRKOGPiR0u203LvVC6Q==
X-Received: by 2002:a05:6000:2911:b0:3a3:6bc1:f1e7 with SMTP id ffacd0b85a97d-3a36bc1f466mr3082730f8f.52.1747642613267;
        Mon, 19 May 2025 01:16:53 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442fd4a0a5dsm132048605e9.0.2025.05.19.01.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 01:16:52 -0700 (PDT)
Message-ID: <8518b861-326d-472f-b6ff-3cda41517587@linaro.org>
Date: Mon, 19 May 2025 09:16:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] arm64: sysreg: Add new PMSIDR_EL1 and PMSFCR_EL1
 fields
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-1-dd480e8e4851@linaro.org>
 <8634d4fwnb.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <8634d4fwnb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/05/2025 3:38 pm, Marc Zyngier wrote:
> On Tue, 06 May 2025 12:41:33 +0100,
> James Clark <james.clark@linaro.org> wrote:
>>
>> Add new fields and registers that are introduced for the features
>> FEAT_SPE_CRR (call return records), FEAT_SPE_EFT (extended filtering),
>> FEAT_SPE_FPF (floating point flag), FEAT_SPE_FDS (data source
>> filtering), FEAT_SPE_ALTCLK and FEAT_SPE_SME.
>>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/tools/sysreg | 26 ++++++++++++++++++++++----
>>   1 file changed, 22 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index bdf044c5d11b..80d57c83a5f5 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -2205,11 +2205,20 @@ Field	0	RND
>>   EndSysreg
>>   
>>   Sysreg	PMSFCR_EL1	3	0	9	9	4
>> -Res0	63:19
>> +Res0	63:53
>> +Field	52	SIMDm
>> +Field	51	FPm
>> +Field	50	STm
>> +Field	49	LDm
>> +Field	48	Bm
>> +Res0	47:21
>> +Field	20	SIMD
>> +Field	19	FP
>>   Field	18	ST
>>   Field	17	LD
>>   Field	16	B
>> -Res0	15:4
>> +Res0	15:5
>> +Field	4	FDS
>>   Field	3	FnE
>>   Field	2	FL
>>   Field	1	FT
>> @@ -2226,7 +2235,12 @@ Field	15:0	MINLAT
>>   EndSysreg
>>   
>>   Sysreg	PMSIDR_EL1	3	0	9	9	7
>> -Res0	63:25
>> +Res0	63:33
>> +Field	32	SME
>> +Field	31:28	ALTCLK
>> +Field	27	FPF
>> +Field	26	EFT
>> +Field	25	CRR
> 
> These are described as enumerations in the JSON file (see [1]).
> 
> 	M.
> 
> [1] https://lore.kernel.org/all/20250506164348.346001-7-maz@kernel.org
> 

So they are. I'll take your commit and double check the other new ones 
against the json.

Thanks
James

