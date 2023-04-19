Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA3C3C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA550C433D2;
	Wed, 19 Apr 2023 12:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906884;
	bh=MnZH/pdwr8eTckayNx2A3YwtQysjRdeo/OXeEBlT5jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIF6yHDuSShCP5PicpodnHgQzCVUPwdYqV+ePxfXOeVU7j+3vN0uAbwZVh5hlhSnl
	 zjP3TSeLUBfbnKrqL32/csPtF/g2c3BWAYBUDPgYDDdXzsZLdVVj5v1SXq1I8MghBr
	 zhpLSUh1JsZXJZGmnVleKHb9zQFyzh9W4/1YPf0jM73r64ZiGrIwETwhAS14x8CQNp
	 ypk3qwwZF4rowZr7KsV4G0nUigHidtMC06XBbYPEwRm+Np4/nd6RJ9zniX9UvzWgDr
	 9ZjaLbMqjDTnoxOpmPfYBB4v+ghMdSyHMN5/TK3mtHHtG6fJvtwKsj7bZVtGLMAQGI
	 Bp/SGmbAbkmqw==
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
Subject: [PATCH v2 09/10] KVM: arm64: Handle FFA_FEATURES call from the host
Date: Wed, 19 Apr 2023 13:20:50 +0100
Message-Id: <20230419122051.1341-10-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Filter out advertising unsupported features, and only advertise
features and properties that are supported by the hypervisor proxy.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 45 +++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 45a2726d73ff..aa8bfc97a164 100644
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
@@ -480,14 +486,41 @@ static bool ffa_call_supported(u64 func_id)
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
@@ -497,6 +530,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
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
2.40.0.634.g4ca3ef3211-goog

