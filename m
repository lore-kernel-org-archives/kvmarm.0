Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683BC342535
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020555; cv=none; b=BeE6xepNZptRZhOcJVg0/DJxcn8zyAOJgHR6XKun5VtWuR4+os0kfr+41ioPcaswdQBZ2oADKD8VkYUbur/jp9RBCfg2P4K+qnXg8dAbOwLT6hLGez+RKrkSHnqL5HbGWevPsNvRZZbKhWNUNldq1jygoaVeCGNOVhjtkzckrZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020555; c=relaxed/simple;
	bh=QWGFycIggrzer+24r8IUUQ544hu3QAGAwn5g4AM9ElU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UZK3qOG31jVDAtDbdbQlhumD3rzyp1H7cXxrVxImvjsV8gFeknFxIbXXNFgmJYNqyxbV18qP4QYXnmY3IcEmBpBADvlkR2ycbznkZLopGpHUd9LiigkGhwSDsFV3+E/y88gEZjy3qXfjJO4tDbFrxoajeCxDBYEsOgNy8l4goR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DL88AoTD; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DL88AoTD"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b9360e9f43bso823013266b.3
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020551; x=1777625351; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=chjLWLOIpt5H2yMUpJCdXjXW1BJ6wL0l1ZmewdyTk+Q=;
        b=DL88AoTDGW3yfioplU2pZjIYtL8Snnl8Fk0FjFb9I8BU+miWpkggz6j8lpNCRIhs0N
         fYwd290jfgckj/25ZmxZ/1/jDq6C3Y+BZnGTvZT9cwKgexQLc9GkC4ojR+Z9FKt0LIYy
         yY0nRrIjA4xlV9pfljvz9PAS/hNNFvtHS/LaoRrwad46NopW6d8gwEwLbWpVIfRFCLmJ
         hnvh99Z92W3yqc9rtax/fPcrLUHz1WZkG/5HgLQ3hDIg+D8C0U5Rz7ttIJDxFjcMYSpn
         pYqKJei25UOHli6NCOLD6H3TE6N7TPd/yssZOzkczC3M/sUw7YqrUve2bpcAoL2b61CJ
         caAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020551; x=1777625351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=chjLWLOIpt5H2yMUpJCdXjXW1BJ6wL0l1ZmewdyTk+Q=;
        b=nBp9qC9bvEZ19TA7myEvSfMnvinZIw0yEXU44jgZsIt/QrUYx2xvdaB5VXbF/4eRYp
         tAozKRDoL175bR06b5J347WyxNvYIvlIeRNnTyHCp8onggiwOXUWcogJrGQKzMUgh+PA
         DapL3UMRWgtpIqB5+BBrPdMTAd6pkzlJS4HvcmpCfROCKl8QjXTIJfqKQeMzNT9XSLLT
         t/xAt77FyTy1iaVWZPKfCYfqtBJavohdo6rDs8uIcUc6FuSUEQuWGk8+71z3qUQdUgtk
         TPn7mR3p3nuHHQ5gncQy9WuKOnTBHeOlgCvFgvvMGT4K1WYfJGqrP2jaTgcZY37NVqYR
         ZysQ==
X-Gm-Message-State: AOJu0Yzez7jUPvnEyy9wabnooLWJ3JnZiCPjhfHMluB7viEuP4B+feES
	c1sI2nMR3IL6O7YnGI3V2+Jbhy80YYJnf9nSNfz8P9b0ELfGXQH6FQW6aSgmJNYdKbhm0NDiHHp
	fG6pw/BKyJ4LMmZ2JfWmFXYA3dtTCb0JmRkTMoMfXmNifyyWglSDwfGYogm++VHHfCFUn4TWMIa
	Ri89yc2IfhTwdOzv8cMY69COgINLFfzSk=
X-Received: from ejbwt10.prod.google.com ([2002:a17:906:ee8a:b0:b9b:9f09:c27e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:cd09:b0:b9e:f58:c581
 with SMTP id a640c23a62f3a-ba41b3dff09mr1835202166b.45.1777020550736; Fri, 24
 Apr 2026 01:49:10 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:03 +0100
In-Reply-To: <20260424084908.370776-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260424084908.370776-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-2-tabba@google.com>
Subject: [PATCH 1/6] KVM: arm64: Fix FEAT_Debugv8p9 to check DebugVer, not PMUVer
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

FEAT_Debugv8p9 is incorrectly defined against ID_AA64DFR0_EL1.PMUVer
instead of ID_AA64DFR0_EL1.DebugVer.  All three consumers of the macro
gate features that are architecturally tied to FEAT_Debugv8p9
(DebugVer = 0b1011, DDI0487 M.b A2.2.10):

  - HDFGRTR2_EL2.nMDSELR_EL1, HDFGWTR2_EL2.nMDSELR_EL1: MDSELR_EL1
    is present only when FEAT_Debugv8p9 is implemented (D24.3.21).

  - MDCR_EL2.EBWE: the Extended Breakpoint and Watchpoint Enable bit
    is RES0 unless FEAT_Debugv8p9 is implemented (D24.3.17).

Neither register has any dependency on PMUVer.

FEAT_Debugv8p9 and FEAT_PMUv3p9 are independent.  Per DDI0487 M.b
A2.2.10, FEAT_Debugv8p9 is unconditionally mandatory from Armv8.9,
whereas FEAT_PMUv3p9 is mandatory only when FEAT_PMUv3 is implemented.
An Armv8.9 CPU without a PMU has DebugVer = 0b1011 but PMUVer = 0b0000,
so the wrong field check would cause KVM to incorrectly treat EBWE and
MDSELR_EL1 as RES0 on such hardware.

Fixes: 4bc0fe089840 ("KVM: arm64: Add sanitisation for FEAT_FGT2 registers")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index f35b8dddd7c1..093290b366e6 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -192,7 +192,7 @@ struct reg_feat_map_desc {
 #define FEAT_SRMASK		ID_AA64MMFR4_EL1, SRMASK, IMP
 #define FEAT_PoPS		ID_AA64MMFR4_EL1, PoPS, IMP
 #define FEAT_PFAR		ID_AA64PFR1_EL1, PFAR, IMP
-#define FEAT_Debugv8p9		ID_AA64DFR0_EL1, PMUVer, V3P9
+#define FEAT_Debugv8p9		ID_AA64DFR0_EL1, DebugVer, V8P9
 #define FEAT_PMUv3_SS		ID_AA64DFR0_EL1, PMSS, IMP
 #define FEAT_SEBEP		ID_AA64DFR0_EL1, SEBEP, IMP
 #define FEAT_EBEP		ID_AA64DFR1_EL1, EBEP, IMP
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

