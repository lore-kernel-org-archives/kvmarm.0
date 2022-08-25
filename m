Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88194C04AA5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31BE14E2DC;
	Thu, 25 Aug 2022 01:10:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gVyh9tEF3T3O; Thu, 25 Aug 2022 01:10:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 797F24E2D8;
	Thu, 25 Aug 2022 01:10:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A9B4E2C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4JXMFyw133cB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:16 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A4C94E2C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:16 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-33580e26058so325513917b3.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=8oX+5M8AEKJji1mM4AdRdiIeL9hn/q6yl0Bz7273pVA=;
 b=LeLhe13n76eUMhCg8SWeTVrWKNtcglEFQyn+mfy6n1dzAkWuQysdlKISXEtK+nMY8e
 KFHp3ByAxQkIys2eIl+f4hu/uA+oD6EZJNE/nEotAQeMIFarEHGOqga1SN984jZVdz/5
 N4Aza75aQ6ogp2RnHch+Zsn6Jalu1DrSU4kripuc0ELF5fnewHCu0Gn3vChBs1tgDaYd
 ADLEDy9zjAvrnk0uMK/T8HwpKQEAjAsqwE75J8fM/9mscrSuleHrzT67O3Y+FrHMSlaM
 uIsU6jEl8gn0OGNrQY/Fyk8idl1C4Cd9nBvGbyaOjjPwxpFmo+kDKFVMJMHLPRiAikRk
 k7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=8oX+5M8AEKJji1mM4AdRdiIeL9hn/q6yl0Bz7273pVA=;
 b=SsP4LkpC16jARrEGB/pANXsv2i1SuzzDK9nxehaOK+5gWZ28Fp2q71GUUhk8xDj5Zn
 v1lVgZx9qOdUBBX+Wn44sCXPvUG2+HD8zDgbxobQtQc5ESjkWiPcl7/W+w73m0rCm3Ay
 kn78p+tx/EBjRCajZQjCZoVL2Y0V5MZCN7fTKwRc+Y50sPa8sVWIl4ErnS1ETF0VbNZK
 +utLMMjvX9bcJl6LlqVpR9TfSXDQztfRP0HjcMUMoLt3AAdkxdQ0iiD4EtJrwwM8gaYG
 UEuiy/r2VHE9toppH+qzL4ocrRWGaiDnEQH2+Un9nE/mVQnto5cH6L4UYkqqVaom0bi9
 36Dg==
X-Gm-Message-State: ACgBeo2t89ggf4MfuohzsSR9MmP/vyC2GUzB2MSShE7U6cDZ57rjRTrR
 DI068S5fBrH8n3/AtFbs1K+Spbv28+0=
X-Google-Smtp-Source: AA6agR52jNE2uqaO7jEYMgZLpa+TwESVpjsc/w6zjrZheJdPE8MUiS+G/MUXsFxHt1MmvGcr0ODLhNAfaxQ=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:2cb:0:b0:688:ecfc:5865 with SMTP id
 h11-20020a5b02cb000000b00688ecfc5865mr2015078ybp.642.1661404216176; Wed, 24
 Aug 2022 22:10:16 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:41 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-5-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug
 exceptions
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Add helpers to enable breakpoint and watchpoint exceptions.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 183ee16acb7d..713c7240b680 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -128,10 +128,20 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
+static void enable_debug_bwp_exception(void)
+{
+	uint32_t mdscr;
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+}
+
 static void install_wp(uint8_t wpn, uint64_t addr)
 {
 	uint32_t wcr;
-	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
 	write_dbgwcr(wpn, wcr);
@@ -139,28 +149,19 @@ static void install_wp(uint8_t wpn, uint64_t addr)
 
 	isb();
 
-	asm volatile("msr daifclr, #8");
-
-	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr, mdscr_el1);
-	isb();
+	enable_debug_bwp_exception();
 }
 
 static void install_hw_bp(uint8_t bpn, uint64_t addr)
 {
 	uint32_t bcr;
-	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
 	write_dbgbcr(bpn, bcr);
 	write_dbgbvr(bpn, addr);
 	isb();
 
-	asm volatile("msr daifclr, #8");
-
-	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr, mdscr_el1);
-	isb();
+	enable_debug_bwp_exception();
 }
 
 static void install_ss(void)
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
