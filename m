Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20CF1EA6B
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA67C433A8;
	Tue, 23 May 2023 10:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684837136;
	bh=8oEz0MTY5vsbOffV05k3O/HgSWc3vJsS4CWhAaejjHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIOO3ouVvalw6V53fGCnZOm286yu+AWyjLu4f8041hN3ll0ox0GW8WsXyll0yuSD1
	 xvWCuBdlyeOv7n1jDowKhvK9EEyD66zDIhSba5Lla7q0bkfFm6piOLYBI90cwYmo4Q
	 P8fsML90KbiZXn85otfLriMHzqcLH+uYNRVSSQymJNH91kbcQ9NySjxQa/zYr7fJyi
	 AHu36GmzdbSBKCoOrDSwd6lyNBT/DCRRO38GkhPm/4R70LWWT+16XjUZDNfxQXHu7X
	 nsjxdE6/IMxFfohcJz/12eXHptiZyIVSpsf12r2qgAHSAQQIBd8fhyB2IyXWx4guEh
	 5G2QuO3gw3JtA==
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
Subject: [PATCH v3 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the host
Date: Tue, 23 May 2023 11:18:25 +0100
Message-Id: <20230523101828.7328-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230523101828.7328-1-will@kernel.org>
References: <20230523101828.7328-1-will@kernel.org>
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
index 550936f4b5da..d90ab1c9ec72 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -116,10 +116,10 @@ static int ffa_unmap_hyp_buffers(void)
 	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
 }
 
-static void ffa_mem_share(struct arm_smccc_res *res, u32 len, u32 fraglen)
+static void ffa_mem_xfer(struct arm_smccc_res *res, u64 func_id, u32 len,
+			  u32 fraglen)
 {
-	arm_smccc_1_1_smc(FFA_FN64_MEM_SHARE,
-			  len, fraglen,
+	arm_smccc_1_1_smc(func_id, len, fraglen,
 			  0, 0, 0, 0, 0,
 			  res);
 }
@@ -321,8 +321,9 @@ static int ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
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
@@ -333,6 +334,9 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	int ret = 0;
 	u32 offset;
 
+	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
+		     func_id != FFA_FN64_MEM_LEND);
+
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -382,7 +386,7 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	if (ret)
 		goto out_unlock;
 
-	ffa_mem_share(res, len, fraglen);
+	ffa_mem_xfer(res, func_id, len, fraglen);
 	if (res->a0 != FFA_SUCCESS) {
 		WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 						reg->addr_range_cnt));
@@ -519,11 +523,15 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
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
2.40.1.698.g37aff9b760-goog

