Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAC12C11D0
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 13:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815578; cv=none; b=p2blBviqhUHDPDOhZ3XKtBGF2lMYqd2rvgB5Kf/SaINslL+XRlZs2VrvLDoCiC30KT3m9pdSWxArVOtxqmYDKwAmV5hVFnLm1iB3Rlxl07z7UKdUke3N4usbB79krWXq21442qkUC7UNvWFgQokWJW7qnsYR+w3xKoZ3VaHylM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815578; c=relaxed/simple;
	bh=GwiFwREw0rCSXyWzYPDQPu4tkpjkebTbj9CPdLLG5AM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CgehKrVxei5mTFy/bEOykimyu7+sZx30ofyWAvBCFjHd+R5q13Vqp7IeudnxoQbHTkI+rKMkJ+/bWeJtqKh5gWkcvn+OmIgtt6jTtWK7zAZNYLLMrlZWosw1aGkQLN9dSmXtxI4k9VlMmwM3Kd6qe94v8EIFZkHXV4N+WoxB/18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2718339;
	Wed, 11 Feb 2026 05:12:49 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CF583F63F;
	Wed, 11 Feb 2026 05:12:54 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 0/6] arm64: Nested virtualization support
Date: Wed, 11 Feb 2026 13:12:43 +0000
Message-ID: <20260211131249.399019-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v6 of the nested virt support series, fixing an endianess bug
in the maintenance IRQ DT code, and rebasing.
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
nested virtualisation), and also advertise the virtual EL2 timer IRQ.

Tested on the FVP (with some good deal of patience) and QEMU.

Cheers,
Andre

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
 arm64/fdt.c                         |  5 ++-
 arm64/gic.c                         | 29 ++++++++++++-
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 ++++-
 arm64/include/kvm/kvm-cpu-arch.h    |  5 ++-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 64 ++++++++++++++++++++++++-----
 arm64/kvm.c                         | 20 +++++++++
 arm64/timer.c                       | 29 ++++++-------
 10 files changed, 133 insertions(+), 40 deletions(-)

-- 
2.47.3
