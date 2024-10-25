Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7E1FB89D
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 20:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888282; cv=none; b=kTuf8hnblQBi0GsK5SaZsW+Vml1AryEK/SaIpedCdSLGcu5pmSvngJP60s1FgxAr+MEIE7ttiREGZLGp98/5Em6LcR5YD9c4/LOsLOShm5wpgDpH3xvtA9rPmRSV13TXCkIH6wIXJ4hwCronQLCimEVToEnzE8tKwUIrIqrGpVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888282; c=relaxed/simple;
	bh=oxXZPi2L6BQcCuSnWGhBgUsgprdsHxrzKnmzEPKS8Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OfD6i+LwD0HsWWI8N+ibwo1eJbVlMuJFhBd9BHYGgIqO7oOZ9mPw9AxtY37SBpi7Owz2wtjRfCXx2Yd2MGZB3Xip5uwtosmMiJASBtlvLxEH2IJHaYPOASKHuwOuOUSZka2yYiuYTgQbC+rtHwbLQ360TUpv6DoaqkjULOr0U74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=duklsBpK; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="duklsBpK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729888276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+LxydfeW6CylOVfo0petMC6IZWMHJbn96M0B111nONA=;
	b=duklsBpKNFsjDGqhEqSMg4y6vNhgOeBuvBHH46HfsyvvXZUnZUtaaMbVOa8AGS/vEIFhaL
	xMwsHj4fAnaOKS4EOKfiqu1V7QeII+igfC/UGeETGo+qVgLAVQ9m5JQexs6oy099LLVyQd
	SQ9VRHMEWyZSUSvDsNpTMwxYvaiQa+g=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/4] KVM: arm64: Fix splat/misbehavior for MMIO SEA injection
Date: Fri, 25 Oct 2024 20:31:02 +0000
Message-ID: <20241025203106.3529261-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v1 -> v2:
 - Make it clear that the series is referring to synchronous external
   aborts (i.e. SEAs)
 - Move helper out of header
 - Pull esr + friends into tools, for use in KVM selftests

v2: https://lore.kernel.org/kvmarm/20241018194757.3685856-1-oliver.upton@linux.dev/

Oliver Upton (4):
  KVM: arm64: Don't retire aborted MMIO instruction
  tools: arm64: Grab a copy of esr.h from kernel
  KVM: arm64: selftests: Convert to kernel's ESR terminology
  KVM: arm64: selftests: Add tests for MMIO external abort injection

 arch/arm64/kvm/mmio.c                         |  32 +-
 tools/arch/arm64/include/asm/brk-imm.h        |  42 ++
 tools/arch/arm64/include/asm/esr.h            | 455 ++++++++++++++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/debug-exceptions.c  |  10 +-
 .../selftests/kvm/aarch64/mmio_abort.c        | 159 ++++++
 .../selftests/kvm/aarch64/no-vgic-v3.c        |   2 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../kvm/aarch64/vpmu_counter_access.c         |  12 +-
 .../selftests/kvm/include/aarch64/processor.h |  15 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   6 +-
 11 files changed, 706 insertions(+), 32 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/brk-imm.h
 create mode 100644 tools/arch/arm64/include/asm/esr.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/mmio_abort.c


base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
-- 
2.47.0.163.g1226f6d8fa-goog

