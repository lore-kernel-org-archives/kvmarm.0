Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7803D1F9ECD
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470480; cv=none; b=Ebj1exWtnoQUjlMr4Jfi01vzGongWOm8oU0RCACYs2lji9z8HuM+a/eY9N+d6gQRNC5kooEbP5m+vlISFedkpxWQCQagjDSEbW8NRz8WQVeYeIgpyAWUbgWIeGQXWSB9sL7SJP04G6TDu3B3Xk9YJcynYKwQz/lhZykhBqUUIW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470480; c=relaxed/simple;
	bh=N3CkdBP4BxotD0IFFq7Qq57eqxjC/6uusjnRLSXGc0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SRl4b9Ge5JP7V/bcwtZGAP0bqTvzG0jQxu3GrKiho1FQytNAVctD7n6ncAbkIwRCTO04GSmQRMjM9PU5vUX1wwgoyQHd1H8N0EPNR3Uqk58YlGfCiNkhYV1/XWhSrtKZIkFO5zRyLl+umUVF2d7Cdzo8zvDBHBZEIBdWwRwbWAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VUCz9OE/; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VUCz9OE/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YE2j3A4NxVRVl2GQB2DLusxN7V/Z1D1qyrpkRyZqAjs=;
	b=VUCz9OE/AV2KcJ4J/cF5KXrOcr3hPjieyyL33kZUsPDz3yA0S+1ZyfYmkt57QMq55xiumt
	2F+dSum7cm/lECcbmlUGO6V3W5MyrylY4OZ19GHhM8/0JzSCzI8rnwAvzElEsh7+UzTBfw
	U3AvPtw0WbCp9WJejotPzL1AE5lyWyc=
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
Subject: [PATCH 06/18] KVM: arm64: Always support SW_INCR PMU event
Date: Tue, 17 Dec 2024 13:20:36 -0800
Message-Id: <20241217212048.3709204-7-oliver.upton@linux.dev>
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

Support for SW_INCR is unconditional, as KVM traps accesses to
PMSWINC_EL0 and emulates the intended event increment. While it is
expected that ~all PMUv3 implementations already advertise this event,
non-PMUv3 hardware may not.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 809d65b912e8..7f20da32266e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -875,6 +875,8 @@ static u64 compute_pmceid0(struct arm_pmu *pmu)
 {
 	u64 val = __compute_pmceid(pmu, 0);
 
+	/* always support SW_INCR */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
 	/* always support CHAIN */
 	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
 	return val;
-- 
2.39.5

