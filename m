Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B30C19F2A
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 18:52:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D41364E993;
	Thu, 11 Aug 2022 14:52:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XQ2EgpE4vek5; Thu, 11 Aug 2022 14:52:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B20484E99A;
	Thu, 11 Aug 2022 14:52:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC9914E98C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K7KXwXJ105oD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 14:52:18 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 246DC4E98F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:18 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 f16-20020a17090a4a9000b001f234757bbbso8961159pjh.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 11:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=VZiPxkBQBE7PnfHpNUttSx1eXhEoYlew1lZUmeEavmw=;
 b=XiiMXev2mWnjZyJYsibr8sQlQJcMRMTmnaXi/1K05NUYChLByxpjhValTyUKyLy2s/
 HS+KFJnE2JRfVwiuQHTgW1F3H5IdUnUzDZPlS/8C8ZnYl6thZW+rkRca30ezT8IENouI
 SGMkFj3IWDOLEenfWosAdwGFjjY6maHLu/FdcPhgjZTFaV01LkGTUAhJc5ko9pZiDqnY
 TG5z4BdfOIIb0fjzMBA1sByI2W+qstPHTV67UymdF/nQ98SDmNb7sTOoDajD1xeCgg7+
 2WiVIRg9sBwFBvyAkH+vmb4EGMj0MQJ1cYxfrC5Gdn/CUdybvN9dXjVJxvCKu6mq79he
 0Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=VZiPxkBQBE7PnfHpNUttSx1eXhEoYlew1lZUmeEavmw=;
 b=MkTkHUNhqIdHzZmIFYGq3biKZTR2HYKbkTVM7vm0Q6fg0+Z+RpzqXodUHkVRHNZJuL
 nPVVHW5SXL4pLvjNgKeABhHS6euwCt11ygTHj+/+BBvJA0/fq84247l0pyODCkKUclIt
 1uxRxKSx5dOpqcL/8eKAGPB642gNAk7CDlpz0y8OiyEoJUXnS74+MWB/epPWItHsX8Xz
 tDcIjeu7pemnRH76qqZ4e0gqCdU3xCoSUTlwF8Rj23O3BkwDJeh0PRcBuPCQr8o2devo
 PJ+Lhnvd3Bk1V0IjMqmod6zXfTTwFyGuJCgrY3R+/E8EAtEeg19ZKbqcI26VUKSKu3xe
 Sx0g==
X-Gm-Message-State: ACgBeo1/X5DjYvuamf8yPszvjGkqezUHrVyyWKNlJ8W86P7xkRcw/L7W
 LvswaUTJUNnqCp1smJ12iD4e40uNgJMDZg==
X-Google-Smtp-Source: AA6agR6AaunjtKLPe1/K8oUl3wed1uUaUWeB0b0zinTqn0KSL7mGjfcIEvGAQtVzVLGVgIq6vknLFRHHLnLirg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:1943:b0:1f7:b63e:60db with SMTP
 id nk3-20020a17090b194300b001f7b63e60dbmr9988947pjb.241.1660243937397; Thu,
 11 Aug 2022 11:52:17 -0700 (PDT)
Date: Thu, 11 Aug 2022 11:52:08 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 2/4] arm: pmu: Add reset_pmu() for 32-bit arm
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org
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

Add a 32-bit arm version of reset_pmu(). Add all the necessary register
definitions as well.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 4c601b05..a5260178 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -93,7 +93,10 @@ static struct pmu pmu;
 #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
 #define PMXEVTYPER   __ACCESS_CP15(c9, 0, c13, 1)
 #define PMCNTENSET   __ACCESS_CP15(c9, 0, c12, 1)
+#define PMCNTENCLR   __ACCESS_CP15(c9, 0, c12, 2)
+#define PMOVSR       __ACCESS_CP15(c9, 0, c12, 3)
 #define PMCCNTR32    __ACCESS_CP15(c9, 0, c13, 0)
+#define PMINTENCLR   __ACCESS_CP15(c9, 0, c14, 2)
 #define PMCCNTR64    __ACCESS_CP15_64(0, c9)
 
 static inline uint32_t get_id_dfr0(void) { return read_sysreg(ID_DFR0); }
@@ -145,6 +148,19 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: "cc");
 }
 
+static void pmu_reset(void)
+{
+	/* reset all counters, counting disabled at PMCR level*/
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	/* Disable all counters */
+	write_sysreg(ALL_SET, PMCNTENCLR);
+	/* clear overflow reg */
+	write_sysreg(ALL_SET, PMOVSR);
+	/* disable overflow interrupts on all counters */
+	write_sysreg(ALL_SET, PMINTENCLR);
+	isb();
+}
+
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
