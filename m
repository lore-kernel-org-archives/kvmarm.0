Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00F6327C09
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178492; cv=none; b=LHVNN9+b+ROjDbJx+ZL+sTBVdHeiS5jbMqUamx5YQqg/kzK6kNXrUPwPyPHC1miuG580K37HIKcjIqzUlYqsrx2B8EBrMu3eJzez1KdNufQPJtI3QMV3KHrisHchWNfg2edqhT91umbIOr8X6gcmm61frTiWfCvJiI9P1RL1rLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178492; c=relaxed/simple;
	bh=7exSPU/9YuSl/Ghj8YV45sMiot1CADmGgiuc1SLjWMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uFbNAG5VXNB1TtuYYCc8IbM3biHFWzEeWYLgltGLCzn9ZYLW6fp5tg1AAsP8QhFXZeJ29cd95kIfwjDURlUUNszKWfXBlmdQ9Kwh29GsaHzbziRu+TM2lwB+FCRuZHlbNjVSCwKYpdA//fHo77cWWQ1SrM42vEUmvmPjWQ92Ko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84A461476;
	Fri, 23 Jan 2026 06:28:03 -0800 (PST)
Received: from e134369.cambridge.arm.com (e134369.arm.com [10.1.34.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B7AC3F740;
	Fri, 23 Jan 2026 06:28:08 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH kvmtool v5 0/7] arm64: Nested virtualization support
Date: Fri, 23 Jan 2026 14:27:22 +0000
Message-ID: <20260123142729.604737-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v5 of the nested virt support series, fixing a corner case when
some maintenance IRQ setup fails. Also there is now a warning if --e2h0
is specified without --nested. Many thanks to Sascha for the review!
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

Changelog v4 ... v5:
- bump kernel headers to v6.19-rc6
- print a warning if --e2h0 is given without --nested
- fail if the maintenance IRQ setting attribute is not supported

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
  Sync kernel UAPI headers with v6.19-rc6
  arm64: Initial nested virt support
  arm64: nested: Add support for setting maintenance IRQ

Marc Zyngier (4):
  arm64: Add counter offset control
  arm64: Add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers
  arm64: Handle virtio endianness reset when running nested

 arm64/arm-cpu.c                     |   6 +-
 arm64/fdt.c                         |   5 +-
 arm64/gic.c                         |  29 ++++++-
 arm64/include/asm/kvm.h             |  25 ++++--
 arm64/include/kvm/gic.h             |   2 +-
 arm64/include/kvm/kvm-config-arch.h |  11 ++-
 arm64/include/kvm/kvm-cpu-arch.h    |   5 +-
 arm64/include/kvm/timer.h           |   2 +-
 arm64/kvm-cpu.c                     |  64 ++++++++++++---
 arm64/kvm.c                         |  19 +++++
 arm64/timer.c                       |  29 +++----
 include/linux/kvm.h                 |  47 +++++++++++
 include/linux/virtio_ids.h          |   1 +
 include/linux/virtio_net.h          |  49 +++++++++++-
 include/linux/virtio_pci.h          |   3 +-
 powerpc/include/asm/kvm.h           |  13 ----
 riscv/include/asm/kvm.h             |  29 ++++++-
 x86/include/asm/kvm.h               | 116 ++++++++++++++++++++++++++++
 18 files changed, 394 insertions(+), 61 deletions(-)

-- 
2.43.0

