Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5CE3DE42C
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880678; cv=none; b=l7QxSoX4jGcliz8Sjm5hzFl1ztkX2CEdmOhrRjJovC3SZ3fjlWZmwAw16zPagRmngQmq03awMLbDyxw7SUjt+O/dYQPefbklDjW8Qp9l4ffrZILVOR+aMm3KfVXe2/7oPR6gWpe8g5YEpHivwTBdzXTJeL1ah/Z/ZdatzZsGrRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880678; c=relaxed/simple;
	bh=0wb/UP6K5ikFmLshj6PNreIcmQ3EuRsKvxwe6jyPGMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAv6gvzfi20TxwhVhtQKq4LmSiIb/o7hzvwYQYJ4Q8AiRo6qsrEPtmra8PkSyva8TcTvi6I+mvD2s5jZOSNjVzCku9wiS1+EyGPb0gZqjr8SyrPmfsWLdQlwcanV9DsuQXPkDveVO/+pzX26yh7xVy9UYUKFoypV6kvOohKixCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GDuQsqaL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GDuQsqaL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46BDF1E7D;
	Mon, 30 Mar 2026 07:24:30 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 855023F915;
	Mon, 30 Mar 2026 07:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880676; bh=0wb/UP6K5ikFmLshj6PNreIcmQ3EuRsKvxwe6jyPGMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDuQsqaLNSKZT0qt/E3z/vZHAUI+d3hMr7S5ojNrShnsdE686HFAfnvwN8kgOW8ut
	 7H9itu21+RaUBOW/OVHb56T/kkYfzMscsrNcAK8lPLz3RJ6UanUEbITsCOSMayFwqx
	 DARwqwyPNg/k00rE1r96jy1I8ANFjrXQFnVO9oxA=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 13/17] arm64: psci: Implement CPU_ON
Date: Mon, 30 Mar 2026 15:23:30 +0100
Message-ID: <20260330142334.3309961-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Add support for the PSCI CPU_ON call, wherein a caller can power on a
targeted CPU and reset it with the provided context (i.e. entrypoint and
context id). Rely on the KVM_ARM_VCPU_INIT ioctl, which has the effect
of an architectural warm reset, to do the heavy lifting.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 72429b36..14c98639 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -18,6 +18,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
 	case PSCI_0_2_FN_CPU_OFF:
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -47,6 +49,68 @@ static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		die_perror("KVM_SET_MP_STATE failed");
 }
 
+static void reset_cpu_with_context(struct kvm_cpu *vcpu, u64 entry_addr, u64 ctx_id)
+{
+	struct kvm_one_reg reg;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu->init))
+		die_perror("KVM_ARM_VCPU_INIT failed");
+
+	reg = (struct kvm_one_reg) {
+		.id	= ARM64_CORE_REG(regs.pc),
+		.addr	= (u64)&entry_addr,
+	};
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+		die_perror("KVM_SET_ONE_REG failed");
+
+	reg = (struct kvm_one_reg) {
+		.id	= ARM64_CORE_REG(regs.regs[0]),
+		.addr	= (u64)&ctx_id,
+	};
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+		die_perror("KVM_SET_ONE_REG failed");
+}
+
+static bool psci_valid_affinity(u64 affinity)
+{
+	return !(affinity & ~ARM_MPIDR_HWID_BITMASK);
+}
+
+static void cpu_on(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u64 target_mpidr = smccc_get_arg(vcpu, 1);
+	u64 entry_addr = smccc_get_arg(vcpu, 2);
+	u64 ctx_id = smccc_get_arg(vcpu, 3);
+	struct kvm_mp_state mp_state;
+	struct kvm_cpu *target;
+
+	if (!psci_valid_affinity(target_mpidr)) {
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+		return;
+	}
+
+	kvm__pause(vcpu->kvm);
+
+	target = kvm__arch_mpidr_to_vcpu(vcpu->kvm, target_mpidr);
+	if (!target) {
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+		goto out_continue;
+	}
+
+	if (ioctl(target->vcpu_fd, KVM_GET_MP_STATE, &mp_state))
+		die_perror("KVM_GET_MP_STATE failed");
+
+	if (mp_state.mp_state != KVM_MP_STATE_STOPPED) {
+		res->a0 = PSCI_RET_ALREADY_ON;
+		goto out_continue;
+	}
+
+	reset_cpu_with_context(target, entry_addr, ctx_id);
+	res->a0 = PSCI_RET_SUCCESS;
+out_continue:
+	kvm__continue(vcpu->kvm);
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -63,6 +127,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_OFF:
 		cpu_off(vcpu, res);
 		break;
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
+		cpu_on(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0

