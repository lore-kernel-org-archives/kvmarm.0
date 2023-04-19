Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E033C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1F5C4339B;
	Wed, 19 Apr 2023 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906881;
	bh=2HmF/rrmNTLMvR62HDkjMR+nhULL3D8G/C1iWDUA6cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCuP8SSjnupsi9wKkrWB/Afy1vHyUEbNrFk5lbucjuBu8vn2aIC+Sxaa2a2p1Im0e
	 doA/fahslm4t8e8mSq7yIIDi64ltRSYla0dfQZ7kZDd0UoC6EVqTqWz0OlNQPOf3H0
	 Nunorhv9QpX/pLc2HYQdL4RZ1wpQbUcSus4fu3qTm2AYI5RLpJWgFhCXNHfkIyr9iG
	 eIjyhBtgWN3hI54aA0kw5y/bMwegGseangIt6dePe7398YvRsC2X8YhygBerHhVYTH
	 1BXApBx4VKiSJfzjQO5IzEcMdNOVMRqZeZka780f4IxCcCKDLZ+IMBbIi0DxZi8QE3
	 aULNU2e3Ag96Q==
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
Subject: [PATCH v2 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the host
Date: Wed, 19 Apr 2023 13:20:49 +0100
Message-Id: <20230419122051.1341-9-will@kernel.org>
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

Handle FFA_MEM_LEND calls from the host by treating them identically to
FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
forwarding on the original request to EL3.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b23e3869ce63..45a2726d73ff 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -116,10 +116,10 @@ static int spmd_unmap_ffa_buffers(void)
 	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
 }
 
-static void spmd_mem_share(struct arm_smccc_res *res, u32 len, u32 fraglen)
+static void spmd_mem_xfer(struct arm_smccc_res *res, u64 func_id, u32 len,
+			  u32 fraglen)
 {
-	arm_smccc_1_1_smc(FFA_FN64_MEM_SHARE,
-			  len, fraglen,
+	arm_smccc_1_1_smc(func_id, len, fraglen,
 			  0, 0, 0, 0, 0,
 			  res);
 }
@@ -317,8 +317,9 @@ static int ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
 	return ret;
 }
 
-static void do_ffa_mem_share(struct arm_smccc_res *res,
-			     struct kvm_cpu_context *ctxt)
+static __always_inline void do_ffa_mem_xfer(const u64 func_id,
+					    struct arm_smccc_res *res,
+					    struct kvm_cpu_context *ctxt)
 {
 	DECLARE_REG(u32, len, ctxt, 1);
 	DECLARE_REG(u32, fraglen, ctxt, 2);
@@ -329,6 +330,9 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	int ret = 0;
 	u32 offset;
 
+	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
+		     func_id != FFA_FN64_MEM_LEND);
+
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -378,7 +382,7 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	if (ret)
 		goto out_unlock;
 
-	spmd_mem_share(res, len, fraglen);
+	spmd_mem_xfer(res, func_id, len, fraglen);
 	if (res->a0 != FFA_SUCCESS) {
 		WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 						reg->addr_range_cnt));
@@ -502,11 +506,15 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 		goto out_handled;
 	case FFA_MEM_SHARE:
 	case FFA_FN64_MEM_SHARE:
-		do_ffa_mem_share(&res, host_ctxt);
+		do_ffa_mem_xfer(FFA_FN64_MEM_SHARE, &res, host_ctxt);
 		goto out_handled;
 	case FFA_MEM_RECLAIM:
 		do_ffa_mem_reclaim(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MEM_LEND:
+	case FFA_FN64_MEM_LEND:
+		do_ffa_mem_xfer(FFA_FN64_MEM_LEND, &res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.40.0.634.g4ca3ef3211-goog

