Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81992F9FE
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 09:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689328657;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCu33ziM562YgoYaGWLee8XNj2HHD6OoiAz2SuMASII=;
	b=DhTcKhzxvjLZ3jmvOA3SU1N7nV3/mvs8/myirNOAawY3rUYTprGsHc5dxNOjCY7eDl7Dhn
	YrBPcyBnaKAX7RcyA2IkZEXTdQ6ZQct80/yOAA6qj/Z4ywk+KwBR3OcSPtZIApOStSX3W6
	IJChy5mnsVRT80+HuXk8PtwpMApGqdw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-neIxy83_PvOcw-Z2ZzroWQ-1; Fri, 14 Jul 2023 05:57:36 -0400
X-MC-Unique: neIxy83_PvOcw-Z2ZzroWQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-635e91e5537so17350226d6.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 02:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689328655; x=1689933455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gCu33ziM562YgoYaGWLee8XNj2HHD6OoiAz2SuMASII=;
        b=iCuu0cpAZpx6dpS7bZuQwwWYghp2Bff6d+t7GE9g6YG7bYDtwCfhBEaQfPCoKEPBJX
         FPNDobH7sA8YgaHKDSs1bEqHiqMMb2ZSH6X4inR1VY7TUf5yidlRpcCHF5cES8z/N2Ol
         AkXgMQehIUtkaMqPhjJ24L0JltHFTTLxVqi4AWM8Y/yETW6Pyiv4135Uc9GEhainiPUH
         nxeraEqOkUl/r4dgAuZxW5pq+D3HB0Erp1l2o62ycwAb2MTq4CgOldkEpANQS/acsCTZ
         QusRXrBk1FMRCk5y2Rd1Ai5ZgTEdAnL8IieepBw5NZj98Xy1Vz4TA6KV2gCmTyjBU9Vr
         4wGQ==
X-Gm-Message-State: ABy/qLbPJeaAD2FT0ACowPKSVAYrpAe+5DTe/NwxCQpz4J3heNp4JlpQ
	8fXO0Qrqn8UL0CVPLn/UrLX6ApYY6HLR33EH/iWceTE+I61hhkOsOg+aE+1/hEpUYdNAEZn9F6m
	s4JzBW9W3KfsWjpRM
X-Received: by 2002:ad4:504e:0:b0:628:35b0:e966 with SMTP id m14-20020ad4504e000000b0062835b0e966mr3805633qvq.21.1689328655670;
        Fri, 14 Jul 2023 02:57:35 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFzMd8R1o7Y2YsrxyRprJ8q0Sa8uedD+jvkqyOU9OZseNveBJ7ue4hLIFSqRa2Cbz6Htb/SZg==
X-Received: by 2002:ad4:504e:0:b0:628:35b0:e966 with SMTP id m14-20020ad4504e000000b0062835b0e966mr3805623qvq.21.1689328655382;
        Fri, 14 Jul 2023 02:57:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m10-20020ae9e70a000000b007654bb4a842sm3669537qka.104.2023.07.14.02.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 02:57:34 -0700 (PDT)
Message-ID: <fc99e975-4625-6d1c-f6d0-08ad5af4233a@redhat.com>
Date: Fri, 14 Jul 2023 11:57:30 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 10/27] arm64: Add feature detection for fine grained traps
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-11-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-11-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/12/23 16:57, Marc Zyngier wrote:
> From: Mark Brown <broonie@kernel.org>
>
> In order to allow us to have shared code for managing fine grained traps
> for KVM guests add it as a detected feature rather than relying on it
> being a dependency of other features.
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20230301-kvm-arm64-fgt-v4-1-1bf8d235ac1f@kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kernel/cpufeature.c | 11 +++++++++++
>  arch/arm64/tools/cpucaps       |  1 +
>  2 files changed, 12 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index f9d456fe132d..0768f98c49cc 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2627,6 +2627,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
>  	},
> +	{
> +		.desc = "Fine Grained Traps",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_HAS_FGT,
> +		.sys_reg = SYS_ID_AA64MMFR0_EL1,
> +		.sign = FTR_UNSIGNED,
> +		.field_pos = ID_AA64MMFR0_EL1_FGT_SHIFT,
> +		.field_width = 4,
> +		.min_field_value = 1,
> +		.matches = has_cpuid_feature,
> +	},
>  #ifdef CONFIG_ARM64_SME
>  	{
>  		.desc = "Scalable Matrix Extension",
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index c80ed4f3cbce..c3f06fdef609 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -26,6 +26,7 @@ HAS_ECV
>  HAS_ECV_CNTPOFF
>  HAS_EPAN
>  HAS_EVT
> +HAS_FGT
>  HAS_GENERIC_AUTH
>  HAS_GENERIC_AUTH_ARCH_QARMA3
>  HAS_GENERIC_AUTH_ARCH_QARMA5

