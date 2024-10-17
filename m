Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05478101F2
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 02:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132601; cv=none; b=MtP8NUC8t7gHB7PxvSeUXwzMM+sd2yVwfl4R+gU/czUtQa/XUk18hUxbujfU65BiAGy2L4MCw72T3PC2/3MqTAC1X61jg9NAIJV3bv3qQ8JNUGQmkrI31V1ZGS+0+6i0hEWAPiSGpSnpF+7DgaXzcY4pcszccMVdhgzOYuC5aME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132601; c=relaxed/simple;
	bh=9ZXrXeqMwvZL5DdagWZkZG4WvZsDR0XyAZxofYV7NS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p6Ao0pMS/zVL30CzEE7N15+UiwPQ70bh1KDtL0xUZ310pJLYtg9bfYDKGhwmzwaXsEfw18h1hIvIstYGiN+CkLvcjhKtvTKZTwkCnpu1mZxQC+4R+oL8s4fASJg+9LZ6i6fA1aD26InYLqfeT0xdLy4GtZUYg4/OqPaUIcpQUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hSVQVeNP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSVQVeNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729132596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wEBlr2uGalE2BxWMEhI3053v9X7bzgdwMmj1cpGN1JQ=;
	b=hSVQVeNPRPQcwt2THSxhsGO0VYGoM61ws/3UNeYZwJQnNTtVqiCZTYHj2Xmuvub8xKIGe5
	8ILDN1Ly9UKhJiG2hLBwu7ZFY+3At9hxbR0kjZRQ48KHcIZwWkS+/XlPw9dxQEi5MNZajl
	5uLSwf3BJVXn7n5JZgo519zrlJNFEvI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-evtNWTiVPP2LI3ZVhiTrfw-1; Wed, 16 Oct 2024 22:36:35 -0400
X-MC-Unique: evtNWTiVPP2LI3ZVhiTrfw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e295559c37so405936a91.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 19:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729132594; x=1729737394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEBlr2uGalE2BxWMEhI3053v9X7bzgdwMmj1cpGN1JQ=;
        b=RIbB+Zi2PeZH1+1O9BFE5sutW0v0l2fbo6al0zaWr/egELFVtVytVaV2gOnf3OLCRS
         NzJsrWvOlQCj9NB+MgaJf5NA/CvDnnNaXnsrzatTBLi6h3bhZ7F//rdOJFfs3UISqVRQ
         1oxKYvQaUTIWZJnl2QP0MPfI1SeoXC71z5y1SGAp/QS59hpeosmkiA/P24WSIq3wpAu3
         x0TJNk0Le83B7DBgVZF4+tGVuAbSkLK8uCAJMqj5xNkKHarpSKFuNOYa+ZqeLWCAaZXH
         kJi184hoHRBz6FDV6cqlGyc3muTHTEMfgCFqNm68DCKtHy2qdjDBNdLtP+MruVw999fm
         k7aw==
X-Forwarded-Encrypted: i=1; AJvYcCUDSB9im5rk02u8sem72S7HnHa4cxHRyNacovnZbDVKizaX0tajtJ46A5AwHRY7K/ESAKUMMUQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzG8+egKFGkMKPwTRTUrjaHBi8hOoW3V5gBv24b6sep5Nsi2xf4
	MORfMdzrxMvdKEVsXI6K6Z6xbBJuMyMxEyUDzx73MDQadI0yHmN9/LdL+7vNHv2Nbhb41LPoSjU
	3BUvLcT4rEeTgVFj1Z1uoxTvTzvq8aRsZulSPq0GoKio9Xmg+HI8OCw==
X-Received: by 2002:a17:903:40c6:b0:20b:5351:f69a with SMTP id d9443c01a7336-20d27f3fae7mr85434785ad.58.1729132594633;
        Wed, 16 Oct 2024 19:36:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbve1cFT+3/T9aIoiBUg75NmznGBWFLY7XVK/82tI9cQx42+1B5lOQ/CKFQ5WmsEJ1LXDSpQ==
X-Received: by 2002:a17:903:40c6:b0:20b:5351:f69a with SMTP id d9443c01a7336-20d27f3fae7mr85434555ad.58.1729132594305;
        Wed, 16 Oct 2024 19:36:34 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1805b0afsm35119205ad.246.2024.10.16.19.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 19:36:33 -0700 (PDT)
Message-ID: <f0de708f-674d-48ad-a3e8-9d3a06a72081@redhat.com>
Date: Thu, 17 Oct 2024 12:36:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] arm64: cpufeature: discover CPU support for MPAM
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-4-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-4-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
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
>   .../arch/arm64/cpu-feature-registers.rst      |  2 +
>   arch/arm64/Kconfig                            | 20 ++++
>   arch/arm64/include/asm/cpu.h                  |  1 +
>   arch/arm64/include/asm/cpucaps.h              |  2 +
>   arch/arm64/include/asm/cpufeature.h           | 12 +++
>   arch/arm64/include/asm/mpam.h                 | 32 ++++++
>   arch/arm64/kernel/Makefile                    |  2 +
>   arch/arm64/kernel/cpufeature.c                | 97 +++++++++++++++++++
>   arch/arm64/kernel/cpuinfo.c                   |  4 +
>   arch/arm64/kernel/mpam.c                      |  6 ++
>   arch/arm64/tools/cpucaps                      |  1 +
>   11 files changed, 179 insertions(+)
>   create mode 100644 arch/arm64/include/asm/mpam.h
>   create mode 100644 arch/arm64/kernel/mpam.c
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

