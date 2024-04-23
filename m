Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D979F13B7AE
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884787; cv=none; b=X8byN31KQq+/dknqvSUP3HuFUO6OspxCnrWLC/8CxmdzauZbTPfiySsyf5/oRv9WfdKRONeSRAdyGCCOGGCHtqewX9PG003UiRGzhp9yk3nWlQx5DPJEvBtnPurFkDGLW6mqca2+uUYS1JeNoN//XKwanccBdptGwh3Sh+OvobE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884787; c=relaxed/simple;
	bh=8iLlbqqvVYMn/2vf+wEKr3U1lzmJSEua4oHtkm7fj3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aKKTwv8aWtsYwIhCyJY1QpPHIfvWIqjBPL5PrO75c0PD4PLsMWCfqpG37VCxrfSrgVXvmq3gqkYuuG8h3c7UJpbC8mTV1ANLWCiiraNfjFQVOVoYNW292d6TrloozVO1WZboVIvUs4Cqt12d6zSJOyPQxVO7d6F8KdCG5NSCIp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UV1CC1S3; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UV1CC1S3"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343da0a889dso5228942f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884784; x=1714489584; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JM0Th8iWZ5eNdmeFHmy7eXd009D2nFz+4Dj6uibCIGQ=;
        b=UV1CC1S3YOXmu6veZf7ttBoGkQt9MLlkYW3VmfvGeM+8oZtQSCBL/iEjr8gXvevvPE
         Coe1ktrhYWWFP4ero+irvSjLVh2Nb8NuTR5pnV43CurxDMd5Vj+J1j8MJ6PwLup0C/Hq
         DdZJ6kztm+l7HgVs5Dl3Qpn/msBnmPkw1HJuwdEiyPsxDraV5oiwuM3SQNUrytAdQMml
         0aJJrqfT0fAYxpEdCha9Auj29x9jBOEsk7wJdzUUXVsSR9mInbVFlz3VF/2JhLIYD6xF
         UTqp+Jw3JDK1KNvkHK+9vTbYL8R6Tze5bA/GgC83yjPjDq3KH9yz1T0fUfbqTH4Jd/7J
         9EyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884784; x=1714489584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JM0Th8iWZ5eNdmeFHmy7eXd009D2nFz+4Dj6uibCIGQ=;
        b=Tp00L1mNiv/wA1e4kBO3WrcIOuv+EIYoBy0wT1+n/2egZf8SdvUDDNrwU6aKaJzIiu
         OWd4Q/6hd9JFgT2GdqIgC+6yZnXZtvjZU71WfHOC1cXtvMxbW2mJK3AUP0MsNvA/KBBG
         YPAiIIx1T9NQszX6SWUQ8Zo5rKYEhk3/8pFwTG7oYPDtkicBD+/JZi7m82k9mh0OlAnT
         +uiSME8pUnEFV6WkANeJGZIYHynR1pLr4mWam3HEUfkz7R+rpvtBZSGB1o18dufjQT5I
         L7q4bkp9kN3PmN/Bf+ux8lsw+1rZxgn7f4qeJFKHs6FWbjRySz2cQ8Krhf+yYMK/2/oD
         V8OA==
X-Gm-Message-State: AOJu0YyiaFLMp0YHeUpIVPjP0FKtMcWfhADTJea+ZtWwV/nuMdmvD8vk
	tvjTQhTnwXvcurcHoHLRKHfc7dLnbFDfw/Ig4FxLnUjVBR/Cjezk2K6+mPT8twj+Yp3z46+P2Ls
	vvWSbmjKcllLMmNvCYP9aTclLtXCNAjjHAibijOR4WqTNrj2aTElC9s7sC1a/cc01go7nKsyFz2
	xbI/2HRMFj01SI8KJo+wujo95X39Q=
X-Google-Smtp-Source: AGHT+IHgSJW+mPpAouAclG11PqZJqaDD7TclUBpxaNv7WvrhE2JokMqaVOiJWzGaIsX80ibWjzAQ0Y9oXw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:460f:0:b0:349:82c5:66a2 with SMTP id
 t15-20020a5d460f000000b0034982c566a2mr33941wrq.4.1713884784187; Tue, 23 Apr
 2024 08:06:24 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:27 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-20-tabba@google.com>
Subject: [PATCH v4 19/30] KVM: arm64: Move pstate reset value definitions to kvm_arm.h
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move the macro defines of the pstate reset values to a shared
header to be used by hyp in future patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 12 ++++++++++++
 arch/arm64/kvm/reset.c           | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e01bb5ca13b7..12a4b226690a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -432,4 +432,16 @@
 	{ PSR_AA32_MODE_UND,	"32-bit UND" },	\
 	{ PSR_AA32_MODE_SYS,	"32-bit SYS" }
 
+/*
+ * ARMv8 Reset Values
+ */
+#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
+				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
+
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 1b7b58cb121f..3d8064bf67c8 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -33,18 +33,6 @@
 /* Maximum phys_shift supported for any VM on this host */
 static u32 __ro_after_init kvm_ipa_limit;
 
-/*
- * ARMv8 Reset Values
- */
-#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
-
-#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
-
-#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
-				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
-
 unsigned int __ro_after_init kvm_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
-- 
2.44.0.769.g3c40516874-goog

