Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA242EED9
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 10:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781607277; cv=none; b=WA9h09+97bn8TwP7L/BjuOXWntTbSMIvuXfc/il61avHVxJLSOYGg9ZYRmPya+qNLR81yylcJhVF9le2mg8ufrQE8TBlltIC8soyxgP2bcCFUEM6LyWsuBJF+zCOzHaf0Znh2qYT7+uZ9Og/RIanxcYZfJ8s3hnJJn3bQhfaFKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781607277; c=relaxed/simple;
	bh=j1mQ8kdXaAUSyoc7CFE8/gvR2NiSPeNLQiAPubEZ/GY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f/EcL/4Oh2hinrtvtJeU/yZEMWq7lRfFl6FPR+9Ndyq2JeXKdMcQZd5n9n91fCSfIGgJ1cRkHsawzgIhx9dZWkwlFHvW6TRSmV2y7tqnppp0xFK7L22nUaSIefAOWCAWjr6QwnNBf4p81P4k5LKygwE+dHEtCDCfNcBog5qjIv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MInK/iof; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MInK/iof"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b3ec3f7fso28594655e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 03:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781607274; x=1782212074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkEKjP1Wo3utwvpO8El//6ig/85bmiEc+30pFMiWQQA=;
        b=MInK/iofN8XuBD0Y5ESB3DQuI4dHbpfncQUId1oWkH5wkeVA4Pj+Q7lgB+/oM+eSKh
         rNmTpEMJX6U37Xd3CTQVlYJYsicuH4Nd66ZWXyM+7Itz6+zYpI9kBpeXb0Ue91ZUrnq/
         PvajlK1ToSxMwZIyxBPYvGAt4VBKWXTXvKbehrEyYsm4PUCyv3KK0++/ionln8PX+7el
         ha0QFSDj0sOIbfuAN2SUy6u1hCMt8Ukcxkyh8PI2G2jf72L+k62icTPWB3BI1r6FNBSt
         lAdxK2sqo+0JKqdfRpGQM3Ov4a0vS04zx51sl8wdVYW1wvaIJM9m/pq47H7EPHOA9d9k
         +hIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781607274; x=1782212074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkEKjP1Wo3utwvpO8El//6ig/85bmiEc+30pFMiWQQA=;
        b=r71FyC4Ijpy2RXmUAfiJST4joaDpVTwMc4JCsfJKvxUBu40MvsHaJr8hrOR5TFYO8Q
         JWxVD8IQsTR4/wg7sAw3JuawP9E7jtjxxmCwmq2i1sVEmPvN0cNFGWJVvNH3AKYLRvFn
         smVGzN+0ieNeSxd0OrRK0nm7rUJXzq89CY0IDdCbywzw8EcmDODeuphV3j/jn6sVykQu
         pE7LrJBa8YJV+UoFgMOs3SD8k4nbe819Vrhr5dFcBX8OkTnzoPkA/k6gPok4jhy35kUq
         AWLpAcXlCz8JDhY1kku3wY26TEcsirgNvY/dCYo4q2QJKhTG+O9CiYwStwO3c3irJ3qw
         +QDQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Z8zO/G7uSBv5hScf+W9hN/ChgVxDiNpnumHfhnkw9GtzkUS43ruT5YGFW+B/S0WZUdyPvuLM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEQCMtlJXSZWDvYi+49TEJ5Lz3I875IXzI/nBBPB4O+LqBUcE1
	YDz7a82mtkDj0YFsUUc7akCb+REumCdcssUifuizzndX890k0+pER/lrs9JoF4fr2klyob4c+AC
	KBhfLCeYWBCDAePbjktkSCZPmzigoGg==
X-Received: from wmsk20-n2.prod.google.com ([2002:a05:600d:8494:20b0:490:b475:af3a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6214:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-4922ff93874mr45013535e9.9.1781607274059;
 Tue, 16 Jun 2026 03:54:34 -0700 (PDT)
Date: Tue, 16 Jun 2026 10:54:16 +0000
In-Reply-To: <20260616105417.2578670-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260616105417.2578670-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260616105417.2578670-10-sebastianene@google.com>
Subject: [PATCH v3 7/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Allow the host to query the FF-A notifiction status and proxy the info
get message to Trustzone. Make sure that the SBZ fields are enforced.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 549250ff8f82..dac30a5fcf5a 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -714,8 +714,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
 	case FFA_MEM_RETRIEVE_REQ:
-       /* Optional notification interfaces added in FF-A 1.1 */
-	case FFA_NOTIFICATION_INFO_GET:
 	/* Optional interfaces added in FF-A 1.2 */
 	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
 	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
@@ -1020,6 +1018,20 @@ static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
 	arm_smccc_1_2_smc(args, res);
 }
 
+static void do_ffa_notif_info_get(struct arm_smccc_1_2_regs *res,
+				  struct kvm_cpu_context *ctxt)
+{
+	struct arm_smccc_1_2_regs *args;
+
+	if (ffa_check_unused_args_sbz(ctxt, 1)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	args = (void *)&ctxt->regs.regs[0];
+	arm_smccc_1_2_smc(args, res);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
@@ -1094,6 +1106,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_NOTIFICATION_GET:
 		do_ffa_notif_get(&res, host_ctxt);
 		goto out_handled;
+	case FFA_NOTIFICATION_INFO_GET:
+		do_ffa_notif_info_get(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.54.0.1136.gdb2ca164c4-goog

