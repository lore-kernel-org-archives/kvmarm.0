Received: from out-230.mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F74F1C26
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 08:01:49 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695196907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MLW7qwdJIvj48Ety8MOzco+OBQsuiHw84jgrxmlkBac=;
	b=l2IgLoEqC/yOBo3Y5qEWPHQFyk0P8rAUR+VVbIDFcNfvcfqJaJN30zb2w511oSCcn1yONr
	EK9Z89DSDG9VbxGJKPjiUQiCC2zG9MRAhnAzmsA/NOUcwot8DT1+2o5IZLIDEzojmu/GUj
	WJLfDeXFG1wKtwR3dGVEHWKEUto/hVA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Address soft lockups due to I-cache CMOs
Date: Wed, 20 Sep 2023 08:01:31 +0000
Message-ID: <20230920080133.944717-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Small series to address the soft lockups that Gavin hits when running
KVM guests w/ hugepages on an Ampere Altra Max machine. While I
absolutely loathe "fixing" the issue of slow I-cache CMOs in this way,
I can't really think of an alternative.

Oliver Upton (2):
  arm64: tlbflush: Rename MAX_TLBI_OPS
  KVM: arm64: Avoid soft lockups due to I-cache maintenance

 arch/arm64/include/asm/kvm_mmu.h  | 37 ++++++++++++++++++++++++++-----
 arch/arm64/include/asm/tlbflush.h |  8 +++----
 2 files changed, 35 insertions(+), 10 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.459.ge4e396fd5e-goog

