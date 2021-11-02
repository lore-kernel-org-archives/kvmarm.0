Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367F0C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D906D60C41
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D906D60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3A74B154;
	Tue,  2 Nov 2021 05:47:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zklOQEhoNLQs; Tue,  2 Nov 2021 05:47:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C224B1B0;
	Tue,  2 Nov 2021 05:47:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6289C4B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pakFyt+rrv5l for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 05:47:07 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FC984B191
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:06 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 w5-20020a6bf005000000b005e1513b2680so12800788ioc.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 02:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=USRcUlx130z7l5DHjEbTqn2FW1uy9zzoAmm3OXXaQBk=;
 b=PQLfk3CFu1uKl92twaW6wnU35UbAHgLOFn7zYoU4COpmRQifsFd/zeIm5FCi0v4o0x
 /v+0h1A/ULEUdztocwTSe0oiqESiYPZ/hpeXLA64lpfwIpqqp3XUJM4CuRE952oFQWKu
 fLsSf++kgTReC9IHoLJuRBY8v8C14jwONDDLb5Mrm+gyaSe1TgfI6eHqcwEEOTofSHTN
 wS8Q0W7bHGRZ1baATKX5JSPRjxdR+oHD9mhS6xgGZ/jA4t+A0uFxy4S4x4p3lceEFZuM
 UJ1ALejVWJAhv1+rtYQZldacua675hfSzOOsdxq9odNYyfkD74lpUoSqCivx93Z0wd+e
 JySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=USRcUlx130z7l5DHjEbTqn2FW1uy9zzoAmm3OXXaQBk=;
 b=oU6c+DRpfSgHexN/qwr6V/JhF5xH5Ch+Qybi3vN5HttDQRfeuN/yWL2rkH9Hu1DW75
 uWRxwtBCMVfNjNsePMGC+X6+C2hs2ER5yNMH6oO4txlLfgs3gIltD10wt1IFcSQBbhX3
 l1VxjTYcKnJmsXPJGOpcqBs8E5JVxut4IX7ft2WqWZG3isub19PvoVg9dMfkBofF512a
 bsG5M16itC+lMgEqB440uVBk3qTITD9Mmgie9ebw6ohui9WJb0KJPbXsb7HdnWtVIOPH
 HsR3e9avR02Q4GpJe+tPPLd3RCxeLs6KtmiKmbnQXLCtXFE86hyUPF1x+xdYs+BrD3fw
 A2ng==
X-Gm-Message-State: AOAM533OAfbwSm3wgAiUXHH5fxOUskIv5bhdBYY4bZMjKKPokB8XjiUR
 FBZ+sGiMGs8UN8wBdiRQdSLCUkav3zhduhOgZ7cHEuL3X2VtQZvOHwkkmyvZlcql/Gb071XiibK
 7IiRgBt9Z6igwmdiUu/6Fu8FgoGhONRppCtb+k1XwM57bay6+mkW4CD/BfhY2LTQ8ClTp9A==
X-Google-Smtp-Source: ABdhPJy6wt5RMowO8zj/XK0tDxqF5oCDvoTx8hC/w3ofvmgfuVtqYfu0icCviFdBDTxdv6AyYpCRfHOVcWc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:1502:: with SMTP id
 b2mr27109379jat.131.1635846425861; Tue, 02 Nov 2021 02:47:05 -0700 (PDT)
Date: Tue,  2 Nov 2021 09:46:51 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-7-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
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
index e5e6c92b60da..6b6ff81cdd23 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -23,7 +23,7 @@
 #define SPSR_D		(1 << 9)
 #define SPSR_SS		(1 << 21)
 
-extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+extern unsigned char sw_bp, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
 static volatile uint64_t sw_bp_addr, hw_bp_addr;
 static volatile uint64_t wp_addr, wp_data_addr;
 static volatile uint64_t svc_addr;
@@ -47,6 +47,14 @@ static void reset_debug_state(void)
 	isb();
 }
 
+static void enable_os_lock(void)
+{
+	write_sysreg(oslar_el1, 1);
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
+	/* OS Lock blocking software-breakpoint */
+	reset_debug_state();
+	enable_os_lock();
+	sw_bp_addr = 0;
+	asm volatile("brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, 0);
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
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
