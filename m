Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A513B3BB9F3
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 06:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790578008; cv=none; b=EboHfrbjn5Qe+14pc2B2sXulNqcNPn61aWeSYbVWYtSMgJQ0pqSJOz8qc7QNIWjRG4VGRaCx5Cr1Pikw9QbUoAbTwCc6X9WG1Dl2SKgUnT8wxTUSiiw6I0PPDgjQKgTvmF3DuCSxXqWHbX54UdZiJyHhoUT8FGO8KL0hr4bY8YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790578008; c=relaxed/simple;
	bh=6ivHM1djiyNApPfmgTiRMC+kHX/ImCj+9xjrPFQgQi4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sDWs8pXVH5R3WjzhRSJTviKk1yhcuJ/xl+4owZ5J5TbS01QuIy+GY+zq6t6KM4ZpuWgIHsPx4+KBaH5BCmVI0oe45S4jgAK0X6ZswMDGVn+uSiqdpRsqeLd4Jl3ZYjOOg4ZBDMpqx2uSKvbWSaKEpisGdkilu5FRsnjKz/k4WO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aAnQlglh; arc=none smtp.client-ip=91.218.175.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aAnQlglh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6ivHM1djiyNApPfmgTiRMC+kHX/ImCj+9xjrPFQgQi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790578004; v=1; x=1791182804;
 b=aAnQlglhVL8NR8DwUi32fX0WPb1wl0Ov84kG0bRmcFLd96Rw9GW4BvqRo1BFn+y3NxaiRdcg
 K80AbHVpLRSkXwwcGMxQsASJTf4/LX4ModWu1+4SOun5CTEqkOS4qGnptr/ByeBW10UOXx/Ox8S
 5xtaQ3x2m8Tj9rYarXYR190s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eace2c2eb089f675;
	Mon, 28 Sep 2026 06:46:44 +0000
X-Mizu-Trace-ID: eace2c2eb089f675
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: arm64: Fix HCR_EL2 for non-protected VMs in pKVM
Date: Mon, 28 Sep 2026 07:46:39 +0100
Message-Id: <20260928064643.3265087-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
- Patch 3: take a list of host bits per VM type instead of the host's
  value minus the bits EL2 owns; drop the HCR_GPF definition (Marc).
- Patches 2 and 3: use the HCR_EL2_* names in added lines (Marc).
- Patches 1-3: reworded the messages, and the comment in patch 2
  (Marc).
- Patch 1: collected Wei-Lin's Reviewed-by.

In pKVM, EL2 sets a non-protected VM's HCR_EL2 in pkvm_vcpu_reset_hcr(),
which misses the RW, TID5 and TTLBOS handling of vcpu_set_hcr(), and
takes only TWI, TWE and VSE from the host. As a result, an AArch32 VM
can't run, a VM can read GMID_EL1 or execute a TLBI OS its ID registers
hide, and the host's TVM, VI and VF never reach it.

The second patch clears RW for an AArch32 vCPU. The third also takes
from the host, for a non-protected VM, the bits the host varies with the
VM's configuration or at runtime: VI, VF, TVM, TID2, TID4, TID5 and
TTLBOS. The rest stay EL2's, and a protected VM still takes only TWI,
TWE and VSE.

The third patch depends on the first: once TTLBOS reaches the VM, a
trapped TLBI OS from a non-nested guest hits a WARN in
handle_tlbi_el1(), as it does without pKVM.

The last patch adds a selftest that checks a feature hidden in an ID
register is UNDEFINED in the guest. Its TLBI OS case fails in pKVM
before the third patch.

VSE still comes from the host as before. Syncing it back after delivery
is a separate fix [2].

Based on Linux 7.3-rc4 (93f51579e7df2).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260925090619.852995-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260921101030.1231605-1-fuad.tabba@linux.dev/

Fuad Tabba (4):
  KVM: arm64: Don't WARN on an unsupported TLBI OS from vEL1
  KVM: arm64: Clear HCR_EL2.RW for 32-bit non-protected vCPUs
  KVM: arm64: Use the host's HCR_EL2 for non-protected VMs in pKVM
  KVM: arm64: selftests: Check a feature hidden in an ID register is
    UNDEF

 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   9 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   7 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  25 ++-
 arch/arm64/kvm/sys_regs.c                     |   7 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/hidden_features.c     | 184 ++++++++++++++++++
 6 files changed, 218 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/hidden_features.c


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.39.5

