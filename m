Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B303C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F2AC433D2;
	Wed, 19 Apr 2023 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906878;
	bh=CE/ZmkI1NSImtPBKJlWk69K3yDP2TFYkhL0CwNJnYjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InI1qxAu/gIhWKlzii8WvehV33kKSvT6m3yxTVxoKntxtmSxp//d0w0xzO1hVtfng
	 Rm7QbMh/9VndlFDSBcG3Gae2w30dEHIvjQbYnSPff6W4qYQcu1WlHzyIGVr1ugqyP2
	 QAkwx1KRCApZ6s3n110ESHpKp//pxHdsWvf7Fzf+XVaO4xTAGbpK8hQS8C/fmfUEoY
	 NpbkOs57i6rxBa2o9SqhBYr41K1PhYJNghDhaEG4NE7osmwMsuYttaW3z9wMi3sHkX
	 bd0XZZ1dLZWm8zM56mr5KfyyQmfqj2T0/5ga+QnNAovgzpYn1Lht3C16Snuc3scJnc
	 MaaKKyy+ZW5jQ==
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
Subject: [PATCH v2 07/10] KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
Date: Wed, 19 Apr 2023 13:20:48 +0100
Message-Id: <20230419122051.1341-8-will@kernel.org>
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

Intecept FFA_MEM_RECLAIM calls from the host and transition the host
stage-2 page-table entries from the SHARED_OWNED state back to the OWNED
state once EL3 has confirmed that the secure mapping has been reclaimed.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 79 +++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 95bc70e52e91..b23e3869ce63 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -124,6 +124,23 @@ static void spmd_mem_share(struct arm_smccc_res *res, u32 len, u32 fraglen)
 			  res);
 }
 
+static void spmd_mem_reclaim(struct arm_smccc_res *res, u32 handle_lo,
+			     u32 handle_hi, u32 flags)
+{
+	arm_smccc_1_1_smc(FFA_MEM_RECLAIM,
+			  handle_lo, handle_hi, flags,
+			  0, 0, 0, 0,
+			  res);
+}
+
+static void spmd_retrieve_req(struct arm_smccc_res *res, u32 len)
+{
+	arm_smccc_1_1_smc(FFA_FN64_MEM_RETRIEVE_REQ,
+			  len, len,
+			  0, 0, 0, 0, 0,
+			  res);
+}
+
 static void do_ffa_rxtx_map(struct arm_smccc_res *res,
 			    struct kvm_cpu_context *ctxt)
 {
@@ -375,6 +392,65 @@ static void do_ffa_mem_share(struct arm_smccc_res *res,
 	return;
 }
 
+static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
+			       struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, handle_lo, ctxt, 1);
+	DECLARE_REG(u32, handle_hi, ctxt, 2);
+	DECLARE_REG(u32, flags, ctxt, 3);
+	struct ffa_composite_mem_region *reg;
+	struct ffa_mem_region *buf;
+	int ret = 0;
+	u32 offset;
+	u64 handle;
+
+	handle = PACK_HANDLE(handle_lo, handle_hi);
+
+	hyp_spin_lock(&host_buffers.lock);
+
+	buf = hyp_buffers.tx;
+	*buf = (struct ffa_mem_region) {
+		.sender_id	= HOST_FFA_ID,
+		.handle		= handle,
+	};
+
+	spmd_retrieve_req(res, sizeof(*buf));
+	buf = hyp_buffers.rx;
+	if (res->a0 != FFA_MEM_RETRIEVE_RESP)
+		goto out_unlock;
+
+	/* Check for fragmentation */
+	if (res->a1 != res->a2) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
+	offset = buf->ep_mem_access[0].composite_off;
+	/*
+	 * We can trust the SPMD to get this right, but let's at least
+	 * check that we end up with something that doesn't look _completely_
+	 * bogus.
+	 */
+	if (WARN_ON(offset > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
+		ret = FFA_RET_ABORTED;
+		goto out_unlock;
+	}
+
+	reg = (void *)buf + offset;
+	spmd_mem_reclaim(res, handle_lo, handle_hi, flags);
+	if (res->a0 != FFA_SUCCESS)
+		goto out_unlock;
+
+	/* If the SPMD was happy, then we should be too. */
+	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
+					reg->addr_range_cnt));
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+
+	if (ret)
+		ffa_to_smccc_res(res, ret);
+}
+
 /*
  * Is a given FFA function supported, either by forwarding on directly
  * or by handling at EL2?
@@ -428,6 +504,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	case FFA_FN64_MEM_SHARE:
 		do_ffa_mem_share(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MEM_RECLAIM:
+		do_ffa_mem_reclaim(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.40.0.634.g4ca3ef3211-goog

