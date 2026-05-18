Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31ED42EED0
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 12:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108365; cv=none; b=MACiVGqmN7g2OVjHD+iXYDg9YZE1esRf3hBbSybvoncgtimQiFsY10d6GisS4kIHHAWGAp6FtZgzbhk1T8LqWcgDx7g3p5v0M4ZMQqj9pynBI72jAtYb+4sOOUgB+aKOI4pN4WBR3Nvt00htNSq2KKtg1TTw8fVfMhyojVvirCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108365; c=relaxed/simple;
	bh=k8yxpOxwZEQuG1vtaQTZsWLT9uQhQkqGAW3FWKUpfA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mCfInWy6om/IcrXr4iBcWW4moqwuicDYB6qWmz8IivY0rEJqPv6g179jFJDc2IUxfdEm8UJZUz+eoSd8qazt2z0WNKGNvitle/Ini/dxXgU/MpSctw/rNA9zNtPyOwtLzz8d81ik+iG4iZHsXUSlLT5T58K+lxvoivl3rcNtEaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TTzVM8JR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TTzVM8JR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF9D145BF;
	Mon, 18 May 2026 05:45:57 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FE243FA21;
	Mon, 18 May 2026 05:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779108363; bh=k8yxpOxwZEQuG1vtaQTZsWLT9uQhQkqGAW3FWKUpfA0=;
	h=From:To:Cc:Subject:Date:From;
	b=TTzVM8JReGQfFdZcEF7edI8lpX8aU+EvbEerfe3i6JdPszoZf033hV3A8ghK/s0jX
	 oyBaBrho0tsg373umbtvyFTBKEeY40L+U+2dgo1lOBpzOIFTOZW9sWmBKVzUpatFoI
	 H+uIdC4FUYX8nO8B88ND0oG8CR0zYGdgQjlgKyQo=
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v8 0/6] arm64: Nested virtualization support
Date: Mon, 18 May 2026 14:45:50 +0200
Message-ID: <20260518124556.164739-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v8 of the nested virt support series is just rebasing on top of current
master, to accommodate the meanwhile merged userland PSCI series.
Changelog below.
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

Changelog v7 ... v8:
- rebased on top of master

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


*** BLURB HERE ***

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

