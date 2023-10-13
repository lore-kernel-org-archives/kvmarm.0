Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451017F3
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 05:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s7Z4VTmg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697174953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pU59iCAJ9xZuR3YWe8jYQ/I5AINYiPC0z4MP25i1zF0=;
	b=s7Z4VTmgzOsDFqiwVECfHXmDqrvqgi+fE/gn6b3ezdguPIosPNLdHbl0iciKkcjkTJC1u9
	iXxb11d69xkP26Euc6267dn3ZvSqVwCCuTYSjJg2UBPHYVtx2hGAN/mrqz5UgbIN3u1E05
	BflllugjG3LcAmbn42nvOwrcDZiBEPg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/2] KVM: arm64: PMU event filtering fixes
Date: Fri, 13 Oct 2023 05:28:59 +0000
Message-ID: <20231013052901.170138-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Set of fixes to KVM's handling of the exception level event filtering in
the PMU event type registers.

I dropped the PMU+NV disablement this time around as we need a complete
fix for that problem. At the same time, I want to get a rework of our
sysreg masks upstream soon to avoid any negative interaction with new
PMU features going in on the driver side of things.

Additionally, I added a fix for the non-secure filtering bits that
Suzuki had spotted (thanks!)

Oliver Upton (2):
  KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
  KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}

 arch/arm64/kvm/pmu-emul.c      | 26 +++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c      |  8 ++++++--
 include/kvm/arm_pmu.h          |  5 +++++
 include/linux/perf/arm_pmuv3.h |  8 +++++---
 4 files changed, 33 insertions(+), 14 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.655.g421f12c284-goog

