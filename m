Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E443BE64A
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284446; cv=none; b=DraFlLKhUEX2zm0bXKqH4HvFCCN4y1b/v8tALba6el2FuDNHZGnY4vkbhug04TaUh6QogeJKGSKWiPZyHJQ3O9yfuHHWNY+V1+fiyZn0PBuxjyyNYPjpW75FKV767pNsR5X28Y8IR3qZOrDD5ci5oNVDCbZK+R0x8hmtZgos5Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284446; c=relaxed/simple;
	bh=JUe3wxokoI7mo1TrvniYCDJF1j7ZUQbdy2NQbw6F9Es=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7QR5BsEm0xOdC7GrDF3dHG3hq8GcvdWwGgVWcBZxGiLc+L783AAXftZfiaubFPfo2JFBI5d8+q685ofTnenQYqH8gDDnB+59jeTpXsw/s0JFnY7We7wIj1/pigivjUDokJ9ASGuulrcfosYB9oAfxSlcW0zjV5ELEY8QogtJIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3BC114BF;
	Mon, 23 Mar 2026 09:47:18 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00CBF3F73B;
	Mon, 23 Mar 2026 09:47:22 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: maz@kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v7 0/6] arm64: Nested virtualization support
Date: Mon, 23 Mar 2026 17:47:11 +0100
Message-ID: <20260323164717.2571585-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v7 of the nested virt support series, correcting a previously
reported, but unfixed issue with endianess. Other than that just
rebased. Changelog below.
========================================================

Thanks to the imperturbable efforts from Marc, arm64 support for nested
virtualization has now reached the mainline kernel, which means the
respective kvmtool support should now be ready as well.

Patch 1 introduces the new "--nested" command line option, to let the
VCPUs start in EL2. To allow KVM guests running in such a guest, we also
need VGIC support, which patch 2 allows by setting the maintenance IRQ.
Patch 3 to 6 are picked from Marc's repo, and allow to set the arch
timer offset, enable non-VHE guests (at the cost of losing recursive
nested virtualisation), advertise the virtual EL2 timer IRQ, and consider
the right system registers when detecting a guest's endianess.

Tested on the FVP (with some good deal of patience), some commercial
hardware and QEMU.

Cheers,
Andre

Changelog v6 ... v7:
- fix SYS_SCTLR_EL1 definition
- consider E2H bit when determining the guest's current endianess

Changelog v5 ... v6:
- rebase / drop header update patch (already merged)
- fix endianness bug in DT maintenance IRQ description

Changelog v4 ... v5:
- bump kernel headers to v6.19-rc6
- print a warning if --e2h0 is given without --nested
- fail if the maintenance IRQ setting attribute is not supported
- add tags

Changelog v3 ... v4:
- pass kvm pointer to gic__generate_fdt_nodes()
- use macros for PPI offset and DT type identifier
- properly calculate DT interrupt flags value
- add patch 7 to fix virtio endianess issues
- CAPITALISE verbs in commit message

Changelog v2 ... v3:
- adjust^Wreplace commit messages for E2H0 and counter-offset patch
- check for KVM_CAP_ARM_EL2_E2H0 when --e2h0 is requested
- update kernel headers to v6.16 release

Changelog v1 ... 2:
- add three patches from Marc:
  - add --e2h0 command line option
  - add --counter-offset command line option
  - advertise all five arch timer interrupts in DT

Andre Przywara (2):
  arm64: Initial nested virt support
  arm64: nested: Add support for setting maintenance IRQ

Marc Zyngier (4):
  arm64: Add counter offset control
  arm64: Add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers
  arm64: Handle virtio endianness reset when running nested

 arm64/arm-cpu.c                     |  6 +--
 arm64/fdt.c                         |  5 +-
 arm64/gic.c                         | 29 ++++++++++-
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 ++++-
 arm64/include/kvm/kvm-cpu-arch.h    |  5 +-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 75 ++++++++++++++++++++++++-----
 arm64/kvm.c                         | 20 ++++++++
 arm64/timer.c                       | 29 +++++------
 10 files changed, 144 insertions(+), 40 deletions(-)

-- 
2.43.0

