From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL] KVM/ARM updates for 4.9-rc6
Date: Fri, 18 Nov 2016 09:39:24 +0000
Message-ID: <1479461966-20136-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Wei Huang <wei@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Please find below the pull request for a couple of fixes for the
PMU emulation, courtesy of Wei. Both patches are candidates for stable.

Thanks,

	M.

The following changes since commit d42c79701a3ee5c38fbbc82f98a140420bd40134:

  KVM: arm/arm64: vgic: Kick VCPUs when queueing already pending IRQs (2016-11-04 17:56:56 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.9-rc6

for you to fetch changes up to b112c84a6ff035271d41d548c10215f18443d6a6:

  KVM: arm64: Fix the issues when guest PMCCFILTR is configured (2016-11-18 09:06:58 +0000)

----------------------------------------------------------------
KVM/ARM updates for v4.9-rc6

- Fix handling of the 32bit cycle counter
- Fix cycle counter filtering

----------------------------------------------------------------
Wei Huang (2):
      arm64: KVM: pmu: Fix AArch32 cycle counter access
      KVM: arm64: Fix the issues when guest PMCCFILTR is configured

 arch/arm64/include/asm/perf_event.h | 10 +++++++++-
 arch/arm64/kernel/perf_event.c      | 10 +---------
 arch/arm64/kvm/sys_regs.c           | 10 ++++++++--
 virt/kvm/arm/pmu.c                  |  8 +++++---
 4 files changed, 23 insertions(+), 15 deletions(-)
