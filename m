Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C270E1DE2A5
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721524; cv=none; b=oVy1Dw9IGreqmVYVshNc/0/xv9UccbHuV2+a5mDU+vH4OtBy8Klu5PU6DPPDRy8uYYrQcL7a7DcMUmsBR39F18EHTcRd+k3+OIlN91pWo2rsvCLcrJyszC0m/Kji4d3pm0k8cv7UOF1jxsrL7OqkbxU2VGl4WgjyZb/YGnedVPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721524; c=relaxed/simple;
	bh=abgqkQhYniJWCyH534lQE/FEFCkzxYytvSvB99BXO5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ccXjssgh/OwjGgZlDOeqCpdmAQm4AG35YSoB8jCC/rVkj19f7oeBvnaQiKSlUxUEX6deGVJTZwrRQ3aTWp9bVY9xfUVbVTxVB9vR3hh/V02SbDYqXzAl8kbnWzb2kntKZGSW9zIlNqubF9ieZTkLZJ3+vHBboxMK1tyodeDc2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09975106F;
	Wed, 24 Sep 2025 06:45:13 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F8833F5A1;
	Wed, 24 Sep 2025 06:45:20 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 0/7] arm64: Nested virtualization support
Date: Wed, 24 Sep 2025 14:45:04 +0100
Message-Id: <20250924134511.4109935-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v4 of the nested virt support series, slightly reworking the
code for the maintenance IRQ. Also adding a fix from Marc for virtio
endianess handling. Changelog below.
========================================================

Thanks to the imperturbable efforts from Marc, arm64 support for nested
virtualization has now reached the mainline kernel, which means the
respective kvmtool support should now be ready as well.

Patch 1 updates the kernel headers, to get the new EL2 capability, and
the VGIC device control to setup the maintenance IRQ.
Patch 2 introduces the new "--nested" command line option, to let the
VCPUs start in EL2. To allow KVM guests running in such a guest, we also
need VGIC support, which patch 3 allows by setting the maintenance IRQ.
Patch 4 to 6 are picked from Marc's repo, and allow to set the arch
timer offset, enable non-VHE guests (at the cost of losing recursive
nested virtualisation), and also advertise the virtual EL2 timer IRQ.

Tested on the FVP (with some good deal of patience), and some commercial
(non-fruity) hardware, down to a guest's guest's guest.

Cheers,
Andre

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


Andre Przywara (3):
  Sync kernel UAPI headers with v6.16
  arm64: Initial nested virt support
  arm64: nested: Add support for setting maintenance IRQ

Marc Zyngier (4):
  arm64: Add counter offset control
  arm64: Add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers
  arm64: Handle virtio endianness reset when running nested

 arm64/arm-cpu.c                     |  6 +--
 arm64/fdt.c                         |  5 +-
 arm64/gic.c                         | 26 ++++++++-
 arm64/include/asm/kvm.h             | 23 ++++++--
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 +++-
 arm64/include/kvm/kvm-cpu-arch.h    |  5 +-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 64 +++++++++++++++++++----
 arm64/kvm.c                         | 17 ++++++
 arm64/timer.c                       | 29 +++++------
 include/linux/kvm.h                 | 31 +++++++++++
 include/linux/virtio_net.h          | 13 +++++
 include/linux/virtio_pci.h          |  1 +
 riscv/include/asm/kvm.h             |  2 +
 x86/include/asm/kvm.h               | 81 +++++++++++++++++++++++++++++
 16 files changed, 274 insertions(+), 44 deletions(-)

-- 
2.25.1

