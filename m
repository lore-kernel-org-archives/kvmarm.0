Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC86DC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:04:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA2014B8F1;
	Wed, 16 Nov 2022 12:04:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F8ZwS0NQt3x4; Wed, 16 Nov 2022 12:04:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC894B91A;
	Wed, 16 Nov 2022 12:03:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE044B8B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cY-SKzC7J4Lb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:03:51 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E8A64B866
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:51 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 y6-20020a25b9c6000000b006c1c6161716so16456710ybj.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=77IO547OJE8gddEAna6ZsOBCEHOzGGdp/N9Pi/AiFDkFC4YnIFiJ0fu8pY6setPSiZ
 Jc5I99mIaBtcmavoZiGux+JLgfXxQaZbiX6Fe2kSZFdkzUttj5bg1pjMZf+/iIMwMlgq
 tZ3l2Jm4FHHSLOyP8udCd2dv/C4xQBshgfFN+YQvh1jX5MdmBW4SHU1FCUZ5aRL7iTE+
 cGXFGBc0+k2xbzzocX+LsDRDU2lJFqmxAmTVpcrAsGhKJxKiGq9rui7k7cBBKGD0/2ID
 vIsHjgdzqrkO5v4kVb3WmpF5Mjy5XdaqMVkiY4f/5ia/vbjjwxCr1bk0hY9MCaHwf3Mr
 /fug==
X-Gm-Message-State: ACrzQf2wxFrapqp1mSNLXji3AyQ6MsYCTfwFgBGPdius4Dn3XPsbF467
 gkEa4nBLJ7QUwtIiyRUer1EkOUEM0gyM
X-Google-Smtp-Source: AMsMyM6LpibcCa3tAvXcPcc9JdUaf9/9fnPypWpp5sDfstjX9mSh84f9tOoNKg6gUA/4AaKj5a/N2Zknhusm
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a0d:f647:0:b0:36f:f93c:c543 with SMTP id
 g68-20020a0df647000000b0036ff93cc543mr60967412ywf.325.1668618230643; Wed, 16
 Nov 2022 09:03:50 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:28 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-6-qperret@google.com>
Subject: [PATCH 05/12] KVM: arm64: Handle FFA_FEATURES call from the host
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
 Andrew Walbran <qwandor@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
