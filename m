From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PULL 0/3] KVM/ARM updates for v4.9-rc4
Date: Fri,  4 Nov 2016 18:36:35 +0000
Message-ID: <20161104183638.28137-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Please find below the KVM/ARM updates for v4.9-rc4 (or later if we've
already missed the boat).

Thanks,

	M.

The following changes since commit 07d9a380680d1c0eb51ef87ff2eab5c994949e69:

  Linux 4.9-rc2 (2016-10-23 17:10:14 -0700)

are available in the git repository at:

  git://git.kernel.org:/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.9-rc4

for you to fetch changes up to d42c79701a3ee5c38fbbc82f98a140420bd40134:

  KVM: arm/arm64: vgic: Kick VCPUs when queueing already pending IRQs (2016-11-04 17:56:56 +0000)

----------------------------------------------------------------
KVM/ARM updates for v4.9-rc4

- Kick the vcpu when a pending interrupt becomes pending again
- Prevent access to invalid interrupt registers
- Invalid TLBs when two vcpus from the same VM share a CPU

----------------------------------------------------------------
Andre Przywara (1):
      KVM: arm/arm64: vgic: Prevent access to invalid SPIs

Marc Zyngier (1):
      arm/arm64: KVM: Perform local TLB invalidation when multiplexing vcpus on a single CPU

Shih-Wei Li (1):
      KVM: arm/arm64: vgic: Kick VCPUs when queueing already pending IRQs

 arch/arm/include/asm/kvm_asm.h    |  1 +
 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm/include/asm/kvm_hyp.h    |  1 +
 arch/arm/kvm/arm.c                | 27 +++++++++++++++++++++++++-
 arch/arm/kvm/hyp/tlb.c            | 15 ++++++++++++++
 arch/arm64/include/asm/kvm_asm.h  |  1 +
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/include/asm/kvm_mmu.h  |  2 +-
 arch/arm64/kvm/hyp/tlb.c          | 15 ++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c     | 41 ++++++++++++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic-mmio.h     | 14 ++++++-------
 virt/kvm/arm/vgic/vgic.c          | 12 ++++++++++++
 12 files changed, 112 insertions(+), 23 deletions(-)
