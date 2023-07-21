Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8513414F98
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:51:55 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3143a431a01so924602f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933113; x=1690537913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5DaiR9S+u4U+JSEW9QiTUosnjJab8FjKQKMcb+vUb5w=;
        b=n430nB4oE8/i944JamUuBjU+kbuyWwH+b6bBtWxGXHFDW3WD96EmCEs8pBwdaKHlpk
         pRWxiadyJTRIZ+lRCiZqGg/psGloxzHvSlvdbpLG38fjSKKr7tgAyvv+EY6uo+VSZASn
         OIA4QVBmLKKqeVAw5cr92RLXlNdxhW82wLGSZAg4zKSR2r0pMDoPogVlutuc6U1LHdy+
         BZ7mGFUJsRv6t+oPR656md8ZGZDwgz0Gt71AKJ38RnOMXbhm1MRwW9qGTVPo+kGLkOsq
         yexT2QZaZbCeC7v8HuilFkJtyQcU33VIQwzL/nyzluld62eqGrmQegQGsdQ7XFlO8PZt
         E0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933113; x=1690537913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DaiR9S+u4U+JSEW9QiTUosnjJab8FjKQKMcb+vUb5w=;
        b=h7TTJFgqxKk30JrCG5xzK2u5pzjzJ3APtKPmUriQ9/iC9yC+C3a98FE644wOCNFaZ2
         1e1sH9+qMTMvAj5HHR1jpCnCA+SM9k0mvJW+vDTSGLKhADj1d99gzHp/hQ+NwFWEA6jK
         P0T5w5O/Ypa9DTVWG/naBOtDjLFCH/u970t0Sq3SQDQ4cS4dqLb3ShYlvniMghmhKQrU
         Yur2k+wCGmplLxyLxosHSrvGGoIfEJ9xiT5WADQa/2KJK86eGeBqhKzSm1RnqJ9Tistl
         SJP4hH4t1C42WU74AGnrbf2tTahEycsrgk1AjqG24iVJIObtjPEsy0F5tNScendXuqWp
         wrdw==
X-Gm-Message-State: ABy/qLaLPDQey0dpqy8W9iZVJJcvn6mqpOU7RopvzEyYQKexb00ZbS9J
	G4d9R0C0lZ9ExhuaVECKislrUX9Jmm8yhbepKDFl6l8NJlwD9xWNMC4QBPmTfZbVYUhePjAgpZK
	YrkB31BdqyrDhEifGf0R2y2YTG7u03MEtauvDFDE6JEIY41508oYzBPRVrmM=
X-Google-Smtp-Source: APBJJlFrBNXkhGHySgTYP7lbph02H3bSiacjJJ+xGv5SnQPXipevNfR2bNbwz4Jy237KC71abwpzkHYacA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6583:0:b0:314:1ac7:2763 with SMTP id
 q3-20020a5d6583000000b003141ac72763mr8299wru.0.1689933113506; Fri, 21 Jul
 2023 02:51:53 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:40 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-4-tabba@google.com>
Subject: [PATCH v2 3/7] KVM: arm64: Disable SME traps for (h)VHE at setup
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
 arch/arm64/include/asm/el2_setup.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 1f3d0aa6d5f5..3bd2e84daeef 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -293,9 +293,19 @@
 	check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_sme_\@, .Lskip_sme_\@, x1, x2
 
 .Linit_sme_\@:	/* SME register access and priority mapping */
+	__check_e2h .Lcptr_nvhe_sme_\@, x1
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
2.41.0.487.g6d72f3e995-goog

