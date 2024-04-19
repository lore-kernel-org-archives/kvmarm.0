Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27A3E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513629; cv=none; b=i0RMtJnMm8cv1As6e5o6zLi6o/ocMB34o6W9Vm9hjGnlHpsg5zM98IKknXPNzGUj5hzelfsVZ/pNh1qtM+p0F3ukhMyWyTf3NYmdQAW66hBKVGFj6dAJjQuOyNiOnjTBRjSHpJtZ/V9Ea40tNabQYyiVNv9alAksqZr8+DndnqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513629; c=relaxed/simple;
	bh=8iLlbqqvVYMn/2vf+wEKr3U1lzmJSEua4oHtkm7fj3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kb6tj2Wt7Xe+0zcxM3HoXXqyImBIZgV+6k/pH7o5VdTCbZOcyvH/pYih7Ai3mWF3v308S2P+JczlUllMWc2MyjD3C/vyh3NZ0sVkiFsiphdVEAxhXgbIEf9Cfz3hr+S2H/7TxbXRPocKqgFmPrFXcbn8qWqteUOD0GsTTiCSkZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IuyhUyi7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuyhUyi7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6167463c60cso20600667b3.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513627; x=1714118427; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JM0Th8iWZ5eNdmeFHmy7eXd009D2nFz+4Dj6uibCIGQ=;
        b=IuyhUyi7Mn1ZYqJUt0ooxmIkrETaQu8ydO/ijeelVWYlUqy6c7+m2EuVdN+xZvSTib
         oQgttHOOJYJ+Lx5Gzl2YLbNIGv59O3+b7Vp1Cj4+4p/nHz4yefM5YJ92jjPA123N0W58
         CypUHGAKPMFik1gZ13DbYsBSUYxkzqk8bL6sumT8ePpSEZJ012DlOTx6v94PvrEuSO6h
         TR2JWlhx1BR/T7GaZZU+XE1F5UiYMbvfhGbE4RPg79czYijW1vqy3gJBGfdvUqQGlpe0
         W82Sy3l2KKaWGkHKK64rPgcF8AI6uG4QPptcK79cOWVs/+wbdzU/2rZ/wP9JLmWPjMQn
         894w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513627; x=1714118427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JM0Th8iWZ5eNdmeFHmy7eXd009D2nFz+4Dj6uibCIGQ=;
        b=QipUCfQyqRkyq8JxyKSNPZ7xWg0vaQ2F3SowKGteOMoT85xIVztw6sLfCymW8/GJ14
         F/kHXrr0hEVpwgzn2W/b1RW5+tvFBqku3kGgmceSzx5a2mHJAx40ksinyW1POLJFGOA5
         bu5lZv1ddgtDiRlK/+MK/aEBjw6jzS8D5Q49dBdPjazz/U32SkgXvFg+7rhheaM+juoQ
         vzBXzTwBrNhEqTRruFS4u6q3x3jw2gQDv66qCVgWI8MLs+Jj1oRr86E/GlVLsIACG6aS
         B3rsZxtA1WSs9QnoE3As4jXBm2bMRc8dyDTsLjaBgwXunqaqP0HtNqUqZ5rBCRIYFPlN
         LT4Q==
X-Gm-Message-State: AOJu0Yz+O2edQpwZCYktRTYwz30J7XI6HzP0SITUq9ujQw3BaRrz0ZDb
	JujXc1FfjvXVweLHZQQYfueuTrEyQyvkRCtUt3cGx5XbQU1OgWqPgVquTtHSOTB8Tw8vtHl10DK
	6RSfqhEPM+I785PwfbKATeOkPaO+sMjGvvVpFut6iGMSZN7UU399wse1VfdaN2oBc/KASeWf6M6
	usXuo/MeXyZTtIbKO2j2NsN9AGGJU=
X-Google-Smtp-Source: AGHT+IHu1hiPQSFSsPlrolrx5xuIFzJCcIlfg/8YjoerI106HrdkJ6LxCETG53/qBUAN3JqNNPef71+lZA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:e946:0:b0:61b:32dc:881d with SMTP id
 s67-20020a0de946000000b0061b32dc881dmr334664ywe.3.1713513626868; Fri, 19 Apr
 2024 01:00:26 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:29 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-20-tabba@google.com>
Subject: [PATCH v3 19/31] KVM: arm64: Move pstate reset value definitions to kvm_arm.h
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

