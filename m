Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0371AADC
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664539; cv=none; b=SE9RujY37sT1TbqOUx1Ucr6t4piZ7KnKWO15bqIqDD6Oa29dSoJxgLwljBwksHV17uQMVNmZW0Qp5dskXzwdt7xo4wGqOwHJvAKmoxf0ua6l+fjIwbDAKePNc9FkPRwQplU2BVTsLucixv+p3zC1wCr/kTa7EnS13wCsFF4Phxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664539; c=relaxed/simple;
	bh=4LkTWix/yOPdq3kUxS6L6ucoLxfJczf1iotBna6zBqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5f5VaXBfu2QfRPueG/uCUwlyZC+jLLIteQLKsCrv/6palmaY21ICiP9ZG0tOGK6Y/6eKLQFh9+87jlPe3t5+cHyHMCfPykqEtuTTlRtB1a/i5q8jQKo2+I71pd/CDW/Y36h/vZiEK8FF4o9hwBNhGnSmY57WBSUPdBrScfCvWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O4wtfHRx; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O4wtfHRx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709664536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j464b6BHe27Efmc8oKhAIJOS+hPXEXstHwnMXP1anzc=;
	b=O4wtfHRxIQikwli0f/BCXS6IcOMkGtZmeoc1RBM7TG13VxayBbv8qhZqEcSywwc78N7tXH
	J/cO2KW7kcatKL/+iOSpp26R0rvftNVxrFtW6kj6xyrA7iDHSDJZrnoC44noOM3/QfJJdE
	mBIADAytoGh+0blvhBehy26xRlrUT9Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Do not disable preemption in kvm_vcpu_pmu_restore_guest()
Date: Tue,  5 Mar 2024 18:48:40 +0000
Message-ID: <20240305184840.636212-4-oliver.upton@linux.dev>
In-Reply-To: <20240305184840.636212-1-oliver.upton@linux.dev>
References: <20240305184840.636212-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The caller has already disabled preemption, no need to nest further.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index a243934c5568..43da27d8087d 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -181,14 +181,12 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_support_pmu_v3() || !has_vhe())
 		return;
 
-	preempt_disable();
 	pmu = kvm_get_pmu_events();
 	events_guest = pmu->events_guest;
 	events_host = pmu->events_host;
 
 	kvm_vcpu_pmu_enable_el0(events_guest);
 	kvm_vcpu_pmu_disable_el0(events_host);
-	preempt_enable();
 }
 
 /*
-- 
2.44.0.278.ge034bb2e1d-goog

