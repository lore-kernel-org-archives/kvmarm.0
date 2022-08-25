Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF96C6498F
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3E64E2E1;
	Thu, 25 Aug 2022 01:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7n97yRZE1Evj; Thu, 25 Aug 2022 01:10:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 146BE4E2E3;
	Thu, 25 Aug 2022 01:10:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3233A4E2C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7hX71iBF-yRn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:25 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BA924E2D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:25 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-32a115757b6so328825347b3.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=TuEzIR2uESIWnuxyfH1eHFT+9Tcdti9EDHpVvf4j/1Y=;
 b=FgTwKGkxPoKxP1KMzZgdT1Mj/ysD6A7ddjhiMc4ZMC8VCRZaSS5hI5vKDifgV+39BI
 wXu770kX27/8AZ9i97GsTq8pOYZk4INErQ8tFX1OSefI1sY6/u/qFMkvHvptqoUSZ6+E
 k2lJs/C31pUqFQ3ZvzsZ+24EUYugRw3GnYcu5HQmVox/Cz0vKKdoQgbwpTNSHnPtCALC
 jdCUwq99FBtXx0NYhFVDDz6EMCMTiKpsq48XCFc+vTJZny1B0S5pcoEvPNNMMkhIMRQp
 eYSEwLumBBkZ8sCvuKlOV0dBHgv9LMAAqIA25/2QSniBAjRoye39JhD06UA5Gm7Ngsy3
 IKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=TuEzIR2uESIWnuxyfH1eHFT+9Tcdti9EDHpVvf4j/1Y=;
 b=lBRS5z8Uyt1mON/rVr/KqiyjzIs7cPby5/eYuatKWXEHxob/XpVBb+AW6lYLn2hQ4o
 vN/ptSuQtJsIEknhyz4uahnHQe20C4dkxahZoJj5wW19mdZNco4t6J02FdBRi9n98/Zf
 I9rro5r1d7xrRbjB/gPHzg8aSA2+6IUk+xERMfrJdGQfnLCQ2FZm+FDTx+BU5aXiaiwt
 +zWgVsSlEv7/DdcklZZyOWTZ7UtkITKXCsvCvW7EXr7EIOq04x3bD1hPbOPVE3uh0jUV
 v5dUjImwZYrjxfv/SNrVwUIWaaVNmXXS2Qt4ItUzXli58H46LSQ46uqRrVy3maRwq0w+
 oiTQ==
X-Gm-Message-State: ACgBeo1I6QfOGY5a1viROpbiiam74oXwCoYGWUuzTSqfGP5KVcgEAMYJ
 mQCGetRnz8E4MltnWxl/d/phRzJilUc=
X-Google-Smtp-Source: AA6agR7GgsXeBwiRPy64/fTalDKJtX3KknB3Yhd/leHLUxzCnhR5CpkXyRqKF28lF7ZEEPDZE2xp5aqGTPs=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1101:b0:695:ce92:a857 with SMTP id
 o1-20020a056902110100b00695ce92a857mr2078061ybu.337.1661404225060; Wed, 24
 Aug 2022 22:10:25 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:45 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 8/9] KVM: arm64: selftests: Add a test case for a linked
 watchpoint
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

Currently, the debug-exceptions test doesn't have a test case for
a linked watchpoint. Add a test case for the linked watchpoint to
the test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 9fccfeebccd3..dc94c85bb383 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -21,6 +21,9 @@
 #define DBGWCR_WR	(0x2 << 3)
 #define DBGWCR_EL1	(0x1 << 1)
 #define DBGWCR_E	(0x1 << 0)
+#define DBGWCR_LBN_SHIFT	16
+#define DBGWCR_WT_SHIFT		20
+#define DBGWCR_WT_LINK		(0x1 << DBGWCR_WT_SHIFT)
 
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
@@ -169,6 +172,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_debug_bwp_exception();
 }
 
+static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
+			   uint64_t ctx)
+{
+	uint32_t wcr;
+	uint64_t ctx_bcr;
+
+	/* Setup a context-aware breakpoint */
+	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
+		  DBGBCR_BT_CTX_LINK;
+	write_dbgbcr(ctx_bp, ctx_bcr);
+	write_dbgbvr(ctx_bp, ctx);
+
+	/* Setup a linked watchpoint (linked to the context-aware breakpoint) */
+	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E |
+	      DBGWCR_WT_LINK | ((uint32_t)ctx_bp << DBGWCR_LBN_SHIFT);
+	write_dbgwcr(addr_wp, wcr);
+	write_dbgwvr(addr_wp, addr);
+	isb();
+
+	enable_debug_bwp_exception();
+}
+
 void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
 		       uint64_t ctx)
 {
@@ -323,6 +348,16 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 
 	GUEST_SYNC(10);
 
+	/* Linked watchpoint */
+	reset_debug_state();
+	install_wp_ctx(wpn, ctx_bpn, PC(write_data), ctx);
+	/* Set context id */
+	write_sysreg(ctx, contextidr_el1);
+	isb();
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
+
 	GUEST_DONE();
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
