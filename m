Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737E918C93C
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113614; cv=none; b=WeM3wxNnKfn4waUIXdKQJSEyPJmjZ9NUtTxhSu3MJkQNBZ6C7m6aQgO2tNjuzTyUeRs4OD1+ZB32zyH1GZ0361WCBIVe5560hFYAUXx0JplomWHppEzfbZjtTNg2H6XDEka1SyAtq+g3uJY7r6flOkyXiIZJnHI99TCpcpPm0EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113614; c=relaxed/simple;
	bh=93EvhuTl9ahqB5emxkAMtf9z0ofEgXEiFiod3siNX7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3df49XfbSV4/rQKGXAynE3nLTu0AK4AagwwNz4GVbYsvTkJqwBYgFAgWtPIOqkigHNXriGcnz7m8sVUyR6uw0KmFLN+lSBZjf/xKYWDUur3EksKjU+2P1omXkHOPcUv/NmqlMdVRii275vTKFUq8iRGYjff0wj1oIvfBPWahes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FwKdfrQk; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FwKdfrQk"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3685a5e7d3cso419864f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Aug 2024 03:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723113611; x=1723718411; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Vywnv2khWwNnQXbEb1k0L/IQrqUeraWcCrhITh2GYs=;
        b=FwKdfrQknUyMblPzJ0wYn0TbzM9yywUp3LPGcTjHQON9nRKqBdBFj6Cc0RkTO4/I8g
         XHs/a7QZ4bQxaP589tJ9qYY7eUfJDj5ZUFoP1PdckzdLIafk2qwWK0mfmTPOiZ49E9bq
         h/TPGe/11ZfXA3L84MV53C+xW91E9Lvhc72kiqKIp0Rv/4UhmxseiQjO6Gg/l8+kN+hx
         l+vVi+CL5xoIeUHxlAJDvSKmpbS2E8C1B7MqaxmADdawtsEUk5PQYoe1mXhGhtesdnjL
         6hR4vPwN6WTbDKTAoThFlxjYQ1mWW1D71g0pGXBtjhYt1fk/ObkKIG7oKrNTLSt7Prbz
         n/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723113611; x=1723718411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Vywnv2khWwNnQXbEb1k0L/IQrqUeraWcCrhITh2GYs=;
        b=K+qhq77k3BNHxLyPRu2Lm0nxi0/ZmEX0UNOZBtPxpLLke268bvri7bQAxNPkquHEcG
         kJIu+O2c17dEq/HXG6cId7OYCx/cciXiZ5xd9j1kyPNfMLlnPlsXNwH3aMkXvlZUb6io
         2uXLqUeEx8OQIWrC2Cs5wnTA4GzyG/4gBdw2yFAyaB0NatX1oUe1lwlHPTOKzGx6fc9j
         i/zuXoyr1pdwZTlNBjL6CPQUBpC55+sRr/zikIhkj1XaQxRIU05g3z03uRzGO+kO/Tno
         3IkNxVjvXXacE6mB1B/yswMNkbj4B0ft7tPL6UztkSlANqJ9u28g5WvXLu2AuTOpd29l
         2pwA==
X-Forwarded-Encrypted: i=1; AJvYcCXGZBHawuXP0WGkk1qhpapI2Osz8eXkQxjBOqRcyl8rab7swRpuc6/fen+gMAlRES/3ZmkaASNZlnSAdq/d9Ys3oze7gQKI
X-Gm-Message-State: AOJu0YyTR3iv+DS6mggFcM5kcbN0mg6XWVjBsOHQnbioBsv4KM1AkTc+
	2IQtB9abppDiMDt20T6orJ5ZxD/rAFzQxItBkaJiesXpfWOY7QJZuHDvnbPd1HQ=
X-Google-Smtp-Source: AGHT+IEGxZsKPo0MfhXCCFxSfCW7K4JInkbw4e4NnCHx4wlQJHciyyD/pmRe1wNjUVMP3CXg9q2VBw==
X-Received: by 2002:a05:6000:1007:b0:367:9614:fb99 with SMTP id ffacd0b85a97d-36d273bfaf4mr1044354f8f.10.1723113610569;
        Thu, 08 Aug 2024 03:40:10 -0700 (PDT)
Received: from [192.168.1.3] ([89.47.253.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d271569d1sm1459252f8f.18.2024.08.08.03.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 03:40:10 -0700 (PDT)
Message-ID: <67ac1ce4-7d95-4215-ae49-c32869bfe6eb@linaro.org>
Date: Thu, 8 Aug 2024 11:40:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] arm64: Add support for Armv9.4 PMU fixed
 instruction counter
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 31/07/2024 5:51 pm, Rob Herring (Arm) wrote:
> This series adds support for the optional fixed instruction counter
> added in Armv9.4 PMU. Most of the series is a refactoring to remove the
> index to counter number conversion which dates back to the Armv7 PMU
> driver. Removing it is necessary in order to support more than 32
> counters without a bunch of conditional code further complicating the
> conversion.
> 
> Patch 1 changes struct arm_pmu.num_events to a bitmap of events, and
> updates all the users. This removes the index to counter conversion
> on the PMUv3 and Armv7 drivers.
> 
> Patch 2 updates various register accessors to use 64-bit values matching
> the register size.
> 
> Patches 3-4 update KVM PMU register accesses to use shared accessors
> from asm/arm_pmuv3.h.
> 
> Patches 5-6 rework KVM and perf PMU defines for counter indexes and
> number of counters.
> 
> Patch 7 finally adds support for the fixed instruction counter.
> 
> I tested this on FVP with VHE host and a guest. Also ran kvm-unittests
> in Arm's kernelCI.
> 

I ran the Perf tests and poked around a bit with PMUs and chaining 
events (on non-fixed instruction counter hardware):

Tested-by: James Clark <james.clark@linaro.org>
