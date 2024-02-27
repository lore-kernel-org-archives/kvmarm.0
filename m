Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4792B136665
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 09:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709026890; cv=none; b=EpTrwT7/J5xc5i54KWgcbcWSr4yegUCWzI6d49xoNTBANdkw+puVMYiHys6JWcQIBA6Z831UceVuheMD4Oconz9KGuuwdZXLjEESmnTADaC3P7u03MtmEvki/ZGw2FKCdvRln9o3JdQLgcOCg11UaLWnASE38IWULuIvTcQUb4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709026890; c=relaxed/simple;
	bh=WPyrtYT5ScpkQO5i+55ZXscdGvXUbUA8rdVx7gi9sCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Muat3KY3H7PC5DR+z87FWODB6RUFf6AuEZwD+Vo/5XFL4V/4IxxaIb19EE/OThyRgbuNEWLfpWHlXXh5fCeloIGkkiCT2Sv7eOD8SWIFgsn2IY/LsWaHuT3xlP1mBG0eHMlsK7PGptleIjfZsMQf9gO6CfoJAcA7fpwqXCYxpOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vP23l7/u; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vP23l7/u"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709026886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DX/bkJhR5P/i5Xq9xeVM29IcZO+WNbaLbVBDnzVYu1g=;
	b=vP23l7/uLKr9BqAsg2InsEVQg1zrwriEQWFwmN763KsIM6V2r+E9aA8oP1CJ/YQvuN5urf
	I1apj6F7b4TN6XsCGlcoQhjoa/5fJT5r6HsT5eTmcW0JgCd5pJ4EfvHU//sCBM65TjaadP
	zyDWqZccBj6Pac/D9qUiQnZOQYT+gm4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Fix splat relating to idregs debugfs
Date: Tue, 27 Feb 2024 09:41:13 +0000
Message-ID: <20240227094115.1723330-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Looks like we're calling in to debugfs w/ preemption disabled, which
explodes when trying to take the parent inode's rwsem.

This is easy enough to work around, and we can just initialize at the
time of VM creation. No idreg values yet? Too bad, just kick an error
back at the user. All two of them.

Applies to kvmarm/next.

Oliver Upton (2):
  KVM: arm64: Fail the idreg iterator if idregs aren't initialized
  KVM: arm64: Don't initialize idreg debugfs w/ preemption disabled

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  4 ++++
 arch/arm64/kvm/sys_regs.c         | 16 ++++++++++------
 3 files changed, 15 insertions(+), 6 deletions(-)


base-commit: bec0d120679f0033cca017e8f9e0f3782d261dc7
-- 
2.44.0.rc1.240.g4c46232300-goog

