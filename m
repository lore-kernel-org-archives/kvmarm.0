Received: from mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC6347C10B
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327185; cv=none; b=gzUHI6zKEciGXSxkvC9SV1ii/tusWZcL4A1wzXHJ2BkG4/DUqEMGSbrcYp9P1UMWoO92FQ9TvD24vJk9+X6GtePR7cpGcKlKxEusu/SW0l4JGi99MjLF2QPm4xG1cISyd9WHref5DTIjnrAuwat3WioVh8r08ktctDtx8HEnFJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327185; c=relaxed/simple;
	bh=ZITxk4HraLSo7l0zjsQliO/uP2wjwsUcYzQpwin/yRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oRlqAYXhXTXX8kQ6qWavR9XNx9vJ3vcgDOR+WKoOrTRswDryMXr4ELSNj/RC0rOmnay1cV8TiwWeSs+8iFiK9kXHEvWROpBfscIaXH3fasLMlA3+1qWe7eivaVTUgur67U1VySU7yTgKedOGSW9kUaRR8886YZfSBWWtBad85no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JmohhVcg; arc=none smtp.client-ip=95.215.58.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JmohhVcg"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZITxk4HraLSo7l0zjsQliO/uP2wjwsUcYzQpwin/yRQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790327180; v=1; x=1790931980;
 b=JmohhVcgVsqSBcDGuC0e3WvDKsInmcrppCdikxY7yTDi3/3w03BhkfPu0pHcx81gGqgCOCDl
 7h2PYoUVNmUFbGciFDcsBSxXWq+ZyalOMblAnjazazweBO1TB48ZlmJt3rgb5f4XIhSSvK9vdKv
 edlFfy1HQQIXzB0jhdtWUCxs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9160c77694c73bbb;
	Fri, 25 Sep 2026 09:06:20 +0000
X-Mizu-Trace-ID: 9160c77694c73bbb
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/4] KVM: arm64: Fix HCR_EL2 for non-protected VMs in pKVM
Date: Fri, 25 Sep 2026 10:06:15 +0100
Message-Id: <20260925090619.852995-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

In pKVM, EL2 sets a non-protected VM's HCR_EL2 in pkvm_vcpu_reset_hcr(),
which covers only part of vcpu_set_hcr(), and takes only TWI, TWE and
VSE from the host. As a result, an AArch32 VM can't run, a VM can read
GMID_EL1 or execute a TLBI OS its ID registers hide, and the host's TVM,
VI and VF never reach it.

Rather than add each missing bit at EL2, the third patch uses the host's
HCR_EL2 on every entry, except for the bits EL2 owns. A bit added to
vcpu_set_hcr() then reaches pKVM with no change at EL2, unless it opens
state EL2 doesn't switch, in which case it goes in PKVM_HCR_EL2_OWNED,
as ATA and DCT do.

The third patch depends on the first: once TTLBOS reaches the VM, a
trapped TLBI OS from a non-nested guest hits a WARN in
handle_tlbi_el1(), as it does without pKVM.

The last patch adds a selftest that checks a feature hidden in an ID
register is UNDEFINED in the guest. Its TLBI OS case fails in pKVM
before the third patch.

VSE still comes from the host as before. Syncing it back after delivery
is a separate fix [1].

Based on Linux 7.3-rc4 (93f51579e7df2).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260921101030.1231605-1-fuad.tabba@linux.dev/

Fuad Tabba (4):
  KVM: arm64: Don't WARN on an unsupported TLBI OS from vEL1
  KVM: arm64: Clear HCR_EL2.RW for 32-bit non-protected vCPUs
  KVM: arm64: Use the host's HCR_EL2 for non-protected VMs in pKVM
  KVM: arm64: selftests: Check a feature hidden in an ID register is
    UNDEF

 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  13 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   7 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  24 ++-
 arch/arm64/kvm/sys_regs.c                     |   7 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/hidden_features.c     | 184 ++++++++++++++++++
 7 files changed, 222 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/hidden_features.c


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.39.5

