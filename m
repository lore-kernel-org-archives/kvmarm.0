Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FDAC4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09B996104F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 09B996104F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B07EA49E93;
	Wed,  4 Aug 2021 04:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TeXZYy+73llO; Wed,  4 Aug 2021 04:58:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 028DB4A3A5;
	Wed,  4 Aug 2021 04:58:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 405C340825
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XwnNh21mR-bd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:43 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B62D940C88
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:41 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 n192-20020a25dac90000b029054c59edf217so2275970ybf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QZYUzbcXutG2B1XPKYDDaowrOTkrdRCYpxjQmfgRBqw=;
 b=fg8ZdJyTO1IzZwQnyFmtQzBLyvzLg3oWs5Mwrvzrq7RU1rdysfWLN2A/CA6201R02a
 9x/yYSHRuUETBU088OpH41tdmTezHXghlym7jalL4hNQj9khOjSNah3nmR20olJYlpGM
 NL9UDv3ftB1FzNYvmaswYPXp0iJ0GOb9T8RcGftr9OzVhNA3piITvnnmbrvRoEKYaUs3
 TAbiN9VHBzEih5yBmaD0TSgq4w33jIlobvj6FE10tdMiUbNXovPf3cPu5j0dQjIYAP24
 xcRWGMUyhFLsg7YJPN15v+gKZLMR1hpOHVLDuC1OOWN4vglBYkL+5BSD3FbMNsMZGkwn
 KpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QZYUzbcXutG2B1XPKYDDaowrOTkrdRCYpxjQmfgRBqw=;
 b=LMx9IOxsC4eORHQW2aXPy7Yl55VrKknp7roShX2EglLrnOQiGS2ADwm0OE/+6kXqb6
 aAykVcbOIKZdo6roSsuhA+fv1oD2bZpRrjvvk98Hz5YVjVKEWQWgWsLtRfccFXbgz6t0
 MYgPOEit4ZOHAvUodOaSi/Hm9WTxOjJRHGwBPdb5DxflL8tT4QX2bnroTJMoblMMHkZ1
 pzfbl39LDygXxjhS9d+ZPkaoK9sl0awmgDoyxXxYERVMSDMbrgKfnDW6Lagmp35ca2j5
 Dll8ymstIsyYf+GyZ3/6jf8Jr/Se6MCmZkGHYoE4NiUrRHgLMGOyA6RW09ezp4boxoZ8
 WSqQ==
X-Gm-Message-State: AOAM533QnXbOL6U4mdKs49YK4sqrV8Rhha++QxeIABPu02a+TkJQbMiT
 VXe13u62yfPk3BshAuTkpjEBNdfIfHQ=
X-Google-Smtp-Source: ABdhPJxV6+3gLGbTheDt4LD8pHoTTfHfR6GcLwPPsqBvh7B9FGBWOPkR9xVf9DHE0p02LBy+6d+tyicSFeI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:4283:: with SMTP id
 p125mr35878914yba.184.1628067521137; 
 Wed, 04 Aug 2021 01:58:41 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:04 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-7-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 06/21] tools: arch: x86: pull in pvclock headers
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Copy over approximately clean versions of the pvclock headers into
tools. Reconcile headers/symbols missing in tools that are unneeded.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/arch/x86/include/asm/pvclock-abi.h |  48 +++++++++++
 tools/arch/x86/include/asm/pvclock.h     | 103 +++++++++++++++++++++++
 2 files changed, 151 insertions(+)
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h

diff --git a/tools/arch/x86/include/asm/pvclock-abi.h b/tools/arch/x86/include/asm/pvclock-abi.h
new file mode 100644
index 000000000000..1436226efe3e
--- /dev/null
+++ b/tools/arch/x86/include/asm/pvclock-abi.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PVCLOCK_ABI_H
+#define _ASM_X86_PVCLOCK_ABI_H
+#ifndef __ASSEMBLY__
+
+/*
+ * These structs MUST NOT be changed.
+ * They are the ABI between hypervisor and guest OS.
+ * Both Xen and KVM are using this.
+ *
+ * pvclock_vcpu_time_info holds the system time and the tsc timestamp
+ * of the last update. So the guest can use the tsc delta to get a
+ * more precise system time.  There is one per virtual cpu.
+ *
+ * pvclock_wall_clock references the point in time when the system
+ * time was zero (usually boot time), thus the guest calculates the
+ * current wall clock by adding the system time.
+ *
+ * Protocol for the "version" fields is: hypervisor raises it (making
+ * it uneven) before it starts updating the fields and raises it again
+ * (making it even) when it is done.  Thus the guest can make sure the
+ * time values it got are consistent by checking the version before
+ * and after reading them.
+ */
+
+struct pvclock_vcpu_time_info {
+	u32   version;
+	u32   pad0;
+	u64   tsc_timestamp;
+	u64   system_time;
+	u32   tsc_to_system_mul;
+	s8    tsc_shift;
+	u8    flags;
+	u8    pad[2];
+} __attribute__((__packed__)); /* 32 bytes */
+
+struct pvclock_wall_clock {
+	u32   version;
+	u32   sec;
+	u32   nsec;
+} __attribute__((__packed__));
+
+#define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
+#define PVCLOCK_GUEST_STOPPED	(1 << 1)
+/* PVCLOCK_COUNTS_FROM_ZERO broke ABI and can't be used anymore. */
+#define PVCLOCK_COUNTS_FROM_ZERO (1 << 2)
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_X86_PVCLOCK_ABI_H */
diff --git a/tools/arch/x86/include/asm/pvclock.h b/tools/arch/x86/include/asm/pvclock.h
new file mode 100644
index 000000000000..2628f9a6330b
--- /dev/null
+++ b/tools/arch/x86/include/asm/pvclock.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PVCLOCK_H
+#define _ASM_X86_PVCLOCK_H
+
+#include <asm/barrier.h>
+#include <asm/pvclock-abi.h>
+
+/* some helper functions for xen and kvm pv clock sources */
+u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
+u8 pvclock_read_flags(struct pvclock_vcpu_time_info *src);
+void pvclock_set_flags(u8 flags);
+unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
+void pvclock_resume(void);
+
+void pvclock_touch_watchdogs(void);
+
+static __always_inline
+unsigned pvclock_read_begin(const struct pvclock_vcpu_time_info *src)
+{
+	unsigned version = src->version & ~1;
+	/* Make sure that the version is read before the data. */
+	rmb();
+	return version;
+}
+
+static __always_inline
+bool pvclock_read_retry(const struct pvclock_vcpu_time_info *src,
+			unsigned version)
+{
+	/* Make sure that the version is re-read after the data. */
+	rmb();
+	return version != src->version;
+}
+
+/*
+ * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
+ * yielding a 64-bit result.
+ */
+static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
+{
+	u64 product;
+#ifdef __i386__
+	u32 tmp1, tmp2;
+#else
+	unsigned long tmp;
+#endif
+
+	if (shift < 0)
+		delta >>= -shift;
+	else
+		delta <<= shift;
+
+#ifdef __i386__
+	__asm__ (
+		"mul  %5       ; "
+		"mov  %4,%%eax ; "
+		"mov  %%edx,%4 ; "
+		"mul  %5       ; "
+		"xor  %5,%5    ; "
+		"add  %4,%%eax ; "
+		"adc  %5,%%edx ; "
+		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
+		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
+#elif defined(__x86_64__)
+	__asm__ (
+		"mulq %[mul_frac] ; shrd $32, %[hi], %[lo]"
+		: [lo]"=a"(product),
+		  [hi]"=d"(tmp)
+		: "0"(delta),
+		  [mul_frac]"rm"((u64)mul_frac));
+#else
+#error implement me!
+#endif
+
+	return product;
+}
+
+static __always_inline
+u64 __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src, u64 tsc)
+{
+	u64 delta = tsc - src->tsc_timestamp;
+	u64 offset = pvclock_scale_delta(delta, src->tsc_to_system_mul,
+					     src->tsc_shift);
+	return src->system_time + offset;
+}
+
+struct pvclock_vsyscall_time_info {
+	struct pvclock_vcpu_time_info pvti;
+} __attribute__((__aligned__(64)));
+
+#define PVTI_SIZE sizeof(struct pvclock_vsyscall_time_info)
+
+#ifdef CONFIG_PARAVIRT_CLOCK
+void pvclock_set_pvti_cpu0_va(struct pvclock_vsyscall_time_info *pvti);
+struct pvclock_vsyscall_time_info *pvclock_get_pvti_cpu0_va(void);
+#else
+static inline struct pvclock_vsyscall_time_info *pvclock_get_pvti_cpu0_va(void)
+{
+	return NULL;
+}
+#endif
+
+#endif /* _ASM_X86_PVCLOCK_H */
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
