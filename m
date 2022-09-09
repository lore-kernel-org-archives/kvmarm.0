Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9A0ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 04:47:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD04B4CB2A;
	Fri,  9 Sep 2022 00:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4j59jtLGrosl; Fri,  9 Sep 2022 00:47:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6664CB14;
	Fri,  9 Sep 2022 00:47:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A189D4CB01
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gBiofAugbVr6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 00:47:11 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B67F4C278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:47:11 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-34546b03773so6135877b3.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2022 21:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=MbeYcUZH5rZnv7Srky0s60QQaNvSpZyXF49LSUjvDEA=;
 b=HystTyEzO0y7slgnAoyhgmwyE6//Ptny72kWSKwWDwnF/pewU2YZGmTe4aXKH4BsD9
 tOZCF/pJNqzQMbGFrADdmXjXCQP9EvzOUU4QmcRDcYj0PKa/uqArjk2L8VC51x0vCNoO
 PgY+1uxqASwNnCD/990sGSZL6aehIUh45mhAzNGV95InvmredIbbFxcU/UhevR3DlKdd
 jBZQdIU98NOmjPHQ3GG2KSDMtSP0PZmznTJKoIdfgvWTm491PoCsSbPyh2fU+AwvhvQZ
 M6vOVpJjEVujY6am0l8Vd3XInLJJ/6QY+l3Am8kVuk9XHMmoz0hEwbnH9UrjjsrJX5of
 6Rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=MbeYcUZH5rZnv7Srky0s60QQaNvSpZyXF49LSUjvDEA=;
 b=ZrKsq2+5bI1rwgAgtFuHlXI9sj1N8zpO8YJwWZmFV/zFTGBzNFliKMnIjIR2Et1oOD
 d9XMy99R1yDcyT3d9iWdGiAh9p6Lgq2yTaNcw6aPGMaufHqyqxrWPkYXtxvK2agFQC7J
 LuYrNhE2zd0zdba/jvO77Z125I5R23yBRk4uEDXn/0NKEl0QxvKydeE4k7NjqEfnST01
 z2eLXeJifDQphLMpjQxrD578X+cXS1XIqf4zgoZailT39Z2oD6E2J21cWwcqNhFQu4gi
 DgtyNCVUnu8GgLYJcwDh+YViazBSd405y3WW41F0kXXvqcrW3HELS4I4dLlnpxBPT0g6
 xm8g==
X-Gm-Message-State: ACgBeo2zFi+bMJzR7ZC3kzwE9slPXLKmfce5FjzCc2YKDJoCn9I4YQzC
 /68pNfk4VhgFf/qddpd+fBCdHVsOHf0=
X-Google-Smtp-Source: AA6agR5IWYF7xulqdDWKw4Vild+Gpo9RYX8tS1XQklBJGnd+q0eLLVs/7l2nNFWoVG/E37pxU2HqzDpQBJc=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:d491:0:b0:6a8:6d1d:465b with SMTP id
 m139-20020a25d491000000b006a86d1d465bmr9986451ybf.64.1662698831044; Thu, 08
 Sep 2022 21:47:11 -0700 (PDT)
Date: Thu,  8 Sep 2022 21:46:36 -0700
In-Reply-To: <20220909044636.1997755-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-4-reijiw@google.com>
Subject: [PATCH 3/3] KVM: arm64: selftests: Add a test case for
 KVM_GUESTDBG_SINGLESTEP
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Add a test case for KVM_GUESTDBG_SINGLESTEP to the debug-exceptions test.
The test enables single-step execution from userspace, and check if the
exit to userspace occurs for each instruction that is stepped.
Set the default number of the test iterations to a number of iterations
sufficient to always reproduce the problem that the previous patch fixes
on an Ampere Altra machine.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 131 ++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index e6e83b895fd5..947bd201435c 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -22,6 +22,7 @@
 #define SPSR_SS		(1 << 21)
 
 extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char iter_ss_begin, iter_ss_end;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -238,6 +239,46 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
+enum single_step_op {
+	SINGLE_STEP_ENABLE = 0,
+	SINGLE_STEP_DISABLE = 1,
+};
+
+static void guest_code_ss(int test_cnt)
+{
+	uint64_t i;
+	uint64_t bvr, wvr, w_bvr, w_wvr;
+
+	for (i = 0; i < test_cnt; i++) {
+		/* Bits [1:0] of dbg{b,w}vr are RES0 */
+		w_bvr = i << 2;
+		w_wvr = i << 2;
+
+		/* Enable Single Step execution */
+		GUEST_SYNC(SINGLE_STEP_ENABLE);
+
+		/*
+		 * The userspace will veriry that the pc is as expected during
+		 * single step execution between iter_ss_begin and iter_ss_end.
+		 */
+		asm volatile("iter_ss_begin:nop\n");
+
+		write_sysreg(w_bvr, dbgbvr0_el1);
+		write_sysreg(w_wvr, dbgwvr0_el1);
+		bvr = read_sysreg(dbgbvr0_el1);
+		wvr = read_sysreg(dbgwvr0_el1);
+
+		asm volatile("iter_ss_end:\n");
+
+		/* Disable Single Step execution */
+		GUEST_SYNC(SINGLE_STEP_DISABLE);
+
+		GUEST_ASSERT(bvr == w_bvr);
+		GUEST_ASSERT(wvr == w_wvr);
+	}
+	GUEST_DONE();
+}
+
 static int debug_version(struct kvm_vcpu *vcpu)
 {
 	uint64_t id_aa64dfr0;
@@ -293,16 +334,106 @@ static void test_guest_debug_exceptions(void)
 	kvm_vm_free(vm);
 }
 
+void test_single_step_from_userspace(int test_cnt)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	struct kvm_run *run;
+	uint64_t pc, cmd;
+	uint64_t test_pc = 0;
+	bool ss_enable = false;
+	struct kvm_guest_debug debug = {};
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_ss);
+	ucall_init(vm, NULL);
+	run = vcpu->run;
+	vcpu_args_set(vcpu, 1, test_cnt);
+
+	while (1) {
+		vcpu_run(vcpu);
+		if (run->exit_reason != KVM_EXIT_DEBUG) {
+			cmd = get_ucall(vcpu, &uc);
+			if (cmd == UCALL_ABORT) {
+				REPORT_GUEST_ASSERT(uc);
+				/* NOT REACHED */
+			} else if (cmd == UCALL_DONE) {
+				break;
+			}
+
+			TEST_ASSERT(cmd == UCALL_SYNC,
+				    "Unexpected ucall cmd 0x%lx", cmd);
+
+			if (uc.args[1] == SINGLE_STEP_ENABLE) {
+				debug.control = KVM_GUESTDBG_ENABLE |
+						KVM_GUESTDBG_SINGLESTEP;
+				ss_enable = true;
+			} else {
+				debug.control = SINGLE_STEP_DISABLE;
+				ss_enable = false;
+			}
+
+			vcpu_guest_debug_set(vcpu, &debug);
+			continue;
+		}
+
+		TEST_ASSERT(ss_enable, "Unexpected KVM_EXIT_DEBUG");
+
+		/* Check if the current pc is expected. */
+		vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &pc);
+		TEST_ASSERT(!test_pc || pc == test_pc,
+			    "Unexpected pc 0x%lx (expected 0x%lx)",
+			    pc, test_pc);
+
+		/*
+		 * If the current pc is between iter_ss_bgin and
+		 * iter_ss_end, the pc for the next KVM_EXIT_DEBUG should
+		 * be the current pc + 4.
+		 */
+		if ((pc >= (uint64_t)&iter_ss_begin) &&
+		    (pc < (uint64_t)&iter_ss_end))
+			test_pc = pc + 4;
+		else
+			test_pc = 0;
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("Usage: %s [-h] [-i iterations of the single step test]\n", name);
+	puts("");
+	exit(0);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
+	int opt;
+	int ss_iteration = 10000;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	__TEST_REQUIRE(debug_version(vcpu) >= 6,
 		       "Armv8 debug architecture not supported.");
 	kvm_vm_free(vm);
+
+	while ((opt = getopt(argc, argv, "i:")) != -1) {
+		switch (opt) {
+		case 'i':
+			ss_iteration = atoi(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
 	test_guest_debug_exceptions();
+	test_single_step_from_userspace(ss_iteration);
 
 	return 0;
 }
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
