Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746410E5
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738954254; cv=none; b=iCpQEj0snvgg3cgK6/WhzmaC2S05Q4AA8ejWXQT0xOwrHX8uz32YWHmUJOpnGlwAaC7gtgt0lWG+hpEJe7wxixiNczRPqP5ufcyCsw89f7ADUr+CDTrxUV/ILNk1SP9tH2ev73joMvjkpmNyebBSdDVfQbbRcUt79ownDmS71Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738954254; c=relaxed/simple;
	bh=KBNdNo3MlGpx2KpU3I1UmYBCV3ZqGAdvjMtxh2DzjbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Df4EdDTg9Mg5brwQzMrjNouu5eKGPFWNZ5hDASJujfK7xKDNOvsON6EVeGGkdRRwIXm83oAOpv4Tjm4353e+ipWVeyTfItSzLUtG1lnR9bmHtJSNeSm84JS7ZHE+lPDSgC7MT7R8Z8msmNverWM6Bvd5uTrDCaAOC5wje6QDmAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DfGU169E; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DfGU169E"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fa3fe04dd2so361786a91.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 10:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738954252; x=1739559052; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClFzQ7PCDwu5Ar2O509WOBBN9Z5B/IHbSallb/vMYQc=;
        b=DfGU169EcbbGwrA2EfCwu1ql3Qxc8Ab8qMhsxEc/INY/vCVV99aWvDHlCUL5mqyMA7
         QAmmVc4RAiMjUJY9MbWyAMq4eNWeqvWGYECEytpeztViusLaQCPzIOEGXTOfLxzloPTP
         dv32K0psjQQTRgCaMdX0CvRdh3VxE6bsWCKK2oZWUfyFF2cisjDC+kwtpO8umEa58YSl
         ia6E8jGDYyZwDkwjuQ8xz08mP3AX6r0swz2BJhugmduGJqIK8vP7UiEocNdY+yQaCyiG
         sRjEMw+dg+AiD/ZqplER8ctWq+3TRkkPE3XBRgAq9NIki0e8RnK30T3SzUxVWyn5YSfx
         7TDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738954252; x=1739559052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClFzQ7PCDwu5Ar2O509WOBBN9Z5B/IHbSallb/vMYQc=;
        b=XFwbhDDmNGXKoyhQ5UfI9P1u2bSNHA9ZtEjiih1mrDVkHp3bdU4JI8Nj29FAIypd6S
         LOjKN1MlHGE4327SFp27Y4FKOnXMeAkk+PxIH8DYvpGfse5hsK6xTLiLJ6DGHdwFuSXC
         SqmrNJ9NdUb+LvEt1qB+eQLwnHCSBIHoAj+oaF6FPStLrtBThZmJWYjB79qol7/yTdO5
         kKebWLOFCorQwyUY9RDl1kBrk2i9GaeEMUNRYKM7otMq6a45//Dtfm1NDt63m7PWqShz
         t34w5laHdSxFP7lYk3SJdIIFig8A+sOWW1sZfGZytn5h9ifMTeKvdcXWk6PJYzZnGNg2
         /nBw==
X-Forwarded-Encrypted: i=1; AJvYcCULJ0huUtmKG+fZtdWQiK64yZwWSZUx7Lf/W/BUodFXG7gonraXIDM/ZtNs9utU3KT5PLriNh8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxd18N4mtXkmFpimXxE7khrTFgn40cFybj48fEE20P/SNY+y7zn
	4fEwszAg4nm+KdNkUqbbvEm+TKRQYKexTzFF65W8Fp/4dHo7/kPQrSd/7izebq8=
X-Gm-Gg: ASbGnct49V0iUkY8dEVEqN1quFF8g9yFxenRYEcVASwHO2wow9bbDIw/G7SV+tuEEEd
	DTn52/AuiweSEJ8VFqMB/YL53p4/i47/6WPwhO92MGs1bdvclXtUL+j8O974QP+i0oTfShmbhaF
	eofWQEDxAkYzEKG10U2A4LUewV6b39CQElH/4W6R+/0rQWZpVFcIGjMYEBEppowZv4Eh0Rzbvv4
	ywRvMaIGwLII12vbkNQBuSLwzkKG8qycoSssTP5nuDztL+yGvhrhsI1QD/N0JmoVxhJEwiPL1KS
	BfaXB4E52Cnp7R7JR1aCzSgSuhXklYBdX3r88oiDfrxETHK9Z5leY8s=
X-Google-Smtp-Source: AGHT+IFx3qX2cQp+Q9eBXyOEC/NAQTDbyj7HflA9TUhCXxbmP1q2CgGRY6AB2kSCZUzRBvIdtf4RCA==
X-Received: by 2002:a05:6a00:3e07:b0:72f:d50a:9096 with SMTP id d2e1a72fcca58-7305d44f5eemr8026145b3a.8.1738954252004;
        Fri, 07 Feb 2025 10:50:52 -0800 (PST)
Received: from [192.168.0.4] (71-212-39-66.tukw.qwest.net. [71.212.39.66])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048c16222sm3412972b3a.135.2025.02.07.10.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 10:50:51 -0800 (PST)
Message-ID: <c06aee81-1802-405d-964d-c68b3147b294@linaro.org>
Date: Fri, 7 Feb 2025 10:50:50 -0800
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
> +
> +/* read a 64b sysreg value and store it in the idregs */
> +static int get_host_cpu_reg64(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
> +{
> +    int index = get_sysreg_idx(sysreg);

Why pass the ARMSysRegs value instead of the ARMIDRegisterIdx value?

You save yourself a linear search over the id_register_sysreg array, and you can't use 
this interface with a sysreg that doesn't have an index anyway -- ERANGE is a new failure 
mode.


r~
