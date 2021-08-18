Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77487C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28B15610A5
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 28B15610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3ABC4A1AF;
	Wed, 18 Aug 2021 16:00:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CqT281Fb3BCX; Wed, 18 Aug 2021 16:00:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6041A4B0FC;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 183D5400D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LC-23Rl7yjJb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:26 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 246A7407EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:26 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 h186-20020a37b7c30000b02903b914d9e335so2394998qkf.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0Y0O8/jMTi8+MKBw8+SC9CkFDxQTH0x1K+F2lorBjNw=;
 b=U4fCLEUOOczPm8ogE1eilqE2IX/q5dZYpTUaPZ7In9Xogc9Is2YYJ4PdA5z5akOnRb
 zbnCmhl/HcZiIWVFvBIxyxxxWDZwfM/6rVRUQbVjmR0xu4pEvT0dEiDNpHqpVKRUlGSg
 PrFH48Vl3R6SocBK9oc3ILkAflN3crptqFzwjm4iUdBsl8VZ7NgJfjxxzHZLEhZ1oZIb
 jCtqNb38XKIM7qCfGQh1ZXTf+UqyRJY/NYgCWUu8I9lHeBt8/9iAkp5OIkPk6FaOfAwk
 cvm2eEiSk3GiQf/6uwc3lmoxtOIXSFNluzN0FdPD8706siUbSTwTmZb8Ww1BYCvnptzP
 pLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0Y0O8/jMTi8+MKBw8+SC9CkFDxQTH0x1K+F2lorBjNw=;
 b=kx8E0eQ058VoiNIn5thXDUM8VKGZgw7Be09Uk4Q4j/e5gFimXbKCpWbZOnZijEx1ja
 STWNqpfrsJ4ND/7Ol2ggQ0hHOnzMp5my/X9nKkKR1NgcCPkT3OatXA5n++9OGNyvt0Xt
 nCbx4C798wBRDuD2hJ3oUQcUyM45a+sgr/u7cikpqbcflJXQIKOB2/FWgRrt3Ll3nG/I
 +CaJ+bFMTua9WYPv3PLMak59ubHf7odKJ+qLbVpc0fd8g88o9t3SLNddJb3ARGFSLVG6
 rfsQCWnRHdObe/p4MmJf6I63Mjt0X6ve0osjtBd1/8uOL8VIP5j9vA06WBA7I008IrWk
 jdkg==
X-Gm-Message-State: AOAM530S6HKn+hE4FJx2yDJ1w7uJJ50LM0wWrttwfH1AehDfXwNlwOYj
 RprfPySrL0f9TRNtEL4O5NDRzSj8oY4L
X-Google-Smtp-Source: ABdhPJzQWgpNp1Calgoj+b5RrQwbZcpvRpTehG5RJ6gjpdwYc8hrymlLG30VoJ0I1EDe0HQTY+K2VPCWx3ze
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:d8a:: with SMTP id
 e10mr10482331qve.22.1629312205652; Wed, 18 Aug 2021 11:43:25 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:05 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-5-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 04/10] KVM: arm64: selftests: Add basic support for
 arch_timers
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

Add a minimalistic library support to access the virtual timers,
that can be used for simple timing functionalities, such as
introducing delays in the guest.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/include/aarch64/arch_timer.h          | 142 ++++++++++++++++++
 1 file changed, 142 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
new file mode 100644
index 000000000000..9df5b63abc47
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Timer specific interface
+ */
+
+#ifndef SELFTEST_KVM_ARCH_TIMER_H
+#define SELFTEST_KVM_ARCH_TIMER_H
+
+#include "processor.h"
+
+enum arch_timer {
+	VIRTUAL,
+	PHYSICAL,
+};
+
+#define CTL_ENABLE	(1 << 0)
+#define CTL_IMASK	(1 << 1)
+#define CTL_ISTATUS	(1 << 2)
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
+		write_sysreg(cntv_cval_el0, cval);
+		break;
+	case PHYSICAL:
+		write_sysreg(cntp_cval_el0, cval);
+		break;
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
+		write_sysreg(cntv_tval_el0, tval);
+		break;
+	case PHYSICAL:
+		write_sysreg(cntp_tval_el0, tval);
+		break;
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
+		write_sysreg(cntv_ctl_el0, ctl);
+		break;
+	case PHYSICAL:
+		write_sysreg(cntp_ctl_el0, ctl);
+		break;
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
