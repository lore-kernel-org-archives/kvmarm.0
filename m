Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68795A23
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:15:30 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso6716223ybx.19
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qTPFXR7xayPMmXjv5I92Qg/+hiJ3TkzhKJA6+fFm3/0=;
        b=WVWNuuj9loc9h6TZCkgIUAe3Pes7CURS9fd4kNqqhupv3FAO/+Azm3ly76I4/Q6bm1
         FoJWN9ErFbQmF1S8VqZH48e+QLM2S9/tYaO9xEr9+7q1PgNUA3ytIdPO5wFULKwbFtJ7
         Z7k2KKxy174Ff7gwqzIkDdqNy0PIGTrJo0NGHEGVtbG1bfSZ6WjpirVuGmOOyyxHiIwV
         1LgkUKK/kPuGTE6tFdwcPX5c9xUezJpOxvlUkBQCq6JhnkrmPqz1/6Lpp2DoR/6sWRmL
         EOQgNMBMWWcAomQWjwHcmJerTPmjEmJOoiCf3gs97vAqpzAknu6Nw5BRvTthZdHAnY5l
         iyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qTPFXR7xayPMmXjv5I92Qg/+hiJ3TkzhKJA6+fFm3/0=;
        b=Frc9Ip/DQwcy0ELOP0d8QmcwPNMKYzA3xp+u/wLjnqUlpsJJIzhYRx6hQ6YqdB1Hy3
         mlUbdluW7M/7aG7SNjIJQ67g/4RRPpQMnzfudJWF8mYRNJBUlbzpDbb2B/GBA9DM3vla
         vSP0uxTJsXVTGE1TyYYxaWUhA6betgKI/zmNlQ/1rK4zMDfn/FpXN1KMtEkNcMy8pfIC
         dMUPUUOFw5f9Pnb+jmiKIZB0G0LzW+rFnLmldva18nmWgjzehltiRZmRuOuZIGYwz4Zm
         H0KODDWp3835RmH0xhYojPVJE3fkL25i2NoJvIOYmpYpBFW6MvQqDrirDEdGUQoLJx7v
         kgGg==
X-Gm-Message-State: AO0yUKWie3vSLCLMrkanu46nl7u2/bShLu1nwUe8QNpeLKWDZBV2by9V
	r/TkqWeMCdEOBwzpXCt3ph0RZCvY7K8=
X-Google-Smtp-Source: AK7set84ziwjbnbxt1eT+quqhcoycXZLti74fKWIwfnAOvAJxG0HlX6NP/QONKPeRCe0sdDeXgEZx1x93ts=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:6042:0:b0:855:fafc:741c with SMTP id
 u63-20020a256042000000b00855fafc741cmr22ybb.3.1676085328924; Fri, 10 Feb 2023
 19:15:28 -0800 (PST)
Date: Fri, 10 Feb 2023 19:14:52 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-1-reijiw@google.com>
Subject: [PATCH v4 00/14] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

The goal of this series is to allow userspace to limit the number
of PMU event counters on the vCPU.  We need this to support migration
across systems that implement different numbers of counters.

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the current PE by default.  Userspace can set PMCR_EL0.N for the
vCPU to any value even with the current KVM using KVM_SET_ONE_REG.
However, it is practically unsupported, as KVM resets PMCR_EL0.N
to the host value on vCPU reset and some KVM code uses the host
value to identify (un)implemented event counters on the vCPU.

This series will ensure that the PMCR_EL0.N value is preserved
on vCPU reset and that KVM doesn't use the host value
to identify (un)implemented event counters on the vCPU.
This allows userspace to limit the number of the PMU event
counters on the vCPU.

This series also includes bug fixes related to the handling of
PMCR_EL0.N and PMUVer for a vCPU with PMUv3 configured on
heterogeneous PMU systems. The issues to be addressed are:

[A] KVM uses the host PMU's PMUVer (kvm->arch.arm_pmu->pmuver) for
    the vCPU in some cases even though userspace might have changed
    the vCPU's PMUVer(kvm->arch.dfr0_pmuver.imp).
[B] ID_AA64DFR0_EL1.PMUVer of the vCPU is set based on the sanitized
    value of the field.  This could be inappropriate on heterogeneous
    PMU systems because only one of PMUs on the system can be
    associated to the guest anyway.
[C] The value of PMCR_EL0.N for the vCPU is set to the same value
    as the current PE.  The value might be different from
    the PMCR_EL0.N value of the PMU associated with the guest.

To fix [A], we will stop using kvm->arch.arm_pmu->pmuver in this series.

To fix [B] and [C], the vCPU's PMCR_EL0.N and ID_AA64DFR0_EL1.PMUVer
will be set based on the host's PMU (kvm->arch.arm_pmu->pmuver) by
default in this series.  When the PMU is changed for the guest using
KVM_ARM_VCPU_PMU_V3_SET_PMU, those are reset to the new PMU's values.
See patch 2, 3, and 9 for more details.

The series is based on v6.2-rc7.

Patch 1 add a helper to set a PMU for the guest. This helper will
make it easier for the following patches to add modify codes
for that process.

Patch 2 make the default PMU for the guest set on the first
vCPU reset.

Patch 3 and 4 fixes the issue [B] and [A], respectively.

Patch 5 fixes reset_pmu_reg() to ensure that (RAZ) bits of
PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero.

Patch 6 is a minor refactoring to use the default PMU register reset
function for PMUSERENR_EL0 and PMCCFILTR_EL0.

Patch 7 simplifies the existing code that extracts PMCR_EL0.N by
using FIELD_GET().

Patch 8 add a helper to read vCPU's PMCR_EL0.

Patch 9 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N. This patch fixes the issue [C].

Patch 10 adds support userspace modifying PMCR_EL0.N.

Patch 11-14 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

v4:
 - Fix the selftest bug in patch 13 (Have test_access_pmc_regs() to
   specify pmc index for test_bitmap_pmu_regs() instead of bit-shifted
   value (Thank you Raghavendra for the reporting the issue!).

v3: https://lore.kernel.org/all/20230203040242.1792453-1-reijiw@google.com/
 - Remove reset_pmu_reg(), and use reset_val() instead. [Marc]
 - Fixed the initial value of PMCR_EL0.N on heterogeneous
   PMU systems. [Oliver]
 - Fixed PMUVer issues on heterogeneous PMU systems.
 - Fixed typos [Shaoqin]

v2: https://lore.kernel.org/all/20230117013542.371944-1-reijiw@google.com/
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1: https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Reiji Watanabe (14):
  KVM: arm64: PMU: Introduce a helper to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
  KVM: arm64: PMU: Don't use the sanitized value for PMUVer
  KVM: arm64: PMU: Don't use the PMUVer of the PMU set for the guest
  KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} on vCPU
    reset
  KVM: arm64: PMU: Don't define the sysreg reset() for
    PM{USERENR,CCFILTR}_EL0
  KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  tools: arm64: Import perf_event.h
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   7 +
 arch/arm64/include/asm/perf_event.h           |   2 +-
 arch/arm64/kernel/perf_event.c                |   3 +-
 arch/arm64/kvm/arm.c                          |   9 +-
 arch/arm64/kvm/pmu-emul.c                     |  81 ++-
 arch/arm64/kvm/reset.c                        |  21 +-
 arch/arm64/kvm/sys_regs.c                     | 133 ++--
 include/kvm/arm_pmu.h                         |  13 +-
 tools/arch/arm64/include/asm/perf_event.h     | 258 +++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 642 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 12 files changed, 1082 insertions(+), 89 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/perf_event.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
-- 
2.39.1.581.gbfd45094c4-goog

