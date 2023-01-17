Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FDD15A0
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 01:35:56 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-434eb7c6fa5so316615827b3.14
        for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 17:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cXMIKYVp+c4Sa+jsYUUChNh+35aTl0TzPBaHrVahGAc=;
        b=Kvh4CvJ7GmN8kUkSghBYRl1ZQpcu4BzNDkpekiOpL3Zi+TsoDhh+x1YNSfTPW+lM6/
         a2STHKxc+7l/h1aTCW0YLE+CCa4OqbXw5elBqpZbB3vnBHGCszGi7hVFHEgVB0ky8OTU
         YAUBENoYICZpoO+Qs9Sm0k68XDt3eu8P7dV/2oodRpbCcKOeYbs0O8iXfS411dCEFjql
         o7f8Uj3GdThd4dD+zxmYyezMDFpiaDmfaLn3QLaws7T9xWn2B6zDvgzM3pT7IEhSvXc0
         Wbzq4s+4Y/ouGD/QXbo6/wgaklLZIaBBe91DnYNmMCvH6MCn3Mi+FPpDLcOKYsC5601/
         xtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXMIKYVp+c4Sa+jsYUUChNh+35aTl0TzPBaHrVahGAc=;
        b=BMViAiBXLGrACEHmi0f0YCObS67NHDiW2v1t8nIlwKk5kBDBNQbSnMdfjBlZ0E8pBb
         KIoBjb7r2jF5SDMv7c2g6xAuWWbo0hUFxFGyfHYvB7zOWOaNQOU5rFA/B1EqwwSb5SpH
         oNagVymtXvx2OFtHRfWl+BG+lpQ9a3TEPTv7ZI5V3ExU7vH/syFOO/v1VOLr4g8/bG4B
         VRN7/rnbbW6mty4s91C4/JIB+N2/MrKF5ivEcWw8LmJ/aFJB7s1oa9ItKaRm3hhn+aeE
         8/QLeMo2dpy6ActsXXIeXnftSMHGq87sW/VDwdaWLlJHQFJCtMY7wOpOyM2uBZzq6xlZ
         Zn6w==
X-Gm-Message-State: AFqh2krEAR7QFHH37Vn90rJY6XmKG6W5213Uh+U/K8trKEbTZ/vwPF/Y
	XB8bh4kVCLVhikDEvDHE+K+fR3hYtjg=
X-Google-Smtp-Source: AMrXdXuMkKUdTI8/EmoeRlROPqs4UPn1FtCKXJ+AbfVWp3HQ3sK8ZayDheDbCUEAVC0xjpf5YT/8oPb05YI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:7408:0:b0:3cc:8ab:be2c with SMTP id
 p8-20020a817408000000b003cc08abbe2cmr182266ywc.205.1673919356032; Mon, 16 Jan
 2023 17:35:56 -0800 (PST)
Date: Mon, 16 Jan 2023 17:35:34 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-1-reijiw@google.com>
Subject: [PATCH v2 0/8] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

The goal of this series is to allow userspace to limit the number
of PMU event counters on the vCPU. We need this to support migration
across systems that implement different numbers of counters.

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

Patch 4 adds the sys_reg's set_user() handler for the PMCR_EL0
to disallow userspace to set PMCR_EL0.N for the vCPU to a value
that is greater than the host value.

Patch 5-8 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

The series is based on v6.2-rc4.

v2:
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1: https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Reiji Watanabe (8):
  KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
  KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0 and
    PMCCFILTR_EL0
  KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
  KVM: arm64: PMU: Disallow userspace to set PMCR.N greater than the
    host value
  tools: arm64: Import perf_event.h
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/kvm/pmu-emul.c                     |   6 +
 arch/arm64/kvm/sys_regs.c                     |  57 +-
 tools/arch/arm64/include/asm/perf_event.h     | 258 +++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 644 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 6 files changed, 954 insertions(+), 13 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/perf_event.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0.314.g84b9a713c41-goog

