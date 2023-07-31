Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A41DDC5
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 21:57:23 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bbb97d27d6so35062735ad.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 14:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690840643; x=1691445443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7XDjhCYt7FGRw55Y+SxXkLDr9VBzRKTPxUQEL1DO0A=;
        b=0r14oa0yxeLPoDTcrUFQsdRmJ1MzKa5X6LsW73dNl1PU/OSY0zRi/GXEUUtRuunzke
         BEXFYTKK9dhr/btpqKk9/KxGb46VF7nLnK8mdvlEa2Vqw6gx1jzqrm22oIwqY9XYoVAB
         o6tMTCDy9zYK4CsNQNKSC8DRFIK6HeIcOJBJcWQcv4dx4BpPRccobsOEqeM2JlWM0c+x
         tRilDqJw0H63lLGsTpxmR4Bilf75D9M09hSNVeFdNixjCrNPPDkxBE6WoQW7XXZ0GnKM
         oLzZ0TTXsq0m1tiYsjmkycSmFXfux5P5Y7E/la2Cz24A5F+xCBn6/y1+P7bnaB9/Ug+S
         oKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690840643; x=1691445443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q7XDjhCYt7FGRw55Y+SxXkLDr9VBzRKTPxUQEL1DO0A=;
        b=QcDAIcXh6+m//kvEYxu8QQxbUKX5bkN1Zdw9KezDc4z3GtQk1FQrtEs5NJmg1Qw6Fx
         zQGc8/eWHtFUgxGFJcI329+TjpEBjpydQgOoy+uArmaqU0kkpDAX8wsgry2YwokAndmV
         kUNekaF6Z00304m8l5fxzHiOEBiRuhiniV6M+gXDx6FBSfuXkY53U7ye20GOZBswnOoh
         bNPMml/n7zgMDfRyZ26fY64mGXbjF/OqeQVWICTakGHGDeTHcd5gaqQBmyR630mkQrCl
         +KHysGeBiU/P7fj1/82ZhEf4vCxxxq5h3UepTrElmEIpLL8nzs0QBbzUzw8IELu1eKD4
         9F0Q==
X-Gm-Message-State: ABy/qLZ67Bh/d13R2byh1Xr6Z8z2eIJov1RkzKl383Cered5laAvxi3e
	L7no1hvZD4KKvGHalBjzr2KdQz9EI60=
X-Google-Smtp-Source: APBJJlEt1EFA1GYHjWvxsA4wpLnQLY4u9T6tmKWhLJwuz8A3I/H56oGiC/ODlllK4HuoyYxAZYF+nbSducE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2291:b0:1b5:2b14:5f2c with SMTP id
 b17-20020a170903229100b001b52b145f2cmr50366plh.4.1690840643199; Mon, 31 Jul
 2023 14:57:23 -0700 (PDT)
Date: Mon, 31 Jul 2023 14:57:21 -0700
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
Message-ID: <ZMguQayWzKU3/8o5@google.com>
Subject: Re: [PATCH v7 00/12] KVM: arm64: Add support for FEAT_TLBIRANGE
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Jul 22, 2023, Raghavendra Rao Ananta wrote:
>  arch/arm64/include/asm/kvm_asm.h     |   3 +
>  arch/arm64/include/asm/kvm_host.h    |   6 ++
>  arch/arm64/include/asm/kvm_pgtable.h |  10 +++
>  arch/arm64/include/asm/tlbflush.h    | 109 ++++++++++++++-------------
>  arch/arm64/kvm/Kconfig               |   1 -
>  arch/arm64/kvm/arm.c                 |   6 --
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  11 +++
>  arch/arm64/kvm/hyp/nvhe/tlb.c        |  30 ++++++++
>  arch/arm64/kvm/hyp/pgtable.c         |  90 +++++++++++++++++++---
>  arch/arm64/kvm/hyp/vhe/tlb.c         |  27 +++++++
>  arch/arm64/kvm/mmu.c                 |  15 +++-
>  arch/mips/include/asm/kvm_host.h     |   4 +-
>  arch/mips/kvm/mips.c                 |  12 +--
>  arch/riscv/kvm/mmu.c                 |   6 --
>  arch/x86/include/asm/kvm_host.h      |   7 +-
>  arch/x86/kvm/mmu/mmu.c               |  25 ++----
>  arch/x86/kvm/mmu/mmu_internal.h      |   3 -
>  arch/x86/kvm/x86.c                   |   2 +-
>  include/linux/kvm_host.h             |  20 +++--
>  virt/kvm/Kconfig                     |   3 -
>  virt/kvm/kvm_main.c                  |  35 +++++++--
>  21 files changed, 294 insertions(+), 131 deletions(-)

Unless I've missed something, nothing in this series conflicts with anything that's
on the horizon for x86, so feel free to take this through the ARM tree once we've
emerged from behind the bikeshed :-)
