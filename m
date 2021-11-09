Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB2DC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5F49619EC
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E5F49619EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A22B4A3A5;
	Mon,  8 Nov 2021 21:39:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0KvkyWx66I9x; Mon,  8 Nov 2021 21:39:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D863A4B20E;
	Mon,  8 Nov 2021 21:39:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E37FA4B1D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H84JvU1-aTLN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:30 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46FF04B1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:28 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 70-20020a630149000000b002da385ceffaso3257651pgb.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7PZd0x6lPt+COIUe7s6j5utQGrhaF5ukxN/0RXAhVWo=;
 b=KkxlOHxbD8sX4/BavdqqOCubN6USToniJ7DdIIAxOUptOkCQavMqqZXwLDQ47hcYxP
 JFyldCgg3BC3Q6ZzfJ6TjKHhFJ0nr/Xp4z6O1LxiDizBwHCYUSvyC5kmEZgOE4IyjR4T
 BicOJ+yQdSq9NtYqEyWBjh0Al+TzfTBWifD1N3o5770pW9r2oJBsxgn4fX1O1pAQt7L/
 CVo7PvNm8WBKi9+pCuA7lNNGYOgvyBdSlTIXdsDue7T4JhIVJ4Gn5yS46ro0tJHlg6zB
 qbZS5P5P7EZSI9N/LZNV+VSRUKdXOjmp/K+hR6AD+DBQQ9TmlOpEc7Cc0sCon22wj9Wt
 6srg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7PZd0x6lPt+COIUe7s6j5utQGrhaF5ukxN/0RXAhVWo=;
 b=hu8qbV7xLCrBT/bT4xN4DaiJf5JsExHcMfcPxTvP8RwagbjmlqvmhZyiS3GxpfD2yb
 Cxo8coGvRubjvBPhmyLS7p8HwfTMAhGaXVmLctV8gipJc67OHy6WSYXTcLRxC5IMknm1
 C/WgdBdaY3tvX11zs9JQxNFUzCNyY/GgXvirudgV2VX2osegJQyoU7H2sHnzK+bfgePk
 hPZzaUkdYfPQl/nvt6WsEA5lk23BH7ePsoL0fICuNiu2TG6WqwtolXRppOZQo8gab0qw
 omM0KEke5wThFRRBQsmGZk85T2UGQaMfzF9ruVkCuhbvX9gdzR0OHwJGYqIPV48HZ6JF
 PzmQ==
X-Gm-Message-State: AOAM531H0IPkgQCxxd3jtCb6vibQQhHZ12WLxfYF7Gp1dIiwUehCefyv
 XBzOzZJVA9W04qHvT5lS2qgAZ/wgxgZ9BQ==
X-Google-Smtp-Source: ABdhPJyZeUY1gD4uhMncXTUXTVCynHHQyEClaB3J19aVo94b9xq6INrEPKCtUNuTetOpfR96X8W9qAtSLlzsKA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr137439pjf.1.1636425567125; Mon, 08 Nov 2021 18:39:27 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:58 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 09/17] KVM: selftests: aarch64: cmdline arg to set EOI mode in
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

Add a new cmdline arg to set the EOI mode for all vgic_irq tests.  This
specifies whether a write to EOIR will deactivate IRQs or not.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 58 ++++++++++++++++---
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 0b89a29dfe79..3e18fa224280 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -29,6 +29,7 @@
  */
 struct test_args {
 	uint32_t nr_irqs; /* number of KVM supported IRQs. */
+	bool eoi_split; /* 1 is eoir+dir, 0 is eoir only */
 };
 
 /*
@@ -112,7 +113,7 @@ static uint64_t gic_read_ap1r0(void)
 	return reg;
 }
 
-static void guest_irq_handler(struct ex_regs *regs)
+static void guest_irq_generic_handler(bool eoi_split)
 {
 	uint32_t intid = gic_get_and_ack_irq();
 
@@ -129,6 +130,8 @@ static void guest_irq_handler(struct ex_regs *regs)
 
 	gic_set_eoi(intid);
 	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
+	if (eoi_split)
+		gic_set_dir(intid);
 
 	GUEST_ASSERT(!gic_irq_get_active(intid));
 	GUEST_ASSERT(!gic_irq_get_pending(intid));
@@ -151,6 +154,24 @@ do { 										\
 	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
 } while (0)
 
+#define CAT_HELPER(a, b) a ## b
+#define CAT(a, b) CAT_HELPER(a, b)
+#define PREFIX guest_irq_handler_
+#define GUEST_IRQ_HANDLER_NAME(split) CAT(PREFIX, split)
+#define GENERATE_GUEST_IRQ_HANDLER(split)					\
+static void CAT(PREFIX, split)(struct ex_regs *regs)				\
+{										\
+	guest_irq_generic_handler(split);					\
+}
+
+GENERATE_GUEST_IRQ_HANDLER(0);
+GENERATE_GUEST_IRQ_HANDLER(1);
+
+static void (*guest_irq_handlers[2])(struct ex_regs *) = {
+	GUEST_IRQ_HANDLER_NAME(0),
+	GUEST_IRQ_HANDLER_NAME(1),
+};
+
 static void reset_priorities(struct test_args *args)
 {
 	int i;
@@ -220,6 +241,8 @@ static void guest_code(struct test_args args)
 	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
 
+	gic_set_eoi_split(args.eoi_split);
+
 	reset_priorities(&args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
@@ -268,10 +291,11 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 
 static void print_args(struct test_args *args)
 {
-	printf("nr-irqs=%d\n", args->nr_irqs);
+	printf("nr-irqs=%d eoi-split=%d\n",
+			args->nr_irqs, args->eoi_split);
 }
 
-static void test_vgic(uint32_t nr_irqs)
+static void test_vgic(uint32_t nr_irqs, bool eoi_split)
 {
 	struct ucall uc;
 	int gic_fd;
@@ -280,6 +304,7 @@ static void test_vgic(uint32_t nr_irqs)
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
+		.eoi_split = eoi_split,
 	};
 
 	print_args(&args);
@@ -297,7 +322,7 @@ static void test_vgic(uint32_t nr_irqs)
 			GICD_BASE_GPA, GICR_BASE_GPA);
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
-			guest_irq_handler);
+			guest_irq_handlers[args.eoi_split]);
 
 	while (1) {
 		vcpu_run(vm, VCPU_ID);
@@ -328,8 +353,11 @@ static void help(const char *name)
 {
 	printf(
 	"\n"
-	"usage: %s [-n num_irqs]\n", name);
-	printf(" -n: specify the number of IRQs to configure the vgic with.\n");
+	"usage: %s [-n num_irqs] [-e eoi_split]\n", name);
+	printf(" -n: specify the number of IRQs to configure the vgic with. "
+		"It has to be a multiple of 32 and between 64 and 1024.\n");
+	printf(" -e: if 1 then EOI is split into a write to DIR on top "
+		"of writing EOI.\n");
 	puts("");
 	exit(1);
 }
@@ -337,18 +365,24 @@ static void help(const char *name)
 int main(int argc, char **argv)
 {
 	uint32_t nr_irqs = 64;
+	bool default_args = true;
 	int opt;
+	bool eoi_split = false;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	while ((opt = getopt(argc, argv, "hg:n:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:e:")) != -1) {
 		switch (opt) {
 		case 'n':
 			nr_irqs = atoi(optarg);
 			if (nr_irqs > 1024 || nr_irqs % 32)
 				help(argv[0]);
 			break;
+		case 'e':
+			eoi_split = (bool)atoi(optarg);
+			default_args = false;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -356,7 +390,15 @@ int main(int argc, char **argv)
 		}
 	}
 
-	test_vgic(nr_irqs);
+	/* If the user just specified nr_irqs and/or gic_version, then run all
+	 * combinations.
+	 */
+	if (default_args) {
+		test_vgic(nr_irqs, false /* eoi_split */);
+		test_vgic(nr_irqs, true /* eoi_split */);
+	} else {
+		test_vgic(nr_irqs, eoi_split);
+	}
 
 	return 0;
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
