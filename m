Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41937C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB564BB77;
	Fri, 18 Nov 2022 20:35:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FSCSGKH7qj6t; Fri, 18 Nov 2022 20:35:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0E54BB90;
	Fri, 18 Nov 2022 20:35:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79DB84BB52
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RyEHvmYTC3nK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:34:59 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 290774B63B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:34:59 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 a23-20020a17090a8c1700b0021890040f7cso1539437pjo.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=e+ywn9anGlzmBRZYQfNE5JqRUvrYYtM9CuRcHhcOat8=;
 b=bUEChsSWxywmbXEODMnhpTArgpDXm8MaKA/SqgTjg5p+/RcYNX7S04/3xpu9J/Qvhd
 4bdagwUbiSdDxnx3tS0KF820eXh2iqkgSCqZDfRbzZHyloQR7cNnkjyTKyEuT6f4pI10
 8tKIXR4fa/bt7sTnMlIgnfjppTnjmh2lzOejjH/eCf9LxOD5caHM7jQPu+J7kwCDF9RB
 ooOOGe2F+sB/yW0Iak7LoRDXFnao07e5dDaQ6BfVTWKYFz8nLtcfxAGPgcnrQw6Wy4Sa
 aeVwQDjy46i3XYIrO35DtjIYTHDet8LPXqZ4MaG6IOPG/C9jabUyQMOrTAnz/MWzY9l1
 R0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=e+ywn9anGlzmBRZYQfNE5JqRUvrYYtM9CuRcHhcOat8=;
 b=KPDepHXTLGN2G0kfMREscyJI0ifLaETeGA/Edp1DP4Z6D8ybhTVF/i2ZNRO6fmuZhg
 n8orTa8e9haJdIISYxMRNoQARLfo8t5fCR5bhzYrkLYRITBueLGXM4/YW4FQgP6KvlLF
 3qzSKJkldDvGR2XCqjnitgJXgHoRcv9DKDsAWnvUp/NIJCwmBvZmhyVrnSeEnObAIn2Z
 BC+ifVHNOP2z8t0Xdy+pO3/PPYZeksVSV/1byRa6Yx7In8b2T1WliLwpSbjoJhdk8DC/
 JEiQvW5M9m5lQnpyvTediIc0ncOJLAKaCIVw13fOsEFYyS6ZSe914j3bfVAp0d17jqBx
 RGjA==
X-Gm-Message-State: ANoB5pmNVFjgHjKCefrwzljiAt4otqSkAuwg2g2dG72RklNRb6mAaEFW
 z+0hOGrWP9NMkHASWUDKi/KkQEg5Zqg=
X-Google-Smtp-Source: AA0mqf7PcgvXvqdOghYQniN0zB4c61iyewtOMCoU0bUVvjXFRgEWaXWMy7aEAP06rfFe12MZOAkzfOPPmU4=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:bd18:0:b0:562:3aed:e40c with SMTP id
 a24-20020a62bd18000000b005623aede40cmr10612946pff.2.1668821698375; Fri, 18
 Nov 2022 17:34:58 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:44 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: arm64: selftests: Enable single-step without a
 "full" ucall()
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add a new ucall hook, GUEST_UCALL_NONE(), to allow tests to make ucalls
without allocating a ucall struct, and use it to enable single-step
in ARM's debug-exceptions test.  Like the disable single-step path, the
enabling path also needs to ensure that no exclusive access sequences are
attempted after enabling single-step, as the exclusive monitor is cleared
on ERET from the debug exception taken to EL2.

The test currently "works" because clear_bit() isn't actually an atomic
operation... yet.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 21 ++++++++++---------
 .../selftests/kvm/include/ucall_common.h      |  8 +++++++
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index d86c4e4d1c82..c62ec4d7f6a3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -239,10 +239,6 @@ static void guest_svc_handler(struct ex_regs *regs)
 	svc_addr = regs->pc;
 }
 
-enum single_step_op {
-	SINGLE_STEP_ENABLE = 0,
-};
-
 static void guest_code_ss(int test_cnt)
 {
 	uint64_t i;
@@ -253,8 +249,16 @@ static void guest_code_ss(int test_cnt)
 		w_bvr = i << 2;
 		w_wvr = i << 2;
 
-		/* Enable Single Step execution */
-		GUEST_SYNC(SINGLE_STEP_ENABLE);
+		/*
+		 * Enable Single Step execution.  Note!  This _must_ be a bare
+		 * ucall as the ucall() path uses atomic operations to manage
+		 * the ucall structures, and the built-in "atomics" are usually
+		 * implemented via exclusive access instructions.  The exlusive
+		 * monitor is cleared on ERET, and so taking debug exceptions
+		 * during a LDREX=>STREX sequence will prevent forward progress
+		 * and hang the guest/test.
+		 */
+		GUEST_UCALL_NONE();
 
 		/*
 		 * The userspace will verify that the pc is as expected during
@@ -356,12 +360,9 @@ void test_single_step_from_userspace(int test_cnt)
 				break;
 			}
 
-			TEST_ASSERT(cmd == UCALL_SYNC,
+			TEST_ASSERT(cmd == UCALL_NONE,
 				    "Unexpected ucall cmd 0x%lx", cmd);
 
-			TEST_ASSERT(uc.args[1] == SINGLE_STEP_ENABLE,
-				    "Unexpected ucall action 0x%lx", uc.args[1]);
-
 			debug.control = KVM_GUESTDBG_ENABLE |
 					KVM_GUESTDBG_SINGLESTEP;
 			ss_enable = true;
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index bdd373189a77..1a6aaef5ccae 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -35,6 +35,14 @@ void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 
+/*
+ * Perform userspace call without any associated data.  This bare call avoids
+ * allocating a ucall struct, which can be useful if the atomic operations in
+ * the full ucall() are problematic and/or unwanted.  Note, this will come out
+ * as UCALL_NONE on the backend.
+ */
+#define GUEST_UCALL_NONE()	ucall_arch_do_ucall((vm_vaddr_t)NULL)
+
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
