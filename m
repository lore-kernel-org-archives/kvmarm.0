Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B0D1F03C4
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 11:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249844; cv=none; b=YV218N9AK1WcJgQzAJ0nDeTJ4FMehBaZ+FjXCH+J3EgUyNQhQ2wMq/4bASa0NmXv+LKCEjSYK8BLn5AdfIiifp2y3glZw263cvWcUoJ1p7iXRKDPT5e2JITxHPfOtOSbXwb/CmLGZmNNRoKE/IyfERbYkx5lB5HihwPwKiZEPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249844; c=relaxed/simple;
	bh=T1JKz/5gONQPF/SagAHF2pyklGaN+K3Up7hSXIu2rPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uaBaYcRPZeZe/KHMLsC3gt73ctbZUlke3+xkh9y/9EsNaML4c9CyanZTYabn9bojlb2bfb47SvcpPhs9LMpgFq0OTTWgJVnnqSBnzfub/80ZxxiVyY0V79Ys38LnyxKcX4/hEY2bXEXsVc9SoKcxgH3EUdOLu0HimY3wjLJ5Ibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vYZxmO8v; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vYZxmO8v"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-385e0e224cbso7688018f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 03:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736249840; x=1736854640; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tZSQaMswdb9C1vMZWBKr4qtwXrK6yb8GLXI20JFrh0k=;
        b=vYZxmO8vpo+p5YYHhvIsA9N58r5eMATigrPfZoVXnbM9qS3/iZI8YjhXqyzvRy3lYw
         uWOnROpSGyjOIzQFfrJUDhH0noUZnf6ge2N1EvIWwRWSUTSn+mbwxy1hASWPkRREMhzF
         ybKlAfQ55c6XDtp+tRFiH7LzGXyecm1lRmP/ujuL5Yb3s54PLqltqJUfWsM/09B5xzhr
         aKHbIa1lPLYMZwm8pYPVM2PA3bXmY4983Pd6tat7+S/mNg1BUVZP0iQGroDkCx/kRmVN
         +fkw7x36dCifNzT3anfZRYJswWzbRDMMddUJu+in6nhpSaBrdPVhYBqg3f6zHg/YzClg
         eylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249840; x=1736854640;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZSQaMswdb9C1vMZWBKr4qtwXrK6yb8GLXI20JFrh0k=;
        b=S5RjUXHt8Y0XreEtxBEfxcYedl2azdj93M6eOOTWMqG1pQqr8d0OS5hS1wJHQdc8h2
         xV8hOu6efeYEKYQTyoX8SxJxeN+lG1hKIi+x2oYtIGbKkzbmSAkVJMCRWBulxWWPfaqW
         rQieJSIQpgj60Qs4GZz20V4KktwY5xFxW+ds7uyoYHg7WkHn1Hg4ZJinT298jsIPcnzn
         LGvYG9WKkaX+6vbsvxGVOPt1NVsUI8lrZu6/vmZOgQ5QR0jWb/RtGTE8QiL5IIdeZeeD
         KvdkptKHbmWulpNI2NSQ0BlenpnXCHnMaoqTQ/uhnbJfjCAT6XhtYBGaEN1Cy5Gm3sTm
         qKVw==
X-Gm-Message-State: AOJu0Ywz9uDtmAAgg1NUuNTaayGgbbLfgSNWrXMONg9siw1080G7p65P
	bhQ0VIv7QBPYEyg9Wme7s33fp1iaa2aM0gGwE85VRDKTbUhvlScVEu+1zisf+nE=
X-Gm-Gg: ASbGncuRSd0BLFd7vkDf9npH9r+AgcbdXWjzfBtzTmrqjKcByHAetk4aFzgg9eC5wIS
	ZyAMl53u8oishMfEpDonPA66URVimgnpV7NTBQgvOlG6K9mc1u6xu4JLtEdSu5VzC46Ci5NjIIR
	+5Eww2gthK/mQC9prcuDivxnsfVHD9R4lnlXyJSB7ONLSJslgLClAT6JYLnzQ1FCl68+RFdqqoS
	zVWD16UQ6B4dIxS8NFcHMISdaMvIFKzGROdKybasiETA+7GkgToWu1lcYzvq1jb3UY=
X-Google-Smtp-Source: AGHT+IECQSms/EowoHXjQsCpkWNAzVFNllMRnf9lJ0ZzSVaV7Tpg5l1Xcq7G+0uJGbW59ugW9EO2jA==
X-Received: by 2002:a5d:64c2:0:b0:385:e968:f189 with SMTP id ffacd0b85a97d-38a22408262mr52863642f8f.51.1736249839872;
        Tue, 07 Jan 2025 03:37:19 -0800 (PST)
Received: from [192.168.68.163] ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8289a0sm51585022f8f.7.2025.01.07.03.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 03:37:19 -0800 (PST)
Message-ID: <b4801774-d279-44c3-9700-40de5c21270d@linaro.org>
Date: Tue, 7 Jan 2025 11:37:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/7] kvm/coresight: Support exclude guest and exclude
 host
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Shiqi Liu <shiqiliu@hust.edu.cn>, James Morse <james.morse@arm.com>,
 Mark Brown <broonie@kernel.org>, "Rob Herring (Arm)" <robh@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250106142446.628923-1-james.clark@linaro.org>
 <865xmsov53.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <865xmsov53.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 06/01/2025 2:48 pm, Marc Zyngier wrote:
> On Mon, 06 Jan 2025 14:24:35 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>> FEAT_TRF is a Coresight feature that allows trace capture to be
>> completely filtered at different exception levels, unlike the existing
>> TRCVICTLR controls which may still emit target addresses of branches,
>> even if the following trace is filtered.
>>
>> Without FEAT_TRF, it was possible to start a trace session on a host and
>> also collect trace from the guest as TRCVICTLR was never programmed to
>> exclude guests (and it could still emit target addresses even if it
>> was).
>>
>> With FEAT_TRF, the current behavior of trace in guests exists depends on
>> whether nVHE or VHE are being used. Both of the examples below are from
>> the host's point of view, as Coresight isn't accessible from guests.
>> This patchset is only relevant to when FEAT_TRF exists, otherwise there
>> is no change.
>>
>> Current behavior:
>>
>>    nVHE/pKVM:
>>
>>    Because the host and the guest are both using TRFCR_EL1, trace will be
>>    generated in guests depending on the same filter rules the host is
>>    using. For example if the host is tracing userspace only, then guest
>>    userspace trace will also be collected.
>>
>>    (This is further limited by whether TRBE is used because an issue
>>    with TRBE means that it's completely disabled in nVHE guests, but it's
>>    possible to have other tracing components.)
>>
>>    VHE:
>>
>>    With VHE, the host filters will be in TRFCR_EL2, but the filters in
>>    TRFCR_EL1 will be active when the guest is running. Because we don't
>>    write to TRFCR_EL1, guest trace will be completely disabled.
>>
>> New behavior:
>>
>> The guest filtering rules from the Perf session are now honored for both
>> nVHE and VHE modes. This is done by either writing to TRFCR_EL12 at the
>> start of the Perf session and doing nothing else further, or caching the
>> guest value and writing it at guest switch for nVHE. In pKVM, trace is
>> now be disabled for both protected and unprotected guests.
>>
>> There is also an optimization where the Coresight drivers pass their
>> enabled state to KVM. This means in the common case KVM doesn't have to
>> touch any sysregs when the feature isn't in use.
>>
>> Applies to kvmarm/next (00163be8bb59).
> 
> Can you *PLEASE* stop this absolutely nonsense of posting patches
> based on top of random commits? Please look at how we integrate new
> developments: they are *always* based on an early -rc tag (usually
> -rc3).
> 
> If you depend on other patches, add them to your series and post the
> whole thing.
> 
> Thanks,
> 
> 	M.
> 

Sure, I re-posted it on the latest -rc with a few commits picked up.

Thanks
James


