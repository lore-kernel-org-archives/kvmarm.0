Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4F4C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7045961481
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7045961481
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 247344B0E0;
	Tue, 15 Jun 2021 09:40:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id apmXr0+69pRs; Tue, 15 Jun 2021 09:40:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A9D4B0FF;
	Tue, 15 Jun 2021 09:40:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF284B0DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogGQYXgEvt3R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:00 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CD0E4B0F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:00 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 u48-20020a25ab330000b029053982019c2dso19743397ybi.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=29BZ8y2wSdq8zl7iml6Bt00bIzQdXVAxUwLgng+5GpY=;
 b=mbhqUAYoLWki9ZQC/43jymFoWJjm7rNBAqWPNEdO+rubaFQpVPtB+CSPxuFRA7oUWd
 65odqls7yHsM2e3bt+lZE3gzA/fZz5rl5z2U4B196nGEcZ8LrEGw5GfJ/UrX3lSz9Nsm
 TsW0qKYlLkzVp3rVRHt5QFVwtHnbOygRjTQAjxieK1Jo5YdtoQ5dCaS0KCAbK/tcQM4g
 BwMO35UW38lyuAype8tfgSb7jUTEm20Pa2d3U9Qja/YhafAsS4YViH6SAfXH+CyjNn7x
 stl0fOclU4ioqm48YDsYXSifaSpYoFVEKtX3Fn+NN/T0PYF4w+R9Xbjbt2UHzjTLb6Ur
 GlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=29BZ8y2wSdq8zl7iml6Bt00bIzQdXVAxUwLgng+5GpY=;
 b=Hr1HReF1YcFRZdGxaCVMvKXAu7yJE5IA7p4q66nEa3MsZYam4nEGCzvVwD0yBYtMDi
 LLCFize6tRjN/ctd5tsBkGEsbOqdLJERve5foMhTj+15tAUe2gcPPbUjUoBTXGMK1yiw
 z5WvaO1N+CSWtRANFhZ+OJgyhVmBLdw7/RxHC7q74BA43SmS4kPiTdGD9QACNV9bWuKE
 Yvm2VBwBnQKXgMWaWK85rmhm31hgx0J/lJSK8peWF5+TJgXNnzi8Bhpq+fGQKAefEokU
 BJdzCN8NivLgjD+PZ/DojMfsKSgcxzCZko5OI++xzLRZ0fBbGc+ZHnZRCTpU1fqTyC0/
 mC9Q==
X-Gm-Message-State: AOAM532FHabsnc48kh3oJn5uiB2Iatpxhn6DIs4YENYOwL1XVhkWrRre
 Zd10Z8TTgmkLHt1Oc2fJ7kbJ7llXw0NijJSwIfKImg9eJPsItdJ4KnzCZtz7Pku5ZlENxAnKNXv
 sC9bHxmYj7xXyAwkuMuTXIEK1E9UoXk33zMgcxdwRCc52Chg6hrajCFtXX6GDo19/u/w=
X-Google-Smtp-Source: ABdhPJyqfduLDddGb1lOk/v5X9rCS+Pp0WuT0RKnWKDhyYRJKRIbrBPP1usWU75SZZd85GaYbhcHDfsJRA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:4641:: with SMTP id
 t62mr34041829yba.253.1623764399546; 
 Tue, 15 Jun 2021 06:39:59 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:40 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-4-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 03/13] KVM: arm64: Fix names of config register fields
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

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 25d8a61888e4..bee1ba6773fb 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -31,9 +31,9 @@
 #define HCR_TVM		(UL(1) << 26)
 #define HCR_TTLB	(UL(1) << 25)
 #define HCR_TPU		(UL(1) << 24)
-#define HCR_TPC		(UL(1) << 23)
+#define HCR_TPCP	(UL(1) << 23)
 #define HCR_TSW		(UL(1) << 22)
-#define HCR_TAC		(UL(1) << 21)
+#define HCR_TACR	(UL(1) << 21)
 #define HCR_TIDCP	(UL(1) << 20)
 #define HCR_TSC		(UL(1) << 19)
 #define HCR_TID3	(UL(1) << 18)
@@ -60,7 +60,7 @@
  * The bits we set in HCR:
  * TLOR:	Trap LORegion register accesses
  * RW:		64bit by default, can be overridden for 32bit VMs
- * TAC:		Trap ACTLR
+ * TACR:	Trap ACTLR
  * TSC:		Trap SMC
  * TSW:		Trap cache operations by set/way
  * TWE:		Trap WFE
@@ -75,7 +75,7 @@
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
+			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
@@ -274,8 +274,8 @@
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
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
