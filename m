Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09945FA3733
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC9422082C
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 10:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC9422082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 759174A88B;
	Thu, 17 Oct 2019 06:29:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JXEpDF9gQmsz; Thu, 17 Oct 2019 06:29:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 616554AA4C;
	Thu, 17 Oct 2019 06:29:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90DE34A9BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 06:49:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xwtm13YWYs4i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Oct 2019 06:49:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C66B4A9BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 06:49:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13C541000;
 Tue, 15 Oct 2019 03:49:09 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com
 [10.169.40.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4B0163F68E;
 Tue, 15 Oct 2019 03:49:04 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com
Subject: [PATCH v5 3/6] timekeeping: Add clocksource to system_time_snapshot
Date: Tue, 15 Oct 2019 18:48:19 +0800
Message-Id: <20191015104822.13890-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015104822.13890-1-jianyong.wu@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
X-Mailman-Approved-At: Thu, 17 Oct 2019 06:29:20 -0400
Cc: justin.he@arm.com, kvm@vger.kernel.org, jianyong.wu@arm.com,
 linux-kernel@vger.kernel.org, nd@arm.com, kvmarm@lists.cs.columbia.edu,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Sometimes, we need check current clocksource outside of
timekeeping area. Add clocksource to system_time_snapshot then
we can get clocksource as well as system time.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/timekeeping.h | 35 ++++++++++++++++++-----------------
 kernel/time/timekeeping.c   |  7 ++++---
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index a8ab0f143ac4..964c14fbbf69 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -194,23 +194,6 @@ extern bool timekeeping_rtc_skipresume(void);
 
 extern void timekeeping_inject_sleeptime64(const struct timespec64 *delta);
 
-/*
- * struct system_time_snapshot - simultaneous raw/real time capture with
- *	counter value
- * @cycles:	Clocksource counter value to produce the system times
- * @real:	Realtime system time
- * @raw:	Monotonic raw system time
- * @clock_was_set_seq:	The sequence number of clock was set events
- * @cs_was_changed_seq:	The sequence number of clocksource change events
- */
-struct system_time_snapshot {
-	u64		cycles;
-	ktime_t		real;
-	ktime_t		raw;
-	unsigned int	clock_was_set_seq;
-	u8		cs_was_changed_seq;
-};
-
 /*
  * struct system_device_crosststamp - system/device cross-timestamp
  *	(syncronized capture)
@@ -236,6 +219,24 @@ struct system_counterval_t {
 	struct clocksource	*cs;
 };
 
+/*
+ * struct system_time_snapshot - simultaneous raw/real time capture with
+ *	counter value
+ * @sc:		Contains clocksource and clocksource counter value to produce
+ * 	the system times
+ * @real:	Realtime system time
+ * @raw:	Monotonic raw system time
+ * @clock_was_set_seq:	The sequence number of clock was set events
+ * @cs_was_changed_seq:	The sequence number of clocksource change events
+ */
+struct system_time_snapshot {
+	struct system_counterval_t sc;
+	ktime_t		real;
+	ktime_t		raw;
+	unsigned int	clock_was_set_seq;
+	u8		cs_was_changed_seq;
+};
+
 /*
  * Get cross timestamp between system clock and device clock
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 44b726bab4bd..66ff089605b3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -983,7 +983,8 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 		nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	systime_snapshot->cycles = now;
+	systime_snapshot->sc.cycles = now;
+	systime_snapshot->sc.cs = tk->tkr_mono.clock;
 	systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
 	systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
 }
@@ -1189,12 +1190,12 @@ int get_device_system_crosststamp(int (*get_time_fn)
 		 * clocksource change
 		 */
 		if (!history_begin ||
-		    !cycle_between(history_begin->cycles,
+		    !cycle_between(history_begin->sc.cycles,
 				   system_counterval.cycles, cycles) ||
 		    history_begin->cs_was_changed_seq != cs_was_changed_seq)
 			return -EINVAL;
 		partial_history_cycles = cycles - system_counterval.cycles;
-		total_history_cycles = cycles - history_begin->cycles;
+		total_history_cycles = cycles - history_begin->sc.cycles;
 		discontinuity =
 			history_begin->clock_was_set_seq != clock_was_set_seq;
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
