Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F7199D6
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 08:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uFEnhuM+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697012232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1hHZDVIa3yDoGKax+wmO5RAUIx6mrtYgB/XXBr+eb8Y=;
	b=uFEnhuM+BGPf1YuGb9CPn2gfCts1MbrrWNExCJpBpN9lmXEkzzSeBEmbda8Bek4yNGGXwc
	iRGPh1cLkFxLaTI7jXUK1mcchyzX43L1B9Fkk/dnWklAFzwBQJfkgNpcIDzTzUsjG+BVke
	3b3JL800ai1t79zg2Eu3br0fx0wUmLA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	James Clark <james.clark@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: vPMU fixes for NV/EL2
Date: Wed, 11 Oct 2023 08:16:46 +0000
Message-ID: <20231011081649.3226792-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM allows userspace to select both the vPMU and NV feature flags, which
is an absolute no-go since we do not handle any of the EL2 controls.
Furthermore, our sysreg emulation allows the guest to set the NSH bit
responsible for counting events at EL2 despite the fact it does
absolutely nothing.

Series to address the both of these issues. While neither of them are
really a big deal at the moment, the second patch is relevant to James
C's PMU event threshold series [*].

[*] https://lore.kernel.org/kvmarm/20231010141551.2262059-1-james.clark@arm.com/

Oliver Upton (2):
  KVM: arm64: Disallow vPMU for NV guests
  KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0

 arch/arm64/kvm/arm.c      | 5 +++--
 arch/arm64/kvm/pmu-emul.c | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.42.0.609.gbb76f46606-goog

