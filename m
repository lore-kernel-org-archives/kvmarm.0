Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D32F58
	for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 16:40:40 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id q196-20020a632acd000000b005140cc9e00aso13615180pgq.22
        for <kvmarm@lists.linux.dev>; Sat, 15 Apr 2023 09:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681576839; x=1684168839;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=edJ/8m/hi3oLGytM7aKqe1ZAWmH9bh2Sy5kO3X9HLCg=;
        b=2QAl3z9GUrv+fNBQ0blS9baSho0J11b079sd+mJX3sh0TkcWMTcgtJabqPYXI/Z1KK
         n08VA3LjH4GuKOF+dlVgh0RGVXP9/0gk7UZTJgobLZDghhbp7FvNbB5bZFprdObPwaS1
         phquLKjrHz+8FlCccLG2WDN9tCRYSmtZbzH8dasm7VR3Yyh9SF/aVUL/qI/xpDIUe9Jf
         hHxlo2H3AtQtBpSXPxpcju4yFNYSQDArFOh+GBmgfFTLCGddYnJKCCVEtMPGjn3kOSNE
         ch/XtDmfccFdFQ5uGTWbY+QezeRTFON94CtS1lrfWkigpKts5sNxJuMzXOOksmUhbKfr
         Knkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681576839; x=1684168839;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=edJ/8m/hi3oLGytM7aKqe1ZAWmH9bh2Sy5kO3X9HLCg=;
        b=BNhgS8DoXfn7n/iCaKN2drD19qhNKKYT8SmsYq6VCHlPT7lOXsxVXAEn5WJFbD74sy
         tUHMnb0EB6pp1Llbx67ZKWugxbejS3PeARwbewiYGRJo8f0YvdpYcZF4C919pB1FvQ7x
         Sgo8f8LzmkqUw5PGqy00qkNMGY2JDWASWyaDo5GxFdl8Ap7mUVg1AwCMeExMu11F4FOU
         TclQFcl0ceRoVAxEPmwmC6jnvaFqFuY0oh39VnnCWE7F/RwQl9gCnD1QnFBtryCzu2px
         lIM4Iw0by0nUAL+H7tkhsuUmbqiotclq7ZVfqFiLTO2ewQ22rTNVwu3LFm4mstm7rQSq
         Zszw==
X-Gm-Message-State: AAQBX9eeQ9bxCpBY9BWiBQ91GdaykxxHLYis4+5aOApq/bperDpgPyqq
	VcQOL3NqpuTswAmKnULCET1cDXy6TKg=
X-Google-Smtp-Source: AKy350Yv3s5ep7D7zZyG+Et4G6Q08mYKXp9AqiJJfgV4/tHON+L4dGztaBGVDdCldKPepvfT1xtBuK3yPus=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:ba5a:0:b0:518:244c:1cde with SMTP id
 l26-20020a63ba5a000000b00518244c1cdemr1709195pgu.2.1681576839640; Sat, 15 Apr
 2023 09:40:39 -0700 (PDT)
Date: Sat, 15 Apr 2023 09:40:27 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230415164029.526895-1-reijiw@google.com>
Subject: [PATCH v3 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
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

v3:
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

Reiji Watanabe (2):
  KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
  KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm64/include/asm/kvm_host.h       |  7 +++++
 arch/arm64/kernel/perf_event.c          | 21 ++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/pmu.c                    | 25 +++++++++++++++++
 include/linux/irqflags.h                |  4 +--
 6 files changed, 88 insertions(+), 8 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.40.0.634.g4ca3ef3211-goog

