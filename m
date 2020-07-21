Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF346C433E1
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74281207DD
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPE+tWYj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74281207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20DC24B1A3;
	Tue, 21 Jul 2020 09:31:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tRrktcyZNaEI; Tue, 21 Jul 2020 09:31:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E4A4B1C7;
	Tue, 21 Jul 2020 09:31:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA03C4B249
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E6yoMORHt4IX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 00:18:04 -0400 (EDT)
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDDCA4B13A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:03 -0400 (EDT)
Received: by mail-pg1-f195.google.com with SMTP id m22so11320302pgv.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 21:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=373R9ouGaabWkF9LOu0D0r/ZsTxSFcUlmLnh8I9bY0s=;
 b=RPE+tWYjEq8lfF5Lw3l/T2VT2gCqX3SDMnLPmA7+qFMTTKSKBzKX5ZJj+2qCHprw0X
 zhFj6A9WFsSrz9NAqY5J4gbiqPbJPY8qJRzhfwUq9lyt1Su+mlIO4+W8O1jXJzMvWNZQ
 5uOA2k2a6QWmhZN5ysIsuMEd/nrlVlZBsmd/QDGma0t53aVuYeX9E2zytGNvy22clEmz
 swji83M0Z6BNIBEqYqvPmRvztC/wG/tcV8MVy6ra8iMBzCG8sUQBznsfD1Mynnvru0b0
 TNO3NgvemhHKueBqbtH3AHZ82se4DMGdqjcTcO8iyQkGvM6awUyOp6uosnGYAdWDzPfp
 hQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=373R9ouGaabWkF9LOu0D0r/ZsTxSFcUlmLnh8I9bY0s=;
 b=gzEAu6T0fZhx9EkDpGqvJqINkWgoQIdnd6eHO5MaUYXhV+5pmR0712xz1bPK16Ygns
 5+MrNnJ3qGIbmw5dzsWHENtesHa4HWcubupM1ccGWfpwkeViO3GTbi7jFKed4uP1/u6f
 J6cbeKFqu/CFxeduGZGYMMLh3YihJIay5IiKdnhVtk2sFwG6TUIm1Z3Xgd2yNqpayvs9
 COHIWLLZGHeitWlHjY11sVAF7o0FiUSrVaWIPvE1cuKQBoheYnug+JgoLoIJFJiNnH4q
 d/cCnP7Wj0UpczzGQYVy7pUdVNR+icgzAbH4h0pa19D3TfF4JMI7NI+qJoNQE82GFtxa
 vPig==
X-Gm-Message-State: AOAM533X5kb6wkvzeQ4sDHL6UwvXPzLPpb+B6SJsALCo02PbS6Fknpax
 YDHTUN2mfTGRfTOrSmhQ/T8=
X-Google-Smtp-Source: ABdhPJwVPnVtk5dh2Lh4fkPP3MVN8SquGMQEFuF8nfcQma0abf59oSZFhiCWcRp1e3eJXlBbB8zm0g==
X-Received: by 2002:a63:417:: with SMTP id 23mr20032006pge.44.1595305083162;
 Mon, 20 Jul 2020 21:18:03 -0700 (PDT)
Received: from localhost.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id
 e28sm18467270pfm.177.2020.07.20.21.17.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 21:18:02 -0700 (PDT)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC][PATCH 1/4] arm64:kvm: define pv_state SMCCC HV calls
Date: Tue, 21 Jul 2020 13:17:39 +0900
Message-Id: <20200721041742.197354-2-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 21 Jul 2020 09:31:48 -0400
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

These will be used later on to configure and enable vCPU
PV-state support, which is needed for vcpu_is_preempted().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 include/linux/arm-smccc.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 15c706fb0a37..cba054662692 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -99,6 +99,24 @@
 			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
 			   0x21)
 
+#define ARM_SMCCC_HV_PV_STATE_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x22)
+
+#define ARM_SMCCC_HV_PV_STATE_INIT				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x23)
+
+#define ARM_SMCCC_HV_PV_STATE_RELEASE				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x24)
+
 /*
  * Return codes defined in ARM DEN 0070A
  * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
