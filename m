Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3378EC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1052610FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D1052610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 899F84025B;
	Wed, 18 Aug 2021 16:00:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M8SqtGBLvlJo; Wed, 18 Aug 2021 16:00:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82A6B4B102;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75CC84B0AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id luIwmoqQ4f4C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:28 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75B0849F5F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:28 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 q15-20020a056a0002af00b003e2840527ceso1781088pfs.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
 b=XclqRPUA0/dOnnUxZ6e5xfFEGz1bzMNLZDMWFZSNFvSFo8M+XkqAR82qhWjdPE04Gd
 aXBogWWruyzy9kxHz03pmBGH/UtNF0W3hCs5Aaq4tpFylnvpbS77o1qVZhE6gSQuUQw4
 mJkGlM8sPbtWCf+da7Jh+QMhfXB3oiO3IwX+9fwS1X7zzd6PquEQPLAul6Z6D2FsdeuH
 O1YzzLW8k2PHAi3uM/cXlCc5b8E7dTrTBvjTkL5DH6rkSScy+NHjgpTDduDeCEmNH+mF
 K/Okj9Ec+GiUjBFew8hgsuz9H4bIcWhcekTwVtjgiLg39+UVOacGwheMLt6SoqfOWwiK
 SluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
 b=nWGYLcREZ6YzcrtcUZ79G+HcwNn4BceKOcZtTcLEjMnUzr0vJbqt74m7J/O3Agjawg
 JwzbOm7P7ILnbQah/KGNJYeDIhhaYz9ejW3d5pkid/nBwkYQcYlCiEGtMJKu582Hxal0
 BfaJUohPFOslZBBdzmRdPRzmU5bg1a8piYVhk6F78BIrBklqwH6h4fI5THeUxqa1EbMG
 WMBlwhRdBQWxMjFd8LeXDU8mPPSAt1j/wsFr9J9mYaCPJcBf7tip33kbq/QQc6NLA14c
 emPNFnTEM2QDbTRutb46+yV5X8gQx5F8EUULBGfqAGhVvzlZjgY6zeuvBHABW7wgQTWW
 tt0g==
X-Gm-Message-State: AOAM532JTLFai4Nxi04a8IH6cF1kIoCWcafXRuyu8zR81+CDmOd4Og2a
 iRc7uxBA+LzBN41uVa6dZ8ncTBOw3u9H
X-Google-Smtp-Source: ABdhPJxc2j/d30LFbliRbem66L7CuOMyzlZyrRGCesZ+JnC9QmoojdAvcyujHgWDyq8CQJl8cLQINmB345v+
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:903:4055:b0:12e:ce88:e896 with SMTP id
 n21-20020a170903405500b0012ece88e896mr4978961pla.21.1629312207724; Wed, 18
 Aug 2021 11:43:27 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:06 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-6-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 05/10] KVM: arm64: selftests: Add basic support to generate
 delays
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
