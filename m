Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44A2C4743D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B3B461108
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B3B461108
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D6B40617;
	Tue,  8 Jun 2021 10:12:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HJBoO-0preFw; Tue,  8 Jun 2021 10:12:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A2349E93;
	Tue,  8 Jun 2021 10:11:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 944B740623
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id irRmwl6pSH8V for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:57 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CA86406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:56 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 a25-20020a7bc1d90000b029019dd2ac7025so813900wmj.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4Asy9TeJS64pEvGY8XEAbuolwNNbKZBoX69L3dIU+1w=;
 b=pqkh1UBwITENdBKvU99xgPAZ6Mx6QI3ILsXjKO6Uq7zCucOnSy+qzrIEiZPaZXQEKa
 cAU2XhxYOX81hN680aGEcxhGPa1HlZOb7BQ+XW7M5qWn2G8jCmt7f7Xhlx8hycAS8+Rw
 vFAIYth4ZXHQFJmTS+gHrhPYguUOT2hVxzyRQTGNbeXaz3ieVgobfOmpUhOJp7ELzepa
 +pk4HABsT0zjVO3z+nkudCEme5XhkRghb8hwDJwVvq9sMZYElPUshgVbSXE0tiLK+r+c
 gh4rH7nLfJ8NSSWcLxvyvRfmtTCXT4i9h8kdD6apYO/zYRHfRcIFZVHBJDOZXw7qobdR
 JveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4Asy9TeJS64pEvGY8XEAbuolwNNbKZBoX69L3dIU+1w=;
 b=rEmlSLEsOOiaE3jT7Qu53dZ494fNZSa/4Pzse9yNEubl66Zger5PZaXigFsxD+Jbx3
 JFT+Hxfa+vkCCLpv4pcIv4uwsC3pC56zgCRJD9XOEbcTLd0xbftd4EHXp6W80j2sFG7x
 /U2MYFCS5mV0LPla9ikF67lrkV4gjAWMxxLFwka5+0OSPMGcm6BjAP3ow9bmf8y6Zbkv
 3LjDOb9/ENX0rSpSwHShSoMiVVfAzlX9COyP/XgIHQpRnkJsd24pVtkFxfsiDJI/zBBo
 zr6Fmpua0bk7GVcMJeZEdSK0fxecpRyBukOsbZNSUhjzVW4a1zCVAyvhCs0lOCdcy96b
 z9Bg==
X-Gm-Message-State: AOAM531aNHKGQ5oiO3LtSkhJWwXhe75MBabX4wUOH4r28nqtncpe8Igz
 xF/0vfafhuBJe0df3HoDPViPPj0IuQEhtbF+D3lZFxHFxxyU6hv/99PlhxmncpJ5kzNMYEG/33N
 Tg7g+i2o5E0cIuhk3+Tycc/zWcpRxBi8XS67bHQETfaGAJP742gtNt8f9D0CbRKnDuJ0=
X-Google-Smtp-Source: ABdhPJzS+sELn7BYfrB7ptQIb0s7ygi8FymYY+xXnjkAYPENkhE5guGgsqKszr4QNxFmh8mo96FSX0OKWA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:f70d:: with SMTP id
 v13mr21664188wmh.183.1623161515598; 
 Tue, 08 Jun 2021 07:11:55 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:34 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-7-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 06/13] KVM: arm64: Add feature register flag definitions
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
might be toggled.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 65d15700a168..52e48b9226f6 100644
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
@@ -854,6 +858,7 @@
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_NI		0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_PARANGE_40		0x2
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -901,6 +906,7 @@
 #define ID_AA64MMFR2_CNP_SHIFT		0
 
 /* id_aa64dfr0 */
+#define ID_AA64DFR0_MTPMU_SHIFT		48
 #define ID_AA64DFR0_TRBE_SHIFT		44
 #define ID_AA64DFR0_TRACE_FILT_SHIFT	40
 #define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
