Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F94AA1F2
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 12:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982525; cv=none; b=UMOM9/OKdTa05AFBhDMRQLxKTK+YfsWDEOORtP6EiyMDXnTzRuuhLqmXMneJ8z+p4nZ2HmSM+YiG22wf6ZQrtp1fs7hDXFfDG0isDXuSB84ODNXCIilIh2Osw5z0A7qlgQisALZN70SaVb+/Oh9mxdm5F81XCG83TEBoDOGJP+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982525; c=relaxed/simple;
	bh=pJBToGHsJMC6/kg5jWs+Mtib+z5TjGaiaQJZnJjpmkk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Dtnv5IxVt9ru7ykLZ8WKsk6v7BzJTfqL2Tg+k7PHcEVsK4xeiezMAsGbomAFlFtQUVo+PEYvElfC12C7EVlzMvIJGVFeM5eVN5LVTm4cF14ztBxH4nZJMHcaOHYGyeq7mnsryKBWbO2GK4/FhToZO0yb8MaecYN5+gzSI64vxow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WPaBA/Hw; arc=none smtp.client-ip=91.218.175.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WPaBA/Hw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pJBToGHsJMC6/kg5jWs+Mtib+z5TjGaiaQJZnJjpmkk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791982513; v=1; x=1792587313;
 b=WPaBA/HwgY+tZeMAg6kf+GOwzWUpq9ktnmYc9UmzX87qeVgLYJgJ4j8HMnDwqh5iRAqLuOXN
 WUPG9uFRz2OdgMsZ5MiKFu7xaTGj/GmqAsZMXOS9Ixv2sKKXjwqrSz7PeKfCu4qS2t3Kd6sRChp
 s6RoZ+duXicG38/1/q5bU1gY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8a582e26eeccef1c;
	Wed, 14 Oct 2026 12:55:10 +0000
X-Mizu-Trace-ID: 8a582e26eeccef1c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: arm64: Per-vCPU TLB and I-cache flush in pKVM
Date: Wed, 14 Oct 2026 13:55:08 +0100
Message-Id: <20261014125510.2928306-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Since 6.14, protected and non-protected pKVM guests run on the
hypervisor's VMID. The host no longer flushes a CPU's TLBs and I-cache
when a different vCPU of the same VM is loaded there, so vCPUs of one
guest can hit each other's entries. This series adds the flush at EL2.

An earlier version of these patches was in Will's pKVM base series in
2022 [1], but didn't make it into its later versions.

This series is based on kvmarm/next because the hyp VM is allocated with
hyp_alloc() there, and the per-CPU array it adds is allocated the same
way.

Based on kvmarm/next (dd0bc00e3e920).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/

Fuad Tabba (2):
  KVM: arm64: Track physical CPU number at EL2
  KVM: arm64: Ensure TLBs and I-cache are private to each vCPU in pKVM

 arch/arm64/include/asm/kvm_hyp.h       |  3 +++
 arch/arm64/kvm/arm.c                   |  3 +++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  8 ++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c      |  2 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 21 ++++++++++++++++++---
 6 files changed, 37 insertions(+), 3 deletions(-)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.39.5

