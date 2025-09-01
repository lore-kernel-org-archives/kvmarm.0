Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED5322C97
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756729266; cv=none; b=sXNsq8Zesd0UirRYuxkFMXH5d1sRVQSHpr27VEX9X15/zHuU9NJ4xCJn4w/y+2D77UFCa0cX5fkuoW9rfzOPC714xRKOokb9k4aPHs+APVspgJQBLQ+JAy9IqicE/NmpN22cRPZumLGoL+OBEEQZLJq/4qcaG2s7/A9OnMyNLp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756729266; c=relaxed/simple;
	bh=Jnllh8eNr0YzeochvFJKtwkXdFGoYn3ypA9uJyfTXXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ntzHT2zsMO7lLXDfHoAZKq5XpF/MNDhns3Ey0+VbjYRpP+YNYVmZKc9n/HX4cKz629AlqjGYLlIIwQI4E1S9ru2pBK48dLNpEhYGulca8oZFbDbmlCP13kbs9R07+jhE9mN8aRf1XTjsylJkKu0ztnFpMR0sPLpVvv/g5SftHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WRED2Q+p; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WRED2Q+p"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3d3fa21a77fso950945f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756729263; x=1757334063; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EkH9UhD037/tOlhct2dcf8bkxNsOyHNCUyc1hozxGl4=;
        b=WRED2Q+phM0K2x3XUtHrpPronnRt4QFiy22M1XOjYEyPHk4MW/1yaqQ+j2jrqKz2Tx
         xAdLD3W42qzWwtcUn0kfmwcusDzhMir6Bdo3GxExgo71/wnhNPRHAzxLfZdfFT4vtmDZ
         wmBvTK5OcD0pk2fTf0qPVIEFoT8qh2oES0QIWdxzbn5aWWwkWDr/OoCq0X93WjkUialE
         5uSdgK37mB2tUeDIRlRC0j2ImfR8qB9+hkaVIkAm9282SOOtutH2dzoGPwlDwzJcuIM9
         sjjEmR8fkpi5OG7nbY0ooTY2Q6DHKCHOtpb0F1Cq1zewYN2MJJFT5e3Hrr4bAHROQ/cW
         XrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729263; x=1757334063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EkH9UhD037/tOlhct2dcf8bkxNsOyHNCUyc1hozxGl4=;
        b=nFTyOQkY43DefNb7hsuKJGg1UxZ6CthJa4nHCiwbHMOP53zi11Tj5ga7gqvSvVSckj
         IjA0DIVfGV4AjNYUB8SL7DbfSuFuBVBRaw76FA54QqIeM+n06R2Be72q2KVov4SMMDL9
         3DPvhneZXy0tuzISRcqCCwAJpYALFsqyBRaXrUPIqZOzs+QOt6Feq+sCVUKB7ubIQR1m
         sjxObrrqi4rd4MotDWq5Apj2vubWbqC6RqneLLPj6pAgwk++FgWgy1HBP8Q/ajxRoO+k
         gzD1RFGl77LHScBNCi8KP4wfBvjFBUxtuj8MAvaEEmKfS7CwgNR3mpnMRf/CWCRGbcBm
         J8BA==
X-Forwarded-Encrypted: i=1; AJvYcCVsMUkdl6HJkCkWzm/E8H+wcR84avnx5y5cs9zjjc5efe3kHf6OMMhyqasXkAVi90T+kYoOBHc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjebLUHL3DVOfHIwjShsC0Ju3fCOdjlTJ55UOurnDgq/Wx0+ze
	TZd0ep9A+hRpqPFq8wXyl0PumuFGK+2+kO9vC/KI1AKl6fr44XMdfbL+stwcpgmy6wQ=
X-Gm-Gg: ASbGncumItSMCMfnc/Xvy0kSCRybYDoY65pcPNAIzS0V8JCouwwZax8bAz/lx1oYORZ
	EjYKWLxQGC8sU97Dx6hczNUUh6lbilcnqORo+hRRjOXyEEnzFzObeztwZ0Wu9AT54cXjgEzWGm+
	vQl6K3xGV/6S5oFEX0IeNrmlUQta/Xc8HNeSw+YCeMqd6q9Ou35sPT+3H6HsmsPuBBMNSYBhiqY
	Nt1DesyCezJ6XIzDnhci1UL07KjlY2V9CSG3YH59G0nOaF2nHE1zwl86R/BozVjluiQckh0ZAmE
	bMj1tZCp9V2jh7x8Gif+Frmu/ubGze4Jmy0wAWYcOIAFoqv+1IjWioD5f00oz1KoHt5mzw/N+Ms
	Jf6Aprryad1278nc9sQRsztZbVnk=
X-Google-Smtp-Source: AGHT+IHbSmwRu3Gk1EehF9mFzPZ3IgKGG6T2VrHQ2WXexIn9NyB08JhzOfdoNYyeZhdmO1rufQhWyA==
X-Received: by 2002:a05:6000:1ace:b0:3c4:bc55:65e1 with SMTP id ffacd0b85a97d-3d1dd434397mr6103249f8f.24.1756729262852;
        Mon, 01 Sep 2025 05:21:02 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d60cf93cb2sm5542282f8f.12.2025.09.01.05.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 05:21:02 -0700 (PDT)
Message-ID: <bd224e52-d786-4922-b2ba-b52f0c73badf@linaro.org>
Date: Mon, 1 Sep 2025 13:21:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
To: Leo Yan <leo.yan@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
 <20250814-james-perf-feat_spe_eft-v7-6-6a743f7fa259@linaro.org>
 <20250901101904.GK745921@e132581.arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250901101904.GK745921@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 01/09/2025 11:19 am, Leo Yan wrote:
> On Thu, Aug 14, 2025 at 10:25:28AM +0100, James Clark wrote:
> 
> [...]
> 
>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
>> index 3a4ca7f9acfb..a0361ddcdca4 100644
>> --- a/arch/arm64/include/asm/el2_setup.h
>> +++ b/arch/arm64/include/asm/el2_setup.h
>> @@ -392,6 +392,17 @@
>>   	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>>   	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>>   .Lskip_pmuv3p9_\@:
>> +	/* If SPE is implemented, */
>> +	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
>> +	/* we can read PMSIDR and */
>> +	mrs_s	x1, SYS_PMSIDR_EL1
>> +	and	x1, x1,  #PMSIDR_EL1_FDS
>> +	/* if FEAT_SPE_FDS is implemented, */
>> +	cbz	x1, .Lskip_spefds_\@
>> +	/* disable traps to PMSDSFR. */
> 
> Nitpick: the comment is a bit ambiguous for me. Would it be better to
> say "disable traps to EL2" or "set the PMSDSFR bit to disable trapping" ?
> 
> Otherwise, LGTM:
> 
> Reviewed-by: Leo Yan <leo.yan@arm.com>

The bit we're setting is actually called nPMSDSFR_EL1, but I can change 
it to:

   /* disable traps of PMSDSFR to EL2 */

> 
>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
>> +
>> +.Lskip_spefds_\@:
>>   	msr_s   SYS_HDFGRTR2_EL2, x0
>>   	msr_s   SYS_HDFGWTR2_EL2, x0
>>   	msr_s   SYS_HFGRTR2_EL2, xzr
>>
>> -- 
>> 2.34.1
>>

