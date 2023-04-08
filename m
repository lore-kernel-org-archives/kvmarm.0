Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7181841
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 12:17:58 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680956276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ed/VqAIsjS0LwI2iXHWPnqeSv4/U5M057y9nzcwmI5Y=;
	b=YRDgSAmlHofela0sEB1xCaI+EoD+xiyLUd5yLbKfCsMyBPGobiOB1B6bpvkg6V3DdA1CqD
	ia/25hFAIwodePn26PjMDLLqbfJy0KBhNWTLEKC9INlJwUgiCXPOP3XGxpfEOlXg/lU6Q8
	NsOEAUAzkUODhNZyAopi72sVmGQVz88=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Reserve SMC64 arch range per SMCCC filter documentation
Date: Sat,  8 Apr 2023 12:17:30 +0000
Message-Id: <20230408121732.3411329-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The intention of the SMCCC filter series was that the 'Arm architecture
calls' range is reserved, meaning userspace cannot apply a filter to it.
Though the documentation calls out both the SMC32 and presently unused
SMC64 views, only the SMC32 view of this range was actually reserved.

Small series to align UAPI behavior with the documentation and adding a
test case for the missed condition. Applies to kvmarm/next.

Oliver Upton (2):
  KVM: arm64: Prevent userspace from handling SMC64 arch range
  KVM: arm64: Test that SMC64 arch calls are reserved

 arch/arm64/kvm/hypercalls.c                   | 25 ++++++++++++++-----
 .../selftests/kvm/aarch64/smccc_filter.c      |  8 ++++++
 2 files changed, 27 insertions(+), 6 deletions(-)


base-commit: b87b85f845976e8d23e5f9fe7e399f6fc7360d26
-- 
2.40.0.577.gac1e443424-goog

