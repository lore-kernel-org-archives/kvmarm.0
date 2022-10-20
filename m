Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC61C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:43:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47C854B87E;
	Thu, 20 Oct 2022 01:43:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZST10aluNHm0; Thu, 20 Oct 2022 01:43:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 230D14B916;
	Thu, 20 Oct 2022 01:43:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 547AD4B87E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sXyp1Sj3M692 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:43:47 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16B944B86A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:47 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-352e29ff8c2so191718387b3.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=oOYOygB9wgU7oohT9RJUnRPUR0sr23f6giwJ3lgqMuk=;
 b=pnLO+fv5ly2qcHUWCKLt3EUiUpqInxinUZeyTk5bKFD9rWzz62b8z6Im7diM3LlfrI
 ZiTbn1vNXiMirnaYW0OzA1SFNkR20MDXyf/IKiO35cUXNeTxdJy9jwmZwuRJQic/aUB1
 M07OM3NLcuZD6g+OH2McHlchBGEM8WqdA1dpl0vZNpHi7o2QgkZVwBmI50B0P72D6ect
 +PSf8Mb/btVDSO01nWPIQUH4pzs6kBIZ2nLkN7Mqtyz+Z5TqVadrdAvyD7uzoJBz//sp
 tULWZHRDZpdAfg73/neuToQEQ+V8MbkOepFTrWsZGzXKpYwhlSgoHELroHNKkpEjKBWX
 DBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=oOYOygB9wgU7oohT9RJUnRPUR0sr23f6giwJ3lgqMuk=;
 b=n3VvLHK40F7Ktj20tvOkork6MFSX6ome7WMFGkq2tP8GoKfhOmfLpm7HUvMzV8ppGk
 Py5u3saUq4jg6jGZ66jRjNgv01cXujjsaV04a+En8fKHnQgYwzYguSBnrVVqPA3gc7li
 HQhLZjxNjDSl8rslBurrI5SoW5UzGCMkjQZbiJPVrMtlINSr6SyjyWB18/uJzj/nO+82
 OIwzbc66faw7L7uKWfg7GFmVH6v2hiCTy+UZI4qypt4jX6RdvWADNWJrl0KMMWWVn4oz
 1bI9kxhUbI3UdZn9Ygm1v/A884dl4D5Ap+wDfNog6JQKUJPUtGiSdo+jjblzcXobzFcL
 ulug==
X-Gm-Message-State: ACrzQf1Lj/m4caHLJaK0GrBev/qlhgM0lXQWt5sDPaDBGg4zxVSw9v5i
 hrIOGIhZ6bf82hDGca9+13LFs69nhZY=
X-Google-Smtp-Source: AMsMyM6kx5OcEqJmzB/hkt4jneBqv+i1c8NLkTNAN23PWELR4sidAYtN4LhOl1nWljVBf7oA5kCb/r5iJNQ=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:5f52:0:b0:6c1:8af:5208 with SMTP id
 h18-20020a255f52000000b006c108af5208mr9557699ybm.220.1666244626721; Wed, 19
 Oct 2022 22:43:46 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:42:00 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-8-reijiw@google.com>
Subject: [PATCH v2 7/9] KVM: arm64: selftests: Add a test case for a linked
 breakpoint
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Currently, the debug-exceptions test doesn't have a test case for
a linked breakpoint. Add a test case for the linked breakpoint to
the test. The new test case uses a pair of breakpoints. One is the
higiest numbered context-aware breakpoint (for Context ID match),
and the other one is the breakpoint#0 (for Address Match), which
is linked to the context-aware breakpoint.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 63 +++++++++++++++++--
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 72ec9bb16682..362e7668a978 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -12,6 +12,10 @@
 #define DBGBCR_EXEC	(0x0 << 3)
 #define DBGBCR_EL1	(0x1 << 1)
 #define DBGBCR_E	(0x1 << 0)
+#define DBGBCR_LBN_SHIFT	16
+#define DBGBCR_BT_SHIFT		20
+#define DBGBCR_BT_ADDR_LINK_CTX	(0x1 << DBGBCR_BT_SHIFT)
+#define DBGBCR_BT_CTX_LINK	(0x3 << DBGBCR_BT_SHIFT)
 
 #define DBGWCR_LEN8	(0xff << 5)
 #define DBGWCR_RD	(0x1 << 3)
@@ -22,7 +26,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start, hw_bp_ctx;
 extern unsigned char iter_ss_begin, iter_ss_end;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
@@ -105,6 +109,7 @@ static void reset_debug_state(void)
 	isb();
 
 	write_sysreg(0, mdscr_el1);
+	write_sysreg(0, contextidr_el1);
 
 	/* Reset all bcr/bvr/wcr/wvr registers */
 	dfr0 = read_sysreg(id_aa64dfr0_el1);
@@ -166,6 +171,31 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_monitor_debug_exceptions();
 }
 
+void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
+		       uint64_t ctx)
+{
+	uint32_t addr_bcr, ctx_bcr;
+
+	/* Setup a context-aware breakpoint for Linked Context ID Match */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/*
+	 * Setup a normal breakpoint for Linked Address Match, and link it
+	 * to the context-aware breakpoint.
+	 */
+	addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		   DBGBCR_BT_ADDR_LINK_CTX |
+		   ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
+	write_dbgbcr(addr_bp, addr_bcr);
+	write_dbgbvr(addr_bp, addr);
+	isb();
+
+	enable_monitor_debug_exceptions();
+}
+
 static void install_ss(void)
 {
 	uint32_t mdscr;
@@ -179,8 +209,10 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(uint8_t bpn, uint8_t wpn)
+static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
+	uint64_t ctx = 0xabcdef;	/* a random context number */
+
 	/* Software-breakpoint */
 	reset_debug_state();
 	asm volatile("sw_bp: brk #0");
@@ -263,6 +295,17 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
 		     : : : "x0");
 	GUEST_ASSERT_EQ(ss_addr[0], 0);
 
+	/* Linked hardware-breakpoint */
+	hw_bp_addr = 0;
+	reset_debug_state();
+	install_hw_bp_ctx(bpn, ctx_bpn, PC(hw_bp_ctx), ctx);
+	/* Set context id */
+	write_sysreg(ctx, contextidr_el1);
+	isb();
+	asm volatile("hw_bp_ctx: nop");
+	write_sysreg(0, contextidr_el1);
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
+
 	GUEST_DONE();
 }
 
@@ -342,11 +385,12 @@ static int debug_version(uint64_t id_aa64dfr0)
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
-static void test_guest_debug_exceptions(void)
+static void test_guest_debug_exceptions(uint64_t aa64dfr0)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
+	uint8_t brp_num;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -365,8 +409,15 @@ static void test_guest_debug_exceptions(void)
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Run tests with breakpoint#0 and watchpoint#0. */
-	vcpu_args_set(vcpu, 2, 0, 0);
+	/* Number of breakpoints */
+	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), aa64dfr0) + 1;
+	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
+
+	/*
+	 * Run tests with breakpoint#0, watchpoint#0, and the higiest
+	 * numbered (context-aware) breakpoint.
+	 */
+	vcpu_args_set(vcpu, 3, 0, 0, brp_num - 1);
 
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
@@ -483,7 +534,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	test_guest_debug_exceptions();
+	test_guest_debug_exceptions(aa64dfr0);
 	test_single_step_from_userspace(ss_iteration);
 
 	return 0;
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
