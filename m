Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04CFC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 18:04:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DB686142F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 18:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DB686142F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80DAC4B4D3;
	Wed, 21 Apr 2021 14:04:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qr+ALbwC1BHs; Wed, 21 Apr 2021 14:04:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7D34B4B6;
	Wed, 21 Apr 2021 14:04:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D63B4B1E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 09:49:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pPlrCnZv8ElI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 09:49:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C56A4B1D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 09:49:32 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 715C261439;
 Wed, 21 Apr 2021 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619012969;
 bh=3JOEoDIfnaWwGOlo+8UCRIcFvWxqNH742UwCb6Bunsw=;
 h=From:To:Cc:Subject:Date:From;
 b=AJni0jwQfWQGMuhJ1iw9JPbOb3fZ6nT1Ti0gxEaAYRcrOfru1mmcChSuiLoWY1Mo/
 H9Y3m9xrHuVVPGh8JYLHKE5jH6YopLIXA3oRDubPbnLqw/Q0B/OZi7TSfGXo1sLV6q
 Ts+vD1yvplPmi8u7/SpcVzCD+tdsTQMToYbdgxlAGQHcbvpl/HZ4OAn6JAHyI2ehFJ
 wqefYwsEvSw5Vm7ABNjS14SNFKP1J4aojQjbb0PdXHF3zsmYz5JAqiQEOSNJKXpnx6
 yHE5b7EjOOu5O9hsIc8lq3QbwGVtSM5BGp3ZU8NlBkMBiaklHiMeUwYlfroUjBhW7z
 P/I2acEcaNQnw==
From: Arnd Bergmann <arnd@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: build perf support only when enabled
Date: Wed, 21 Apr 2021 15:49:01 +0200
Message-Id: <20210421134922.3309033-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 21 Apr 2021 14:04:15 -0400
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

From: Arnd Bergmann <arnd@arndb.de>

The perf_num_counters() function is only defined when CONFIG_PERF_EVENTS
is enabled:

arch/arm64/kvm/perf.c: In function 'kvm_perf_init':
arch/arm64/kvm/perf.c:58:43: error: implicit declaration of function 'perf_num_counters'; did you mean 'dec_mm_counter'? [-Werror=implicit-function-declaration]
   58 |         if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0
      |                                           ^~~~~~~~~~~~~~~~~

Use conditional compilation to disable this feature entirely when
CONFIG_PERF_EVENTS is disabled in the host.

Fixes: 6b5b368fccd7 ("KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static key")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Not sure if this is the correct symbol to check for, but this is
one way to avoid the build failure.
---
 arch/arm64/kvm/Makefile | 4 +++-
 arch/arm64/kvm/arm.c    | 8 +++++---
 include/kvm/arm_pmu.h   | 7 +++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 589921392cb1..9adf12ba5047 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_KVM) += hyp/
 
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
-	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
@@ -24,4 +24,6 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
+kvm-$(CONFIG_PERF_EVENTS) += perf.o
+
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4808aca8c87c..720e075c70f9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1694,7 +1694,8 @@ static int init_subsystems(void)
 	if (err)
 		goto out;
 
-	kvm_perf_init();
+	if (IS_ENABLED(CONFIG_PERF_EVENTS))
+		kvm_perf_init();
 	kvm_sys_reg_table_init();
 
 out:
@@ -1899,7 +1900,8 @@ static int init_hyp_mode(void)
 	return 0;
 
 out_err:
-	teardown_hyp_mode();
+	if (IS_ENABLED(CONFIG_PERF_EVENTS))
+		teardown_hyp_mode();
 	kvm_err("error initializing Hyp mode: %d\n", err);
 	return err;
 }
@@ -2101,7 +2103,7 @@ int kvm_arch_init(void *opaque)
 
 out_hyp:
 	hyp_cpu_pm_exit();
-	if (!in_hyp_mode)
+	if (!IS_ENABLED(CONFIG_PERF_EVENTS) && in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
 	return err;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6fd3cda608e4..d84307a1ebd5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -13,12 +13,19 @@
 #define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
 #define ARMV8_PMU_MAX_COUNTER_PAIRS	((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
 
+#ifdef CONFIG_PERF_EVENTS
 DECLARE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
 static __always_inline bool kvm_arm_support_pmu_v3(void)
 {
 	return static_branch_likely(&kvm_arm_pmu_available);
 }
+#else
+static __always_inline bool kvm_arm_support_pmu_v3(void)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_HW_PERF_EVENTS
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
