Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B511C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 17:28:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7AB4B24C;
	Tue, 14 Dec 2021 12:28:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZzG2VH8jLuwF; Tue, 14 Dec 2021 12:28:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E896D4B235;
	Tue, 14 Dec 2021 12:28:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC6B4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sNGptcjf42wQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 12:28:23 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99F7D4B235
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 12:28:23 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 s199-20020a6b2cd0000000b005ed3e776ad0so18291889ios.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2KsIfF/OkZ9dy42g5M0MSW1Bp0JJrNex4RjUkPqKNds=;
 b=BTupxORVlkQAx/Iy53cFyu5AChY6Dwql1j31uAUZPphY3Jkui/DZwf9uw/Epm3gPtH
 hhofflryL/VpdwS/YjAPHRLHjUiQ7tfPr23XRtOSeu33fEtjMwJoAibQ9ny7R0BsrLkI
 1m5llWRHwW1COSo0402NBQtIYNNDTHrVwVP6maaHol9MJoUZK5s7nE3zBRw0wnIXNhSm
 cblJ0vEgi9/GfY2FtvAP6pUgeNHIJiw3zuhTXUQuhydKDKcab5ntd30uRQ4g6NmhjZt5
 1t5Motk6j/C51AN5IwNjSy4tZ8SOmuicISUuHtolxa31fcA0htcP47S+v4+2gnq/0/sg
 7D+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2KsIfF/OkZ9dy42g5M0MSW1Bp0JJrNex4RjUkPqKNds=;
 b=hgd8jY10TPsenVKMyhzbFiR78ilosHe5LFv3B0r3FKQB+zDKkfJojLQqYzgSHVju9G
 4F5rnqul9MRU4V0/E5ArIbrMoqUx4PH0Kq0226vlAyYk+9Tmrc67NffQG6gQekFMEc4f
 1xqZmOiObPdlwQuFmk8KVS17gY2RjLDzUOeHMydKYBxXDQywhr/lDXNGOj+9YnnRvgVJ
 Lt9gm22ZPHqv0u716za0hrI3dTsgZSeuX6/94SkyIf1mBLWHKwi2cJXCsgxpPZxgycNi
 m/ZPnOLmgsoXNDD1lqtq050f4lxzwO9MDBeHO45mtcOaTf6gjqJHP0dNcRIoOGrP1FUc
 pFnQ==
X-Gm-Message-State: AOAM53139VpDHzxgH1dkbhaH5hQ+GGwVuo+eusKZyx9ataZ7fYTPHvwa
 Xxz8QhmYZD2lHhRBVTBoDw+1K1o4cVr5Qf8v3tUyVHm43Y3kojnvj2Jhyklj3iGsOc9jQF/7sJy
 qL5EY00Ko/gKabtPhEJeM3HiprmU25Ovk8jqxb+HFRcdeQHM+Zphcl2LampeEtMZ4DwwkHg==
X-Google-Smtp-Source: ABdhPJwobQAZeq2s7m3v81+Wf50FFSnaXP3bVgG+rf4cUMi0f5NKEKThGGU9QLnF3Rxf9jtnho1DIhl9g/k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:2162:: with SMTP id
 s2mr4543585ilv.247.1639502903053; Tue, 14 Dec 2021 09:28:23 -0800 (PST)
Date: Tue, 14 Dec 2021 17:28:12 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-7-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 6/6] selftests: KVM: Test OS lock behavior
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
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
