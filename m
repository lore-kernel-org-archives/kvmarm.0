Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE26311C2A
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 19:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861565; cv=none; b=LwxEm4u7AIv++K6FODDMBXQbnbVUXLIhy0ZTplTdyr34ouKwO9ppJ6o3+dmFQMjw1BCKygPLujiz+l60YQMRPsZ1VTcrb3xdzFAoS1xj/Fsk48xAOyiKK0AZwUqW6E6wyshIsQME50mPfJUqWaYnt4C+E1x4Ywsjf9GQp8c1gME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861565; c=relaxed/simple;
	bh=iOiYMYWdvapsqU9gHuWUDcqRMVlMEgNDCc6GEEiP8Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tClhjOgzYCnkl0IrrrkWulvma2Inat8uL20VxYv9rvM+1nStdoCmM7W3EahXrkVKLFENofi+VTUbCN3IKy93f/5eT2cQLq8FR0DlgxyUB4C98jAbZ3xITurYQcgD7+7G66HurH/M+GR70HqFC5QYdoSziljovcyQLKVJDXUGgdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 819CF1BF7;
	Wed, 18 Mar 2026 12:19:15 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB4863F73B;
	Wed, 18 Mar 2026 12:19:19 -0700 (PDT)
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
Subject: [PATCH v2 0/4] arm64: Work around C1-Pro erratum 4193714 (CVE-2026-0995)
Date: Wed, 18 Mar 2026 19:19:12 +0000
Message-ID: <20260318191918.2653160-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

That's version 2 of the workaround for C1-Pro erratum 4193714. Version 1
was posted here:

https://lore.kernel.org/r/20260302165801.3014607-1-catalin.marinas@arm.com/

The logic is pretty much the same, we use a global sme_active_cpus mask
to track which CPUs run in user-space with SME enabled and an IPI is
sent to those CPUs to synchronise the TLB maintenance.

Main changes since v1:

- The workaround won't be enabled if SME is disabled

- Replace the __tlbi_sync_s1ish(NULL) calls from arch_tlbbatch_flush()
  with a dedicated __tlbi_sync_s1ish_batch() function

- Dropped the DMB in sme_set_active() before returning to user, replaced
  it with a comment and a link to the list discussion on why it is not
  necessary

- Use alternative_has_cap_unlikely() instead of cpus_have_final_cap()
  since it's a local CPU erratum feature and only used after the
  capabilities have been finalised

I'll post a separate RFC patch (linked here) showing how using a per-mm
cpumask looks like. The downside of that approach is that
arch_tlbbatch_add_pending() will require a DSB, practically cancelling
any TLBI batching for unaffected CPUs. Yet another option would be to
add a struct mm and some flag in struct arch_tlbflush_unmap_batch and
use full global broadcast if more than one mm is targeted or
mm_cpumask() otherwise. Given that this is used on the TTU path, it's
possible to have more than one owner of an unmapped page. I haven't done
any assessment how of this would happen.

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

Thanks.

Catalin Marinas (3):
  arm64: tlb: Introduce __tlbi_sync_s1ish_{kernel,batch}() for TLB
    maintenance
  arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()
  arm64: errata: Work around early CME DVMSync acknowledgement

James Morse (1):
  KVM: arm64: Add SMC hook for SME dvmsync erratum

 arch/arm64/Kconfig                    | 12 ++++
 arch/arm64/include/asm/cpucaps.h      |  2 +
 arch/arm64/include/asm/cputype.h      |  2 +
 arch/arm64/include/asm/fpsimd.h       | 21 +++++++
 arch/arm64/include/asm/mmu.h          |  1 +
 arch/arm64/include/asm/tlbflush.h     | 50 ++++++++++++++---
 arch/arm64/kernel/cpu_errata.c        | 30 ++++++++++
 arch/arm64/kernel/entry-common.c      |  3 +
 arch/arm64/kernel/fpsimd.c            | 81 +++++++++++++++++++++++++++
 arch/arm64/kernel/process.c           |  7 +++
 arch/arm64/kernel/sys_compat.c        |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 17 ++++++
 arch/arm64/tools/cpucaps              |  1 +
 include/linux/arm-smccc.h             |  5 ++
 14 files changed, 225 insertions(+), 9 deletions(-)

