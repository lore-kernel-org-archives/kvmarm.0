Received: from out-79.mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC67817FEA
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 23:43:37 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691019816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qqT0zCIJsEeSPR80PQTsas7oUgXS+gw93IfHYu9wlXc=;
	b=GWwYipisLUNDHZ2+LIg0+myKZsLRdyss9c2xt5cQQ2cOj4l5eglpPA12W2WZuAXL25Yb98
	f6jx8M/s4t0QYcYet6R1bNRK8j5EzRI4sQ5cnHUZGyGTiDELfxTwteO8kdtS3XiErDmf5U
	tQxaA6C53ZA7ttZm4pnlAmu1F4V+Dr4=
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
Subject: [PATCH kvmtool v3 12/17] aarch64: psci: Implement CPU_OFF
Date: Wed,  2 Aug 2023 23:42:50 +0000
Message-ID: <20230802234255.466782-13-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
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
2.41.0.585.gd2178a4bd4-goog

