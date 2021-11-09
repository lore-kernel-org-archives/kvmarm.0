Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0225C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A19F4619E4
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A19F4619E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 526684B1F8;
	Mon,  8 Nov 2021 21:39:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BJOdWxzvFl8t; Mon,  8 Nov 2021 21:39:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0320E4B1BD;
	Mon,  8 Nov 2021 21:39:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9DC4B1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+vONcnW5X9Y for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:31 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8F9E4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:29 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 b23-20020a170902d89700b001415444f5a6so7705385plz.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LozXdBeHm1wVJM1zXtUi3Myaa0mOvHQ8f6t6MIK9jqk=;
 b=c2JYScEky9XAjrfUtUpSg0+Ds/y5sqhLsY4MTjk1ZRyQ5jTN+xr18kK5ALfBIkdJGl
 BeTxqMZXPXkFlv4W77QPonZYelqiEfHTUeYu01+VAXEyh4srKCMpNR+w2H9ZSisj6hju
 7jgBEmL+2HSlqRH1z1zJQ/QAV2sdf8sCUkO+o8EsS4uAsJECUV0vi3YBRAl3UAKJH0EA
 HBq6OmaB1EQtEJAPCRn1DJ4qj1NMNQsGDGLtfDzdCihW10n5RBHQl7TDLI5YCYIwKtq3
 O2rmB73ClJb40oSoNLany273Jisyaex1z4lIO4QMIMxDWU4lmLzAfD71VVa6calQR9Z3
 3BMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LozXdBeHm1wVJM1zXtUi3Myaa0mOvHQ8f6t6MIK9jqk=;
 b=l1lPIDnTZBiYk4vVNFx3R9+54RcJ06O3loZbfl0Deo2/yeInDvF+oK+KinVTSQINZ7
 UFjSYefCFldG6TwhdT2XvWPN3ZTN7Q16wsJhMEIvzLOiNliAbSSKBBrq8nVPVFjHdors
 GuTVypuNpWexbMXzZgGmZA276/wpYOhepEnFBIiwGxYrGma7O3neLl8oqY8n3/CrjyE5
 0K1Q6RFJ8C0I0Enlxj7/x+sTYb7H59qPTV9+rF0WJwSV5Afhr5FTxSi14Fm+kbhthF2a
 X4nDebn2/7p/lE9eQ9cj9+5+31Ek8+S5gYrKLaPLhMAZ/KGCNqk9JNqtuTw0L54jnm/Y
 dWHg==
X-Gm-Message-State: AOAM531o+WSQ7t4anmgvwuvGXJ0yOSehBrIusBeEXpzeoLuUEmQDm0RV
 PrAzl1+/r2NqEHgY250nMmZnlltut9bZCw==
X-Google-Smtp-Source: ABdhPJyd3cmlccdsr0jYFtsQ/AxEtNcZxg4ERBnu9kTbLsShBB+WnJdZ2O9U6SlWXTQFEJZRY28W/+iC5/C0mQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8755:0:b0:494:67a6:1c84 with SMTP id
 g21-20020aa78755000000b0049467a61c84mr37627084pfo.26.1636425569082; Mon, 08
 Nov 2021 18:39:29 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:59 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-11-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 10/17] KVM: selftests: aarch64: add preemption tests in
 vgic_irq
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add tests for IRQ preemption (having more than one activated IRQ at the
same time).  This test injects multiple concurrent IRQs and handles them
without handling the actual exceptions.  This is done by masking
interrupts for the whole test.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 91 ++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 3e18fa224280..b9080aa75a14 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -41,6 +41,7 @@ struct test_args {
  */
 #define KVM_NUM_PRIOS		32
 #define KVM_PRIO_SHIFT		3 /* steps of 8 = 1 << 3 */
+#define KVM_PRIO_STEPS		(1 << KVM_PRIO_SHIFT) /* 8 */
 #define LOWEST_PRIO		(KVM_NUM_PRIOS - 1)
 #define CPU_PRIO_MASK		(LOWEST_PRIO << KVM_PRIO_SHIFT)	/* 0xf8 */
 #define IRQ_DEFAULT_PRIO	(LOWEST_PRIO - 1)
@@ -212,6 +213,74 @@ static void guest_inject(struct test_args *args,
 	reset_priorities(args);
 }
 
+/*
+ * Polls the IAR until it's not a spurious interrupt.
+ *
+ * This function should only be used in test_inject_preemption (with IRQs
+ * masked).
+ */
+static uint32_t wait_for_and_activate_irq(void)
+{
+	uint32_t intid;
+
+	do {
+		asm volatile("wfi" : : : "memory");
+		intid = gic_get_and_ack_irq();
+	} while (intid == IAR_SPURIOUS);
+
+	return intid;
+}
+
+/*
+ * Inject multiple concurrent IRQs (num IRQs starting at first_intid) and
+ * handle them without handling the actual exceptions.  This is done by masking
+ * interrupts for the whole test.
+ */
+static void test_inject_preemption(struct test_args *args,
+		uint32_t first_intid, int num,
+		kvm_inject_cmd cmd)
+{
+	uint32_t intid, prio, step = KVM_PRIO_STEPS;
+	int i;
+
+	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
+	 * in descending order, so intid+1 can preempt intid.
+	 */
+	for (i = 0, prio = (num - 1) * step; i < num; i++, prio -= step) {
+		GUEST_ASSERT(prio >= 0);
+		intid = i + first_intid;
+		gic_set_priority(intid, prio);
+	}
+
+	local_irq_disable();
+
+	for (i = 0; i < num; i++) {
+		uint32_t tmp;
+		intid = i + first_intid;
+		kvm_inject_call(cmd, intid, 1);
+		/* Each successive IRQ will preempt the previous one. */
+		tmp = wait_for_and_activate_irq();
+		GUEST_ASSERT_EQ(tmp, intid);
+	}
+
+	/* finish handling the IRQs starting with the highest priority one. */
+	for (i = 0; i < num; i++) {
+		intid = num - i - 1 + first_intid;
+		gic_set_eoi(intid);
+		if (args->eoi_split)
+			gic_set_dir(intid);
+	}
+
+	local_irq_enable();
+
+	for (i = 0; i < num; i++)
+		GUEST_ASSERT(!gic_irq_get_active(i + first_intid));
+	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
+	GUEST_ASSERT_IAR_EMPTY();
+
+	reset_priorities(args);
+}
+
 static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 {
 	uint32_t nr_irqs = args->nr_irqs;
@@ -231,6 +300,24 @@ static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 	}
 }
 
+static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
+{
+	/*
+	 * Test up to 4 levels of preemption. The reason is that KVM doesn't
+	 * currently implement the ability to have more than the number-of-LRs
+	 * number of concurrently active IRQs. The number of LRs implemented is
+	 * IMPLEMENTATION DEFINED, however, it seems that most implement 4.
+	 */
+	if (f->sgi)
+		test_inject_preemption(args, MIN_SGI, 4, f->cmd);
+
+	if (f->ppi)
+		test_inject_preemption(args, MIN_PPI, 4, f->cmd);
+
+	if (f->spi)
+		test_inject_preemption(args, MIN_SPI, 4, f->cmd);
+}
+
 static void guest_code(struct test_args args)
 {
 	uint32_t i, nr_irqs = args.nr_irqs;
@@ -249,8 +336,10 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_inject_fn(inject_edge_fns, f)
+	for_each_inject_fn(inject_edge_fns, f) {
 		test_injection(&args, f);
+		test_preemption(&args, f);
+	}
 
 	GUEST_DONE();
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
