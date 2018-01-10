From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC 0/4] KVM: Support PUD hugepages at stage 2
Date: Wed, 10 Jan 2018 19:07:25 +0000
Message-ID: <20180110190729.18383-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This patchset adds support for PUD hugepages at stage 2. This feature
is useful on cores that have support for large sized TLB mappings
(e.g., 1GB for 4K granule).

The patchset is based on v4.15-rc7 and depends on a fix sent out
earlier[0]. There patchset will conflict with Suzuki's work to
dynamically set IPA size. I'll work with Suzuki to resolve this
depending on the order the features are merged.

The patches have been functionally tested on an A57 based system. To
quantify the benefit, the patches need to be evaluated on cores
supporting larger sized TLB mappings.

I'm sending the patchset as RFC to get feedback on the code as well as
allow evaluation on real systems.

Thanks,
Punit

[0] https://patchwork.kernel.org/patch/10145339/

Punit Agrawal (4):
  arm64: Correct type for PUD macros
  KVM: arm64: Support dirty page tracking for PUD hugepages
  KVM: arm/arm64: Refactor Stage2 PMD hugepages support
  KVM: arm64: Add support for PUD hugepages at stage 2

 arch/arm/include/asm/kvm_mmu.h         | 19 +++++++
 arch/arm/include/asm/pgtable-3level.h  |  2 +
 arch/arm64/include/asm/kvm_mmu.h       | 29 +++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h |  8 +--
 arch/arm64/include/asm/pgtable.h       |  4 ++
 virt/kvm/arm/mmu.c                     | 91 +++++++++++++++++++++++++++++-----
 6 files changed, 137 insertions(+), 16 deletions(-)

-- 
2.15.1
