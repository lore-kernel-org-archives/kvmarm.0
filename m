Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1829636A01E
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 14:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003776; cv=none; b=iElLEqtIuTLsDPqasWVjI+it6SPVrUFvyRNjUM8Z6HgGRn4R8C7KkX8ipRonqJVYDdNzcKXGdrcYFw9+s9fYWAEyvvrAFgRi/Vd6RfGjHc8cN/CqZ+RRvcyDNCcvNXPjfzJ+K7J7ffjtntq10A+pv1P2kpFiLKFv0JPiuOBSkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003776; c=relaxed/simple;
	bh=x5b6a2lnu4dYKEG9M/n+bLgsEZhpt2lX5ouBIpHYT7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VUCRl4xw3YEWuvsuQkiWrQW3enpdH/0nuRRaQSRxYYlao9/gBWtumw3+OB5Sj/P/zELgsVtixZhi4Mkl6XrrtGNR2GO236pORMaJO9Uu1ex6JlHKwMq/8YwAOitmhVcVzmUPdIFoPlzSTL573Ida09OTyk1+bNeCeqgmCyP6X+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q4w/sVDe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q4w/sVDe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A98523555;
	Sun, 12 Apr 2026 07:22:39 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B0CE3F641;
	Sun, 12 Apr 2026 07:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776003765; bh=x5b6a2lnu4dYKEG9M/n+bLgsEZhpt2lX5ouBIpHYT7E=;
	h=From:To:Cc:Subject:Date:From;
	b=Q4w/sVDeLN62hSuLNCnXhATJ2i/gfeOMvOG5WNLbhewr1EplLMWXzA1GqhytEX2k8
	 AdtE9x/iT/pZ3CTmEjXx8xhJDdHNP4XYgr2mBlZhnTvaMBcAY1WxPwOuPzmpNJmDa0
	 ywOcA5dEIqotsHAmui1HLFUb6j0GnTWm+8FGi4Ak=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 0/4] KVM: arm64: selftests: Basic nested guest support
Date: Sun, 12 Apr 2026 15:22:12 +0100
Message-ID: <20260412142216.3806482-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of adding basic support for running nested guests (L2) in
kselftest. After getting feedback from v1 [1], I mostly started over
from scratch. Therefore you won't lose any context if you start here.
Nonetheless, I still compiled the broad changes.

Patch 1 adds GPR save/restore code for guest, and vEL2 exception
vectors.

Patch 2 adds other hypervisor helpers.

Patch 3 adds the hello_nested selftest to jump from vEL2 -> EL1 -> vEL2.

Patch 4 enhances the hello_nested selftest so that vEL1 handles a
hypercall from EL1.

* Changes from v1 [1]:

  - Set HCR_EL2.E2H for the guest.

  - Pivoted from "userspace setting up everything" to "make L1 more like
    a proper hypervisor". Guest EL2 exception vectors, and GPR
    save/restore are added. There is also some infrastructure to
    save/restore system registers, right now only SP_EL1 is
    saved/restored to give L2 a stack. More system registers can be
    added in the future.

  - Removed the stage-2 page table generator. The stage-2 page table
    generator was bad, and the changes needed for the previous point
    alone is already making the series larger, so I decided to not add
    any guest stage-2 code in this iteration.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260325003620.2214766-1-weilin.chang@arm.com/

Wei-Lin Chang (4):
  KVM: arm64: selftests: Add GPR save/restore functions for NV
  KVM: arm64: sefltests: Add helpers for guest hypervisors
  KVM: arm64: sefltests: Add basic NV selftest
  KVM: arm64: selftests: Enhance hello_nested test

 tools/testing/selftests/kvm/Makefile.kvm      |   4 +
 .../selftests/kvm/arm64/hello_nested.c        | 132 +++++++++++++++++
 .../selftests/kvm/include/arm64/nested.h      |  62 ++++++++
 tools/testing/selftests/kvm/lib/arm64/entry.S | 137 ++++++++++++++++++
 .../selftests/kvm/lib/arm64/hyp-entry.S       |  77 ++++++++++
 .../testing/selftests/kvm/lib/arm64/nested.c  |  58 ++++++++
 6 files changed, 470 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/entry.S
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c

-- 
2.43.0

