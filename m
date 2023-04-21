Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50D417EF
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 07:16:24 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1682061382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IP96PoYHynLtiAulB8dvzaBWzbM84JCmBXgodBlJnKo=;
	b=jRxubiFLaXre7CSnKYj/hUkbcL4akTR2aZWGq4jkHAJ7FSJrFsP4kh1zz9I4BI5So2tOR3
	RaI7M2jFOUdoLJHEK+Pc+xhT7h4z+xyV9aZg7qMyChgoGdBoT1l2hHNdYO6rpQl6tTn5Te
	c4/eq1DL80mH2PHWmgYD1sOp9ZsJH08=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	David Matlack <dmatlack@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Fix for mapping incorrect PA at stage-2
Date: Fri, 21 Apr 2023 07:16:04 +0000
Message-ID: <20230421071606.1603916-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ugh.

So it appears that there is a race between two parallel stage-2 map
walkers that could lead to mapping the incorrect PA for a given IPA, as
the IPA -> PA relationship picks up an unintended offset. This series
eliminates the problem by using the current IPA of the walk as the
source-of-truth regarding where we are in a map operation. If you're
curious about the race, it is spelled out in the first patch.

While there is no such race to update hyp's stage-1, the second patch
applies the same rationale to hyp stage-1 walks for the sake of
consistency.

Applies to 6.3-rc3, and merges w/o conflict into kvmarm/next. Took this
for a ride with selftests, kvm-unit-tests, QEMU, and our internal VMM
(affectionately referred to as Vanadium on the list from time to time).
I also ran through the gamut of nVHE, VHE, and pKVM given the effects on
hyp stage-1.

Marc, the bug can have some rather ugly (albeit rare) consequences, so
I'd like to get this in ASAP. The door is shut on 6.3, but it'd be nice
to squeeze in the 6.4 pull request if possible.

Oliver Upton (2):
  KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
  KVM: arm64: Infer PA offset from VA in hyp map walker

 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c         | 35 +++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 6 deletions(-)


base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
-- 
2.40.0.634.g4ca3ef3211-goog

