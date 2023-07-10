Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA15D14AAC
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:31:55 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689017514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rSQgIJUwmVjU+YetnRMaEhAPP3BrgGETAKJ0eC/WlDE=;
	b=pw5SI1XMmy0NEVl0pohAny3yHduOjOAlC4t+5wAoHN5A0+Vp+ENAx1N1jIh5yZ2ROodx7t
	uUIUEY2sLo6z9EOnHpjAxY5h+2SnRhD5aWEinkWddGlPU0HWQvklYNyOgU30kE50MYTSnv
	A+z6libI+xZnTTZfWDx6hw3jr3HNnQ4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 4/4] KVM: arm64: Always return generic v8 as the preferred target
Date: Mon, 10 Jul 2023 19:31:40 +0000
Message-ID: <20230710193140.1706399-5-oliver.upton@linux.dev>
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

Userspace selecting an implementation-specific vCPU target has been
completely useless for a very long time. Let's go whole hog and start
returning the generic v8 target across all implementations as the
preferred target.

Uphold the pre-existing behavior by tolerating either the generic target
or an implementation-specific target if the vCPU happens to be running
on one of the lucky few parts.

Acked-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  9 +++++----
 arch/arm64/kvm/guest.c            | 15 ---------------
 3 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b53105bccff9..ed60277e834a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -898,7 +898,6 @@ struct kvm_vcpu_stat {
 	u64 exits;
 };
 
-void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 13f1bde0bc2d..9ab17ecd76bb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1250,7 +1250,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
-	if (init->target != kvm_target_cpu())
+	if (init->target != KVM_ARM_TARGET_GENERIC_V8 &&
+	    init->target != kvm_target_cpu())
 		return -EINVAL;
 
 	ret = kvm_vcpu_init_check_features(vcpu, init);
@@ -1585,9 +1586,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		return kvm_vm_ioctl_set_device_addr(kvm, &dev_addr);
 	}
 	case KVM_ARM_PREFERRED_TARGET: {
-		struct kvm_vcpu_init init;
-
-		kvm_vcpu_preferred_target(&init);
+		struct kvm_vcpu_init init = {
+			.target = KVM_ARM_TARGET_GENERIC_V8,
+		};
 
 		if (copy_to_user(argp, &init, sizeof(init)))
 			return -EFAULT;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 20280a5233f6..95f6945c4432 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -884,21 +884,6 @@ u32 __attribute_const__ kvm_target_cpu(void)
 	return KVM_ARM_TARGET_GENERIC_V8;
 }
 
-void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
-{
-	u32 target = kvm_target_cpu();
-
-	memset(init, 0, sizeof(*init));
-
-	/*
-	 * For now, we don't return any features.
-	 * In future, we might use features to return target
-	 * specific features available for the preferred
-	 * target type.
-	 */
-	init->target = (__u32)target;
-}
-
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	return -EINVAL;
-- 
2.41.0.255.g8b1d071c50-goog

