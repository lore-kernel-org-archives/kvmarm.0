Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E55C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF30F61477
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF30F61477
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9934B110;
	Tue, 15 Jun 2021 09:40:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y0GZfSWNW0yp; Tue, 15 Jun 2021 09:40:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 588F34B0EE;
	Tue, 15 Jun 2021 09:40:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E984B0E4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RiFIRjhS1+fp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:07 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 606024B0F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:06 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 r8-20020a0562140c88b0290242bf8596feso10141887qvr.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kL/kBHAQck4ApelGdSS7r2lP6eaQeDEKtmMiMUjhfo0=;
 b=gzqPcBKLBvsLtIpEG1aUU37g0RalZyoxkyhQar78llr2oOc96Tava3TDOCiRx/YzEm
 OAh8TvMkEWDMPRC/bmfuFicpQV2yuurSJCvzKZuu7RXLqmur44ozuMukAkMEaGUyoOEL
 775rpm73wH5/gfsIXgBzkK9rQqPrjXOk0GIoLBVxrqDy8OmH78CbVcj1TYfehMToBrGu
 vORRBMciUjIHgl6+21vGLDXma9hKclutw+MqKY79hibqJ/RttXxhJoUBjCKvW5EJbMlX
 4TRfrtYuBACaUKlWTnWTh35wbz5CtLb6XErSBJSX45vP3N3sniIGOEHGty3ZLjb7Qaiy
 Y1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kL/kBHAQck4ApelGdSS7r2lP6eaQeDEKtmMiMUjhfo0=;
 b=U3BeUi+Seu/nHBfNdH1nr0imWIctiqv0scpLc1dXYq42sqDcFyhsIKvHYLSCd+tcYH
 g4ZJ/2WrZwOVkN4GcZsxywNey8PHVw/AzLGbteY9rwcwGXYS+td0VPEJjH6RBRBqU6/Z
 XAFf5OcOL5okq68xu8c9VjOdP9r606+JVCOLJzvg65vfDYZaHTitlWqQPLte6SOPDz4h
 SmSjXxnh+oW4njXXTgbylcT8LKZxEMIrrxsaEnko0BOqREeaejBKB6Wu6nxMGGLVC7bo
 g8dTDXH16xSLALGTS4meDcYaxzLcWcUyR5MqjbmAwvjDC3tl2PilOnH3Ya9Vf9XmNKV6
 mLYQ==
X-Gm-Message-State: AOAM5327/izR9tsvzFzw+le/P1kVSqpXZ6/j1KdMiua+Bb79Yj1sVz3d
 2IcngrCK/dtz72iAGPzL07fd7UyW4u5+/8lD7Y6iAtX9VWsMS3dIVtwstB44I3fR8kDic8YjPM+
 xqqVCmRxAExIRzbsf50jkwRaAkLKaf3u/zPeoPsZlMsHtKmOuWeUStjGzkcr8av2A8YM=
X-Google-Smtp-Source: ABdhPJzXW07KU0XghibXdRXCGLp6L5Ztu0HSUPRZ+aQpdEyoZgVmZraHgVD7kZuhI194f2WprPrdxaRdtw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:536a:: with SMTP id
 e10mr5022177qvv.9.1623764405756; 
 Tue, 15 Jun 2021 06:40:05 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:43 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-7-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 06/13] KVM: arm64: Add feature register flag definitions
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

Add feature register flag definitions to clarify which features
might be supported.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 65d15700a168..42bcc5102d10 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -789,6 +789,10 @@
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
+#define ID_AA64PFR0_EL3_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL3_32BIT_64BIT	0x2
+#define ID_AA64PFR0_EL2_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL2_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
 #define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
@@ -848,12 +852,16 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ASID_8		0x0
+#define ID_AA64MMFR0_ASID_16		0x2
+
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_NI		0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_PARANGE_40		0x2
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -901,6 +909,7 @@
 #define ID_AA64MMFR2_CNP_SHIFT		0
 
 /* id_aa64dfr0 */
+#define ID_AA64DFR0_MTPMU_SHIFT		48
 #define ID_AA64DFR0_TRBE_SHIFT		44
 #define ID_AA64DFR0_TRACE_FILT_SHIFT	40
 #define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
