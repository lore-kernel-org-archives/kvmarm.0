Received: from out-212.mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA8D3FB0B
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 19:50:50 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695239448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqUs/7yAcT86lqyVi3bi6/3EeWVA+owFHQLC8nksiPI=;
	b=o9tUEvQMvO9NUnzt4hh5GmpKh3C1sKhZF18TTF2m/oXKu9WSndgbJDzh7fCwoDGGeIYrZk
	1RmDmminOeFnoQwwyQEkjkLUlDvoEnMGxPsBRySwVVNq0RqCaK9zG11/A0Kbataij+gdmA
	afh1BnCUzPNgjukOm/rzWUwpBsf6D8E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/8] KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
Date: Wed, 20 Sep 2023 19:50:30 +0000
Message-ID: <20230920195036.1169791-3-oliver.upton@linux.dev>
In-Reply-To: <20230920195036.1169791-1-oliver.upton@linux.dev>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Test that the system supports PMUv3 before ever getting to
kvm_reset_vcpu().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   | 3 +++
 arch/arm64/kvm/reset.c | 5 -----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 66f3720cdd3a..c6cb7e40315f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1197,6 +1197,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
+	if (!kvm_arm_support_pmu_v3())
+		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
+
 	return features;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 7a65a35ee4ac..5b5c74cb901d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -255,11 +255,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	else
 		pstate = VCPU_RESET_PSTATE_EL1;
 
-	if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
 	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
-- 
2.42.0.515.g380fc7ccd1-goog

