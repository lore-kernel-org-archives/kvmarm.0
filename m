Received: from out-76.mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3AF17FEA
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 23:43:35 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691019814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgV/YkRuoGK7JAbjSL224m11AE8yfT1qu12skCQUl1I=;
	b=SK3BEK6XIB99aJ+dZl/H5bkYIqNPTRfInroYqZjC1+DeQg9gdYeTkbET3s9fpnKEN6Z4Fw
	R2KHzbW1yexLk+T8LzWmy4OGgOdRZo80r4Qdn5uzpFxdmrmRK2B2HGkraXH0ZX6SgwSZp/
	JY6DjnUUv0xFWeoCHvoPkiWwCdHx63U=
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
Subject: [PATCH kvmtool v3 11/17] aarch64: psci: Implement CPU_SUSPEND
Date: Wed,  2 Aug 2023 23:42:49 +0000
Message-ID: <20230802234255.466782-12-oliver.upton@linux.dev>
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

Implement support for PSCI CPU_SUSPEND, leveraging in-kernel suspend
emulation (i.e. a WFI state). Eagerly resume the vCPU for any wakeup
event.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/kvm-cpu.c | 18 ++++++++++++++++++
 arm/aarch64/psci.c    | 19 +++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 4feed9f41cb0..316e20c7f157 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -263,6 +263,16 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
 }
 
+static void handle_wakeup(struct kvm_cpu *vcpu)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_RUNNABLE,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
 	struct kvm_run *run = vcpu->kvm_run;
@@ -271,6 +281,14 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 	case KVM_EXIT_HYPERCALL:
 		handle_hypercall(vcpu);
 		return true;
+	case KVM_EXIT_SYSTEM_EVENT:
+		switch (run->system_event.type) {
+		case KVM_SYSTEM_EVENT_WAKEUP:
+			handle_wakeup(vcpu);
+			return true;
+		default:
+			return false;
+		}
 	default:
 		return false;
 	}
diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index 482b9a7442c6..abfdc764b7e0 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -15,12 +15,27 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		return;
 
 	switch (arg) {
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
 	}
 }
 
+static void cpu_suspend(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_SUSPENDED,
+	};
+
+	/* Rely on in-kernel emulation of a 'suspended' (i.e. WFI) state. */
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+
+	res->a0 = PSCI_RET_SUCCESS;
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -30,6 +45,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		psci_features(vcpu, res);
 		break;
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		cpu_suspend(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.585.gd2178a4bd4-goog

