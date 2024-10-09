Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A166D2AF1D
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 05:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728453031; cv=none; b=CbphUz3CgGk3MVYCuoU7Ivfr9aWuuqN2wo+xGcqJ6oyAwFUtsD6Tmgm3IR9Iy+lFeQrNh5X3PNH5QJQK2oQu+RbhxI35EcX2lIgKIaqnfA2sefkkROmPrROrOazOkYbxDrJEFtu2xTjvh52MDXh+PZULn61XDmyfoTN4KMbsCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728453031; c=relaxed/simple;
	bh=9S2jPLYFK+rDY5ycsoEGWF98XMRbhd/RhKW5ulm2iuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=og2nAXDqqNcq4prahJfbvi7BwbBzYypZHKAvoueHIZgqZGkcrW2ptC3TEZ3MqyKGb3kk+UO0LnAGuibskc6Gz6S98Z6Frg7x4BbFSrNZbeUC0lj4mP+S54QIDoAzDVgVgB56fzvV672q2JPasAdfvd9BsiFpfQYB4BThG6Emlrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICtLS+5B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICtLS+5B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728453028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ymX19yxGKNcPPZT9dbIlT7LvMSHhqQQCw6kliOcG++o=;
	b=ICtLS+5BMZXLdpHKyVoiBNox0vKUi95JgZQ5huVLpyW/VNpXutkzvf/MkEg485Hozd2F7h
	omdWLBV0UyEIchZnTbHKOkir1o7EPA39cVSS7KUqhs1MNixMcp1bvolbeVKQQsu3J+8//o
	xL69lYCGIIupxRibY31nBgk6jG8zMU8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-l4Gk2NeEM7ybQpoPzm8BDg-1; Wed, 09 Oct 2024 01:50:25 -0400
X-MC-Unique: l4Gk2NeEM7ybQpoPzm8BDg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e10dec7d0fso5795307a91.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Oct 2024 22:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728453024; x=1729057824;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ymX19yxGKNcPPZT9dbIlT7LvMSHhqQQCw6kliOcG++o=;
        b=RFYqHkDdY1NUcY8UbTCfqXexMPSNW2ZAQJfTccn/0MDRIpyxb+4mVh3/71OT3jzLBA
         t+7gJx/+Nwd7aFFx+MvQYWdOLX51dbo+4XBPQohLhTlvnt2X1Jj+m4jia2vsgLEYyDNz
         3fQFNJ8FlVe37HNPwtQIXKsrnPjJLDE2A1sgvRqhMrDQCMvLVp8xTbtS4rzQYRjTFopV
         HOgDxwfPzofGsRanYqEMbhJFCO9qJ3e/sOozwgHMwsmx4uA2ZmmhavD+AJ8+OSylJMjS
         vcUk6ETJJZZ6ofLXbO78slceZfMjYbyTeyZFnkxyTwDXRbbvZg/agaNrZYVQF/rm+mu2
         4Ouw==
X-Forwarded-Encrypted: i=1; AJvYcCUXW/74HOr/PO0Pa0/ww1GnIPSFN2igUqn5DXVXkgmYhau5r2jK6QouSphAQsGaZCmHYrlGea4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYF0zZLUtMoM54IyjPK5VTfif3hu90gmqh+lyRwMhVyt943kso
	qgv1EiYsq5dVVd4+C2GtbLmXJDEAfqWslFL5B22GpUGhilWV2dHYL+6SHbeyMjldPSuMaxEP599
	AwuecFRkQYQ0aZqj2bKIv90MEiVXh90zJ15nxHdse4kG0j6IBlzsf9A==
X-Received: by 2002:a17:90a:f0c6:b0:2e0:7e80:2013 with SMTP id 98e67ed59e1d1-2e2a2578abemr1740883a91.38.1728453024126;
        Tue, 08 Oct 2024 22:50:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHPLj8B4geOM4Lg3iZurhkPCvU+Nn9za7W4Emb4G50Z5/U3Z1RUlAVfpPuJ4P+IyR9FEZ/ig==
X-Received: by 2002:a17:90a:f0c6:b0:2e0:7e80:2013 with SMTP id 98e67ed59e1d1-2e2a2578abemr1740858a91.38.1728453023800;
        Tue, 08 Oct 2024 22:50:23 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2a5aabbb1sm661909a91.35.2024.10.08.22.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 22:50:23 -0700 (PDT)
Message-ID: <b82215a0-f4e0-4073-86f6-09526f5dfc8f@redhat.com>
Date: Wed, 9 Oct 2024 15:50:16 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] arm64: cpufeature: discover CPU support for MPAM
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-4-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004110714.2051604-4-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 9:07 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> ARMv8.4 adds support for 'Memory Partitioning And Monitoring' (MPAM)
> which describes an interface to cache and bandwidth controls wherever
> they appear in the system.
> 
> Add support to detect MPAM. Like SVE, MPAM has an extra id register that
> describes some more properties, including the virtualisation support,
> which is optional. Detect this separately so we can detect
> mismatched/insane systems, but still use MPAM on the host even if the
> virtualisation support is missing.
> 
> MPAM needs enabling at the highest implemented exception level, otherwise
> the register accesses trap. The 'enabled' flag is accessible to lower
> exception levels, but its in a register that traps when MPAM isn't enabled.
> The cpufeature 'matches' hook is extended to test this on one of the
> CPUs, so that firmware can emulate MPAM as disabled if it is reserved
> for use by secure world.
> 
> Secondary CPUs that appear late could trip cpufeature's 'lower safe'
> behaviour after the MPAM properties have been advertised to user-space.
> Add a verify call to ensure late secondaries match the existing CPUs.
> 
> (If you have a boot failure that bisects here its likely your CPUs
> advertise MPAM in the id registers, but firmware failed to either enable
> or MPAM, or emulate the trap as if it were disabled)
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
> Changes since v3:
>   * A proper conversion to sysreg
> ---
>   .../arch/arm64/cpu-feature-registers.rst      |  2 +
>   arch/arm64/Kconfig                            | 20 ++++
>   arch/arm64/include/asm/cpu.h                  |  1 +
>   arch/arm64/include/asm/cpucaps.h              |  2 +
>   arch/arm64/include/asm/cpufeature.h           | 12 +++
>   arch/arm64/include/asm/mpam.h                 | 32 ++++++
>   arch/arm64/kernel/Makefile                    |  2 +
>   arch/arm64/kernel/cpufeature.c                | 97 +++++++++++++++++++
>   arch/arm64/kernel/cpuinfo.c                   |  4 +
>   arch/arm64/kernel/mpam.c                      |  8 ++
>   arch/arm64/tools/cpucaps                      |  1 +
>   11 files changed, 181 insertions(+)
>   create mode 100644 arch/arm64/include/asm/mpam.h
>   create mode 100644 arch/arm64/kernel/mpam.c
> 

[...]

> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
> new file mode 100644
> index 000000000000..a29dc58c2da5
> --- /dev/null
> +++ b/arch/arm64/kernel/mpam.c
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021 Arm Ltd. */
> +
> +#include <asm/mpam.h>
> +
> +#include <linux/jump_label.h>
> +
> +DEFINE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);

linux/jump_label.h has been included to asm/mpam.h. So we needn't include
it again.

Thanks,
Gavin

