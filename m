From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 0/3] KVM/ARM Fixes for v4.12-rc5
Date: Tue,  6 Jun 2017 15:56:26 +0200
Message-ID: <20170606135629.31664-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACCD640C26
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:52:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NgZkVuRy92+1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 09:52:40 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 816A540A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:52:40 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id d73so49536439wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 06:56:46 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim and Paolo,

Three additional fixes for KVM/ARM for v4.12.

They fix an issue with migrating GICv2 VMs on GICv3 systems, squash a
bug for gicv3 when figuring out preemption levels, and fix a potential
null pointer derefence in KVM happening under memory pressure.

The following changes since commit fa472fa91a5a0b241f5ddae927d2e235d07545df:

  KVM: arm/arm64: Hold slots_lock when unregistering kvm io bus devices (2017-05-18 11:18:16 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.12-rc5

for you to fetch changes up to d6dbdd3c8558cad3b6d74cc357b408622d122331:

  KVM: arm/arm64: Handle possible NULL stage2 pud when ageing pages (2017-06-06 15:28:40 +0200)

Thanks,
-Christoffer

----------------------------------------------------------------
Christoffer Dall (2):
  KVM: arm/arm64: Fix isues with GICv2 on GICv3 migration
  KVM: arm/arm64: vgic-v3: Fix nr_pre_bits bitfield extraction

Marc Zyngier (1):
  KVM: arm/arm64: Handle possible NULL stage2 pud when ageing pages

 arch/arm64/kvm/vgic-sys-reg-v3.c   | 10 ++++----
 include/linux/irqchip/arm-gic-v3.h |  4 ++++
 include/linux/irqchip/arm-gic.h    | 28 ++++++++++++++++++++---
 virt/kvm/arm/hyp/vgic-v3-sr.c      |  2 +-
 virt/kvm/arm/mmu.c                 |  3 +++
 virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 +++++++++++--
 virt/kvm/arm/vgic/vgic-v2.c        | 28 ++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-v3.c        | 47 ++++++++++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic.h           | 12 ++++++----
 9 files changed, 118 insertions(+), 32 deletions(-)
