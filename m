Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16CEC2D0D4
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 14:30:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B09DC24689
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 14:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B09DC24689
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A28D4A3A3;
	Fri, 20 Dec 2019 09:30:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9pt4iHzsrKnj; Fri, 20 Dec 2019 09:30:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA8A4A98A;
	Fri, 20 Dec 2019 09:30:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 197454A531
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 09:30:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jqBJqpCayxJY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 09:30:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F784A3A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 09:30:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 648A130E;
 Fri, 20 Dec 2019 06:30:32 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8ABF43F718;
 Fri, 20 Dec 2019 06:30:30 -0800 (PST)
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
Date: Fri, 20 Dec 2019 14:30:07 +0000
Message-Id: <20191220143025.33853-1-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
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

This series implements support for allowing KVM guests to use the Arm
Statistical Profiling Extension (SPE).

It has been tested on a model to ensure that both host and guest can
simultaneously use SPE with valid data. E.g.

$ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
        dd if=/dev/zero of=/dev/null count=1000
$ perf report --dump-raw-trace > spe_buf.txt

As we save and restore the SPE context, the guest can access the SPE
registers directly, thus in this version of the series we remove the
trapping and emulation.

In the previous series of this support, when KVM SPE isn't supported
(e.g. via CONFIG_KVM_ARM_SPE) we were able to return a value of 0 to
all reads of the SPE registers - as we can no longer do this there isn't
a mechanism to prevent the guest from using SPE - thus I'm keen for
feedback on the best way of resolving this.

It appears necessary to pin the entire guest memory in order to provide
guest SPE access - otherwise it is possible for the guest to receive
Stage-2 faults.

The last two extra patches are for the kvmtool if someone wants to play
with it.

Changes since v2:
	- Rebased on v5.5-rc2
	- Renamed kvm_spe structure 'irq' member to 'irq_num'
	- Added irq_level to kvm_spe structure
	- Clear PMBSR service bit on save to avoid spurious interrupts
	- Update kvmtool headers to 5.4
	- Enabled SPE in KVM init features
	- No longer trap and emulate
	- Add support for guest/host exclusion flags
	- Fix virq support for SPE
	- Adjusted sysreg_elx_s macros with merged clang build support

Andrew Murray (4):
  KVM: arm64: don't trap Statistical Profiling controls to EL2
  perf: arm_spe: Add KVM structure for obtaining IRQ info
  KVM: arm64: spe: Provide guest virtual interrupts for SPE
  perf: arm_spe: Handle guest/host exclusion flags

Sudeep Holla (12):
  dt-bindings: ARM SPE: highlight the need for PPI partitions on
    heterogeneous systems
  arm64: KVM: reset E2PB correctly in MDCR_EL2 when exiting the
    guest(VHE)
  arm64: KVM: define SPE data structure for each vcpu
  arm64: KVM: add SPE system registers to sys_reg_descs
  arm64: KVM/VHE: enable the use PMSCR_EL12 on VHE systems
  arm64: KVM: split debug save restore across vm/traps activation
  arm64: KVM/debug: drop pmscr_el1 and use sys_regs[PMSCR_EL1] in
    kvm_cpu_context
  arm64: KVM: add support to save/restore SPE profiling buffer controls
  arm64: KVM: enable conditional save/restore full SPE profiling buffer
    controls
  arm64: KVM/debug: use EL1&0 stage 1 translation regime
  KVM: arm64: add a new vcpu device control group for SPEv1
  KVM: arm64: enable SPE support
  KVMTOOL: update_headers: Sync kvm UAPI headers with linux v5.5-rc2
  KVMTOOL: kvm: add a vcpu feature for SPEv1 support

 .../devicetree/bindings/arm/spe-pmu.txt       |   5 +-
 Documentation/virt/kvm/devices/vcpu.txt       |  28 +++
 arch/arm64/include/asm/kvm_host.h             |  18 +-
 arch/arm64/include/asm/kvm_hyp.h              |   6 +-
 arch/arm64/include/asm/sysreg.h               |   1 +
 arch/arm64/include/uapi/asm/kvm.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   7 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/debug.c                        |   2 -
 arch/arm64/kvm/guest.c                        |   6 +
 arch/arm64/kvm/hyp/debug-sr.c                 | 105 +++++---
 arch/arm64/kvm/hyp/switch.c                   |  18 +-
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     |  11 +
 drivers/perf/arm_spe_pmu.c                    |  26 ++
 include/kvm/arm_spe.h                         |  82 ++++++
 include/uapi/linux/kvm.h                      |   1 +
 virt/kvm/arm/arm.c                            |  10 +-
 virt/kvm/arm/spe.c                            | 234 ++++++++++++++++++
 19 files changed, 521 insertions(+), 47 deletions(-)
 create mode 100644 include/kvm/arm_spe.h
 create mode 100644 virt/kvm/arm/spe.c

-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
