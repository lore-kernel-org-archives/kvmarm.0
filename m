Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F0826B2DD
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739892141; cv=none; b=ZXNF45K81fk6CFi0Fq1wzau3tThY1kyUB0/XrCed4dIf9SuCY0Xr1ugs15ZjIehMUNjz/veCSeRm+RW8YFzwx/qOC7cMgARU8DlYl5cQ9fYWgUcu+wCBBvJAAdE57U2R88ao5zpXiLQbXp5uUQtZWNOM6zWGwg4a1Orgxd/lK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739892141; c=relaxed/simple;
	bh=yPpobAjxWyvd8DIGuDfNeq29qMEyf2ao4zFEPI0Ut+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQNDBGUHqHBeV6tBplCYtvEMTsF/WHVIibXrlsSPMB762X+FPgcgQb8r3WTnM1kFU8s6bNyzUW6TtEpOsUXoTO1VADFTTJoAMEcqiAzIVkQVTYfWFryBIcSay+1KHPvwBIHsUdPG/qEdlGeO8u2Wm274px5oUgUneiBPHKUJsOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CoIIsnmS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CoIIsnmS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739892138;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ot+fYgSVKyy+rAYXe+wg7VR70oe9I02rM5x2Ee3gz8M=;
	b=CoIIsnmSWTKSn1St5s9WQrCd/HPrPoDLFuPxy7aXmT2wypcpIgmIGcsZJNqpYqkTWIR8JV
	mTWhZTZTeEwEcYG2q07Ao6/vHPMWpAceAieMPIhACMF993YoSgGVHr4r565vkd7v++jRLw
	3cYtnJEiFNoQDwu/2XUXjB8amEKw1Yw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-G-pMNDc9PoaitSE51Mbiqg-1; Tue, 18 Feb 2025 10:22:17 -0500
X-MC-Unique: G-pMNDc9PoaitSE51Mbiqg-1
X-Mimecast-MFC-AGG-ID: G-pMNDc9PoaitSE51Mbiqg_1739892137
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4393ed818ccso49044435e9.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 07:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739892136; x=1740496936;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ot+fYgSVKyy+rAYXe+wg7VR70oe9I02rM5x2Ee3gz8M=;
        b=DsSvoEg5M23YSJk3tQlkrnXZYDRUtc8hcqoPDO7Zwokas8DFRPbadJQYgvk5/URXTX
         d+wqezVDlVQU/68FsoPv9U7iI/2C01q8OYwqidPjqsSbYNUDDT8FzD047P27oAqvkDTA
         g2jfjnUXb7X6q11DqAwOQwuz3bvJ6QnFoyjL9AD7fo7BoWAprPI5Y7y6pKmyGZWRl6oO
         7WtBNdmrNJzhqoUbXxX63jmBCJTul90QVNi18rTM54T5fuuz1Uk2DDBvvBDKC4L3kLX8
         C9c6z+99+zZL47MwJgoIPAckKEo30kfyw9Fik48vAFTrHeFTJ3A9H+ECA9WKCBv2s3hY
         CkjA==
X-Forwarded-Encrypted: i=1; AJvYcCXvnsUUyUWimSuAWfocZqZIRj0E3tlCZrb5609tPsKFeTN+pC1BsGbSMJh42Aqps/BkAxIIiqA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9Gz4JNrXkxYVNFWv2TEWKchDRlZjjX62NsjqcKjJNgguJ7sEI
	vfQ2pN9zLJviX1iXrZgW2Lv/n5y7aE+wdb1X8aPTwbxwtnWrwqDnxnUerbP4mX13aClqx/JT1FJ
	WqQu8PxcD/MAHbH8pSv87jLpA0VYYTK7U8socVwcsrF4EAFZKs/Kt+Q==
X-Gm-Gg: ASbGncsT5HX1tz91pzfI6Oyfa1F7W9ojl0Jp0rjfVWI85mvPO+gVJ0DGApjjyGuBCCQ
	nqZRwoK6utsebibrLKk/eVt6e5j77frP6g7mLpC1jwUJW9JNgYko9hwWpVLwqPB2K6M3gahh4cB
	CpumbRf79GhpDZ4tBsJpkmdrCsgpaoaAvEAyJhbP5qEMwIYvZwetzEmfVh8rWEBVrE6Kew6ajNU
	CojA/PB9Yd9lf1bfafyQJwqh58+NgfKm3TFIf0OZEMaRTUfaAWCO8hdu3D24zOvs9nb4lhcie8m
	mvQqXui9jnhg8KS09FYgIlv+QabNa3wjDUPh4o15QS51gmqzhfcS
X-Received: by 2002:a05:6000:2a7:b0:38d:e190:b713 with SMTP id ffacd0b85a97d-38f33f4acbdmr9880417f8f.37.1739892136457;
        Tue, 18 Feb 2025 07:22:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMnTLi7/TR+3t7v4Awn2y8jepWE1m8Q0WLeR24iE4GrUJAg7Jv+YiQ6wp1cS+aqYQDUDQPzQ==
X-Received: by 2002:a05:6000:2a7:b0:38d:e190:b713 with SMTP id ffacd0b85a97d-38f33f4acbdmr9880373f8f.37.1739892136005;
        Tue, 18 Feb 2025 07:22:16 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258f5fb6sm15062981f8f.44.2025.02.18.07.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 07:22:15 -0800 (PST)
Message-ID: <6030fd76-e7f1-47ca-9eb7-8cafe48bd639@redhat.com>
Date: Tue, 18 Feb 2025 16:22:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 01/15] arm/cpu: Add sysreg definitions in cpu-sysregs.h
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-2-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250207110248.1580465-2-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xYu_BZQBKn_xD8crBCkfN6j5OqGsvKerFCXOgZ7CdVs_1739892137
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Connie,


On 2/7/25 12:02 PM, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> This new header contains macros that define aarch64 registers.
> In a subsequent patch, this will be replaced by a more exhaustive
> version that will be generated from linux arch/arm64/tools/sysreg
> file. Those macros are sufficient to migrate the storage of those
> ID regs from named fields in isar struct to an array cell.
>
> [CH: reworked to use different structures]
> [CH: moved accessors from the patches first using them to here,
>      dropped interaction with writable registers, which will happen
>      later]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-sysregs.h | 131 +++++++++++++++++++++++++++++++++++++++
>  target/arm/cpu.h         |  42 +++++++++++++
>  2 files changed, 173 insertions(+)
>  create mode 100644 target/arm/cpu-sysregs.h
>
> diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
> new file mode 100644
> index 000000000000..de09ebae91a5
> --- /dev/null
> +++ b/target/arm/cpu-sysregs.h
> @@ -0,0 +1,131 @@
> +#ifndef ARM_CPU_SYSREGS_H
> +#define ARM_CPU_SYSREGS_H
> +
> +/*
> + * Following is similar to the coprocessor regs encodings, but with an argument
> + * ordering that matches the ARM ARM. We also reuse the various CP_REG_ defines
> + * that actually are the same as the equivalent KVM_REG_ values.
> + */
> +#define ENCODE_ID_REG(op0, op1, crn, crm, op2)          \
> +    (((op0) << CP_REG_ARM64_SYSREG_OP0_SHIFT) |         \
> +     ((op1) << CP_REG_ARM64_SYSREG_OP1_SHIFT) |         \
> +     ((crn) << CP_REG_ARM64_SYSREG_CRN_SHIFT) |         \
> +     ((crm) << CP_REG_ARM64_SYSREG_CRM_SHIFT) |         \
> +     ((op2) << CP_REG_ARM64_SYSREG_OP2_SHIFT))
> +
> +typedef enum ARMIDRegisterIdx {
> +    ID_AA64PFR0_EL1_IDX,
> +    ID_AA64PFR1_EL1_IDX,
> +    ID_AA64SMFR0_EL1_IDX,
> +    ID_AA64DFR0_EL1_IDX,
> +    ID_AA64DFR1_EL1_IDX,
> +    ID_AA64ISAR0_EL1_IDX,
> +    ID_AA64ISAR1_EL1_IDX,
> +    ID_AA64ISAR2_EL1_IDX,
> +    ID_AA64MMFR0_EL1_IDX,
> +    ID_AA64MMFR1_EL1_IDX,
> +    ID_AA64MMFR2_EL1_IDX,
> +    ID_AA64MMFR3_EL1_IDX,
> +    ID_PFR0_EL1_IDX,
> +    ID_PFR1_EL1_IDX,
> +    ID_DFR0_EL1_IDX,
> +    ID_MMFR0_EL1_IDX,
> +    ID_MMFR1_EL1_IDX,
> +    ID_MMFR2_EL1_IDX,
> +    ID_MMFR3_EL1_IDX,
> +    ID_ISAR0_EL1_IDX,
> +    ID_ISAR1_EL1_IDX,
> +    ID_ISAR2_EL1_IDX,
> +    ID_ISAR3_EL1_IDX,
> +    ID_ISAR4_EL1_IDX,
> +    ID_ISAR5_EL1_IDX,
> +    ID_MMFR4_EL1_IDX,
> +    ID_ISAR6_EL1_IDX,
> +    MVFR0_EL1_IDX,
> +    MVFR1_EL1_IDX,
> +    MVFR2_EL1_IDX,
> +    ID_PFR2_EL1_IDX,
> +    ID_DFR1_EL1_IDX,
> +    ID_MMFR5_EL1_IDX,
> +    ID_AA64ZFR0_EL1_IDX,
> +    CTR_EL0_IDX,
> +    NUM_ID_IDX,
> +} ARMIDRegisterIdx;
> +
> +typedef enum ARMSysRegs {
> +    SYS_ID_AA64PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 0),
> +    SYS_ID_AA64PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 1),
> +    SYS_ID_AA64SMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 5),
> +    SYS_ID_AA64DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 0),
> +    SYS_ID_AA64DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 1),
> +    SYS_ID_AA64ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 0),
> +    SYS_ID_AA64ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 1),
> +    SYS_ID_AA64ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 2),
> +    SYS_ID_AA64MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 0),
> +    SYS_ID_AA64MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 1),
> +    SYS_ID_AA64MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 2),
> +    SYS_ID_AA64MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 3),
> +    SYS_ID_PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 0),
> +    SYS_ID_PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 1),
> +    SYS_ID_DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 2),
> +    SYS_ID_MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 4),
> +    SYS_ID_MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 5),
> +    SYS_ID_MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 6),
> +    SYS_ID_MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 7),
> +    SYS_ID_ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 0),
> +    SYS_ID_ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 1),
> +    SYS_ID_ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 2),
> +    SYS_ID_ISAR3_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 3),
> +    SYS_ID_ISAR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 4),
> +    SYS_ID_ISAR5_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 5),
> +    SYS_ID_MMFR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 6),
> +    SYS_ID_ISAR6_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 7),
> +    SYS_MVFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 0),
> +    SYS_MVFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 1),
> +    SYS_MVFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 2),
> +    SYS_ID_PFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 4),
> +    SYS_ID_DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 5),
> +    SYS_ID_MMFR5_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 6),
> +    SYS_ID_AA64ZFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 4),
> +    SYS_CTR_EL0 = ENCODE_ID_REG(3, 3, 0, 0, 1),
> +} ARMSysRegs;
> +
> +static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
> +    [ID_AA64PFR0_EL1_IDX] = SYS_ID_AA64PFR0_EL1,
> +    [ID_AA64PFR1_EL1_IDX] = SYS_ID_AA64PFR1_EL1,
> +    [ID_AA64SMFR0_EL1_IDX] = SYS_ID_AA64SMFR0_EL1,
> +    [ID_AA64DFR0_EL1_IDX] = SYS_ID_AA64DFR0_EL1,
> +    [ID_AA64DFR1_EL1_IDX] = SYS_ID_AA64DFR1_EL1,
> +    [ID_AA64ISAR0_EL1_IDX] = SYS_ID_AA64ISAR0_EL1,
> +    [ID_AA64ISAR1_EL1_IDX] = SYS_ID_AA64ISAR1_EL1,
> +    [ID_AA64ISAR2_EL1_IDX] = SYS_ID_AA64ISAR2_EL1,
> +    [ID_AA64MMFR0_EL1_IDX] = SYS_ID_AA64MMFR0_EL1,
> +    [ID_AA64MMFR1_EL1_IDX] = SYS_ID_AA64MMFR1_EL1,
> +    [ID_AA64MMFR2_EL1_IDX] = SYS_ID_AA64MMFR2_EL1,
> +    [ID_AA64MMFR3_EL1_IDX] = SYS_ID_AA64MMFR3_EL1,
> +    [ID_PFR0_EL1_IDX] = SYS_ID_PFR0_EL1,
> +    [ID_PFR1_EL1_IDX] = SYS_ID_PFR1_EL1,
> +    [ID_DFR0_EL1_IDX] = SYS_ID_DFR0_EL1,
> +    [ID_MMFR0_EL1_IDX] = SYS_ID_MMFR0_EL1,
> +    [ID_MMFR1_EL1_IDX] = SYS_ID_MMFR1_EL1,
> +    [ID_MMFR2_EL1_IDX] = SYS_ID_MMFR2_EL1,
> +    [ID_MMFR3_EL1_IDX] = SYS_ID_MMFR3_EL1,
> +    [ID_ISAR0_EL1_IDX] = SYS_ID_ISAR0_EL1,
> +    [ID_ISAR1_EL1_IDX] = SYS_ID_ISAR1_EL1,
> +    [ID_ISAR2_EL1_IDX] = SYS_ID_ISAR2_EL1,
> +    [ID_ISAR3_EL1_IDX] = SYS_ID_ISAR3_EL1,
> +    [ID_ISAR4_EL1_IDX] = SYS_ID_ISAR4_EL1,
> +    [ID_ISAR5_EL1_IDX] = SYS_ID_ISAR5_EL1,
> +    [ID_MMFR4_EL1_IDX] = SYS_ID_MMFR4_EL1,
> +    [ID_ISAR6_EL1_IDX] = SYS_ID_ISAR6_EL1,
> +    [MVFR0_EL1_IDX] = SYS_MVFR0_EL1,
> +    [MVFR1_EL1_IDX] = SYS_MVFR1_EL1,
> +    [MVFR2_EL1_IDX] = SYS_MVFR2_EL1,
> +    [ID_PFR2_EL1_IDX] = SYS_ID_PFR2_EL1,
> +    [ID_DFR1_EL1_IDX] = SYS_ID_DFR1_EL1,
> +    [ID_MMFR5_EL1_IDX] = SYS_ID_MMFR5_EL1,
> +    [ID_AA64ZFR0_EL1_IDX] = SYS_ID_AA64ZFR0_EL1,
> +    [CTR_EL0_IDX] = SYS_CTR_EL0,
> +};
> +
> +#endif /* ARM_CPU_SYSREGS_H */
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 2213c277348d..4bbce34e268d 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -30,6 +30,7 @@
>  #include "qapi/qapi-types-common.h"
>  #include "target/arm/multiprocessing.h"
>  #include "target/arm/gtimer.h"
> +#include "target/arm/cpu-sysregs.h"
>  
>  #ifdef TARGET_AARCH64
>  #define KVM_HAVE_MCE_INJECTION 1
> @@ -832,6 +833,46 @@ typedef struct {
>      uint32_t map, init, supported;
>  } ARMVQMap;
>  
> +static inline uint64_t _get_idreg(uint64_t *idregs, uint32_t index)
> +{
> +    return idregs[index];
> +}
> +
> +static inline void _set_idreg(uint64_t *idregs, uint32_t index, uint64_t value)
> +{
> +    idregs[index] = value;
> +}
> +
> +/* REG is ID_XXX */
nit: we have MVFRx too so maybe we shall rather say that REG is the

ARMIDRegisterIdx litteral without  _EL1_IDX suffix or just remove the comment

 
> +#define FIELD_DP64_IDREG(ARRAY, REG, FIELD, VALUE)              \
> +{                                                             \
> +    uint64_t regval = _get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX);   \
> +        regval = FIELD_DP64(regval, REG, FIELD, VALUE);                 \
> +    _set_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX, regval);             \
> +}
> +
> +#define FIELD_DP32_IDREG(ARRAY, REG, FIELD, VALUE)              \
> +{                                                             \
> +uint64_t regval = _get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX);       \
> +regval = FIELD_DP32(regval, REG, FIELD, VALUE);               \
> +_set_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX, regval);                 \
> +}
> +
> +#define FIELD_EX64_IDREG(ARRAY, REG, FIELD)                     \
> +FIELD_EX64(_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX), REG, FIELD)  \
> +
> +#define FIELD_EX32_IDREG(ARRAY, REG, FIELD)                     \
> +FIELD_EX32(_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX), REG, FIELD)  \
> +
> +#define FIELD_SEX64_IDREG(ARRAY, REG, FIELD)                     \
> +FIELD_SEX64(_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX), REG, FIELD)  \
> +
> +#define SET_IDREG(ARRAY, REG, VALUE)                            \
> +_set_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX, VALUE)
> +
> +#define GET_IDREG(ARRAY, REG)                                   \
> +_get_idreg((uint64_t *)ARRAY, REG ## _EL1_IDX)
> +
>  /**
>   * ARMCPU:
>   * @env: #CPUARMState
> @@ -1040,6 +1081,7 @@ struct ArchCPU {
>          uint64_t id_aa64zfr0;
>          uint64_t id_aa64smfr0;
>          uint64_t reset_pmcr_el0;
> +        uint64_t idregs[NUM_ID_IDX];
>      } isar;
>      uint64_t midr;
>      uint32_t revidr;

Thanks

Eric

