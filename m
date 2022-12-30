Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A651DC3DA7C
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 03:59:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1916D4B652;
	Thu, 29 Dec 2022 22:59:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d74UwoSgTILD; Thu, 29 Dec 2022 22:59:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE4E4B641;
	Thu, 29 Dec 2022 22:59:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23A6F4B641
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 22:59:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7h2QkbFQjGbH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2022 22:59:43 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A0C04B63D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 22:59:42 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 t13-20020a056902018d00b0074747131938so21427216ybh.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 19:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=YtG01C54pr5HBzjQ6TICmpKcQbsEbQC+iwG4Tp7BDT9vvYQsYIorJjDKpNpfnFds+1
 rlPP9VhdO7WBdIzT36XBsTImR4nih3NF6p4kafM4xyi4Xl2o2ittJrRYKAQP9iwAZ3t+
 MfrFnZ6hkeEyNC1vJjsjWU9Rz2hUBW7lMULkwg4XyUXfuZ/MpInxYKT9y3fH5htVbOEr
 gu3wnspqCnHj5KTaSmP9i+pxSStTBDzB9U1Nqz1uc7q5coFXEpH7XoyJ1M+WS8JVE8xR
 OTupH4ioiYmssS1uwoIldGs+g3hh1Xbi1e2HWI87qp3MDLQBgDFUw0UJGqS4D0SH5M48
 okTA==
X-Gm-Message-State: AFqh2kqN+TQ7jIz+QesHzkAffSeDmSjtbq0tZk3YRfoD4GyJnDFA+g+Z
 PJbWtaLtWp+5yIXyDwsJv7pITKRGYu0=
X-Google-Smtp-Source: AMrXdXtrSTPSyHUSN0bUEcQslEgn9v/hGErQUCNKveYX1t5cCH2abCenP1S6iHraLmq8WQIDxFx7SB5vYgU=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8012:0:b0:777:ee99:e98d with SMTP id
 m18-20020a258012000000b00777ee99e98dmr1661825ybk.597.1672372782523; Thu, 29
 Dec 2022 19:59:42 -0800 (PST)
Date: Thu, 29 Dec 2022 19:59:21 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-1-reijiw@google.com>
Subject: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number of
 PMCs on vCPU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
