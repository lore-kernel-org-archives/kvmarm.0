Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC67C4743E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B11E661108
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B11E661108
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64AE14079D;
	Tue,  8 Jun 2021 10:12:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9oG2TSrxXJBm; Tue,  8 Jun 2021 10:12:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8750E49F83;
	Tue,  8 Jun 2021 10:11:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9F0D406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id epZNiY51fqLt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:57 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA1EA40821
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:57 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 k12-20020a0cfd6c0000b029020df9543019so13248141qvs.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PeB+UBqReCGwpCjLlz829AwM5AYc1PkEdvHShsb8BsY=;
 b=thWPfhDKbF5s/ofjUoC618+2dp0pJ6SpArtej3SQV13eC53nY4my1hjo7wNFpjVTmK
 yGHlTgow8y7JhOomXXHMNqFfSQSCw8cIokbKDoG5o8uO/iw7Qz6I7L8zrZxSbtXCzw1E
 kH/kMWS4ZwSMu1APA9ipWbzroPMlnqFDdilyUsvKU7we20dnh2MdNxQj/ueOjOzZIlce
 dvugoeETqCejcNqjuKVcyI7KqCyZqEpCBTDKP43wzWg0yoW2mQ6+Czg0ver96xkdKBTr
 aKVDAXeEKI+h1lKlx25/Q9MvHfUl61FiuWFkvdUtsjsPYMWPEP7y4r5aT8G48XkWtFRf
 d30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PeB+UBqReCGwpCjLlz829AwM5AYc1PkEdvHShsb8BsY=;
 b=TcIGWXxWAzjnA15xgU0FdoHwhAD4cyAiIdgEGyB5DJ6+Ab1bgRCcipTln20bZ0Ardd
 XuikCCo4twAQYZpxRd066SBkFYpgtFrIy0G+CuY/v+ciSnCThJpuPOhZr3bfye7m4Da5
 rXIR+eX+MPr2vjCmROeoFhAabex5OsnvF8GDrN0zfpPKuSMM2fP2jaIEgP0WJqu4kG4b
 pMMJw5TWwkQGYjeQ9RUjh/TEG/31L7yeutgm9NrRjpNaP6VnoUeM9AIZATaAGVaX+mTm
 QxpS7r4bPyq/7cC8ce3cJYCOKI9kCg6snFQjbRKWKNuKSDY0/qCoFA/HTdpDVLb1egzs
 po7A==
X-Gm-Message-State: AOAM5312JxR3mTurK+/VUjc3O0dC66PvUUBAjJ2J+zA81pu+avwsC4Pz
 S5JKOA7TxJDzS4klTlap1ApvwDy+1a0Yq2bte/j7hY/xLrKH2G1z+HSsWr2qvyd/pWN9Kxj3p8R
 bznNFtqL6DPapIJlxENWYO1LDHyJhdLMnSV1T9KsJ6hL9IlNl6cVn5t3ul/nMocs6UDc=
X-Google-Smtp-Source: ABdhPJxb527Ok9dzKMDfpH0rL290/po/5ZdFVHy/rNH6MII/RtyWRGkp6JE/bCw5MFqPLrEii301dtlmdw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:5561:: with SMTP id
 w1mr23725500qvy.47.1623161517455; 
 Tue, 08 Jun 2021 07:11:57 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:35 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-8-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 07/13] KVM: arm64: Add config register bit definitions
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

Add hardware configuration register bit definitions for HCR_EL2
and MDCR_EL2. Future patches toggle these hyp configuration
register bits to trap on certain accesses.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d140e3c4c34f..5bb26be69c3f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,7 +12,11 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA		(UL(1) << 56)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -280,7 +284,11 @@
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
+#define MDCR_EL2_MTPME		(UL(1) << 28)
+#define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_HPMD		(UL(1) << 17)
 #define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
