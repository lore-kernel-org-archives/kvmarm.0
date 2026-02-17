Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3F5C13B
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771336744; cv=none; b=Zl4z4GPg9Zyg3Fg9t7vhXs0LMEVS/h32QXAJOxqumxN463i7SXc13AZQas4oy5cNDcrnsvflxHQ7hV7dlOIwKvLuiXvkzIVsiu0LW9WLUzwWC/KgQLgsXzFkdHQLmQgQJVZ+lLD4wQ+My2Nj84UCP9EkRXHvTqW06jM7DwY8zgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771336744; c=relaxed/simple;
	bh=DJQLEXpOMZ7mJRrJeulgyumNP2K404TBIAfARMlJXsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CEcJH4TSOqNdC64HgxtnYZdb3YfxKgd+tAziQI3Pby+29BmlxvuDLpgJlAU4zevr23kCKOzMEqP9wg+FCWEKWgVzghj8c4t51Qu2kORMkV8EMuqYdT5+Nw0RBuuCNTHepoLgdOjZ0msk9bnLCC7RZKeopVaexKCB9OP5WIpXPGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FMwrHrzt; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FMwrHrzt"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6580dbdb41eso5485056a12.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 05:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771336741; x=1771941541; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0qm6wSg3YMFqBYaKKYJQYHdgXgOxUBgkA3dGoL/vl0=;
        b=FMwrHrzt7au6V+71xfPgRRhSBxyO18OkpXKHAV73QEyVN45G8hDwa1ltbZZf35PLPS
         l1kWRAi/T+AT1rUYhoPVjJZHzbKsWFjfLPbH4GSsTM1rXrOaijJnqxHYEqPLvqKGBLrh
         H+PgwzYmq4bTTh+Dcnt5BWvVfWXcrAlcQHWpXr7o3iq+toJjlqqGCxbjPsvLiK0J0+PO
         7wjaovb6aMBtxG9cWJPXwnpSW3n9UYimqbS0xl8mCaaKWRrIwdONNtg8+5BHvDDDE2yk
         Q6Umay+1YYxTibEKPuykSKvZYzRq6gsDE2Xao/qQ7H5QN+r731sL59Q5/fTOBrcQKoNt
         OcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771336741; x=1771941541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0qm6wSg3YMFqBYaKKYJQYHdgXgOxUBgkA3dGoL/vl0=;
        b=nyW8iDoF2IZ7K7Nb4u9cTKbLK/cRLUCjtM9VnWKmBh6VGJB2jNix+geUqwsvCqKuK9
         6dbocPQOA6JdLt+nHp95aEEtV5n7TcCApL2NY1Nu4h73b+o4zgLKjYnYe7p6jFUyOGLV
         4r4FTti90hpDlg9MSC7uwAgp1NVhVQhjey8PKXVyo05JyUzqJi4HG9J/Yis1WSZR46Qf
         3EDKKqfvgEpvN9WMoAFKnrxMttamaDeVA2mpBA+sDiFvhrZjJQhs6Qblvf+u488KCaJ6
         9G2rRscg7Hf5M9bVPYR4R6/EPjxUyeO4/zaqBKoalvTPjBwRv0md0UJnGwuYGojNqh2y
         OByA==
X-Forwarded-Encrypted: i=1; AJvYcCUtFpe1HeC5Ieu8kdrLQAaQB3JvEv6vBuMP7A8C77X5QMUYBY6uOUxw3frEUmewLJhVYZm2e3w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRHb5Wq9dtm1YIAlRB260PcP7XqOHqDg5nvzBsAffnCmQmVkTd
	jrffz9xwek4lI9h9pb/YbOY318Ihu/Y8Yd4a5TXynBXy9JYXJRUNQxSduoo8pucqPGo=
X-Gm-Gg: AZuq6aKjDcjI00kIkbWILiWYm9Wf+XNXHVikrKNkHNLz/pqdGenBAyaRmlm6I+L4ajx
	TIP9Q5W+W7yqp9B0dq7X7PRDgKRNnmzIw378OTuRdjEkWsYMZdFyvhr0c/Vqd99DN9mFhk16gsq
	UCIIFsiCjnl6W4e+ziW9JYfxab7UJmWsis20PUapo4oVemj/uQxF5i0ha1ZvaoAn+T/n//jiYJZ
	Ag/u13JjhiUH6E5dgYXX8+VGpdYAe+JwUAH9Q+bpqJ5lVg3DJkMzk48YKTAErxeeFm1+L7xKzyx
	C6nLuiZIYANWBd3ugpvU64OtnHMPD00EIZKcH81y7ZlMf+WyVblkwSqsAHdIQfsgxd0WfjFOZVn
	+i3EQ4/2IPiZGQrN9wceSDEEoSXwZVZSoRIHFkL3nZmCtciWMDNpukrbpyPECwNG/LYtFDsa+0M
	hdDiB7nDlfmzlC419/r6noVTW/eAhF
X-Received: by 2002:a17:906:4795:b0:b8e:12f9:5fce with SMTP id a640c23a62f3a-b8fb4574ebamr726740266b.61.1771336741232;
        Tue, 17 Feb 2026 05:59:01 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc7385e60sm350983766b.19.2026.02.17.05.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 05:59:00 -0800 (PST)
Message-ID: <b4421029-54ca-41e0-8055-56f9f525170d@linaro.org>
Date: Tue, 17 Feb 2026 13:58:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 Oliver Upton <oupton@kernel.org>, Leo Yan <leo.yan@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org> <aZNUqONyOUVd0opW@willie-the-truck>
 <cda4e111-29cc-481c-aee2-811f4178f54b@linaro.org>
 <aZReWRme4InoSa8M@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aZReWRme4InoSa8M@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 17/02/2026 12:26 pm, Will Deacon wrote:
> On Tue, Feb 17, 2026 at 12:20:14PM +0000, James Clark wrote:
>> On 16/02/2026 5:32 pm, Will Deacon wrote:
>>> On Mon, Feb 16, 2026 at 02:29:31PM +0000, Marc Zyngier wrote:
>>>> And even then, I'm tempted to simply get rid of any sort of
>>>> guest-only tracing, given that TRBE is not capable of representing
>>>> exceptions that are synthesised by the host, making it the resulting
>>>> traces useless.
>>>
>>> I think that effectively means reverting the series merged from here:
>>>
>>> https://lore.kernel.org/all/20250106142446.628923-1-james.clark@linaro.org/
>>>
>>> but then we still need to clear TRBLIMITR_EL1.E.
>>>
>>
>> Removing that series would actually have the effect of turning guest trace
>> on in nVHE for non-TRBE sinks. The reason for implementing the filtering was
>> to turn guest trace off because a user didn't want to see it.
> 
> What I meant was, revert that series and then also ensure that both TRFCR
> and TRBLIMITR are always zero while running in the guest. Is that not
> sufficient?
> 
> Will

Yes that would work. Although if someone is currently tracing guests 
from the host then obviously that will break that. I'm still not 
convinced that tracing guests from the host is broken enough to be 
completely useless. But there is a chance nobody is doing it, or waiting 
for them to scream might help in understanding their use case.

It doesn't seem like the combination of the TRFCR filtering stuff and 
zeroing TRBLIMITR is too messy either though. I suppose you could also 
skip the TRFCR switch if you've disabled TRBE if you wanted to save a 
register write, but that makes it slightly more complicated.

