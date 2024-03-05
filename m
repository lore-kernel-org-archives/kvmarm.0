Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908651400B
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664538; cv=none; b=m8JxW5jXGaWB5ay6QKp/+F5ckrbbKcqjJEBKDa2yJSKWRbxE8XNrB8JHbfcpLsoCZ24MQWJR1ms8DcRgqLqtTnkKB7covS3B1P0lSPhEbjAYqFDDGd8+mSSbVpOQCYDme66tNd3AMnOLHsZUl79C5dB/GaJAAKErZmgTN+2Gsjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664538; c=relaxed/simple;
	bh=zFHpeoHrk2fy3c/j0OJVv5j9Rm4YAqZK0RHIRw+CLq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BI/G2iuZfycomep5kZkOXlnJCWaS061SHEo+pe7MtBvciTALKv0fOxho7k/yy2lDhStqMTctARLP8dA/lFWzHNTrLrWLFCXpF7KRhJRolXAFqKNLXYNqCdKaVCQaPyXoY1NGhmhVVSdKk3BRghdHKKdUyfH6vEtcNK7y+tqN4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tz3Y3RTy; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tz3Y3RTy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709664534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKOAySTmtsid9rWndhWZ282Y5Z7nMyZa3Vt79s4X/6c=;
	b=tz3Y3RTyGDXm7Lt7cGt1xxxz3Tm24ZAnhgvF4Ixi4LWM7rNAO/52LTktdTjXC5qRXfMkaL
	/3m5Qt+83aH6zalf3eMMQgJuxw7jwXmuFmLyMBvX3wPv3IeSKVBzxyiKpf69cKqiMl0kJk
	Sy2rZ4rKgtOLrNuT5X32tK9wj5XBUDk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: Fix host-programmed guest events in nVHE
Date: Tue,  5 Mar 2024 18:48:39 +0000
Message-ID: <20240305184840.636212-3-oliver.upton@linux.dev>
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

Programming PMU events in the host that count during guest execution is
a feature supported by perf, e.g.

  perf stat -e cpu_cycles:G ./lkvm run

While this works for VHE, the guest/host event bitmaps are not carried
through to the hypervisor in the nVHE configuration. Make
kvm_pmu_update_vcpu_events() conditional on whether or not _hardware_
supports PMUv3 rather than if the vCPU as vPMU enabled.

Cc: stable@vger.kernel.org
Fixes: 84d751a019a9 ("KVM: arm64: Pass pmu events to hyp via vcpu")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 include/kvm/arm_pmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 4b9d8fb393a8..df32355e3e38 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -86,7 +86,7 @@ void kvm_vcpu_pmu_resync_el0(void);
  */
 #define kvm_pmu_update_vcpu_events(vcpu)				\
 	do {								\
-		if (!has_vhe() && kvm_vcpu_has_pmu(vcpu))		\
+		if (!has_vhe() && kvm_arm_support_pmu_v3())		\
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
-- 
2.44.0.278.ge034bb2e1d-goog

