Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6629EC43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9554BE01;
	Fri, 15 Jul 2022 02:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4IluhPRuCfg6; Fri, 15 Jul 2022 02:11:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCF504BE08;
	Fri, 15 Jul 2022 02:11:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1F54BDF1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8TGwLEo-tvQW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:44 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA3F54BE01
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:44 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31ce88f9ab8so33605317b3.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=I1SuK+mlx4+9ePe7Z4q/Ds8UD0oS6ojhAZGxfH2qnag=;
 b=JdLDNIjxjl26urcQRjobE7lTFwccfK46WtRp+G7+hkl3xjEvwMw68U/MYBXubciMxG
 BUImcs+xTk3eLMzI43bui6vTXiNnZu8GyF+VhTxsBvMu84qLdmtpNmydEJC1khQOQ50Z
 iSxrEYA8fXN/craiygC6fAoFdYfU1OKsRY4QkJxHDjnzj3AKTL1loj3883Xiz45eqNE8
 NzpjLCCYzvSug/99Xx/FJEKg7xSZx78LuAbSVSyhjyyMngJSswROraDCbOLtuRtJsQPS
 5wF5vbQpcK4Ay7pfQPwg7dQgjrZm2O+7wGs5DLCMznbnRwd0oZO0Z5vhLoDnd0cxM7iy
 pjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=I1SuK+mlx4+9ePe7Z4q/Ds8UD0oS6ojhAZGxfH2qnag=;
 b=Hug9g6BbE3UtXqhj1rt7szP4f1zUU8YJ1gQzByc+0T91YaY/B+PCeNisB4xawAXDCN
 37yi/cEBSV0ogEuDMrUdXSvNBjnjdBDXKXrJnz9hdrpPXmYooqVjWlTbVTvFXuNKayuO
 2mBlqeiIwOxqY9dmy4WZQ3scJ/j3GmSL5xX4U2ErMG71gz1eMiZjymcdHuNKiq548kj3
 1DXNT6JOyT9V6UD2Fx7h4iX9Hqgji4oHlyfewRJwTZ7Kg1EVF+CDDC5gqUiHXXLLF2Ex
 LjU77idaZk1s+LGh0Qn6gwTQru4HYU8YkU6XFrskwllGJmJlB7eFW17yfmdx48a0MR8K
 RGSw==
X-Gm-Message-State: AJIora/I0z9zUJIj4Ljgc75aia9JFFGhXuKi58X6d2EfMo93sQHTN6co
 e1e9ds+KA53FBBtqZ3G/1CGr2YMDrYhohUv48w==
X-Google-Smtp-Source: AGRyM1vfpvfXbao8rDt6oOq5i85WSVodppQ11DSfR0dlAxIEEuKVDbQoAxSVRuw8vhTAwf/zAn7NyXoNXMOZ7LmHhA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:1c04:0:b0:660:1ffc:fb9 with SMTP
 id c4-20020a251c04000000b006601ffc0fb9mr12710440ybc.431.1657865504408; Thu,
 14 Jul 2022 23:11:44 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:25 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-17-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 16/18] KVM: arm64: Introduce pkvm_dump_backtrace()
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Dumps the pKVM hypervisor backtrace from EL1 by reading the unwinded
addresses from the shared stacktrace buffer.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index c3f94b10f8f0..ec1a4ee21c21 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -190,5 +190,54 @@ static int notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
+
+/**
+ * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * Dumping of the pKVM HYP backtrace is done by reading the
+ * stack addresses from the shared stacktrace buffer, since the
+ * host cannot direclty access hyperviosr memory in protected
+ * mode.
+ */
+static inline void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	unsigned long *stacktrace_pos;
+	unsigned long va_mask, pc;
+
+	stacktrace_pos = (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
+	va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+
+	kvm_err("Protected nVHE HYP call trace:\n");
+
+	/* The stack trace is terminated by a null entry */
+	for (; *stacktrace_pos; stacktrace_pos++) {
+		/* Mask tags and convert to kern addr */
+		pc = (*stacktrace_pos & va_mask) + hyp_offset;
+		kvm_err(" [<%016lx>] %pB\n", pc, (void *)pc);
+	}
+
+	kvm_err("---- End of Protected nVHE HYP call trace ----\n");
+}
+#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static inline void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
+}
+#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
+/**
+ * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ */
+static inline void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
+{
+	if (is_protected_kvm_enabled())
+		pkvm_dump_backtrace(hyp_offset);
+}
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
 #endif	/* __ASM_STACKTRACE_NVHE_H */
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
