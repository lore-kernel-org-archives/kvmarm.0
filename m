Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2250C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:49:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9188160FD8
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9188160FD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 492EC4B116;
	Fri, 27 Aug 2021 03:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t-+BRWPgyX5l; Fri, 27 Aug 2021 03:49:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA024B171;
	Fri, 27 Aug 2021 03:49:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 630774B0C9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oFq6mgE8FVew for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 20:57:41 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4821C4B110
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 20:57:41 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 d78-20020a256851000000b00598b2a660e2so4906970ybc.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 17:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=/GNsXDXGxvkLYn64hGgFQXgQU/jMUClIrsjFgTViz1Y=;
 b=tRvkfbrGw8+v7Lr3XLUmzwVcxzAbAizvlsAktjoSUGPxvViNrp9xpwsT+0jULLS0XQ
 QBNR07zqN8UHtCl5MQ4ti3SFRSDkyOQMWk/4FAKgjY0ERaJLZ7e6gc8JstfsQpjdP8pN
 v4l1BG+uDjmM2Bi4xrpkbB1gpGDLl7c4sM4zXvgYmcAkI8bj70Vi0WRIULATvW29c86P
 +1i26kA7dY0yY0Q112IpUA7udaIzNtFpo5eE00IcdfbT6SvKww5RR5G9/2iwQ3ltt6VI
 10Wa1Y40Ho9VSOkSxhKZNCOowxojF7K8qtaH4uV/l7mvCI3KuGMrLb1Qg33vy3GnobZv
 +KeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=/GNsXDXGxvkLYn64hGgFQXgQU/jMUClIrsjFgTViz1Y=;
 b=p2n+0c6CsTEAdk8h8FiJtpPOZPam6e57E197CeE5+ar0VWE/16NhI4UBS29KZt2sx9
 R+0e1XDqi4MuDi7MXaR3T5J719Xvs+hJgiuMYZNXSswB7Pbsd9Hi8DA+wNcBfCC97MXr
 /pf7y1GqexoELPH4I9MU2UgVANMh8TgOVfUtXGV6MKV1+9HuZvELhEz+wE4bGTbncE3T
 SbvzOtbSNS0V6vzp1RCBvdW42JNduQ7KSuloRZ9fLv04wm2etzTHQ2zudE1NLDvVXinh
 t34pzNgm4ym1j/121GR+WDCHFtuQVQs3W9WUE9DT9tfLja+/282LR7T84RiV21VJUFZ1
 tg/A==
X-Gm-Message-State: AOAM532e3XqhwJkdkdfXVnAOI34mCKnWlOkOg9Oaqj4CDoF1kOM+Atae
 ML6iE+LKGOmOOeb7FRAq2i9Apdy4XMU=
X-Google-Smtp-Source: ABdhPJwlJCzwV2czahQdIDDwZpv3WILOdy4N6W1GAOIZtI0/OVUnTHcgIFdLrF39Vy4IljF0G9kSbF2BA3s=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:d989:: with SMTP id
 q131mr1776832ybg.500.1630025860851; 
 Thu, 26 Aug 2021 17:57:40 -0700 (PDT)
Date: Thu, 26 Aug 2021 17:57:08 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 05/15] perf: Track guest callbacks on a per-CPU basis
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>, 
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Thomas Gleixner <tglx@linutronix.de>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Fri, 27 Aug 2021 03:49:31 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org, xen-devel@lists.xenproject.org,
 Zhu Lingshan <lingshan.zhu@intel.com>, Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Sean Christopherson <seanjc@google.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Use a per-CPU pointer to track perf's guest callbacks so that KVM can set
the callbacks more precisely and avoid a lurking NULL pointer dereference.
On x86, KVM supports being built as a module and thus can be unloaded.
And because the shared callbacks are referenced from IRQ/NMI context,
unloading KVM can run concurrently with perf, and thus all of perf's
checks for a NULL perf_guest_cbs are flawed as perf_guest_cbs could be
nullified between the check and dereference.

In practice, this has not been problematic because the callbacks are
always guarded with a "perf_guest_cbs && perf_guest_cbs->is_in_guest()"
pattern, and it's extremely unlikely the compiler will choost to reload
perf_guest_cbs in that particular sequence.  Because is_in_guest() is
obviously true only when KVM is running a guest, perf always wins the
race to the guarded code (which does often reload perf_guest_cbs) as KVM
has to stop running all guests and do a heavy teardown before unloading.

Cc: Zhu Lingshan <lingshan.zhu@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kernel/perf_callchain.c | 18 ++++++++++++------
 arch/x86/events/core.c             | 17 +++++++++++------
 arch/x86/events/intel/core.c       |  8 +++++---
 include/linux/perf_event.h         |  2 +-
 kernel/events/core.c               | 12 +++++++++---
 5 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 4a72c2727309..38555275c6a2 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -102,7 +102,9 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+
+	if (guest_cbs && guest_cbs->is_in_guest()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -147,9 +149,10 @@ static bool callchain_trace(void *data, unsigned long pc)
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
 	struct stackframe frame;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->is_in_guest()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -160,18 +163,21 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		return perf_guest_cbs->get_guest_ip();
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+
+	if (guest_cbs && guest_cbs->is_in_guest())
+		return guest_cbs->get_guest_ip();
 
 	return instruction_pointer(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
 	int misc = 0;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		if (perf_guest_cbs->is_user_mode())
+	if (guest_cbs && guest_cbs->is_in_guest()) {
+		if (guest_cbs->is_user_mode())
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 1eb45139fcc6..34155a52e498 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2761,10 +2761,11 @@ static bool perf_hw_regs(struct pt_regs *regs)
 void
 perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2864,10 +2865,11 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
 void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (guest_cbs && guest_cbs->is_in_guest()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2944,18 +2946,21 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		return perf_guest_cbs->get_guest_ip();
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+
+	if (guest_cbs && guest_cbs->is_in_guest())
+		return guest_cbs->get_guest_ip();
 
 	return regs->ip + code_segment_base(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
 	int misc = 0;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		if (perf_guest_cbs->is_user_mode())
+	if (guest_cbs && guest_cbs->is_in_guest()) {
+		if (guest_cbs->is_user_mode())
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index fca7a6e2242f..96001962c24d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2784,6 +2784,7 @@ static void intel_pmu_reset(void)
 
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
+	struct perf_guest_info_callbacks *guest_cbs;
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int bit;
@@ -2852,9 +2853,10 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
-			perf_guest_cbs->handle_intel_pt_intr))
-			perf_guest_cbs->handle_intel_pt_intr();
+		guest_cbs = this_cpu_read(perf_guest_cbs);
+		if (unlikely(guest_cbs && guest_cbs->is_in_guest() &&
+			     guest_cbs->handle_intel_pt_intr))
+			guest_cbs->handle_intel_pt_intr();
 		else
 			intel_pt_interrupt();
 	}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5eab690622ca..c98253dae037 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1237,7 +1237,7 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 				 u16 flags);
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
-extern struct perf_guest_info_callbacks *perf_guest_cbs;
+DECLARE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern void perf_unregister_guest_info_callbacks(void);
 #endif /* CONFIG_HAVE_GUEST_PERF_EVENTS */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9820df7ee455..9bc1375d6ed9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6483,17 +6483,23 @@ static void perf_pending_event(struct irq_work *entry)
 }
 
 #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
-struct perf_guest_info_callbacks *perf_guest_cbs;
+DEFINE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
-	perf_guest_cbs = cbs;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(perf_guest_cbs, cpu) = cbs;
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
 
 void perf_unregister_guest_info_callbacks(void)
 {
-	perf_guest_cbs = NULL;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(perf_guest_cbs, cpu) = NULL;
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 #endif
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
