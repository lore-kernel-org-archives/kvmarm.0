Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2B931771F
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771254839; cv=none; b=jLW/KDnHQaUUtwoX67Qov1TcfDLn+Wsr+BO+E2vpn7uEWdYunjsqtygM/Srvdqf8YA/GeQqAByTIovkZr5qCaQ2lDfP0de1r9maLt8QeKgeNy5wQTj3pOfJewYyRFRMUaeNZsY55uaYlTYla9TuLnH7K3brFYzwNIvOSVyEdxTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771254839; c=relaxed/simple;
	bh=388O0o5Z6u4O7twcCa6exHZvhKir0X60s7jJoOiXwQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbR2XNto6yKeu0i84iwdMro6vkcO1hQwISa+jUu3ElJivCLrpWJfAxXf3evNyMfQNZUeM05k8WkS5yeceXzjJxWMrgUcelhSb4NYxaH0N7KKGNVrBdDxmwqmCYWSA6x/qS4bVpOpoRRXazxs5EHV1fmXA5zBpO66t7lIx8/74nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aF1b5Xz8; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aF1b5Xz8"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59dea72099eso3778575e87.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 07:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771254836; x=1771859636; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARVlRZLS2IZMmsfNeB9nzFj870EQPkmjLcXV/k5P/+U=;
        b=aF1b5Xz8mWdddP0RHA9+ZjFRR+jZ/HF16DN9s0WswfaGZb5XzVkgLrUVyZ5zSCsIgy
         0Y/CuwAw59osTAXv9jSXPe42Qn/XCQIFi/SPymY7D34gX6HAn7F7uDwhD3Zsh+Zwwuva
         AUemiPa/WQsMaTvdYEXqEAs3nwNNK7x4g53nB4N6gn6yOc8H+ksLfj07MEclP2Jn9y//
         GVBWPhWOaZhfh58FKO3SQSbCDIVGIMIZsReAM16rRdjF6O2UtK1spCZzJIguvuZ9LPbB
         j09TVBorZTIExbr19eYacwsX//0RiKI4VCw8Sn0qRrqDiBRE4jHUG+l7Rbny6lhTeoEy
         Fe5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771254836; x=1771859636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARVlRZLS2IZMmsfNeB9nzFj870EQPkmjLcXV/k5P/+U=;
        b=wQcTocX9oUxqmFYH0xMAugIrgl9NAYiXWktVdGxliPb8sPNidTXNzlff2X6lDbzLgj
         I7a06WB75glwDFkvY/r9azq3Z2JXwZkRHr83rfHsSwZpZDnNdIh5ZMN18pD9h09GoRPQ
         EqNobTrrrs8ojBYxuSkjikuTgVvn1ORFFL2tGB1YsrEHuPxtQabVpuWoMDKb0UN3lwRO
         2CiNdLZou6yn+9naPMSs5kZwI7zgTqvXHEHPbrxFRaxaRzHnfCl2w+yA82O+b8EHyaLU
         H38H24F0ZeTycvECVW93COVBbvZf6eS/R8lbUuE5h5yNt1BFGqUjHdpjL9MAUzuXJzZF
         hLwg==
X-Forwarded-Encrypted: i=1; AJvYcCXfbdHm6TjTytRHsMb7ZCkhoyvd8roxscAQkxLj883Xw5yHOr6EM/0WdO00cVYRmDWzgqix8eE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKbJD7nHkccTup2nlPTjtb6UlIxBKy+u5OYVwzyEWGyBiW7Fqq
	riDm+phwsemvCWOjzmx2CDmk1VHhHnEW4EwEhuEL7Qbtc3mujT9NdAglXacsf9txQv8ZRah+3E6
	46sZkqGQ=
X-Gm-Gg: AZuq6aJKLXzqjezxBdvdt1sLQaeK4jMhdb/06ZKfaHtrTK4tw3BB2YKQqyJEci0JB3B
	zhPOdIYIiemoRrMBOsucZitHDJF8k5g/Lwd4M/mtyJDBBzpbCfMmnsaq0CSBhHlAcAaILMDlblc
	GnA2j39k9ljh7Gy/yAqzNASuFjDCKvCNPeBT2j05ktarjX8ALdzQjInoEfSmGV9Vvxrp8Xcswrt
	20uxzKVxK4qTpZQoldDnlVq/RVVFpXvLvWwzNrqxkMmCX460ZoL5XRvdZZ5EYuMZihVaPXDRISF
	LkzAoSZM6xlTIoDmwvDKIdh103XkofbRfMOrN1cZXqpAUH67mmD5kgB9WLAJhd77Z84F7jAKx43
	yDN1ffaXG6dHKmLDjOm9oNMVjtxIwdCAPI+3gf0JpQFP+a3/eP2Xw/NZU9xM/ph5JjvmYweT+O8
	oZHrEy7zpeajoIlBKnTJaWmHfEPnK2
X-Received: by 2002:a05:6512:15a6:b0:59e:4671:1020 with SMTP id 2adb3069b0e04-59f6d3883e5mr1888575e87.46.1771254836319;
        Mon, 16 Feb 2026 07:13:56 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38706906089sm29671031fa.31.2026.02.16.07.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:13:55 -0800 (PST)
Message-ID: <878e304e-4162-4981-8125-bd4f67ba9dd5@linaro.org>
Date: Mon, 16 Feb 2026 15:13:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Leo Yan <leo.yan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Fuad Tabba <tabba@google.com>
References: <20260216130959.19317-1-will@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260216130959.19317-1-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/02/2026 1:09 pm, Will Deacon wrote:
> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> generation in guest context when self-hosted TRBE is in use by the host.
> 
> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> per R_YCHKJ the Trace Buffer Unit will still be enabled if
> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> Trace Buffer Unit can perform address translation for the "owning
> exception level" even when it is out of context.
> 
> Consequently, we can end up in a state where TRBE performs speculative
> page-table walks for a host VA/IPA in guest/hypervisor context depending
> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
> result appears to be a heady mixture of data corruption and hardware
> lockups.
> 
> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
> draining the buffer, restoring the register on return to the host.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> NOTE: This is *untested* as I don't have a TRBE-capable device that can
> run upstream but I noticed this by inspection when triaging occasional
> hardware lockups on systems using a 6.12-based kernel with TRBE running
> at the same time as a vCPU is loaded. This code has changed quite a bit
> over time, so stable backports are not entirely straightforward.
> Hopefully James/Leo/Suzuki can help us test if folks agree with the
> general approach taken here.
> 
>   arch/arm64/include/asm/kvm_host.h  |  1 +
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
>   2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac7f970c7883..a932cf043b83 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -746,6 +746,7 @@ struct kvm_host_data {
>   		u64 pmscr_el1;
>   		/* Self-hosted trace */
>   		u64 trfcr_el1;
> +		u64 trblimitr_el1;
>   		/* Values of trap registers for the host before guest entry. */
>   		u64 mdcr_el2;
>   		u64 brbcr_el1;
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 2a1c0f49792b..fd389a26bc59 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>   	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>   }
>   
> -static bool __trace_needs_drain(void)
> +static void __trace_drain_and_disable(void)
>   {
> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>   
> -	return host_data_test_flag(TRBE_ENABLED);
> +	*trblimitr_el1 = 0;
> +
> +	if (is_protected_kvm_enabled()) {
> +		if (!host_data_test_flag(HAS_TRBE))
> +			return;
> +	} else {
> +		if (!host_data_test_flag(TRBE_ENABLED))
> +			return;
> +	}
> +
> +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
> +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
> +		isb();
> +		tsb_csync();
> +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> +		isb();
> +	}
>   }
>   
>   static bool __trace_needs_switch(void)
> @@ -79,15 +94,18 @@ static void __trace_switch_to_guest(void)
>   
>   	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
>   			  *host_data_ptr(trfcr_while_in_guest));
> -
> -	if (__trace_needs_drain()) {
> -		isb();
> -		tsb_csync();
> -	}
> +	__trace_drain_and_disable();
>   }
>   
>   static void __trace_switch_to_host(void)
>   {
> +	u64 trblimitr_el1 = *host_data_ptr(host_debug_state.trblimitr_el1);
> +
> +	if (trblimitr_el1 & TRBLIMITR_EL1_E) {
> +		write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);

Will this restore a stale value if you do kvm_enable_trbe() then later 
kvm_disable_trbe()? Looks like the read and save will be skipped unless
host_data_test_flag(TRBE_ENABLED) is true, so it will never save a 
disabled value.

kvm_disable_trbe() might need to clear host_debug_state.trblimitr_el1.

> +		isb();
> +	}
> +
>   	__trace_do_switch(host_data_ptr(trfcr_while_in_guest),
>   			  *host_data_ptr(host_debug_state.trfcr_el1));
>   }

