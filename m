Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A856C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D141823341
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D141823341
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B624B3D3;
	Thu,  7 Jan 2021 06:21:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dtE3V0Xhyw3m; Thu,  7 Jan 2021 06:21:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1E234B3C7;
	Thu,  7 Jan 2021 06:21:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7604B3BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FPPqTgJTjm12 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:21:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69C0E4B3BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E3407221E9;
 Thu,  7 Jan 2021 11:21:17 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTLv-005p1o-Sg; Thu, 07 Jan 2021 11:21:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
Date: Thu,  7 Jan 2021 11:20:43 +0000
Message-Id: <20210107112101.2297944-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com,
 shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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

Hi Paolo,

Happy New Year!

Here's a first set of fixes for 5.11, most of which are just
cleanups. I may have some more meaty stuff next week, but let's ease
back into it as gently as possible...

Please pull,

	M.

The following changes since commit 3a514592b698588326924625b6948a10c35fadd5:

  Merge remote-tracking branch 'origin/kvm-arm64/psci-relay' into kvmarm-master/next (2020-12-09 10:00:24 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-1

for you to fetch changes up to 45ba7b195a369f35cb39094fdb32efe5908b34ad:

  arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST (2021-01-05 13:22:07 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.11, take #1

- VM init cleanups
- PSCI relay cleanups
- Kill CONFIG_KVM_ARM_PMU
- Fixup __init annotations
- Fixup reg_to_encoding()
- Fix spurious PMCR_EL0 access

----------------------------------------------------------------
Alexandru Elisei (5):
      KVM: Documentation: Add arm64 KVM_RUN error codes
      KVM: arm64: arch_timer: Remove VGIC initialization check
      KVM: arm64: Move double-checked lock to kvm_vgic_map_resources()
      KVM: arm64: Update comment in kvm_vgic_map_resources()
      KVM: arm64: Remove redundant call to kvm_pmu_vcpu_reset()

David Brazdil (6):
      KVM: arm64: Prevent use of invalid PSCI v0.1 function IDs
      KVM: arm64: Use lm_alias in nVHE-only VA conversion
      KVM: arm64: Skip computing hyp VA layout for VHE
      KVM: arm64: Minor cleanup of hyp variables used in host
      KVM: arm64: Remove unused includes in psci-relay.c
      KVM: arm64: Move skip_host_instruction to adjust_pc.h

Marc Zyngier (6):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available
      KVM: arm64: Declutter host PSCI 0.1 handling
      KVM: arm64: Consolidate dist->ready setting into kvm_vgic_map_resources()
      KVM: arm64: Fix hyp_cpu_pm_{init,exit} __init annotation
      KVM: arm64: Remove spurious semicolon in reg_to_encoding()
      KVM: arm64: Replace KVM_ARM_PMU with HW_PERF_EVENTS

Shannon Zhao (1):
      arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST

 Documentation/virt/kvm/api.rst             |  9 ++++-
 arch/arm64/include/asm/kvm_host.h          | 23 ++++++++++++
 arch/arm64/kernel/cpufeature.c             |  2 +-
 arch/arm64/kernel/smp.c                    |  2 +-
 arch/arm64/kvm/Kconfig                     |  8 ----
 arch/arm64/kvm/Makefile                    |  2 +-
 arch/arm64/kvm/arch_timer.c                |  7 ++--
 arch/arm64/kvm/arm.c                       | 32 +++++++++-------
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  9 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 12 +-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c          |  6 +--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c       | 59 +++++++++++-------------------
 arch/arm64/kvm/pmu-emul.c                  |  2 -
 arch/arm64/kvm/sys_regs.c                  |  6 ++-
 arch/arm64/kvm/va_layout.c                 |  7 ++--
 arch/arm64/kvm/vgic/vgic-init.c            | 11 +++++-
 arch/arm64/kvm/vgic/vgic-v2.c              | 20 +++-------
 arch/arm64/kvm/vgic/vgic-v3.c              | 21 +++--------
 include/kvm/arm_pmu.h                      |  2 +-
 19 files changed, 122 insertions(+), 118 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
