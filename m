Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087ECC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:43:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E564B937;
	Thu, 20 Oct 2022 01:42:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SCWkGGQjYmGO; Thu, 20 Oct 2022 01:42:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CD54B90B;
	Thu, 20 Oct 2022 01:42:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAD884B8E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NcLItBsTM183 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:42:55 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4B7249673
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:55 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 t6-20020a25b706000000b006b38040b6f7so18098545ybj.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=qGPUfNXbDXq8tVpmh3iXBlsoXoLe+lb9ybKX9Ouotxs=;
 b=fam3UQuvRDuo6oBP8SRNcDAciBNKVKz4/fFVWts2VwMESRtauKi37VbcrTWOZjxpGX
 y7vkWeI+JuaZLGgSBbADMD95DBSHeTN8COMYJiR/JhGqRr/MXCjI0hjQ40V7f+Rss4+6
 9tW2Q4X356WVRbUSKNmnn/gKdvrjK8u4NayWOu6nxedkz+nOLfQuQw2BoLc7VFHeqUbA
 p7G0sZvOlyDxYS+wuQ34OcckGjJ3znkGxxbKkwsLtQZ3tnuucwKFNOoobWeGXU3bbygt
 w7JZ17Gzdc/dm6BDfZqiCnl+njnMkRCaMoqali1iPAqMPQMdCZsZXDbe7jy8E4gUGxVc
 qkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=qGPUfNXbDXq8tVpmh3iXBlsoXoLe+lb9ybKX9Ouotxs=;
 b=hCOgZuEj6K3BmIt3mebtqc6JhUuCQrdHPM2XDSHp3+rV0JkMT6EYKOGQilJOMBQn8y
 RcgDqvKhHEBXQlX5og4bOX+O7NbZA25Nf3zPYrSpie3gbilBE6bdtMT74pY7i/Sjkhqc
 xP38m4oeMqLi+JnMJyRVVWVSdo2y8u1c+bLPdRgySoZilruhB8c4woEFgiy7xwaPfyng
 1YnO+tnuvfDPwnsDEkdX7bL+vphYWr+Ge3iC85UnGRkYUqq2t+dSODulYPRgiXRmKcvG
 sxcmOgHgS8w9sLz3uepExb1H8rb6ajikpRvIEPp+oNSM/gNjZWVoIlKISSNAUwUciqvt
 QDEA==
X-Gm-Message-State: ACrzQf3Irt7TJlxNoYMnGYVhmufHqVnWFJ0s1zmBa3xfWAixikuNdHSd
 mNeevFtnH1rHVkAuW+PHRnLenj/UJDs=
X-Google-Smtp-Source: AMsMyM75m4E9sVLnRu9y7rmR0yLBR2tNjSIyrcpolvmnOh5DeGKR1WpAeFmXIgNIxR/XfGes3CkkIHTtWDs=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:5f45:0:b0:6c4:46b3:6f6d with SMTP id
 h5-20020a255f45000000b006c446b36f6dmr9081488ybm.62.1666244575457; Wed, 19 Oct
 2022 22:42:55 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:41:56 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-4-reijiw@google.com>
Subject: [PATCH v2 3/9] KVM: arm64: selftests: Remove the hard-coded {b, w}pn#0
 from debug-exceptions
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

Remove the hard-coded {break,watch}point #0 from the guest_code() in
debug-exceptions to allow {break,watch}point number to be specified.
Change reset_debug_state() to zeroing all dbg{b,w}{c,v}r_el0 registers
so that guest_code() can use the function to reset those registers
even when non-zero {break,watch}points are specified for guest_code().
Subsequent patches will add test cases for non-zero {break,watch}points.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>

---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 50 ++++++++++++-------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index d9884907fe87..608a6c8db9a2 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -95,6 +95,9 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
 
 static void reset_debug_state(void)
 {
+	uint8_t brps, wrps, i;
+	uint64_t dfr0;
+
 	asm volatile("msr daifset, #8");
 
 	write_sysreg(0, osdlr_el1);
@@ -102,11 +105,20 @@ static void reset_debug_state(void)
 	isb();
 
 	write_sysreg(0, mdscr_el1);
-	/* This test only uses the first bp and wp slot. */
-	write_sysreg(0, dbgbvr0_el1);
-	write_sysreg(0, dbgbcr0_el1);
-	write_sysreg(0, dbgwcr0_el1);
-	write_sysreg(0, dbgwvr0_el1);
+
+	/* Reset all bcr/bvr/wcr/wvr registers */
+	dfr0 = read_sysreg(id_aa64dfr0_el1);
+	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), dfr0);
+	for (i = 0; i <= brps; i++) {
+		write_dbgbcr(i, 0);
+		write_dbgbvr(i, 0);
+	}
+	wrps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS), dfr0);
+	for (i = 0; i <= wrps; i++) {
+		write_dbgwcr(i, 0);
+		write_dbgwvr(i, 0);
+	}
+
 	isb();
 }
 
@@ -118,14 +130,14 @@ static void enable_os_lock(void)
 	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
 }
 
-static void install_wp(uint64_t addr)
+static void install_wp(uint8_t wpn, uint64_t addr)
 {
 	uint32_t wcr;
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_dbgwcr(0, wcr);
-	write_dbgwvr(0, addr);
+	write_dbgwcr(wpn, wcr);
+	write_dbgwvr(wpn, addr);
 
 	isb();
 
@@ -136,14 +148,14 @@ static void install_wp(uint64_t addr)
 	isb();
 }
 
-static void install_hw_bp(uint64_t addr)
+static void install_hw_bp(uint8_t bpn, uint64_t addr)
 {
 	uint32_t bcr;
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_dbgbcr(0, bcr);
-	write_dbgbvr(0, addr);
+	write_dbgbcr(bpn, bcr);
+	write_dbgbvr(bpn, addr);
 	isb();
 
 	asm volatile("msr daifclr, #8");
@@ -166,7 +178,7 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(void)
+static void guest_code(uint8_t bpn, uint8_t wpn)
 {
 	GUEST_SYNC(0);
 
@@ -179,7 +191,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(hw_bp));
+	install_hw_bp(bpn, PC(hw_bp));
 	asm volatile("hw_bp: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
 
@@ -187,7 +199,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + svc */
 	reset_debug_state();
-	install_hw_bp(PC(bp_svc));
+	install_hw_bp(bpn, PC(bp_svc));
 	asm volatile("bp_svc: svc #0");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
 	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
@@ -196,7 +208,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + software-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(bp_brk));
+	install_hw_bp(bpn, PC(bp_brk));
 	asm volatile("bp_brk: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
@@ -205,7 +217,7 @@ static void guest_code(void)
 
 	/* Watchpoint */
 	reset_debug_state();
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
@@ -239,7 +251,7 @@ static void guest_code(void)
 	/* OS Lock blocking hardware-breakpoint */
 	reset_debug_state();
 	enable_os_lock();
-	install_hw_bp(PC(hw_bp2));
+	install_hw_bp(bpn, PC(hw_bp2));
 	hw_bp_addr = 0;
 	asm volatile("hw_bp2: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, 0);
@@ -251,7 +263,7 @@ static void guest_code(void)
 	enable_os_lock();
 	write_data = '\0';
 	wp_data_addr = 0;
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, 0);
@@ -376,6 +388,8 @@ static void test_guest_debug_exceptions(void)
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
+	/* Run tests with breakpoint#0 and watchpoint#0. */
+	vcpu_args_set(vcpu, 2, 0, 0);
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vcpu);
 
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
