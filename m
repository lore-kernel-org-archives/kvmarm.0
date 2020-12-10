Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3348C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D71923E23
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 14:29:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D71923E23
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 564BA4B1D4;
	Thu, 10 Dec 2020 09:29:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vm7EoCXkOczg; Thu, 10 Dec 2020 09:29:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1839B4B1B3;
	Thu, 10 Dec 2020 09:29:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274684B195
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id knD5vFbZBjLk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 09:29:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 922DF4B137
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 09:29:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA4941FB;
 Thu, 10 Dec 2020 06:29:21 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE1443F718;
 Thu, 10 Dec 2020 06:29:20 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool 00/21] Unify I/O port and MMIO trap handling
Date: Thu, 10 Dec 2020 14:28:47 +0000
Message-Id: <20201210142908.169597-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

Patch 04/21 lays the groundwork, by extending mmio.c to be able to also
register I/O port trap handlers, using the same callback prototype as
we use for MMIO.

The next 14 patches then convert devices that use the I/O port
interface over to the new joint interface. This requires to rework
the trap handler routine to adhere to the same prototype as the existing
MMIO handlers. For most devices this is done in two steps: a first to
introduce the reworked handler routine, and a second to switch to the new
joint registration routine. For some devices the first step is trivial,
so it's done in one patch.

Patch 19/21 then retires the old I/O port interface, by removing ioport.c
and friends.

The final two patches switch the UART and the RTC device over to register
on the MMIO "bus", when running on ARM or arm64. This changes the
addresses to be at 16MB, so they are not in the PCI I/O area anymore.

Admittedly this goal can be achieved much simpler, by just having the
first three patches, and some more changes and ifdef's in the last two,
but I figured it would be good to clean up the I/O port mess for good.

Please have a look and comment!

Cheers,
Andre

Andre Przywara (21):
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
  hw/serial: ARM/arm64: Use MMIO at higher addresses
  hw/rtc: ARM/arm64: Use MMIO at higher addresses

 Makefile             |   1 -
 arm/ioport.c         |   5 -
 hw/i8042.c           |  88 ++++++----------
 hw/rtc.c             |  91 ++++++++---------
 hw/serial.c          | 166 +++++++++++++++++++-----------
 hw/vesa.c            |  19 +---
 include/kvm/i8042.h  |   1 -
 include/kvm/ioport.h |  25 -----
 include/kvm/kvm.h    |  42 +++++++-
 ioport.c             | 235 -------------------------------------------
 mips/kvm.c           |   5 -
 mmio.c               |  59 +++++++++--
 pci.c                |  82 +++++----------
 powerpc/ioport.c     |   6 --
 vfio/core.c          |  50 ++++-----
 virtio/pci.c         |  42 ++------
 x86/ioport.c         | 106 +++++++++----------
 17 files changed, 385 insertions(+), 638 deletions(-)
 delete mode 100644 ioport.c

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
