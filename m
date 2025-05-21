Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5C237713
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747817694; cv=none; b=iDImoFapW+rgXdfzX3jJTunCNMwkjHipI48iHfVm5EGaZ7/ZzT/QgBjPor0FYE0T7GM1q6qt2n3m39xyE6YyBkPezlIHR7npBMayhvv7jQ3XEN8A7YokTv/szO/ZCGNGrGqk3hKnHwSKBdL5gA9D5nSzn6bCBUqCz3+NeGFEzno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747817694; c=relaxed/simple;
	bh=w8uGtywi8FTT/FAgTCq7UeSzJ2Y+7StYHR09dw3aCDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5DxmuNhJuVMdle2hmTXDqiLipBrAVgid82NBao+gRfxGDOIOqlV0Tk1LphhpSsso5NS9szB7AI50+YkDkw+sZbKX+7ILOiJYeXI5fSUu483WzdKSdm/lEfwqvbfRG1OTNlhiktYzFH2VFz4TWc/aMgbZUIItGoSYP5aCKLAzBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p4PQGDdB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p4PQGDdB"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a0ac853894so5788581f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 01:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747817690; x=1748422490; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sbdPpdpIurd9SvA4bpOQHcg2N+24lyWEgW2cl5m4WjA=;
        b=p4PQGDdBT3YC3httYHG+wO7qWjJle+lNb2l7uDTA/JnaDFx0kP//VrOGf7MhaGmJ6F
         s6CPYBtU35Wo2hpNJSTiq9GmoAiRjXULE7T9xYg7TS7jZs1wIv6GJWIN2Y7JCdnCJwos
         tNTsZ7+VML56r5shBg2FpmfxmeSvxyU1YkSISmafpxXxxl/zw4pSNqKH5gydlywhnRTx
         3MFpRxc60+0vF0YnslGZW5Edro/tF0y2s07TfU18P6z2aC8N9PhAvROJC8XK3HwX0gUC
         LCPLmD6YVln/aS+j3O/23UMPctFETzSwCthz7R58Zb56j+SoB2XI91xTpzxVb+6gmL3o
         KGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747817690; x=1748422490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sbdPpdpIurd9SvA4bpOQHcg2N+24lyWEgW2cl5m4WjA=;
        b=WPcr2vaN5SVUiEwDRx2FAU5L4T9m8ExkbLnv1Pz010vZo6E0A5USO0OQwN/6pDwKE6
         Xi8sa78Jv4DDCT0jQnxdAwzKjOFNwYLEpOQ6cho9wER7nNpdHnOvU1wFO7uaUniwWQnJ
         Uz1U5TIpwKzP025mnWiVSgR71eD4wXgxcW8M7E2MjlxzdMe/q9ijwgqUWJ8Qi+gq2HeS
         stWkac7vtZzAegrvPjpzeAWu3COFxg5H4/Q/70HmqXJGpnS6wX86nmKXaCZl5iibc5fO
         0P7BDiVJLARV+Jr4Qg09ro/riXOBygsCWY9MtLjUV+iR0jcuw+F3ZMBxlp+FsJldhQO+
         Nf/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYn93IABXKadP13qp5oaLo/WbU8cpbzQDwJFtAbhz65gCUCkIJi3SzJAX1Vusec6pNGf7YgZU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnUfVbT9GRXA51MH+1SzkLNvXKWR8cGV+LKEVW6BGOfKDVa6it
	WEGCkkC6yKuUUYVbVEkyCtlPwdPMoKgSyJBE5z+fXD8DCwi06217xWWyt/lkX8Ad9KI=
X-Gm-Gg: ASbGncu+dA6svwpB4qfmu1dUhIEFeOBwiQSjAfU+f5eZhS+B/kA74a98fohCuDtoGil
	OW13jSpbEZKDCEovKlvyu9gnHbb7IXBtxLDn69DiAA3gmCTrWOi5DFhcuRRm7Bi98bPuUUpboOG
	IzedwfA57gjpyb1WcY+L11D8mdi/ENZBG9iOtGhQHHTqbgxwDovHzL7ES8NfZKgMSowARspGngw
	qlAuq8Qp//jhIQYSJcVd2J4D6annLJU/qKkPJpCE3MgrnGSTrAyqP2GuQ4VKmeiQs7sV3sVWBk0
	jt9n2pgnDUU8nYcwipgvx/cHDBzfdJboKbdYheZUvKAMBmJiObPRVJnn
X-Google-Smtp-Source: AGHT+IHcXYGtM7XVHHJEdGmOY1yvOZ0EB0s4eDSPvPzqzTL5ClJRA8YIoq/xMdJkfTjyIFVgJ2bfQA==
X-Received: by 2002:a05:6000:18ac:b0:3a3:67c4:580b with SMTP id ffacd0b85a97d-3a367c45acemr12032252f8f.46.1747817690326;
        Wed, 21 May 2025 01:54:50 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a366e08747sm15804239f8f.95.2025.05.21.01.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 01:54:49 -0700 (PDT)
Message-ID: <5752f039-51c1-4452-b5df-03ff06da7be3@linaro.org>
Date: Wed, 21 May 2025 09:54:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] perf: arm_spe: Add support for filtering on data
 source
To: Leo Yan <leo.yan@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-7-dd480e8e4851@linaro.org>
 <20250520134632.GR412060@e132581.arm.com>
 <443141db-6950-4a15-83be-ad9e9c0e03a0@linaro.org>
 <20250520161003.GT412060@e132581.arm.com>
 <20250520162243.GU412060@e132581.arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250520162243.GU412060@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/05/2025 5:22 pm, Leo Yan wrote:
> On Tue, May 20, 2025 at 05:10:03PM +0100, Leo Yan wrote:
> 
> [...]
> 
>> If 'PMSFCR_EL1.FDS == 0 and PMSDSFR_EL1 == 0x0' is the init state, as
>> you said, when user passed 0xFFFF,FFFF,FFFF,FFFF for data filter, we
>> cannot distinguish it from the init state, as a result, we will fail
>> to handle this case.
> 
> Correct a typo. The case above, it means "when a user passes 0x0 for
> data source filter ....".
> 
> Sorry for spamming.
> 
> Leo

I'm thinking I'd rather leave it consistent with PMSFCR_EL1.FT and 
automatically enable PMSFCR_EL1.FDS for any non zero data-source filter.

This means we don't need a tool change to set some other flag when a 
filter is provided (even if it's zero) and it's much simpler. It also 
doesn't prevent the possibility of adding the enable flag in the future 
if someone comes out with a need for it, but I don't think it needs to 
be done now. TBH I can't imagine a case where someone would want to 
filter out any samples that have any data source. Surely you'd only be 
looking for a selected set of data sources, or no filtering at all.



