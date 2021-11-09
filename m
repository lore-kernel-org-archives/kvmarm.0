Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5CFC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAB73619FA
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EAB73619FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA5E4B1C8;
	Mon,  8 Nov 2021 21:39:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pDIsUIM99m88; Mon,  8 Nov 2021 21:39:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 525CD4B1E3;
	Mon,  8 Nov 2021 21:39:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6854B21E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lbVZIf7JuCRl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:34 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 715B84B203
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:34 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 m17-20020a170902db1100b001421cb34857so7425001plx.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4fIWsaJ7AG87Eny4Oj2wlGi/WPege+GzmpcyzUfC/nA=;
 b=sdqIJ3tNj+06Vs15yWGRFfTW5dZ5joj8Aa4fZvsD8ZJrR1TY4RD/KU3ZhZDuX8zqXS
 wimZE18x7boDFaqI2o9fz/QPYw0q4wIeA2M9biLAx6U7CTFizQZXHO+EPT18un50aKVL
 vJVLjTJjbl4u0KKT9ezFMhwF0s9VsQIR6iKTrGnzAY56A0FERJrzPZBAaeiNvQ7my23/
 Dofo88qFQnotiAM1LbZSwq0IPtpjDc2OoruW/txUm7GEGHc7XUnnG4RsNdEemQRQz4J9
 OF24uosRg+LaLXfoIgQ2nqkLyWmFTP3BeuBBwOMKLU9XbmpM9YSjvS9Ifgxny8BCGo9p
 7Ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4fIWsaJ7AG87Eny4Oj2wlGi/WPege+GzmpcyzUfC/nA=;
 b=b1mf59XVSOXq4dNgY2KLIyYRSUu4V7ziTrSpR3h1qhix1J20V3iq32S8jL5srTm2pS
 NnrWUWt14lk42CDhQjl46QJkmdLOBnJT+vFQ19SG6OVgjo5H3CCzEImb558KdV9xxGd8
 HpIlq/Cs9hroLKzyhq89btOACfVxGuyaNRsNQ5PkyuMYvwb08tHzd1ZXosS95A7kC0zo
 1Rurir5QaqEo0k/d7vVv7cnqgbcDL8jJzOljmde87Bu/0PjDC3x158OmWsQoWifOXo3H
 OP9JTw/ikFchLPFVB9yrRZbCy58HAOEVlgosy8BIMqcwUT5pUQaME4+Ju/7iS1vUelrp
 R8Qg==
X-Gm-Message-State: AOAM530r81n64VE7eCo2u10zJDamTVqnd/zIi8cWDdyCHNK4tt/SCkhE
 EpsuTCMcTq1CslU+H5wg06nlvJ0JtnMxcg==
X-Google-Smtp-Source: ABdhPJxe7TUOGiysiHJWhoUKues6FGuvEwSAAtB2niN2S8OEli6XrUWSVccmzL0bWu42GNXILmsof4dgznU+5Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4d8f:: with SMTP id
 oj15mr3295394pjb.127.1636425573621; Mon, 08 Nov 2021 18:39:33 -0800 (PST)
Date: Mon,  8 Nov 2021 18:39:02 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-14-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 13/17] KVM: selftests: aarch64: add test_inject_fail to
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

Add tests for failed injections to vgic_irq. This tests that KVM can
handle bogus IRQ numbers.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 122 +++++++++++++++---
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   7 +-
 2 files changed, 109 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index bc1b6fd684fc..9f1674b3a45c 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -68,21 +68,28 @@ struct kvm_inject_args {
 	uint32_t first_intid;
 	uint32_t num;
 	int level;
+	bool expect_failure;
 };
 
 /* Used on the guest side to perform the hypercall. */
 static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
-			uint32_t num, int level);
+		uint32_t num, int level, bool expect_failure);
 
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args);
 
-#define KVM_INJECT(cmd, intid)							\
-	kvm_inject_call(cmd, intid, 1, -1 /* not used */)
+#define _KVM_INJECT_MULTI(cmd, intid, num, expect_failure)			\
+	kvm_inject_call(cmd, intid, num, -1 /* not used */, expect_failure)
 
 #define KVM_INJECT_MULTI(cmd, intid, num)					\
-	kvm_inject_call(cmd, intid, num, -1 /* not used */)
+	_KVM_INJECT_MULTI(cmd, intid, num, false)
+
+#define _KVM_INJECT(cmd, intid, expect_failure)					\
+	_KVM_INJECT_MULTI(cmd, intid, 1, expect_failure)
+
+#define KVM_INJECT(cmd, intid)							\
+	_KVM_INJECT_MULTI(cmd, intid, 1, false)
 
 struct kvm_inject_desc {
 	kvm_inject_cmd cmd;
@@ -158,13 +165,14 @@ static void guest_irq_generic_handler(bool eoi_split, bool level_sensitive)
 }
 
 static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
-			uint32_t num, int level)
+		uint32_t num, int level, bool expect_failure)
 {
 	struct kvm_inject_args args = {
 		.cmd = cmd,
 		.first_intid = first_intid,
 		.num = num,
 		.level = level,
+		.expect_failure = expect_failure,
 	};
 	GUEST_SYNC(&args);
 }
@@ -206,7 +214,19 @@ static void reset_priorities(struct test_args *args)
 
 static void guest_set_irq_line(uint32_t intid, uint32_t level)
 {
-	kvm_inject_call(KVM_SET_IRQ_LINE, intid, 1, level);
+	kvm_inject_call(KVM_SET_IRQ_LINE, intid, 1, level, false);
+}
+
+static void test_inject_fail(struct test_args *args,
+		uint32_t intid, kvm_inject_cmd cmd)
+{
+	reset_stats();
+
+	_KVM_INJECT(cmd, intid, true);
+	/* no IRQ to handle on entry */
+
+	GUEST_ASSERT_EQ(irq_handled, 0);
+	GUEST_ASSERT_IAR_EMPTY();
 }
 
 static void guest_inject(struct test_args *args,
@@ -330,6 +350,16 @@ static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 	}
 }
 
+static void test_injection_failure(struct test_args *args,
+		struct kvm_inject_desc *f)
+{
+	uint32_t bad_intid[] = { args->nr_irqs, 1020, 1024, 1120, 5120, ~0U, };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bad_intid); i++)
+		test_inject_fail(args, bad_intid[i], f->cmd);
+}
+
 static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 {
 	/*
@@ -376,11 +406,61 @@ static void guest_code(struct test_args args)
 	for_each_inject_fn(inject_fns, f) {
 		test_injection(&args, f);
 		test_preemption(&args, f);
+		test_injection_failure(&args, f);
 	}
 
 	GUEST_DONE();
 }
 
+static void kvm_irq_line_check(struct kvm_vm *vm, uint32_t intid, int level,
+			struct test_args *test_args, bool expect_failure)
+{
+	int ret;
+
+	if (!expect_failure) {
+		kvm_arm_irq_line(vm, intid, level);
+	} else {
+		/* The interface doesn't allow larger intid's. */
+		if (intid > KVM_ARM_IRQ_NUM_MASK)
+			return;
+
+		ret = _kvm_arm_irq_line(vm, intid, level);
+		TEST_ASSERT(ret != 0 && errno == EINVAL,
+				"Bad intid %i did not cause KVM_IRQ_LINE "
+				"error: rc: %i errno: %i", intid, ret, errno);
+	}
+}
+
+void kvm_irq_set_level_info_check(int gic_fd, uint32_t intid, int level,
+			bool expect_failure)
+{
+	if (!expect_failure) {
+		kvm_irq_set_level_info(gic_fd, intid, level);
+	} else {
+		int ret = _kvm_irq_set_level_info(gic_fd, intid, level);
+		/*
+		 * The kernel silently fails for invalid SPIs and SGIs (which
+		 * are not level-sensitive). It only checks for intid to not
+		 * spill over 1U << 10 (the max reserved SPI). Also, callers
+		 * are supposed to mask the intid with 0x3ff (1023).
+		 */
+		if (intid > VGIC_MAX_RESERVED)
+			TEST_ASSERT(ret != 0 && errno == EINVAL,
+				"Bad intid %i did not cause VGIC_GRP_LEVEL_INFO "
+				"error: rc: %i errno: %i", intid, ret, errno);
+		else
+			TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO "
+				"for intid %i failed, rc: %i errno: %i",
+				intid, ret, errno);
+	}
+}
+
+/* handles the valid case: intid=0xffffffff num=1 */
+#define for_each_intid(first, num, tmp, i)					\
+	for ((tmp) = (i) = (first);						\
+		(tmp) < (uint64_t)(first) + (uint64_t)(num);			\
+		(tmp)++, (i)++)
+
 static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 		struct kvm_inject_args *inject_args,
 		struct test_args *test_args)
@@ -389,28 +469,36 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 	uint32_t intid = inject_args->first_intid;
 	uint32_t num = inject_args->num;
 	int level = inject_args->level;
+	bool expect_failure = inject_args->expect_failure;
+	uint64_t tmp;
 	uint32_t i;
 
-	assert(intid < UINT_MAX - num);
+	/* handles the valid case: intid=0xffffffff num=1 */
+	assert(intid < UINT_MAX - num || num == 1);
 
 	switch (cmd) {
 	case KVM_INJECT_EDGE_IRQ_LINE:
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, 1);
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, 0);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, 1, test_args,
+					expect_failure);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, 0, test_args,
+					expect_failure);
 		break;
 	case KVM_SET_IRQ_LINE:
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, level);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, level, test_args,
+					expect_failure);
 		break;
 	case KVM_SET_IRQ_LINE_HIGH:
-		for (i = intid; i < intid + num; i++)
-			kvm_arm_irq_line(vm, i, 1);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_line_check(vm, i, 1, test_args,
+					expect_failure);
 		break;
 	case KVM_SET_LEVEL_INFO_HIGH:
-		for (i = intid; i < intid + num; i++)
-			kvm_irq_set_level_info(gic_fd, i, 1);
+		for_each_intid(intid, num, tmp, i)
+			kvm_irq_set_level_info_check(gic_fd, i, 1,
+					expect_failure);
 		break;
 	default:
 		break;
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 84206d7c92b4..b3a0fca0d780 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -110,12 +110,13 @@ int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
 {
 	uint32_t irq = intid & KVM_ARM_IRQ_NUM_MASK;
 
+	TEST_ASSERT(!INTID_IS_SGI(intid), "KVM_IRQ_LINE's interface itself "
+		"doesn't allow injecting SGIs. There's no mask for it.");
+
 	if (INTID_IS_PPI(intid))
 		irq |= KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
-	else if (INTID_IS_SPI(intid))
-		irq |= KVM_ARM_IRQ_TYPE_SPI << KVM_ARM_IRQ_TYPE_SHIFT;
 	else
-		TEST_FAIL("KVM_IRQ_LINE can't be used with SGIs.");
+		irq |= KVM_ARM_IRQ_TYPE_SPI << KVM_ARM_IRQ_TYPE_SHIFT;
 
 	return _kvm_irq_line(vm, irq, level);
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
