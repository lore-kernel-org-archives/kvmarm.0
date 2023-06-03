Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CBC179
	for <kvmarm@lists.linux.dev>; Sat,  3 Jun 2023 02:50:57 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-babb5e91ab4so3949824276.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 19:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685760656; x=1688352656;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UOf7JPRrL9hOlCaj9LUz9Ny3KjSPlKOPu6lXUFM6n9A=;
        b=xkSOr8wPdu2X1Ygw948lyPjL5RZCQ2t2i9AMO19v/2eo1cDzHmh5ywh5RA7q5cJKzt
         6HGicNi6fFQzgfPoHLvyOBh8clVCjQZqwgqrIZIxVGZtCtdwKpnHqP+Fq8eKCpkpmR2e
         N5RCdxzXmZdCEyrt1qxBg6UBMcjOmvCAgb0STUfw6Evfvw7cOTKPYu+hZ47vWL2BfoMi
         YcsSmW8Lwqzd/jx7NHUtN8OJqA2PMc3I2vo8Zdjq54G+oW/HgJRXoYR8UhgTXWrKQPf+
         XwPiySuX0KRWbQoj6hG4yDWEeSaXik+gpix2RPSc/vje5IkSCGFz+XZjVf0gLUHHelCD
         BeIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685760656; x=1688352656;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UOf7JPRrL9hOlCaj9LUz9Ny3KjSPlKOPu6lXUFM6n9A=;
        b=O9JAF3Pu88oR/33pz7xiLVwXOI6aowhQVE3UeLTBQ6BYDDDzZrz0v4gKiumgKiVs1N
         aTzrzezCPebG1s1B9EVgbdIIXfLZTt/r0FIJ9vaw63BuIS6QYVbbNuo5A1cWp613LiyP
         BBUjxMLsHXhRJ4glYYvWfSGFu1auTyKiwSFblDkN0LcIkUvAHZiDOosrs6TmQ3zhTqou
         lgyPNDHbrd6KDamqEb7Yq4W6pR4dfdPBLzlpFjQY/yxF4+eJodiLJbwwICXQaTWol+zH
         L2Pr1HL1/I4RuGHWhK0cc0Xh2XmNHRV58GxdVL+hAUs3+bEigfRsr1X6IqsLr7zF+igT
         UYJQ==
X-Gm-Message-State: AC+VfDzdJHLoy4H/86eDGVE/7kMjmwgFGc7IfRhZJMJYEbnoNaL7Obut
	ujEvQ8sQE7+mO3/3flnF3NNJAb0MwHU=
X-Google-Smtp-Source: ACHHUZ4nr7cemm/IrLIW9GYN15UjE/9E42hV5mDDFqDGx7aWoU9woHyAtb3GzYQn3XbU4w1OfNQQzKwbR3Q=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:100a:b0:bad:600:1833 with SMTP id
 w10-20020a056902100a00b00bad06001833mr2835309ybt.0.1685760656190; Fri, 02 Jun
 2023 19:50:56 -0700 (PDT)
Date: Fri,  2 Jun 2023 19:50:33 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230603025035.3781797-1-reijiw@google.com>
Subject: [PATCH v5 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
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
The series is based on 6.4-rc4.

v5:
 - Move IRQ save/restore to {activate,deactivate}_traps_vhe_{load,put}().

v4: https://lore.kernel.org/all/20230416045316.1367849-1-reijiw@google.com/
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

 arch/arm/include/asm/arm_pmuv3.h        |  5 +++++
 arch/arm64/include/asm/kvm_host.h       |  7 +++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 ++++++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 14 +++++++++++++
 arch/arm64/kvm/pmu.c                    | 27 +++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c                | 21 ++++++++++++++++---
 6 files changed, 84 insertions(+), 5 deletions(-)


base-commit: 7877cb91f1081754a1487c144d85dc0d2e2e7fc4
-- 
2.41.0.rc0.172.g3f132b7071-goog

