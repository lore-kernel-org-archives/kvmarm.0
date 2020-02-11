Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A408C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 08:40:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D7F4206CC
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 08:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D7F4206CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C835F4A59B;
	Tue, 11 Feb 2020 03:40:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kk0HqjUPk1cr; Tue, 11 Feb 2020 03:40:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E024A5A3;
	Tue, 11 Feb 2020 03:40:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 329A14ACF4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 03:40:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DlT9j7GfZNoI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 03:40:49 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 180094AE8E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 03:40:49 -0500 (EST)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 945D616D4F7F1FABDD1A;
 Tue, 11 Feb 2020 16:40:45 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 16:40:35 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH 3/3] arm64: timer: Use existing helpers to
 access counter/timers
Date: Tue, 11 Feb 2020 16:39:01 +0800
Message-ID: <20200211083901.1478-4-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200211083901.1478-1-yuzenghui@huawei.com>
References: <20200211083901.1478-1-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
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

We already have some good helpers to access the counter and timer
registers.  Use them to avoid open coding the accessors again.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arm/timer.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 10a88f3..f5cf775 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -331,7 +331,7 @@ static void test_init(void)
 	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
 
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
-	read_sysreg(cntp_ctl_el0);
+	ptimer_info.read_ctl();
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
 
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
@@ -366,15 +366,15 @@ static void print_timer_info(void)
 {
 	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
 
-	if (!ptimer_unsupported){
-		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
-		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
-		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
+	if (!ptimer_unsupported) {
+		printf("CNTPCT_EL0   : 0x%016lx\n", ptimer_info.read_counter());
+		printf("CNTP_CTL_EL0 : 0x%016lx\n", ptimer_info.read_ctl());
+		printf("CNTP_CVAL_EL0: 0x%016lx\n", ptimer_info.read_cval());
 	}
 
-	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
-	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
-	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+	printf("CNTVCT_EL0   : 0x%016lx\n", vtimer_info.read_counter());
+	printf("CNTV_CTL_EL0 : 0x%016lx\n", vtimer_info.read_ctl());
+	printf("CNTV_CVAL_EL0: 0x%016lx\n", vtimer_info.read_cval());
 }
 
 int main(int argc, char **argv)
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
