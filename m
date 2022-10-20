Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E4BC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:43:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C569E4B92F;
	Thu, 20 Oct 2022 01:43:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OcWl4Ppe4z9y; Thu, 20 Oct 2022 01:43:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A72954B8B6;
	Thu, 20 Oct 2022 01:43:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C05784B8AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cDgWdESFYTko for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:43:11 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4A0C4B8B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:11 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-36885d835e9so5108377b3.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=gJ7DW6FMrS3/XjKR3IUADDixPsWjRSTHpU4QIywCQT0=;
 b=kGndETIJMFAPsM6o9M6DaJUd1eiJ2R4UMKlgOyP1fNzxbCIVhSLbX7CnVkqS0nZlgD
 qkckUwjazjcZLM/YkMuwJNmj1ry2kxAjdem3B0xhMr2Dp4mF/14rIR7QQKqF48mU8mB8
 DcVOolzBRorJXy4aurbFEdEk/2+PPc1mT16TphLnIg/nGPjf1VTt5E1w2sdOQK4gJFWK
 SWfUUVygx2JxiN+W1eCfC/6ejAbDk16p/xlU+QRxcN9+DW5mPw4pCt5m2rJjzODbwnTl
 IPW0r6GYVCllZBAnh/B7sQDg2fWC80wwFFwvtnm6wbVWdEwS7OpZC3IggwH4D5drvjZp
 wY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=gJ7DW6FMrS3/XjKR3IUADDixPsWjRSTHpU4QIywCQT0=;
 b=tPGgCf/gRMKA+O4NZuMADoLtVXTpjhiiitAyflPlyNMp6bB/Md+Z2YVBVYys2OMRhL
 CdtAGUlZZAREcfwEYEH/3AdFjSf0Y90dxo1BY9IWG4auQ+vzl6cuSPkLTqAWHrUxyU3U
 bDSaKpE5399zo3TuzcJhjrSEzQJYfma6EMJuoUvBCXOCrnYPpMiH59C6oCfbQk2lsB6g
 eIEhpP+mKWeb4VujHFW5cGiUidIjb7sjdhAUKaPeDBDnrn31b91GDU+NqDBrdQAeqSiW
 kl7wFke0q7mVsatoEAfGcda1P7+Z1dTN9HFAqRWUAlCDPR3H6rokQiKVdOf7UmHeMai0
 bg2w==
X-Gm-Message-State: ACrzQf1qqIOpwuwZ/w8+Gu5S47lGK7MoCj88bzIXtSTJzH1pEaO8xXr+
 dlyYZJaDEruOWur4ETvdykVG3H0sYJI=
X-Google-Smtp-Source: AMsMyM5cafI3oKmmNqdU3WwdsV2NsJ9CGbFSB+7QFWMTaiHhqL6V6IVmTaXwI0KJcvCCmksQc05HdIvzMqg=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:7cc7:0:b0:6ca:3ba9:a1b8 with SMTP id
 x190-20020a257cc7000000b006ca3ba9a1b8mr438557ybc.206.1666244591287; Wed, 19
 Oct 2022 22:43:11 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:41:57 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-5-reijiw@google.com>
Subject: [PATCH v2 4/9] KVM: arm64: selftests: Add helpers to enable debug
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
No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 608a6c8db9a2..0c237022f4d3 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -130,10 +130,20 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
+static void enable_monitor_debug_exceptions(void)
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
@@ -141,28 +151,19 @@ static void install_wp(uint8_t wpn, uint64_t addr)
 
 	isb();
 
-	asm volatile("msr daifclr, #8");
-
-	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr, mdscr_el1);
-	isb();
+	enable_monitor_debug_exceptions();
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
+	enable_monitor_debug_exceptions();
 }
 
 static void install_ss(void)
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
