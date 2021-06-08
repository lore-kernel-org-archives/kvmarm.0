Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0371C4743E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 932F36135A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 932F36135A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3263B40825;
	Tue,  8 Jun 2021 10:11:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jvV5UTNEKRyf; Tue,  8 Jun 2021 10:11:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C5840CF9;
	Tue,  8 Jun 2021 10:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA30840825
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zmf8Zridu0LT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:50 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00DAF409DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:49 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 2-20020a3709020000b02903aa9873df32so5516189qkj.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JXESWIRrg65Jst8XI7PkCsZKq0ZtOHhtcll5+7kJZvQ=;
 b=EZZZOs/wJaLpc4iV8fhIWCgKJcms1Zc85BNtnQggUPKXLstvhiF1Jeh4Z5mKQORV1x
 rFVJ1253JOz+Ny3hILPyxJN25otv0qA72R77AxNIg/sjMzYAn95LC9YrROnTMPnB9hJL
 5w1ejcaPtilYK6h/+gIJNqCjIPpGrtK+wn1lEvXmeLuxuc0ZTXgQICCE9UdsRrPtEtap
 u0tTuPG5/p/s5OYny9dy7K5wOHk7JRHis7NI28wlQNOg37qO8VQhe8xTtU2PYPK0oQyF
 RRdHjhmCR1EpJ5PkNy57QB3dBgQVQzyUdGqtHQDFUy/huC8jMWOlrPjcuFbQBqn+PDIN
 FJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JXESWIRrg65Jst8XI7PkCsZKq0ZtOHhtcll5+7kJZvQ=;
 b=Vhf6jAOzMuaU+v2GmIn9Wdo1GQMMaG79V2JRb+lA/9hxu++tzFKkMAw4fsbwMKeq8/
 BblDyksLpbSylqa4VVBoclCswtc+uPKu98H1fNAN9NdVb3MeQyjAQdf6lx9KxUHdVejq
 jYoad4hNISoJDCxZ7m6eWrJ6SQrq8Y+XlcX+IAMfaEcCb4RdQoBShN/vllsOb4e/AUqt
 gMlpLFRypFkc57I69hLiJap/jHftTsxbBvDYisY18/5YoknpKB/hdT1AeOoYQh9kbhqk
 H92EzMGX30DM2b5VyI88oMrkjKFAVTnkNxmrqRlIcW6P0UmQ3LoCut3d856R7NYrn8E6
 WWLA==
X-Gm-Message-State: AOAM532f1r56Uixyt/C9GgCuO4MmDlrcsUvYu7fVRNsoHfzLotMT4itA
 IBHU2sZQporgewS5QcHKoX6dvJOwawGir4Eqx502UvlGsmFM3grHlCRGwT3rgm9oorT7it3cjjO
 o07jXizd8U8K4AzxsKwNkHQ9Pof0++kMzFUg8icrrX9tmcmJoxMRSPOt19+c7HF7PCq4=
X-Google-Smtp-Source: ABdhPJzFZhBxwNe7fGP0rKm32SNqUOu/zZzV1SJv34ne7YfRjjA0JDJ8WQ4OdDzl/uUfpzc+v515ENBpag==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:f982:: with SMTP id
 t2mr327420qvn.28.1623161509479; 
 Tue, 08 Jun 2021 07:11:49 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:31 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-4-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 03/13] KVM: arm64: Fix name of HCR_TACR to match the spec
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

Makes it easier to grep and to cross-check with the Arm Architecture
Reference Manual.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 25d8a61888e4..d140e3c4c34f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -33,7 +33,7 @@
 #define HCR_TPU		(UL(1) << 24)
 #define HCR_TPC		(UL(1) << 23)
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
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
