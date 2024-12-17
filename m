Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1165D1FAC45
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470631; cv=none; b=eJqm+Z4JFpiX3nJqvG1l3umxuPL9OXvsyht56OM7NqLL0hF+3nrWmbQqMqqZej0nYDK6HPuBgYULHrbTrTJ6tDulxeWMCAJ7lx1m7AptxD6sQ4J2ZF0lFvzSGGnFymcsC7YuL/ljVYI8t4KEOD4/l3537GhmOELj75oSv8oxYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470631; c=relaxed/simple;
	bh=JEH6VIxMNbo7NmfZIs+BIaWAf0jjuH4Dh0marg2vFM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GwUcT4clqPEMZcM2D9QsxhLsssPF2xznN4Tc9Knis3IOZw94M4hNdYeb49OeB3L9rBSwTUcjxcz1OXsWZbStq09s4l1mvNxbZP0LBz1KNCpLkAzGRhF61+8DLqbp5+pyOWWYr+aqUmtPWzbVdU5NLYQ/BTCvDeCxRy6MgbH8rok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DuIwr+s4; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DuIwr+s4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YI2KAoE2SX7+W8a4D1T/xctArnLAfC10Qu1P05UgNA=;
	b=DuIwr+s4NNh44T42eneXEcnCmnXGAZNrlC/kyuTskZtvRC7BXsxCXIikgCW0helwT7ElDx
	3VnwDicLKGH4aCkqNZc7f8jAlVXCoSoJIFOO7hXKdiP1cj1ILHFFN2U78WOdIEGmaEDQqc
	E8JAfD6lURoYaBUQnJVIaZEVR5VR5SU=
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
Subject: [RFC PATCH 17/18] KVM: arm64: Provide 1 event counter on IMPDEF hardware
Date: Tue, 17 Dec 2024 13:23:38 -0800
Message-Id: <20241217212338.3709556-1-oliver.upton@linux.dev>
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

PMUv3 requires that all programmable event counters are capable of
counting any event. The Apple M* PMU is quite a bit different, and
events have affinities for particular PMCs.

Expose 1 event counter on IMPDEF hardware, allowing the guest to do
something useful with its PMU while also upholding the requirements of
the architecture.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Jury is still out on whether we want to do this, which is why this patch
is RFC.

 arch/arm64/kvm/pmu-emul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3803737cbf7c..8f96a34d3da5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1046,8 +1046,12 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	/*
+	 * PMUv3 requires that all event counters are capable of counting any
+	 * event, though the same may not be true of non-PMUv3 hardware.
+	 */
 	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
-		return 0;
+		return 1;
 
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
-- 
2.39.5

