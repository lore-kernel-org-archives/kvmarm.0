Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E61C432BE
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2820261212
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2820261212
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2834B11B;
	Sun, 15 Aug 2021 13:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sqQj5Cz-FafY; Sun, 15 Aug 2021 13:01:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B504B13C;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9764B0A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7phQhjx3MKLI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:37 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F1644ACC9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:37 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 k16-20020a170902ba90b029012c06f217cdso3745223pls.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ImD1K6W7q85b9plMlOYBF1Iglgh9e6yeR/4CNYhFQRg=;
 b=CZFVMacm4oRYM5riU6/kN8e+8QOv4ScQvNs7LSvfERJ4elKZRbXW+cb8Ajm1AP7A30
 RlwtBzLAGwJRbBQWXxizFVNyyhNotO7OsTweXQX2WsecNIfppBRrIGEldPfIqtK9rgBN
 q7lpifCkdvblOQzMIvdIsuToYogD0ih5pb8s6uGOzcaKoRfNg1CbXQA8AL2yutqZVz2n
 8t0Yb2b/6OxkhH7s4fpA/CBTuUYvc2vf1xbJRoEEZeWlyn3rmztALV6Z/xF4qjv3pcjb
 6rMgBz/c/geaxKZAZbK/g/LH+ddcynHYz4byTRGuv7/ja26tgAFuvg2zc8H6ed7fUDXE
 zxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ImD1K6W7q85b9plMlOYBF1Iglgh9e6yeR/4CNYhFQRg=;
 b=r/Okqp9fuDakzBNqIdrRLo1Q855b3mvcTrB4ny7S83wBK76X3c2AEvUQirsJ89SEbk
 o1tiNJCxVaxo75I97gWgSlonTlU0vF5uqrx3tHRbWF8Bh14fWcUqE7Qe6587H+6EOTcp
 zMkAQvrxyypMFJa2OUNY0ZCsK6URi59ZNQ9EyN2QfmbH6X5Kxsg8rRWDXOAj5Wt32Ga0
 QQkJmwrQpJ9ROSUoXBJX9uE2OaJeWjQbe4RjM20BMC8npKUbt0H5Mryv/yw3/BkD5J1Q
 67GU24lS5c9a1c6hqKOKBmasT7oL2f4tRcVJLaeuGaoasj4atf96GPMxe2jauZrBZOBK
 V+QQ==
X-Gm-Message-State: AOAM532tB9c5E2y2+3vOF21hRS+nCg9B4rBZh5CdediMxxMCTd48Eqn8
 G6vU3jda16vqcwHrQlm5UOCEEBBej+42
X-Google-Smtp-Source: ABdhPJz7Stco5O4WRJcJOWee+TYY1OyxYEHxh5Gszj92Xn7xpZ+r+S55XXaa2Tso8A7V93Qrha+yjd75ByH2
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:903:1243:b029:107:eca4:d5bf with SMTP
 id u3-20020a1709031243b0290107eca4d5bfmr3528610plh.15.1628889156661; Fri, 13
 Aug 2021 14:12:36 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:05 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-5-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 04/10] KVM: arm64: selftests: Add basic support for arch_timers
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

Add a minimalistic library support to access the virtual timers,
that can be used for simple timing functionalities, such as
introducing delays in the guest.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/include/aarch64/arch_timer.h          | 138 ++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
new file mode 100644
index 000000000000..e6144ab95348
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) specific defines
+ */
+
+#ifndef SELFTEST_KVM_ARCH_TIMER_H
+#define SELFTEST_KVM_ARCH_TIMER_H
+
+#include <linux/sizes.h>
+
+#include "processor.h"
+
+enum arch_timer {
+	VIRTUAL,
+	PHYSICAL,
+};
+
+#define CTL_ENABLE	(1 << 0)
+#define CTL_ISTATUS	(1 << 2)
+#define CTL_IMASK	(1 << 1)
+
+#define msec_to_cycles(msec)	\
+	(timer_get_cntfrq() * (uint64_t)(msec) / 1000)
+
+#define usec_to_cycles(usec)	\
+	(timer_get_cntfrq() * (uint64_t)(usec) / 1000000)
+
+#define cycles_to_usec(cycles) \
+	((uint64_t)(cycles) * 1000000 / timer_get_cntfrq())
+
+static inline uint32_t timer_get_cntfrq(void)
+{
+	return read_sysreg(cntfrq_el0);
+}
+
+static inline uint64_t timer_get_cntct(enum arch_timer timer)
+{
+	isb();
+
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntvct_el0);
+	case PHYSICAL:
+		return read_sysreg(cntpct_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
+static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return write_sysreg(cntv_cval_el0, cval);
+	case PHYSICAL:
+		return write_sysreg(cntp_cval_el0, cval);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	isb();
+}
+
+static inline uint64_t timer_get_cval(enum arch_timer timer)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntv_cval_el0);
+	case PHYSICAL:
+		return read_sysreg(cntp_cval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
+static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return write_sysreg(cntv_tval_el0, tval);
+	case PHYSICAL:
+		return write_sysreg(cntp_tval_el0, tval);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	isb();
+}
+
+static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return write_sysreg(cntv_ctl_el0, ctl);
+	case PHYSICAL:
+		return write_sysreg(cntp_ctl_el0, ctl);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	isb();
+}
+
+static inline uint32_t timer_get_ctl(enum arch_timer timer)
+{
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntv_ctl_el0);
+	case PHYSICAL:
+		return read_sysreg(cntp_ctl_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
+static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
+{
+	uint64_t now_ct = timer_get_cntct(timer);
+	uint64_t next_ct = now_ct + msec_to_cycles(msec);
+
+	timer_set_cval(timer, next_ct);
+}
+
+static inline void timer_set_next_tval_ms(enum arch_timer timer, uint32_t msec)
+{
+	timer_set_tval(timer, msec_to_cycles(msec));
+}
+
+#endif /* SELFTEST_KVM_ARCH_TIMER_H */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
