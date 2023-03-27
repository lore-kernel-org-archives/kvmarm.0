Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D750C63B9
	for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 16:48:18 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679935697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v5fcFa0ottpyT29ww6ePOjYGABxQ2B8/lksLSCnquaQ=;
	b=RL/m9YGnCTwYnMBW09gS7IwFs3YVZb4wu1ZLw+a7skUbp0bF4LVpcLGqUDnOZHqmaVWzys
	5Nr5n1wM9PZKolX5ySfmjE196XRgItFSKMoH4ukMw6ZEs9E8u6XFcIvTehLDMILPrNyn+V
	qZdF7KI6BqH0qqDEk8BYlgpCgDZS2v4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/4] KVM: arm64: Avoid lock inversion when setting the VM register width
Date: Mon, 27 Mar 2023 16:47:45 +0000
Message-Id: <20230327164747.2466958-3-oliver.upton@linux.dev>
In-Reply-To: <20230327164747.2466958-1-oliver.upton@linux.dev>
References: <20230327164747.2466958-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm->lock must be taken outside of the vcpu->mutex. Of course, the
locking documentation for KVM makes this abundantly clear. Nonetheless,
the locking order in KVM/arm64 has been wrong for quite a while; we
acquire the kvm->lock while holding the vcpu->mutex all over the shop.

All was seemingly fine until commit 42a90008f890 ("KVM: Ensure lockdep
knows about kvm->lock vs. vcpu->mutex ordering rule") caught us with our
pants down, leading to lockdep barfing:

 ======================================================
 WARNING: possible circular locking dependency detected
 6.2.0-rc7+ #19 Not tainted
 ------------------------------------------------------
 qemu-system-aar/859 is trying to acquire lock:
 ffff5aa69269eba0 (&host_kvm->lock){+.+.}-{3:3}, at: kvm_reset_vcpu+0x34/0x274

 but task is already holding lock:
 ffff5aa68768c0b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x8c/0xba0

 which lock already depends on the new lock.

Add a dedicated lock to serialize writes to VM-scoped configuration from
the context of a vCPU. Protect the register width flags with the new
lock, thus avoiding the need to grab the kvm->lock while holding
vcpu->mutex in kvm_reset_vcpu().

Cc: stable@vger.kernel.org
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Link: https://lore.kernel.org/kvmarm/f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com/
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arm.c              | 18 ++++++++++++++++++
 arch/arm64/kvm/reset.c            |  6 +++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 917586237a4d..cd1ef8716719 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -199,6 +199,9 @@ struct kvm_arch {
 	/* Mandated version of PSCI */
 	u32 psci_version;
 
+	/* Protects VM-scoped configuration data */
+	struct mutex config_lock;
+
 	/*
 	 * If we encounter a data abort without valid instruction syndrome
 	 * information, report this to user space.  User space can (and
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 647798da8c41..1620ec3d95ef 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -128,6 +128,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	mutex_init(&kvm->arch.config_lock);
+
+#ifdef CONFIG_LOCKDEP
+	/* Clue in lockdep that the config_lock must be taken inside kvm->lock */
+	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->lock);
+#endif
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -328,6 +338,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	spin_lock_init(&vcpu->arch.mp_state_lock);
 
+#ifdef CONFIG_LOCKDEP
+	/* Inform lockdep that the config_lock is acquired after vcpu->mutex */
+	mutex_lock(&vcpu->mutex);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+	mutex_unlock(&vcpu->mutex);
+#endif
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 9e023546bde0..b5dee8e57e77 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,7 +205,7 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
 
 	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
 		/*
@@ -262,9 +262,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	ret = kvm_set_vm_width(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	if (ret)
 		return ret;
-- 
2.40.0.348.gf938b09366-goog

