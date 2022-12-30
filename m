Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907721C04
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 03:59:43 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id h66-20020a252145000000b0071a7340eea9so21200432ybh.6
        for <kvmarm@lists.linux.dev>; Thu, 29 Dec 2022 19:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B1xLwV78lCPmkgrGGinUUY3Xt3pN3bRW29JV1F7l2Tw=;
        b=DnXWG7VxhEDPodtoEqB7yGUoaAkDziJd/CtJ8hDKcKT4+9g0XaRACjdRbHwexe9eSH
         nfHZOJ4vMHoYfZdbPEoY+kV/xz+zW9WHcd+T334M72Ge5hyBKvMy98o+LZ7xn2TIi+z9
         H0Sbg6CC2jFAvRmRDf/XK3YXRDCgG0c6k1/y4C1Zv076kqKD87LN4UqPApqBj8ybRyJ4
         hvXHMXi0tTbbskTlCu1YO9OiogFNKnC2vqXp5wjNqKZb4pP8Z/QAmYa2ptkj8NWCqqZr
         IfU3xmhLcdNJ5kWLCyE3A5KYrm5sXmwYDyu6f2PK1LCyXRoFjUWaknritGGi7KEVJNwc
         7PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B1xLwV78lCPmkgrGGinUUY3Xt3pN3bRW29JV1F7l2Tw=;
        b=SuhGIll4sFHQ334vjLB4aes+UUSJdaidUornAA8MIGtgXLKnA/AOLerttL2brkExqP
         2b/mwEv+GSFcTjtEiL/Jv63mNmR7GoCd7S/Gj7XPBUcIfc2jrAaLEM/CdOIVRyu5xxl3
         tf+uwb8NHcc706G2t/fdJrpuoIIAm3T3vrdlQC7/tgBN31Ww5GTBB3tb3TG60dQ53om+
         ij+nFaQ568hh7zAVcARm4qKc5Koh0Kxs0XUC603Pi+u0czOpK+ubSTJH3r/W7NyZJ9Vy
         ht8fHEo4Ahht0g83IuwYVqXFGoapAWoIoo8I1UwpP0El1ngVJiGL0OpWHi9sk56RVJ/J
         92pg==
X-Gm-Message-State: AFqh2krYOEJC8yHCpW+oVwuLmsBrQHd/LTncMmR6B9oVVHsBCf4Wx89i
	QOJprPSkx/mLtZm59Q7hIsfm8vArk2U=
X-Google-Smtp-Source: AMrXdXtrSTPSyHUSN0bUEcQslEgn9v/hGErQUCNKveYX1t5cCH2abCenP1S6iHraLmq8WQIDxFx7SB5vYgU=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8012:0:b0:777:ee99:e98d with SMTP id
 m18-20020a258012000000b00777ee99e98dmr1661825ybk.597.1672372782523; Thu, 29
 Dec 2022 19:59:42 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:21 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-1-reijiw@google.com>
Subject: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number of
 PMCs on vCPU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221230035921.uNo6PxNju0jI5GbW-ddo3T-U4cwwVUPeHCQ1qxzLZkg@z>

The goal of this series is to allow userspace to limit the number
of PMU event counters on the vCPU.

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the host value by default. Userspace can set PMCR_EL0.N for the
vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
However, it is practically unsupported, as KVM resets PMCR_EL0.N
to the host value on vCPU reset and some KVM code uses the host
value to identify (un)implemented event counters on the vCPU.

This series will ensure that the PMCR_EL0.N value is preserved
on vCPU reset and that KVM doesn't use the host value
to identify (un)implemented event counters on the vCPU.
This allows userspace to limit the number of the PMU event
counters on the vCPU.

Patch 1 fixes reset_pmu_reg() to ensure that (RAZ) bits of
{PMCNTEN,PMOVS}{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero even when PMCR_EL0.N for
the vCPU is different from the host.

Patch 2 is a minor refactoring to use the default PMU register reset
function (reset_pmu_reg()) for PMUSERENR_EL0 and PMCCFILTR_EL0.
(With the Patch 1 change, reset_pmu_reg() can now be used for
those registers)

Patch 3 fixes reset_pmcr() to preserve PMCR_EL0.N for the vCPU on
vCPU reset.

Patch 4-7 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

The series is based on kvmarm/fixes at the following commit:
  commit aff234839f8b ("KVM: arm64: PMU: Fix PMCR_EL0 reset value")

Reiji Watanabe (7):
  KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
  KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0 and
    PMCCFILTR_EL0
  KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
  tools: arm64: Import perf_event.h
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/kvm/pmu-emul.c                     |   6 +
 arch/arm64/kvm/sys_regs.c                     |  18 +-
 tools/arch/arm64/include/asm/perf_event.h     | 258 ++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 613 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 7 files changed, 886 insertions(+), 12 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/perf_event.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: aff234839f8b80ac101e6c2f14d0e44b236efa48
-- 
2.39.0.314.g84b9a713c41-goog

