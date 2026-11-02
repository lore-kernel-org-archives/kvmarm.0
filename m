Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655264;
	b=PXzPzZGyL9GxL5cXewHuhu5kP0bLhv3bJVVOx5bUkdhep0vzRdusJWwQyD9tksUs70KY
	 s723hwt/YylqtAcio7E8vAHt1mJ7eFhpl39dyDO4lbmQz33mpk0Q57blmFqXEVgQ2EItO
	 RJkLrvxENNkGNp9swhC7Hjr8cIko9x225GWgf++nSwJl32Q6abc5VEwhfEKMuJGoN/4Yu
	 lemmYPrKOy5LSj/9DRZ8+kCJGiZRDRoZo2Uoo2MANG1KgsB3mrWHeTAe1KI1VZB/ydqPH
	 VdRTDkfDeVEiuahP3ITRVXt0mIL46sx4yaT+ukC68Gq3XiEW3bmGCORoRoLS72/wSRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655264;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=NAqLT7kufGBP+nHopW6HfGaMZzWNBLYiNONYUHr0zWU=;
	b=FReFx/8x+anUimFikiTXZTkbKuzsSbGoEZ2ZcwDMHdYJ1/uILUY3GlHTGkgoKs12VfkK
	 xQhH4Frw//NB7Xij+EIAWN3jyR8w1nCC66VWPJt2encJY+9q7SDMWbfnvDDSCzlpJSELB
	 f6I+qbfxbtl7g2XV1juMgVWyxdP/4Bf+F0MwIXgaUF58cKdr1mvi8LA0PkFxv8mNbeuxn
	 1Py+4e3uHLSHNn9giN2C33yIoyAxeKKso5tZg+qPRUbdb6WgMvBQE/c/P5vXFRXiMjtmk
	 s7BhHXmQqKcG3Jjsi/Zow22Hei0KuBh4G+0nodmxIci/uEbcKUeSiXKkj74ZQB8mcoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=f1vchbCM;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3453606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3453606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=f1vchbCM
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F39C1595;
	Mon,  2 Nov 2026 13:34:20 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18F613F673;
	Mon,  2 Nov 2026 13:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655263; bh=oeFbh4Ag3sXbqQJgqRvzofhpTB/CMCVWpRHbdCqYVZs=;
	h=From:To:Cc:Subject:Date:From;
	b=f1vchbCMISYmNt2Q4LDcegVknWk84LDlDVMIrh2AN5whZIxvsZPMm2TqfD1LV+vA4
	 coACQpVSX8WPy7j0kTsZN2juIycDvC8nqnjFcYzkPvYUSU/9SbC0L62wP1PAfEdc+b
	 OiIdikBizvzDZRd3dKQB6Nw3dviSflxZD0g+uDiY=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 00/23] arm64: Support GICv5-based guests
Date: Mon,  2 Nov 2026 21:33:50 +0000
Message-Id: <20261102213413.4136118-1-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for GICv5-based VMs to kvmtool. These are
exposed as --irqchip=gicv5 and --irqchip=gicv5-its, where the former
only creates a vGICv5 device and the latter adds in a GICv5 ITS. The
GICv5 specification can be found at [1].

The GICv5 support in KVM needed by --irqchip=gicv5 can be found as of
Linux v7.4-rc1. KVM support for GICv5 ITS has been posted at
[2]. Thus, --irqchip=gicv5 works with the corresponding KVM changes,
while --irqchip=gicv5-its cannot yet be used with upstream KVM.

The series teaches kvmtool to create the GICv5 irqchip and ITS KVM
devices. It describes the GICv5 CPU interface, IRS and ITS in the
guest DT, updates the timer and PMU interrupt descriptions, and
generates GICv5 interrupt specifiers for platform devices and PCI. It
also maps PCI MSI requester IDs to the ITS.

Since [3], there have been a lot of changes to the core plumbing
introduced by the GICv5 support. Thanks to Vladimir's suggestions, it
has been somewhat decoupled from the GICv5 support itself, and the
split is now much cleaner. Thanks, Vladimir! The IRS support is built
up and exposed before the ITS support is added, as was the case
previously. This allows, for example, the --irqchip=gicv5 config to be
merged while leaving the ITS changes under review.

Compared with v3 [3]:

* Split GIC device address setup into CPU interface, redistributor and
  distributor helpers. The existing MSI helper now uses the global MSI
  base, and the GICv2 PPI CPU-mask check uses irqchip ordering.

* Split IRQ-offset support into generic infrastructure and separate
  GICv5 configuration.

* Use configured SPI/PPI bases and FDT types in interrupt and DT code,
  with a helper for encoding the PMU's GICv5 PPI INTID. Remove the
  unused GICv5 state.

* Give GICv5 FDT interrupt types distinct names and emit CPU phandles
  for all arm64 guests; the GICv5 IRS references those phandles.

* Sync the UAPI headers with v7.4-rc1.

The v7.4-rc1 header sync includes GICv5 IRS UAPI, but not GICv5 ITS
UAPI. Patch 19 mirrors the ITS definitions from the pending KVM series
[2]. Once that UAPI lands upstream, the headers should be resynced
against the latest Linux headers before merging the ITS support.

Thanks,
Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20261102194454.4086911-1-sascha.bischoff@arm.com/
[3] https://lore.kernel.org/all/20261016153939.913764-1-sascha.bischoff@arm.com/

Sascha Bischoff (23):
  arm64: Propagate IRQ routing initialisation errors
  arm64: Close the ITS descriptor when setup fails
  arm64: Split GIC device setup
  Sync kernel UAPI headers with v7.4-rc1
  arm64: Add GICv5 irqchip device support
  arm64: Configure GIC interrupt bases
  irq: Allow the initial interrupt line number to be set
  arm64: Start GICv5 SPI line allocation at zero
  arm64: Configure the GICv5 IRS
  arm64: Define GICv5 interrupt types
  arm64: Describe the PMU interrupt for GICv5
  arm64: Describe timer PPIs for GICv5
  arm64: Assign CPU DT phandles
  arm64: Describe the GICv5 CPU interface in the DT
  arm64: Describe the GICv5 IRS in the DT
  arm64: Generate GICv5 SPI specifiers for platform devices
  arm64: Generate GICv5 PCI INTx specifiers
  arm64: Expose the GICv5 irqchip option
  arm64: Add proposed GICv5 ITS UAPI definitions
  arm64: Add GICv5 ITS device support
  arm64: Describe the GICv5 ITS in the DT
  arm64: Map PCI MSI requester IDs to the GICv5 ITS
  arm64: Expose the GICv5 ITS irqchip option

 arm64/fdt.c                         |  13 +-
 arm64/gic.c                         | 361 ++++++++++++++++++++++++----
 arm64/include/asm/kvm.h             |  18 ++
 arm64/include/kvm/fdt-arch.h        |   1 +
 arm64/include/kvm/gic.h             |  15 ++
 arm64/include/kvm/kvm-arch.h        |  16 ++
 arm64/include/kvm/kvm-config-arch.h |   2 +-
 arm64/pci.c                         |  16 +-
 arm64/pmu.c                         |  13 +-
 arm64/timer.c                       |   9 +-
 include/kvm/irq.h                   |   1 +
 include/linux/kvm.h                 |  23 ++
 include/linux/virtio_console.h      |   2 +-
 include/linux/virtio_ids.h          |   1 +
 irq.c                               |  15 +-
 powerpc/include/asm/kvm.h           |  18 ++
 riscv/include/asm/kvm.h             |  17 ++
 x86/include/asm/kvm.h               |   4 +-
 18 files changed, 475 insertions(+), 70 deletions(-)

-- 
2.34.1

