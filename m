Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590F520B815
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733254413; cv=none; b=pWI3qDnRuCErDuyRUoLrsfkEWuSCTbk5CJO7945cGMxuhQ5522xyIOfWrGbiEqm3YMsBZxz6J0i71qZHbc80RP93qzvomDcisYbz1us5e0wQ6T/1DyTWV55oZwJG5fRe/BHZCKYy/Ml4281EEMD7q2k46pRJoLMTrFubc/gLsdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733254413; c=relaxed/simple;
	bh=/8zDSXy5NBfTRH9ktf6Q1xux324+tPPHxPFariEPL04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VsK8KF/EavNgbnX8V5dgH5mSz26MxM1T4l0zavV7CDJnPRgbO7dE0JXQxPY4zgd4047+Uv8l4SD8ao9+PXAmkvi4Y0GpURLBXRiCjZ6SdKAKtVfFZFEoq0LtH+ZfPY6MuTfaY3BYchBKbyimtaaC65NIvicccXdPqeiETJu/A3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GE/uC9w2; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GE/uC9w2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733254409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0j8QeVqUGY13o8ZYmbGCiTmLdu0BS5K0LBQnEGaYE5E=;
	b=GE/uC9w258cmQKpVqyZITlLnhswPFWnYY7UCRXFLORi7N+xrJfvTrpQQBJZwrhhm6VEwdk
	wZP1oJbgVQu/Mdu6TIF/EBqWtPCY971EArCM98yxfvPWLJgyDj9QlYG955RKh+5sW6IFXK
	HQN25HW8EKutFnj7aqYm3iZt4tnDCtc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH 13/14] KVM: arm64: Advertise 0 event counters for IMPDEF PMU
Date: Tue,  3 Dec 2024 11:32:19 -0800
Message-Id: <20241203193220.1070811-14-oliver.upton@linux.dev>
In-Reply-To: <20241203193220.1070811-1-oliver.upton@linux.dev>
References: <20241203193220.1070811-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The programmable event counters on Apple M* parts are quite different
from what's available in PMUv3, as the event counters aren't fungible
(some events only work on specific counters) and the event ID space
doesn't match the architecture.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 34d9c08af209..8ac4eee781c9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1044,6 +1044,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return 0;
+
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
-- 
2.39.5

