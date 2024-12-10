Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BC223DE8F
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 10:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733826623; cv=none; b=kEG9W7lP2Muag4k5pnrtQn02+asFH5kvfaeUFuPfGIHsdBlw0vq5lDhe6XZxl6zYfe0uMP8tytgAaCD5iYAZfLx6QoO08kXhOORa8fHUFcF5w7B2dObwGmCgChwBg4Anou3frW5JjuL9bDfR7gv/bQsCR39mjqAUg8thQ4kF+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733826623; c=relaxed/simple;
	bh=K4JRNtokVTo5yBSbfnxvAexmolrFDdWA3D6ybzR01hE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDPWpNtTDx4yBRWpgg6VhKmmdgX5rBfHAvT4zacg/DZ27lbPvkCtdBZ45X43WWHSL06g6tp7fC5z1RiSRgoodJoG6WJxmb/0mZskyTJs9VM4DJPP1+2vQ4eM/tI6NROIrvn2yVEi5R5bR3oviKPsTES5RDxAzCaPa5SbCod1UrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cWhD0g2Z; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cWhD0g2Z"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-434f74e59c7so22739315e9.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 02:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733826620; x=1734431420; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DDjcCZSe8KAJq42IqprOyS1d580l4vFo1LRRZ3pxbmo=;
        b=cWhD0g2ZwLeJcQs+hU+0scG8EaC3e4Q2WzB88KKwCw7ZojR6XnWOH1gX4cBXPlYF/Z
         6kR9Lnq8GgxEJ0aic6UEhhwXFl04XZFR0IRgCdTy+pP7IE43ii1aW5RhV0JJEdIF3S2/
         f/R6ICYNtZIHnKVaNbMTuB303FMZHSnxqvG6XqgCEBXsV4NBJ4NmL30LvxyoZ4dpAHka
         eHGe7iEV63KWSP+4iPO2IMzm1sBC4bMpNLn1DS4pKmKmTGMG5aJ5S0tLjvlo+sOa9WZl
         /X+4FEVYvQFTw4LnM1HTtjFhGQqkwvTzJN+cHRwW9jroJk7BILvnF54tlzgtFQCnOnlN
         4pMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733826620; x=1734431420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DDjcCZSe8KAJq42IqprOyS1d580l4vFo1LRRZ3pxbmo=;
        b=PBlvVd+g+9Pwvr+P2joXsqy0C1/iE5ImE5BHZ5c+zUBIkbKQ4fS364mtj9nhb7zc7u
         vaOng/YCAy2Zfi5792ek0Gb1jEbtK4X3BP3/mYI1MczbPGwefk7S4yHu3kPd+0owLP2F
         Gg9Vv5tkn33DTMerI8or0Q9cOBsNTkJ8NGf6FAzEMmmCKrthCxnIsrmvnpvWjbMV0ppM
         PYqBz7rOWrKSajbHePTRnwRsvkmvfA8IokxZBdCiU5QIgahXX15HhgXnEGQs7KOK5swG
         paVHPm5IUjI1UsdW+mM0HbPmfPBI3KYVLPJOHFBNSK61+0OxJT798nU+sL61xPbb0sdS
         mTUw==
X-Forwarded-Encrypted: i=1; AJvYcCUhx4/FxkMH0ReFECskkdDbv0m6T53sLnLXX0+/tOHe3ds1rcwXKAQOgF+Oj6M3O8ji8m2Uj+s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoNZ3IdimdpgxH5ZqfghQbT40nTjA4zX0hiPaTptpM++01H4Wu
	E/48hFB7EWG9aq7wBufhf34CpaVXzDJQXcC9lc8auZxlTQs6sXSIqXobnG/Vpdw=
X-Gm-Gg: ASbGncvTdvC5gFJP+mgFjRZJOsXPSEwj32c6+pYsUKqZfn4NMx9l0Hl1I9YZI4D4Or3
	YlO1HjbHb5FjZzEMTCYme8kaZjBWM3ExljCPbHKyUWcJjAkDpraCGFM/nyEB3p2X+dR91lVGbDh
	aI3HP0s23cc6nOKNGSz+Qyu1LgwiovsDuUmPRLIZLce+BWjuTmvBhZkiLGjiWSJUHxjuyBtcYUe
	ohtEYpNu447KjLlrqhiOj7CI2vQVf/mWilkKuVxg95E3GDW+V+7u9WAr93Yquq8KA==
X-Google-Smtp-Source: AGHT+IGpjl+mx9DCXaoqvmMEFb5kmyCFxDm2kCYVdrAU/KzGZWkhmwsQc1ksxXX4sTa5HheYB5M/xA==
X-Received: by 2002:a05:600c:358a:b0:434:a852:ba77 with SMTP id 5b1f17b1804b1-434fff50290mr42352265e9.15.1733826620251;
        Tue, 10 Dec 2024 02:30:20 -0800 (PST)
Received: from [192.168.68.163] ([209.198.129.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434f2d08564sm94109455e9.12.2024.12.10.02.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 02:30:19 -0800 (PST)
Message-ID: <17a6c687-a661-44f2-8178-50cff71d1d48@linaro.org>
Date: Tue, 10 Dec 2024 10:30:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/16] KVM: arm64: Debug cleanups
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>,
 Colton Lewis <coltonlewis@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 09/12/2024 6:09 pm, Oliver Upton wrote:
> On top of the cleanups, this series takes a considerable bite out of the
> volume of sysreg traps when running windows, which likes to read
> MDSCR_EL1 quite a lot.
> 
> v2: https://lore.kernel.org/kvmarm/20241115224924.2132364-13-oliver.upton@linux.dev/
> 
> v2 -> v3:
>   - Respin to 6.13-rc2
>   - Fix unsafe usage of percpu data in kvm_debug_set_guest_ownership()
>     which led to a splat (James)
> 
> Oliver Upton (16):
>    KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
>    KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
>    KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
>      vCPU
>    KVM: arm64: Move host SME/SVE tracking flags to host data
>    KVM: arm64: Evaluate debug owner at vcpu_load()
>    KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
>    KVM: arm64: Select debug state to save/restore based on debug owner
>    KVM: arm64: Remove debug tracepoints
>    KVM: arm64: Remove vestiges of debug_ptr
>    KVM: arm64: Use debug_owner to track if debug regs need save/restore
>    KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
>    KVM: arm64: Compute MDCR_EL2 at vcpu_load()
>    KVM: arm64: Don't hijack guest context MDSCR_EL1
>    KVM: arm64: Manage software step state at load/put
>    KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
>    KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore
> 
>   arch/arm64/include/asm/kvm_asm.h           |   5 +-
>   arch/arm64/include/asm/kvm_host.h          |  94 ++---
>   arch/arm64/include/asm/kvm_nested.h        |   1 +
>   arch/arm64/kvm/arm.c                       |  14 +-
>   arch/arm64/kvm/debug.c                     | 378 +++++++--------------
>   arch/arm64/kvm/emulate-nested.c            |  23 +-
>   arch/arm64/kvm/fpsimd.c                    |  12 +-
>   arch/arm64/kvm/guest.c                     |  31 +-
>   arch/arm64/kvm/handle_exit.c               |   5 +-
>   arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 +--
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
>   arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
>   arch/arm64/kvm/sys_regs.c                  |  55 +--
>   arch/arm64/kvm/trace_handle_exit.h         |  75 ----
>   16 files changed, 281 insertions(+), 523 deletions(-)
> 
> 
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4

Tested-by: James Clark <james.clark@linaro.org>

