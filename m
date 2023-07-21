Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684714F98
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:51:52 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5839e70f346so1493767b3.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933111; x=1690537911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=47KrH2yP97uk7rkXw5nBWPM4SDB+WAXZCbrQjUob62g=;
        b=cLUniL1DbxP4navWXPgbwP9O3z+pCdEQd2aNtiKLeiFGk3pZ0C/EVbN0D6O+Osy9od
         jTtZeC9Vp9nI26ANDEg47cLwb8ZH6WfQziX6mvwRGsEWP2Eu7GTW1A1WLx7KmJJmjyb0
         3iBx7fMiDxYjiUSN6t0whTlKrEXqXlDbBtntDhAPhuEkKG6ywfN7LgAkLnngTOElKLE4
         uCdniu8Q3S4MQoWpH9urxW1gCqotuwvoEnLHJ6l0BH6nJz+NPZ2mtgWPxA+hgHz1TX5H
         uX3EvkTIlpzKhG4j9XOFC5MdxfAaCWCkkipXTWzwAFgUsqrxgGNixMiT4GYGaKh+T60L
         Eh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933111; x=1690537911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47KrH2yP97uk7rkXw5nBWPM4SDB+WAXZCbrQjUob62g=;
        b=BX8nS7xIWhIFORuj1bvcuxj0OauiyLuRU+Lfek82GuBRDhdrFV2eLPuqlPxs1PcRoA
         I2U+SgILrHwNFG28RNoATW5fFMQ7gt6tKIUL66cecXEYruKLWtDlDDXt9pZSsbZRq5/o
         qPv3fjeJ5j6jiZdGTp+3gibdDLP2+S6t8kC91W/ARuiBlP/eKN/AWmjqWW13l6H0FZKW
         SIXl6x0/rB2v1nD/rUH6ZsQiK13u/ifTt2RHfkuRtS8dDrlXM9dMN28TZfR1XKKH6tQ1
         kmBnklTQib3GFBw6Dyoz4p9Iq2bRbLp3tqjYjg8HTnqto2JOG5qX01zgiPNU7l4CnbNS
         2B7A==
X-Gm-Message-State: ABy/qLa2wjIrv4+NxHrn/vfLq1WAObSdSXFeDvXXHGVwf8Z4neT6G/QE
	gCtxqnLo8D23yyGEaTAvVgBf0lfNuERDbQKDNrFc8WmmnvPL35ncEKxDmOhPv7ItCPjcj895WSG
	DBRq8b8jmgv2a7CF7bBlQyWQG3JwHOUtVBtRWGAUF+rMRK4BV6+fDFrP6lLs=
X-Google-Smtp-Source: APBJJlFxLm1gEEd/YHy9SDui1D1j9BbV17u5qlOP+ExE60jBWzeZV0EL65it/aJFmWi07a98jvv3KmEucA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:ad27:0:b0:573:54d8:e5be with SMTP id
 l39-20020a81ad27000000b0057354d8e5bemr18195ywh.3.1689933111281; Fri, 21 Jul
 2023 02:51:51 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:39 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-3-tabba@google.com>
Subject: [PATCH v2 2/7] KVM: arm64: Use the appropriate feature trap register
 for SVE at EL2 setup
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Use the architectural feature trap/control register that
corresponds to the current KVM mode, i.e., CPTR_EL2 or CPACR_EL1,
when setting up SVE feature traps.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 383f6be66ed6..1f3d0aa6d5f5 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -146,11 +146,12 @@
 .macro __init_el2_cptr
 	__check_e2h .LnVHE_\@, x1
 	mov	x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
-	b	.Lset_cptr_\@
+	msr	cpacr_el1, x0
+	b	.Lskip_set_cptr_\@
 .LnVHE_\@:
 	mov	x0, #0x33ff
-.Lset_cptr_\@:
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
+.Lskip_set_cptr_\@:
 .endm
 
 /* Disable any fine grained traps */
@@ -271,17 +272,19 @@
 	check_override id_aa64pfr0, ID_AA64PFR0_EL1_SVE_SHIFT, .Linit_sve_\@, .Lskip_sve_\@, x1, x2
 
 .Linit_sve_\@:	/* SVE register access */
-	mrs	x0, cptr_el2			// Disable SVE traps
 	__check_e2h .Lcptr_nvhe_\@, x1
 
-	// VHE case
+	// (h)VHE case
+	mrs	x0, cpacr_el1			// Disable SVE traps
 	orr	x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
-	b	.Lset_cptr_\@
+	msr	cpacr_el1, x0
+	b	.Lskip_set_cptr_\@
 
 .Lcptr_nvhe_\@: // nVHE case
+	mrs	x0, cptr_el2			// Disable SVE traps
 	bic	x0, x0, #CPTR_EL2_TZ
-.Lset_cptr_\@:
 	msr	cptr_el2, x0
+.Lskip_set_cptr_\@:
 	isb
 	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
 	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
-- 
2.41.0.487.g6d72f3e995-goog

