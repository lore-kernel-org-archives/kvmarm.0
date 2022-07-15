Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A479DCCA480
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51DC84BBA4;
	Fri, 15 Jul 2022 02:11:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id znpdjCYXSs38; Fri, 15 Jul 2022 02:11:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 077C94BDDF;
	Fri, 15 Jul 2022 02:11:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 812BB4BBA9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E5a-ad4XZt3h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:47 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C3D74BE07
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:47 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31c858e18c8so33531907b3.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pCrsAtrXdQrqKS3eeA8f9GflhdYZQyxHWES6iqq1HQQ=;
 b=jI4zAPvvQ77ZuvgrkrRIHZRkBl0VSF8QUgVCY/1ZnqdCg0pQyYf0UuEwHeiROiTaAy
 FSHAtwwXH951A9lpReSW3weDPL7qdYwHOOctZaeKlz/8zfmGCk6fRs1Evv5wtDjJbTBx
 cksIRahdwMwL9F3qJGyjQ997TNOhcHp+H114RtKstCa99riB9yoL6l7Y4CeCyWMV/92L
 JuWSurazgujBJNjwdTmMGq62lprxYhEAOKVMr/bVOZY31Ft4VD0s5Xyn5gfq130hJGt6
 vwzQ9VHOvkWYELkKQ1Ph3gdjt7xURPyOBYcL0IdT2MaGg5DiSqXxP2wCEE8xSsVaHn7d
 DJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pCrsAtrXdQrqKS3eeA8f9GflhdYZQyxHWES6iqq1HQQ=;
 b=TlS9NOeLbUx6ikKH8lWIqRJRYS6sWh60zOHniVly9AcT45V+7s4z6OLX2WPqZGRGeK
 e/GUDJVolcJt3ZveaUMwyCCtps2Znxbek3eC1ccCWu7zy21+xaLS1hRkJLJSZCALHHcz
 sYHl6KEhEYWHUUlBsO1xdMThItyAms5DHQbv3FnFGKXYhvJ41ha/7KB4eD7TvbI3TRDl
 wAhkN5SEtC2NazRBzywlSf2j1GDQ2I5CKJVd4em0kY3v+OT/1SeohPr5kgt957PBcAzb
 XMCdhex+ePYFkgIV/DzsRWtVFXLHGmc7BVYx6rQfVhM7LouPXHOz/3GjvGM/PszZ9t9a
 8EEQ==
X-Gm-Message-State: AJIora8VMQ1WNsh9rgTWOSXtwSQ+K8ujoEL6wRAOv6fbyQhjZJv/v2AE
 snIkkqpE6PdhKAFlGzeUva8JN05DSL3ZTvAi0Q==
X-Google-Smtp-Source: AGRyM1tEqC2CS+wqI7vtsUSjZ6J4A5D2uthRIAUasSZuLlJSGC81kXJwJZFzwd7qYeFr+qoAbrl5Z8/6YFdrJhWx1A==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:503:0:b0:317:c5d5:16fe with SMTP
 id 3-20020a810503000000b00317c5d516femr13830160ywf.231.1657865506980; Thu, 14
 Jul 2022 23:11:46 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:26 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-18-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 17/18] KVM: arm64: Introduce hyp_dump_backtrace()
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

In non-protected nVHE mode, unwinds and dumps the hypervisor backtrace
from EL1. This is possible beacuase the host can directly access the
hypervisor stack pages in non-proteced mode.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 64 +++++++++++++++++++++---
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index ec1a4ee21c21..c322ac95b256 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -190,6 +190,56 @@ static int notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
+/**
+ * kvm_nvhe_print_backtrace_entry - Symbolizes and prints the HYP stack address
+ */
+static inline void kvm_nvhe_print_backtrace_entry(unsigned long addr,
+						  unsigned long hyp_offset)
+{
+	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+
+	/* Mask tags and convert to kern addr */
+	addr = (addr & va_mask) + hyp_offset;
+	kvm_err(" [<%016lx>] %pB\n", addr, (void *)addr);
+}
+
+/**
+ * hyp_backtrace_entry - Dump an entry of the non-protected nVHE HYP stacktrace
+ *
+ * @arg    : the hypervisor offset, used for address translation
+ * @where  : the program counter corresponding to the stack frame
+ */
+static inline bool hyp_dump_backtrace_entry(void *arg, unsigned long where)
+{
+	kvm_nvhe_print_backtrace_entry(where, (unsigned long)arg);
+
+	return true;
+}
+
+/**
+ * hyp_dump_backtrace - Dump the non-proteced nVHE HYP backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * The host can directly access HYP stack pages in non-protected
+ * mode, so the unwinding is done directly from EL1. This removes
+ * the need for shared buffers between host and hypervisor for
+ * the stacktrace.
+ */
+static inline void hyp_dump_backtrace(unsigned long hyp_offset)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info;
+	struct unwind_state state;
+
+	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+
+	kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
+
+	kvm_err("Non-protected nVHE HYP call trace:\n");
+	unwind(&state, hyp_dump_backtrace_entry, (void *)hyp_offset);
+	kvm_err("---- End of Non-protected nVHE HYP call trace ----\n");
+}
+
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
 
@@ -206,22 +256,18 @@ DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm
 static inline void pkvm_dump_backtrace(unsigned long hyp_offset)
 {
 	unsigned long *stacktrace_pos;
-	unsigned long va_mask, pc;
 
 	stacktrace_pos = (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
-	va_mask = GENMASK_ULL(vabits_actual - 1, 0);
 
 	kvm_err("Protected nVHE HYP call trace:\n");
 
-	/* The stack trace is terminated by a null entry */
-	for (; *stacktrace_pos; stacktrace_pos++) {
-		/* Mask tags and convert to kern addr */
-		pc = (*stacktrace_pos & va_mask) + hyp_offset;
-		kvm_err(" [<%016lx>] %pB\n", pc, (void *)pc);
-	}
+	/* The saved stacktrace is terminated by a null entry */
+	for (; *stacktrace_pos; stacktrace_pos++)
+		kvm_nvhe_print_backtrace_entry(*stacktrace_pos, hyp_offset);
 
 	kvm_err("---- End of Protected nVHE HYP call trace ----\n");
 }
+
 #else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
 static inline void pkvm_dump_backtrace(unsigned long hyp_offset)
 {
@@ -238,6 +284,8 @@ static inline void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
 {
 	if (is_protected_kvm_enabled())
 		pkvm_dump_backtrace(hyp_offset);
+	else
+		hyp_dump_backtrace(hyp_offset);
 }
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
 #endif	/* __ASM_STACKTRACE_NVHE_H */
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
