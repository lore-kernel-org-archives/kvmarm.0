From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v3 0/6] GICv3: add 32bit compatibility
Date: Thu,  1 Oct 2015 13:47:13 +0100
Message-ID: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E42441390
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 08:46:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3YjnNKoKyWAM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2015 08:46:42 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11C9D412D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 08:46:41 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Cooper <jason@lakedaemon.net>, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series adds 32bit support to the GICv3 driver. Only SGIs, PPIs and
SPIs support is present, no ITS.
Currently, the main targets for those patches are 32bit guests running under
KVM. They can now use affinity routing and theoretically have a lot more than
8 CPUs. During my tests, I was able to use 16 virtual CPUs on an AEM model.

We don't support 32bit hosts with GICv3 at the moment. I added a patch to allow
building a host when CONFIG_ARM_GIC_V3 enabled, as pointed out by Vladimir in
the last series. When attempting to run such host with a device-tree that
declares GICv3, KVM will refuse to start, and throw a -ENODEV error.

Some time has passed since last series, but I am now available full-time to act
on reviews and comments.

Changes since v2 [2]:
- rebased on 4.3-rc3,
- add a sixth patch to handle build with CONFIG_KVM + CONFIG_ARM_GIC_V3.

Changes since v1 [1]:
- fix the mistakes pointed out on the list,
- add a patch to select ARM_GIC_V3 under ARCH_VIRT.

Cheers,
Jean

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310124.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/327034.html

Jean-Philippe Brucker (6):
  arm64: GICv3: refactor the AArch64 specific parts
  arm64: GICv3: change unsigned types for AArch32 compatibility
  arm64: GICv3: Specialize readq and writeq accesses
  ARM: add 32bit support to GICv3
  ARM: virt: select ARM_GIC_V3
  arm/arm64: KVM: only allow 64bit hosts to build VGICv3

 arch/arm/Kconfig                    |    1 +
 arch/arm/include/asm/arch_gicv3.h   |  188 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/arch_gicv3.h |  148 +++++++++++++++++++++++++++
 arch/arm64/kvm/Kconfig              |    4 +
 drivers/irqchip/irq-gic-v3.c        |   69 ++++---------
 include/kvm/arm_vgic.h              |    4 +-
 include/linux/irqchip/arm-gic-v3.h  |   87 ++--------------
 virt/kvm/arm/vgic.c                 |    4 +-
 8 files changed, 373 insertions(+), 132 deletions(-)
 create mode 100644 arch/arm/include/asm/arch_gicv3.h
 create mode 100644 arch/arm64/include/asm/arch_gicv3.h

-- 
1.7.9.5
