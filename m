Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6021A1FC1
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 15:06:48 +0000 (UTC)
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-3fc07d4c2f4so41619675e9.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689779206; x=1690384006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rdsRbC/vWAy/mXl/tSNZ6PpitB/mHX4dM44kTJKLWVw=;
        b=AmVOSWTy7KW66mbG6zS3fUYMFDEFVik4BsldCMvKQFNQI2LuLfD83RIdI6FAxo0xrC
         yFxLD9dyPVHitnU57yONKllFZ0bEjSkpjJtsBM7aaLR2O+SeBTREHT1jiXE5gL/Hq0bV
         rjnXeIGRgJx9EbIwoIK9390mCVDmx/Yd9hnrrP+Bh9F9Zt2C+QbtCgFAfHeGFeXb2AaL
         wf/PDL2cEemTmpWxeW6wSidyrEMgkJgJ3bM2atbvzNMRcaJjNl7P58KYh4LvvsSm5tuX
         lAsg5K21QGLk3oYd5hTzQkTP5Q6kQqTW3GJke/V+4/je6ipj8b4yzZaY4V7cc/5k5by3
         wZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779206; x=1690384006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rdsRbC/vWAy/mXl/tSNZ6PpitB/mHX4dM44kTJKLWVw=;
        b=aCEG1408VoK7Ne8k6QihcnKykpc/jjdYmZP8lJxpHianqqx4AEiwuzjj0D/PM8dveX
         Z9NoxxV/kQA+NMW4tKDwVCWHguYiDX2bbfXGzOcaZUNVmNhE+kPmIQsDPY84fTEhJA9F
         eFtBrPyI4FhvpvtHHer43wvbVFIs0//t8uA1rq38y3NBJCTAM79RoX68U7h7QIlXY2mo
         wN8vL1awRE6+elpnKJoO4dOoxIEGy+flrpZLfpv6WkZLpNxu1HmAN3/crUuDtb2FJfdZ
         GMZkT0ZAn7J5Ffqde9/70D0+iIBLBSIjEnOcaRhH2+8Fgp0kuuWJV7sXi8Q/x/jWYKuh
         xNFg==
X-Gm-Message-State: ABy/qLZSCX7odd60VYfZCzBx7INcztrgCpQhOhxlg94XmPsAsGpdv+/1
	pl0BsXPF4bew0l0M/HNwIGAot4LoWMlN5EQOMMEMeZiNj6W9z75RZ3CTj79MRqhLmkTz7xnKV5r
	96AunvD45JeNEVFim/ve3FWgZUKNbVhi719gtRQDi0e0VNFUBR34ib0+dyXw=
X-Google-Smtp-Source: APBJJlEqC28qkw+gN0QE5vTKS0NR3aMMgAyfkQolmswgjDiPZ5uRO/HuT9yvWGW0xqy84Xh+nZXdz56jBg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6144:0:b0:313:ea8e:afe9 with SMTP id
 y4-20020a5d6144000000b00313ea8eafe9mr791wrt.9.1689779206359; Wed, 19 Jul 2023
 08:06:46 -0700 (PDT)
Date: Wed, 19 Jul 2023 16:06:36 +0100
In-Reply-To: <20230719150639.1968034-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230719150639.1968034-3-tabba@google.com>
Subject: [PATCH v1 2/5] KVM: arm64: Disable SME Traps for (h)VHE at setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Ensure that SME traps are disabled for (h)VHE when setting up
EL2, as they are for nVHE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index c106b31d776c..7001b6db3ccc 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -292,9 +292,21 @@
 	check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_sme_\@, .Lskip_sme_\@, x1, x2
 
 .Linit_sme_\@:	/* SME register access and priority mapping */
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_E2H
+	cbz	x1, .Lcptr_nvhe_sme_\@
+
+	// (h)VHE case
+	mrs	x0, cpacr_el1			// Disable SME traps
+	orr	x0, x0, #(CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN)
+	msr	cpacr_el1, x0
+	b	.Lskip_set_cptr_sme_\@
+
+.Lcptr_nvhe_sme_\@: // nVHE case
 	mrs	x0, cptr_el2			// Disable SME traps
 	bic	x0, x0, #CPTR_EL2_TSM
 	msr	cptr_el2, x0
+.Lskip_set_cptr_sme_\@:
 	isb
 
 	mrs	x1, sctlr_el2
-- 
2.41.0.255.g8b1d071c50-goog

