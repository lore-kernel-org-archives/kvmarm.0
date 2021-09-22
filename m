Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2407AC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD0A361178
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CD0A361178
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81A5D4B126;
	Wed, 22 Sep 2021 09:12:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id myo2AsZQhV0G; Wed, 22 Sep 2021 09:12:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABAE34B1B6;
	Wed, 22 Sep 2021 09:11:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79560405EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:06:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GU60UEcnp16p for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 20:05:59 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DB7E405A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:05:59 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 k12-20020a05620a0b8c00b003d5c8646ec2so5332310qkh.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 17:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=sNDCyCpfsN1q6fRIAZGHe8t08fZK9DQU77lycxeDgvE=;
 b=VfPFQTi2H68Pv6JmEb/KQ6WY/Mh3+l2kbL2XaDfVNNRWtfkT0wPW7iSQgW51WR5Ixu
 QaVgL8eDvDPLryj3vrQdNZbcnETMB9dGrhIzgmphuyjNlSU7aoy32NJ7ZHdZp0tssaUn
 WmTaDF7tt5GMvqHs/f51AneClTfDU4/Qx1Y7bh13Y1mJ7NTIjpZczmD07Ifh3YHzj8to
 lJYiaCZYA+JZO1GYoyMeT2BFWYalqIN+pUd4yUi7DujNd/X/ujswoWs0DebayZIqAv/y
 Meqb7X4l8tyF48vYwj84msbYaRs7+6wgTa49v9X0jrHAK7tmUtVCOQiRYMjdbLlI0bf9
 COSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=sNDCyCpfsN1q6fRIAZGHe8t08fZK9DQU77lycxeDgvE=;
 b=wWIYjZeKHWijtEkuzuwCDOlQwkPMVhqQvFgUz+F7ffbTcKp5tpf5d2dqWIj87EBlfT
 ANZ7o8j/0nxIZeq/s6f1+tyMDD+sh1l24gZkmR5l7srZuKrtFgf5W3AeC3I1VJwCIUA/
 oVAWOQ2RmdxDsBcUShY620OwxPqhjKJGrrxRTxn1lCQrUIk2yLtkeBZ9IFgETFsBrjQq
 MsLDVxlUJfgO54N5kjEgHCaf3Hi6tyMynJr8JK/r70vRDWHwqKG7q8GGFv5Wn1X/kfc+
 599csHJkJOEPxKd6AsHJMbC9eNdnlJfnstdM6+SNtR6D8zK90KJKbrLfiMtawKFuSATO
 JlkQ==
X-Gm-Message-State: AOAM532JAaImP8Hcmh3oESLx7t6rScSvAUJSn0o72JFNPFkxTkjGJF1B
 d5Z4J1TxWU1J4iASr8lhEUPk+ZahI2s=
X-Google-Smtp-Source: ABdhPJzkQ+TPTNghaiyjopK2Q9UXHXirkFCk7bz7Y2wHOEucRILtEQweuapuUXRwLMTZlbJ4rzpjCo5gfvs=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a25:1884:: with SMTP id
 126mr25006798yby.114.1632269158936; 
 Tue, 21 Sep 2021 17:05:58 -0700 (PDT)
Date: Tue, 21 Sep 2021 17:05:24 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 07/16] perf: Add wrappers for invoking guest callbacks
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, 
 Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
 Nick Hu <nickhu@andestech.com>, 
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 linux-riscv@lists.infradead.org, Jiri Olsa <jolsa@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Stefano Stabellini <sstabellini@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 xen-devel@lists.xenproject.org, Zhu Lingshan <lingshan.zhu@intel.com>,
 Namhyung Kim <namhyung@kernel.org>,
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

Add helpers for the guest callbacks to prepare for burying the callbacks
behind a Kconfig (it's a lot easier to provide a few stubs than to #ifdef
piles of code), and also to prepare for converting the callbacks to
static_call().  perf_instruction_pointer() in particular will have subtle
semantics with static_call(), as the "no callbacks" case will return 0 if
the callbacks are unregistered between querying guest state and getting
the IP.  Implement the change now to avoid a functional change when adding
static_call() support, and because the new helper needs to return
_something_ in this case.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kernel/perf_callchain.c | 16 +++++-----------
 arch/x86/events/core.c             | 15 +++++----------
 arch/x86/events/intel/core.c       |  5 +----
 include/linux/perf_event.h         | 24 ++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 274dc3e11b6d..db04a55cee7e 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -102,9 +102,7 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -149,10 +147,9 @@ static bool callchain_trace(void *data, unsigned long pc)
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe frame;
 
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -163,18 +160,15 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->state())
-		return guest_cbs->get_ip();
+	if (perf_guest_state())
+		return perf_guest_get_ip();
 
 	return instruction_pointer(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
+	unsigned int guest_state = perf_guest_state();
 	int misc = 0;
 
 	if (guest_state) {
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 3a7630fdd340..d20e4f8d1aef 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2761,11 +2761,10 @@ static bool perf_hw_regs(struct pt_regs *regs)
 void
 perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2865,11 +2864,10 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
 void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2946,18 +2944,15 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->state())
-		return guest_cbs->get_ip();
+	if (perf_guest_state())
+		return perf_guest_get_ip();
 
 	return regs->ip + code_segment_base(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
+	unsigned int guest_state = perf_guest_state();
 	int misc = 0;
 
 	if (guest_state) {
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 524ad1f747bd..f5b02017ba16 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2786,7 +2786,6 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-	struct perf_guest_info_callbacks *guest_cbs;
 	int bit;
 	int handled = 0;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
@@ -2853,9 +2852,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-
-		guest_cbs = perf_get_guest_cbs();
-		if (likely(!guest_cbs || !guest_cbs->handle_intel_pt_intr()))
+		if (!perf_guest_handle_intel_pt_intr())
 			intel_pt_interrupt();
 	}
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f9be88a47434..c0a6eaf55fb1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1247,6 +1247,30 @@ static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
 	/* Prevent reloading between a !NULL check and dereferences. */
 	return READ_ONCE(perf_guest_cbs);
 }
+static inline unsigned int perf_guest_state(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+
+	return guest_cbs ? guest_cbs->state() : 0;
+}
+static inline unsigned long perf_guest_get_ip(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+
+	/*
+	 * Arbitrarily return '0' in the unlikely scenario that the callbacks
+	 * are unregistered between checking guest state and getting the IP.
+	 */
+	return guest_cbs ? guest_cbs->get_ip() : 0;
+}
+static inline unsigned int perf_guest_handle_intel_pt_intr(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+
+	if (guest_cbs && guest_cbs->handle_intel_pt_intr)
+		return guest_cbs->handle_intel_pt_intr();
+	return 0;
+}
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
