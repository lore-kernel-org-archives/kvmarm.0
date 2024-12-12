Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A36215712
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734014282; cv=none; b=EPpXDqH+M3GXICEmKyCxlF/rT6+jKlqpLBpJA12xsuNtt6/qakg+emzXVCC/x+UPpPt1iYsBaQVEiBuVcRm5p9vQmYYCWDp5gr4IYi4MnI9LCzQTAephrAD+Lo2Jr/Z5LJNoyjfjNNnhGzryPqV2fchhJVO6zOOw3Ze5bn1tE80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734014282; c=relaxed/simple;
	bh=7wdUJVOpKunAjBnZ/Y2oYssdLm7+VQ+wq9aWZWy+6/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X8YUsdTvOlc6p2u6s85cpvu6P0yHErQ/plhITMuNvbe6dHJMj8O5diPIFLgTJAmg+8RrfZc5IhFcZvss7uDSmCu+Ucs9BWA8yd0f7Op4uoJVhMURPrvUXG91JTs4Y155xODhKIpHg+urpYq0Mhmq3Omf6lBddhIvuDkC5ieupKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fK91G/h3; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fK91G/h3"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3ea696c4dcaso247111b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 06:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734014279; x=1734619079; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WClgGnNKhbkqYl2M5kjAPX27ot9J1JWOs4M4aBmFm9w=;
        b=fK91G/h3iGro1KRS3XeQw086Rs293JA4/csuLuKBQHc5+x3z0aUozRGOkRO9W/n5CD
         yicd4LnuyEGRYIilmBC0BzmvPJ08alOVp89iqbo69zF2xDWWhMcMLu1lat84nKYXTZQk
         Luc50ZOrM0tFfdfqRGSI/xcWyc9qNIvGynfDkTnsyHYjlL57FFDn6gs8k9oZIhnyHrIV
         /OnlOhSMWSXH5YhlqhEtC+iugGLvLPCwXnXG198SDe8SqsYHfsr3CZFGtJin91a/rp6t
         le3zI8fQDQIv8hgi4eeafQVY8+pvPSRB2cf5SuVpEuScq2yzcUQV/KcJY951NjVwVUNZ
         3vLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734014279; x=1734619079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WClgGnNKhbkqYl2M5kjAPX27ot9J1JWOs4M4aBmFm9w=;
        b=pOMXhPJKg+aCh9SKJJYSlZ5G08jE1ICBKwINixTvUKm03u2h7KfQMPzrXYmgsNu4O0
         kmg7APXWtS3yomou90+CkOA3ePGNQR2JBS4OROxfopi4fAoJHRRLsEtrYPM6QZg8KabC
         SUqGFQc/b4Vw6ZqvMGHY/KgdJE90P6g/Zym+l/Ci7WjfSMqdb8t6D32LB9yVyMEsfV4N
         VztUtCZ2NMMQLC0rwtoQZ+Geob2dsiB1fL23SfSwFGHr4EP2KpSBp3fkwxwqC2W5iH2c
         xCC5Az8FufO2ijKtK8yxja2oOzM64zTNF1XsIxbFoWSbGGRyICv4U0asVM+eYL5rGA7K
         mJUA==
X-Forwarded-Encrypted: i=1; AJvYcCW5EAMddYiOB2tbyp2304kSDrpwHJCRtvshi7En0kwVEOS6IaMdvpra857dEGnxB6J36XzMtO4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ2q+f5LFIepaqmjlAKJjL98MJgSd5l1TAAFX86h7jUB13b7rP
	BPBfyGjf7z7PHF+5K3QvBsD2WZAPV3boXEnyjoYi5kDfmdychWo0/mW7+X5rz2M=
X-Gm-Gg: ASbGnctWDcTav7U1nY1wjPZVXP/wwHmvMJWjm96fXKFhFAYgCfL5eVkS7n4v2ctdqIM
	fRwLlFuIF+/L1FxaODw6EomYBGYXBu0/1LssRfad3R6VNcr5l7UFvII6rGM2iFMzuJf7LtL40Jx
	k/emdAwFJxkD+0mJjllzZZaJXIICocae7bkfnzZNeF9au4PTxnUuFUbV2W2egWuL25wWUVTS2rN
	iAt1DzDtorgYce8+p03vT7gAU8l2OAw4BUMOgfbUR6R/tKKe9WmnvzzEaT8sksNwuFkCy83g1D/
	rcv1wjFuHbCnL/jvTYBV/Y2sdkXI+jVuz6o=
X-Google-Smtp-Source: AGHT+IHzcsNqE4IFEDtNAAVXxkbmviqgknyI1oXeRyYPRBrNN3gZRaB7NkY5HJTFgq2pBMw1QofjPQ==
X-Received: by 2002:a05:6808:1381:b0:3eb:66d7:a33e with SMTP id 5614622812f47-3eb93f95d83mr2328391b6e.5.1734014278863;
        Thu, 12 Dec 2024 06:37:58 -0800 (PST)
Received: from [192.168.4.112] (fixed-187-189-51-143.totalplay.net. [187.189.51.143])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3eb8d6da3ecsm608895b6e.50.2024.12.12.06.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 06:37:58 -0800 (PST)
Message-ID: <2a83a49b-6863-4fb8-b5de-c3eacf3cdb77@linaro.org>
Date: Thu, 12 Dec 2024 08:37:55 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFCv2 02/20] arm/cpu: Add sysreg definitions in
 cpu-sysregs.h
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, alex.bennee@linaro.org,
 maz@kernel.org, oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-3-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20241206112213.88394-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/24 05:21, Cornelia Huck wrote:
> +#define SYS_ID_AA64PFR0_EL1                             sys_reg(3, 0, 0, 4, 0)
...
> +typedef struct ARMSysReg {
> +    int op0;
> +    int op1;
> +    int crn;
> +    int crm;
> +    int op2;
> +} ARMSysReg;
...
> +static inline ARMSysReg sys_reg(int op0, int op1, int crn, int crm, int op2)
> +{
> +        ARMSysReg sr = {op0, op1, crn, crm, op2};
> +
> +        return sr;
> +}

Not a fan.  Why take 20 bytes to represent these?

Our existing ENCODE_CP_REG and ENCODE_AA64_CP_REG macros seem much better, even if the 
argument ordering doesn't match the column ordering in Table D22-2.

> @@ -841,6 +849,51 @@ typedef struct IdRegMap {
>       uint64_t regs[NR_ID_REGS];
>   } IdRegMap;
>   
> +#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               \
> +        ({                                                              \
> +                __u64 __op1 = (op1) & 3;                                \
> +                __op1 -= (__op1 == 3);                                  \
> +                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
> +        })

Ah, well, this answers my question re patch 1.

It seems a shame to use 128 slots to represent all 9 id registers in the op1={1,3} space.

Do we really need anything beyond the defined registers, or even the defined registers for 
which qemu knows how to do anything?

I'm certainly happy to replace ARMISARegisters fields with an array, but more like

enum ARMIDRegisterIdx {
     ID_AA64ISAR0_IDX,
     etc
     ordering arbitrary, either machine or macro generated,
     but every register has a symbolic index.
     NUM_ID_IDX,
};

enum ARMSysregs {
     SYS_ID_AA64PFR0_EL1 = ENCODE_AA64_CP_REG(...),
     etc
};

const uint32_t id_register_sysreg[NUM_ID_IDX] = {
     [ID_AA64ISAR0_IDX] = SYS_ID_AA64PFR0_EL1,
     etc
};

struct ARMISARegisters {
     uint64_t id[NUM_ID_IDX];
};

This seems trivial to automate, and wastes no space.


r~
