Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF40826E716
	for <kvmarm@lists.linux.dev>; Wed,  3 Sep 2025 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756898159; cv=none; b=K4G70byrUkpBFQN5FcvJW/ICKqwohvx4BO9Y+MssOmw5nRbdEuMIYCF9TawRXh701Q8r2q8A4DH/D2bjPW4ujsIJ0k+37Ol1JdUjOgam2QeN5ttU4feGdBM4IFz0ZmRcVBj1Jz6Kl8YEvCGUzMoxWg/F064eXmsCYNUypRR1PqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756898159; c=relaxed/simple;
	bh=O5Kl27XB553N7cmeBmXq/uiaTLYFFfTmRY6zD5Qm2IA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShccA6KdbQVXcw7oJnGz0TI+n0yfO2FmEuUAiljVFUdRk2oJrSegyjaYJokR0qZD1RLvEuxGLV7C+gZjnqxMFZyIm3yO9g8D4BHyGSw2xLMJcGQbH8dDzvZyizLZlId+c+Xqkfc3suqo7BnABdJekfoEMTTNj6a9wknvJ/rmBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwythlQV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwythlQV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756898156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVBqAzXRtaGdVaqdIdbidkD/s0lTNKoOEws6COnY9ko=;
	b=YwythlQVxvQcs54IB9cQyVHcXm5eyuNI4507+mzd5drvfaWRPaMOKTLmw+X/HK3nTHchSz
	jsEiPxepjB/9XaDgg9ujIe29NodO6NO22IJgrXKuwjyttwmtya6bNSv7pvrXnxVMl0WJVa
	krtQkNacD4ir+5TVN53RcOotRW8MV9M=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-S7lGklGDNUqoyZxlmr3I_g-1; Wed, 03 Sep 2025 07:15:55 -0400
X-MC-Unique: S7lGklGDNUqoyZxlmr3I_g-1
X-Mimecast-MFC-AGG-ID: S7lGklGDNUqoyZxlmr3I_g_1756898155
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7724877cd7cso3888127b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 03 Sep 2025 04:15:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756898154; x=1757502954;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVBqAzXRtaGdVaqdIdbidkD/s0lTNKoOEws6COnY9ko=;
        b=On9J7DwHozci92PC0/vQvbmsbpoAfyLHiQAvAMPs8bZl/jvc+AMTzsSIhcg1E2sb2Q
         qnDaDgNteXsmJ0qDGPw0I/FezSxZEpWFYcoWRXKYcCgHfs10eBI5l2pw94PFt+w21OaP
         G4Q/DrCR4hmDHgJTM4aY+UwkxwqHnKxrbeAdvCvXXquGUwOiCb5wvtwdqkWQX4TwfVwj
         Th1U7gK5rxKBT9MgjLLVljmGKEj3WT5l+lPa2x2OUPWDTOLeSfPu7i1hexRVDOFfFxZI
         wY4ZyKRPdpPl8ofkkvDndPzRb6Ec522ZWi4DdERfYF13KbQjUjJdfYPZnplrJKgNMhty
         OVNw==
X-Forwarded-Encrypted: i=1; AJvYcCUtgxIh8mUfIE3eu8y73yqUhTX7FMrLABvqjq3IaO4Tq5EXJyrCknq80rU20HjsQBxKD9qq+qI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTrZgTe3OvSldLqPK71drfGghDm72/3g1J3xsijybhJruABRsz
	I+GUHpuo4pUGu2USC9qh3l0YE+u+ISYFsAHH1YzOoXOLN3vdGDbBoWeiJMbwXHKI0611U8d0WHB
	6PwXoRixy4A4DCIPSWrSnHxWcGWFfN4YSjH5laejnDUwilXwJVkfvXHFx310MiZrkjQ==
X-Gm-Gg: ASbGncstVj5lcxeV6OaOO2wcBg2PPl0NF9BQSrUeeqbJDIDaQpQiq/Ezn52uJ3WnChO
	qK4tfJGsR9umoDNGZDFZdohL2rzZ3gXijDbyKRDHuhW72bEhsr6bwD5wLctpeQIquD1zx1xM+BA
	ksACEEu3muEkXEm0I+0n6y+bMq1vQoCEvE8Qmg8DkFX6ss9jQLyRw6z4zaZYXPhFa4mM3HBWRsA
	bHgi+zQe7KvblQyLL1kuVE2DjibfVLZWI3awt1MGrNlmrUp4v9MrY0XVYp3S4Z1z3D0Mdd/RBt1
	uF77U/K3pi5f61Gdp0NEy5ISr3Gh0I0oosChSL3lV2Ri4xrd2sPRiVR5vBKocF8RZUXlLZMi/yO
	b8whB
X-Received: by 2002:a05:6a00:2d13:b0:772:2fad:ff64 with SMTP id d2e1a72fcca58-7723e257daamr16145022b3a.8.1756898154155;
        Wed, 03 Sep 2025 04:15:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEehFXhizd/XBGs6lPLajyy1rp0g+vzzGOhiFu//IuUVahDT7Y1/d6xBov7/G/ROyWBDy0Hlg==
X-Received: by 2002:a05:6a00:2d13:b0:772:2fad:ff64 with SMTP id d2e1a72fcca58-7723e257daamr16144978b3a.8.1756898153626;
        Wed, 03 Sep 2025 04:15:53 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a269e9csm16651516b3a.17.2025.09.03.04.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:15:52 -0700 (PDT)
Message-ID: <0481109b-769f-464b-aa72-ad6e07bdfa78@redhat.com>
Date: Wed, 3 Sep 2025 21:15:43 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/43] arm64: RME: Check for RME support at KVM init
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-6-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-6-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jZecKbsInlj1I7EF2HA-vZRo05_VMkKtOaWT-bcmBaQ_1756898155
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 12:55 AM, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Later patches make use of struct realm and the states as the ioctls
> interfaces are added to support realm and REC creation and destruction.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v8:
>   * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
> Changes since v6:
>   * Improved message for an unsupported RMI ABI version.
> Changes since v5:
>   * Reword "unsupported" message from "host supports" to "we want" to
>     clarify that 'we' are the 'host'.
> Changes since v2:
>   * Drop return value from kvm_init_rme(), it was always 0.
>   * Rely on the RMM return value to identify whether the RSI ABI is
>     compatible.
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>   arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kvm/Makefile              |  2 +-
>   arch/arm64/kvm/arm.c                 |  5 +++
>   arch/arm64/kvm/rme.c                 | 56 ++++++++++++++++++++++++++++
>   7 files changed, 141 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>   create mode 100644 arch/arm64/kvm/rme.c
> 

[...]

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 888f7c7abf54..76177c56f1ef 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -40,6 +40,7 @@
>   #include <asm/kvm_nested.h>
>   #include <asm/kvm_pkvm.h>
>   #include <asm/kvm_ptrauth.h>
> +#include <asm/kvm_rme.h>
>   #include <asm/sections.h>
>   

Nit: The header file <asm/kvm_rme.h> has been included to <asm/kvm_host.h> and
<linux/kvm_host.h>, which has been included to arm.c. So this explicit inclusion
can be dropped.

>   #include <kvm/arm_hypercalls.h>
> @@ -59,6 +60,8 @@ enum kvm_wfx_trap_policy {
>   static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
>   static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
>   
> +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
> +
>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>   
>   DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
> @@ -2836,6 +2839,8 @@ static __init int kvm_arm_init(void)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	kvm_init_rme();
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> new file mode 100644
> index 000000000000..67cf2d94cb2d
> --- /dev/null
> +++ b/arch/arm64/kvm/rme.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/rmi_cmds.h>
> +#include <asm/virt.h>
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	unsigned short version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +
> +	if (res.a0 != RMI_SUCCESS) {
> +		unsigned short high_version_major, high_version_minor;
> +
> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> +
> +		kvm_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
> +			version_major, version_minor,
> +			high_version_major, high_version_minor,
> +			RMI_ABI_MAJOR_VERSION,
> +			RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +void kvm_init_rme(void)
> +{
> +	if (PAGE_SIZE != SZ_4K)
> +		/* Only 4k page size on the host is supported */
> +		return;

Nit: The comment can be moved before the check, something like below. Otherwise,
{} is needed here.

	/* Only 4kB page size is supported */
	if (PAGE_SIZE != SZ_4K)
		return;

> +
> +	if (rmi_check_version())
> +		/* Continue without realm support */
> +		return;

Nit: same as above.

> +
> +	/* Future patch will enable static branch kvm_rme_is_available */
> +}

Thanks,
Gavin

