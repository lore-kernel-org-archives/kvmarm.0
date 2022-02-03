Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCC2C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:42:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 677704B139;
	Thu,  3 Feb 2022 12:42:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qa2bmHbtuDzX; Thu,  3 Feb 2022 12:42:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFF884B17C;
	Thu,  3 Feb 2022 12:42:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA484B108
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oJtbi4KT1u8t for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:42:10 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 669164B118
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:42:09 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 y124-20020a6bc882000000b0060fbfe14d03so2475739iof.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wrgfEfV14EVeGeVBLAsKjtwiGuvuEQxGhzBYOaaTqP4=;
 b=YpzyUoEg7zq/DcVh3KyeU4vERdGA8ReR59CxEznCRJob+oEp3QY3eZ0VWIBhuOBMrr
 t1Bj4upczXAJsjg23H0UQlGn7PuUMxUMi8BnCfkyRMADFajSDMHQIGaFP57BQ4wXw7G5
 GSF1ORFT9coE27YVzmUtB3ha4th1yqtzjz6KjGvoOu/Zy9PMrrOwSOjQUIFbfcuv3Urm
 fb8z8xZQ8TEtnL4YLX+tdae00N4XGnnVaeO1pnTiBfxZRmo+6zKUOYvvSyhc4D0dfjRM
 fWtZ00OZbBqz7pz1CZfMeIB6r5m99pcTN9V3MWn+XMZs+DjbS8hHQhhN6/KJ7SzQCTtW
 vO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wrgfEfV14EVeGeVBLAsKjtwiGuvuEQxGhzBYOaaTqP4=;
 b=aaAFMEBxkDLiiqQS9O5m7z+Fjo+ysiOHPj7a6dqnt2cfmyGP8XMBEUSUq0NXpjogC1
 QZj0H6mGlQJxgxo7PzUyn56Z/uJ6hluuOHp0Um2uWcY2xQAGxs2gANYyrvFFArE4rAp1
 hPnW5a9Kln/yXzcLAND6xlGcZj/4Elkq7Z96VkD0es5C+cKqp5c5VXGajMz/z8k56VYh
 93qHECO/+bmHwZorm9VhjJRXOz5kKlDR7vIAnQPTdn5V9Fev7n2XC6xfFdQpbS0OLrOE
 RFmQVLRQ+s5Gq9myW4gQLvFb5RaXBrI0+8hrvTURV4xePxBSXTxQRRnkOBptk7mSD+gx
 FCPg==
X-Gm-Message-State: AOAM533cx0/aCSfnQKAbZdaJthJbWB8SrTl8K0owxQTB/rZqHCmrHvMj
 3roN5EMLrdnJKYk17G4yQoj7jmM5vriqwKoph+UO5OuPNPZKW8KEAbtbYi+BCDjSmRXvxvCJx5y
 xBug8NiQ5SKItghArWM+1L4682DacMiVRq8rWFIBu7LnyXiYx31VmOOJ9ONB8mYXeNwtZYw==
X-Google-Smtp-Source: ABdhPJy86QQxEmk8vHHLHMGD7z7jHF4YL6H2YGYKUKkBCDrOUwuinXMawx6qJjo17l9XbIu4Ypf6lAox+V4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:3045:: with SMTP id
 u5mr17309119jak.105.1643910128871; Thu, 03 Feb 2022 09:42:08 -0800 (PST)
Date: Thu,  3 Feb 2022 17:41:59 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-7-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 6/6] selftests: KVM: Test OS lock behavior
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

KVM now correctly handles the OS Lock for its guests. When set, KVM
blocks all debug exceptions originating from the guest. Add test cases
to the debug-exceptions test to assert that software breakpoint,
hardware breakpoint, watchpoint, and single-step exceptions are in fact
blocked.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++++++-
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index ea189d83abf7..63b2178210c4 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -23,7 +23,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, sw_bp2, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -47,6 +47,14 @@ static void reset_debug_state(void)
 	isb();
 }
 
+static void enable_os_lock(void)
+{
+	write_sysreg(1, oslar_el1);
+	isb();
+
+	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
+}
+
 static void install_wp(uint64_t addr)
 {
 	uint32_t wcr;
@@ -99,6 +107,7 @@ static void guest_code(void)
 	GUEST_SYNC(0);
 
 	/* Software-breakpoint */
+	reset_debug_state();
 	asm volatile("sw_bp: brk #0");
 	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
 
@@ -152,6 +161,51 @@ static void guest_code(void)
 	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
 	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
 
+	GUEST_SYNC(6);
+
+	/* OS Lock does not block software-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	sw_bp_addr = 0;
+	asm volatile("sw_bp2: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp2));
+
+	GUEST_SYNC(7);
+
+	/* OS Lock blocking hardware-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	install_hw_bp(PC(hw_bp2));
+	hw_bp_addr = 0;
+	asm volatile("hw_bp2: nop");
+	GUEST_ASSERT_EQ(hw_bp_addr, 0);
+
+	GUEST_SYNC(8);
+
+	/* OS Lock blocking watchpoint */
+	reset_debug_state();
+	enable_os_lock();
+	write_data = '\0';
+	wp_data_addr = 0;
+	install_wp(PC(write_data));
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, 0);
+
+	GUEST_SYNC(9);
+
+	/* OS Lock blocking single-step */
+	reset_debug_state();
+	enable_os_lock();
+	ss_addr[0] = 0;
+	install_ss();
+	ss_idx = 0;
+	asm volatile("mrs x0, esr_el1\n\t"
+		     "add x0, x0, #1\n\t"
+		     "msr daifset, #8\n\t"
+		     : : : "x0");
+	GUEST_ASSERT_EQ(ss_addr[0], 0);
+
 	GUEST_DONE();
 }
 
@@ -223,7 +277,7 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	for (stage = 0; stage < 7; stage++) {
+	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vm, VCPU_ID);
 
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
-- 
2.35.0.263.gb82422642f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
