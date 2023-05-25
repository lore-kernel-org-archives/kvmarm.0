Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDDB1EA8B
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 21:27:54 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685050072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dzfESPWnr/g9ux0llAQCibwDz0KlvK21w6uaollSFxU=;
	b=nsu7EP0Xfbr6G3wnezyqTP9EqoGyjV3Nxon3DqVENiux+BC2C8UolNxVGmUwbWA6fOkSAf
	HsKWdw7109gvmzaExgTGum4QCnNb8qL2QJ6iIWMksS4qzIrDz1mVHbKMDWRusmL/LBZtg2
	UVWcMlxzptipxO6oQEVPA2DUmZ6eXww=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Nathan Chancellor <nathan@kernel.org>,
	mark.rutland@arm.com,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Document default vPMU behavior on heterogeneous systems
Date: Thu, 25 May 2023 21:27:22 +0000
Message-ID: <20230525212723.3361524-3-oliver.upton@linux.dev>
In-Reply-To: <20230525212723.3361524-1-oliver.upton@linux.dev>
References: <20230525212723.3361524-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM maintains a mask of supported CPUs when a vPMU type is explicitly
selected by userspace and is used to reject any attempt to run the vCPU
on an unsupported CPU. This is great, but we're still beholden to the
default behavior where vCPUs can be scheduled anywhere and guest
counters may silently stop working.

Avoid confusing the next poor sod to look at this code and document the
intended behavior.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5deddc49e745..491ca7eb2a4c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -890,7 +890,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return -EBUSY;
 
 	if (!kvm->arch.arm_pmu) {
-		/* No PMU set, get the default one */
+		/*
+		 * No PMU set, get the default one.
+		 *
+		 * The observant among you will notice that the supported_cpus
+		 * mask does not get updated for the default PMU even though it
+		 * is quite possible the selected instance supports only a
+		 * subset of cores in the system. This is intentional, and
+		 * upholds the preexisting behavior on heterogeneous systems
+		 * where vCPUs can be scheduled on any core but the guest
+		 * counters could stop working.
+		 */
 		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
 		if (!kvm->arch.arm_pmu)
 			return -ENODEV;
-- 
2.41.0.rc0.172.g3f132b7071-goog

