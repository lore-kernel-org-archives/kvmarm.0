From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 00/10] kvmtool: arm64: GICv3 guest support
Date: Wed, 17 Jun 2015 12:21:51 +0100
Message-ID: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F80E55CEF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 07:11:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X-0AV2Py-9DB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 07:11:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF9555CDD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 07:11:10 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

a new version of the GICv3 support series for kvmtool.

I got rid of passing the number of redistributors around kvmtool.
The new patch 06/10 simplifies ARM's MMIO dispatching, so that we no
longer need to know the GIC size at this point. The FDT code uses
base and size values now directly and these values are private to
arm/gic.c.

The new 07/10 patch aims to solve the number-of-VCPUs problem Marc
mentioned. Instead of letting kvmtool have knowledge about particular
limits, let the kernel decide on this matter. Since KVM_CAP_MAX_VCPUS
is not really reliable on ARM, let's be a bit more relaxed about
KVM_CREATE_VCPU failing and stop with creating more VCPUs if we get
an EINVAL in return.

I also addressed the other comments Marcs gave, but I had to leave
some of the default switch-cases in due to the compiler complaining
otherwise.

Cheers,
Andre.
-----

Since Linux 3.19 the kernel can emulate a GICv3 for KVM guests.
This allows more than 8 VCPUs in a guest and enables in-kernel irqchip
for non-backwards-compatible GICv3 implementations.

This series updates kvmtool to support this feature.
The first half of the series is mostly from Marc and supports some
newer features of the virtual GIC which we later depend on. The second
part enables support for a guest GICv3 by adding a new command line
parameter (--irqchip=).

We now use the KVM_CREATE_DEVICE interface to create a virtual GIC
and only fall back to the now legacy KVM_CREATE_IRQCHIP call if the
former is not supported by the kernel.
Also we use two new features the KVM_CREATE_DEVICE interface
introduces:
* We now set the number of actually used interrupts to avoid
  allocating too many of them without ever using them.
* We tell the kernel explicitly that we are finished with the GIC
  initialisation. This is a requirement for future VGIC versions.

The final three patches introduce virtual GICv3 support, so on
supported hardware (and given kernel support) the user can ask KVM to
emulate a GICv3, lifting the 8 VCPU limit of KVM. This is done by
specifying "--irqchip=gicv3" on the command line.
For the time being the kernel only supports a virtual GICv3 on ARM64,
but as the GIC is shared in kvmtool, I had to add the macro
definitions to not break the build on ARM.

This series goes on top of the new official stand-alone repo hosted
on Will's kernel.org git [1].
Find a branch with those patches included at my repo [2].

[1] git://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
[2] git://linux-arm.org/kvmtool.git (branch gicv3/v3)
    http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/gicv3/v3

Andre Przywara (6):
  arm: finish VGIC initialisation explicitly
  arm: simplify MMIO dispatching
  limit number of VCPUs on demand
  arm: prepare for instantiating different IRQ chip devices
  arm: add support for supplying GICv3 redistributor addresses
  arm: use new irqchip parameter to create different vGIC types

Marc Zyngier (4):
  AArch64: Reserve two 64k pages for GIC CPU interface
  AArch{32,64}: use KVM_CREATE_DEVICE & co to instanciate the GIC
  irq: add irq__get_nr_allocated_lines
  AArch{32,64}: dynamically configure the number of GIC interrupts

 arm/aarch32/arm-cpu.c                    |   2 +-
 arm/aarch64/arm-cpu.c                    |   2 +-
 arm/aarch64/include/kvm/kvm-arch.h       |   2 +-
 arm/gic.c                                | 190 +++++++++++++++++++++++++++++--
 arm/include/arm-common/gic.h             |   9 +-
 arm/include/arm-common/kvm-arch.h        |  19 ++--
 arm/include/arm-common/kvm-config-arch.h |   9 +-
 arm/include/arm-common/kvm-cpu-arch.h    |  14 ++-
 arm/kvm-cpu.c                            |  27 ++---
 arm/kvm.c                                |   6 +-
 include/kvm/irq.h                        |   1 +
 irq.c                                    |   5 +
 kvm-cpu.c                                |   7 ++
 13 files changed, 242 insertions(+), 51 deletions(-)

-- 
2.3.5
