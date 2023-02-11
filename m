Received: from out-129.mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CC5A23
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 04:20:22 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676079501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMHylM3w6c4OLWhS6cH5kkFUnRyYPx005aFa1ArQdjA=;
	b=WWkeWl7sjI1Gpg8qoCkjEUHiGV2dAqXuKmNZm7O2cbD8OEAlTS+xPvSCJO73OHBMz8sbah
	cH6d/k09iT21iO6Lqcne7ZP/AnV5Lw5W/67EajnpaGalghi5njhXajNU9CO2iuI8WOj02I
	QWMIxRS6rgcnZpbTnr8K8WLhCm0OhwU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH v2 5/6] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Date: Sat, 11 Feb 2023 01:37:58 +0000
Message-Id: <20230211013759.3556016-6-oliver.upton@linux.dev>
In-Reply-To: <20230211013759.3556016-1-oliver.upton@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In anticipation of user hypercall filters, add the necessary plumbing to
get SMCCC calls out to userspace. Even though the exit structure has
space for KVM to pass register arguments, let's just avoid it altogether
and let userspace poke at the registers via KVM_GET_ONE_REG.

This deliberately stretches the definition of a 'hypercall' to cover
SMCs from EL1 in addition to the HVCs we know and love. KVM doesn't
support EL1 calls into secure services, but now we can paint that as a
userspace problem and be done with it.

Finally, we need a flag to let userspace know what conduit instruction
was used (i.e. SMC vs. HVC). Redefine the remaining padding in
kvm_run::hypercall to accomplish this. Let's all take a moment
to admire the flowers and see how 'longmode' tied up a full u32 in the
UAPI. Weep.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst    | 24 +++++++++++++++++++++---
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/handle_exit.c      | 12 +++++++++---
 arch/arm64/kvm/hypercalls.c       | 31 +++++++++++++++++++++++++++++++
 include/kvm/arm_hypercalls.h      |  1 +
 include/uapi/linux/kvm.h          |  2 +-
 6 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index deb494f759ed..c82da1a84590 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6119,14 +6119,32 @@ to the byte array.
 			__u64 args[6];
 			__u64 ret;
 			__u32 longmode;
-			__u32 pad;
+			__u32 flags;
 		} hypercall;
 
-Unused.  This was once used for 'hypercall to userspace'.  To implement
-such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
+
+It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
+``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
+requires a guest to interact with host userpace.
 
 .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
 
+For arm64:
+----------
+
+SMCCC exits can be enabled depending on the configuration of the SMCCC
+filter. See the Documentation/virt/kvm/devices/vm.rst
+``KVM_ARM_SMCCC_FILTER`` for more details.
+
+``nr`` contains the function ID of the guest's SMCCC call. Userspace is
+expected to use the ``KVM_GET_ONE_REG`` ioctl to retrieve the call
+parameters from the vCPU's GPRs.
+
+Definition of ``flags``:
+ - ``KVM_HYPERCALL_EXIT_SMC``: Indicates that the guest used the SMC
+   conduit to initiate the SMCCC call. If this bit is 0 then the guest
+   used the HVC conduit for the SMCCC call.
+
 ::
 
 		/* KVM_EXIT_TPR_ACCESS */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index e298574a45ea..5c98e7c39ba1 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -471,12 +471,16 @@ enum {
 enum kvm_smccc_filter_action {
 	KVM_SMCCC_FILTER_ALLOW = 0,
 	KVM_SMCCC_FILTER_DENY,
+	KVM_SMCCC_FILTER_FWD_TO_USER,
 
 #ifdef __KERNEL__
 	NR_SMCCC_FILTER_ACTIONS
 #endif
 };
 
+/* arm64-specific KVM_EXIT_HYPERCALL flags */
+#define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e778eefcf214..d15ff6c795e1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -52,6 +52,8 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
+	int ret = kvm_smc_call_handler(vcpu);
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
@@ -60,9 +62,13 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 * We need to advance the PC after the trap, as it would
 	 * otherwise return to the same address...
 	 */
-	vcpu_set_reg(vcpu, 0, ~0UL);
-	kvm_incr_pc(vcpu);
-	return 1;
+	if (ret < 0) {
+		vcpu_set_reg(vcpu, 0, ~0UL);
+		kvm_incr_pc(vcpu);
+		return 1;
+	}
+
+	return ret;
 }
 
 /*
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 45b8371816fd..f095c048730a 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -161,6 +161,17 @@ static u8 kvm_hvc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
 	return KVM_SMCCC_FILTER_DENY;
 }
 
+static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id, bool smc)
+{
+	struct kvm_run *run = vcpu->run;
+
+	run->exit_reason = KVM_EXIT_HYPERCALL;
+	run->hypercall.nr = func_id;
+
+	if (smc)
+		run->hypercall.flags = KVM_HYPERCALL_EXIT_SMC;
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
@@ -173,6 +184,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	action = kvm_hvc_get_action(vcpu, func_id);
 	if (action == KVM_SMCCC_FILTER_DENY)
 		goto out;
+	if (action == KVM_SMCCC_FILTER_FWD_TO_USER) {
+		kvm_prepare_hypercall_exit(vcpu, func_id, false);
+		return 0;
+	}
 
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
@@ -270,6 +285,22 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+int kvm_smc_call_handler(struct kvm_vcpu *vcpu)
+{
+	u32 func_id = smccc_get_function(vcpu);
+	u8 action = kvm_smccc_filter_get_action(vcpu->kvm, func_id);
+
+	/*
+	 * KVM doesn't support SMCs from EL1, so reject the call if userspace
+	 * doesn't want it.
+	 */
+	if (action != KVM_SMCCC_FILTER_FWD_TO_USER)
+		return -ENOSYS;
+
+	kvm_prepare_hypercall_exit(vcpu, func_id, true);
+	return 0;
+}
+
 static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_PSCI_VERSION,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index ae1ada68cdc2..4707aa206c4e 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -7,6 +7,7 @@
 #include <asm/kvm_emulate.h>
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
+int kvm_smc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..0ae7cf8ca2db 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -342,7 +342,7 @@ struct kvm_run {
 			__u64 args[6];
 			__u64 ret;
 			__u32 longmode;
-			__u32 pad;
+			__u32 flags;
 		} hypercall;
 		/* KVM_EXIT_TPR_ACCESS */
 		struct {
-- 
2.39.1.581.gbfd45094c4-goog

