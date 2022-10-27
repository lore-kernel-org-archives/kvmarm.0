Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4626C7B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 21:17:17 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d10so2960143pfh.6
        for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DM/N1LiRYR5yDHC9HV4NzFlP3woquy/xP1yC7CcJoiA=;
        b=VluDObdXopb8OAj9DyzgeU6LPp3JZHPn0iZsIbwsJ/VDaCueQ8VwT3B7TvUs2XlNF8
         cl6e3Hhh4x7f6XgprihONG99p6rxwItlVzP3MLnhtN2MVuX36mU0A5Fzz1U0yrNKsiJa
         4b4PoCN5cBeJl1qbJ9oLFjMYcmLxBvtxg4/jE8f4P7GYlzCmoGJRqalnqi9OPa5ToemN
         mP/rlmhFbesoSquKtzlaZWmyvWESW8uXZEYBTn520OnSnMp7laThcmz6Rein1gk7QACQ
         vxs3qxPeg88r6lpRDslENQJfQ6si1kJ6FBLy1LcDT80a4kPJIMC1yS5g4cEW2cwAs7aU
         T3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DM/N1LiRYR5yDHC9HV4NzFlP3woquy/xP1yC7CcJoiA=;
        b=5rKf7lvTnhkz7NLnjzfGhut6eKXLmE0bKByGL3ijWweBFAGeXBXN0mHgJBoYbjlRh0
         fJWMQGDd4eqFBTiXhK9n+tcxaw0ftqWLTt336dgaud3XhRxUZN12chgtyzzGsipGyxtb
         bj4aTYeO07YRh/TbZKfCxRNy29/xktlN9m6TmEbvHyO2KfzQ7DFESvrDcO03WcKUr/O6
         /XoeiASTAwI/KOxD0KI0odSziDC2YWA3j1NXEbdY6S0KmEqRU141mGTvOXj1pMzN18Ar
         lpNgJ1zfi5pR2I6WJA85StgvcQLKTKwQTqX8ZVP6w+p7ZIG+Tovl+6fxN006je4fQcLB
         dolA==
X-Gm-Message-State: ACrzQf0g89E6PT9cGxPlXBs/IaKHpZqVeH+BYjyDPMCpcpI4UHHoQ2/C
	MvSmoEIkKqnzupzhqcYL4K2h6w==
X-Google-Smtp-Source: AMsMyM7pBE1eD4OtSevp7WS6mbWoc1thuhcbX7HeLyaRkxyHXJXBXYHwDnYQ/lDoXHycVN+YNaspaQ==
X-Received: by 2002:a05:6a00:1306:b0:555:6d3f:11ed with SMTP id j6-20020a056a00130600b005556d3f11edmr51174431pfu.55.1666905436664;
        Thu, 27 Oct 2022 14:17:16 -0700 (PDT)
Received: from ?IPV6:2001:8003:501a:d301:93c4:c1c9:4368:47fa? ([2001:8003:501a:d301:93c4:c1c9:4368:47fa])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b001853e6d6179sm1620164plm.162.2022.10.27.14.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 14:17:16 -0700 (PDT)
Message-ID: <a8e0768f-6537-8f4c-8ba1-956aedd052bb@linaro.org>
Date: Fri, 28 Oct 2022 07:17:08 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1 0/2] KVM: arm: Refuse to enable KVM on systems with SME
 but not FGT
Content-Language: en-US
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Vincent Donnefort <vdonnefort@google.com>, James Morse
 <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20221027205246.812586-1-broonie@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20221027205246.812586-1-broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/22 06:52, Mark Brown wrote:
> The architecture requires that any system which implements SME also has
> fine grained traps since SME is a v9.2 feature, meaning that v8.7 must be
> implemented, and FGT is mandatory from v8.6. SME relies on fine grained
> traps to control access to SMPRI_EL1 and in nVHE mode to TPIDR2_EL0,
> without traps SMPRI_EL1.Priority and TPIDR2_EL0 can be used as side
> channels.
> 
> This series adds support for detecting FGT and refuses to allow KVM to
> be used in architecturally invalid configurations which have SME but not
> FGT, without detection the issue presents as faults due to EL2
> attempting to access the FGT registers which isn't obvious to users.
> Currently fine grained traps are only used in nVHE but but a series
> "arm64/sme: Fix SMPRI_EL1 traps for KVM guests" sent along with this
> will add usage for VHE mode too making the issue more pressing.

Series:
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

