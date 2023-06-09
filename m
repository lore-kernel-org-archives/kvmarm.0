Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7193123403
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 22:01:15 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686348072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5iBfoHKW/WQ0K23XQQEoJJQTBbnOdvyZj0RT3bSYgCk=;
	b=YQtv1QG4MESi/kbwWrWuxpzWnCvJwOV3gky+Of5VmzRUyTqAJv69LRvmW5jEHgWzkJIVMz
	lLsuQIdayrScJsfYsYZN6Ghh5VI3gcT64F1g9kcVIu/nGigCAXT7fjFJK2SgSSXFlOHhOV
	muAUJX0NWoTcsFhRHP0IXKOIHZuRC9w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Darren Hart <darren@os.amperecomputing.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Work around Ampere1 erratum AC03_CPU_38
Date: Fri,  9 Jun 2023 22:01:01 +0000
Message-ID: <20230609220104.1836988-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Small series to work around a CPU erratum on AmpereOne. While the
implementation does not advertise support for FEAT_HAFDBS (due to
another erratum), the associated control bits do not have RES0 behavior
as required by the architecture.

Usage of HAFDBS at stage-1 is unaffected, since HA and HD are only
enabled on implementations that advertise the feature. However, KVM
relies on HA having RES0 semantics if the feature isn't implemented. The
end result is that KVM enables a broken hardware access flag
implementation that could lead to correctness issues.

Applies to 6.4-rc1. Tested with access_tracking_perf_test, verifying
that KVM is indeed taking Access Flag faults.

Oliver Upton (3):
  arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38 at stage-2
  KVM: arm64: Refactor HFGxTR configuration into separate helpers
  KVM: arm64: Prevent guests from enabling HA/HD on Ampere1

 Documentation/arm64/silicon-errata.rst  |  3 +
 arch/arm64/Kconfig                      | 17 +++++
 arch/arm64/kernel/cpu_errata.c          |  7 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 99 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/pgtable.c            | 14 +++-
 arch/arm64/tools/cpucaps                |  1 +
 6 files changed, 120 insertions(+), 21 deletions(-)


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.41.0.162.gfafddb0af9-goog

