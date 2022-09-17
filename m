Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C32C54EE9
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 01:06:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64C84BD44;
	Fri, 16 Sep 2022 21:06:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OtL2rh0NCOnd; Fri, 16 Sep 2022 21:06:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 552FF4BD35;
	Fri, 16 Sep 2022 21:06:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5991A4BCF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TB66q6qSnQez for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 21:06:19 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0729D4BD33
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:17 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-348608c1cd3so206244157b3.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 18:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=vSAVyhq4u4ked+75RMxOFmz9hyvsFzcpaxbyEdlNhRQ=;
 b=j/kC+EPcJBYntAqBP0Aqrkt6xDFsegaWD/ZmXCa3VDTCGnpYhKJKJLwhPo0rT+lLx9
 iYtU2c7fq2cww7WGpLeyTGjevYtklyKjkbe1+Hvuc4c+k77LxH0skV39S5hRT8e9PGbf
 drudQXuKnq/bfJWjM6sdxH232YCZrhHyCLHGSy+DGnb8r9J5a+NKw/C2BzrUU5myUFbc
 jqGRayAtTRihLPd+qKsRUMDaE8fdSyyMyUWeaSoFHQv5pjboIHGmIGB2J8KhB00Qfz2C
 2Gml7/SoLEy8rVQoqV/RZDAJDf+a77Z8EADQoBJYpQnVsg9DhgoSECZhKSSC8RSALhLl
 VEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=vSAVyhq4u4ked+75RMxOFmz9hyvsFzcpaxbyEdlNhRQ=;
 b=6mzZTnQf9IlZWqBupgnYmFwwOce7SEc9vG2rUHguSuUpocKzzN14X+nsY/b4lkj1C7
 ZE6MSPiSGhroFTxWgxNl0pAofMXRozCA04AA7B3/mHoWmUTgkUCR/UJLboUF60L10pKJ
 WmtGJKBI+OWx5pWonEWYPykG07b1r2ipoTOnkClYZoxFHeQW7/5X6XigpjELOOBAmcxV
 uomVzVIOfDxgb63YF3IC8cNtJrbRuoqyzShdUVs7KDxgdjgPCmIvyFnS8TCmGqSngBn4
 0YVRy60nCuP8wDKYh2NY3KPXRVEURqG7/ovXtt9qyn/Aw4IN7CHu2fRTYI0isFDRHypB
 GaXg==
X-Gm-Message-State: ACrzQf0nTUSUG1Ff3Et143/k405nuKx0xTrNd44Zqg7SygQuqCs5O0xU
 1NHmjAUOvgppCveTjOhXS9yFmCUcTNE=
X-Google-Smtp-Source: AMsMyM6KDY96ug0OSKbbC3uFEUYKiw4o02BdQW8tmh3ooObxt8Azn6qGZMMdvxeh69GBQLRHrPi4iSC2wH0=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:63c4:0:b0:349:543f:99f3 with SMTP id
 x187-20020a8163c4000000b00349543f99f3mr6570759ywb.392.1663376777646; Fri, 16
 Sep 2022 18:06:17 -0700 (PDT)
Date: Fri, 16 Sep 2022 18:06:00 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-5-reijiw@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: selftests: Add a test case for
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
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
