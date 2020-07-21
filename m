Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B51BC433EC
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D545720792
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqhSzg4Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D545720792
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2CE4B1D7;
	Tue, 21 Jul 2020 09:31:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B1Eu6pfUAS6o; Tue, 21 Jul 2020 09:31:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287E84B1D9;
	Tue, 21 Jul 2020 09:31:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 466804B13A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qnyn0MtGNRuF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 00:18:09 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBDCA4B23A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:08 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id w2so11327393pgg.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 21:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=QhRkRM1m4qgsAo9eZ39otcpFvlPpO24W7mp8anbogBw=;
 b=bqhSzg4QOmAx8vDaoW+qgWApTlOrQm4qYUFBFPFk5eJ0mJKUnH+PBOy0rrPoVLuSvj
 G5nYm2pK68MYqj6x+TCFJB+f5jSKEM8VQr4aztw9FuTmTF+mMsEgmg/KgI32RN54P7bo
 Bn2WB2MaubV4PEisl9ole2vBWAje7/6zJzcOgvSaMXBVKWeu1m54/+zJ11AFQ9IAPZFj
 91rrJTGVdFDuaP2F5FGqiWP3c4TtwHUsRxjZmJ/tHtgrRdyF4+P1bosWHGypJBEIDb/5
 Aw3/2v/i3mKymhzPQPRC/tYJPoKK3JPXXYId/NMpEGilerA3j8tWesrhzp4XC8U4VWSl
 qwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=QhRkRM1m4qgsAo9eZ39otcpFvlPpO24W7mp8anbogBw=;
 b=N0URV5AS70cTPqGfdmClsWH//PRkNeZ8YIjceBx6+suTlrrDYVGfPfMu8o+8ct0Hq/
 tqxZ/yI2xxQRDGCBBUvgsBQ6mdsxb3SvSLw2R12Iv1rjvs7LbY3LJ4De1K3zurV/iA7o
 BTbgMVM8LSYIBeCMJh6hrDaM2C7jjI01hi1j0Ptmmum6D2ucnjsbaS5vqAQTyGnRpRE/
 MwvF78J8gmE0A2/C67k3hnc+aji0ghhLyszoNqvmYZvbVhRQEbC4u+cpnsiXkGVCwHA1
 YuDrpcNYTs1KJcQnqth5G6E5Ir9ifD7SffqJIU4ruVIfFzOvFHK9KHGWMe7RLGx3Bqa1
 1SCg==
X-Gm-Message-State: AOAM533z7K5aBEuhAbOUc8fkS61Im9cUgtLOHlZxx+OVghodhNiQyNBI
 tNLNHMdlHzikOepayxN6xHU=
X-Google-Smtp-Source: ABdhPJx4iEq46mQUJiDEqXIx/wrx7qJP7HCND86/POVGHX0/iSnb09hQdnlfUa/C3gaz4EjedXYGBg==
X-Received: by 2002:aa7:9a84:: with SMTP id w4mr21905832pfi.13.1595305088045; 
 Mon, 20 Jul 2020 21:18:08 -0700 (PDT)
Received: from localhost.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id
 e28sm18467270pfm.177.2020.07.20.21.18.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 21:18:07 -0700 (PDT)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC][PATCH 2/4] arm64: add guest pvstate support
Date: Tue, 21 Jul 2020 13:17:40 +0900
Message-Id: <20200721041742.197354-3-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 21 Jul 2020 09:31:48 -0400
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
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

PV-state is a per-CPU struct, which, for the time being,
holds boolean `preempted' vCPU state. During the startup,
given that host supports PV-state, each guest vCPU sends
a pointer to its per-CPU variable to the host as a payload
with the SMCC HV call, so that host can update vCPU state
when it puts or loads vCPU.

This has impact on the guest's scheduler - it does check
the state of the vCPU it wants to run a task on:

[..]
  wake_up_process()
   try_to_wake_up()
    select_task_rq_fair()
     available_idle_cpu()
      vcpu_is_preempted()

Some sched benchmarks data is available on the github page [0].

[0] https://github.com/sergey-senozhatsky/arm64-vcpu_is_preempted
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 arch/arm64/include/asm/paravirt.h  |  15 ++++
 arch/arm64/kernel/Makefile         |   2 +-
 arch/arm64/kernel/paravirt-state.c | 117 +++++++++++++++++++++++++++++
 arch/arm64/kernel/paravirt.c       |   4 +-
 arch/arm64/kernel/time.c           |   1 +
 5 files changed, 137 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kernel/paravirt-state.c

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index cf3a0fd7c1a7..1bf164b2041b 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -7,12 +7,22 @@ struct static_key;
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
 
+struct pvstate_vcpu_info {
+	bool	preempted;
+	u8	reserved[63];
+};
+
+struct pv_state_ops {
+	bool (*vcpu_is_preempted)(int cpu);
+};
+
 struct pv_time_ops {
 	unsigned long long (*steal_clock)(int cpu);
 };
 
 struct paravirt_patch_template {
 	struct pv_time_ops time;
+	struct pv_state_ops state;
 };
 
 extern struct paravirt_patch_template pv_ops;
@@ -22,10 +32,15 @@ static inline u64 paravirt_steal_clock(int cpu)
 	return pv_ops.time.steal_clock(cpu);
 }
 
+bool native_vcpu_is_preempted(int cpu);
+bool paravirt_vcpu_is_preempted(int cpu);
+
+int __init pv_state_init(void);
 int __init pv_time_init(void);
 
 #else
 
+#define pv_state_init() do {} while (0)
 #define pv_time_init() do {} while (0)
 
 #endif // CONFIG_PARAVIRT
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 5fb9b728459b..18974d5e798d 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_ARMV8_DEPRECATED)		+= armv8_deprecated.o
 obj-$(CONFIG_ACPI)			+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)			+= acpi_numa.o
 obj-$(CONFIG_ARM64_ACPI_PARKING_PROTOCOL)	+= acpi_parking_protocol.o
-obj-$(CONFIG_PARAVIRT)			+= paravirt.o
+obj-$(CONFIG_PARAVIRT)			+= paravirt.o paravirt-state.o
 obj-$(CONFIG_RANDOMIZE_BASE)		+= kaslr.o
 obj-$(CONFIG_HIBERNATION)		+= hibernate.o hibernate-asm.o
 obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
diff --git a/arch/arm64/kernel/paravirt-state.c b/arch/arm64/kernel/paravirt-state.c
new file mode 100644
index 000000000000..4ae92a84c73d
--- /dev/null
+++ b/arch/arm64/kernel/paravirt-state.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define pr_fmt(fmt) "arm-pvstate: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/cpuhotplug.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/jump_label.h>
+#include <linux/printk.h>
+#include <linux/psci.h>
+#include <linux/reboot.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <asm/paravirt.h>
+#include <asm/smp_plat.h>
+
+static DEFINE_PER_CPU(struct pvstate_vcpu_info, vcpus_states);
+
+bool native_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
+
+static bool pv_vcpu_is_preempted(int cpu)
+{
+	struct pvstate_vcpu_info *st;
+
+	st = &per_cpu(vcpus_states, cpu);
+	return READ_ONCE(st->preempted);
+}
+
+bool paravirt_vcpu_is_preempted(int cpu)
+{
+	return pv_ops.state.vcpu_is_preempted(cpu);
+}
+
+static bool has_pvstate(void)
+{
+	struct arm_smccc_res res;
+
+	/* To detect the presence of PV time support we require SMCCC 1.1+ */
+	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
+		return false;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_HV_PV_STATE_FEATURES,
+			     &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return false;
+	return true;
+}
+
+static int __pvstate_cpu_hook(unsigned int cpu, int event)
+{
+	struct arm_smccc_res res;
+	struct pvstate_vcpu_info *st;
+
+	st = &per_cpu(vcpus_states, cpu);
+	arm_smccc_1_1_invoke(event, virt_to_phys(st), &res);
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return -EINVAL;
+	return 0;
+}
+
+static int pvstate_cpu_init(unsigned int cpu)
+{
+	int ret = __pvstate_cpu_hook(cpu, ARM_SMCCC_HV_PV_STATE_INIT);
+
+	if (ret)
+		pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_INIT\n");
+	return ret;
+}
+
+static int pvstate_cpu_release(unsigned int cpu)
+{
+	int ret = __pvstate_cpu_hook(cpu, ARM_SMCCC_HV_PV_STATE_RELEASE);
+
+	if (ret)
+		pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_RELEASE\n");
+	return ret;
+}
+
+static int pvstate_register_hooks(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
+			"hypervisor/arm/pvstate:starting",
+			pvstate_cpu_init,
+			pvstate_cpu_release);
+	if (ret < 0)
+		pr_warn("Failed to register CPU hooks\n");
+	return ret;
+}
+
+static int __pvstate_init(void)
+{
+	return pvstate_register_hooks();
+}
+
+int __init pv_state_init(void)
+{
+	int ret;
+
+	if (!has_pvstate())
+		return 0;
+
+	ret = __pvstate_init();
+	if (ret)
+		return ret;
+
+	pv_ops.state.vcpu_is_preempted = pv_vcpu_is_preempted;
+	return 0;
+}
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 295d66490584..3fec7563ac27 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -26,7 +26,9 @@
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 
-struct paravirt_patch_template pv_ops;
+struct paravirt_patch_template pv_ops = {
+	.state.vcpu_is_preempted = native_vcpu_is_preempted,
+};
 EXPORT_SYMBOL_GPL(pv_ops);
 
 struct pv_time_stolen_time_region {
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index eebbc8d7123e..50c55792f72b 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -68,4 +68,5 @@ void __init time_init(void)
 	lpj_fine = arch_timer_rate / HZ;
 
 	pv_time_init();
+	pv_state_init();
 }
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
