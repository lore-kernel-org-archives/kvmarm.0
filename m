Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBEDD504
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:03:51 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-36810cfa61fso165808527b3.6
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IGAnxq8TxsaiJ4rE+mUN7BVSpa7cDNjlDGASV4bWpCs=;
        b=WJwAIwpyllGWtU5Y33F3Liqf/YIvtoOmru97wtImoiBp3Nn+xEqI6tv0y2+K8Y7cd8
         YfsCJHf+g7pz4Ql+A0xh0aj+hrJ3JREtrpdk3cKf9lbVimZUCy1iAsJ5cwZHBLNJRolK
         5jQqTJEtMgZ86xyOJjcSpBktYOO7HT4+lfBK2eT41evfRAQV5Cf+m1iZqzrGhPIW8RVp
         aEvLZXtdDp8b0NVmT8T9eYdv5M0+GP80sE6m6X621AVRDbLPf0YYJdjQI5PwhOf6h3Kz
         88A+3FNo2ZLDA3i4G6zrNrfv1BzdATpngxJnltogw/VIaQjQM3T2MaxhaGjR9j0UuV7A
         0l0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGAnxq8TxsaiJ4rE+mUN7BVSpa7cDNjlDGASV4bWpCs=;
        b=KCgYe89IQjUPqq+sElL0jFO2saTkutusla52LGnLBxTdpd/kXbXqDaRS0kIBujZQcg
         dQRkgzU7CpADRsZL0z9bAJ9sPRJQW5eHJazYelROKTqpLQOEPHmsjCY6gekt3tomQyJ/
         s3PHkg1W/IkDfZ7ZOsbBedIMLRmjZoCd1wMOfk9hBNfrYq0YkoIlNa2YUyWGN+aiLZ56
         qHNJGKWAlz4RKhTLntnCnIz+lITu4a2VUqVBsaHdOX0DOqij/NWS/+yJX8ORpSbbjsXh
         hSTuamCjZn2mEtIII/TRuvPBn3VIMBdjrPrJan59pA0A8KbFhhpS4IfL3Wc3+Hy+REpd
         wexw==
X-Gm-Message-State: ACrzQf2+u/G5v2J/cxVYtBFDGe2AiOcGbQISF0Lf0smdGlHnBZOw8Ydy
	EjHYWTolbGnFPAVFskI//u4iRStCwda7
X-Google-Smtp-Source: AMsMyM6LpibcCa3tAvXcPcc9JdUaf9/9fnPypWpp5sDfstjX9mSh84f9tOoNKg6gUA/4AaKj5a/N2Zknhusm
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a0d:f647:0:b0:36f:f93c:c543 with SMTP id
 g68-20020a0df647000000b0036ff93cc543mr60967412ywf.325.1668618230643; Wed, 16
 Nov 2022 09:03:50 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:28 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-6-qperret@google.com>
Subject: [PATCH 05/12] KVM: arm64: Handle FFA_FEATURES call from the host
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Andrew Walbran <qwandor@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221116170328.IVv13taFPg_3mf1tRk4E4bmGg2EGqBy7TKRAmegrQEw@z>

From: Fuad Tabba <tabba@google.com>

Filter out advertising unsupported features, and only advertise
features and properties that are supported by the hypervisor proxy.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 969d72390844..d199f868583e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -45,6 +45,16 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 	};
 }
 
+static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
+{
+	if (ret == FFA_RET_SUCCESS) {
+		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS,
+						.a2 = prop };
+	} else {
+		ffa_to_smccc_error(res, ret);
+	}
+}
+
 static void ffa_set_retval(struct kvm_cpu_context *ctxt,
 			   struct arm_smccc_res *res)
 {
@@ -89,6 +99,35 @@ static bool ffa_call_unsupported(u64 func_id)
 	return false;
 }
 
+static bool do_ffa_features(struct arm_smccc_res *res,
+			    struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, id, ctxt, 1);
+	u64 prop = 0;
+	int ret = 0;
+
+	if (ffa_call_unsupported(id)) {
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
@@ -98,6 +137,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 		return false;
 
 	switch (func_id) {
+	case FFA_FEATURES:
+		if (!do_ffa_features(&res, host_ctxt))
+			return false;
+		goto out_handled;
 	/* Memory management */
 	case FFA_FN64_RXTX_MAP:
 	case FFA_RXTX_UNMAP:
@@ -114,6 +157,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 		return false; /* Pass through */
 
 	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
+out_handled:
 	ffa_set_retval(host_ctxt, &res);
 	return true;
 }
-- 
2.38.1.431.g37b22c650d-goog

