Return-Path: <SRS0=w/1t=MB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F01EC07E9C
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE238613DC
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE238613DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC1449DE3;
	Fri,  9 Jul 2021 05:25:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wWrUgD9Q8KqG; Fri,  9 Jul 2021 05:25:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E954A4A0;
	Fri,  9 Jul 2021 05:25:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD43140870
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 00:37:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XpZR7bsTAjNU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jul 2021 00:37:36 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5EF340808
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 00:37:36 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id a127so7590602pfa.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jul 2021 21:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=eBdDu50tMNuB7A6waM/ZyWIMl2LOJYIC1/NpalUridM=;
 b=C655qxBGfJlYMHH9QBFLbhyK4uAmvdwzkJEVRuHMZB1mKz3O4MEfvXbS4szocXmsQx
 XIZA71qy/kDzskTcV6GbpzRzk8XHO4KV9K7Cf1kSB9kEBsdsJHCYou1sWIlHT4aU7d8n
 oO+1zOGotRjyCjPehfvMbg1+d41s4nllzJJ4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=eBdDu50tMNuB7A6waM/ZyWIMl2LOJYIC1/NpalUridM=;
 b=aIAbelOhF3gRe5+25UnS/HiJQVnRNgBbaVhtfUyt1hLsns1oT2/pwENYRtG/K0qWlc
 euhWBs1rKY2sVj53WA+9DkXeXIQOS7Sv9rMYCiBoVeYrxcc11GUthESJkLelrzIwn0m5
 NoYQs65G83mXHS6dROLKHCKWgUcA3mYx27imV9/qYQzkQSmEmPhMa37Mm1ePy3KufVIe
 7LwD/H0l7A8cRaM7a3qHHVvvgzjWomadIRh4aBCjdC3wEx8S7237fF/WTz7fCBLN0PQI
 c6RiDZBIgrGpKl1Q5Z3rh9BuN6d8xS45+YhSvKM0EIfBWBgIjBIAxuceh4FPVFZdnUx/
 qf3Q==
X-Gm-Message-State: AOAM530PL+UOZrIDzmQtxBlyk3MpWfBtedr8fA7qLNWigg0Ghw6rf6O5
 LZp0jkfeMqbZTpX38SC5M2BXmw==
X-Google-Smtp-Source: ABdhPJyU5pINJoX/AogKYgRXTY5MbyhKXColfNbeIbVpm0ISXAwe7bj9tLDDjqgSf+cAP3MHB+R6Wg==
X-Received: by 2002:a63:4e4d:: with SMTP id o13mr35755196pgl.361.1625805455971; 
 Thu, 08 Jul 2021 21:37:35 -0700 (PDT)
Received: from senozhatsky.flets-east.jp
 ([2409:10:2e40:5100:a30d:fc4:7834:ee08])
 by smtp.gmail.com with ESMTPSA id y4sm4420760pfa.14.2021.07.08.21.37.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jul 2021 21:37:35 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCHv2 1/4] arm64: smccc: Add SMCCC pv-vcpu-state function call IDs
Date: Fri,  9 Jul 2021 13:37:10 +0900
Message-Id: <20210709043713.887098-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210709043713.887098-1-senozhatsky@chromium.org>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 09 Jul 2021 05:25:42 -0400
Cc: Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Add the definitions of the SMCCC functions that will be
used to paravirt VCPU state configuration.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 include/linux/arm-smccc.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 7d1cabe15262..dbf0d658e54a 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -177,6 +177,24 @@
 			   ARM_SMCCC_OWNER_STANDARD,		\
 			   0x53)
 
+#define ARM_SMCCC_HV_PV_VCPU_STATE_FEATURES			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x60)
+
+#define ARM_SMCCC_HV_PV_VCPU_STATE_INIT			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x61)
+
+#define ARM_SMCCC_HV_PV_VCPU_STATE_RELEASE			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x62)
+
 /*
  * Return codes defined in ARM DEN 0070A
  * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
