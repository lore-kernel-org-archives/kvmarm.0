Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F766309F09
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 16:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772470687; cv=none; b=bD2KF0E6VQaWBZlbzRlwCl0fO3tBwW+iMGxrb9LehWMLHZir/uwqEV7WLySd6JHjV0DQXNH22IX/cbDmsxaevcmnffz1SaYnOMKb8GYl7q8ntmvBKPF+V1PwCCHXLVqaeUgB8hDPXCyZTq6EXvSdXSqTdq46BxqFkzGpegG1s1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772470687; c=relaxed/simple;
	bh=/99JAUsVtE8WBOwArtrzVruuzX89NXALoSpZPPXF/GA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PRfgARqW9T+MMDihiBMnN9FYuUItF3mpJywBCrr6Rv4/TnIw3FI7cof72/3G4LhswIj77injEhbTvMo3J7Xtr8/sQUSynpwY1WjghVAuZ2F5oW4W3K4NaDMC1DqI3ytWuM/08dyl6ij81MaUKvPTG9sphRvTSzDJq0Fu6aIFuCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBB7C19423;
	Mon,  2 Mar 2026 16:58:04 +0000 (UTC)
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
Subject: [PATCH 0/4] arm64: Work around C1-Pro erratum 4193714 (CVE-2026-0995)
Date: Mon,  2 Mar 2026 16:57:53 +0000
Message-ID: <20260302165801.3014607-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm C1-Pro prior to r1p3 has an erratum (4193714) where a TLBI+DSB
sequence might fail to ensure the completion of all outstanding SME
(Scalable Matrix Extension) memory accesses. The DVMSync message is
acknowledged before the SME accesses have fully completed, potentially
allowing pages to be reused before all in-flight accesses are done.

The workaround consists of executing a DSB locally (via IPI)
on all affected CPUs running with SME enabled, after the TLB
invalidation. This ensures the SME accesses have completed before the
IPI is acknowledged.

The first two patches are preparatory: patch 1 adds
__tlbi_sync_s1ish_kernel() to distinguish kernel from user TLB
maintenance; patch 2 passes the mm_struct to __tlbi_sync_s1ish().

Patch 3 implements the actual erratum workaround for the kernel
(non-virtualised) case. It applies only to user mappings and limited to
tasks using SME (tracked via a new MMCF_SME_DVMSYNC flag) and running at
EL0. The smp_call_function() does not need an explicit DSB on the
interrupted CPUs since SCTLR_EL1.IESB=1 forces the completion of SME
accesses when entering the kernel from EL0.

Patch 4 handles the pKVM case. The aim is to ensure the kernel will not
compromise the security of protected guests. pKVM delegates the
workaround to EL3 via an SMC call (to Trusted Firmware-A). The TF-A
patches are provided separately in the project's repository.

Since SME in guests is not currently supported, no additional KVM
workaround needed to prevent guests from exploiting the erratum.

This has been assigned CVE-2026-0995:

https://developer.arm.com/documentation/111823/latest/

Backports available here (no stable-6.12.y since SME is not supported):

https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git errata/c1-pro-erratum-4193714-stable-6.19.y
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git errata/c1-pro-erratum-4193714-stable-6.18.y
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git errata/c1-pro-erratum-4193714-android16-6.12-lts

Thanks.

Catalin Marinas (3):
  arm64: tlb: Use __tlbi_sync_s1ish_kernel() for kernel TLB maintenance
  arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()
  arm64: errata: Work around early CME DVMSync acknowledgement

James Morse (1):
  KVM: arm64: Add SMC hook for SME dvmsync erratum

 arch/arm64/Kconfig                    | 12 ++++
 arch/arm64/include/asm/cpucaps.h      |  2 +
 arch/arm64/include/asm/cputype.h      |  2 +
 arch/arm64/include/asm/fpsimd.h       | 29 ++++++++++
 arch/arm64/include/asm/mmu.h          |  1 +
 arch/arm64/include/asm/tlbflush.h     | 39 ++++++++++---
 arch/arm64/kernel/cpu_errata.c        | 19 +++++++
 arch/arm64/kernel/entry-common.c      |  3 +
 arch/arm64/kernel/fpsimd.c            | 81 +++++++++++++++++++++++++++
 arch/arm64/kernel/process.c           |  7 +++
 arch/arm64/kernel/sys_compat.c        |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 17 ++++++
 arch/arm64/tools/cpucaps              |  1 +
 include/linux/arm-smccc.h             |  5 ++
 14 files changed, 211 insertions(+), 9 deletions(-)

