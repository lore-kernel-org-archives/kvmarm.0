Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F37E1DF984
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953796; cv=none; b=HYfbiB7+3nIhS/KRiyQv34wVYktnt36DxMc3xAGIbKW9zBZtvxWvw4WybJfjJc9cKMWtW/BCaQrM7WwyGqUpTsW57gRGpE7R8LRL2oZkFcYEDVoPnzATHi/AiAOU/ors+VzzFycpIn5e+xEPt4wYw7ZJeufQ7HPDjIrl52dO6lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953796; c=relaxed/simple;
	bh=X+AzTTg+xMzudWLBX4oy8cRB+Se2I0o7FSaQpMToYwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mYRZCDOnoWX9HhLQyObMrKyXeEYIXTykdKxfxGrfetv7g9c72ov9IoN0e5NsSAGvYj6J5WISaIIQovK1guXkg/h/SYPDb/6cedGWtzaSKk/81UeILdc6mGnQWb/QlFjXXHrQTPMGY2clBSTq8hr7AJbwccYt7mQI7zFfZlrWfVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=coVM7Nwg; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="coVM7Nwg"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21661be2c2dso44941335ad.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 10:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738953793; x=1739558593; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yQ6ouQKtMw+oLrG0MpntcTg7tf/Dub71Tm/Bgzpv4ko=;
        b=coVM7NwgZ1Hd0vF2/WLHcyzxXuI64YmG8rQVEagO1cXcAa10p8YiZGfarTdKKuwWSk
         m5GLWiyoXlaK57izUsoBA2adz63S2ApGnfGoqJlyYh8AqVvBp4HFsdLHilwFWtghtgCG
         KS4xmYgnfin9hl0aef2e5SK91F9vfh32D2PbKJ4HV0b219jHK7HoZX6Ezbacj3By1vFn
         guLkT6nClC4rbfpUwJYVbOSLqVKlg7Nv7PXap+zh161gseCviGN/ElNvxu3kpsJMKtlI
         lh2fg2UXT1KTVV5LKHFq0TE0ZhD4DZBvoen0+sJiKWhjRmnDmTYh34X7baR9xlZ2MT6D
         4vpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738953793; x=1739558593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQ6ouQKtMw+oLrG0MpntcTg7tf/Dub71Tm/Bgzpv4ko=;
        b=Jcrp+a5AfBHJnM9n+Ye1F/fogZDHvJriTJGoEMbhD2i1htlWXmInEXPhXuPSddsNvP
         0LTKeQYqPlWDj+8dZCA7+K1GQH2YpHNx2Ae5m8FI68j4Ts2Nyb8RvpyJ1oon33UUTJCK
         a4Nlgq5vNcUFL94v3hr1Wnc/lHcNOiqv7u4fjAqfcPo3NhBrqxTdDllvlU44f5fqXdeL
         ehEQgMt+hPNH9BgN6XRxaytkb32iWgl2ANrkWHIDAFI24oqDBSU430OLbOyNrz1bY9ed
         H6vNE/Ws30qPmX1GeDnEXCuG6BNvxiRXN/zKSOFrtWdCnzHQ2UmVnpQg5R0504gnnZ1C
         VfFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfYf+EdgsAU/byCTdv79M4gkZ0kIR8LDHZLxwzxy/5UXmKI1sXf0ItziyABzXTOkzoXerR/nc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyD+4RMKtuHP20YgKT41rtQ2MqsQy5ukXBEdRyRO1uadInmd3HZ
	QMvky/7s0O9lc3HF8bsPBnxfj3pv9Kt3dfnLdCDm8qK+dPne7TJq3E3f102pJgI=
X-Gm-Gg: ASbGncuXKYL3bsLljnV8G1Hzkz7p9X2vsTOHYZw2DhL/LJHO7MokwBjSYuyhvq5nTAT
	g93iYeoi/+MPEk6wXKwfYOcRZve/AI4D4Mz8hJk9ElmBr+UPJM3iLcHcJL4fKAjTnjObWcd8szP
	ovQEichRnYMOskcXt7CMkFqIqcN+FLMut5AdjU/22M2bhCSxbbOM5dUw9RQ6yxp0XvwwjhwbHSo
	rcyPrYk8XHxtEHj6jXG/9o1OH9sxep6pNhPgOCZKXyjan6kGUvwQiZjSYN//fXhUegeHMFWQQeB
	rE0fgw7rO7EdSnHBixRXr9waYAwWq2zIyuv2luPDX1xZw586RFZRfIw=
X-Google-Smtp-Source: AGHT+IGTpeNLYmW2p3SDgp/nsdVhTg4C9ppV2GubFXW0LsvCUjQZYYkGCotavEk7zK0VwH12vNpbpQ==
X-Received: by 2002:a17:902:e848:b0:215:83e1:99ff with SMTP id d9443c01a7336-21f4e6d255fmr59734945ad.27.1738953793035;
        Fri, 07 Feb 2025 10:43:13 -0800 (PST)
Received: from [192.168.0.4] (71-212-39-66.tukw.qwest.net. [71.212.39.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f368d8ccbsm34130995ad.255.2025.02.07.10.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 10:43:12 -0800 (PST)
Message-ID: <8636f192-8438-4123-9dfa-83fd4194ed82@linaro.org>
Date: Fri, 7 Feb 2025 10:43:11 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/15] arm/kvm: add accessors for storing host features
 into idregs
To: Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-3-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250207110248.1580465-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 03:02, Cornelia Huck wrote:
> +/* read a 32b sysreg value and store it in the idregs */
> +static int get_host_cpu_reg32(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
> +{
> +    int index = get_sysreg_idx(sysreg);
> +    uint64_t *reg;
> +    int ret;
> +
> +    if (index < 0) {
> +        return -ERANGE;
> +    }
> +    reg = &ahcf->isar.idregs[index];
> +    ret = read_sys_reg32(fd, (uint32_t *)reg, idregs_sysreg_to_kvm_reg(sysreg));
> +    return ret;
> +}

I'm not keen on the casting.

If we want to retain read_sys_reg32 at all, then

     uint32_t tmp;
     ret = read_sys_reg32(fd, &tmp, idregs_sysreg_to_kvm_reg(sysreg));
     if (ret == 0) {
         ahcf->isar.idregs[index] = tmp;
     }
     return ret;

That said, read_sys_reg32 does exactly the opposite, using a uint64_t temporary. 
Therefore I would say that we should simply use read_sys_reg64.


r~
