Received: from out-224.mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577003D3BF
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 19:50:52 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695239450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ev47HMNAOpHr6JFY8Ik7Biij/Z2d9LYaVbvs+9OPj4=;
	b=Y3aeTrcT32P1DLX0Wai+44vCXqNQuBxpWjj/g6vJrKzaq9Mr0PefxabuGTehiChth7eskR
	xlGPKeZ55b169wXxqb3+r7teYFDLvJJ4d5wfYSGtCBscjbBuWWdFEUOtHv9US30TrWTIH6
	ydDg41lafJKc5J3hyQodFVJnVJ6PBtc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/8] KVM: arm64: Hoist SVE check into KVM_ARM_VCPU_INIT ioctl handler
Date: Wed, 20 Sep 2023 19:50:31 +0000
Message-ID: <20230920195036.1169791-4-oliver.upton@linux.dev>
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

Test that the system supports SVE before ever getting to
kvm_reset_vcpu().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   |  3 +++
 arch/arm64/kvm/reset.c | 14 +++-----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c6cb7e40315f..9415a760fcda 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1200,6 +1200,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!kvm_arm_support_pmu_v3())
 		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
 
+	if (!system_supports_sve())
+		clear_bit(KVM_ARM_VCPU_SVE, &features);
+
 	return features;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5b5c74cb901d..3cb08d35b8e0 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -73,11 +73,8 @@ int __init kvm_arm_init_sve(void)
 	return 0;
 }
 
-static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 {
-	if (!system_supports_sve())
-		return -EINVAL;
-
 	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
 
 	/*
@@ -86,8 +83,6 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
 	 */
 	vcpu_set_flag(vcpu, GUEST_HAS_SVE);
-
-	return 0;
 }
 
 /*
@@ -231,11 +226,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
-		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
-			ret = kvm_vcpu_enable_sve(vcpu);
-			if (ret)
-				goto out;
-		}
+		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features))
+			kvm_vcpu_enable_sve(vcpu);
 	} else {
 		kvm_vcpu_reset_sve(vcpu);
 	}
-- 
2.42.0.515.g380fc7ccd1-goog

