Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7131EF094
	for <kvmarm@lists.linux.dev>; Sun,  2 Mar 2025 23:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740959554; cv=none; b=FKlcYc7L9l8U0Wm4KwPO+/oLManQLgd0fyX5gHGDrQ6EI26wwdT9N4zz9rZ/e+mO7PhXU+itGxIbaB7BDZMeGnaogUMdOWDHjJV+tgDsf3kAgJY53C6Qu+/j3iVJQIpx0tWjZB0IZyBX0SV3IivHNqpboCyf+zsKIPq4Du5Nj0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740959554; c=relaxed/simple;
	bh=ZCHiDYAhlovsWxCqC+x+dRnRzJjE1HzBfBSQe8cnIkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oj/5BzOhffCp3PAgzjFNrAjpFGqnevXlLaltRxmThVLnXSQcFWGG5M2y0DnxqsdEHgU0Qf9mm5Zcelu+SauwdEU9QJc4sU3Tt7Nd0fB9TsSnckgUdl/a2a8/hP55oC5BiBjBYHuzWKS0ClQbVNhOPsRgACjOY34LIx5QU08LfKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Doz5BwjL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Doz5BwjL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740959551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYg5YEi6qBDiPq4yW7kt5bdYtpCwTDMo82ocwV6poUo=;
	b=Doz5BwjLsIwfzUhtqcTusDh4gUdrgsnnkGYAqURwTKf6RJ+VMbtdaA8xF729/GDa2APeEF
	jJRLoDCZFUhKtvKIdKRkLRsyYSz+faudXU0eVPZs+WDB8lvaJdTvH+ShfoWPKza/uKbRJ1
	U2qafmIdtg/p5NtYRXVcYZItmQcXSTI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-fRd3_ubEN2mkN8-D9Z-iRA-1; Sun, 02 Mar 2025 18:52:15 -0500
X-MC-Unique: fRd3_ubEN2mkN8-D9Z-iRA-1
X-Mimecast-MFC-AGG-ID: fRd3_ubEN2mkN8-D9Z-iRA_1740959534
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2feb4648d4dso10756373a91.1
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 15:52:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740959534; x=1741564334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYg5YEi6qBDiPq4yW7kt5bdYtpCwTDMo82ocwV6poUo=;
        b=fb9fqE9gIt7pKEQEipJCDv+rvi4DYJib//ew5xkya+AMRglbGQKymafwWmdr0kBtOs
         xKznu3wA+7yMEqjJpqKpvtia2NhSXioP7vm1Eh8bYncrEjkTvJVrJV6EiA9U8aijgTJg
         DuXmaggqRDNEtVpHQUQmRkLEP5BMGiIX4RDLuU2ZhcirPEKBtv9vuQvIBEffZvXxzyrZ
         uTeD4j0+Ps63NWMU99Qz1MhJCyfFJCn26dVZs2RHJl/9t4+VfSIiZVlheTqaesJp36uR
         W6HGsneMqSVlYWCq+IJULNq+7DvU4b+aVS7+a+fLlwfLqeCn2UNjpfo0bsA1qDFN+o6K
         j2KA==
X-Forwarded-Encrypted: i=1; AJvYcCWwbW0DJYcHc0A80C/IwRspCamvxyuo2GqJBNG6YqJymPCJRrOaOMYwxUSy0i3B4CsQkxvGUvU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqPM71sTFJ5yaQl2ClNGbmzB7q+irN9xk0vQ3xi4v7ZWZ61arE
	WdW9++u4266HWuy0bKezMB78ChrdUxAjoChaFuWXK9H62LDRIDoyOd5NS8GgwqimemNnXzBMz/i
	G2uEb+HxdAYFgZG4LXEAZMUA25/YDAmqyjv12r7dR+2D3e/F/Due4GQ==
X-Gm-Gg: ASbGncsdVe+b5oM6aVs3x64Wo1smCRttrAUoR/JdjNSzmaXoghCoGbBcATY7M+da/9S
	YRNeKzxOmFgyHSS0rtjtsOS+O2Y0a1RolPc0S8lW4aShX5lWeL3Rpn3bS0WXWa2AlH1wadQ2c+O
	tZ6lItNgy5u5nTxBXouPEuU9IZzPiKHhtd5ot3LK9hhFuQ0YaJKYLf+kykZT7HfLwC12SzqZ9Tt
	Ry65naEUYycWL3o4dS9k3/7YDD0BcyMqmEF+rIs0Yv3TEWiiCbagZPVAe2R3o/+gmNnn6WwpuJw
	TsoFTqEAwIad14aXDg==
X-Received: by 2002:aa7:8589:0:b0:736:2f20:9d1 with SMTP id d2e1a72fcca58-7362f200c33mr9917261b3a.23.1740959534556;
        Sun, 02 Mar 2025 15:52:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKlHkk3X/xMjFSbabboBMi1iDhPso9R9B1xGAoC3vDIC/hJIAYOgl7Zpu+TUw2ZN+RUI7UGA==
X-Received: by 2002:aa7:8589:0:b0:736:2f20:9d1 with SMTP id d2e1a72fcca58-7362f200c33mr9917245b3a.23.1740959534256;
        Sun, 02 Mar 2025 15:52:14 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a003ec7esm7554622b3a.153.2025.03.02.15.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:52:13 -0800 (PST)
Message-ID: <7c217ce9-588e-4e4a-b395-2cd5d014487e@redhat.com>
Date: Mon, 3 Mar 2025 09:52:05 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/45] arm64: RME: Add SMC definitions for calling the
 RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-5-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-5-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yzpUZGpQxpz7xnUZV1WdPN-5D8JAShpUxITWSZf-uXM_1740959534
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>     these are flag values.
> Changes since v5:
>   * Sorted the SMC #defines by value.
>   * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>     RMI calls.
>   * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>     number of available list registers could be lower.
>   * Provided a define for the reserved fields of FeatureRegister0.
>   * Fix inconsistent names for padding fields.
> Changes since v4:
>   * Update to point to final released RMM spec.
>   * Minor rearrangements.
> Changes since v3:
>   * Update to match RMM spec v1.0-rel0-rc1.
> Changes since v2:
>   * Fix specification link.
>   * Rename rec_entry->rec_enter to match spec.
>   * Fix size of pmu_ovf_status to match spec.
> ---
>   arch/arm64/include/asm/rmi_smc.h | 259 +++++++++++++++++++++++++++++++
>   1 file changed, 259 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 

One nitpick below, with it addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> new file mode 100644
> index 000000000000..f85a82072337
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_smc.h
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2024 ARM Ltd.
> + *
> + * The values and structures in this file are from the Realm Management Monitor
> + * specification (DEN0137) version 1.0-rel0:
> + * https://developer.arm.com/documentation/den0137/1-0rel0/
> + */
> +
> +#ifndef __ASM_RME_SMC_H
> +#define __ASM_RME_SMC_H
> +

#ifndef __ASM_RMI_SMC_H
#define __ASM_RMI_SMC_H


[...]

> +
> +struct rec_run {
> +	struct rec_enter enter;
> +	struct rec_exit exit;
> +};
> +
> +#endif

#endif /* __ASM_RMI_SMC_H */

