Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DE72D242
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 22:17:56 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685139475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S18IxtH870DftquD21o7n6kWwLX5SaNnDaD0Dom/QTg=;
	b=BzyKJLOaung4P0+diZU10+gVqxNUKL3dnOf9jXTmxf5FBxePeWgLGXjV6IHWdk40Wal/0M
	bHvK1jDd2lVz++XB7giFz7WMxlotkRKBzMCydwagmZXYqn3ZdigynMKizoAI2T0FSRDAVA
	7PbMaFwKk/iODnRrf4pvHoO1IBjQiwA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 16/21] aarch64: psci: Implement CPU_OFF
Date: Fri, 26 May 2023 22:17:07 +0000
Message-ID: <20230526221712.317287-17-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add support for PSCI CPU_OFF, relying on KVM emulation of a 'powered
off' vCPU by setting the MP state to KVM_MP_STATE_STOPPED.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/psci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index abfdc764b7e0..72429b36a835 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -17,6 +17,7 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	switch (arg) {
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_CPU_OFF:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -36,6 +37,16 @@ static void cpu_suspend(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	res->a0 = PSCI_RET_SUCCESS;
 }
 
+static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_STOPPED,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -49,6 +60,9 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_SUSPEND:
 		cpu_suspend(vcpu, res);
 		break;
+	case PSCI_0_2_FN_CPU_OFF:
+		cpu_off(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.rc0.172.g3f132b7071-goog

