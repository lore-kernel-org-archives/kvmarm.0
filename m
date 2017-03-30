From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 3/8] arm64: apei: add a per-cpu variable to indecate sei is
 processing
Date: Thu, 30 Mar 2017 18:31:03 +0800
Message-ID: <1490869877-118713-4-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD47C40B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bS3cY5S+ik+u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 06:32:41 -0400 (EDT)
Received: from dggrg02-dlp.huawei.com (unknown [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BD8B40A74
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:40 -0400 (EDT)
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a per-cpu variable to indicate sei is processing, with which we could use to
reserve a separate virtual space address page for sei in next patch

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 arch/arm64/kernel/traps.c | 4 ++++
 include/acpi/ghes.h       | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 53710a2..955dc8c 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -615,6 +615,8 @@ const char *esr_get_class_string(u32 esr)
 	return esr_class_str[ESR_ELx_EC(esr)];
 }
 
+DEFINE_PER_CPU(int, sei_in_process);
+
 /*
  * bad_mode handles the impossible case in the exception vector. This is always
  * fatal.
@@ -632,7 +634,9 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 	 * of cper records at a time. There is no risk for one cpu to parse ghes table.
 	 */
 	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI) && ESR_ELx_EC(esr) == ESR_ELx_EC_SERROR) {
+		this_cpu_inc(sei_in_process);
 		ghes_notify_sei();
+		this_cpu_dec(sei_in_process);
 	}
 
 	die("Oops - bad mode", regs, 0);
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 10d752e..eed79ea 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -102,4 +102,6 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
 int ghes_notify_sea(void);
 int ghes_notify_sei(void);
 
+DECLARE_PER_CPU(int, sei_in_process);
+
 #endif /* GHES_H */
-- 
1.8.3.1
