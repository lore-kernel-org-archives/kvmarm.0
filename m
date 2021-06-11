Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BADC48BD1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D0D3613BA
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D0D3613BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DC374B087;
	Thu, 10 Jun 2021 21:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 51kNqQoeglwV; Thu, 10 Jun 2021 21:10:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E2AA4B09F;
	Thu, 10 Jun 2021 21:10:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D184B086
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ATXgAHE6mBUD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 21:10:27 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93B1A49FE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:27 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 r8-20020a0562140c88b0290242bf8596feso1505319qvr.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=g2jclRA9lTw/W97XJiMf53LRm15IYPw+1SChqYyccDA=;
 b=aLM0Vaaz+cyTp51TN8IDMX95LliI5Z426gW5UybIuMeG9DDvhdCPohwjwrhyx3S8/1
 7FG/7DB3hYJ16PkBgqsjpp07ivB3cYL24UPNZwRe0Z3Otz+ZZlym2BxyJ1yLfpaEnYET
 /GtXpFNEH1nyvf7pScc1prfSlHF04N5cTN9ojF1F2eLacZ2w/3bAIr4D/uUbCVkeEKOS
 a1DvdIk/xS0CHavMi7D8VON+bJzAAFJQWgX9DWB+FCSE4F09/NbsGNUXBHSxsCRdbt62
 Iv8E6Z0YvxCWQQTxjs/y1IHD+Bf9P1SrrZpqfba24eR9wlZAnB3z3iiFsMgeoOvkhoRM
 e+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=g2jclRA9lTw/W97XJiMf53LRm15IYPw+1SChqYyccDA=;
 b=GL2+ijTgG/2YR2MhPH6hO9GD+svaHu4WMOOyPbpCh5pOfIxk3XTscxNVdp2XjEwQij
 A9VYv6sq5/AFf3+/v5hli5pynmVgu59rNz505WMjzR7s6x6Y31SgjjJv5Kl7BIcDY7Iu
 IxYb18D3pmLCxdJdNc8jmwHnTGBCu5i4bq24NAYQnIAkNuplCXKB2HX8zZ0gHDnISIEu
 PX4RvpThIAwFr2a6zEjIS66MWS9TV9Ry5LD6kwHjAJJ0tHJ3OSOVsoR5f88p6xffFX9d
 MvyhF8Gg1DbmfX/qN1W+s4oZRQHiGSb7Com9GnMD9PMGvTLOZ6KvEifbCdN7o5IeBgog
 u+hw==
X-Gm-Message-State: AOAM533s2vQyHna0fhRZtMGf/Hsm2ljeTU4SR22Lj+DcDtUYhWICUnRC
 6xGRhGNZBYagFq4IQVRlxGcUEyjOY3DXBg==
X-Google-Smtp-Source: ABdhPJwS2FaokvitUzUEJhjnFOTvGpUM0p0dmA7rKoXpD9NblRj9EjqQzR8QSlMKVNeHfOQpz47kYBdAtVFv4Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:e047:: with SMTP id
 y7mr2400895qvk.46.1623373827053; Thu, 10 Jun 2021 18:10:27 -0700 (PDT)
Date: Thu, 10 Jun 2021 18:10:16 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 2/6] KVM: selftests: Complete x86_64/sync_regs_test ucall
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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

The guest in sync_regs_test does raw ucalls by directly accessing the
ucall IO port. It makes these ucalls without setting %rdi to a `struct
ucall`, which is what a ucall uses to pass messages.  The issue is that
if the host did a get_ucall (the receiver side), it would try to access
the `struct ucall` at %rdi=0 which would lead to an error ("No mapping
for vm virtual address, gva: 0x0").

This issue is currently benign as there is no get_ucall in
sync_regs_test; however, that will change in the next commit as it
changes the unhandled exception reporting mechanism to use ucalls.  In
that case, every vcpu_run is followed by a get_ucall to check if the
guest is trying to report an unhandled exception.

Fix this in advance by setting %rdi to a UCALL_NONE struct ucall for the
sync_regs_test guest.

Tested with gcc-[8,9,10], and clang-[9,11].

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index d672f0a473f8..fc03a150278d 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -24,6 +24,10 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
+struct ucall uc_none = {
+	.cmd = UCALL_NONE,
+};
+
 /*
  * ucall is embedded here to protect against compiler reshuffling registers
  * before calling a function. In this test we only need to get KVM_EXIT_IO
@@ -34,7 +38,8 @@ void guest_code(void)
 	asm volatile("1: in %[port], %%al\n"
 		     "add $0x1, %%rbx\n"
 		     "jmp 1b"
-		     : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
+		     : : [port] "d" (UCALL_PIO_PORT), "D" (&uc_none)
+		     : "rax", "rbx");
 }
 
 static void compare_regs(struct kvm_regs *left, struct kvm_regs *right)
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
