From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM fixes for 5.1-rc3
Date: Thu, 28 Mar 2019 13:36:00 +0000
Message-ID: <20190328133608.110805-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB22F4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nHRMv4qEPViO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 09:36:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 679694A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:35 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, Julien Grall <julien.grall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Here's a handful of KVM/ARM fixes for 5.1-rc3. We have a number of
stage-2 page table fixes, some srcu fixes the the ITS emulation, a
reset fix for the virtual PMU, a GICv4 regression fix, and some
cleanups.

Please pull,

	M.

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.1

for you to fetch changes up to 8324c3d518cfd69f2a17866b52c13bf56d3042d8:

  KVM: arm/arm64: Comments cleanup in mmu.c (2019-03-28 13:17:17 +0000)

----------------------------------------------------------------
KVM/ARM fixes for 5.1

- Fix THP handling in the presence of pre-existing PTEs
- Honor request for PTE mappings even when THPs are available
- GICv4 performance improvement
- Take the srcu lock when writing to guest-controlled ITS data structures
- Reset the virtual PMU in preemptible context
- Various cleanups

----------------------------------------------------------------
Marc Zyngier (4):
      KVM: arm64: Reset the PMU in preemptible context
      arm64: KVM: Always set ICH_HCR_EL2.EN if GICv4 is enabled
      KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest memory
      KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots

Suzuki K Poulose (2):
      KVM: arm/arm64: Enforce PTE mappings at stage2 when needed
      KVM: arm/arm64: Fix handling of stage2 huge mappings

YueHaibing (1):
      KVM: arm/arm64: vgic-its: Make attribute accessors static

Zenghui Yu (1):
      KVM: arm/arm64: Comments cleanup in mmu.c

 arch/arm/include/asm/kvm_mmu.h        |  11 +++
 arch/arm/include/asm/stage2_pgtable.h |   2 +
 arch/arm64/include/asm/kvm_mmu.h      |  11 +++
 arch/arm64/kvm/reset.c                |   6 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c         |   4 +-
 virt/kvm/arm/mmu.c                    | 125 ++++++++++++++++++++--------------
 virt/kvm/arm/vgic/vgic-its.c          |  31 +++++----
 virt/kvm/arm/vgic/vgic-v3.c           |   4 +-
 virt/kvm/arm/vgic/vgic.c              |  14 ++--
 9 files changed, 133 insertions(+), 75 deletions(-)
