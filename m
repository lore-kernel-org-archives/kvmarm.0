Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B0280C02
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724448448; cv=none; b=fGtmi6PIwBYVWvi64w1wXR/fGR7UqX/czTOhljrDjabwFR5bhK3EH0a4GLiyXut72RZPVjTcSx24OoPl3QslJdIHQAk5A6x4oFm5R71Uc4qafzqvxB8AWyqfy7FZ0u3qpJIttUxEPKDZXncbIk7jvAUM8sQkfqrDNm2P5Pql2Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724448448; c=relaxed/simple;
	bh=UN75N7u9kgIBbLyrBPENF/qle2S5zLqBOchCNtBBXiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nGr5L2udJqUk9APjba1r0hCDRfU3mVQiKYZSwE+wV4qAWHzYZZt7uWVQUK9IHByLWoLtG+SH0akbSzHdoIdDQdMn2FQIEa3v9cgW9VVfTJNpVQxzC0kcF522x59HFcyrQRIIEbgj8sAY7JXSU7A4y+Q0UhkFu8XjFd5zx/wow0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KPjW9x9s; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KPjW9x9s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724448442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U/KCmivpEAcPokV1whcNtbbTcN8czkWIDLJpXrNOGf0=;
	b=KPjW9x9svnQgPZPxj/ijXhVs1yo+Gmvin+36Hsa32D2O0t8o8o8pXkCE4UyIq+CRSxOl8m
	LGJSUxeDTR1rwY53Wd6jy5UtXduTt7iUI1Ysm9xXd7b+x8X9ku5qKdXCVinibNtqpc4/bk
	uUlxcE6vlFdTzTjujBHC5MhNwoSoNVI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: nv: Fix nested IRQ exception storm on NV+GICv4
Date: Fri, 23 Aug 2024 21:27:00 +0000
Message-ID: <20240823212703.3576061-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

There's a rather annoying collision between nested virt and GICv4 that
leads to a storm of nested excpetions taken to the L1, meaning the L2
can never get off the ground.

Here's a small series to address the immediate issue + ensure IRQs
destined for the L1 aren't erroneously masked by running an L2.

Marc, I've deliberately based this on top of upstream rather than the NV
series. I did this to avoid stacking more crap on top of the out of tree
series. The fact we don't virtualize GICv4 for the L1 isn't really
up for discussion right now, so taking that limitation ahead of full
nested VGIC support seems OK.

Note that I spun off a small portion of the nested VGIC patch which avoids
making the vPE resident in nested state to give the full picture of how
the vPE is managed while nested.

Oliver Upton (3):
  KVM: arm64: nv: Leave vPE nonresident in nested vgic state
  KVM: arm64: Move host SVE/SME state flags out of vCPU
  KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2

 arch/arm64/include/asm/kvm_host.h | 28 ++++++++++++++++++----------
 arch/arm64/kvm/emulate-nested.c   |  2 ++
 arch/arm64/kvm/fpsimd.c           | 12 ++++++------
 arch/arm64/kvm/vgic/vgic-v3.c     | 15 ++++++++++++++-
 arch/arm64/kvm/vgic/vgic-v4.c     | 18 +++++++++++++++++-
 include/kvm/arm_vgic.h            |  5 +++++
 6 files changed, 62 insertions(+), 18 deletions(-)


base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.46.0.295.g3b9ea8a38a-goog

