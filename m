Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46221641C
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:19:35 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d2a392775c6so270914276.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568375; x=1691173175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T7cMhi6W1QA72qy6OnVjmEOCding/R2p1klzAYF0ZSc=;
        b=rF2yKEaY1+qGW4yqr/ZDga1hoWZYiI2p2zc8yQ9kHdT44KsPEvoMVekCxp8AfghkrW
         rMjKjRvkxs+wiCzBI5lgToksGFROkVlXlN+SkQIjZniH8ytnyaxvtlQRlJn9Cj8kcvI3
         KoFNL9T8OSKOnjnssPigziHXCqK1L3kE2iRASoTLF1OnyYkPMah8AsJk05j8hATC3ZZ2
         C8bnTiwVpe5/KEZBZIzcExtKteckZN91xceRRLul0/fRz8xcWAGQJvr8FcCUVvOx9LpH
         CBFXgWSA928eM+Yo7h1fWLEYXg24t9YcsTPZYlS7JEpAAXmcD3X0XI3V5Wi6vT6uSlm2
         uZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568375; x=1691173175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7cMhi6W1QA72qy6OnVjmEOCding/R2p1klzAYF0ZSc=;
        b=IXpGbZgLvoifU/t6+NaUovuLsmZFxBi1dcBRwJ6sgGqOQAGRtNfrDQ6nGOiTtFtxLX
         v4FsELhMiXuyjQE7rh23c5/mboEJkTr84tkDxkFzrdZ8PHQDbQuloEh7uTy5r/yWBGEg
         jb3p9/6sM4M8Wa/Fjhm+bwJph0zN+hGsRdRwRZ1sC5kVqg3GssKWthdMuY819LnbTDCa
         dx3ErqcOuSsaiFCRq4lX7ILj6Ho4XbTgW2OV7m/vLL3hz9HYs5cMVVx/ZPiHINRrWJOI
         VU/3pud8aYE3QwjPICM5Y+x6ml+EJK4VKYVJiem8/nEUdqxaawrIVnM/60bRWmaSSYg0
         Cq+Q==
X-Gm-Message-State: ABy/qLaOjj9dhIZ6iom8ARkPwdZzUORsCVy6rA2CtrMPD1lEmmFQgOW+
	mXa3oVRQ2CKIdFHF1GPcJDOlhDbGbaw=
X-Google-Smtp-Source: APBJJlHHrkbaWwlROgHKR6eB+lXZtSRXwpmBiCRMU364RcnA5ppYwL/doSe0Q2ZdQqFbWDIBBE84vPbLp04=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:100f:b0:cf9:3564:33cc with SMTP id
 w15-20020a056902100f00b00cf9356433ccmr18274ybt.13.1690568374733; Fri, 28 Jul
 2023 11:19:34 -0700 (PDT)
Date: Fri, 28 Jul 2023 11:19:03 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-2-reijiw@google.com>
Subject: [PATCH v2 1/5] KVM: arm64: PMU: Use of pmuv3_implemented() instead of
 open-coded version
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace the open-coded PMU version check with pmuv3_implemented()
to simplify the code.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 560650972478..dee83119e112 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -14,6 +14,7 @@
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
+#include <asm/arm_pmuv3.h>
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
@@ -672,8 +673,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
-	    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+	if (!pmuv3_implemented(pmu->pmuver))
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.41.0.585.gd2178a4bd4-goog

