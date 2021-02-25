Return-Path: <SRS0=vuhq=H3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C88EC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C708D64F03
	for <kvmarm@archiver.kernel.org>; Thu, 25 Feb 2021 01:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C708D64F03
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B56D4B2A3;
	Wed, 24 Feb 2021 20:00:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TuR6vGgLKcEu; Wed, 24 Feb 2021 20:00:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6544B29F;
	Wed, 24 Feb 2021 20:00:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28B974B272
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uWJMXfNI98Ud for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 20:00:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB5C4B26E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 20:00:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D098ED1;
 Wed, 24 Feb 2021 17:00:26 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF9053F73B;
 Wed, 24 Feb 2021 17:00:24 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v2 00/22] Unify I/O port and MMIO trap handling
Date: Thu, 25 Feb 2021 00:58:53 +0000
Message-Id: <20210225005915.26423-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
Cc: Marc Zyngier <maz@kernel.org>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Compared to v1 this has a few fixes, as suggested by Alex.
There is a new patch 20/22, which cleans up the ARM memory map
definition and adds some chart to make it more obvious what is going on.
For a changelog, see below.

==============

At the moment we use two separate code paths to handle exits for
KVM_EXIT_IO (ioport.c) and KVM_EXIT_MMIO (mmio.c), even though they
are semantically very similar. Because the trap handler callback routine
is different, devices need to decide on one conduit or need to provide
different handler functions for both of them.

This is not only unnecessary code duplication, but makes switching
devices from I/O port to MMIO a tedious task, even though there is no
real difference between the two, especially on ARM and PowerPC.

For ARM we aim at providing a flexible memory layout, and also have
trouble with the UART and RTC device overlapping with the PCI I/O area,
so it seems indicated to tackle this once and for all.

The first three patches do some cleanup, to simplify things later.

Patch 04/22 lays the groundwork, by extending mmio.c to be able to also
register I/O port trap handlers, using the same callback prototype as
we use for MMIO.

The next 14 patches then convert devices that use the I/O port
interface over to the new joint interface. This requires to rework
the trap handler routine to adhere to the same prototype as the existing
MMIO handlers. For most devices this is done in two steps: a first to
introduce the reworked handler routine, and a second to switch to the new
joint registration routine. For some devices the first step is trivial,
so it's done in one patch.

Patch 19/22 then retires the old I/O port interface, by removing ioport.c
and friends.
Patch 20/22 uses the opportunity to clean up the memory map description,
also declares a new region (from 16MB on), where the final two patches
switch the UART and the RTC device to. They are now registered
on the MMIO "bus", when running on ARM or arm64. This moves them away
from the first 64KB, so they are not in the PCI I/O area anymore.

Please have a look and comment!

Cheers,
Andre

Changelog v1 .. v2:
- rework memory map definition
- add explicit debug output for debug I/O port
- add explicit check for MMIO coalescing on I/O ports
- drop usage of ioport__{read,write}8() from serial
- drop explicit I/O port cleanup routine (to mimic MMIO operation)
- add comment for IOTRAP_BUS_MASK
- minor cleanups / formatting changes

Andre Przywara (22):
  ioport: Remove ioport__setup_arch()
  hw/serial: Use device abstraction for FDT generator function
  ioport: Retire .generate_fdt_node functionality
  mmio: Extend handling to include ioport emulation
  hw/i8042: Clean up data types
  hw/i8042: Refactor trap handler
  hw/i8042: Switch to new trap handlers
  x86/ioport: Refactor trap handlers
  x86/ioport: Switch to new trap handlers
  hw/rtc: Refactor trap handlers
  hw/rtc: Switch to new trap handler
  hw/vesa: Switch trap handling to use MMIO handler
  hw/serial: Refactor trap handler
  hw/serial: Switch to new trap handlers
  vfio: Refactor ioport trap handler
  vfio: Switch to new ioport trap handlers
  virtio: Switch trap handling to use MMIO handler
  pci: Switch trap handling to use MMIO handler
  Remove ioport specific routines
  arm: Reorganise and document memory map
  hw/serial: ARM/arm64: Use MMIO at higher addresses
  hw/rtc: ARM/arm64: Use MMIO at higher addresses

 Makefile                          |   1 -
 arm/include/arm-common/kvm-arch.h |  47 ++++--
 arm/ioport.c                      |   5 -
 hw/i8042.c                        |  94 +++++-------
 hw/rtc.c                          |  91 ++++++------
 hw/serial.c                       | 160 ++++++++++++--------
 hw/vesa.c                         |  19 +--
 include/kvm/i8042.h               |   1 -
 include/kvm/ioport.h              |  32 ----
 include/kvm/kvm.h                 |  49 ++++++-
 ioport.c                          | 235 ------------------------------
 mips/kvm.c                        |   5 -
 mmio.c                            |  65 +++++++--
 pci.c                             |  82 +++--------
 powerpc/ioport.c                  |   6 -
 vfio/core.c                       |  50 ++++---
 virtio/pci.c                      |  46 ++----
 x86/ioport.c                      | 107 +++++++-------
 18 files changed, 433 insertions(+), 662 deletions(-)
 delete mode 100644 ioport.c

-- 
2.17.5

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
