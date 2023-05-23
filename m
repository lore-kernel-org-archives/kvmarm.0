Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618DC1EA6B
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EBEC433A4;
	Tue, 23 May 2023 10:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684837139;
	bh=bVOjEQnVhuatfAAzuLAt5ovgaWm6Wz0ZkmC8mkLZJds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHPldyrzLff27XQHPks/a8sk6yfKK8GyDW13Q1mYPtij88vcRZgKSlwNv+xtsZH2w
	 ssXBX5+htbJFllmKKi2WrK9JY8vDwU1QU6giMvKcvPjTLt9NqA61uDZIXfMuc4r1+j
	 1POCsRnQYIrGO35hJs7ZX+b8zWSQhtu4WDGj0KzyxpeFVuIthl/CcfIznH/H3fTtB7
	 BF+6+6Ju2GbZfp6OtjzMy8mYVEywRoJeHnlY0G5bD05XHb7yvl+Dh4XGpIYOV+N+Qs
	 jVAnGAMjc0LBzQarQf8p6PZNe8WwW0VuKHcyqtBo0gbBlYkSrFGd2Yqy6CYkrOddzP
	 qnOOv4kvlaNEg==
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
Subject: [PATCH v3 09/10] KVM: arm64: Handle FFA_FEATURES call from the host
Date: Tue, 23 May 2023 11:18:26 +0100
Message-Id: <20230523101828.7328-10-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Filter out advertising unsupported features, and only advertise
features and properties that are supported by the hypervisor proxy.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 45 +++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index d90ab1c9ec72..926314a9b9d7 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -64,15 +64,21 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 	};
 }
 
-static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
+static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
 {
 	if (ret == FFA_RET_SUCCESS) {
-		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS };
+		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS,
+						.a2 = prop };
 	} else {
 		ffa_to_smccc_error(res, ret);
 	}
 }
 
+static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
+{
+	ffa_to_smccc_res_prop(res, ret, 0);
+}
+
 static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 			   struct arm_smccc_res *res)
 {
@@ -484,14 +490,41 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-	/* Don't advertise any features just yet */
-	case FFA_FEATURES:
 		return false;
 	}
 
 	return true;
 }
 
+static bool do_ffa_features(struct arm_smccc_res *res,
+			    struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, id, ctxt, 1);
+	u64 prop = 0;
+	int ret = 0;
+
+	if (!ffa_call_supported(id)) {
+		ret = FFA_RET_NOT_SUPPORTED;
+		goto out_handled;
+	}
+
+	switch (id) {
+	case FFA_MEM_SHARE:
+	case FFA_FN64_MEM_SHARE:
+	case FFA_MEM_LEND:
+	case FFA_FN64_MEM_LEND:
+		ret = FFA_RET_SUCCESS;
+		prop = 0; /* No support for dynamic buffers */
+		goto out_handled;
+	default:
+		return false;
+	}
+
+out_handled:
+	ffa_to_smccc_res_prop(res, ret, prop);
+	return true;
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, func_id, host_ctxt, 0);
@@ -514,6 +547,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 		return false;
 
 	switch (func_id) {
+	case FFA_FEATURES:
+		if (!do_ffa_features(&res, host_ctxt))
+			return false;
+		goto out_handled;
 	/* Memory management */
 	case FFA_FN64_RXTX_MAP:
 		do_ffa_rxtx_map(&res, host_ctxt);
-- 
2.40.1.698.g37aff9b760-goog

