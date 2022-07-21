Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0FFCCA479
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11DD04DA7A;
	Thu, 21 Jul 2022 01:58:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h28WMJDHvgPT; Thu, 21 Jul 2022 01:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405924DA8C;
	Thu, 21 Jul 2022 01:58:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13AD54DA66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wmv1BHeAwmtb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:13 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1D724DA81
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:13 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 u15-20020a25ab0f000000b0066e49f6c461so597116ybi.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=POF5DiWqY8exBmivz0rKj4swn88HJpD6BS/y4rmGEUs=;
 b=iNF3/wKiZxQkHHbeWmrDPvF2lTugngVT8l6YAy7ij5cPY90sHRbAuAte+7t0gXkHM8
 Nn10K9x+jyiPRlfMiH8Kme8pJx4iK86w/tvNiOBAB1RJwhX9HgF7aG5TgxWlxjs/+aC8
 JmrWVdRF1+4cai70BJHNbLhfq+tLYGoZ6LLzkBFW+Nr9qdq5HvnnSMO3BS2WFS59TMNg
 LZGWa/1Ri7/0xL/cgFTo4eKFiFrQxY3DxKk8iLGThqSBtt9m+qrvIc1e+4lqd4jVScfj
 zAqxL3KDqT2/e+X/RiSP6BCUWHdY0bJGvcENptvBCIFJV6C4TR6EHm0MT+/+Kbjg1Kil
 auXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=POF5DiWqY8exBmivz0rKj4swn88HJpD6BS/y4rmGEUs=;
 b=Jk6yXIraOumbKqpQtTc2eeVtrZbwPhknDVPOIJUCXCuwu5eRpF0JVgeMPXidvh3oNv
 5zJ+f/YIFcnykVwXdnDI+vOpobkN38KhmaZcyEC9nmMs6WE9VkZyDyQ+6Qd3fCCywxuj
 uCx3yXwg+7cPGHRIWA0Y4VEiIPApgLLvdemEt+T0rNpzfeXfuL0aHPjf0viPvTvj+M3r
 kh1qDtR7KDVYvfvbqKMQOcMfWVH4C0I+iBvfI1rhPXSqBnkrrB5jWYiwl+lF/ThSi7td
 2Qo34vAhR1681yymo9HrPnoFtSDF/YPPe9hApZETa1F/ovPIULUghxU+3rGpg4X7YMOm
 /S8A==
X-Gm-Message-State: AJIora9DzBjq+UgMhjKm4wgmT4ZL/xvLBnZwBRyEYftgA4X53ISwmeZG
 ewIKYMAvxflkGiXN9j6hjiYM3BBj8xOjnlCC0Q==
X-Google-Smtp-Source: AGRyM1s1aoVE6pG6u4uUcd7EnheOT1wFEk50XabWGsXZv3DmsYR0UuXWQPe2QHeoCAY/ooJghIm8SbcDhywackPmqQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d614:0:b0:670:9ea2:e6c1 with SMTP
 id n20-20020a25d614000000b006709ea2e6c1mr4776973ybg.379.1658383093469; Wed,
 20 Jul 2022 22:58:13 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:27 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-17-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 16/17] KVM: arm64: Introduce pkvm_dump_backtrace()
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

The nVHE hyp backtrace is dumped on hyp_panic(), before panicking the
host.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Move code out from nvhe.h header to handle_exit.c, per Marc
  - Fix stacktrace symoblization when CONFIG_RAMDOMIZE_BASE is enabled,
    per Fuad
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/kvm/handle_exit.c | 54 ++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index f66c0142b335..ad568da5c7d7 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -318,6 +318,57 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
+			 pkvm_stacktrace);
+
+/*
+ * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * Dumping of the pKVM HYP backtrace is done by reading the
+ * stack addresses from the shared stacktrace buffer, since the
+ * host cannot direclty access hyperviosr memory in protected
+ * mode.
+ */
+static void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	unsigned long *stacktrace_entry
+		= (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
+	unsigned long va_mask, pc;
+
+	va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+
+	kvm_err("Protected nVHE HYP call trace:\n");
+
+	/* The stack trace is terminated by a null entry */
+	for (; *stacktrace_entry; stacktrace_entry++) {
+		/* Mask tags and convert to kern addr */
+		pc = (*stacktrace_entry & va_mask) + hyp_offset;
+		kvm_err(" [<%016lx>] %pB\n", pc, (void *)(pc + kaslr_offset()));
+	}
+
+	kvm_err("---- End of Protected nVHE HYP call trace ----\n");
+}
+#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static void pkvm_dump_backtrace(unsigned long hyp_offset)
+{
+	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
+}
+#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
+/*
+ * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ */
+static void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
+{
+	if (is_protected_kvm_enabled())
+		pkvm_dump_backtrace(hyp_offset);
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -353,6 +404,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 				(void *)panic_addr);
 	}
 
+	/* Dump the nVHE hypervisor backtrace */
+	kvm_nvhe_dump_backtrace(hyp_offset);
+
 	/*
 	 * Hyp has panicked and we're going to handle that by panicking the
 	 * kernel. The kernel offset will be revealed in the panic so we're
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
