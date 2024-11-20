Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F918A6A8
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 09:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732095821; cv=none; b=eIRL8qoRydd0jbA30dwjg+MmoCuGyb0kcp7PwFK8212yqAJQ+JWHChMKu3PzjAEcXPSKKL0O9F+/eomQ1p2GK8vWEWruVJoiXcS2dtmVz1A6IuSSoG6I+dRCBKgd/cNw3Pt5gqQHSyiSEGKuiAdPjVXsA/HDyVn4l/737KKyupo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732095821; c=relaxed/simple;
	bh=3IYRdTUfO3yDGyAuYaGAOpNJ3n3ybKoAhhl963CdxV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KEHO2RpGdcZOjW+pmHcFWNSrA5N3CZ3LUgFkXuA6PD8m06eHg0NC18WUCDCnkagTdsoD4cKWrMUCYxjfMrZERMTELS5BpjMfmazt2c+yHoazoWmhL/rsbJZWKLFbpdT1iQEohC15PSQSN9JYZfUA9v1cTU7bUllPaREtIzJ0LDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y07NonX9; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y07NonX9"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5cb15b84544so5643817a12.2
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 01:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732095818; x=1732700618; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hnMuJVLT9f8LFRD+CDKFKXxiScl2L/4chGY+NToAMxA=;
        b=Y07NonX9OKcqckvANbfjyeUpT78vUOgm225CGtNKfOdgA5ku0B6+N9TvQz0xKtHVtY
         tuy8ObbhloVpCbviYNYrWZB+/76gmcEsEPAeOnBTcWddoYFK+0I2u7yUhQM2eTqG4HY2
         1HABIPD2r/Bh+p/ZUtlzHgtEfrEjREgRZR9Up7dMb3G+0AYa0pJnqTNBafwzZiSxGFFj
         q9NCLf8M1vkPPqHlyJ2o58+LW2YD6HLOb6Zu9bbSYJ6aOSKEcVCMzjO5H8ERRKc9ks+3
         YBdeFpD/S7bCWrA/KpfXFOq44q5/WANM0xcoWc12LRKj8wYyaL7d8CsiktqJ3MfjHs/P
         c1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732095818; x=1732700618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hnMuJVLT9f8LFRD+CDKFKXxiScl2L/4chGY+NToAMxA=;
        b=NF26iUqAQazt0UX9hpOUvhqg9z/Cb2tnUmK9XjdB3tfaG5iMICHToU9Lu0qBf3843t
         MNJu6L4Yy10pywdbzeCl4nBSCm7SJvKjKX+uHew/IvKrQZcipdtMm/sP4Bc3zSMgKbQy
         6cOHG27x9BfWNGAt4Bzzcrs5yAJzsQNJhLONaf4uLyCwtZexCOS49sJ+9ia4a5yFrQEa
         uSmiwkFZNP3h9wS9P412ZqF7yDj3n0lvwUu8dSAJUVl1etdskJMmWclRTU0gt5NGb7xg
         U1OouuTJ8yVB6sQFdvq3DEYLsG6OLVvaHEqPv4imzIyd4kIoq5CNW8yX5WYC9nX3LvB/
         kWKg==
X-Forwarded-Encrypted: i=1; AJvYcCUR7OLHAYLMZV1WHed7h8T7tfEuQMXB/E1MxcgG6aTFpkYlmQK0VQHSCfQBlOlxmORcZxozxZU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc7Sbq8Pv+mcLnVhIiL/yLvW2W9PYDyb25TVZkySZZZwoXiCZ0
	dZS400Wi9aRQ8SFtn10WqyukffzzgLIecOR0d7VDIAebic0WBXvcRF6RQFPKREc=
X-Google-Smtp-Source: AGHT+IHPRVJgISuT50tHDUxOcColFsHDGhCQoGsxkLXqTG91NWmfuCwkbfL9wtykWsiswaDg+PK2jg==
X-Received: by 2002:a05:6402:2807:b0:5ce:fa47:18b6 with SMTP id 4fb4d7f45d1cf-5cff4c41f5fmr982907a12.12.1732095818491;
        Wed, 20 Nov 2024 01:43:38 -0800 (PST)
Received: from [192.168.68.163] ([145.224.90.249])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cff44de59bsm615495a12.2.2024.11.20.01.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 01:43:38 -0800 (PST)
Message-ID: <0f6241cf-8938-4c3b-82ef-fbfd29676bd7@linaro.org>
Date: Wed, 20 Nov 2024 09:43:36 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/12] KVM: arm64: arm_spe: Give SPE enabled state to
 KVM
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: coresight@lists.linaro.org, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Fuad Tabba
 <tabba@google.com>, James Morse <james.morse@arm.com>,
 Shiqi Liu <shiqiliu@hust.edu.cn>, Mark Brown <broonie@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241112103717.589952-1-james.clark@linaro.org>
 <20241112103717.589952-8-james.clark@linaro.org> <Zz2o9XryCezwAf61@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <Zz2o9XryCezwAf61@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/11/2024 9:16 am, Oliver Upton wrote:
> Hi James,
> 
> On Tue, Nov 12, 2024 at 10:37:06AM +0000, James Clark wrote:
>> Currently in nVHE, KVM has to check if SPE is enabled on every guest
>> switch even if it was never used. Because it's a debug feature and is
>> more likely to not be used than used, give KVM the SPE buffer status to
>> allow a much simpler and faster do-nothing path in the hyp.
>>
>> This is always called with preemption disabled except for probe/hotplug
>> which gets wrapped with preempt_disable().
> 
> Unless the performance penalty of checking if SPE is measurably bad, I'd
> rather we keep things as-is.
> 
> Folks that want to go fast are probably using VHE to begin with. As you
> note below, we need the hypervisor to decide if SPE is enabled based on
> hardware in protected mode anyway. Using a common flow for protected and
> non-protected configs keeps complexity down and increases the likelihood
> SPE save/restore code actually gets tested.
> 

I'm not sure if there is any measurable difference. This change was 
actually in response to this review from Marc here [1]:

   > Why do we need to save anything if nothing was enabled, which is
   > *all the time*? I'm sorry to break it to you, but nobody uses these
   > features.  So I'd like them to have zero cost when not in use.

   > Surely there is something there that should say "yup, tracing" or
   > not (such as the enable bits), which would avoid hitting the sysreg
   > pointlessly?

I suppose I could have taken the "zero cost" bit a bit too literally and 
maybe there were some simpler optimizations that didn't involve strongly 
coupling the driver to KVM. At least for enable/disable, for filtering 
it would still be required.

I'm trying to think if there is some middle ground where there is a 
systemwide flag or static key that gets set on the very first SPE or 
trace session. In theory it could be simpler than this per-cpu enable 
disable stuff, but in the end it pretty much ends up needing the same 
info from the driver (and has the same protected mode issue). So you 
might as well do it as fine grained as this or not at all like you suggest.

[1]: https://lore.kernel.org/linux-arm-kernel/86bk832jza.wl-maz@kernel.org/

