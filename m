Received: from out-10.mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6314AB4
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:31:50 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689017509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1mgKw05torO9/d/PysP0c6NuPEoLDa7Df/dneLoddlo=;
	b=PLY+IQ9FZrKWS7Tu5K6c9kQwQ7RkxGiQCUCvdDXxpXK9RYd5v5b185Psgbhgu7YW1WhvX1
	tDm/VsokvqGnCVJD22CU3il/sC1lVdqjYkHOCznts86yCMTGpGrNcBT8dkC2oRXV2g2cvt
	XVwJwR/9J6xuglUGa6CPfukPOuuYB1Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/4] KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
Date: Mon, 10 Jul 2023 19:31:37 +0000
Message-ID: <20230710193140.1706399-2-oliver.upton@linux.dev>
In-Reply-To: <20230710193140.1706399-1-oliver.upton@linux.dev>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The vCPU target hasn't mattered for quite a long time now. Delete the
useless switch statement in kvm_reset_vcpu(), which hilariously only had
a default case in it.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/reset.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index bc8556b6f459..7a65a35ee4ac 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -248,21 +248,16 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	switch (vcpu->arch.target) {
-	default:
-		if (vcpu_el1_is_32bit(vcpu)) {
-			pstate = VCPU_RESET_PSTATE_SVC;
-		} else if (vcpu_has_nv(vcpu)) {
-			pstate = VCPU_RESET_PSTATE_EL2;
-		} else {
-			pstate = VCPU_RESET_PSTATE_EL1;
-		}
-
-		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-			ret = -EINVAL;
-			goto out;
-		}
-		break;
+	if (vcpu_el1_is_32bit(vcpu))
+		pstate = VCPU_RESET_PSTATE_SVC;
+	else if (vcpu_has_nv(vcpu))
+		pstate = VCPU_RESET_PSTATE_EL2;
+	else
+		pstate = VCPU_RESET_PSTATE_EL1;
+
+	if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* Reset core registers */
-- 
2.41.0.255.g8b1d071c50-goog

