Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2BDC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93BE260F90
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93BE260F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 482504B1A2;
	Wed,  1 Sep 2021 17:14:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s9LFvsXMu--c; Wed,  1 Sep 2021 17:14:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 259F34B1E0;
	Wed,  1 Sep 2021 17:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7455E4B1A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dgi61nQOaMLV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:14:35 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8166D4B160
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:33 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 r21-20020a63d9150000b029023ccd23c20cso367958pgg.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+AY8FeEMdxANwbygbtDaWIs43jeZEXZSs/Nh/5qOONM=;
 b=sEIY6pZWU9JUoxbD3SFQAJZ+HaGDWEhhiX68l598G5kx1J0UFKGKlaSU38oiDTa1Tx
 M7YtesHq9xYqY0otdE0WpP3W5upth9uNrvUqlySOeWYnXdGfchoX7OqBLWKau4auWQci
 /Ml7YMnAC38eUFvCK8SQG8vG3CCC+WSwiLxcpI2nY/kIbj7jXbgrh4aijRFluLZH8qTQ
 r6862jdf17hMV2ehP0rYONQtfJac19PddlZr8gfK+HFjgAhjc3Uz1i5jonJrhI12qoMx
 tF06MUmg9WXAq6agNAue9s+mZxU7IgFJhBH9Ayn0+bL0etqXxP9RchKd8tiKtxV4bPA6
 xt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+AY8FeEMdxANwbygbtDaWIs43jeZEXZSs/Nh/5qOONM=;
 b=C4eEG5qaizqKGJX9Av1JgELWgvllanrtvI0bLWcb1PDXA78OJYQoBIcbol/0kvBm1h
 HVZF4mNlT2Ym6Ts1N1Ypw6NHFyjnw/u4p32gPXVzNxZPfdPj3qhzqypVzvDPmfLvqT0E
 0YPKRg5ODyqrt2B5idDv8RED8NFxd4fJ5xJ2G07oyOkmVnrRGOAbosA8XgcmNY3b3tR+
 U9UQTuVBEopqjXEP3oRhwEpfc5YJvxWNs8+c+SvHL+K0QHtJP+H+JTOAFlZ+TJH8bZRt
 H+t6kCp3WDBg76t9UbU5uUJNV74rj0cKujMkiB41MTe8E9+7N1n2sFKBhcEX6SK/JsiF
 /5jw==
X-Gm-Message-State: AOAM533x5b3jCfz3/e5MPzmh35IPB/+g0xvn/JrJkTp7ZmNm3nEwpVaQ
 r/RE2LYQvEO0DkV8j2NNhxKST8K6jZkE
X-Google-Smtp-Source: ABdhPJzfQCQqY7ZDdEh40WA7Lnhk+LTL8HLswLGjRlSmvbVQ8MCEnZQQ9EpYsHt2TdSwBvGTdcslFJvAEGDG
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:1888:0:b029:3c9:7957:519b with SMTP id
 130-20020a6218880000b02903c97957519bmr1345245pfy.17.1630530872495; Wed, 01
 Sep 2021 14:14:32 -0700 (PDT)
Date: Wed,  1 Sep 2021 21:14:05 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-6-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 05/12] KVM: arm64: selftests: Add basic support to generate
 delays
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
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
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
