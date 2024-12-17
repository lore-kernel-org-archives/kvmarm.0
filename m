Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C721442F
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458032; cv=none; b=KqnmvRwtuJ/J9l5BAElFXBN0t7ZQmkaA1c7S+aPwRAZMJ9UjXVQs01Gmyv3rLzd+23HHAFWmH9UgOaTACIccxQ7CIp411ZjTs9ImoYetfTaWayB7fpwrtSb1PHdUiHXqZMG+/O4TggAKbZqu/hanxAjCnSXt5vOJ/4jmRCKG9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458032; c=relaxed/simple;
	bh=ylCMkM+rCVvPe98DY/sSklo6uJuTEB/sBfvaxn51beg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XZK9r3UlJvcvPSeINkLIUJmonI1AHC1PBoz6QTK3xDHsix01ng68uQ+NL78Oh9aK7xTK5AgQ/jeKkcp087Ld/xqfrbNl5q+wt99oZ4WMmvEXRnoOV+VLvQOXEt0K7QGZJjNfYpuolTg2mAhZVjLPC1isWanXxs91NszPJVTV694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TrDezsEY; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TrDezsEY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734458028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2QLMIYgaoudjtrwIYcCzEDgQCqf3TXu0gKs9q/Mjz24=;
	b=TrDezsEYiZgW7Ttgl2rhVI3K9OaIwScSaTzoCl0n1amGy/4FHAirIZuHLsVNkYJYsMbhUU
	FImlMwDNVQ88dJhfymlk1xlBsV4wSUciUKHHPjSXcmAX8PFFca0OPoJQiQE/BAtFx0/SRo
	GOlIjWPDnsON1+AX48hvdHihrCEod6E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: arm64: PMU fixes for 6.13
Date: Tue, 17 Dec 2024 09:53:32 -0800
Message-Id: <20241217175336.3657966-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Small set of fixes for PMU, mostly focused on plugging gaps in nested
support that I'd missed last time around:

 - Don't attempt to enable/disable EL2 counters when PMCR_EL0.E is
   changed. This is already the case since the enable state of a
   counter is re-evaluated in kvm_pmu_create_perf_event(), though the
   handling of PMCR_EL0.E would suggest otherwise.

 - Enable/disable EL2 counters when MDCR_EL2.HPME is changed.

 - Only reset 'guest' counters when PMCR_EL0.P is set, excluding EL2
   counters from being reset.

Applies to 6.13-rc3, tested on the M2 w/ my PMUv3 patches thrown on top.

Oliver Upton (4):
  KVM: arm64: Add unified helper for reprogramming counters by mask
  KVM: arm64: Use KVM_REQ_RELOAD_PMU to handle PMCR_EL0.E change
  KVM: arm64: nv: Reload PMU events upon MDCR_EL2.HPME change
  KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters

 arch/arm64/kvm/pmu-emul.c | 89 +++++++++++++++------------------------
 arch/arm64/kvm/sys_regs.c | 32 +++++++++++---
 include/kvm/arm_pmu.h     |  6 +--
 3 files changed, 62 insertions(+), 65 deletions(-)


base-commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
-- 
2.39.5

