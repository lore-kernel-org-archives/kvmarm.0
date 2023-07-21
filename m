Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB5E171AF
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:51:50 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5706641dda9so16931607b3.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933109; x=1690537909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kvl5mWCugMTeJwJCOAtYLTMuVDAKNppca97JsT1vsOI=;
        b=u+pCHEsyDHxYmFKkIiBayptMIS160RUlVMYxfKsHZ8RZIyMq+vqhp5XZtkL1uqnPw2
         kYoXVIk4ACn3BQvoJfWaO5W2AcQEC1w30LQecroXW9Sz2W28mQUL9asp3tEWMDiSyN72
         EjOf37cDMsydYFL0MQAVKxxssHC3s//CuVOW/7uYleClDDj35kpxtdXTXRObZAs5YH4g
         XZvsp06RC/5rs2rDsgoebz8p0yxXQanV6NUSdmt1xvuWQDOypxPcs8V5i70BBi9jBA8/
         RDtGaSV6xR35VG1S5N4sflQOlGJ9y7XQjcBh9Pt6rhrc1UUMlzd/j5Uwj7LzZqbWO6qr
         utcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933109; x=1690537909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvl5mWCugMTeJwJCOAtYLTMuVDAKNppca97JsT1vsOI=;
        b=CfY8NtLQOACUMfcudY5rAax9SRZlPFwHgyyI+gOMblq34XZ8KuBNfgp1e6qoaDWsu8
         HQUQ5oqT7ClNPUhkzrurvJx9X4gz3TtLJDRhZt39zjgAMFvBEyDEuG6wouuPejj7BR9z
         mSeiMU5G9ynKbfpJknxlIhdFmnvAR8DwOrqxf953AG7XDq94hnZknM7+tSYSBeW7qIly
         x4NwKy+E3Flp4vCo+jBMrCkFnHJxDv6oZNTMRr59Q4+LCcN7GCasapkcPpKfwWr6l3Rf
         nUAN5ya9ol1e1oDbE6wlzE5qbOGJTi7a4CvdS0ReEjDjRxvcbxoncuRBPYuXJqSCW3WV
         ikVQ==
X-Gm-Message-State: ABy/qLYy2pe5jQMKIl06lE2Ry02TSZy7xWmBCeuXimcwSBmhwGMBPVHW
	AwXrb4UM/Ji794vXpdaorbPfv2mcJssSn3A5vRSYZyYpTPn6FZ5nA9aD4hX7/5JaMmaMi9PAIC7
	2NmcRNSuLy5ECVmrvCuHE3gW+Iu1nJw4S1cYVn70DGb9SCaeFBc1XAQGlVpk=
X-Google-Smtp-Source: APBJJlFxxq0r6oXWxZourrRc7mntBlHVcLBDt3f+POAsyI3RD5U3utPLRcvPkx/1pasnmgcf0kvgT5Sq1g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:b657:0:b0:580:8dfc:7f85 with SMTP id
 h23-20020a81b657000000b005808dfc7f85mr12118ywk.9.1689933109083; Fri, 21 Jul
 2023 02:51:49 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:38 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-2-tabba@google.com>
Subject: [PATCH v2 1/7] KVM: arm64: Factor out code for checking E2H into a macro
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The code for checking whether the kernel is in (h)VHE mode is
repeated, and will be needed again in future patches. Factor it
out in a macro.

No functional change intended.
No change in emitted assembly code intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 8e5ffb58f83e..383f6be66ed6 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -31,6 +31,13 @@
 .Lskip_hcrx_\@:
 .endm
 
+/* Check if running in host at EL2 mode, i.e., (h)VHE. Jumps to fail if not. */
+.macro __check_e2h fail, tmp
+	mrs	\tmp, hcr_el2
+	and	\tmp, \tmp, #HCR_E2H
+	cbz	\tmp, \fail
+.endm
+
 /*
  * Allow Non-secure EL1 and EL0 to access physical timer and counter.
  * This is not necessary for VHE, since the host kernel runs in EL2,
@@ -43,9 +50,7 @@
  */
 .macro __init_el2_timers
 	mov	x0, #3				// Enable EL1 physical timers
-	mrs	x1, hcr_el2
-	and	x1, x1, #HCR_E2H
-	cbz	x1, .LnVHE_\@
+	__check_e2h .LnVHE_\@, x1
 	lsl	x0, x0, #10
 .LnVHE_\@:
 	msr	cnthctl_el2, x0
@@ -139,9 +144,7 @@
 
 /* Coprocessor traps */
 .macro __init_el2_cptr
-	mrs	x1, hcr_el2
-	and	x1, x1, #HCR_E2H
-	cbz	x1, .LnVHE_\@
+	__check_e2h .LnVHE_\@, x1
 	mov	x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
 	b	.Lset_cptr_\@
 .LnVHE_\@:
@@ -269,9 +272,7 @@
 
 .Linit_sve_\@:	/* SVE register access */
 	mrs	x0, cptr_el2			// Disable SVE traps
-	mrs	x1, hcr_el2
-	and	x1, x1, #HCR_E2H
-	cbz	x1, .Lcptr_nvhe_\@
+	__check_e2h .Lcptr_nvhe_\@, x1
 
 	// VHE case
 	orr	x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
-- 
2.41.0.487.g6d72f3e995-goog

