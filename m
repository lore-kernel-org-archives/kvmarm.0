Received: from out-53.mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1D1EA8B
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 21:27:50 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685050068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GcaYIZes7eoQxIcBQ3dy6XEPGIYlpX9Tf7l6FKMLHFE=;
	b=R6EFO+mfgaKp5pp/vzP4f7bzreOdW4h5fiazXOHHmf1XoP3cfYOKhYGBQ7a65K/bJTkAAU
	PFkMdU9nLIVmxPd15zyV15Q9oXwFJPe5ZpnP574AdOOJ4X9U5MKi0Dsw6BeJ8rgCt3cso5
	KtVMqSHkCUAAumdrf8m5r7ETXAn/2Wc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Nathan Chancellor <nathan@kernel.org>,
	mark.rutland@arm.com,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Fix for probing default PMU
Date: Thu, 25 May 2023 21:27:20 +0000
Message-ID: <20230525212723.3361524-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Follow-up to the discussion in [1].

KVM uses a junk perf event to probe for a default PMU instance to use
for the guest, which depends on perf finding the right PMU instance
to use for the event. Looks like perf is going to rely strictly on
the specified PMU type, breaking the entire scheme.

KVM now maintains a list of valid PMU instances that can be selected by
userspace, we can simply walk that to probe for a default PMU.

Applies to 6.4-rc3 and tested on -next.

[1] https://lore.kernel.org/all/20230524214133.GA2359762@dev-arch.thelio-3990X/

Oliver Upton (2):
  KVM: arm64: Iterate arm_pmus list to probe for default PMU
  KVM: arm64: Document default vPMU behavior on heterogeneous systems

 arch/arm64/kvm/pmu-emul.c | 58 ++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 35 deletions(-)


base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
-- 
2.41.0.rc0.172.g3f132b7071-goog

