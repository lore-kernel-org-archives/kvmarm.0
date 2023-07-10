Received: from out-6.mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6AA14AB4
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:31:53 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689017512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mGG2nCoUls0JDuISPlsiqb42btR5pzZOvd3L81f+nFY=;
	b=E/HqI4vM3ZgpCsL/VOd7TC5Px5dmHXWCo8TMIdOR52IgcXZiJKbR/AGqqAF/02Vtwzy1N+
	MdHrM4PHIXOQtqsYvAbwDiJBev3on3KTTHXU8SE5qUD7H0KIa3ccNGChn5aGZC6EhRviIO
	ZjCF1/wSw2hTg4UPwMBzORYYRIaWLw4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 3/4] KVM: arm64: Replace vCPU target with a configuration flag
Date: Mon, 10 Jul 2023 19:31:39 +0000
Message-ID: <20230710193140.1706399-4-oliver.upton@linux.dev>
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

The value of kvm_vcpu_arch::target has been used to determine if a vCPU
has actually been initialized. Storing this as an integer is needless at
this point, as KVM doesn't do any microarch-specific emulation in the
first place. Instead, all we care about is whether or not the vCPU has
been initialized.

Delete the field in favor of a vCPU configuration flag indicating if
KVM_ARM_VCPU_INIT has completed for the vCPU.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/arm.c              | 12 +++++-------
 arch/arm64/kvm/hyp/nvhe/switch.c  |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b6096753740..b53105bccff9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -567,8 +567,7 @@ struct kvm_vcpu_arch {
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-	/* Target CPU and feature flags */
-	int target;
+	/* feature flags */
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
@@ -669,6 +668,8 @@ struct kvm_vcpu_arch {
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
 /* PTRAUTH exposed to guest */
 #define GUEST_HAS_PTRAUTH	__vcpu_single_flag(cflags, BIT(2))
+/* KVM_ARM_VCPU_INIT completed */
+#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(3))
 
 /* Exception pending */
 #define PENDING_EXCEPTION	__vcpu_single_flag(iflags, BIT(0))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3f844934b9f3..13f1bde0bc2d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -360,7 +360,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 #endif
 
 	/* Force users to call KVM_ARM_VCPU_INIT */
-	vcpu->arch.target = -1;
+	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
@@ -569,7 +569,7 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.target >= 0;
+	return vcpu_get_flag(vcpu, VCPU_INITIALIZED);
 }
 
 /*
@@ -1051,7 +1051,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			 * invalid. The VMM can try and fix it by issuing  a
 			 * KVM_ARM_VCPU_INIT if it really wants to.
 			 */
-			vcpu->arch.target = -1;
+			vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 			ret = ARM_EXCEPTION_IL;
 		}
 
@@ -1228,20 +1228,18 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	    !bitmap_equal(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES))
 		goto out_unlock;
 
-	vcpu->arch.target = init->target;
 	bitmap_copy(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
 
 	/* Now we know what it is, we can reset it. */
 	ret = kvm_reset_vcpu(vcpu);
 	if (ret) {
-		vcpu->arch.target = -1;
 		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 		goto out_unlock;
 	}
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
-
+	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
@@ -1259,7 +1257,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	if (ret)
 		return ret;
 
-	if (vcpu->arch.target == -1)
+	if (!kvm_vcpu_initialized(vcpu))
 		return __kvm_vcpu_set_target(vcpu, init);
 
 	if (kvm_vcpu_init_changed(vcpu, init))
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0a6271052def..b9caac3e7b1d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -236,7 +236,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 		 * KVM_ARM_VCPU_INIT, however, this is likely not possible for
 		 * protected VMs.
 		 */
-		vcpu->arch.target = -1;
+		vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 		*exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
 		*exit_code |= ARM_EXCEPTION_IL;
 	}
-- 
2.41.0.255.g8b1d071c50-goog

