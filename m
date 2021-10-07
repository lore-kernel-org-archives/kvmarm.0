Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC356C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73ABA6137C
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 73ABA6137C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A59A4B1DA;
	Thu,  7 Oct 2021 19:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WXqCLX1Y3CJL; Thu,  7 Oct 2021 19:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B24424B25E;
	Thu,  7 Oct 2021 19:35:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72F934B19D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FJPExdhqsPNK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 19:35:06 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4F5C4B1BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 19:35:05 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 d6-20020a63d646000000b00268d368ead8so587109pgj.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 16:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zdzYxOXw6HRBi/j9Q4Djh6DlKsT7KOqy9GkRVsRm4i4=;
 b=PvCCl4ZEQDsLP+V4LSuwH3sCogQbp1B9/TjEPTV8Nu5kiq6lYaDWIAyAbL60TcCriO
 TvK03v2M+Fk6kFFH8ucJeeM6OQTB1aTWP1gmvUqjbGltaij4+2MAeHFGuX4HCenQLwzT
 nNb/riJFKx1B2mLcVjIq+qwj1R8H7LegcugghClZjUKpaskRXhrO4DA6ZdCJfuB/XTnL
 62oIU8it2w+FC9kvR7JrAZq4iWZLeYlkl7mTVgjJLhcU+nP2uohiXmICjub5LWvb1ad8
 TRrchyPGubtZPJSPWL/JIdDssStNCNcvQo8H2EqT/ReRwJw2ZJutddbBu7KoJPNit/CD
 +M+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zdzYxOXw6HRBi/j9Q4Djh6DlKsT7KOqy9GkRVsRm4i4=;
 b=rp4EKijXxYz0bdRziIFt5R4ohlhaJHiAWA1arRZnQJMkEditeQZkunB55x7tMHT/Ha
 x5zd5MAebCBSz2S+iUl0YM4OLa0RMHRkozsKRwqHip9UpS5S66jz4NsM88PgWcMkJqkK
 KY77i9uI5GCo8AgMGrM998TCv02HeJ90CtHhHJBjVlOHP2+DRlFdxuBGvW3ng0yQVIC2
 xhxkYw0CiRk9FFOqXPnkBLHbHPfIp3e2ZeEqkuOIHdM0ARoV4LTNAHDHIWGCt7e6tyL3
 THtTHJhnr5BYony/aRmIgegS54+G4W7tmTBfwSkE9IUAnzsNfyiFLg3MvcjC1x7kHvDH
 XWIQ==
X-Gm-Message-State: AOAM532CaRe0UIUnba8C2LaKoLGSRxVaQ8t9V2JwGCJkmk+YxFsd/OUf
 woSS+BXjj1TLhUnv+7+W0m3e6DTkB3rq
X-Google-Smtp-Source: ABdhPJyilhCRZk0a0SoW62S+ez80OkitwK2J0PNfM9M/q/wH8V2CCWfESNfQOqN3LyPJYXZ7p4mJxSOzXVdc
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:b093:b029:12c:843:b55a with SMTP
 id p19-20020a170902b093b029012c0843b55amr6613361plr.83.1633649704900; Thu, 07
 Oct 2021 16:35:04 -0700 (PDT)
Date: Thu,  7 Oct 2021 23:34:31 +0000
In-Reply-To: <20211007233439.1826892-1-rananta@google.com>
Message-Id: <20211007233439.1826892-8-rananta@google.com>
Mime-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 07/15] KVM: arm64: selftests: Add basic support to generate
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
