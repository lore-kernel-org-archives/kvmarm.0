Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B957C1C5D77
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736783039; cv=none; b=EJ3jpWyXqyTyMLJhMJDeifxVDLA2Qfld2QknjZhL5ajpl6Y2+lqzcfE+OjQgxz7pQY+YXQq6pS3nCke8UQ7XViFP22Rfq/hkKQI+4j1CJMwTzC6NgagX9X0fHARjidLZNNZ2Olmy8l40t6uzFpB7OgIPb9o2tONRPmv30eJDiIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736783039; c=relaxed/simple;
	bh=nYXTMYkpYZJVw+BxraYv+iCPishhrNSu8cNWkJaooYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fx1QEA7SJCmpMwVAB+646vJeEnmoxSNtlmRyT+p7s6PrI1YBuZu1JW1El7t4J4OLSPBlNqRwBONDES4wL5WICHj78UGbqKhyzvJ5xZSmKFqOJEG3udtKWmtr6/KgG082A83t28cosYRKzenXx6QsMzm1BjaYKkKVn90s5nbVpLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DXSr/2/M; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DXSr/2/M"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43690d4605dso31169455e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 07:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736783033; x=1737387833; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kTGNxm9xYnn4cWmuziKMIalKHLj2jvSVwL5+1WZXiyg=;
        b=DXSr/2/M6adPb/e10gxI3aFmBSp3zEcqS+kQ0VyA9fZopAbcGK9FPteSzTPfttEW89
         zvG1BjPKLWhoDSvEFPaanSmgwLIzOw23o9IVH/bhARXqwOBODKY33xiPG+GVWclA+y+D
         5oKUp1xtQ+NGWi6/0ZUtRfqW6Nj06x8B2mlgH2hGnP0g1iISoJxgWwL9zw0JCKvabpP3
         dwHLgEaM2AZU/9Jui7bKXoaHxJFBZeHvNNGtkCWp1CII+1voKpJumjulFdHoKWmhy62i
         vpBK1RD9sRScbHpcvX1DMfzemjtE0iO7Iw9aokFU6a1gscKLv2VyNec0eDKgC5U5i1Ti
         ot2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736783033; x=1737387833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kTGNxm9xYnn4cWmuziKMIalKHLj2jvSVwL5+1WZXiyg=;
        b=RL6LzVSCPdEv4NcOCWJbj35jnY6WqYJcvk9ouErAK5i+hfEmMyjTZ5athUw5LlDQPt
         A6eFnacYu/KMkn8wvIdZ8s/hV5O1lJVO9rhz/iJ3G/iSnJ2RF0ad+uAxEXxgz5Pfh4Uk
         khFHK6D9Yuo1Ww8hPt0nkHUiwXP5WdneK1Fg6Aayobkmb22+Q17gSxoFTDMq4PNimNrK
         R/AD/xWgt3nfvFhyxuQmOEqWla4Dj0biIoLES6iEM1OWx/XW01Zaz4oy+n7S/Imc64AK
         VQs24Cwr3t6dRbK1sIOwno/+E2u6a4zov8qKfIB3aYPY555C8SD+qUrbUyQhhQnuWPWN
         wu6Q==
X-Gm-Message-State: AOJu0YyTeeUsWSHFW2Kgnqc1CoFvl3Oyp7nycti69vH/BS3hrSIGVxNO
	iO4qiIwLDvYLnvDX8O9PQJKah42ocnsIe8I6ZGHYurQdxl7r5ncwyRRJE5ad6qL8lP7dMwQFJGl
	u
X-Gm-Gg: ASbGncvBGSXrFOgXwiaLWqMCK4GNhD1CwOC094jX77UiNQ27lFiQxu1U5rhvcOGSCKb
	WWT0YHRMgqtjHve52FdholCsbXuDaPzZxz2R7cMuXduidrd+ShxMjhOicyEMR3hUKTyAU/2X0ka
	5oghB1AAgXY2R1AB/ahFZbCr8GcrRedj+3xrM+b7EafzQq+jY3p+dKplGdrNBTQpUKXP+MftwOv
	c0l8tGiy55cALEjPp8iZxKpJnHNXm0uiYVzr91bxiMrnrKiP16x6vYowwK63H19RBHn
X-Google-Smtp-Source: AGHT+IHYI0z58G3tmL4uSQ3a1JaItNifz0mtTDEQSbqhFfFgd11vVuTxyh8yF5a5Jh2ewY4Zed7z1Q==
X-Received: by 2002:a05:600c:4f4e:b0:434:a902:97cd with SMTP id 5b1f17b1804b1-436e26935cbmr178745305e9.12.1736783033077;
        Mon, 13 Jan 2025 07:43:53 -0800 (PST)
Received: from [192.168.68.163] ([212.105.145.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e62333sm144996065e9.36.2025.01.13.07.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 07:43:52 -0800 (PST)
Message-ID: <dcd3918d-feb6-412c-8f1c-b19e01241790@linaro.org>
Date: Mon, 13 Jan 2025 15:43:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/7] tools: arm64: Update sysreg.h header files
To: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, James Clark <james.clark@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>,
 Shiqi Liu <shiqiliu@hust.edu.cn>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 "Rob Herring (Arm)" <robh@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20250106142446.628923-1-james.clark@linaro.org>
 <20250106142446.628923-3-james.clark@linaro.org>
 <1dad2a07-6aa2-4ddb-a337-ca3bba560f92@sirena.org.uk>
 <86ldvewx5g.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86ldvewx5g.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13/01/2025 3:28 pm, Marc Zyngier wrote:
> On Mon, 13 Jan 2025 15:07:21 +0000,
> Mark Brown <broonie@kernel.org> wrote:
>>
>> [1  <text/plain; us-ascii (quoted-printable)>]
>> On Mon, Jan 06, 2025 at 02:24:37PM +0000, James Clark wrote:
>>> From: James Clark <james.clark@arm.com>
>>>
>>> Created with the following:
>>>
>>>    cp include/linux/kasan-tags.h tools/include/linux/
>>>    cp arch/arm64/include/asm/sysreg.h tools/arch/arm64/include/asm/
>>>
>>> Update the tools copy of sysreg.h so that the next commit to add a new
>>> register doesn't have unrelated changes in it. Because the new version
>>> of sysreg.h includes kasan-tags.h, that file also now needs to be copied
>>> into tools.
>>
>> This breaks the build of the KVM selftests:
>>
>> aarch64/aarch32_id_regs.c:150:16: error: use of undeclared identifier 'ID_AA64PFR0_EL1_ELx_64BIT_ONLY'
>>    150 |         return el0 == ID_AA64PFR0_EL1_ELx_64BIT_ONLY;
>>        |                       ^
>> 1 warning and 1 error generated.
>>
>> since it's pulled over the changes in 056600ff7330 ("arm64/cpufeature:
>> Replace custom macros with fields from ID_AA64PFR0_EL1") but not updated
>> the test to reflect this.
> 
> Thanks for the heads up. I've stashed a fix on top, which hopefully
> will be in next tomorrow.
> 
> 	M.
> 

Oops sorry about that. I only tested the Perf build and hadn't done the 
self tests for a few versions.

Thanks for making the fix.

