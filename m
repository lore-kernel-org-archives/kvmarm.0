From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 0/2] KVM: Fix refaulting due to page table update
Date: Mon, 13 Aug 2018 11:43:49 +0100
Message-ID: <20180813104351.24595-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, marc.zyngier@arm.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Contention when updating a page table entry can lead to unnecessary
refaults. The issue was reported by a user when testing PUD hugepage
support[1] but also exists for PMD and PTE updates though with a lower
probability.

This version -

* fixes a nit reported by Suzuki
* Re-orders the checks when setting PMD hugepage
* drops mistakenly introduced Change-id in the commit message

Thanks,
Punit

[1] https://lkml.org/lkml/2018/7/16/482

Punit Agrawal (2):
  KVM: arm/arm64: Skip updating PMD entry if no change
  KVM: arm/arm64: Skip updating PTE entry if no change

 virt/kvm/arm/mmu.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

-- 
2.18.0
