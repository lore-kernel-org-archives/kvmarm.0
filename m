Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30231343D80
	for <kvmarm@lists.linux.dev>; Sat, 16 May 2026 18:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956264; cv=none; b=AlLz9EvnQ7XHLtPxfJrm/2Hb4U7dCtCVHEhhvV5crMa4/gvk+lnHmf0u0wT/aOZPQvW+HMN8DZmQtcw2wZIZVXzpPaa8gjCZ1MTJ7f+W4U70clyW1ZAyYycCm0qjjvELtgwupfnA67LMOb8GGfW/+MuqKHB/5EXfY13n6dFkcpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956264; c=relaxed/simple;
	bh=5KZ7qUudRVx69oZU53QLLwxihrHqBxwg4Go1w9hakIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CABO5LZqijnp+IG4+OYOq6dKjkczfCzD07YGK6mu8Evywov6jku3ySFcrJ5zmalqZqKtUIf6uFlzIP23oDiu2IfbksxGBA4h5Di1dk8QmVxjjKwKDfa2SXDYt706vWBRI9+SGcEqxPmoPmDYK7H9fv16WrgWg12JpRzlDiJJXKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NzugMphC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NzugMphC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E88A4388;
	Sat, 16 May 2026 11:30:55 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 116A73F85F;
	Sat, 16 May 2026 11:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778956260; bh=5KZ7qUudRVx69oZU53QLLwxihrHqBxwg4Go1w9hakIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzugMphCkvAxgEwnAiw0HL8w4i6xIvLxspyk1uirCke9E42/ZaKgM3o6JVD5e9js/
	 UY6fUQYC28HqV3ajKiNOW2SM0j0c8VoAfxp9dfG0WIMVrcEUQg0SS2TxIai5DtS+re
	 MTCd9uvsrx2P9v2KGNdqN/XeWDbhtKCkIOY0X+Qo=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 4/9] KVM: arm64: selftests: Enhance hello_nested test
Date: Sat, 16 May 2026 19:29:58 +0100
Message-ID: <20260516183003.799058-5-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516183003.799058-1-weilin.chang@arm.com>
References: <20260516183003.799058-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle an "add" hypercall in L1 to add 2 numbers passed by L2, and
return the result. This better tests our save/restore functionality.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 .../selftests/kvm/arm64/hello_nested.c        | 32 ++++++++++++++++++-
 .../selftests/kvm/include/arm64/nested.h      |  2 +-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
index 1cab56e4597b..9ed5285f5f2d 100644
--- a/tools/testing/selftests/kvm/arm64/hello_nested.c
+++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
@@ -11,6 +11,10 @@
 #define XLATE2GPA	(0xABCD)
 #define L2STACKSZ	(0x100)
 
+#define L2SUCCESS	(0x0)
+#define L2FAILED	(0x1)
+#define L2ADD		(0x2)
+
 /*
  * TPIDR_EL2 is used to store vcpu id, so save and restore it.
  */
@@ -31,7 +35,14 @@ static gpa_t ucall_translate_to_gpa(void *gva)
 
 static void l2_guest_code(void)
 {
-	do_hvc();
+	int ans = 0;
+
+	ans = do_hvc(L2ADD, 2, 3);
+
+	if (ans == 5)
+		do_hvc(L2SUCCESS, 0, 0);
+	else
+		do_hvc(L2FAILED, 0, 0);
 }
 
 static void guest_code(void)
@@ -42,6 +53,7 @@ static void guest_code(void)
 	gpa_t l2_pc, l2_stack_top;
 	/* force 16-byte alignment for the stack pointer */
 	u8 l2_stack[L2STACKSZ] __attribute__((aligned(16)));
+	u64 arg1, arg2;
 
 	GUEST_ASSERT_EQ(get_current_el(), 2);
 	GUEST_PRINTF("vEL2 entry\n");
@@ -55,6 +67,24 @@ static void guest_code(void)
 	ret = run_l2(&vcpu, &hyp_data);
 	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
 	GUEST_ASSERT_EQ(ESR_ELx_EC(read_sysreg(esr_el2)), ESR_ELx_EC_HVC64);
+
+	if (vcpu.context.regs.regs[0] == L2ADD) {
+		arg1 = vcpu.context.regs.regs[1];
+		arg2 = vcpu.context.regs.regs[2];
+		GUEST_PRINTF("L2 add request, arg1: %lx, arg2: %lx\n", arg1, arg2);
+		vcpu.context.regs.regs[0] = arg1 + arg2;
+	} else {
+		GUEST_FAIL("Unexpected hvc action\n");
+	}
+
+	ret = run_l2(&vcpu, &hyp_data);
+	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
+	GUEST_ASSERT_EQ(ESR_ELx_EC(read_sysreg(esr_el2)), ESR_ELx_EC_HVC64);
+
+	if (vcpu.context.regs.regs[0] != L2SUCCESS)
+		GUEST_FAIL("L2 failed\n");
+
+	GUEST_PRINTF("L2 success!\n");
 	GUEST_DONE();
 }
 
diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
index 30e626e427da..c10ef4a85be7 100644
--- a/tools/testing/selftests/kvm/include/arm64/nested.h
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -50,7 +50,7 @@ void prepare_hyp(void);
 void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top);
 int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
 
-void do_hvc(void);
+u64 do_hvc(u64 action, u64 arg1, u64 arg2);
 u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
 void __hyp_exception(u64 type);
 
-- 
2.43.0

