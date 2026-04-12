Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEF737C911
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003778; cv=none; b=oRl6WqAi7QfcF0eQeQpCpm0r4jm2QsBQ/oH43ICLvMGJGu/eGo29JNDsH0qK8SII6MCuDMJIbyFTVASSUh9+HSVMl0WV2Rs/oLA3bKKTWwPZSiAr3CbY5gImn07TcCHGqnrqcTWzKGCsjrEnGvvlhJbq8UhQQVME41+cu1dCkAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003778; c=relaxed/simple;
	bh=QPplt9v5p8kVai7ekd7bomvey9xBlngaWafbaC0iH44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsor5M8YVYFrxenby8RycON0IucS07Yr8LtAXPk1oR5hmO3AHEIXn54S6QidGDtvREkoGbdHKH+vHxw0IERKYbb09GFkYZyj/Xj1GpTAupsWUxiB4ogUNhKxAN1J4SYt3UktWHBnJi5caA/l/HHKc8MVtKvP5UNjIhI5EgYCf34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O/BlMV5k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O/BlMV5k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7ED124CE5;
	Sun, 12 Apr 2026 07:22:49 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A9833F641;
	Sun, 12 Apr 2026 07:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776003775; bh=QPplt9v5p8kVai7ekd7bomvey9xBlngaWafbaC0iH44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/BlMV5kcl4IHyUZ+uWlPgQryQNHL3bCFMsZCtItLiZ4YoyMtIeoNB2MYXt7qOMFC
	 Kb75HPkWom7dHxlo5Ly7xcUByt/Byn8uFK+5mU2xKD3DN22h9Lxw8RKh/Ekel4OEmu
	 Ehyrn6pcI5NX/FriRF0MdgfzfO8oeMFKorpn1gR0=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 4/4] KVM: arm64: selftests: Enhance hello_nested test
Date: Sun, 12 Apr 2026 15:22:16 +0100
Message-ID: <20260412142216.3806482-5-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260412142216.3806482-1-weilin.chang@arm.com>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
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
 .../selftests/kvm/arm64/hello_nested.c        | 31 ++++++++++++++++++-
 .../selftests/kvm/include/arm64/nested.h      |  2 +-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
index 97387e4697b3..69f4d8e750e2 100644
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
@@ -31,7 +35,14 @@ static vm_paddr_t ucall_translate_to_gpa(void *gva)
 
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
 	vm_paddr_t l2_pc, l2_stack_top;
 	/* force 16-byte alignment for the stack pointer */
 	u8 l2_stack[L2STACKSZ] __attribute__((aligned(16)));
+	u64 arg1, arg2;
 
 	GUEST_ASSERT_EQ(get_current_el(), 2);
 	GUEST_PRINTF("vEL2 entry\n");
@@ -54,6 +66,23 @@ static void guest_code(void)
 
 	ret = run_l2(&vcpu, &hyp_data);
 	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
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
+
+	if (vcpu.context.regs.regs[0] != L2SUCCESS)
+		GUEST_FAIL("L2 failed\n");
+
+	GUEST_PRINTF("L2 success!\n");
 	GUEST_DONE();
 }
 
diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
index 7928ef89494a..b16a72488858 100644
--- a/tools/testing/selftests/kvm/include/arm64/nested.h
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -50,7 +50,7 @@ void prepare_hyp(void);
 void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top);
 int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
 
-void do_hvc(void);
+u64 do_hvc(u64 action, u64 arg1, u64 arg2);
 u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
 void __hyp_exception(u64 type);
 
-- 
2.43.0

