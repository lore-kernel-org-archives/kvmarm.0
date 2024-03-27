Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E2114C5AF
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560963; cv=none; b=dQoNMpqmTyBWWxU8w8VhaxGCO246h7g9i/NgJhFUZ6VoK2nrgWt1HgScuCnrNM9fezD9R4zdnpJJcDnBoOnzoIOSnIs8lnXGpcegNz6W77p5czUt/WjLwscXtCet1Wk3io1gN2lBCReGKvPl7X/mBmdPBLDVtPvbF1ui5fzoJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560963; c=relaxed/simple;
	bh=iByzXH4LpTtmZ08l62RkK38XIqWlqhWrsH12Tb96+Dc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Duq/wldmjTESoqpXIf5xdyMzImQOkbOKOXuUsJhvqivHD0rQ/4BSkw8ZONu4+0E0PPyHaFi/BrPHsY3qV6ISrnrLdeBTbTGafvgHM1wfzbrhScB1CMyqN1Rtlk0Axr7VrgGcSNrBkMdjLCVE8IwcrKbfzQuR1KMpK4qRWVSv4tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mkGEsDkC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkGEsDkC"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso45319276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560961; x=1712165761; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ds8wl1osdag3QnNKaqiHmhfIocGB7YS+8iigTFBEp4=;
        b=mkGEsDkCjJavXZR8p5taZD7gY/6ffEdoRFeG90FAuYxE+A1rq8oiDtIjEwaSozsBDp
         NIL/Ah7UK+bSjCaDs6XOZnJwrQABwuI0hT/d0Gy3H8nh19YwkTfuPALqy/QE36JV6aoG
         DhBz/ckdfOws9wAurU/tHQ4GQcBozesyJDtVmI9bcBmahfJ40RUdyWqXFjjkaW00HBNQ
         Q/2JHVlqP+yAkISjRR2SQ7ZXwoFZdNiOAr0aPn+vtp2Yevts9x6zjYkGUEZptlJJ1XYN
         2TgDoyuWB0NPbAUInqyBEcLyYDpz/DJ9/vjvYk+jQx8P6SorSNXaLXGsamuV/9dpD4kP
         e0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560961; x=1712165761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ds8wl1osdag3QnNKaqiHmhfIocGB7YS+8iigTFBEp4=;
        b=KmgbSwc1WlesVf2sKG3hNlX13Ri1w9qwBrhO4Y0zDPasFFebEAlNiLTO4B8edyql7a
         EVF9zSEUgJUS02v1d6Ma00UVWrgOm14UqrHDaKce+gBS38KUK27evb6DG5m9REwcRhW8
         YkDZyLLOxXEm9XW1lgBnXyqxpq+2X5RwGWf1PfF7vK8O6trLKgbacaPWA0H0gXForuzy
         Aqz5mjfrgGTIMgL1PAfxMgimzwbpbI3NE90iTOkyCHFqL233Be3pLJECb1864H+MY2mK
         wfFw6PkBHc/eeB2Lcl+d2NAfSnbfG3oB+SuZEKy8el+xbGIlKE+F9TqoZU0f4mJCtUWK
         kLHA==
X-Gm-Message-State: AOJu0YwygpGTsnpxWVm+2CnYEdF19tCFSGMRF3P3QMw0A9PAQ5LodEID
	ynXjTCY74R0n7YHnGwjyNbW3IZ/SGEtZC2OPkWXzMNjuCw3pg1o04g0XyyVvauhbfd43JzPDCXM
	2WUM+ehca6ALe1pcVdN8hHWuYrm1zyweQviTFAsfpwLQ7K4vi74upbaClXY2xJuI1jil2xnffcB
	krpBojLvKq88E5oLSywVfA5tklSec=
X-Google-Smtp-Source: AGHT+IG/LcPB6CRk6pDmMGtVoHLKYViTFcJUns9vIY9JLep120XKYVpWsYGTl+7bh5+ASFuLPptWS8w3CA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:702:b0:dcd:88e9:e508 with SMTP id
 k2-20020a056902070200b00dcd88e9e508mr143765ybt.5.1711560961576; Wed, 27 Mar
 2024 10:36:01 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:59 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-13-tabba@google.com>
Subject: [PATCH v1 12/44] KVM: arm64: Move pstate reset value definitions to kvm_arm.h
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 68d1d05672bd..29ae68f60bef 100644
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
2.44.0.478.gd926399ef9-goog

