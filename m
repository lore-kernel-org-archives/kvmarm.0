Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BFCC43219
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC556408B3;
	Fri, 11 Mar 2022 12:41:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i9CtwEXtfRmG; Fri, 11 Mar 2022 12:41:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F8D49F07;
	Fri, 11 Mar 2022 12:41:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F59949ED2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MqQkjbE7aC-M for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:15 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB6CD40D26
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:13 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 e23-20020a6b6917000000b006406b9433d6so6733942ioc.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=15ALodezktg5rSBXdOu3gPy5I4IPaYXdBd1Dvt3rcGg=;
 b=lwoYMy7NpxI1EiS0XM6ypEpQgLVOw071V+L89QlSMkRaf87mBw3mzZlySHfIduSlRs
 UGiRiAafOdifDlW+2+O5uiVMZ1UEwUP9mbvJfk2081+Jsn9NHTRtxRpj9I3MYbZzOcjZ
 lv00KWYeGc+ZqpcHp0qX5pZ/4hLpMOj4zY6xguyd8akJ34km9/ptGYplndcfTkGcgum+
 de+1DIjXj70ysGjwH8IpcMa8o1Jek/0gTc6CYkTFMEh4UH4teKP6nbORVgS6f2ihxtbb
 KL4MEWTKIMcwMvJp0ogTZVV3OMZbKpOwt7gJ3cHc2mWepASwsTL76R3+l4hkGZfGbFHr
 33+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=15ALodezktg5rSBXdOu3gPy5I4IPaYXdBd1Dvt3rcGg=;
 b=7w/4cQGLFp7yvZX34+JAlsViWB/HnvvBO9hJr9EkuPLFVMmCGlfakbUpPVevZTKHpk
 6gYmqLsrCv1KtQHtKYZobAsWOkNo3dclripzl2HIc671laBDkyjBj56hh377ukMeeB6x
 7BVjucSIMN420obcEMWNCJdLr6XLFZgcUw2KBf5E9eTc/5jooHH4SBhTAHqBtv7Gy8Bp
 RYD0oslSUhNvePbULmYxc7FjaZsiOJNuQ3b61WWJbJHtE54e4X9mjUtf5dNMuyDpMpSS
 LxSo73rzMGNyyHPycBCcXlLUsFLzm+ir+R46S9jmQ/jrHPE0+3DEpS8Fzk5UvdVa7XU8
 K07g==
X-Gm-Message-State: AOAM532x9aTTUsevZu5hYUKqtNkVhsInCT1hD9J7Lb+n9qMv7IuQTiV0
 0r3CR9xg/CHTUhNLrMeL76flvTY32X/cEmu96gvZfZNnYkMatVEBGF1EA8Ihpg86sBGiqN/0Agf
 tNUbF010cuBLB1EEzCo+5WyGZb1R3B2VUXgFeBZKR274c/67M5uXhWQPdfQj4DvBEUuPTuw==
X-Google-Smtp-Source: ABdhPJzTKNFdb6MhKjGYU0UAr2AraFi1txIlqJ0CpXPiOl8IoC78/RPrJs9+Fap/wy9Bw2ot6ILX0F6U5X4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:84c5:0:b0:60b:bd34:bb6f with
 SMTP id
 z5-20020a5d84c5000000b0060bbd34bb6fmr8933660ior.32.1647020473264; Fri, 11 Mar
 2022 09:41:13 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:58 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-13-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 12/15] selftests: KVM: Create helper for making SMCCC calls
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

The PSCI and PV stolen time tests both need to make SMCCC calls within
the guest. Create a helper for making SMCCC calls and rework the
existing tests to use the library function.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 25 ++++++-------------
 .../selftests/kvm/include/aarch64/processor.h | 22 ++++++++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 25 +++++++++++++++++++
 tools/testing/selftests/kvm/steal_time.c      | 13 +++-------
 4 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 4c5f6814030f..8c998f0b802c 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -26,32 +26,23 @@
 static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
 			    uint64_t context_id)
 {
-	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_CPU_ON;
-	register uint64_t x1 asm("x1") = target_cpu;
-	register uint64_t x2 asm("x2") = entry_addr;
-	register uint64_t x3 asm("x3") = context_id;
+	struct arm_smccc_res res;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
-	    : "memory");
+	smccc_hvc(PSCI_0_2_FN64_CPU_ON, target_cpu, entry_addr, context_id,
+		  0, 0, 0, 0, &res);
 
-	return x0;
+	return res.a0;
 }
 
 static uint64_t psci_affinity_info(uint64_t target_affinity,
 				   uint64_t lowest_affinity_level)
 {
-	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_AFFINITY_INFO;
-	register uint64_t x1 asm("x1") = target_affinity;
-	register uint64_t x2 asm("x2") = lowest_affinity_level;
+	struct arm_smccc_res res;
 
-	asm("hvc #0"
-	    : "=r"(x0)
-	    : "r"(x0), "r"(x1), "r"(x2)
-	    : "memory");
+	smccc_hvc(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level,
+		  0, 0, 0, 0, 0, &res);
 
-	return x0;
+	return res.a0;
 }
 
 static void guest_main(uint64_t target_cpu)
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..59ece9d4e0d1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -185,4 +185,26 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+/**
+ * struct arm_smccc_res - Result from SMC/HVC call
+ * @a0-a3 result values from registers 0 to 3
+ */
+struct arm_smccc_res {
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+};
+
+/**
+ * smccc_hvc - Invoke a SMCCC function using the hvc conduit
+ * @function_id: the SMCCC function to be called
+ * @arg0-arg6: SMCCC function arguments, corresponding to registers x1-x7
+ * @res: pointer to write the return values from registers x0-x3
+ *
+ */
+void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
+	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
+	       uint64_t arg6, struct arm_smccc_res *res);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..6a041289fa80 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -500,3 +500,28 @@ void __attribute__((constructor)) init_guest_modes(void)
 {
        guest_modes_append_default();
 }
+
+void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
+	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
+	       uint64_t arg6, struct arm_smccc_res *res)
+{
+	asm volatile("mov   w0, %w[function_id]\n"
+		     "mov   x1, %[arg0]\n"
+		     "mov   x2, %[arg1]\n"
+		     "mov   x3, %[arg2]\n"
+		     "mov   x4, %[arg3]\n"
+		     "mov   x5, %[arg4]\n"
+		     "mov   x6, %[arg5]\n"
+		     "mov   x7, %[arg6]\n"
+		     "hvc   #0\n"
+		     "mov   %[res0], x0\n"
+		     "mov   %[res1], x1\n"
+		     "mov   %[res2], x2\n"
+		     "mov   %[res3], x3\n"
+		     : [res0] "=r"(res->a0), [res1] "=r"(res->a1),
+		       [res2] "=r"(res->a2), [res3] "=r"(res->a3)
+		     : [function_id] "r"(function_id), [arg0] "r"(arg0),
+		       [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3),
+		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
+		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
+}
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 62f2eb9ee3d5..8c4e811bd586 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -118,17 +118,10 @@ struct st_time {
 
 static int64_t smccc(uint32_t func, uint64_t arg)
 {
-	unsigned long ret;
+	struct arm_smccc_res res;
 
-	asm volatile(
-		"mov	w0, %w1\n"
-		"mov	x1, %2\n"
-		"hvc	#0\n"
-		"mov	%0, x0\n"
-	: "=r" (ret) : "r" (func), "r" (arg) :
-	  "x0", "x1", "x2", "x3");
-
-	return ret;
+	smccc_hvc(func, arg, 0, 0, 0, 0, 0, 0, &res);
+	return res.a0;
 }
 
 static void check_status(struct st_time *st)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
