From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 00/15] arm/arm64: add ITS framework
Date: Mon,  5 Dec 2016 22:46:31 +0100
Message-ID: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D90154027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cljse4FnW0Qd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A305401F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:03 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This series proposes a framework to test the virtual ITS.
This is based on Drew's v7 series [1]. The last patch tests
several ITS commands (collection/device mapping, interrupt
translation service entry creation and LPI trigger through INT
command). At this point we don't use any external PCIe device
to write into the GITS_TRANSLATER register.

The bulk of the code derives from the ITS driver code so all
the credit is due to Marc.

Many other ITS commands could be tested. Also existing MMIO
accesses could be enhanced into standalone tests. Current focus
was to make it functional.

The code deserves more cleanup with respect to cacheability
attributes in general.

Tested on Cavium ThunderX [2].

Best Regards

Eric

[1] [kvm-unit-tests PATCH v7 00/11] arm/arm64: add gic framework

[2] sample command line:

$QEMU -machine virt,accel=kvm -cpu host \
 -device virtio-serial-device \
 -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
 -display none -serial stdio \
 -kernel arm/gic.flat \
 -smp 8 -machine gic-version=3 -append 'its'

Eric Auger (15):
  libcflat: Add other size defines
  arm/arm64: gicv3: Add some re-distributor defines
  arm/arm64: ITS skeleton
  arm/arm64: ITS: BASER parsing and setup
  arm/arm64: GICv3: add cpu count
  arm/arm64: ITS: Set the LPI config and pending tables
  arm/arm64: ITS: Init the command queue
  arm/arm64: ITS: enable LPIs at re-distributor level
  arm/arm64: ITS: Parse the typer register
  arm/arm64: ITS: its_enable_defaults
  arm/arm64: ITS: create device
  arm/arm64: ITS: create collection
  arm/arm64: ITS: commands
  arm/arm64: gic: Generalize ipi_enable()
  arm/arm64: ITS test

 arm/Makefile.common        |   1 +
 arm/gic.c                  | 101 +++++++++++-
 lib/arm/asm/gic-v3-its.h   | 238 +++++++++++++++++++++++++++
 lib/arm/asm/gic-v3.h       |  84 ++++++++++
 lib/arm/asm/gic.h          |   1 +
 lib/arm/gic-v3-its-cmd.c   | 399 +++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/gic-v3-its.c       | 305 ++++++++++++++++++++++++++++++++++
 lib/arm/gic-v3.c           |   2 +
 lib/arm/gic.c              |  30 +++-
 lib/arm64/asm/gic-v3-its.h |   1 +
 lib/libcflat.h             |   3 +
 11 files changed, 1154 insertions(+), 11 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm/gic-v3-its-cmd.c
 create mode 100644 lib/arm/gic-v3-its.c
 create mode 100644 lib/arm64/asm/gic-v3-its.h

-- 
2.5.5
