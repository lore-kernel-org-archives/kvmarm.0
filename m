From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 0/3] Fix race condition and simplify vgic active handler
Date: Tue, 16 May 2017 12:04:28 +0200
Message-ID: <20170516100431.4101-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is a small series that reworks a problem in a previously submitted
patch [1].  The previous patch version did not consider that userspace
accesses already hold the KVM mutex and therefore end up in deadlock.

These patches therefore introduces uaccess read/write functions for the
GICv2 MMIO register descriptor framework, splits out the distributor
active register write functionality into separate guest and userspace
access functions, and then finally take the KVM mutex on the guest
access path and gets rid of unneeded complexity from
active_change_prepare/finish.

Applied on top of v4.12-rc1.

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2017-May/025542.html

Changes from v1:
 - Separate guest and uaccess distributor active register writes.
 - Only take the mutex in the guest access path.


Christoffer Dall (3):
  KVM: arm/arm64: Allow GICv2 to supply a uaccess register function
  KVM: arm/arm64: Separate guest and uaccess writes to dist {sc}active
  KVM: arm/arm64: Simplify active_change_prepare and plug race

 arch/arm/include/asm/kvm_host.h   |  2 --
 arch/arm64/include/asm/kvm_host.h |  2 --
 virt/kvm/arm/arm.c                | 20 +++---------
 virt/kvm/arm/vgic/vgic-mmio-v2.c  | 24 +++++++-------
 virt/kvm/arm/vgic/vgic-mmio-v3.c  |  8 +++--
 virt/kvm/arm/vgic/vgic-mmio.c     | 68 ++++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic-mmio.h     | 12 ++++++-
 virt/kvm/arm/vgic/vgic.c          | 11 ++++---
 8 files changed, 92 insertions(+), 55 deletions(-)

-- 
2.9.0
