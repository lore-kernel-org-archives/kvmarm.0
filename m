Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8643C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FABA4BD65;
	Thu, 24 Feb 2022 12:26:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OFK75irXONvM; Thu, 24 Feb 2022 12:26:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 307A84BE5C;
	Thu, 24 Feb 2022 12:26:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE27A4BD36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pfviBqkw4DwR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:36 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 430144BE5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:36 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 x17-20020a17090ab01100b001bbffb2c5f3so3888599pjq.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jmsF+28/o9uCf/VQ6k2qhkTuRm6SZhX9vjCTItav4Nc=;
 b=MlN/UYTncICeUsEkBDYqjV04VlUXrjRCma8eYvTC2n4PabVyNlEk1LltoOc1rlbsP5
 BHwzTVQ0bQZgdqeFundXtet8O11tqSXdKmPvZbIYLXBL4MIStxKmsZImBmhLDRHyd9iP
 1zX0cIBwW73iTjZNiwjKfzYpr54Js+FLQ1vYuNh2gwffgJAyV1xpp2KAPiuOFZlMQ057
 X4dRf+jgoWGJTRdUWs7JthKJ9/YyXBuTdzWk6M/WKJw5dbEPLL2aShI6mjqHgWmaraNq
 RIB/mb6ecYxcpgdPaPcaT0j+eAXnz05OF+R9x5kVVeWEQ7R4G70Yoz6ESki6j1zEtlfP
 GMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jmsF+28/o9uCf/VQ6k2qhkTuRm6SZhX9vjCTItav4Nc=;
 b=pwHcPEZbgtVt+GRObRk7Q9jd+8gbysjiIxYo0gzpe//Bu093/MzSQ2yf8nqUYEfd2G
 xAuobVrn4Q7k66taCA9zwAQfKabuQqD0Yw6P7rIwSg3LvrUWUvzVHwZ2tp3yMIBhCejF
 VJv2NZOhweJGtxlx2HyaZebMVsAJ+DqzwdFUTsqKSbiIJGUjckGSTmt854ZCZOwGmzF7
 3gg77ITdpYFoOYcnjp+22AToV8aTKJfum5XljyMo5Hkfhrh1GznwdcIwIebf3acfpdTB
 fDv/3+ZNr89/c3a7XQJirRWb0nZ/oucCgTbDqHJYBEyz5vrnRJaiORtZmSbhuguyF8du
 3C8Q==
X-Gm-Message-State: AOAM532M6zAAsH/C4t4YwEME6i+xwmAvf6Ys7jOJVScFZluKE7jpW4vs
 Q2YnL2y7jCnfralacI4p9/tj256t53r0
X-Google-Smtp-Source: ABdhPJydh3IBl9/WqQAefokxf+CHH33yyX7uFA4vfoZVHfdfqGbdHQgTzulUJSpoukHYPflZqQVnV5VDQyf+
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:3ec2:b0:1b9:fbeb:942b with SMTP id
 rm2-20020a17090b3ec200b001b9fbeb942bmr15311322pjb.55.1645723595262; Thu, 24
 Feb 2022 09:26:35 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:58 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-13-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 12/13] selftests: KVM: aarch64: hypercalls: Test with
 KVM_CAP_ARM_REG_SCOPE
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Upgrade the aarch64/hypercalls test to also consider the
firmware register's scope information. Thus, run the test
with the capability KVM_CAP_ARM_REG_SCOPE disabled and enabled.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/hypercalls.c        | 83 +++++++++++++++++--
 1 file changed, 75 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index e4e3a286ff3e..85818b91b4fb 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -29,7 +29,7 @@ struct kvm_fw_reg_info {
 		.max_feat_bit = bit_max,	\
 	}
 
-static const struct kvm_fw_reg_info fw_reg_info[] = {
+static struct kvm_fw_reg_info fw_reg_info[] = {
 	FW_REG_INFO(KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_BMAP_BIT_MAX),
 	FW_REG_INFO(KVM_REG_ARM_STD_HYP_BMAP, KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX),
 	FW_REG_INFO(KVM_REG_ARM_VENDOR_HYP_BMAP, KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX),
@@ -294,19 +294,78 @@ static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
 	}
 }
 
-static struct kvm_vm *test_vm_create(void)
+static bool test_reg_is_bmap_fw_reg(uint64_t reg)
+{
+	if ((reg & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW &&
+		(reg & 0xffff) >= 0xff00) /* Bitmap firmware register space */
+		return true;
+
+	return false;
+}
+
+static void test_fw_regs_encode_vm_scope(void)
+{
+	int i;
+
+	/*
+	 * Encode the scope as KVM_REG_ARM_SCOPE_VM for further use
+	 * in KVM_SET_ONE_REG and KVM_GET_ONE_REG operations.
+	 */
+	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++)
+		fw_reg_info[i].reg |= (KVM_REG_ARM_SCOPE_VM << KVM_REG_ARM_SCOPE_SHIFT);
+}
+
+static void test_validate_fw_regs(struct kvm_vm *vm, int scope)
+{
+	uint64_t i, reg;
+	int obtained_scope;
+	struct kvm_reg_list *reg_list;
+
+	reg_list = vcpu_get_reg_list(vm, 0);
+
+	for (i = 0; i < reg_list->n; i++) {
+		reg = reg_list->reg[i];
+		if (!test_reg_is_bmap_fw_reg(reg))
+			continue;
+
+		/*
+		 * Depending on KVM_CAP_ARM_REG_SCOPE, currently all the firmware
+		 * bitmap registers are either completely VM-scoped or vCPU scoped.
+		 */
+		obtained_scope = (reg & KVM_REG_ARM_SCOPE_MASK) >> KVM_REG_ARM_SCOPE_SHIFT;
+		TEST_ASSERT(obtained_scope == scope,
+				"Incorrect scope detected for reg: %lx. Expected: %d; Obtained: %d\n",
+				reg, scope, obtained_scope);
+	}
+}
+
+static struct kvm_vm *test_vm_create(int scope)
 {
 	struct kvm_vm *vm;
+	struct kvm_enable_cap reg_scope_cap = {
+		.cap = KVM_CAP_ARM_REG_SCOPE,
+	};
+
+	if (scope == KVM_REG_ARM_SCOPE_VM && !kvm_check_cap(KVM_CAP_ARM_REG_SCOPE)) {
+		print_skip("Capability KVM_CAP_ARM_REG_SCOPE unavailable\n");
+		return NULL;
+	}
 
 	vm = vm_create_default(0, 0, guest_code);
 
 	ucall_init(vm, NULL);
 	steal_time_init(vm);
 
+	if (scope == KVM_REG_ARM_SCOPE_VM) {
+		vm_enable_cap(vm, &reg_scope_cap);
+		test_fw_regs_encode_vm_scope();
+	}
+
 	return vm;
 }
 
-static struct kvm_vm *test_guest_stage(struct kvm_vm *vm)
+static struct kvm_vm *
+test_guest_stage(struct kvm_vm *vm, int scope)
 {
 	struct kvm_vm *ret_vm = vm;
 
@@ -319,7 +378,7 @@ static struct kvm_vm *test_guest_stage(struct kvm_vm *vm)
 	case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		/* Start a new VM so that all the features are now enabled by default */
 		kvm_vm_free(vm);
-		ret_vm = test_vm_create();
+		ret_vm = test_vm_create(scope);
 		break;
 	case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
 	case TEST_STAGE_HVC_IFACE_FALSE_INFO:
@@ -334,14 +393,20 @@ static struct kvm_vm *test_guest_stage(struct kvm_vm *vm)
 	return ret_vm;
 }
 
-static void test_run(void)
+static void test_run(int scope)
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
 	bool guest_done = false;
 
-	vm = test_vm_create();
+	vm = test_vm_create(scope);
+	if (!vm)
+		return;
 
+	stage = TEST_STAGE_REG_IFACE;
+	sync_global_to_guest(vm, stage);
+
+	test_validate_fw_regs(vm, scope);
 	test_fw_regs_before_vm_start(vm);
 
 	while (!guest_done) {
@@ -349,7 +414,7 @@ static void test_run(void)
 
 		switch (get_ucall(vm, 0, &uc)) {
 		case UCALL_SYNC:
-			vm = test_guest_stage(vm);
+			vm = test_guest_stage(vm, scope);
 			break;
 		case UCALL_DONE:
 			guest_done = true;
@@ -371,6 +436,8 @@ int main(void)
 {
 	setbuf(stdout, NULL);
 
-	test_run();
+	test_run(KVM_REG_ARM_SCOPE_VCPU);
+	test_run(KVM_REG_ARM_SCOPE_VM);
+
 	return 0;
 }
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
