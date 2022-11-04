Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB93C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 06:21:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAEC54B105;
	Fri,  4 Nov 2022 02:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fh-D+37jvGeC; Fri,  4 Nov 2022 02:21:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6164B0D0;
	Fri,  4 Nov 2022 02:21:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2001B49E1A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:21:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bOPWnKiDs6z7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 02:21:20 -0400 (EDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB4B140EEF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:21:19 -0400 (EDT)
Received: by mail-wr1-f51.google.com with SMTP id o4so5684056wrq.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 23:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=xbUgkqdqlP0TXRThV9fNUb23PL+ZSNiv2lV8h+vDI6o=;
 b=imUXex4ARPKocmDM9ipkZFuRSOQjZGPCh8xCGhXhPFszelxiFFYyzabJtWVOBqRsOn
 UrXbYxEOedDge+aDjd+JMoQe74wgIAE/Ea0AiiaSAafhUiDs9eWNbgHHUNAec+UGqoZA
 nabhdH6HPcmnkSxd0xsffa/wZa7MwXCnhRPfhv/6a/wPALBI7yBrUQHYJdQoHPQkMMF6
 5jxd2vhLH9BwfRoCPodbrVlU7ta4IP5DRxrtw+n3eG5FOS4e3zgirCjShSh1jjHA3X9I
 o6uvV9ccxY/7c0V/5qZYHfV68GVxUBXiWyXYjvSoOkoEtKZEYMqWxQsRNuxbJJb6H3n4
 vpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=xbUgkqdqlP0TXRThV9fNUb23PL+ZSNiv2lV8h+vDI6o=;
 b=uS5iLM1pulAGCHyMlo6NcBVQY63EFeRpGFz3UfenA7dEd/CPDpjMmyCLNHLyYbzZNP
 a5W1cEZIgc93L6cseN5e6Y/93OOQ9QuX1yXTmJaAnHQVDbpgt4B+MGA6bToUzKWXnw/G
 2jRTQBbrRYrtKrm0tfBE7hjCnq9vAFOqSeZsoDLygjywii9QLFa+et5coRDJ+UcJSSwH
 zZ1baHqiDm5vNHQok9FzOIMUFNIrCuxPQbVinYdCkVDhWiRw2MLhoWMPdQ8egeUOaWxE
 R6BZ2lxMe+lfP8jNsPNRSixUTkluygeVTPryhx/Y2CzuM+kOZ1HaAa+NUYLmZ5ilOvNJ
 TUtQ==
X-Gm-Message-State: ACrzQf2dL6FrDAWWQQ+fHUpBEG9X9gcQM0fNSjB+kHYWADjMBwfZDsbE
 3QJjm+NP3nr+T0h0986Ldb1ysw==
X-Google-Smtp-Source: AMsMyM4RzfHZlEHKZapvxe+7lxyCsG2p54jnJRbUQA/hxMV9BGQ3GTc1YIfiW7CSzL6Q8YMCkxvWqQ==
X-Received: by 2002:a05:6000:1201:b0:236:61f4:b384 with SMTP id
 e1-20020a056000120100b0023661f4b384mr20419434wrx.505.1667542878791; 
 Thu, 03 Nov 2022 23:21:18 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
 by smtp.gmail.com with ESMTPSA id
 w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 23:21:18 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com,
 mark.rutland@arm.com, bagasdotme@gmail.com
Subject: [v2 5/6] KVM: arm64: Support the VCPU preemption check
Date: Fri,  4 Nov 2022 06:21:04 +0000
Message-Id: <20221104062105.4119003-6-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

Support the vcpu_is_preempted() functionality under KVM/arm64. This will
enhance lock performance on overcommitted hosts (more runnable VCPUs
than physical CPUs in the system) as doing busy waits for preempted
VCPUs will hurt system performance far worse than early yielding.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/paravirt.h |   2 +
 arch/arm64/include/asm/spinlock.h |  16 ++++-
 arch/arm64/kernel/paravirt.c      | 112 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c         |   3 +
 include/linux/cpuhotplug.h        |   1 +
 5 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 9aa193e0e8f2..4ccb4356c56b 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -19,10 +19,12 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_time_init(void);
+int __init pv_lock_init(void);
 
 #else
 
 #define pv_time_init() do {} while (0)
+#define pv_lock_init() do {} while (0)
 
 #endif // CONFIG_PARAVIRT
 
diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index 0525c0b089ed..7023efa4de96 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -10,7 +10,20 @@
 
 /* See include/linux/spinlock.h */
 #define smp_mb__after_spinlock()	smp_mb()
+#define vcpu_is_preempted vcpu_is_preempted
+
+#ifdef CONFIG_PARAVIRT
+#include <linux/static_call_types.h>
+
+bool dummy_vcpu_is_preempted(int cpu);
 
+DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
+static inline bool vcpu_is_preempted(int cpu)
+{
+	return static_call(pv_vcpu_is_preempted)(cpu);
+}
+
+#else
 /*
  * Changing this will break osq_lock() thanks to the call inside
  * smp_cond_load_relaxed().
@@ -18,10 +31,11 @@
  * See:
  * https://lore.kernel.org/lkml/20200110100612.GC2827@hirez.programming.kicks-ass.net
  */
-#define vcpu_is_preempted vcpu_is_preempted
 static inline bool vcpu_is_preempted(int cpu)
 {
 	return false;
 }
 
+#endif /* CONFIG_PARAVIRT */
+
 #endif /* __ASM_SPINLOCK_H */
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 57c7c211f8c7..a340f5f4327f 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -20,8 +20,10 @@
 #include <linux/types.h>
 #include <linux/static_call.h>
 
+#include <asm/hypervisor.h>
 #include <asm/paravirt.h>
 #include <asm/pvclock-abi.h>
+#include <asm/pvlock-abi.h>
 #include <asm/smp_plat.h>
 
 struct static_key paravirt_steal_enabled;
@@ -38,7 +40,12 @@ struct pv_time_stolen_time_region {
 	struct pvclock_vcpu_stolen_time __rcu *kaddr;
 };
 
+struct pv_lock_state_region {
+	struct pvlock_vcpu_state __rcu *kaddr;
+};
+
 static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
+static DEFINE_PER_CPU(struct pv_lock_state_region, lock_state_region);
 
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
@@ -178,3 +185,108 @@ int __init pv_time_init(void)
 
 	return 0;
 }
+
+static bool native_vcpu_is_preempted(int cpu)
+{
+	return false;
+}
+
+DEFINE_STATIC_CALL(pv_vcpu_is_preempted, native_vcpu_is_preempted);
+
+static bool para_vcpu_is_preempted(int cpu)
+{
+	struct pv_lock_state_region *reg;
+	__le64 preempted_le;
+
+	reg = per_cpu_ptr(&lock_state_region, cpu);
+	if (!reg->kaddr) {
+		pr_warn_once("PV lock enabled but not configured for cpu %d\n",
+			     cpu);
+		return false;
+	}
+
+	preempted_le = le64_to_cpu(READ_ONCE(reg->kaddr->preempted));
+
+	return !!(preempted_le);
+}
+
+static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
+{
+	struct pv_lock_state_region *reg;
+
+	reg = this_cpu_ptr(&lock_state_region);
+	if (!reg->kaddr)
+		return 0;
+
+	memunmap(reg->kaddr);
+	memset(reg, 0, sizeof(*reg));
+
+	return 0;
+}
+
+static int init_pvlock_vcpu_state(unsigned int cpu)
+{
+	struct pv_lock_state_region *reg;
+	struct arm_smccc_res res;
+
+	reg = this_cpu_ptr(&lock_state_region);
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID, &res);
+
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
+		pr_warn("Failed to init PV lock data structure\n");
+		return -EINVAL;
+	}
+
+	reg->kaddr = memremap(res.a0,
+			      sizeof(struct pvlock_vcpu_state),
+			      MEMREMAP_WB);
+
+	if (!reg->kaddr) {
+		pr_warn("Failed to map PV lock data structure\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_init_pvlock(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
+				"hypervisor/arm/pvlock:starting",
+				init_pvlock_vcpu_state,
+				pvlock_vcpu_state_dying_cpu);
+	if (ret < 0) {
+		pr_warn("PV-lock init failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static bool has_kvm_pvlock(void)
+{
+	return kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PV_LOCK);
+}
+
+int __init pv_lock_init(void)
+{
+	int ret;
+
+	if (is_hyp_mode_available())
+		return 0;
+
+	if (!has_kvm_pvlock())
+		return 0;
+
+	ret = kvm_arm_init_pvlock();
+	if (ret)
+		return ret;
+
+	static_call_update(pv_vcpu_is_preempted, para_vcpu_is_preempted);
+	pr_info("using PV-lock preempted\n");
+
+	return 0;
+}
\ No newline at end of file
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index fea3223704b6..05ca07ac5800 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <asm/cpu_ops.h>
 #include <asm/kasan.h>
 #include <asm/numa.h>
+#include <asm/paravirt.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp_plat.h>
@@ -360,6 +361,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
+	pv_lock_init();
+
 	/* Init percpu seeds for random tags after cpus are set up. */
 	kasan_init_sw_tags();
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f61447913db9..c0ee11855c73 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -192,6 +192,7 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
+	CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_CTI_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
