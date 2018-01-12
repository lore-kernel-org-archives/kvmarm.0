From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/2] KVM/ARM Fixes for v4.15 - Round 3
Date: Fri, 12 Jan 2018 13:33:32 +0100
Message-ID: <20180112123334.28687-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

This is the third round of fixes for KVM/ARM for v4.15, including two more
fixes for v4.15 fixing incorrect huge page mappings on systems using the
contiguous hint for hugetlbfs and supporting an alternative GICv4 init
sequence.

The following changes since commit 0eb7c33cadf6b2f1a94e58ded8b0eb89b4eba382:

  KVM: arm/arm64: Fix timer enable flow (2017-12-18 10:53:24 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.15-3

for you to fetch changes up to f8f85dc00b7427de6222ea3955c52512315d13cd:

  KVM: arm64: Fix GICv4 init when called from vgic_its_create (2018-01-12 11:40:21 +0100)

Thanks,
-Christoffer

Christoffer Dall (1):
      KVM: arm64: Fix GICv4 init when called from vgic_its_create

Punit Agrawal (1):
      KVM: arm/arm64: Check pagesize when allocating a hugepage at Stage 2

 virt/kvm/arm/mmu.c            | 2 +-
 virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
 virt/kvm/arm/vgic/vgic-v4.c   | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)
