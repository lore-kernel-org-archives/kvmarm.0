Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9F2C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BAD761221
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0BAD761221
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3F7C4B110;
	Sun, 15 Aug 2021 13:01:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lcEj8Fhqn9Nv; Sun, 15 Aug 2021 13:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D26AD4B11C;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0157449FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cDZ0ksMK+wip for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:40 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5D244B0A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:39 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 u6-20020a170902bf46b029012c971d6226so5685237pls.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
 b=CWKvMvq482YcNTRILLKxrh/xXxR9laMMXd5epUlsTlwgqwSaX6jxASp2d+jPJJHATO
 uq70iG5BIugJ6LTQ/N2CA7kNudIDf8jJOq/Mbeq72/1jYBoPwBj47fTLtm7ZYZ3UHWgj
 LXD5RMu1CojOoWF8rcnS78THeu4/0Aohx6EMP0HZc8Ps0Zk+qQTVPDS7U6/VXSXlbPZJ
 MjtBHGnHlUOfk96OBdhBl4berWwQsylBeu4KtAOyoCtCXEftrQk+hdqlCoLRPcYIV2va
 rR0J/hpsbfkRpmGM9c+uIbBOYxu6mjORsohBqt1WNdT5lSCYEoBSYWpOvv5dKH1WGhF0
 jlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JcHymXf2ERbzAFxFFXQtQ/oPOCBg0VdgmGHaGoYCh8I=;
 b=sOCIJ56Xf9uwha9bLkujWhmp4+oSHZ03k9HAVUT/AV4g0+aks/1hni0rhQsmySblq+
 PmufR5B67NDRuDh+YQOzygIquK0oGgVWI3WtRlIJGHrwgxfupKQqCGJLHkB6K+Bp0fvZ
 +d2KQs316gDbjjpqA9lrG4SSvaVlvFb8N2pnrOf6e7QWarA6cUUX63E2IwhkcS3pjuPh
 RJB+IhAeURwqvgaZu/m4krMxVY/KSlddSLH7n32ApkkKjrvfx05SgtfItxWzJ7eX+3vj
 qb5f3xPPH+iZWPqDL8oO4uWuBCnH2swQcSZi2b8MnGAAUwkTtFxHOm12H0myS3SNwXUM
 n3Qg==
X-Gm-Message-State: AOAM533tPmYF8Obc5daBw9v2HBfnXFU3AVOZlEumHalqtJq7SWDD0Xwd
 TibzJYcQwNq1hkgOTJVa1nW+q/r6N3BB
X-Google-Smtp-Source: ABdhPJxkQK9wa8EAKeJUZV8Gv80qxslUu0aDGjvZsi5a5rtCn9QS93AjUmOYIEaffTe0zniAjkpecuN6BdRu
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:7584:b0:12d:8cb5:c7b8 with SMTP id
 j4-20020a170902758400b0012d8cb5c7b8mr3462236pll.84.1628889159142; Fri, 13 Aug
 2021 14:12:39 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:06 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-6-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 05/10] KVM: arm64: selftests: Add basic support to generate
 delays
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
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
