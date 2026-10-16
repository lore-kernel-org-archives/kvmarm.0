Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E1A4E73D3
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165190; cv=none; b=FE2rfWURfboCQWBQvesAFklZ940xZRKe7rqZGc+RGu1ISASNPR3crpoKOo+ukW9i4RK7RVipENM2wnyL7877vMdvsEY8MnlNW+DCxAaT/m3M/830RydlkMR3G0Vw12DseCSWqoiSCWFWNqIGi2zaY9mkIXaeUhvkAzvbVpglMWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165190; c=relaxed/simple;
	bh=rHRvMSExvGuuOfyAs5V40rEeuuYpKQAhv88rcndMFLU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fEZ/JdIKEwWq5TorbjiqB2RA5618azQ72zrYkBHdoB8myeXids2EpwWSHJO8DnWyfdta5sd/zP9n/P/3rkCpWndnN2F5whUTJMNhv1vdMXR6NJ5Ofqieg4M85HMLeOzIeFZB57QNEM0mY0K7WDrd58dh/zqGNALWi/nrE4md2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aUTUype7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aUTUype7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91017143D;
	Fri, 16 Oct 2026 08:39:45 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D23713F673;
	Fri, 16 Oct 2026 08:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165188; bh=rHRvMSExvGuuOfyAs5V40rEeuuYpKQAhv88rcndMFLU=;
	h=From:To:Cc:Subject:Date:From;
	b=aUTUype7s5wp04Iv5ep3UyYFALx9FAD1OrHHs7U6LNnB+5OJKLdYYu8cPNG0gONMW
	 jTfMUzF8dDyCDt6XoCE8vaNNFTw3Rw9F25ju16ArNky4+XBBZfULEFTdjFr0BzESIq
	 C/8WE2Sby6lOGSEbyl8ke0jSWEG8kEgdU+XpeVCo=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 00/21] arm64: Support GICv5-based guests
Date: Fri, 16 Oct 2026 16:39:18 +0100
Message-Id: <20261016153939.913764-1-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for GICv5-based VMs to kvmtool. These are
exposed as --irqchip=gicv5 and --irqchip=gicv5-its, where the former
only creates a vGICv5 device and the latter adds in a GICv5 ITS. The
GICv5 specification can be found at [1].

The GICv5 support in KVM needed by --irqchip=gicv5 is expected to
land in Linux v7.4. KVM support for GICv5 ITS has yet to be posted,
but should follow shortly. Thus, --irqchip=gicv5 works with the
corresponding KVM changes, while --irqchip=gicv5-its cannot yet be
used with upstream KVM.

The series teaches kvmtool to create the GICv5 irqchip and ITS KVM
devices. It describes the GICv5 CPU interface, IRS and ITS in the
guest DT, updates the timer and PMU interrupt descriptions, and
generates GICv5 interrupt specifiers for platform devices and PCI. It
also maps PCI MSI requester IDs to the ITS.

Compared with v2 [2], the work has been split into smaller patches
to make the series easier to review. The IRS support is built up and
exposed before the ITS support is added, as was the case previously.

Please do note: the kernel headers have not been fully synced. Only
the definitions needed for this support have been added, in separate
IRS and ITS patches. Before merging, the headers should be synced
against the latest Linux headers.

Thanks,
Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.com/

Sascha Bischoff (21):
  arm64: Propagate IRQ routing initialisation errors
  arm64: Close the ITS descriptor when setup fails
  arm64: Sync KVM UAPI headers for GICv5 IRS
  arm64: Add GICv5 irqchip device support
  arm64: Track whether the VM uses GICv5
  irq: Allow the initial interrupt line number to be set
  arm64: Configure the GICv5 IRS
  arm64: Define GICv5 interrupt types
  arm64: Describe the PMU interrupt for GICv5
  arm64: Describe timer PPIs for GICv5
  arm64: Assign CPU DT phandles for GICv5
  arm64: Describe the GICv5 CPU interface in the DT
  arm64: Describe the GICv5 IRS in the DT
  arm64: Generate GICv5 SPI specifiers for platform devices
  arm64: Generate GICv5 PCI INTx specifiers
  arm64: Expose the GICv5 irqchip option
  arm64: Sync KVM UAPI headers for GICv5 ITS
  arm64: Add GICv5 ITS device support
  arm64: Describe the GICv5 ITS in the DT
  arm64: Map PCI MSI requester IDs to the GICv5 ITS
  arm64: Expose the GICv5 ITS irqchip option

 arm64/fdt.c                         |  21 ++-
 arm64/gic.c                         | 196 +++++++++++++++++++++++++---
 arm64/include/asm/kvm.h             |  17 +++
 arm64/include/kvm/fdt-arch.h        |   1 +
 arm64/include/kvm/gic.h             |   7 +
 arm64/include/kvm/kvm-arch.h        |  16 +++
 arm64/include/kvm/kvm-config-arch.h |   2 +-
 arm64/pci.c                         |  23 +++-
 arm64/pmu.c                         |  23 +++-
 arm64/timer.c                       |  21 ++-
 include/kvm/irq.h                   |   1 +
 include/linux/kvm.h                 |   2 +
 irq.c                               |  15 ++-
 13 files changed, 306 insertions(+), 39 deletions(-)

-- 
2.34.1

