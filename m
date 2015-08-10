From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 11/15] KVM: arm: add a function to keep track of host use
 of the debug registers
Date: Mon, 10 Aug 2015 21:26:03 +0800
Message-ID: <1439213167-8988-12-git-send-email-zhichao.huang@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C22415A7AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:15:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m9Yp5BmPInhQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:15:42 -0400 (EDT)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
 [209.85.220.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D77D75A71D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:15:41 -0400 (EDT)
Received: by pacgr6 with SMTP id gr6so27303372pac.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:28:42 -0700 (PDT)
In-Reply-To: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to implement a lazy world switch for debug registers,
we add a function reading the break/watch control variables directly to
indicate whether the host has enabled any break/watch points or not.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/include/asm/hw_breakpoint.h |  5 +++++
 arch/arm/kernel/hw_breakpoint.c      | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
index f2f4c61..6f375c5 100644
--- a/arch/arm/include/asm/hw_breakpoint.h
+++ b/arch/arm/include/asm/hw_breakpoint.h
@@ -66,9 +66,14 @@ int arch_install_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 int hw_breakpoint_slots(int type);
+bool hw_breakpoint_enabled(void);
 
 #else
 static inline void clear_ptrace_hw_breakpoint(struct task_struct *tsk) {}
+static inline bool hw_breakpoint_enabled(void)
+{
+	return false;
+}
 
 #endif	/* CONFIG_HAVE_HW_BREAKPOINT */
 #endif  /* __ASSEMBLY */
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index dc7d0a9..f56788f 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -227,6 +227,27 @@ static int get_num_brps(void)
 	return core_has_mismatch_brps() ? brps - 1 : brps;
 }
 
+/* Indicate whether the host has enabled any break/watch points or not. */
+bool hw_breakpoint_enabled(void)
+{
+	struct perf_event **slots;
+	int i;
+
+	slots = this_cpu_ptr(bp_on_reg);
+	for (i = 0; i < core_num_brps; i++) {
+		if (slots[i])
+			return true;
+	}
+
+	slots = this_cpu_ptr(wp_on_reg);
+	for (i = 0; i < core_num_wrps; i++) {
+		if (slots[i])
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * In order to access the breakpoint/watchpoint control registers,
  * we must be running in debug monitor mode. Unfortunately, we can
-- 
1.7.12.4
