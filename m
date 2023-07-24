Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D975A6AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:39 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d07cb52a768so2519256276.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202319; x=1690807119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lSqz1V+qZxC23ZuX0bxKx3kKA5JcInjwu4WZ7DtCwrc=;
        b=ygDsFEczkSWB3VTjeerVxSeFyU4TkOGW0+N5FQGCSJrZHXFMGqcW6WfxMpeAx/kNpU
         9jIwGj0KPdibmV2AL6gRsksSNJ4c+G93WF4bko7if9JLBlbkZb0lEx5iE7LlUvhJ3Jf2
         S2wo2SsZEts83qhonPTNqeAJyQsuD/T9AxjjpgFZwV0w+vfS4FtqDu+E2pmHT+q9/NKF
         y1yg+kC6asjk7SMbQ/nTPPzmfh6NjnYWiXuFmQEo/uMmTHKRaWjZbp615wJmPdYOZqRu
         P5rP3SjQyfEe8ZrDpc0MgcrniGo2QRQgXT6Uzoxk/LJ81PUYF8vTmjMrd+3huD57dLKr
         2Rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202319; x=1690807119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSqz1V+qZxC23ZuX0bxKx3kKA5JcInjwu4WZ7DtCwrc=;
        b=Bcou5bFTbVU7WL2fjOv7M2K1TDO/TLwWfN6l35bXUScgo1I5oN9udiu8nWpcsS2UjL
         zSSMG6iZDf8DqPPOOVBpJn4zzEp2e11NgYKzNsNU1MIIrQ9n9lfz8z85Yzebv+EvEJhj
         g0VuY6n/ZH1ZC3/NJ7EfFBVbENWm5LT3I0ykfIUp5TlCFcNlC7CQf3v4sFU/6G8J2WE5
         HLhuSWjQMwl244F+p8jcpwpqYtYPpFglxOJAqDorhSyNefxbyeYY7lcA9EIGk6tK2nY7
         4+XKFSUcWH65RO3L8VA9194seCrAfmxNjCVu1RvClhHP2oFdVTLP+gVQD4zlTe7oQSha
         zVJQ==
X-Gm-Message-State: ABy/qLZWK/pcW9lspXEh13+NwlinD/zekUplNe+6Le/BPJ+NrONin0Mo
	//nIQX5OV6fc8GV1Jn6V7M5cspL8r2rr/FEm0vPN75ydSDvs6NAq4gw4i5nA7lpwnd3VvkvmgOC
	Nt8hOQhnts/6JFO5mzgqKqXRr0sOOAvfWOZrW9Ar0LqiZNFVqSsph46vp1qM=
X-Google-Smtp-Source: APBJJlH8vc7Fd26jdzQu5vUuVOqpWYLzZyFaEl1Ry8PY/yV1Pr6AooUA+nnQIh70gEZdOJK/HO56ActKsg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:10c5:0:b0:c4e:1c21:e642 with SMTP id
 188-20020a2510c5000000b00c4e1c21e642mr51989ybq.3.1690202318400; Mon, 24 Jul
 2023 05:38:38 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:24 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-4-tabba@google.com>
Subject: [PATCH v3 2/7] KVM: arm64: Use the appropriate feature trap register
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
index 16d3bafa715d..41c5b02f38c5 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -146,11 +146,12 @@
 .macro __init_el2_cptr
 	__check_hvhe .LnVHE_\@, x1
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
 	__check_hvhe .Lcptr_nvhe_\@, x1
 
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

