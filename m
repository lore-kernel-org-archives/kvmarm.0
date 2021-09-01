Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F897C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:05:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CAD961075
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9CAD961075
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C19A4B0AC;
	Wed,  1 Sep 2021 18:05:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hA1GI2-jBtSS; Wed,  1 Sep 2021 18:05:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49AE04B137;
	Wed,  1 Sep 2021 18:05:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C634B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:05:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5SQ1xRR8C1Me for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 18:05:11 -0400 (EDT)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 796414B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:05:11 -0400 (EDT)
Received: by mail-il1-f180.google.com with SMTP id j15so844799ila.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 15:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+DuLck7trE3/jeuLJyQqFOD4gSDy3mwIoW3d+ThIoWc=;
 b=ue60hZ708cIr7G42kkYJi/pAO26l3GQIlDpRhHkRx9vrX7fkrGwcxv381hWQHI/80W
 u697z+xufWYfztWIL9kzUPbDj+ybhEp3ZG4QiSDxRsFBVYWZhhiadTaAty6AcHC1yd9s
 +RtPFgqGxGPHaBXwIGpGCa/G0bn8zAC5+mwkup6bTH+Ybsz7vXo5hFvzG7kxwf5kJnQX
 mCOcBpbHGFnARtedqKBlXB95AWHySM3o4dW9WeC4PFn7tLnsDhQQFB0XSPli72Glti9S
 5PNsiN0EZfP0B1y9voI1vv+Wx7UuCoYBBbTI5YMtJ9ZqNUut17oqsZ4+Y1pvn+g+sG9N
 NP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+DuLck7trE3/jeuLJyQqFOD4gSDy3mwIoW3d+ThIoWc=;
 b=CvqmUzpLPw27cImdvaeNIQwQ6ZAW3IMMIMUd3LPhcn8PWQSEXPM7YE0x+h9UK5N0I7
 +VTAl2TeEZVz5nExnkMSXYX2AQqxAVbgSdDh6pyFPeHVNMfLKcZ6agxiWXyu0ja8SNxh
 UJ210dgt5EyJT163KmzOilpFTX500m301nsTRO1KNyM/kMKxwczer3K/U0jnHW0P3S7q
 jRWGcFxtR33FDrnOA7XwIfqPE0mtlBxXIU28gYLPbqhLmGvR1MQ4Y/a2/v/0qDWWhgcG
 b6OrNLkWEBV4FBmVislmtkLvRiOO+XftLuMB0/gwiFFt2RdezBVcPagRP0TTNW+FVrpH
 Jl1w==
X-Gm-Message-State: AOAM530VSwhj637+obLrfAkUJqG6UmUln11ss03CEFrJOIBx/GRvttD/
 yecU7MCTkGQTVz0doqPSGNTkXw==
X-Google-Smtp-Source: ABdhPJyz03AQjKq617pC8w9b66FNA0eCW4EBtDeYY+hkxM2sCWzfoOh7yUadawftcIzUoT8TCwMRug==
X-Received: by 2002:a92:c609:: with SMTP id p9mr1138171ilm.135.1630533910160; 
 Wed, 01 Sep 2021 15:05:10 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id h9sm518789ioz.30.2021.09.01.15.05.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 15:05:09 -0700 (PDT)
Date: Wed, 1 Sep 2021 22:05:06 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 00/12] KVM: arm64: selftests: Introduce arch_timer
 selftest
Message-ID: <YS/5EjjPSWjWb6BI@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

+cc Andrew Jones

On Wed, Sep 01, 2021 at 09:14:00PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-11). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> Patch-12 adds an option to randomly migrate the vCPUs to different
> physical CPUs across the system. The bug for the fix provided by
> Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
> pending state on deactivation") was discovered using arch_timer
> test with vCPU migrations.
> 
> Since the test heavily depends on interrupts, patch-10 adds a host
> library to setup ARM Generic Interrupt Controller v3 (GICv3). This
> includes creating a vGIC device, setting up distributor and
> redistributor attributes, and mapping the guest physical addresses.
> Symmetrical to this, patch-9 adds a guest library to talk to the vGIC,
> which includes initializing the controller, enabling/disabling the
> interrupts, and so on.
> 
> Furthermore, additional processor utilities such as accessing the MMIO
> (via readl/writel), read/write to assembler unsupported registers,
> basic delay generation, enable/disable local IRQs, and so on, are also
> introduced that the test/GICv3 takes advantage of (patches 1 through 8).
> 
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
> 
> Regards,
> Raghavendra
> 
> v2 -> v3:
> 
> - Addressed the comments from Ricardo regarding moving the vGIC host
>   support for selftests to its own library.
> - Added an option (-m) to migrate the guest vCPUs to physical CPUs
>   in the system.
> 
> v1 -> v2:
> 
> Addressed comments from Zenghui in include/aarch64/arch_timer.h:
> - Correct the header description
> - Remove unnecessary inclusion of linux/sizes.h
> - Re-arrange CTL_ defines in ascending order
> - Remove inappropriate 'return' from timer_set_* functions, which
>   returns 'void'.
> 
> Raghavendra Rao Ananta (12):
>   KVM: arm64: selftests: Add MMIO readl/writel support
>   KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
>   KVM: arm64: selftests: Add support for cpu_relax
>   KVM: arm64: selftests: Add basic support for arch_timers
>   KVM: arm64: selftests: Add basic support to generate delays
>   KVM: arm64: selftests: Add support to disable and enable local IRQs
>   KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
>   KVM: arm64: selftests: Add light-weight spinlock support
>   KVM: arm64: selftests: Add basic GICv3 support
>   KVM: arm64: selftests: Add host support for vGIC
>   KVM: arm64: selftests: Add arch_timer test
>   KVM: arm64: selftests: arch_timer: Support vCPU migration
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../selftests/kvm/aarch64/arch_timer.c        | 457 ++++++++++++++++++
>  .../kvm/include/aarch64/arch_timer.h          | 142 ++++++
>  .../selftests/kvm/include/aarch64/delay.h     |  25 +
>  .../selftests/kvm/include/aarch64/gic.h       |  21 +
>  .../selftests/kvm/include/aarch64/processor.h | 140 +++++-
>  .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
>  .../selftests/kvm/include/aarch64/vgic.h      |  14 +
>  tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 ++++
>  .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
>  .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++
>  .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++
>  .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  |  67 +++
>  15 files changed, 1332 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> 
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
