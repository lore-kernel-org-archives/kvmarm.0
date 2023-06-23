Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9DD107B2
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 19:43:12 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687549390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PFwIcOBP2a8u2/dbeqfzvIZ/9x//E7c27DWYVBwkGWU=;
	b=G433CvTGCXMi3+7L3TCCl2xO8m8RJ5gyadvf8C+7vRWW/hkK1sIEYKeIjq4kzCoUFnReEQ
	e8UQ0p9JhxUJu14kRUV0SqTShqWDRRY9fWCJJJly9A93oymx4g6WwNr3Hd5Q3JdhZFEt6v
	T9oSSwpx+ML7r5QER0fg/RMwFGGmDNg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/4] KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
Date: Fri, 23 Jun 2023 19:42:55 +0000
Message-ID: <20230623194258.2648987-2-oliver.upton@linux.dev>
In-Reply-To: <20230623194258.2648987-1-oliver.upton@linux.dev>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
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
2.41.0.178.g377b9f9a00-goog

