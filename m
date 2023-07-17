Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62615A8
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 08:13:03 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3141c3a7547so4004789f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 01:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689581581; x=1692173581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VT24UUIzDMth5tPZL5Y5vTEOs+P0BwYmDWZgKveF0+M=;
        b=K/iJhKX4wID4O6BHCkqoNDeKizzM0ai2C/JJVSYMd+iQ+t5gkYEyqR8OcId9s6Uw/g
         +AIOCIIHWgQP5i51DcuabWMLSpL4+g4yBFEaNnFvCFvlOvJtDRtBZSsu4q/eyraIhxnF
         34lFSWsMuYImH0tASUyIG9UN5kV+zySjXP1wgy3I0PiMTd8SGe0bBTaL1/3m+AIDIUri
         t2pJXylGN30xSlpLDQiAnrflPN5i2wyDLNiZpxqAYVBhvceI1p6Lvuk8qVu8Vmd37D5M
         py/+IAtS+moAn/+PGdzK6ETPGkvlELAfB3SP0bODnQ1hd3dVHt1OhCJkizrojhSmGnF9
         2zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689581581; x=1692173581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VT24UUIzDMth5tPZL5Y5vTEOs+P0BwYmDWZgKveF0+M=;
        b=Fe4MTvmISrf6mtHlzkaz4J7/inVPmYWLU7ho6QLtNasdGZaWfE1W9papbsS10z8mCE
         l1Yl9cXDVUG/UKwVpLOrzn7zb78EEwuevCv+dHYYZNif7/GitrP15EWjTwa/7CTKxSWY
         3XPo+JWrYQYFOV+upqnU3coURRFwOIsj51Dbjs3dzQwJL/WIms9vQWbmOMkxnF53yiMo
         XMaql/d2Z7GhISGfgx23LiUiLxc9adYeJ33CBDO2q07Bk3P60UUnNBqogQph9zKL6QSc
         UJ3vMth4+76F9eVLvoMCnokTitCehH8RjOw8vYlhyawZP/irdiBNdUIRPJTv6AvjWirA
         SbNQ==
X-Gm-Message-State: ABy/qLZ/bkb1tXvH2PCUTP3Zd1x4m9rkWya6He4GUjcYbSM2o8jl1DLA
	xvedozwyD+9TNX2Q9QCmPbsjqw==
X-Google-Smtp-Source: APBJJlHUSWcZYlPppSbFTXSEdHwpgpaTrSSog0KcOaUXq6539rjFQxsogmQ3Co+Knjkf78qoCa1SzQ==
X-Received: by 2002:adf:f206:0:b0:314:34dd:aaec with SMTP id p6-20020adff206000000b0031434ddaaecmr9504790wro.8.1689581581381;
        Mon, 17 Jul 2023 01:13:01 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.144.39])
        by smtp.gmail.com with ESMTPSA id b2-20020a5d4b82000000b0031432c2fb95sm18429372wrt.88.2023.07.17.01.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 01:13:00 -0700 (PDT)
Message-ID: <ef2dddcd-f4dd-da9b-c03f-ccd852bb8543@linaro.org>
Date: Mon, 17 Jul 2023 10:12:57 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v6 02/11] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
Content-Language: en-US
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Zenghui Yu <zenghui.yu@linux.dev>, Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-3-rananta@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230715005405.3689586-3-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Raghavendra, David,

On 15/7/23 02:53, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Use kvm_arch_flush_remote_tlbs() instead of
> CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
> problem, allowing architecture-specific code to provide a non-IPI
> implementation of remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of maintaining
> two mechanisms.
> 
> Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> In addition, instead of just incrementing remote_tlb_flush_requests
> stat, the generic interface would also increment the
> remote_tlb_flush stat.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
> Acked-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   virt/kvm/Kconfig                  | 3 ---
>   virt/kvm/kvm_main.c               | 2 --
>   5 files changed, 6 insertions(+), 9 deletions(-)

You are doing 2 changes in the same patch:

- Have ARM use kvm_arch_flush_remote_tlbs() instead of
   HAVE_KVM_ARCH_TLB_FLUSH_ALL,
- Drop the now unused HAVE_KVM_ARCH_TLB_FLUSH_ALL.

Commits should be atomic, to allow partial
revert or cherry-pick.

Preferably splitting this patch in 2:
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Regards,

Phil.

