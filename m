Received: from out-200.mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0695B262BF
	for <kvmarm@lists.linux.dev>; Wed,  4 Oct 2023 23:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d1j923p0"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696463405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zrlS9qShL+VBMvCHeJefZmgBz6EH2IBmaUJdenIoZgI=;
	b=d1j923p0/uoPLgf2+CYvNqHe8Bz0muO4MALTRk1ZmYuvZ4pvS62fhzQcb98xMUzlo0BpSW
	nx+NGceMhJe4+yEqS54WNR+kFJxyZD9U7pE4IXXdrNsNYXYZVee7pUgge7TB5hQiox1gy+
	J9A+TYmZO3wtqpKLX4+h7TuelArSszc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Cleanups for managing SMCCC filter maple tree
Date: Wed,  4 Oct 2023 23:49:44 +0000
Message-ID: <20231004234947.207507-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Small series to clean up the way KVM manages the maple tree
representation of the SMCCC filter, only allocating nodes in the tree if
the SMCCC filter is used.

The other ugly bit that this fixes is the error path when 'reserved'
ranges cannot be inserted into the maple tree, instead returning an
error to userspace.

Oliver Upton (3):
  KVM: arm64: Add a predicate for testing if SMCCC filter is configured
  KVM: arm64: Only insert reserved ranges when SMCCC filter is used
  KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured

 arch/arm64/include/asm/kvm_host.h |  4 +---
 arch/arm64/kvm/hypercalls.c       | 34 ++++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 15 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.609.gbb76f46606-goog

