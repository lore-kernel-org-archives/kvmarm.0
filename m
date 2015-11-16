From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] arm64: KVM: Fixes for 4.4-rc2
Date: Mon, 16 Nov 2015 10:28:16 +0000
Message-ID: <1447669698-15939-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Here's a couple of fixes for KVM/arm64:

- The first one addresses a misinterpretation of the architecture
  spec, leading to the mishandling of I/O accesses generated from an
  AArch32 guest using banked registers.

- The second one is a workaround for a Cortex-A57 erratum.

Both patches are based on v4.4-rc1.

Marc Zyngier (2):
  arm64: KVM: Fix AArch32 to AArch64 register mapping
  arm64: KVM: Add workaround for Cortex-A57 erratum 834220

 arch/arm64/Kconfig                   | 21 +++++++++++++++++++++
 arch/arm64/include/asm/cpufeature.h  |  3 ++-
 arch/arm64/include/asm/kvm_emulate.h |  8 +++++---
 arch/arm64/kernel/cpu_errata.c       |  9 +++++++++
 arch/arm64/kvm/hyp.S                 |  6 ++++++
 arch/arm64/kvm/inject_fault.c        |  2 +-
 6 files changed, 44 insertions(+), 5 deletions(-)

-- 
2.1.4

