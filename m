Received: from out-229.mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8933FB0B
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 19:50:53 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695239452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lmsd+cmXdh5Wnuo3B63Fy6hr6UdLHBnrjyIdvUByTdo=;
	b=uwLjCK9/Lvat9rKT13yy618oablIoQQGZq8LgT/UPhqCnAB8tlgJ2DiUbMLl1BHVw7ldg6
	L2RS/7TYTNm9uRjsiBszk2p8+vSptka3sAQ5iYfTKNzwPQmzYMQx6iJiNnk2FNxp77gttP
	X38iTZZD0g5GmZDOqexnx3Y9dRLXvDI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/8] KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
Date: Wed, 20 Sep 2023 19:50:32 +0000
Message-ID: <20230920195036.1169791-5-oliver.upton@linux.dev>
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

Test for feature support in the ioctl handler rather than
kvm_reset_vcpu(). Continue to uphold our all-or-nothing policy with
address and generic pointer authentication.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   | 13 +++++++++++++
 arch/arm64/kvm/reset.c | 21 +++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9415a760fcda..e40f3bfcb0a1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1203,6 +1203,11 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!system_supports_sve())
 		clear_bit(KVM_ARM_VCPU_SVE, &features);
 
+	if (!system_has_full_ptr_auth()) {
+		clear_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features);
+		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
+	}
+
 	return features;
 }
 
@@ -1223,6 +1228,14 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (features & ~system_supported_vcpu_features())
 		return -EINVAL;
 
+	/*
+	 * For now make sure that both address/generic pointer authentication
+	 * features are requested by the userspace together.
+	 */
+	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features) !=
+	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3cb08d35b8e0..bbcf5bbd66d9 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -165,20 +165,9 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
-static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * For now make sure that both address/generic pointer authentication
-	 * features are requested by the userspace together and the system
-	 * supports these capabilities.
-	 */
-	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
-	    !system_has_full_ptr_auth())
-		return -EINVAL;
-
 	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
-	return 0;
 }
 
 /**
@@ -233,12 +222,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
-		if (kvm_vcpu_enable_ptrauth(vcpu)) {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
+	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+		kvm_vcpu_enable_ptrauth(vcpu);
 
 	if (vcpu_el1_is_32bit(vcpu))
 		pstate = VCPU_RESET_PSTATE_SVC;
-- 
2.42.0.515.g380fc7ccd1-goog

