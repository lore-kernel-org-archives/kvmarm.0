Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BA1C43217
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:43:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BEEF4B916;
	Thu, 20 Oct 2022 01:43:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wOpv9wuO-x2A; Thu, 20 Oct 2022 01:43:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FAB84B93D;
	Thu, 20 Oct 2022 01:43:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D28E4B86A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qLiLhA1Glj4L for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:43:50 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AE9C4B938
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:50 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 u8-20020a170902e5c800b00185483ee4f5so9593740plf.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=NTH7ZmIDUvfRqYyd1HhBU5CIbrwUrGIrg8Vkup78EQQ=;
 b=a0kob/6IV3hX8wveVUZp8aIkDTHPSkKD5x0boK7exvWYmVqS1xKXjC980frftI1iB8
 OWCsn1M7ioegFzfpZDpYLhsw7YxdRjT1mqJh6jP7+GD6gBX65QrnaGUXiiGWxjhSn2aS
 /+R3vDIVC5QbrkbrkeoXpCeR63kcHlllzNsasi2HfB9dkxUIrG4HllTXWAz7kLz5flMg
 PKkcNWAIF9qF2dNNuqMTKpGOzyb4SJKBkGqu59mOkKQVVJMIiug52s+14wVOER9MNH0R
 LNFZfjxYmtfAvlWRsxg/hxtMqa48+J7IPUDMYSOQEcdhdSX7ZLvH6BjAXQCbljrXZYqA
 pyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=NTH7ZmIDUvfRqYyd1HhBU5CIbrwUrGIrg8Vkup78EQQ=;
 b=nCRyJveqbPECHgK2qzkad7GdmfQFf8y+5mtFe2ZGV8pFxcki67LkThvf+Ds3UNGfov
 sUJlLorcjTPjjWJdzViSMN+gFebdlyi18YS0Zay+uNJzBd5E4oKIZ0yGYKAuqvq33abe
 hUpprunhxxGfo0mvs0h7urRYn6dC9zfZvp9xbhIH8KG6jZ5LMO5crZHRA35585md5oC+
 SJgiY4fErSRNds9/xrIEcahqAUDk47KlTI5QW3cCTZ3mV/gLMGibIKFyMUYP58muruhg
 HOayAiPeH+rhoDbA9+xopFkDxQ4sHckTv6j8f/hIGKu9JBoosk8AFMsGgUw/JVXIR563
 4F6w==
X-Gm-Message-State: ACrzQf0Rx7cUKmoI14jYZQW+UzHRvimm72dhKZkgmiC7xhkmNN5+Cn1U
 VRoWbLh98u+IUIrKoOsTcUSDRRgBYvw=
X-Google-Smtp-Source: AMsMyM7HKrCTV8qQjJ+AeuKopjnwPGTiQp5PNWWQkgWncAh69Zqd6D1WMZdPZsMDLEvCA6w055Dg1d+ZtUw=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:902:d2cc:b0:182:d901:5d28 with SMTP id
 n12-20020a170902d2cc00b00182d9015d28mr12606746plc.142.1666244628304; Wed, 19
 Oct 2022 22:43:48 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:42:01 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-9-reijiw@google.com>
Subject: [PATCH v2 8/9] KVM: arm64: selftests: Add a test case for a linked
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
the test. The new test case uses the highest numbered context-aware
breakpoint (for Context ID match), and the watchpoint#0, which is
linked to the context-aware breakpoint.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 362e7668a978..73a95e6b345e 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -22,6 +22,9 @@
 #define DBGWCR_WR	(0x2 << 3)
 #define DBGWCR_EL1	(0x1 << 1)
 #define DBGWCR_E	(0x1 << 0)
+#define DBGWCR_LBN_SHIFT	16
+#define DBGWCR_WT_SHIFT		20
+#define DBGWCR_WT_LINK		(0x1 << DBGWCR_WT_SHIFT)
 
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
@@ -171,6 +174,28 @@ static void install_hw_bp(uint8_t bpn, uint64_t addr)
 	enable_monitor_debug_exceptions();
 }
 
+static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, uint64_t addr,
+			   uint64_t ctx)
+{
+	uint32_t wcr;
+	uint64_t ctx_bcr;
+
+	/* Setup a context-aware breakpoint for Linked Context ID Match */
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
+	enable_monitor_debug_exceptions();
+}
+
 void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
 		       uint64_t ctx)
 {
@@ -306,6 +331,16 @@ static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 	write_sysreg(0, contextidr_el1);
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp_ctx));
 
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
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
