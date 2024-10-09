Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8852AF1D
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 05:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728453239; cv=none; b=NKX9qWURnoisHULHDcvJ7N4YGyvK0sDgnhgMf+zMdT2r7++unluav1/xTyvjQcwrY9OP9XrZ2dLgMg+9h9a5bscaHoCPCygpj4r+vqNJk25IMgqyYzF1Kz3/yrz4kKjkz53hmDuK5KWbQ9RPiHYyox/gi+KXxOozy2HbpAxfQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728453239; c=relaxed/simple;
	bh=187ircL8dahSfKPzP90scmX2t9tAvwc2+dk0cJPPVJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LBoDHx89Xyqs3+INDztj3DZawVy4ZoKQ/ngqfP2ybZ5zpuciJhzj0YEd7Dnlrq2N7fCKgtUOV03JY67D00YdGIl3exsptEJ3feUVEKjTVWuDHJYCCzQXQvT7kDNd5hUra13RwEPbWAptuhCp6r8dwmqlXF0ZiDnqbyPKr7AkJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WurAu2mP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WurAu2mP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728453236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Slax4z+/KZOsvDd7Ygfjf1nxy1SxhrjMaSfPmKQQdOw=;
	b=WurAu2mP5Mru8IY3BgwXs90Q6eYwka7uozUpF4CG9NUTyodvtRhC8D/oiZA2cDP7sq6kJW
	+UtYxlZnrAfM5XGYFp3Y0VRQiP9vVHZgtQ4TjlhIkLoA8AZKf+69J1NBQv2IwmrTjY3qcK
	2sjrTTZQWyIzFEckMmtS69xLq5Ew2LI=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-poD2yehdPaGq1tkPnzJuYg-1; Wed, 09 Oct 2024 01:53:55 -0400
X-MC-Unique: poD2yehdPaGq1tkPnzJuYg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71e0217c5fdso4144208b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Oct 2024 22:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728453233; x=1729058033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Slax4z+/KZOsvDd7Ygfjf1nxy1SxhrjMaSfPmKQQdOw=;
        b=aECz4J/3JMKq7XKBZgvZYYkxGlnJy4wON3tkDkv5mp/gD0DaORGSsDUpNtrs36r7iP
         U8DQkV3G/QqFCYvYhfjkhYF3yVgYXzayONKTli21Vjq1vCQNZ1RMkUdYzhQ3O86NSWz3
         ii4HhdLGUGIMAC416+J2zCKfjJVgq8Wk4ZdW33aHCHdDPEYCUQx42IFBY7AtAqDqUPVl
         sOQ6oggTtesEWYNO25abyqqCeCxVGyLK/qsxQ5HVUlUMj4v6r01xcOKWRAYAkUX5Tce/
         mWF82X5XuDfpfpLUarRNZsiRX1WKnhFRu5iP/b3T7WQ4VF3AVwyEPyr9DL7xZA1LBUjT
         GvlA==
X-Forwarded-Encrypted: i=1; AJvYcCUU9ZxUcDbE88T1cpDQ1ig6Q4wxTJQ9nm1rSfdPI5JXu2F21E4rHDDbuju9Ge84Zw0DTHyrmx8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzwy11M+LjThdU6p9NB1eaFE0RU3FV+UyRATC94RPWeVnBxaInG
	XZEHJqR/sDLIkV4eJJCcvlnPASrHtpbJqOET5f0pQ9TZb9IzT9fJz3x0UXHSRnMVW2aSyCIw/GW
	1/TBIpCN9yuwbamNk8lqYkd95CXS1rdgrme9Yv6XC+HSDzrzKk60urcseIurfjA==
X-Received: by 2002:a05:6a00:1390:b0:71d:ea77:e94e with SMTP id d2e1a72fcca58-71e1db8ecffmr2049722b3a.16.1728453233556;
        Tue, 08 Oct 2024 22:53:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6K3jrTaX0JnvKghwg74VC2sXr7LYXI22yttoAzoB1pMvX6+MO+r20njF9pYkILpR81LkUww==
X-Received: by 2002:a05:6a00:1390:b0:71d:ea77:e94e with SMTP id d2e1a72fcca58-71e1db8ecffmr2049703b3a.16.1728453233135;
        Tue, 08 Oct 2024 22:53:53 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d4a278sm7266851b3a.140.2024.10.08.22.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 22:53:52 -0700 (PDT)
Message-ID: <c98586dc-da5f-44f2-9ed7-1acb6d9afe86@redhat.com>
Date: Wed, 9 Oct 2024 15:53:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] KVM: arm64: Fix missing traps of guest accesses to
 the MPAM registers
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-5-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004110714.2051604-5-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 9:07 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> but didn't add trap handling.
> 
> If you are unlucky, this results in an MPAM aware guest being delivered
> an undef during boot. The host prints:
> | kvm [97]: Unsupported guest sys_reg access at: ffff800080024c64 [00000005]
> | { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },
> 
> Which results in:
> | Internal error: Oops - Undefined instruction: 0000000002000000 [#1] PREEMPT SMP
> | Modules linked in:
> | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc7-00559-gd89c186d50b2 #14616
> | Hardware name: linux,dummy-virt (DT)
> | pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> | pc : test_has_mpam+0x18/0x30
> | lr : test_has_mpam+0x10/0x30
> | sp : ffff80008000bd90
> ...
> | Call trace:
> |  test_has_mpam+0x18/0x30
> |  update_cpu_capabilities+0x7c/0x11c
> |  setup_cpu_features+0x14/0xd8
> |  smp_cpus_done+0x24/0xb8
> |  smp_init+0x7c/0x8c
> |  kernel_init_freeable+0xf8/0x280
> |  kernel_init+0x24/0x1e0
> |  ret_from_fork+0x10/0x20
> | Code: 910003fd 97ffffde 72001c00 54000080 (d538a500)
> | ---[ end trace 0000000000000000 ]---
> | Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> | ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---
> 
> Add the support to enable the traps, and handle the three guest accessible
> registers by injecting an UNDEF. This stops KVM from spamming the host
> log, but doesn't yet hide the feature from the id registers.
> 
> With MPAM v1.0 we can trap the MPAMIDR_EL1 register only if
> ARM64_HAS_MPAM_HCR, with v1.1 an additional MPAM2_EL2.TIDR bit traps
> MPAMIDR_EL1 on platforms that don't have MPAMHCR_EL2. Enable one of
> these if either is supported. If neither is supported, the guest can
> discover that the CPU has MPAM support, and how many PARTID etc the
> host has ... but it can't influence anything, so its harmless.
> 
> Fixes: 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register")
> CC: Anshuman Khandual <anshuman.khandual@arm.com>
> Link: https://lore.kernel.org/linux-arm-kernel/20200925160102.118858-1-james.morse@arm.com/
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/include/asm/cpufeature.h     |  2 +-
>   arch/arm64/include/asm/kvm_arm.h        |  1 +
>   arch/arm64/include/asm/mpam.h           |  2 +-
>   arch/arm64/kernel/image-vars.h          |  5 ++++
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c               | 11 +++++++++
>   6 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 1abe55e62e63..985d966787b1 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -845,7 +845,7 @@ static inline bool system_supports_poe(void)
>   		alternative_has_cap_unlikely(ARM64_HAS_S1POE);
>   }
>   
> -static inline bool cpus_support_mpam(void)
> +static __always_inline bool cpus_support_mpam(void)
>   {
>   	return alternative_has_cap_unlikely(ARM64_MPAM);
>   }

The changes belong to PATCH[3/7] if I'm correct.

> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 109a85ee6910..16afb7a79b15 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -103,6 +103,7 @@
>   #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>   
>   #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
> +#define MPAMHCR_HOST_FLAGS	0
>   
>   /* TCR_EL2 Registers bits */
>   #define TCR_EL2_DS		(1UL << 32)
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index d3ef0b5cd456..3ffe0f34ffff 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -15,7 +15,7 @@
>   DECLARE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
>   
>   /* check whether all CPUs have MPAM virtualisation support */
> -static inline bool mpam_cpus_have_mpam_hcr(void)
> +static __always_inline bool mpam_cpus_have_mpam_hcr(void)
>   {
>   	if (IS_ENABLED(CONFIG_ARM64_MPAM))
>   		return static_branch_unlikely(&arm64_mpam_has_hcr);

Save as above, the changes belong to PATCH[3/7].

Thanks,
Gavin

