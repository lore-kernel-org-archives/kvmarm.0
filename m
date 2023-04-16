Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411D87B
	for <kvmarm@lists.linux.dev>; Sun, 16 Apr 2023 04:53:32 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id l124-20020a252582000000b00b8f5572bcdaso8757897ybl.13
        for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 21:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681620811; x=1684212811;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GSBOHO8J2MQ2o/VKIsPqTm9ugOUbkx/1SnLPtI3xz4A=;
        b=ao6Gt0p3QbgT6+gIHy9isrfjtcrgOsou5uEF8cXmo65HRAKbSjAWxBlj5942sbxx7Y
         /LqSQftNAIHrBN8knrrYx+4xCYjN/X82j3NAddpQDH9Rlx5YGZf8VxJqH09V7XpxhFJx
         PdWGl5uOrq8wtx/GO6wmEfxK2+rlcFb6ZO8G8UnK8ey0/TeOKeDZI4vdkuVmTjHX4Jdm
         O9h6hXfUrxOQXsInVKpGZilOzVoAEBqBQ6vPAsQNSJhHcY2LbqUE6sS3rKDCP/s5kK4d
         PzFCt9s8+1cojNl2E6UpxGcnGyx9sA3BYYsvaJXx4ve5N6GbB7UiuIhHfywVhcEywCPj
         hW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681620811; x=1684212811;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GSBOHO8J2MQ2o/VKIsPqTm9ugOUbkx/1SnLPtI3xz4A=;
        b=aLRG8Ag6uR0aND009PXexbBFhli709bDMkluq/8O8IWL+cxJ2iMAOYUTh7hn+I0NvS
         +A7NVbexRqvWEe6abomOO6DrLYUFdfCH7smOly7j1Ja4NXE5Ye9oXMrR/cokG67LLyV0
         S20EDIGVbKgymjnzrxaJuLcfg4ySrbLX3Fem2eUd7HtMTKhuTM3n+uj0wwS0qq0yFht7
         haGoT1dIz38DFdRJFTgJBXtNQKJpCyjZ8pSAAo0FhF388VQCs4rW20HzCQAjjUXicnV0
         x6RJQBTrjrFJsoUi+gI1e3s0GvICRgGihpOf29wpmejmhRK64kA0iPkjt7pdw7z3yN86
         roTg==
X-Gm-Message-State: AAQBX9dqSOutwdg2Fumt09LhRtRC2Qalg8Q6jAgyLyTi5Q/UTidjPYl/
	xzsZ0P6BBUngpeTzIdW3zX8XJJxZ0wA=
X-Google-Smtp-Source: AKy350YrV2Jc2viuvwLHBzra9y9vpzRiIgY9TA0+SRfr+P59RNJCm7Qq0WQi8xckYzZJwFXI/uJfbMWGyoU=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:e08c:0:b0:b8f:3647:d757 with SMTP id
 x134-20020a25e08c000000b00b8f3647d757mr7226448ybg.11.1681620811185; Sat, 15
 Apr 2023 21:53:31 -0700 (PDT)
Date: Sat, 15 Apr 2023 21:53:14 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230416045316.1367849-1-reijiw@google.com>
Subject: [PATCH v4 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Rob Herring <robh@kernel.org>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

This series will fix bugs in KVM's handling of PMUSERENR_EL0.

With PMU access support from EL0 [1], the perf subsystem would
set CR and ER bits of PMUSERENR_EL0 as needed to allow EL0 to have
a direct access to PMU counters.  However, KVM appears to assume
that the register value is always zero for the host EL0, and has
the following two problems in handling the register.

[A] The host EL0 might lose the direct access to PMU counters, as
    KVM always clears PMUSERENR_EL0 before returning to userspace.

[B] With VHE, the guest EL0 access to PMU counters might be trapped
    to EL1 instead of to EL2 (even when PMUSERENR_EL0 for the guest
    indicates that the guest EL0 has an access to the counters).
    This is because, with VHE, KVM sets ER, CR, SW and EN bits of
    PMUSERENR_EL0 to 1 on vcpu_load() to ensure to trap PMU access
    from the guset EL0 to EL2, but those bits might be cleared by
    the perf subsystem after vcpu_load() (when PMU counters are
    programmed for the vPMU emulation).

Patch-1 will fix [A], and Patch-2 will fix [B] respectively.
The series is based on v6.3-rc6.

v4:
 - Introduce NO_DEBUG_IRQFLAGS to exclude warn_bogus_irq_restore()
   from the nVHE hyp code. This is to address the issue [2] that
   was reported by kernel test robot <lkp@intel.com>.

v3: https://lore.kernel.org/all/20230415164029.526895-1-reijiw@google.com/
 - While vcpu_{put,load}() are manipulating PMUSERENR_EL0,
   disable IRQs to prevent a race condition between these
   processes and IPIs that updates PMUSERENR_EL0. [Mark]

v2: https://lore.kernel.org/all/20230408034759.2369068-1-reijiw@google.com/
 - Save the PMUSERENR_EL0 for the host in the sysreg array of
   kvm_host_data. [Marc]
 - Don't let armv8pmu_start() overwrite PMUSERENR if the vCPU
   is loaded, instead have KVM update the saved shadow register
   value for the host. [Marc, Mark]

v1: https://lore.kernel.org/all/20230329002136.2463442-1-reijiw@google.com/

[1] https://github.com/torvalds/linux/commit/83a7a4d643d33a8b74a42229346b7ed7139fcef9
[2] https://lore.kernel.org/all/202304160658.Oqr1xZbi-lkp@intel.com/

Reiji Watanabe (2):
  KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
  KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm64/include/asm/kvm_host.h       |  7 +++++
 arch/arm64/kernel/perf_event.c          | 21 ++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/pmu.c                    | 25 +++++++++++++++++
 include/linux/irqflags.h                |  6 ++--
 6 files changed, 89 insertions(+), 9 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.40.0.634.g4ca3ef3211-goog

