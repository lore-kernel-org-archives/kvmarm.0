Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA815C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 457F36147D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 457F36147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6024B090;
	Mon, 19 Jul 2021 12:04:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NH0+nldoifHi; Mon, 19 Jul 2021 12:03:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7ABD4B0B5;
	Mon, 19 Jul 2021 12:03:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D8FB4AEDC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h-1n3msyBV2I for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:03:57 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BB6840667
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:57 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 j141-20020a1c23930000b0290212502cb19aso191593wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=k10DPudObTvcj74PA9oJ4czrG2bf/iAmYaVF6bRkhko=;
 b=BPSFlH5yAUOM5EqitdPB3laSW+FRnNWn2lMenmzoSKl27Cvko3VreV9gcyS/C6J0HR
 ftiwwxS3VzE+ufspgaVIXd/18+Mnb++5SN5atFtMk9JTNyLuHjVfsffTqfhXXKFtxnQn
 vyL2kEoKt6INYuLNeMb0i517AmrACvOQMrsLA34LiYFNPvevZrY6W9bKO0Snob3nWrpw
 MtUOlJNHX6tC7etd5Uld5WJZqkSo6TmdYef+MefU3jc3GV+HlmZfQ2fbTUNGFcxH7pCP
 VOIuBF9TfW4mnHTY4Ktp5AGgwmLd0xvteF5dEK55U4E5DGzE5a6tJLKKQeYP/lQ7M8dK
 Glxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=k10DPudObTvcj74PA9oJ4czrG2bf/iAmYaVF6bRkhko=;
 b=Ui2WOatYmEws0B5z8NjL145LljLfPdfQJy+0ZdG/NOAsjthAJYqTNuhQqvuFSoCQpv
 H9UhohRZHwVTOvv2YzsCW0Jgqq2xXNpiE4/J7z04dQijCeLFn8pOzxuKrdYpMLXPkYPd
 ZdHK9s/kFr8yEXxz2Dp7d9iVinlPHMF7epZ3lsX9vccY+qf/e7sjKnLB3mo4WqwJwxQR
 1CGbN2dcWKlZSkJ8foJ3svocKLfES+zV/AJD84l0x5SLG0GEZLFFvERLIksJI/Wt7TmM
 +/qb760HX9G9Vd/cDQH0E3NPM2pQJkjgOuSNa+EHE+VU2yQFc1bzp2Gqmd/4Dj3g6yGI
 Vj9Q==
X-Gm-Message-State: AOAM530i8fnC29aol1QIYcrOsdYv7D2MEWBuc0wYwx9L8cSqROItNx05
 kc04I6J0/1fl+6GbxDA/AucZBD1gn/NJgybntbzkSmxan9nUUQKAxT+povlEmGZldbnT1biAaOx
 bdFo8+PPIejEi8mOjnByfmkoYojAPM4IO/5Z98vRggr1dSZxRHoTBaDlMaZnHxe45OVA=
X-Google-Smtp-Source: ABdhPJwJ28BjxRQydXSdv3kpZHN6Lpf07TsYNXVlePcsPh5Xqgyd/MpQ7FE52+v1uJMUFASUHF3DQsPCaQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4048:: with SMTP id
 w8mr30885618wrp.82.1626710636444; 
 Mon, 19 Jul 2021 09:03:56 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:35 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-5-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 04/15] KVM: arm64: Fix names of config register fields
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
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
