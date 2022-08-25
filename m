Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DC7C64990
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B715C4E2CA;
	Thu, 25 Aug 2022 01:10:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zMmkLNf4idGd; Thu, 25 Aug 2022 01:10:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE3A4E2D1;
	Thu, 25 Aug 2022 01:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F56E4E2C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tU1vly7fct-o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:14 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53CD44E2C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:14 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-33d356e7629so149805717b3.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=9ffUjEySqAKD1W3MR1Jll+z7zRBzaKpJ63e87b2sI0w=;
 b=Y2XgBKslzFhyyaeuMJTAUVbJclGK2+/4xYvY6Ym/8KydSI8gTBWYAeRwKuZYtS+QXO
 M0BoxBQrLDT4cHZzCw2tWZDbE5ck4054YjeYeUjJsYmc+VVPIGaF3kKsGw+DjgZUK+uy
 vXAickHOiwUViKy5QQBUm5r2NxTAzgC2dx4uq6+JB13u17Z6BuO0bdA5XxrIMS684azZ
 fVDTX6qgO9KdVOL8iYI0vPnVur2yMCm9OxrPQd1AyF8wwFI6xzkEpP0ZrT2DehZH1WVv
 yYQ/b8Dxs/GYb7s97082W3qCi52LSalo97F7Tuqs2nSZd1WJ4mgDvkmdfFecwDmDyMzq
 nkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=9ffUjEySqAKD1W3MR1Jll+z7zRBzaKpJ63e87b2sI0w=;
 b=s1XchNVxDu3O+1ldJf7Oqt/q5AOtjkj4BLtOOxcrsyZ/cXkDD4pxk8MGTNHxIVKANF
 ZK5ZK4xhiPKuSSvKRDZshmxwfDD0E48LORU/dAx6E7XT5jj+Si0NeSFOCDQ6WivmEg75
 /WjdLgV22jRLtccPUqSlauB6rfEI9K6A9/Frw1MdxHbo+jHFUHP1xL+BCpjAtYvDr5+N
 CxloA4nNFVqFwYVSfmHyKZE1UQSJfFRjL6buTx/Ww3dfmvHACX4tVDwYNYo8yRfS5Qk+
 2alC3p7VZWQP4WCyNSI5/sgBqv3NdAa8NgAIyzXw1P22BBqw6dq4T4f8W38Hmx5Inlyr
 BvTg==
X-Gm-Message-State: ACgBeo05xygBvL4wKNPd1gVfAQAtt58awqGnTrcw7VhdNGjX+rIqZ2AT
 gniJWxpPZU1yQkuqDV3uRqsOKhYjymg=
X-Google-Smtp-Source: AA6agR71nOpX8pLKJKTNxFaWjIc4FLSWuNTbDZPoIKZQIn8/WYBy8Y7fVJOMwWjOvv8y7dwtbE/1RQ9qK04=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:a0f:0:b0:691:6fea:deda with SMTP id
 k15-20020a5b0a0f000000b006916feadedamr2092344ybq.377.1661404214009; Wed, 24
 Aug 2022 22:10:14 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:40 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-4-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0
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

Remove the hard-coded {break,watch}point #0 from the guest_code()
in debug-exceptions to allow {break,watch}point number to be
specified.  Subsequent patches will add test cases for non-zero
{break,watch}points.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 50 ++++++++++++-------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 51047e6b8db3..183ee16acb7d 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -93,6 +93,9 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
 
 static void reset_debug_state(void)
 {
+	uint8_t brps, wrps, i;
+	uint64_t dfr0;
+
 	asm volatile("msr daifset, #8");
 
 	write_sysreg(0, osdlr_el1);
@@ -100,11 +103,20 @@ static void reset_debug_state(void)
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
+	brps = cpuid_get_ufield(dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	for (i = 0; i <= brps; i++) {
+		write_dbgbcr(i, 0);
+		write_dbgbvr(i, 0);
+	}
+	wrps = cpuid_get_ufield(dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	for (i = 0; i <= wrps; i++) {
+		write_dbgwcr(i, 0);
+		write_dbgwvr(i, 0);
+	}
+
 	isb();
 }
 
@@ -116,14 +128,14 @@ static void enable_os_lock(void)
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
 
@@ -134,14 +146,14 @@ static void install_wp(uint64_t addr)
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
@@ -164,7 +176,7 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(void)
+static void guest_code(uint8_t bpn, uint8_t wpn)
 {
 	GUEST_SYNC(0);
 
@@ -177,7 +189,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(hw_bp));
+	install_hw_bp(bpn, PC(hw_bp));
 	asm volatile("hw_bp: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
 
@@ -185,7 +197,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + svc */
 	reset_debug_state();
-	install_hw_bp(PC(bp_svc));
+	install_hw_bp(bpn, PC(bp_svc));
 	asm volatile("bp_svc: svc #0");
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
 	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
@@ -194,7 +206,7 @@ static void guest_code(void)
 
 	/* Hardware-breakpoint + software-breakpoint */
 	reset_debug_state();
-	install_hw_bp(PC(bp_brk));
+	install_hw_bp(bpn, PC(bp_brk));
 	asm volatile("bp_brk: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
 	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
@@ -203,7 +215,7 @@ static void guest_code(void)
 
 	/* Watchpoint */
 	reset_debug_state();
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
@@ -237,7 +249,7 @@ static void guest_code(void)
 	/* OS Lock blocking hardware-breakpoint */
 	reset_debug_state();
 	enable_os_lock();
-	install_hw_bp(PC(hw_bp2));
+	install_hw_bp(bpn, PC(hw_bp2));
 	hw_bp_addr = 0;
 	asm volatile("hw_bp2: nop");
 	GUEST_ASSERT_EQ(hw_bp_addr, 0);
@@ -249,7 +261,7 @@ static void guest_code(void)
 	enable_os_lock();
 	write_data = '\0';
 	wp_data_addr = 0;
-	install_wp(PC(write_data));
+	install_wp(wpn, PC(write_data));
 	write_data = 'x';
 	GUEST_ASSERT_EQ(write_data, 'x');
 	GUEST_ASSERT_EQ(wp_data_addr, 0);
@@ -337,6 +349,8 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
+	/* Run tests with breakpoint#0 and watchpoint#0. */
+	vcpu_args_set(vcpu, 2, 0, 0);
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vcpu);
 
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
