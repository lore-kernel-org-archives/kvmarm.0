From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/5] KVM/ARM updates for 5.1-rc7
Date: Thu, 25 Apr 2019 14:48:51 +0100
Message-ID: <20190425134857.26109-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533484A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bnq5YDl225ct for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:49:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 119C64A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:13 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Here's a bunch of late fixes for 5.1-rc7, which should hopefully be
the last drop for this cycle.

Please pull,

	M.

The following changes since commit 8324c3d518cfd69f2a17866b52c13bf56d3042d8:

  KVM: arm/arm64: Comments cleanup in mmu.c (2019-03-28 13:17:17 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.1-2

for you to fetch changes up to 6bc210003dff7b789efae5bb02a0320dc24dd416:

  KVM: arm/arm64: Don't emulate virtual timers on userspace ioctls (2019-04-25 14:13:31 +0100)

----------------------------------------------------------------
KVM/ARM fixes for 5.1, take #2:

- Don't try to emulate timers on userspace access
- Fix unaligned huge mappings, again
- Properly reset a vcpu that fails to reset(!)
- Properly retire pending LPIs on reset
- Fix computation of emulated CNTP_TVAL

----------------------------------------------------------------
Andrew Jones (1):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Christoffer Dall (1):
      KVM: arm/arm64: Don't emulate virtual timers on userspace ioctls

Marc Zyngier (1):
      KVM: arm/arm64: vgic-v3: Retire pending interrupts on disabling LPIs

Suzuki K Poulose (1):
      kvm: arm: Skip stage2 huge mappings for unaligned ipa backed by THP

Wei Huang (1):
      KVM: arm/arm64: arch_timer: Fix CNTP_TVAL calculation

 virt/kvm/arm/arch_timer.c        | 17 ++++++++++-------
 virt/kvm/arm/arm.c               | 11 ++++++++---
 virt/kvm/arm/mmu.c               |  6 +++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 +++
 virt/kvm/arm/vgic/vgic.c         | 21 +++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  1 +
 6 files changed, 48 insertions(+), 11 deletions(-)
