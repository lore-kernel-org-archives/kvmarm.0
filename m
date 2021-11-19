Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E2AC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 12:29:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2682261AD0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 12:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2682261AD0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBE344B17C;
	Fri, 19 Nov 2021 07:29:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y0ECZM7YAvaV; Fri, 19 Nov 2021 07:29:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C8B4B160;
	Fri, 19 Nov 2021 07:29:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E95D4B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:21:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mLuFfybTZ4pF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 05:21:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2954349F5D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 05:21:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637317307;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mX5jcuznSuqa2Xcuiv4jYmRlfngakhSaRM4ITDtNgjs=;
 b=SnPIKWOWW7qPOimXc3cq6JJntsCfvh85N4ntd62/z8rwYvSiMvov5zXK9GN0jVXwcUDfHz
 hbVn5VslzYR8q/KzApmaWBV3cHSHxTOHc/v6RnIAsVKqAhzJvIPH61o5YNPX0TeEyvOiZI
 3oJ27yREnVwXD5TtYdDSDTHswcajZ+Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240--lHXrcCAMPmXnfb0YXttUA-1; Fri, 19 Nov 2021 05:21:45 -0500
X-MC-Unique: -lHXrcCAMPmXnfb0YXttUA-1
Received: by mail-wr1-f72.google.com with SMTP id
 r12-20020adfdc8c000000b0017d703c07c0so1683001wrj.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 02:21:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=mX5jcuznSuqa2Xcuiv4jYmRlfngakhSaRM4ITDtNgjs=;
 b=reecvoSwDwWN46+VUnSIkCAKpa5OsCQeKgn2M+pQl2y4N2HPMWtOe1DHws2LsZqNll
 MOl/OfQkWWpFfYZIihcTjpfcot0D1QCFIAkTPkfucWyYzOCr8nJQKQv7FIWkF1BVNTzW
 +hm6PdJW+CYspozZZPrWZ8ybPJaJEwXarIJLuOLDenK/EJ/fz0ktZDtTxzbhjJTz0H8A
 cl52p0nHLVkYDnWlYqecw6DlV8JrqM/EXpR/Y1sVe9JdB/YrdMvQ1wCRKwl6dLphrGKL
 0wYvu/0K6VHnRjE5NKVUnpnzEiauEd+XHGUqf1Da9QeDpNe/HB1bGxyEf5SNfrdkJ+7t
 oX8A==
X-Gm-Message-State: AOAM533lT3X9tCpSVOvw5cYcWkNeRcUB4j2to5wSg5cWHl8aRzQyC9rr
 7dmrtUs8HHRN3NhUPymeihBweoW9utsnhgl/keM9wNT1Lcmywrn8dKMR5zLx/yJdDyEkuWYX88S
 7lq8vh7Qh2mBeziyB0ERaGpiD
X-Received: by 2002:a5d:4909:: with SMTP id x9mr5932209wrq.313.1637317304296; 
 Fri, 19 Nov 2021 02:21:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxeQnWOxgbNOebQdl80w1DTmX2lRjG3ogVnSnid0ngmyFfrhWmSZI2Hfqqy5HB4Ucb0MKfToQ==
X-Received: by 2002:a5d:4909:: with SMTP id x9mr5932181wrq.313.1637317304102; 
 Fri, 19 Nov 2021 02:21:44 -0800 (PST)
Received: from vian.redhat.com ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
 by smtp.gmail.com with ESMTPSA id k27sm14336026wms.41.2021.11.19.02.21.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 02:21:43 -0800 (PST)
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: linux-arm-kernel@lists.infradead.org, maz@kernel.org, rostedt@goodmis.org
Subject: [RFC PATCH 1/2] arm64/tracing: add cntvct based trace clock
Date: Fri, 19 Nov 2021 11:21:17 +0100
Message-Id: <20211119102117.22304-2-nsaenzju@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119102117.22304-1-nsaenzju@redhat.com>
References: <20211119102117.22304-1-nsaenzju@redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Fri, 19 Nov 2021 07:29:31 -0500
Cc: will@kernel.org, catalin.marinas@arm.com, mtosatti@redhat.com,
 linux-kernel@vger.kernel.org, mingo@redhat.com, nsaenzju@redhat.com,
 nilal@redhat.com, kvmarm@lists.cs.columbia.edu
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

Add a new arm64-specific trace clock using the cntvct register, similar
to x64-tsc. This gives us:
 - A clock that is relatively fast (1GHz on armv8.6, 1-50MHz otherwise),
   monotonic, and resilient to low power modes.
 - It can be used to correlate events across cpus as well as across
   hypervisor and guests.

By using arch_timer_read_counter() we make sure that armv8.6 cpus use
the less expensive CNTVCTSS_EL0, which cannot be accessed speculatively.

Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
---
 arch/arm64/include/asm/trace_clock.h | 12 ++++++++++++
 arch/arm64/kernel/Makefile           |  2 +-
 arch/arm64/kernel/trace_clock.c      | 12 ++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/trace_clock.h
 create mode 100644 arch/arm64/kernel/trace_clock.c

diff --git a/arch/arm64/include/asm/trace_clock.h b/arch/arm64/include/asm/trace_clock.h
new file mode 100644
index 000000000000..ce4a66d63108
--- /dev/null
+++ b/arch/arm64/include/asm/trace_clock.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_TRACE_CLOCK_H
+#define _ASM_ARM64_TRACE_CLOCK_H
+
+#include <linux/types.h>
+
+extern u64 notrace trace_clock_arm64_cntvct(void);
+
+# define ARCH_TRACE_CLOCKS \
+	{ trace_clock_arm64_cntvct, "cntvct", .in_ns = 0 },
+
+#endif  /* _ASM_ARM64_TRACE_CLOCK_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 88b3e2a21408..ec9180f0ac90 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -29,7 +29,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
 			   syscall.o proton-pack.o idreg-override.o idle.o	\
-			   patching.o
+			   patching.o trace_clock.o
 
 targets			+= efi-entry.o
 
diff --git a/arch/arm64/kernel/trace_clock.c b/arch/arm64/kernel/trace_clock.c
new file mode 100644
index 000000000000..fe1315f368cb
--- /dev/null
+++ b/arch/arm64/kernel/trace_clock.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * arm64 trace clocks
+ */
+#include <asm/trace_clock.h>
+
+#include <clocksource/arm_arch_timer.h>
+
+u64 notrace trace_clock_arm64_cntvct(void)
+{
+	return arch_timer_read_counter();
+}
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
