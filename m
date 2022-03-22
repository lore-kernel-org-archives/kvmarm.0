Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19F7C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 17:23:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50ECF49F59;
	Tue, 22 Mar 2022 13:23:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hWTXcq9T1H0D; Tue, 22 Mar 2022 13:23:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06FE94078F;
	Tue, 22 Mar 2022 13:23:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 320A249EEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 13:23:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3RgHaSHqI5U7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 13:23:25 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24F3249EEF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 13:23:25 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 z10-20020a634c0a000000b0036c5eb39076so9045983pga.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 10:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7ggpAtHNiDJ+NnsLo7ScZ5icbm1fKGUxqGcBJCAEY6Y=;
 b=mqg3pc+6i6V/WC/2nUh0x/0RXtMDSlRE8rCEA2QSpbd1/19ON/Ef3H/Q8YD6UH990U
 m5SSErCS/i5EZsNXySHNv0yPxAr6sKj6Id5hTc7JjuTIkR7k354RVJ20WCuPNIP8Dsii
 z3pujgswQD40fhtW31IvyoXmCvfKEP8wlB/HWBP5bWl2cO2YiRaeAVCry5w+6q4qmysy
 6wED+XCVQ1UVCxtFf9om1e+mzHzxzR92DpatXmSRRuUDR46jm38sUkojVr9OxBILR2QD
 4OclWsiNpSxfBpE2qlcj7w7lHF0etmhBlMBUjYdfD+juEHJbC/PpMSWGjBvg6JX+7e1/
 CtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7ggpAtHNiDJ+NnsLo7ScZ5icbm1fKGUxqGcBJCAEY6Y=;
 b=J0SPnuS1RUMqhbmkjZ0E+McQBUcar+kBpzGT3JwECc7y5HYwwXCuIRCBOZJoBRBZoc
 TjrPLl1sadyzbJf6iRfogXcly/zaRyaXA6bIt1jGG0gjS68BWqetaoxqIz/97DQnCigD
 jDlk2pXUSez5FMZ9/UXYvTo3MMZ+GEi48o1K4NkxLiiFnwsBlGTHmYOT+bq4oRJTe7lb
 reZU0k4lOw+PK9u+qkWYa3qkFHw3k0eZksJ9PHhzRKRub9Wk+xE4UiXEa9TVCJ1Gwdz/
 BoipY7uo9UbOtX9ITEL8WHOdBRUcnU4ruDETJQsKeoz/w6JtVJhgkZutmJMcSif945CK
 PZAw==
X-Gm-Message-State: AOAM5336oTb1AHSlVpvwAq9op4j4tw8WtwWHKH4zpRT2/RwJgPIL8HRU
 FD+zSEwKUcyCBpGVpKJeIkC4caUwPGy/fw==
X-Google-Smtp-Source: ABdhPJyhU7hmeOiqa0P0D3pB5tvCb/IIOpleA1rmE8VxLD5P5L6UlLlxLsc3gmLGCUOoq3qoZytbYSHsU4UJ7Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:2288:b0:154:50ba:2e31 with SMTP
 id b8-20020a170903228800b0015450ba2e31mr12250063plh.132.1647969804148; Tue,
 22 Mar 2022 10:23:24 -0700 (PDT)
Date: Tue, 22 Mar 2022 10:23:16 -0700
In-Reply-To: <20220322172319.2943101-1-ricarkol@google.com>
Message-Id: <20220322172319.2943101-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220322172319.2943101-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v3 1/4] KVM: arm64: selftests: add timer_get_tval() lib
 function
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add timer_get_tval() into the arch timer library functions in
selftests/kvm. Bonus: change the set_tval function to get an int32_t
(tval is signed).

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..93f35a4fc1aa 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 	isb();
 }
 
+static inline int32_t timer_get_tval(enum arch_timer timer)
+{
+	isb();
+	switch (timer) {
+	case VIRTUAL:
+		return (int32_t)read_sysreg(cntv_tval_el0);
+	case PHYSICAL:
+		return (int32_t)read_sysreg(cntp_tval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
 static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 {
 	switch (timer) {
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
