From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL 0/4] KVM/arm fixes for 4.17-rc4
Date: Fri,  4 May 2018 17:15:55 +0100
Message-ID: <20180504161559.22852-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E7F249FD7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:07:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NYWPs+gcSqbx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 12:06:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EFCE400D4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:06:39 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Valentin Schneider <valentin.schneider@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

Here is the second batch of KVM/arm fixes for 4.17, mostly fixing a
few fallouts from the merge window.

Please pull.

	M.

The following changes since commit 85bd0ba1ff9875798fad94218b627ea9f768f3c3:

  arm/arm64: KVM: Add PSCI version selection API (2018-04-20 16:32:23 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-4.17-2

for you to fetch changes up to b220244d41798c6592e7d17843256eb0bae456a0:

  arm64: vgic-v2: Fix proxying of cpuif access (2018-05-04 16:45:55 +0100)

----------------------------------------------------------------
KVM/arm fixes for 4.17, take #2

- Fix proxying of GICv2 CPU interface accesses
- Fix crash when switching to BE
- Track source vcpu git GICv2 SGIs
- Fix an outdated bit of documentation

----------------------------------------------------------------
James Morse (2):
      KVM: arm64: Fix order of vcpu_write_sys_reg() arguments
      arm64: vgic-v2: Fix proxying of cpuif access

Marc Zyngier (1):
      KVM: arm/arm64: vgic: Fix source vcpu issues for GICv2 SGI

Valentin Schneider (1):
      KVM: arm/arm64: vgic_init: Cleanup reference to process_maintenance

 arch/arm64/include/asm/kvm_emulate.h     |  2 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 24 ++++++++++++----
 include/kvm/arm_vgic.h                   |  1 +
 virt/kvm/arm/vgic/vgic-init.c            |  2 +-
 virt/kvm/arm/vgic/vgic-mmio.c            | 10 +++++--
 virt/kvm/arm/vgic/vgic-v2.c              | 38 ++++++++++++++-----------
 virt/kvm/arm/vgic/vgic-v3.c              | 49 +++++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic.c                 | 30 +++++--------------
 virt/kvm/arm/vgic/vgic.h                 | 14 +++++++++
 9 files changed, 102 insertions(+), 68 deletions(-)
