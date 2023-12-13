Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B0D2E821
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BgbgmGAI"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3363aa1b7d2so587441f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 06:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702477096; x=1703081896; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pMvhSkMSE/Am1VRqFroHUAOOjs4iyetVHF646YQvvOI=;
        b=BgbgmGAI9OtKAuQ1tZUo/S5nLTM60e7AX3k21zAmgBfq//TaAfS6W0moGcqjHIk9E+
         GnH2WitjMHnRgBZmFVNinOllFrj/smdoWI8ZWm9RzJ5xUphQE941SnvYKfcr29Rs9cQu
         rglH75KXrk3+de/snthXztp7GO07C0Ys0IjUxhqI097OnoUBbkmCavloDTvm5None/SV
         62pJkM5mMEvS83GZYTLOUvO+Cv5R97+IiPyTmLrpdA0sQw69U3Ae3KKOgX8a0FipRyMc
         Y9NPUg/FzXEgh6vjy7F4qMe9QHpo1BywlsXuw1EPyJ3yNA4I30QsNg74yu0/VpgFuilT
         OXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702477096; x=1703081896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMvhSkMSE/Am1VRqFroHUAOOjs4iyetVHF646YQvvOI=;
        b=LxI/WFYiYbS5xXB8YfLPzlfJ4gO1FpRav3+2QPjUScNTf3iox7M5shSxOnswLT7qBi
         FzNnYvfLIPgD9klJaMFqXTJ30VdivkSB3/Spvn0XamBfOyShjoyoCAlABqSnkqbPcTLq
         INJ46/rTurc9zFrP/ir/J4cyGnyKalrvM2ecs9tlIhdFBKRze9xADcs1xZx9JQ7FF11A
         CT7xaP3CsQExe+MKpNT9H6is1gOYGfTkb+6hmoAa983Of+9pEaIqZwgBgHXrScBtVE4y
         4wsVcb794+o1HXZHJi4zon5yqSGmKDWuwcQKFLEcWZ3bKpg0KIJtrfy6QVvuuZEDA40w
         b4xA==
X-Gm-Message-State: AOJu0Yz1VqCsWzXRVy3B3n8vN8QpIIbtE/JE6jap3ZukG01j2UiHeVlw
	csrJFIXz64BHyYNnkAVeQJLeSA==
X-Google-Smtp-Source: AGHT+IHHAN8IaZVRK1Ps8W71SJhwMq4xLyWFOqoAIKM4rFfgBhljotdkzECz0shi/fy3fHhekB11VQ==
X-Received: by 2002:a5d:6242:0:b0:333:3c06:b433 with SMTP id m2-20020a5d6242000000b003333c06b433mr2848127wrv.0.1702477095654;
        Wed, 13 Dec 2023 06:18:15 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v16-20020adfa1d0000000b003362e9b75c3sm4056912wrv.88.2023.12.13.06.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:18:15 -0800 (PST)
Date: Wed, 13 Dec 2023 15:18:14 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Greentime Hu <greentime.hu@sifive.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Jisheng Zhang <jszhang@kernel.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Samuel Holland <samuel@sholland.org>, Sean Christopherson <seanjc@google.com>, 
	Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, Vipin Sharma <vipinsh@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 10/11] KVM: riscv: selftests: Add sstc timer test
Message-ID: <20231213-4ba5fcc75b41cd19ec96f08e@orel>
References: <cover.1702371136.git.haibo1.xu@intel.com>
 <3bb7d5ae5a1a016e970faa0759c47214c9391b19.1702371136.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bb7d5ae5a1a016e970faa0759c47214c9391b19.1702371136.git.haibo1.xu@intel.com>

On Tue, Dec 12, 2023 at 05:31:19PM +0800, Haibo Xu wrote:
> Add a KVM selftests to validate the Sstc timer functionality.
> The test was ported from arm64 arch timer test.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/arch_timer.c        |  12 +-
>  tools/testing/selftests/kvm/arch_timer.c      |  10 +-
>  .../selftests/kvm/include/riscv/arch_timer.h  |  71 ++++++++++++
>  .../selftests/kvm/include/riscv/processor.h   |  10 ++
>  .../selftests/kvm/include/timer_test.h        |   5 +-
>  .../testing/selftests/kvm/riscv/arch_timer.c  | 107 ++++++++++++++++++
>  7 files changed, 206 insertions(+), 10 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/arch_timer.h
>  create mode 100644 tools/testing/selftests/kvm/riscv/arch_timer.c
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
