Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7757F3BE168
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283055; cv=none; b=Am6+h394K8qCjOLTVwiqwFLkXtlOLjP3sQV7LIHMSOVYq1QcgZov4zQkCFmsjfCtE75tfHGGR2Sb/wpmXQWp1UCCsMkPdHLIyo1CP80nt/uqQcQr/tUce+R49aXUebNZdZnerwgCFZo+AvuVdkdl3OGCoxpfvL+UpOw4W3bmNuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283055; c=relaxed/simple;
	bh=j7t8Rj0Szk6tqCh2keHIRgTb7GDrsJLDKcLZyhevSAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PGHcwhyhFRwe5XY/aWo7h5FExCcT7piQmLw53RUdau85wdDgyS21Wzkv3JaaOIECnp+xFLCu9SW1o/NjPVvKbZ3Wd2QI3madcG/eDhcK+nf/wjlKp83s6zxv31X868eV6GxNfX67OgbCiFyo6/ZMy6sogKoyhKRr3ZwWc4yG7ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5D2114BF;
	Mon, 23 Mar 2026 09:24:06 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44CAD3F73B;
	Mon, 23 Mar 2026 09:24:11 -0700 (PDT)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 0/5] arm64: Work around C1-Pro erratum 4193714 (CVE-2026-0995)
Date: Mon, 23 Mar 2026 16:24:00 +0000
Message-ID: <20260323162408.4163113-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's version 3 of the workaround for C1-Pro erratum 4193714. Version 2 was
posted here:

https://lore.kernel.org/r/20260318191918.2653160-1-catalin.marinas@arm.com

Main changes since v2:

- Renamed the config option, cpucap and SMCCC macro to include the
  '4193714' suffix instead of 'SME_DVMSYNC'

- Pushed smp_processor_id() into sme_{set,clear}_active()

- Updated silicon-errata.rst

- Moved the CPU part definition to a separate patch

Erratum description:

Arm C1-Pro prior to r1p3 has an erratum (4193714) where a TLBI+DSB
sequence might fail to ensure the completion of all outstanding SME
(Scalable Matrix Extension) memory accesses. The DVMSync message is
acknowledged before the SME accesses have fully completed, potentially
allowing pages to be reused before all in-flight accesses are done.

The workaround consists of executing a DSB locally (via IPI)
on all affected CPUs running with SME enabled, after the TLB
invalidation. This ensures the SME accesses have completed before the
IPI is acknowledged.

This has been assigned CVE-2026-0995:

https://developer.arm.com/documentation/111823/latest/

Catalin Marinas (4):
  arm64: tlb: Introduce __tlbi_sync_s1ish_{kernel,batch}() for TLB
    maintenance
  arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()
  arm64: cputype: Add C1-Pro definitions
  arm64: errata: Work around early CME DVMSync acknowledgement

James Morse (1):
  KVM: arm64: Add SMC hook for SME dvmsync erratum

 Documentation/arch/arm64/silicon-errata.rst |  2 +
 arch/arm64/Kconfig                          | 12 +++
 arch/arm64/include/asm/cpucaps.h            |  2 +
 arch/arm64/include/asm/cputype.h            |  2 +
 arch/arm64/include/asm/fpsimd.h             | 21 +++++
 arch/arm64/include/asm/mmu.h                |  1 +
 arch/arm64/include/asm/tlbflush.h           | 50 ++++++++++--
 arch/arm64/kernel/cpu_errata.c              | 30 +++++++
 arch/arm64/kernel/entry-common.c            |  3 +
 arch/arm64/kernel/fpsimd.c                  | 89 +++++++++++++++++++++
 arch/arm64/kernel/process.c                 |  7 ++
 arch/arm64/kernel/sys_compat.c              |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c       | 17 ++++
 arch/arm64/tools/cpucaps                    |  1 +
 include/linux/arm-smccc.h                   |  6 ++
 15 files changed, 236 insertions(+), 9 deletions(-)

