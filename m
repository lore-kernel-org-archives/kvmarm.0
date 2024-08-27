Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F61FDA
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718190; cv=none; b=Lt8Hznz1xjDapUDflxAAWyBCcxYRZZdXy3/jSYUpYW4kwsqJ2IVwfNtamSya/uUrE/XzJ9A+XEQuyovanmfl/5j5vM6EzZM7fExO8VN3Vd8lIEpkQD9VCLafdL+zjL4g7hWz7sGOP0rDIMxDuES1asJailb0biX/N7+OZ/bqTvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718190; c=relaxed/simple;
	bh=0El/KKSSTOenxCjKMKPKc6Qr8STfB0ZHYyIOAmqhZOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDqZpCGrcOfLOWOlzA6Yv3C/UEeNHuppRqODWivVBCUQCgujNHKu3P98+xl1WU6tvu1Q/5GxcfBakxxR9amMh3JB6c0RkxE9ldFP9VLC6dftYAZYHLYMA9qZGLYrn0W8IjkkFAM2vdwT+vHd5am876siwNNCe/p3ygOIivL2Y+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=batGyvKT; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="batGyvKT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=24AgZaGeKik0vcysPxbqRjYNsYY8wI5RROhHV9p1aJE=;
	b=batGyvKTztb9zROCCUqIUFY+M/tdTdss0U09BAZoYIyds8ULTu4144ugb6I0SCT0xF/rVt
	dagl1ZgAIKO3loYWGw5Xf3tgvVUCHpY9TuuGCvzmC586ENg3OwS/4pc1i4lwpbDK2h+gUU
	PTVKTuCBHFc4iVB4D6DiblS+uHjbfpU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 11/12] KVM: arm64: nv: Honor NSH filter when in hyp context
Date: Tue, 27 Aug 2024 00:22:34 +0000
Message-ID: <20240827002235.1753237-12-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It hopefully comes as no surprise when I say that vEL2 actually runs at
EL1. So, the guest hypervisor's EL2 event filter (NSH) needs to actually
be applied to EL1 in the perf event.

This isn't quite enough yet, as the backing perf events need to be
reprogrammed upon nested ERET/exception entry to remap the effective
filter onto ::exclude_kernel.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fbefad8913bf..3dee669c0674 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -624,6 +624,11 @@ static bool kvm_pmc_counts_at_el1(struct kvm_pmc *pmc)
 	return p == nsk;
 }
 
+static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
+{
+	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
+}
+
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -666,11 +671,19 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
 	attr.exclude_user = !kvm_pmc_counts_at_el0(pmc);
-	attr.exclude_kernel = !kvm_pmc_counts_at_el1(pmc);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
 
+	/*
+	 * Filter events at EL1 (i.e. vEL2) when in a hyp context based on the
+	 * guest's EL2 filter.
+	 */
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		attr.exclude_kernel = !kvm_pmc_counts_at_el2(pmc);
+	else
+		attr.exclude_kernel = !kvm_pmc_counts_at_el1(pmc);
+
 	/*
 	 * If counting with a 64bit counter, advertise it to the perf
 	 * code, carefully dealing with the initial sample period
-- 
2.46.0.295.g3b9ea8a38a-goog

