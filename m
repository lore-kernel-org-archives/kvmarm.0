Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5079A4E
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:12 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d86dac81f8fso8577387276.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771611; x=1696376411; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DBZz03nR6vXHP7+mhK+zZem9sUDVZQM80l4Hk2l9+oM=;
        b=wOjB4alEOMDNO8XSl0b1qd9Sq/oa2NbCLj02t7Ul5OPWVJhmLTj3CmRIvhwbYIzJDx
         zgmx8LTqHcwoiV17KSAo+O1A0kG5GOUBJekW5KZek/b9e/UIISNiGIFKyFa2U+1WgDGH
         AnSwNhhlinxRKU0Cm/NcDQCiywm+nQNZlC9AaRRAkRvRnwcM3gZGR8NtrglS/FZRDsTE
         eKWfbEFHylJIYC8myC2cR1ST0hFFveTnDdwRjdiNn1pAOrrIzmtlMrKoS2TV+b13bBfZ
         HdriGWKifv/UX4HdLIhTut/QuTw4Xd+bbeNPJ8s+T94HyNt8FPLMWIQ9m4mKtAKwMcWd
         o9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771611; x=1696376411;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DBZz03nR6vXHP7+mhK+zZem9sUDVZQM80l4Hk2l9+oM=;
        b=OCMaN/xzcYFMUa2LV/RAfFkSV40MShrOCN2Vs+9Y5zjfCHez3pOdQil6fsZVj/dgCW
         hK11cx189anJ+X5Hq1TqpUHzA5g3QHAkfOjrrwA+Q7RrbiTV/J/dF3h2a4sEzjCdMrrN
         sVLcS3x5IrndmywFGOWI1MNPYuKSLik/0eejVjK7rK0B2wAa8MTxKF1xXOOIySBSXo8N
         3+4DnBUp3AadcVdxDnip2+r/9YlqeRe4DJ/hOwXaCr0MjO+bL5TlPkC1hYOKZ/sv+cJ1
         tjXg+FcOHq/wp4eOHp3nRoeVfImflss5JYWkT/w8QKIOy/TKO1T9252Oa9lHfqUhAqDr
         09/Q==
X-Gm-Message-State: AOJu0Ywjmw03cyae+WlccSJl3oED3KLoEr3fD6hSeRYhukW414nymQkH
	x0YjDekE8zcscMFok1FSuIzveFtZodyM
X-Google-Smtp-Source: AGHT+IH+SqAHAb/x2o7VLSGDQEey3HjL5K5XEMJ7sW/4mrbG9+wfDWdp+8z1rmq6Ubznn1Ur71amL8i04drG
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:541:b0:d0c:c83b:94ed with SMTP id
 z1-20020a056902054100b00d0cc83b94edmr4524ybs.10.1695771611520; Tue, 26 Sep
 2023 16:40:11 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:39:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-1-rananta@google.com>
Subject: [PATCH v6 00/11] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

With permission from Reiji Watanabe <reijiw@google.com>, the original
author of the series, I'm posting the v6 with necessary alterations.

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

The series is based on v6.6-rc3.

Patch 1 adds helper functions to set a PMU for the guest. This
helper will make it easier for the following patches to add
modify codes for that process.

Patch 2 makes the default PMU for the guest set on the first
vCPU reset.

Patch 3 fixes reset_pmu_reg() to ensure that (RAZ) bits of
PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero.

Patch 4 is a minor refactoring to use the default PMU register reset
function for PMUSERENR_EL0 and PMCCFILTR_EL0.

Patch 5 adds a helper to read vCPU's PMCR_EL0.

Patch 6 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N.

Patch 7 adds support userspace modifying PMCR_EL0.N.

Patch 8-11 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

v6: Thanks, Oliver and Shaoqin for the suggestions
- Split the previously defined kvm_arm_set_vm_pmu() into separate
  functions: default arm_pmu and a caller requested arm_pmu.
- Send -EINVAL from kvm_reset_vcpu(), instead of -ENODEV for the
  case where KVM fails to set a default arm_pmu, to remain consistent
  with the existing behavior.
- Drop the v5 patch-5/12 that removes ARMV8_PMU_PMCR_N_MASK and adds
  ARMV8_PMU_PMCR_N. Make corresponding changes to v5 patch-6/12.
- Disregard introducing 'pmcr_n_limit' in kvm->arch as a member to
  be accessed later in 'set_pmcr()'. Instead, directly obtain the
  value by accessing the saved 'arm_pmu'.
- 'set_pmcr()' ignores the error when userspace tries to set PMCR.N
  greater than the hardware limit to keep the existing API behavior.
- 'set_pmcr()' ignores modifications to the register after the VM has
  started and returns a success to userspace.
- Introduce [get|set]_pmcr_n() helpers in the selftest to make
  modifications to the field easier.
- Define the 'vpmu_vm' globally in the selftest, instead of allocating
  it every time a VM is created.
- Use the new printf style __GUEST_ASSERT()s in the selftest. 

v5:
https://lore.kernel.org/all/20230817003029.3073210-1-rananta@google.com/
 - Drop the patches (v4 3,4) related to PMU version fixes as it's
   now being handled in a separate series [1].
 - Switch to config_lock, instead of kvm->lock, while configuring
   the guest PMU.
 - Instead of continuing after a WARN_ON() for the return value of
   kvm_arm_set_vm_pmu() in kvm_arm_pmu_v3_set_pmu(), patch-1 now
   returns from the function immediately with the error code.
 - Fix WARN_ON() logic in kvm_host_pmu_init() (patch v4 9/14).
 - Instead of returning 0, return -ENODEV from the
   kvm_arm_set_vm_pmu() stub function.
 - Do not define the PMEVN_CASE() and PMEVN_SWITCH() macros in
   the selftest code as they are now included in the imported
   arm_pmuv3.h header.
 - Since the (initial) purpose of the selftest is to test the
   accessibility of the counter registers, remove the functional
   test at the end of test_access_pmc_regs(). It'll be added
   later in a separate series.
 - Introduce additional helper functions (destroy_vpmu_vm(),
   PMC_ACC_TO_IDX()) in the selftest for ease of maintenance
   and debugging.
   
v4:
https://lore.kernel.org/all/20230211031506.4159098-1-reijiw@google.com/
 - Fix the selftest bug in patch 13 (Have test_access_pmc_regs() to
   specify pmc index for test_bitmap_pmu_regs() instead of bit-shifted
   value (Thank you Raghavendra for the reporting the issue!).

v3:
https://lore.kernel.org/all/20230203040242.1792453-1-reijiw@google.com/
 - Remove reset_pmu_reg(), and use reset_val() instead. [Marc]
 - Fixed the initial value of PMCR_EL0.N on heterogeneous
   PMU systems. [Oliver]
 - Fixed PMUVer issues on heterogeneous PMU systems.
 - Fixed typos [Shaoqin]

v2:
https://lore.kernel.org/all/20230117013542.371944-1-reijiw@google.com/
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1:
https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Thank you.
Raghavendra

[1]:
https://lore.kernel.org/all/20230728181907.1759513-1-reijiw@google.com/

Raghavendra Rao Ananta (1):
  tools: Import arm_pmuv3.h

Reiji Watanabe (10):
  KVM: arm64: PMU: Introduce helpers to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
  KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} on vCPU
    reset
  KVM: arm64: PMU: Don't define the sysreg reset() for
    PM{USERENR,CCFILTR}_EL0
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/arm.c                          |   3 +-
 arch/arm64/kvm/pmu-emul.c                     |  91 ++-
 arch/arm64/kvm/reset.c                        |  18 +-
 arch/arm64/kvm/sys_regs.c                     | 102 ++-
 include/kvm/arm_pmu.h                         |  12 +
 tools/include/perf/arm_pmuv3.h                | 308 +++++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 590 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 10 files changed, 1064 insertions(+), 65 deletions(-)
 create mode 100644 tools/include/perf/arm_pmuv3.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.582.g8ccd20d70d-goog

