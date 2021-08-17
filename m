Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DB8C432BE
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9EC760F41
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9EC760F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ABB84B146;
	Tue, 17 Aug 2021 04:11:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4x74Otie+bRs; Tue, 17 Aug 2021 04:11:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D1964B161;
	Tue, 17 Aug 2021 04:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A438A4B14A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dIH3QC-bmcQp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:11:50 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1C494B140
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:45 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 p2-20020a5d48c20000b0290150e4a5e7e0so6243739wrs.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=riHWMzrcAM6+2VGU16NZVkOvNT6zBw95n97WEjCFhB0=;
 b=s1oZnJt8O/uB5Wwp8GNi245aDjnSiO28K1OSCUNw1ROwfCqi3EgMK4iE927kUSKT30
 4yEWfpfnx083c3a9drJcp3aLhMZz3DtzxRmiy/UP03TtNMwLAbMEsHLoymw6XflNKY05
 P4IXrRa6/exnENEb+ASBa9N1KOml7QiHy+BpZMx/XkfFYbtOszA48db1Yokeo24EI4JS
 Jl+Xpq8Ge4XjtRSXbZkE04V9TDxRZg8elSN2wbKZCNLVOCFofOhVzd2Ff0BRTEW8usyM
 PjvxJg7+BZ/Bp4OJAL++xGJIVrMQoS9fwTHr2QPDfsDa0G2gvHqDm42H2sYywYGflvec
 ICeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=riHWMzrcAM6+2VGU16NZVkOvNT6zBw95n97WEjCFhB0=;
 b=EJLSdIUMkcAaE9Zrj+5FrkNY+jZ88PXGhj5VIRZ/3QL/YXKlxqU61y1PGsOXPbkPGm
 R2uKoN/KLRM5TGLuaeWeq4j1ut/a9RrtPBy5xfnswAV7JILIJrGN8zZIND85+Ado1auV
 hUEj7ACIDuDsSSFJyL6Yl//IHxZh+MZpUFqKC3D6YKsLpzUnkI5Ymp82VFFVEpMuBTf4
 LcEvqGnwdf/oMWxx1FB5Vq170axuB5nXE0qRTRRrm9olzbljlv3/XRZVGGJHZtTk+pag
 /nrIvZeVzZvAVtO5VuhwnloIII4pW6SV4JVrRFRbZRsRfrkmOM1T7aYxemKsvjImrsUx
 YU7Q==
X-Gm-Message-State: AOAM532T/13B9oPt0D82Cr4+CbwlTLTvb97GxttDz3hLpXJepE/kjx0n
 qrfr84HtvAU8Suwx+R2TpQol8QLdvwH0csMsbwz1xf+8SD5NR+laYdRChfJRPE4S6S/7YuBM7Um
 ML4XUVNEU+K8yx8gANTpo+Ml8emBRwwvM3RYWjxqH57rO8YKjufYR51/D4dxzgpOWDQc=
X-Google-Smtp-Source: ABdhPJxBqdSlQUtDWbtnb0OOe/ZNbip8Q5Yu0vjbiyQ+GBy166dIhRK0a6EK8PCVu03u8H+XwdSKSynECw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d3:: with SMTP id
 r19mr227788wmq.1.1629187904044; Tue, 17 Aug 2021 01:11:44 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:23 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-5-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 04/15] KVM: arm64: Fix names of config register fields
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Change the names of hcr_el2 register fields to match the Arm
Architecture Reference Manual. Easier for cross-referencing and
for grepping.

Also, change the name of CPTR_EL2_RES1 to CPTR_NVHE_EL2_RES1,
because res1 bits are different for VHE.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6a523ec83415..a928b2dc0b0f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -32,9 +32,9 @@
 #define HCR_TVM		(UL(1) << 26)
 #define HCR_TTLB	(UL(1) << 25)
 #define HCR_TPU		(UL(1) << 24)
-#define HCR_TPC		(UL(1) << 23)
+#define HCR_TPC		(UL(1) << 23) /* HCR_TPCP if FEAT_DPB */
 #define HCR_TSW		(UL(1) << 22)
-#define HCR_TAC		(UL(1) << 21)
+#define HCR_TACR	(UL(1) << 21)
 #define HCR_TIDCP	(UL(1) << 20)
 #define HCR_TSC		(UL(1) << 19)
 #define HCR_TID3	(UL(1) << 18)
@@ -61,7 +61,7 @@
  * The bits we set in HCR:
  * TLOR:	Trap LORegion register accesses
  * RW:		64bit by default, can be overridden for 32bit VMs
- * TAC:		Trap ACTLR
+ * TACR:	Trap ACTLR
  * TSC:		Trap SMC
  * TSW:		Trap cache operations by set/way
  * TWE:		Trap WFE
@@ -76,7 +76,7 @@
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
+			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
@@ -275,8 +275,8 @@
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 */
-#define CPTR_EL2_DEFAULT	CPTR_EL2_RES1
+#define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
+#define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
