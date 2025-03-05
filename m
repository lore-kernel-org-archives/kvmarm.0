Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4431F419E
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206637; cv=none; b=Sy9SFIM1M5s9glnskKPltUolAZ5o0Oh42py42bsdFnTQ7vK0cZJg4Bf95zMUpyDaRJaFpOXE4qFtdt5uLfDohmEY5gCsqaesEo70BCZR/MAwEdSHRd4yo7GatX/kMPMQZyXfORvLERdf+vVtEKsxRx5EZWxc3LgmHhTWfaRFjnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206637; c=relaxed/simple;
	bh=q2xqLjtqchddGyvhFV5o9T+l8maI7VQKWimt4j6opmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YuaOvyqNHgbdOwUFx8xsTHaU78jQ2jMixltScX6CCNby7P/vzbC7WNTU51WZNHilGZLVA627s7Fn75mpIM2l/Wdsui9hLnhjn3juPrjrhNw9oztFFEH24fw7rIiWm5g5vc7wwjKH/Ibi4qNdNQoSIkLaLMVMnmt3qc4sh1cFlXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HTITEQdf; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HTITEQdf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C9rkU/BkO0IgQUVDyWoSYn1KJrlLp/PbUGzatcb+mgA=;
	b=HTITEQdfFDjsccUW0LToAjPQRSbAlGDYIuou0YBxpV/mxHgGNhlz2JsLTpR/L++kJpBvJS
	ykkzMVUeyG+C2ZM9NOvuagegTzCEqWNOmvcFgHse/aV+Vlt3dVD9OOPRIFufPghhhGAUby
	PivE4dKcdsdymK2io/xY8nOSABhFE48=
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
	Janne Grunau <j@jannau.net>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 13/14] KVM: arm64: Provide 1 event counter on IMPDEF hardware
Date: Wed,  5 Mar 2025 12:30:21 -0800
Message-Id: <20250305203021.428366-1-oliver.upton@linux.dev>
In-Reply-To: <20250305202641.428114-1-oliver.upton@linux.dev>
References: <20250305202641.428114-1-oliver.upton@linux.dev>
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

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5f4e9be8aa8b..51fb47e0bf89 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1038,6 +1038,13 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	/*
+	 * PMUv3 requires that all event counters are capable of counting any
+	 * event, though the same may not be true of non-PMUv3 hardware.
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return 1;
+
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
-- 
2.39.5

