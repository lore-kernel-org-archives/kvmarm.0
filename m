Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AE4C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4965D61100
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4965D61100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F35DF4B11A;
	Wed, 22 Sep 2021 09:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IQi4ffVl-WtA; Wed, 22 Sep 2021 09:12:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70EFA4B126;
	Wed, 22 Sep 2021 09:11:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FDFF4A00B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:05:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BbT3VE7y-9Kr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 20:05:54 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4B4C405EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 20:05:54 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 h9-20020a05621413a900b0037a2d3eaf8fso7925733qvz.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 17:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=uGRLtrGbpD3S6B/7zzXt3L9N6QvZuu1UjnfG14mJ8ek=;
 b=RFIhbvEyvYMragxwcAv1E8u094o6TR3aNC++WUaaLMbpX1lKaGuAbXr4UQ4DnYHp6f
 0izeMTfNi3w+g5sbRJ0zA7LvF+2NsrCBFGIUyCyWEOC9wn70vrrhnoT3jtw95SZHu/KS
 NX/NMJBJ9rL02BAnaFZcMgeOgQTyJ3QXygCXEu9hwHwMFitHgFFJeLNMjteHVUzmBk3C
 gxJ7A5VIKod2bScVarg0Ti81qTfwhFhcVvMp3krZctVE206zQUgs8jQ7G+Dz7hdiV3WH
 q42Zv28O4z7mAPyMIHk2g1A40W19Qiluvr7IjkcHSYgiI2bp3YLj+WcuS1yfVh40dAHd
 TYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=uGRLtrGbpD3S6B/7zzXt3L9N6QvZuu1UjnfG14mJ8ek=;
 b=uqrIIi0syId92hxtsZoeo9Qx8IiJ2KsRYY2l60WOeyV5W7vQtA0yeiQ+mDKKYSXQIx
 B2ONt752Thk2JGWcM9Mh116Un8K/klGqMdbFgYt3OjRGDMZ8Z0Hfj3jlxPiBC2Gd8kag
 iJhbkqWnSFSeTy2Jb0R7CBn9XrMfwtdHZv52wMG2GyRJIESWf6qQwCvK8s8+6oefNG/E
 EPMKV3LXNTWduAhvv/Ty2hQOT3dSOkpv11bDOED9CNYILq+DGZLRGZMjvMttPbJaEAZk
 9s57bVhiRDn/fE6drF88YITzAZsT+PoA7RbybZf10ZEsSbOAoCo/WhPqukwfflQmPGFH
 XP6w==
X-Gm-Message-State: AOAM531HsaMqT9v3Qz07crNsBqdgwrwXUFjsMGBE2E8Dl4X0BOB6LbIG
 nFHNEgXBG6cFVhsrLSgjvL46AjPge8Q=
X-Google-Smtp-Source: ABdhPJx1/jRpojAUuj4tkfVy2mNumpkwTOY4qlI3JrC7x6zrnCf19L4LA34wG9xOt6d1Anx3BB/t4F42q7U=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2e7:: with SMTP id
 h7mr34209194qvu.39.1632269154568; Tue, 21 Sep 2021 17:05:54 -0700 (PDT)
Date: Tue, 21 Sep 2021 17:05:22 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 05/16] perf: Drop dead and useless guest "support" from
 arm, csky, nds32 and riscv
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

Drop "support" for guest callbacks from architctures that don't implement
the guest callbacks.  Future patches will convert the callbacks to
static_call; rather than churn a bunch of arch code (that was presumably
copy+pasted from x86), remove it wholesale as it's useless and at best
wasting cycles.

A future patch will also add a Kconfig to force architcture to opt into
the callbacks to make it more difficult for uses "support" to sneak in in
the future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm/kernel/perf_callchain.c   | 33 ++++-------------------------
 arch/csky/kernel/perf_callchain.c  | 12 -----------
 arch/nds32/kernel/perf_event_cpu.c | 34 ++++--------------------------
 arch/riscv/kernel/perf_callchain.c | 13 ------------
 4 files changed, 8 insertions(+), 84 deletions(-)

diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
index 1626dfc6f6ce..bc6b246ab55e 100644
--- a/arch/arm/kernel/perf_callchain.c
+++ b/arch/arm/kernel/perf_callchain.c
@@ -62,14 +62,8 @@ user_backtrace(struct frame_tail __user *tail,
 void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct frame_tail __user *tail;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		/* We don't support guest os callchain now */
-		return;
-	}
-
 	perf_callchain_store(entry, regs->ARM_pc);
 
 	if (!current->mm)
@@ -99,44 +93,25 @@ callchain_trace(struct stackframe *fr,
 void
 perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe fr;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		/* We don't support guest os callchain now */
-		return;
-	}
-
 	arm_get_current_stackframe(regs, &fr);
 	walk_stackframe(&fr, callchain_trace, entry);
 }
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return guest_cbs->get_guest_ip();
-
 	return instruction_pointer(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	int misc = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		if (guest_cbs->is_user_mode())
-			misc |= PERF_RECORD_MISC_GUEST_USER;
-		else
-			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
-	} else {
-		if (user_mode(regs))
-			misc |= PERF_RECORD_MISC_USER;
-		else
-			misc |= PERF_RECORD_MISC_KERNEL;
-	}
+	if (user_mode(regs))
+		misc |= PERF_RECORD_MISC_USER;
+	else
+		misc |= PERF_RECORD_MISC_KERNEL;
 
 	return misc;
 }
diff --git a/arch/csky/kernel/perf_callchain.c b/arch/csky/kernel/perf_callchain.c
index 35318a635a5f..92057de08f4f 100644
--- a/arch/csky/kernel/perf_callchain.c
+++ b/arch/csky/kernel/perf_callchain.c
@@ -86,13 +86,8 @@ static unsigned long user_backtrace(struct perf_callchain_entry_ctx *entry,
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	unsigned long fp = 0;
 
-	/* C-SKY does not support virtualization. */
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return;
-
 	fp = regs->regs[4];
 	perf_callchain_store(entry, regs->pc);
 
@@ -111,15 +106,8 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe fr;
 
-	/* C-SKY does not support virtualization. */
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		pr_warn("C-SKY does not support perf in guest mode!");
-		return;
-	}
-
 	fr.fp = regs->regs[4];
 	fr.lr = regs->lr;
 	walk_stackframe(&fr, entry);
diff --git a/arch/nds32/kernel/perf_event_cpu.c b/arch/nds32/kernel/perf_event_cpu.c
index f38791960781..a78a879e7ef1 100644
--- a/arch/nds32/kernel/perf_event_cpu.c
+++ b/arch/nds32/kernel/perf_event_cpu.c
@@ -1363,7 +1363,6 @@ void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 		    struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	unsigned long fp = 0;
 	unsigned long gp = 0;
 	unsigned long lp = 0;
@@ -1372,11 +1371,6 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 
 	leaf_fp = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		/* We don't support guest os callchain now */
-		return;
-	}
-
 	perf_callchain_store(entry, regs->ipc);
 	fp = regs->fp;
 	gp = regs->gp;
@@ -1480,13 +1474,8 @@ void
 perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 		      struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe fr;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		/* We don't support guest os callchain now */
-		return;
-	}
 	fr.fp = regs->fp;
 	fr.lp = regs->lp;
 	fr.sp = regs->sp;
@@ -1495,32 +1484,17 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	/* However, NDS32 does not support virtualization */
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return guest_cbs->get_guest_ip();
-
 	return instruction_pointer(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	int misc = 0;
 
-	/* However, NDS32 does not support virtualization */
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		if (guest_cbs->is_user_mode())
-			misc |= PERF_RECORD_MISC_GUEST_USER;
-		else
-			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
-	} else {
-		if (user_mode(regs))
-			misc |= PERF_RECORD_MISC_USER;
-		else
-			misc |= PERF_RECORD_MISC_KERNEL;
-	}
+	if (user_mode(regs))
+		misc |= PERF_RECORD_MISC_USER;
+	else
+		misc |= PERF_RECORD_MISC_KERNEL;
 
 	return misc;
 }
diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
index 8ecfc4c128bc..1fc075b8f764 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -56,13 +56,8 @@ static unsigned long user_backtrace(struct perf_callchain_entry_ctx *entry,
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	unsigned long fp = 0;
 
-	/* RISC-V does not support perf in guest mode. */
-	if (guest_cbs && guest_cbs->is_in_guest())
-		return;
-
 	fp = regs->s0;
 	perf_callchain_store(entry, regs->epc);
 
@@ -79,13 +74,5 @@ static bool fill_callchain(void *entry, unsigned long pc)
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	/* RISC-V does not support perf in guest mode. */
-	if (guest_cbs && guest_cbs->is_in_guest()) {
-		pr_warn("RISC-V does not support perf in guest mode!");
-		return;
-	}
-
 	walk_stackframe(NULL, regs, fill_callchain, entry);
 }
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
