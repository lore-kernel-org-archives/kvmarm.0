Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B6A3C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166F0C433A0;
	Wed, 19 Apr 2023 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906869;
	bh=7V0H/Z0cY5qFw40r2vsiItqUftnOGn1oIzj1w+Sj4gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZaj8BML6DaQYj377zA2dS1HBKIMpV9VqZzlxcPi4FMxnNEWnx6A/hcM1fmhYlKKW
	 Xdy1D0JxEH20/1R353GiCKt9pzLQiIY0vVqS1UfSKIt/f3jWMh4ZqUao40nnNpsau3
	 7DneeKhgXazJwP1WFxufGYOsQYhRvpaze+V3qGCeDDvyUSJ7Or3dCWVJT47lr3T/hh
	 i2YNuUcCHlCmdeKq/MIUAi/ezIKHLGN77J+f4MOxmeGn+7GMaQTcKM9xP0L3mkq+b8
	 XgwHRnpaNNMNRojMX72YOjmOPVf4pFFKEtZYg9/96O58/iJ07p+4BZ2irYeq0YIbXr
	 hWQlIWjLwp7SQ==
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
	kernel-team@android.com,
	Andrew Walbran <qwandor@google.com>
Subject: [PATCH v2 04/10] KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host
Date: Wed, 19 Apr 2023 13:20:45 +0100
Message-Id: <20230419122051.1341-5-will@kernel.org>
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

Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host by sharing
the host's mailbox memory with the hypervisor and establishing a
separate pair of mailboxes between the hypervisor and the SPMD at EL3.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 184 ++++++++++++++++++++++++++++++++++
 include/linux/arm_ffa.h       |   8 ++
 2 files changed, 192 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index de0fba79b195..9ee3be517e1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -31,6 +31,8 @@
 #include <asm/kvm_pkvm.h>
 
 #include <nvhe/ffa.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/memory.h>
 #include <nvhe/trap_handler.h>
 #include <nvhe/spinlock.h>
 
@@ -52,6 +54,7 @@ struct kvm_ffa_buffers {
  * client.
  */
 static struct kvm_ffa_buffers hyp_buffers;
+static struct kvm_ffa_buffers host_buffers;
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -61,6 +64,15 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 	};
 }
 
+static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
+{
+	if (ret == FFA_RET_SUCCESS) {
+		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS };
+	} else {
+		ffa_to_smccc_error(res, ret);
+	}
+}
+
 static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 			   struct arm_smccc_res *res)
 {
@@ -78,6 +90,140 @@ static bool is_ffa_call(u64 func_id)
 	       ARM_SMCCC_FUNC_NUM(func_id) <= FFA_MAX_FUNC_NUM;
 }
 
+static int spmd_map_ffa_buffers(u64 ffa_page_count)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(FFA_FN64_RXTX_MAP,
+			  hyp_virt_to_phys(hyp_buffers.tx),
+			  hyp_virt_to_phys(hyp_buffers.rx),
+			  ffa_page_count,
+			  0, 0, 0, 0,
+			  &res);
+
+	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
+}
+
+static int spmd_unmap_ffa_buffers(void)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(FFA_RXTX_UNMAP,
+			  HOST_FFA_ID,
+			  0, 0, 0, 0, 0, 0,
+			  &res);
+
+	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
+}
+
+static void do_ffa_rxtx_map(struct arm_smccc_res *res,
+			    struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(phys_addr_t, tx, ctxt, 1);
+	DECLARE_REG(phys_addr_t, rx, ctxt, 2);
+	DECLARE_REG(u32, npages, ctxt, 3);
+	int ret = 0;
+	void *rx_virt, *tx_virt;
+
+	if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	if (!PAGE_ALIGNED(tx) || !PAGE_ALIGNED(rx)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	hyp_spin_lock(&host_buffers.lock);
+	if (host_buffers.tx) {
+		ret = FFA_RET_DENIED;
+		goto out_unlock;
+	}
+
+	ret = spmd_map_ffa_buffers(npages);
+	if (ret)
+		goto out_unlock;
+
+	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
+	if (ret) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto err_unmap;
+	}
+
+	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(rx));
+	if (ret) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto err_unshare_tx;
+	}
+
+	tx_virt = hyp_phys_to_virt(tx);
+	ret = hyp_pin_shared_mem(tx_virt, tx_virt + 1);
+	if (ret) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto err_unshare_rx;
+	}
+
+	rx_virt = hyp_phys_to_virt(rx);
+	ret = hyp_pin_shared_mem(rx_virt, rx_virt + 1);
+	if (ret) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto err_unpin_tx;
+	}
+
+	host_buffers.tx = tx_virt;
+	host_buffers.rx = rx_virt;
+
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+out:
+	ffa_to_smccc_res(res, ret);
+	return;
+
+err_unpin_tx:
+	hyp_unpin_shared_mem(tx_virt, tx_virt + 1);
+err_unshare_rx:
+	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(rx));
+err_unshare_tx:
+	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
+err_unmap:
+	spmd_unmap_ffa_buffers();
+	goto out_unlock;
+}
+
+static void do_ffa_rxtx_unmap(struct arm_smccc_res *res,
+			      struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, id, ctxt, 1);
+	int ret = 0;
+
+	if (id != HOST_FFA_ID) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	hyp_spin_lock(&host_buffers.lock);
+	if (!host_buffers.tx) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	hyp_unpin_shared_mem(host_buffers.tx, host_buffers.tx + 1);
+	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.tx)));
+	host_buffers.tx = NULL;
+
+	hyp_unpin_shared_mem(host_buffers.rx, host_buffers.rx + 1);
+	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.rx)));
+	host_buffers.rx = NULL;
+
+	spmd_unmap_ffa_buffers();
+
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+out:
+	ffa_to_smccc_res(res, ret);
+}
+
 /*
  * Is a given FFA function supported, either by forwarding on directly
  * or by handling at EL2?
@@ -119,10 +265,21 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	if (!is_ffa_call(func_id))
 		return false;
 
+	switch (func_id) {
+	/* Memory management */
+	case FFA_FN64_RXTX_MAP:
+		do_ffa_rxtx_map(&res, host_ctxt);
+		goto out_handled;
+	case FFA_RXTX_UNMAP:
+		do_ffa_rxtx_unmap(&res, host_ctxt);
+		goto out_handled;
+	}
+
 	if (ffa_call_supported(func_id))
 		return false; /* Pass through */
 
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
+out_handled:
 	ffa_set_retval(host_ctxt, &res);
 	return true;
 }
@@ -130,6 +287,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
+	size_t min_rxtx_sz;
 
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
@@ -148,11 +306,37 @@ int hyp_ffa_init(void *pages)
 	if (res.a2 != HOST_FFA_ID)
 		return -EINVAL;
 
+	arm_smccc_1_1_smc(FFA_FEATURES, FFA_FN64_RXTX_MAP,
+			  0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 != FFA_SUCCESS)
+		return -EOPNOTSUPP;
+
+	switch (res.a2) {
+	case FFA_FEAT_RXTX_MIN_SZ_4K:
+		min_rxtx_sz = SZ_4K;
+		break;
+	case FFA_FEAT_RXTX_MIN_SZ_16K:
+		min_rxtx_sz = SZ_16K;
+		break;
+	case FFA_FEAT_RXTX_MIN_SZ_64K:
+		min_rxtx_sz = SZ_64K;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (min_rxtx_sz > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
 	hyp_buffers = (struct kvm_ffa_buffers) {
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
 		.tx	= pages,
 		.rx	= pages + (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE),
 	};
 
+	host_buffers = (struct kvm_ffa_buffers) {
+		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
+	};
+
 	return 0;
 }
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index c87aeecaa9b2..b9f81035eb41 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -94,6 +94,14 @@
  */
 #define FFA_PAGE_SIZE		SZ_4K
 
+/*
+ * Minimum buffer size/alignment encodings returned by an FFA_FEATURES
+ * query for FFA_RXTX_MAP.
+ */
+#define FFA_FEAT_RXTX_MIN_SZ_4K		0
+#define FFA_FEAT_RXTX_MIN_SZ_64K	1
+#define FFA_FEAT_RXTX_MIN_SZ_16K	2
+
 /* FFA Bus/Device/Driver related */
 struct ffa_device {
 	int vm_id;
-- 
2.40.0.634.g4ca3ef3211-goog

