Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4ED1C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BF5961103
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9BF5961103
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5232A4B1FB;
	Mon, 13 Sep 2021 16:50:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jAoulbINVBCQ; Mon, 13 Sep 2021 16:50:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AEBD4B1CB;
	Mon, 13 Sep 2021 16:50:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2CE54B1B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:50:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0spt85+Iyp4U for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 16:50:00 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 616DC4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:59 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r13-20020a17090a4dcdb0290176dc35536aso5746474pjl.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 13:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
 b=XCvIJVs/DuwD6DVXVIzmTZNaPbpYhKQLqpZ+rykxYdMxB/84Qi3vvYNUM88AonXgYm
 3V6M6oTDcFmeLBGC5wdKY8zvWQpQhY0wyzDGjzao2o0kiQeF8MKozUm6aPUJDoNJvQ0v
 Lmji7B2c73sTFVtY40SkEnXFX4/nn96K40bYLwW1C3pGJ5ybkts2yHh9IuwHH2le2c/F
 bklsQntTOO03t4HxTTxahmaU0/nj5BytTybtnNuD2k1GS2D8URinNWESa7cXIMFXBD7G
 9OnHFMdEybV2SP5svwz3As2tL0s9uOYNxase9+yjgy4dHZZJJIzB8FxgLSP4ZBdHFgbL
 qNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=++4XnYRgMyNMsEZoy1OpwZj4635Oms83QujRa32HDH4=;
 b=Gm566UEihZl9WnuERh6uGTCtUuUjAJULxakSe++aBefWXjz5U6v4HYisBuy3T1x4LQ
 FKPq2nKDNqFKtl+/edqKT6XE8pSjgEvxCx2cPLaCvJ6VbQ7obrH2ZruHNSK6ig+peQz/
 USiKQdmZ0/52jgN+eUYtTmu44NhE3RzAtWEr8G7GKX7UpCWz9trhdTkWnGExEBCqgEIX
 wq+/OQeKDr6faWctW4OyVV5Uv08Yevj6FIqpixqKUnHXJkorEGJ3PAA0dkBC58CGRfOi
 Tlqt9i715X9GchdNipxgCsjgEHfHtvfbR//Kr5UrxTT8SqGDBERBGYvQ+BHYYglxsJDF
 olLg==
X-Gm-Message-State: AOAM532raRwaNURHpYfDbZhk6lYscRMxvG+VrTw5VwZk+vDz4qpmM4Pv
 MQKwlEfJ3ZFgDjtXestKuec2alLA+6RZ
X-Google-Smtp-Source: ABdhPJwfTceLZYDZAwbbgQTF9ZLpvhVdpi6vUBIdVg4ocUiJi21dM3Cwnc6gs258WgslLA9IFf0uYZgYLOjP
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1706:b0:434:9def:d275 with SMTP
 id h6-20020a056a00170600b004349defd275mr1328644pfc.1.1631566198555; Mon, 13
 Sep 2021 13:49:58 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:49:23 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-8-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 07/14] KVM: arm64: selftests: Add basic support to generate
 delays
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Add udelay() support to generate a delay in the guest.

The routines are derived and simplified from kernel's
arch/arm64/lib/delay.c.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/aarch64/delay.h     | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/delay.h b/tools/testing/selftests/kvm/include/aarch64/delay.h
new file mode 100644
index 000000000000..329e4f5079ea
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/delay.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM simple delay routines
+ */
+
+#ifndef SELFTEST_KVM_ARM_DELAY_H
+#define SELFTEST_KVM_ARM_DELAY_H
+
+#include "arch_timer.h"
+
+static inline void __delay(uint64_t cycles)
+{
+	enum arch_timer timer = VIRTUAL;
+	uint64_t start = timer_get_cntct(timer);
+
+	while ((timer_get_cntct(timer) - start) < cycles)
+		cpu_relax();
+}
+
+static inline void udelay(unsigned long usec)
+{
+	__delay(usec_to_cycles(usec));
+}
+
+#endif /* SELFTEST_KVM_ARM_DELAY_H */
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
