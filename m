Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478F2C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02D1E4B1E7;
	Tue,  3 May 2022 23:25:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aaFM0+tGi4bC; Tue,  3 May 2022 23:25:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7CF24B23C;
	Tue,  3 May 2022 23:25:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F4264B0F7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hcTJRJFDLeuF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:10 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A1C94B216
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:09 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 t14-20020a1709028c8e00b0015cf7e541feso145488plo.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QEqWR8OKdUM2DdgBqD6OFYZ64t35sJlXXS4QuEZbCRM=;
 b=Fa7BPZq5pmfBzaOlrfx5XwVeQW/aHZvcmKSXrMDnNtCwcLwz+4Qtvy+Ii28OICIF0I
 ylx7fYAdxwiuACZCycioQsxIoaZKjozC/uPLaXBhgYNVFwC1Z66dC1e727JX6HndLjlZ
 8cKxit+ttxUL9Z4GVWGqyFCL6puQzFm89odKtZ7n1cHIQd/WZjJH3phlRUJAB8el7sts
 tmoUK64dW4VfN556vZMqOx5tRkRNbp8N7qGH5GuzmmzbS0djyspfNUIMRDaFDGaU39xI
 hViVo3ma6jAVuljuz0tkm67jO7ZLd0X8vHLNUFarAlfRilHtBuxZXii4n3ImsnEYEahp
 unSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QEqWR8OKdUM2DdgBqD6OFYZ64t35sJlXXS4QuEZbCRM=;
 b=2uFS1lrGisz6DBI2rfCu6F163aHIe8PdpuduZQLi9JjH1qPetibCjvnWXMnzfBxM2B
 17wH3bU4nxAlYgCsJV0jvwb8PE3vDZxTVZk4vd0L86trbfaF7HXMqruqOQbeQdjnurah
 CwsBeqTgcSPdPDfB1HcL+iJr7rc1K/STY8J84N+Sa1QJBwtlqswygsB1B7O+REF22iFN
 M2oLBI59D/2sFJAtB5s1w9i8GcK+i/U7HuthxjUprkAxbN6LpnDabExw4ZxayJdGZq47
 1gTJuZtOkfTRd9+86HWg1iymkQyEDFUrT+4bsSHcNuglKgbQ/UouD8x0mRtJn6B4aRsf
 PCjA==
X-Gm-Message-State: AOAM5325bt4WpqGIDxhDLm88sO1isbiZDmzwc0/c2osR1y6dGuPKWtIe
 BOnXFd4vwJfxI7yNuL7A+BHzCAdpGtNyozjWxC0S9IOAW8YeLhcKaPiYBHsZ7YrJGRzkfP5k/wJ
 uJMjoIVlu/FKnlla00WHS6CBGjnpqWEXKuArUm9OBTHesCjfQJr4boSNf0NYbLLEiH/I6fw==
X-Google-Smtp-Source: ABdhPJzVxal57eFE0hqSN2pEmR/JPezB6ZtDfnKnpAjSKSaYy8GklWhtq929HlbdL6L1Um3kd8K5mUpyylA=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:e510:b0:1d8:39b3:280b with SMTP id
 t16-20020a17090ae51000b001d839b3280bmr8310639pjy.142.1651634708442; Tue, 03
 May 2022 20:25:08 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:43 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-10-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 09/12] selftests: KVM: Create helper for making SMCCC calls
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
