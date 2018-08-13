From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v2 0/2] KVM: Fix refaulting due to page table update
Date: Mon, 13 Aug 2018 10:40:47 +0100
Message-ID: <20180813094049.3726-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, marc.zyngier@arm.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Here's a couple of patches to fix an issue when multiple vcpus fault
on a page table entry[0]. The issue was reported by a user when testing
PUD hugepage support[1] but also exists for PMD and PTE updates though
with a lower probability.

In this version -

* the fix has been split for PMD hugepage and PTE update
* refactored the PMD fix
* applied fixes tag and cc'ing to stable

Thanks,
Punit

[0] https://lkml.org/lkml/2018/8/10/256
[1] https://lkml.org/lkml/2018/7/16/482

Punit Agrawal (2):
  KVM: arm/arm64: Skip updating PMD entry if no change
  KVM: arm/arm64: Skip updating PTE entry if no change

 virt/kvm/arm/mmu.c | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

-- 
2.18.0
