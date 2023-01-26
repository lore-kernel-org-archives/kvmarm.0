Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0C046A7
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 16:54:02 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id l40-20020a25ad68000000b0080b821fbb0fso2455498ybe.13
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 08:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOFFsrMOvyCTg6BeWwNjQP7I8O4rsRpyLcw1dHFSKvQ=;
        b=CLgqeDQXmoncZ2pXfsfJ+wxHgbm1Yc4B/40B7BOtexUUY4XjjyxkE3TCF00T5BUKOJ
         z/+ufWbrQFLAWEyjcfyqLaPKssvj1hAmmobsrK19z/DLUo0JpnPtPBoMpOaBO9Rt5R47
         p0RbMFAr7Iw2azc8+ShwmyYYh5X9GqW0zPt1X67uemPx6OUv9smJFomn87Sp/ymLSB6P
         lFqDds9eZMVp99u4L/3OHkTYMeKs/4aDDJDgdeoxZvoP2SR/W9peLqSvBKnqwy+P3eNm
         ajoSLTufrB+CUI0mkeCEIxHMEYmSiUhOnfWDLTIEiKf3JwQ8hCEJ13wAdniFzqgtJc31
         2Zbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOFFsrMOvyCTg6BeWwNjQP7I8O4rsRpyLcw1dHFSKvQ=;
        b=DuWk7yb9CR30lxzkVsspbvd5lhV3N8y73yEXmlafj7oTeyHDyD6buQOYkbchj5xyVX
         XBU+VDzGvcth3G9tRy6PUP16owBLtnrHqm6BAE6YWOC+5+2Nr46ELDT78/EbGotvjipL
         jiMfwBJfCLGJHBTECBZpFpPJ8egLO17a2biMRWMj8VJqzAQD/OlRakeDVeMNWAB2DZjF
         IMtOfe3ECgT5cNJ5dCprXZEsh/UQ9f0EpfjWTf5UaP/ZjmMUQXMJ1Lfja+vjkkqH6Vhg
         Vp1N1dF/Qrnz96xnLOUp3PX77pfTO7Uu2yNHmhUh89qoDujXUS9ZBii0+I5GJokC6HK6
         //dg==
X-Gm-Message-State: AFqh2kqPz2YLA7xkpuxfAL915XBFu1hejQcAYls4kbesOvQIXTI7i5hk
	ESOGJe77NQoEqICEBMh5M0VQIhNDSjKN2g==
X-Google-Smtp-Source: AMrXdXtDNv00dKI1COJb6goV4rKTo90bcFMRSqcNiTkW1VPWThNWNyyFGTdeqoIbJMFqeBzphd0+QvwpWlsJqQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:4d54:0:b0:7d4:e9c5:b6cf with SMTP id
 a81-20020a254d54000000b007d4e9c5b6cfmr4202442ybb.311.1674752042076; Thu, 26
 Jan 2023 08:54:02 -0800 (PST)
Date: Thu, 26 Jan 2023 16:53:50 +0000
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126165351.2561582-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-6-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 5/6] arm: pmu: Print counter values as hexadecimals
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev, reijiw@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

The arm/pmu test prints the value of counters as %ld.  Most tests start
with counters around 0 or UINT_MAX, so having something like -16 instead of
0xffff_fff0 is not very useful.

Report counter values as hexadecimals.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/pmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 082fb41..1e93ea2 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -551,8 +551,8 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
-	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
-	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
+	report_info("counter #0 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
+	report_info("counter #1 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
 	report((read_regn_el0(pmevcntr, 0) == read_regn_el0(pmevcntr, 1)) &&
 	       (read_regn_el0(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0),
@@ -567,7 +567,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
-	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
+	report_info("cnt#0=0x%lx cnt#1=0x%lx overflow=0x%lx",
 			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
 			read_sysreg(pmovsclr_el0));
 }
@@ -598,7 +598,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
+	report_info("SW_INCR counter #0 has value 0x%lx", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
@@ -615,7 +615,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 	isb();
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
-	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
+	report_info("counter values after 100 SW_INCR #0=0x%lx #1=0x%lx",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"overflow on counter #0 after 100 SW_INCR");
@@ -691,7 +691,7 @@ static void test_chained_sw_incr(bool unused)
 	report((read_sysreg(pmovsclr_el0) == 0x1) &&
 		(read_regn_el0(pmevcntr, 1) == 1),
 		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
@@ -712,7 +712,7 @@ static void test_chained_sw_incr(bool unused)
 	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
 	       (read_regn_el0(pmevcntr, 1) == cntr1),
 	       "expected overflows and values after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
@@ -744,11 +744,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
 	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
 		"odd counter did not increment on overflow if disabled");
-	report_info("MEM_ACCESS counter #0 has value %ld",
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
-	report_info("CHAIN counter #1 has value %ld",
+	report_info("CHAIN counter #1 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 1));
-	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
 
 	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
 	pmu_reset();
-- 
2.39.1.456.gfc5497dd1b-goog

