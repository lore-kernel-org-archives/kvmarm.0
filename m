From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 0/2] KVM/ARM Fixes for 3.20
Date: Sun, 15 Feb 2015 21:22:41 +0100
Message-ID: <1424031763-9534-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

The following changes since commit bfa76d49576599a4b9f9b7a71f23d73d6dcff735:

  Linux 3.19 (2015-02-08 18:54:22 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-3.20

for you to fetch changes up to 42e387ed20c012e37e60535bdbe809e65ce1559b:

  arm/arm64: KVM: Add exit reaons to kvm_exit event tracing (2015-02-15 17:12:27 +0100)

Thanks,
-Christoffer

----------------------------------------------------------------
First round of KVM/ARM fixes for 3.20 (or what it will be called).

Fixes a VM_BUG_ON error check and adds exit reasons to tracing.

----------------------------------------------------------------
Jan Kiszka (1):
      ARM: KVM: Fix size check in __coherent_cache_guest_page

Wei Huang (1):
      arm/arm64: KVM: Add exit reaons to kvm_exit event tracing

 arch/arm/include/asm/kvm_mmu.h |  2 +-
 arch/arm/kvm/arm.c             |  2 +-
 arch/arm/kvm/trace.h           | 10 +++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)
