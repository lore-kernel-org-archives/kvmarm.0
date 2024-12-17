Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B7D1F9EDA
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470569; cv=none; b=KC+fJgVk5j4MW5uhnyKYaopuh0Nk335bPKMtd5699638kxDIqn13Yz1tjItQQKmyDEPjIkhed2aHx5LlepRgKPG45u13uq/o9B9nGtofNiNzlDffU8EZzN459kR/8QmRsaz/I1yx5XOXRGTzbTLBczYxjaUX/jM0I3TRF8tOuB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470569; c=relaxed/simple;
	bh=Ubwiyn2TQr4wkm8jdzpmKEPHRmzV6Jrn5JMCzt3KHnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IQwqr3LHZJcMa10yneGJEzqwgcyyzxohPsuYVtidtzbsa2sfrEmMFNnk3MWmxasNSZQzrtgaBAGtGwVjsOGZ9N51ja8huqTZscstf4bEII24QdYOG3GNrkbL7vC5XXf9J4XX6fBjeZVaXNbOR760pc2pHglZwGm76p+3O1BYBLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W80u9i4H; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W80u9i4H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6GKBll1jVI+4KI5lsojh+atfM/dunkfyY0owsZPklhU=;
	b=W80u9i4HP18C3HMwynU7mz1BVXfjUNBjNPg/p/tApgrZYcvbglLmuaDCaGf0ZcIoVTau1p
	3UEbsLT+k46nb/vHs5Or6RGDm5w4j/7Aptt+x+ZFRmDv+cEJkdZYgFqT+QEB4ng1giIsTh
	FPDIUjNl4q4r5HYRBtZ5OQPToaM+N0s=
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
Subject: [PATCH 14/18] KVM: arm64: Advertise 0 event counters for IMPDEF PMU
Date: Tue, 17 Dec 2024 13:22:33 -0800
Message-Id: <20241217212233.3709321-1-oliver.upton@linux.dev>
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
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
index 553d02a03877..3803737cbf7c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1046,6 +1046,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
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

