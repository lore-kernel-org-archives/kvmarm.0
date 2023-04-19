Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4A3C30
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3166BC433A0;
	Wed, 19 Apr 2023 12:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906863;
	bh=08AppxyzCwg0Jh3KAek3eE5f9QXIIhBbUTwzEv1w/h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm53Sm2FTxmA4xnxuhSoc1YrDr6PnicMyjNVK0w/n8vQoBwFOeh9dXddJSEznFKUi
	 gsg8LlnUx1tvnOUZxLCoCNYBCASq7ILp7ZgWLgfTxgPSjyY6FoWDq+aAYwjwi8Tf1M
	 wsIdfg417p0mst8ZNjoVzVlwQ9BowpF8t5COizS+Wu86imQjby/xGQf8EG6twRjeA4
	 7+PvkiPuxoms+kEM3eL6mJwdepPao/4+M22FBSMSOfsGVIbqLLDqq5+yE4NdzDbYd7
	 gwMRHvCisWV+CoRPnNAS4VBXvC+0QbBSsxwxxRVYSWTdxzYOFgZCt1eu2t2/HKvuFC
	 EbCBxhgF0JBVw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: [PATCH v2 02/10] KVM: arm64: Probe FF-A version and host/hyp partition ID during init
Date: Wed, 19 Apr 2023 13:20:43 +0100
Message-Id: <20230419122051.1341-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230419122051.1341-1-will@kernel.org>
References: <20230419122051.1341-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Probe FF-A during pKVM initialisation so that we can detect any
inconsistencies in the version or partition ID early on.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  1 +
 arch/arm64/kvm/arm.c                  |  1 +
 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 30 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c       |  5 +++++
 5 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..b7fe6e829231 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -391,6 +391,7 @@ struct kvm_host_data {
 struct kvm_host_psci_config {
 	/* PSCI version used by host. */
 	u32 version;
+	u32 smccc_version;
 
 	/* Function IDs used by host if version is v0.1. */
 	struct psci_0_1_function_ids function_ids_0_1;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4b2e16e696a8..3dab9a33e9f8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1790,6 +1790,7 @@ static bool __init init_psci_relay(void)
 	}
 
 	kvm_host_psci_config.version = psci_ops.get_version();
+	kvm_host_psci_config.smccc_version = arm_smccc_get_version();
 
 	if (kvm_host_psci_config.version == PSCI_VERSION(0, 1)) {
 		kvm_host_psci_config.function_ids_0_1 = get_psci_0_1_function_ids();
diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index fc09ec671e24..5c9b92430ff3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -11,6 +11,7 @@
 #define FFA_MIN_FUNC_NUM 0x60
 #define FFA_MAX_FUNC_NUM 0x7F
 
+int hyp_ffa_init(void);
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt);
 
 #endif /* __KVM_HYP_FFA_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a437b0727881..b387e433f15e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -31,6 +31,12 @@
 #include <nvhe/ffa.h>
 #include <nvhe/trap_handler.h>
 
+/*
+ * "ID value 0 must be returned at the Non-secure physical FF-A instance"
+ * We share this ID with the host.
+ */
+#define HOST_FFA_ID	0
+
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
 	*res = (struct arm_smccc_res) {
@@ -104,3 +110,27 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	ffa_set_retval(host_ctxt, &res);
 	return true;
 }
+
+int hyp_ffa_init(void)
+{
+	struct arm_smccc_res res;
+
+	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
+		return 0;
+
+	arm_smccc_1_1_smc(FFA_VERSION, FFA_VERSION_1_0, 0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 == FFA_RET_NOT_SUPPORTED)
+		return 0;
+
+	if (res.a0 != FFA_VERSION_1_0)
+		return -EOPNOTSUPP;
+
+	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 != FFA_SUCCESS)
+		return -EOPNOTSUPP;
+
+	if (res.a2 != HOST_FFA_ID)
+		return -EINVAL;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 110f04627785..c4ca174a0592 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -11,6 +11,7 @@
 #include <asm/kvm_pkvm.h>
 
 #include <nvhe/early_alloc.h>
+#include <nvhe/ffa.h>
 #include <nvhe/fixed_config.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
@@ -314,6 +315,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = hyp_ffa_init();
+	if (ret)
+		goto out;
+
 	pkvm_hyp_vm_table_init(vm_table_base);
 out:
 	/*
-- 
2.40.0.634.g4ca3ef3211-goog

