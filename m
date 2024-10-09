Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCB01C68F
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 03:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728446365; cv=none; b=EmeZfOAEKJjLCOZm2K/bqp1crLCaQPX1alNRmPbMvelMRJhWEKpdIJndGV684URFL2ISSqgKHeJJmy47gvOxCAU3rsFoz1T+p05QsbTwvKJ4UpDGR2pcqrqyT7ENvVrif6mwp6keKzeBpt/TTCQtsRniHMmGfH0TvjlekZs/3QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728446365; c=relaxed/simple;
	bh=bffiJ29RRTw1gznKIWIUPxvqEhykXZbk7YMVWrIO8+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hCjGHPQDQ9MsaDymqbv1xgDcUd6p15+kWEPQei+KlRsBFXGssWMXWQw1HR9VLh1/nlfDTJPpYizGPYMvSAGvAB0zj8ofqqgPEHvuFNre9Wp2GzYybRRmiWY82BgdJedyEpvQM5VkemWPFm2YoSBN+NOwE7VsPXwvl+TKTigdKgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWouHIKa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWouHIKa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728446362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cYfnpdnpDhaDHET1qTxR+asRwAv8qKJ2BIt8nlF0EeE=;
	b=ZWouHIKaW1+PbZZVFBEkMthymsz++0gY9LjSwqcg7eWTL2/aFi5Ri8sfSzRvsxe0bv6j9d
	SrOM+yWy6yYQ05+lfePc3qWPT/6TzHqtoJCcSbIIHcHJ0ivanlbYc5fGN9wOaW0QgJ+mCb
	xPzEDcqAvQZ0u1Q7NHzvX3s3gT4DmCc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-QVrfL9FfNhmaf8WNHTscNg-1; Tue, 08 Oct 2024 23:59:19 -0400
X-MC-Unique: QVrfL9FfNhmaf8WNHTscNg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e295559c37so753478a91.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Oct 2024 20:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728446358; x=1729051158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cYfnpdnpDhaDHET1qTxR+asRwAv8qKJ2BIt8nlF0EeE=;
        b=kZn69ls+0dn9ufgtLIZTqN+4+qlQni+X6EVu9gKRHx6GPha/rYIyc4t+YWiQNopw6E
         Q5NYhHahFVWE3AgVpxrfsj5kU4HTJfNSoFOHm9aBjB12CRHmsRWjOLbusrTliLEvQS8f
         PT0aM3L5LX9VHKt9yK4pYJ/flNQukAJ6HtfUJW20uA9YYMWRtp6EqBvga2yuZaCIVY38
         WbWjbk/gmAGP5ZcvQGG0EA2YVKVnPZXD9SvPWOvGees9wtKRe+0L8+u4PWdMIS8Iqnre
         TN0vYYqTvZBYyuKr9e7YyYky4s1sTIMeyRE77NqpzS56X8I2l2yMMyjdgsoOKojbqGuB
         oXyA==
X-Forwarded-Encrypted: i=1; AJvYcCVU75rfHgB5GUrwcHTOzvPLgWeMp1WjcGoYMS9sjInQlSfLvt7d0VPLNCn0cyvHKIDPSBbXgK0=@lists.linux.dev
X-Gm-Message-State: AOJu0YybIF5UfVTqSRMa6+Nu6LaFA+7iCAj/NFSiHqnlM+gBwBrjqtl7
	NEUqk+EO3nL8GwJt8poh9t7kFLKZIACU/1JYrpGR1fmTBuLX0t7CuShmDEgQCnE9lzMpQLPEkjh
	YxDBxcvlUqN0CoAwA+MWfc6g1CoA82eMFZBHfJB27lG2s6V1LPTx6Xg==
X-Received: by 2002:a17:90a:8a07:b0:2e2:9522:279d with SMTP id 98e67ed59e1d1-2e2a252b9fdmr1471910a91.29.1728446358383;
        Tue, 08 Oct 2024 20:59:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsLgq/HbP8ucQ7tgjj9gWBtjpqYvm316NEWB/etdpJV2F7U5XV60Py/mdsUV6RFU7RLTqTmQ==
X-Received: by 2002:a17:90a:8a07:b0:2e2:9522:279d with SMTP id 98e67ed59e1d1-2e2a252b9fdmr1471888a91.29.1728446358004;
        Tue, 08 Oct 2024 20:59:18 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2a55fc7dbsm451760a91.4.2024.10.08.20.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 20:59:17 -0700 (PDT)
Message-ID: <a779a4e3-5ba4-43c9-9c2f-f1e953098e3e@redhat.com>
Date: Wed, 9 Oct 2024 13:59:11 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] arm64: head.S: Initialise MPAM EL2 registers and
 disable traps
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-2-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004110714.2051604-2-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 9:07 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> Add code to head.S's el2_setup to detect MPAM and disable any EL2 traps.
> This register resets to an unknown value, setting it to the default
> parititons/pmg before we enable the MMU is the best thing to do.
> 
> Kexec/kdump will depend on this if the previous kernel left the CPU
> configured with a restrictive configuration.
> 
> If linux is booted at the highest implemented exception level el2_setup
> will clear the enable bit, disabling MPAM.
> 
> This code can't be enabled until a subsequent patch adds the Kconfig
> and cpufeature boiler plate.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/include/asm/el2_setup.h | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index e0ffdf13a18b..2a84a3d05834 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -220,6 +220,21 @@
>   	msr	spsr_el2, x0
>   .endm
>   
> +.macro __init_el2_mpam
> +#ifdef CONFIG_ARM64_MPAM
> +	/* Memory Partitioning And Monitoring: disable EL2 traps */
> +	mrs	x1, id_aa64pfr0_el1
> +	ubfx	x0, x1, #ID_AA64PFR0_EL1_MPAM_SHIFT, #4
> +	cbz	x0, .Lskip_mpam_\@		// skip if no MPAM
> +	msr_s	SYS_MPAM2_EL2, xzr		// use the default partition
> +						// and disable lower traps
> +	mrs_s	x0, SYS_MPAMIDR_EL1
> +	tbz	x0, #17, .Lskip_mpam_\@		// skip if no MPAMHCR reg
> +	msr_s	SYS_MPAMHCR_EL2, xzr		// clear TRAP_MPAMIDR_EL1 -> EL2
> +.Lskip_mpam_\@:
> +#endif /* CONFIG_ARM64_MPAM */
> +.endm
> +

Bit#17 has been defined as SYS_MPAMIDR_EL1_HAS_HCR_SHIFT in PATCH[v4 2/7]. The
definition can be used if PATCH#1 and PATCH#2 are swapped.

     tbz    x0, #SYS_MPAMIDR_EL1_HAS_HCR_SHIFT, .Lskip_mpam_\@	// skip if no MPAMHCR

>   /**
>    * Initialize EL2 registers to sane values. This should be called early on all
>    * cores that were booted in EL2. Note that everything gets initialised as
> @@ -237,6 +252,7 @@
>   	__init_el2_stage2
>   	__init_el2_gicv3
>   	__init_el2_hstr
> +	__init_el2_mpam
>   	__init_el2_nvhe_idregs
>   	__init_el2_cptr
>   	__init_el2_fgt

Thanks,
Gavin

