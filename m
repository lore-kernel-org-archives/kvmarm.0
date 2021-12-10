Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CD1C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 16:58:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BFDF4B174;
	Fri, 10 Dec 2021 11:58:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I4dGEyhojtLl; Fri, 10 Dec 2021 11:58:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0287C4B1BD;
	Fri, 10 Dec 2021 11:58:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F34D4B174
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:58:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oyq-z6I+rvM6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 11:58:17 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 119DB4B126
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:58:14 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 h23-20020a635757000000b00338aec76502so2050682pgm.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 08:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=eKQesUFjYD5NfEB4UvQVXF1znz9HszyH0XL6Z4lPT7E=;
 b=pLZZPADyNN9UJUo/y6m5A586urPxDvD011OjasTyFvpXgxTNPjOdg4iIuHxKiis28b
 zNXWr9X95dauDgG3SrAnWBEDXRw85qrjzgoryyRAoZs9IDhRNTrUol+9RkTtWpiFZKYd
 JSRVHeBkx7lA35hOQxSuziYZFqaf5O5VjQYuHex/vmZtI3gnG/mXbW0WXAyEARz2KNSF
 Di9yci3dLMjlRZO7xrg/io5jI12uK7rcIAT0ZiomJw0mFuwJeYIm1T+BIMJQn3IwxSBL
 NLVrOVQrkanj5ipPAlHDFA/GrGtvruUASEbJEApUjdtEy2Vw1qvgBKVhh3z+5ssnjgD0
 Ulhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eKQesUFjYD5NfEB4UvQVXF1znz9HszyH0XL6Z4lPT7E=;
 b=428TJt52Km6cVloCSEX4MHMjq2L0K4SWjIdYNlgQWJa79B6IdGfgT1t14njPIRF1/L
 Sk1lQgZ3BGdUmJtQm3s/4LK3+Pi05vcap5p6rq28gPGE+JdfpGweigqm7eWiX2WBr13w
 sInQ8zqu47OjPCQxpxDCBHVVlWamjMJwOsaDZrmj3Q+nyVkyEkbz/0TRS5E58GDHOYcL
 aahRvHTRgzVZ4peCD+p+97GpUgPUcZbULyIn82Dihx01URYb/Q7x56rc6LfAX6K3Pm/F
 hxkMTOOFH0lbKxQ5csxnhk79GiePo5Jf09pbLb+WipFGCpKLSuK1uySIpnMlP0g4O6CV
 4kcA==
X-Gm-Message-State: AOAM5323bjoyQ0aSVLBrhgnCwUSSsg0Oj+43c5O2HucF7Wj6rQ8dEfbm
 0jeH9KTTdyiTXARQ0m/M1uNkbcfauLjiXA==
X-Google-Smtp-Source: ABdhPJxrlb29OM6chmNq04VCtKjTZI3T5q3zrOTqQXOnHJ5M/LwUa4Repgd6cICtUvBgVw2HN6RYjaaTq9xQ5g==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4c4b:: with SMTP id
 np11mr25621615pjb.233.1639155493365; Fri, 10 Dec 2021 08:58:13 -0800 (PST)
Date: Fri, 10 Dec 2021 08:58:04 -0800
In-Reply-To: <20211210165804.1623253-1-ricarkol@google.com>
Message-Id: <20211210165804.1623253-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20211210165804.1623253-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 3/3] arm64: debug: add a migration test for
 single-step state
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>
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

Test the migration of single-step state. Setup single-stepping, migrate,
and check that we are actually single-stepping.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/debug.c       | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg | 12 ++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/arm/debug.c b/arm/debug.c
index b2240d7..54f059d 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -23,8 +23,10 @@
 #define DBGWCR_E		(0x1 << 0)
 
 #define SPSR_D			(1 << 9)
+#define SPSR_SS			(1 << 21)
 
 #define ESR_EC_HW_BP_CURRENT    0x31
+#define ESR_EC_SSTEP_CURRENT    0x33
 #define ESR_EC_WP_CURRENT       0x35
 
 #define ID_AA64DFR0_BRPS_SHIFT	12
@@ -34,6 +36,7 @@
 
 static volatile uint64_t hw_bp_idx, hw_bp_addr[16];
 static volatile uint64_t wp_idx, wp_data_addr[16];
+static volatile uint64_t ss_addr[4], ss_idx;
 
 static void hw_bp_handler(struct pt_regs *regs, unsigned int esr)
 {
@@ -47,6 +50,12 @@ static void wp_handler(struct pt_regs *regs, unsigned int esr)
 	regs->pstate |= SPSR_D;
 }
 
+static void ss_handler(struct pt_regs *regs, unsigned int esr)
+{
+	ss_addr[ss_idx++] = regs->pc;
+	regs->pstate |= SPSR_SS;
+}
+
 static int get_num_hw_bp(void)
 {
 	uint64_t reg = read_sysreg(id_aa64dfr0_el1);
@@ -344,6 +353,36 @@ static void test_wp(bool migrate)
 	}
 }
 
+static void test_ss(bool migrate)
+{
+	extern unsigned char ss_start;
+	uint32_t mdscr;
+
+	install_exception_handler(EL1H_SYNC, ESR_EC_SSTEP_CURRENT, ss_handler);
+
+	reset_debug_state();
+
+	ss_idx = 0;
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+
+	if (migrate) {
+		do_migrate();
+	}
+
+	asm volatile("msr daifclr, #8");
+
+	asm volatile("ss_start:\n"
+			"mrs x0, esr_el1\n"
+			"add x0, x0, #1\n"
+			"msr daifset, #8\n"
+			: : : "x0");
+
+	report(ss_addr[0] == (uint64_t)&ss_start, "single step");
+}
+
 int main(int argc, char **argv)
 {
 	if (argc < 2)
@@ -365,6 +404,14 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_wp(true);
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "ss") == 0) {
+		report_prefix_push(argv[1]);
+		test_ss(false);
+		report_prefix_pop();
+	} else if (strcmp(argv[1], "ss-migration") == 0) {
+		report_prefix_push(argv[1]);
+		test_ss(true);
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index bca2fad..c8c51d2 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -266,3 +266,15 @@ file = debug.flat
 arch = arm64
 extra_params = -append 'wp-migration'
 groups = debug migration
+
+[debug-sstep]
+file = debug.flat
+arch = arm64
+extra_params = -append 'ss'
+groups = debug
+
+[debug-sstep-migration]
+file = debug.flat
+arch = arm64
+extra_params = -append 'ss-migration'
+groups = debug migration
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
