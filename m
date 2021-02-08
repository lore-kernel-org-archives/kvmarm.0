Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A9FC433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 13:40:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A66464E5D
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 13:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A66464E5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 267A94B6A9;
	Mon,  8 Feb 2021 08:40:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1mb+Ac-9UtBO; Mon,  8 Feb 2021 08:40:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6CF4B673;
	Mon,  8 Feb 2021 08:40:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EE244B6A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 08:40:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4cN1RUcSpORT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 08:40:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EA9C4B68A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 08:40:39 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9B43064E45;
 Mon,  8 Feb 2021 13:40:38 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l96mK-00Cn0C-Rr; Mon, 08 Feb 2021 13:40:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
 richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
 suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com,
 lorenzo.pieralisi@arm.com, sudeep.holla@arm.com
Subject: [PATCH v18 4/7] time: Add mechanism to recognize clocksource in
 time_get_snapshot
Date: Mon,  8 Feb 2021 13:40:26 +0000
Message-Id: <20210208134029.3269384-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208134029.3269384-1-maz@kernel.org>
References: <20210208134029.3269384-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, yangbo.lu@nxp.com,
 john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com,
 seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com,
 steven.price@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com,
 justin.he@arm.com, jianyong.wu@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

From: Thomas Gleixner <tglx@linutronix.de>

System time snapshots are not conveying information about the current
clocksource which was used, but callers like the PTP KVM guest
implementation have the requirement to evaluate the clocksource type to
select the appropriate mechanism.

Introduce a clocksource id field in struct clocksource which is by default
set to CSID_GENERIC (0). Clocksource implementations can set that field to
a value which allows to identify the clocksource.

Store the clocksource id of the current clocksource in the
system_time_snapshot so callers can evaluate which clocksource was used to
take the snapshot and act accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201209060932.212364-5-jianyong.wu@arm.com
---
 include/linux/clocksource.h     |  6 ++++++
 include/linux/clocksource_ids.h | 11 +++++++++++
 include/linux/timekeeping.h     | 12 +++++++-----
 kernel/time/clocksource.c       |  2 ++
 kernel/time/timekeeping.c       |  1 +
 5 files changed, 27 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/clocksource_ids.h

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 86d143db6523..1290d0dce840 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/of.h>
+#include <linux/clocksource_ids.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -62,6 +63,10 @@ struct module;
  *			400-499: Perfect
  *				The ideal clocksource. A must-use where
  *				available.
+ * @id:			Defaults to CSID_GENERIC. The id value is captured
+ *			in certain snapshot functions to allow callers to
+ *			validate the clocksource from which the snapshot was
+ *			taken.
  * @flags:		Flags describing special properties
  * @enable:		Optional function to enable the clocksource
  * @disable:		Optional function to disable the clocksource
@@ -100,6 +105,7 @@ struct clocksource {
 	const char		*name;
 	struct list_head	list;
 	int			rating;
+	enum clocksource_ids	id;
 	enum vdso_clock_mode	vdso_clock_mode;
 	unsigned long		flags;
 
diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
new file mode 100644
index 000000000000..4d8e19e05328
--- /dev/null
+++ b/include/linux/clocksource_ids.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CLOCKSOURCE_IDS_H
+#define _LINUX_CLOCKSOURCE_IDS_H
+
+/* Enum to give clocksources a unique identifier */
+enum clocksource_ids {
+	CSID_GENERIC		= 0,
+	CSID_MAX,
+};
+
+#endif
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index c6792cf01bc7..78a98bdff76d 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -3,6 +3,7 @@
 #define _LINUX_TIMEKEEPING_H
 
 #include <linux/errno.h>
+#include <linux/clocksource_ids.h>
 
 /* Included from linux/ktime.h */
 
@@ -243,11 +244,12 @@ struct ktime_timestamps {
  * @cs_was_changed_seq:	The sequence number of clocksource change events
  */
 struct system_time_snapshot {
-	u64		cycles;
-	ktime_t		real;
-	ktime_t		raw;
-	unsigned int	clock_was_set_seq;
-	u8		cs_was_changed_seq;
+	u64			cycles;
+	ktime_t			real;
+	ktime_t			raw;
+	enum clocksource_ids	cs_id;
+	unsigned int		clock_was_set_seq;
+	u8			cs_was_changed_seq;
 };
 
 /**
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index cce484a2cc7c..4fe1df894ee5 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -920,6 +920,8 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 
 	clocksource_arch_init(cs);
 
+	if (WARN_ON_ONCE((unsigned int)cs->id >= CSID_MAX))
+		cs->id = CSID_GENERIC;
 	if (cs->vdso_clock_mode < 0 ||
 	    cs->vdso_clock_mode >= VDSO_CLOCKMODE_MAX) {
 		pr_warn("clocksource %s registered with invalid VDSO mode %d. Disabling VDSO support.\n",
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a45cedda93a7..50f08632165c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1049,6 +1049,7 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		now = tk_clock_read(&tk->tkr_mono);
+		systime_snapshot->cs_id = tk->tkr_mono.clock->id;
 		systime_snapshot->cs_was_changed_seq = tk->cs_was_changed_seq;
 		systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
 		base_real = ktime_add(tk->tkr_mono.base,
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
