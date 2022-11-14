Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A89A847C
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 20:11:40 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668456698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c7eJcRQB0lx33rMvbkdk1U8UPwvqiEcNke7dhs9bXxk=;
	b=AsNWEzgq6M5I0JGjE3dhOXIXHo/2w12Pduf1EO+Yld+orfYsqG1+y+cmisW/BFDIU7ILBd
	860xTFmL+rX+U6HWpuhbcvzXAw3C9eC6dlLZu9rfYXnO3kGsxYS+Al0h4l7x7NgDCe+Wv9
	cjAPYp4tuawq+rrX19NYZ3yQ3xeRHg0=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/1] KVM: arm64: Skip RCU protection for hyp stage-1
Date: Mon, 14 Nov 2022 20:11:26 +0000
Message-ID: <20221114201127.1814794-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221114201126.nflJS-RTfc_MreNE2Hz27W5Rd0WbaF-0kDGZz6ybYGo@z>

Whelp, that was quick.

Marek reports [1] that the parallel faults series leads to a kernel BUG
when initializing the hyp stage-1 page tables. Work around the issue by
never acquiring the RCU read lock when walking hyp stage-1. This is safe
because hyp stage-1 is protected by a spinlock (pKVM) or mutex (regular
nVHE).

The included patch applies to the parallel faults series. To avoid
breaking bisection, the patch should immediately precede commit
c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). Or, if
preferred, I can respin the whole series in the correct order.

Tested with the pKVM isolated vCPU state series [2] merged on top, w/
kvm-arm.mode={nvhe,protected} on an Ampere Altra system.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>

[1]: https://lore.kernel.org/kvmarm/d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com/
[2]: https://lore.kernel.org/linux-arm-kernel/20221110190259.26861-1-will@kernel.org/

Oliver Upton (1):
  KVM: arm64: Use a separate function for hyp stage-1 walks

 arch/arm64/include/asm/kvm_pgtable.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 18 +++++++++++++++---
 3 files changed, 40 insertions(+), 4 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

