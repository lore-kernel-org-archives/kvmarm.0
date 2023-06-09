Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9890A408F1
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:09 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVoCbGcSXc3YlNbdxbQ4Np4WjjRfqNezMOxc2Wb+q4w=;
	b=WCfXlrUVAOrCjMM67pSGKlWNQbtJWDYJU4CRR4c2/gWNrFLLptSVqu9Glc4jgCv6igym5P
	1YaWmxZL7K/d0lRt0BmEr4MCJ3m5gNPyx9+kY2UnUx3A6dxRxE+QYmqjmsEmALv4rST17B
	tQwzl2/eljs2iKV5ylYvl8qI6PsMmsE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 01/11] KVM: arm64: Separate out feature sanitisation and initialisation
Date: Fri,  9 Jun 2023 19:00:44 +0000
Message-ID: <20230609190054.1542113-2-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm_vcpu_set_target() iteratively sanitises and copies feature flags in
one go. This is rather odd, especially considering the fact that bitmap
accessors can do the heavy lifting. A subsequent change will make vCPU
features VM-wide, and fitting that into the present implementation is
just a chore.

Rework the whole thing to use bitmap accessors to sanitise and copy
flags.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 75 +++++++++++++++++++------------
 2 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..565cad211388 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
 #define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..d5298054a8ed 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1167,42 +1167,40 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
-static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
-			       const struct kvm_vcpu_init *init)
+static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
+					const struct kvm_vcpu_init *init)
 {
-	unsigned int i, ret;
-	u32 phys_target = kvm_target_cpu();
+	unsigned long features = init->features[0];
+	int i;
 
-	if (init->target != phys_target)
-		return -EINVAL;
+	if (features & ~KVM_VCPU_VALID_FEATURES)
+		return -ENOENT;
 
-	/*
-	 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
-	 * use the same target.
-	 */
-	if (vcpu->arch.target != -1 && vcpu->arch.target != init->target)
-		return -EINVAL;
+	for (i = 1; i < ARRAY_SIZE(init->features); i++) {
+		if (init->features[i])
+			return -ENOENT;
+	}
 
-	/* -ENOENT for unknown features, -EINVAL for invalid combinations. */
-	for (i = 0; i < sizeof(init->features) * 8; i++) {
-		bool set = (init->features[i / 32] & (1 << (i % 32)));
+	return 0;
+}
 
-		if (set && i >= KVM_VCPU_MAX_FEATURES)
-			return -ENOENT;
+static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
+				  const struct kvm_vcpu_init *init)
+{
+	unsigned long features = init->features[0];
 
-		/*
-		 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
-		 * use the same feature set.
-		 */
-		if (vcpu->arch.target != -1 && i < KVM_VCPU_MAX_FEATURES &&
-		    test_bit(i, vcpu->arch.features) != set)
-			return -EINVAL;
+	return !bitmap_equal(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES) ||
+			vcpu->arch.target != init->target;
+}
 
-		if (set)
-			set_bit(i, vcpu->arch.features);
-	}
+static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
+				 const struct kvm_vcpu_init *init)
+{
+	unsigned long features = init->features[0];
+	int ret;
 
-	vcpu->arch.target = phys_target;
+	vcpu->arch.target = init->target;
+	bitmap_copy(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
 
 	/* Now we know what it is, we can reset it. */
 	ret = kvm_reset_vcpu(vcpu);
@@ -1214,6 +1212,27 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
+			       const struct kvm_vcpu_init *init)
+{
+	int ret;
+
+	if (init->target != kvm_target_cpu())
+		return -EINVAL;
+
+	ret = kvm_vcpu_init_check_features(vcpu, init);
+	if (ret)
+		return ret;
+
+	if (vcpu->arch.target == -1)
+		return __kvm_vcpu_set_target(vcpu, init);
+
+	if (kvm_vcpu_init_changed(vcpu, init))
+		return -EINVAL;
+
+	return kvm_reset_vcpu(vcpu);
+}
+
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 					 struct kvm_vcpu_init *init)
 {
-- 
2.41.0.162.gfafddb0af9-goog

