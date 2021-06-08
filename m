Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E83C48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 963FA611BD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 963FA611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FF04A531;
	Wed,  9 Jun 2021 06:21:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 67yRKkjEJ5qq; Wed,  9 Jun 2021 06:21:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170924A32E;
	Wed,  9 Jun 2021 06:21:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59B444057F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gk3TG5ShgENb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 17:48:20 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5859E40291
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:20 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 j7-20020a258b870000b029052360b1e3e2so28687358ybl.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 14:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qXkSbOYb2IC3X2Tl5AKB9URDdm1XI6BUL14Xin2r7eg=;
 b=F9podaJObKk/txBttzcQCUMN3bmiUkX6RaROZiUt4OyZK4vESkbOf4/II5yKFotHVQ
 alHKMpjv3ojhTmGJfKR0t8Pyc3bB+pnSBywsc97WcltB+In8AABdaquDC6LG0mdDRJni
 uH97XjL/yCGjxozIBw5JWghGNQXCuEsCu9BK04G/h9CcBweO7u09GJQdL0rl/obTCjUz
 dgck6LWM7TZyL78hf1fLz0pprF8fjd7LbZBlbaBcNXq8Uxv6B5cctb1GH046oxmztpJ3
 xwTLXOmKNCU36JKeHjq8101RrY8QnGF03HpMmuFmQFoASYx3qaG24I2W95/80lYrhHBd
 YrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qXkSbOYb2IC3X2Tl5AKB9URDdm1XI6BUL14Xin2r7eg=;
 b=YT5GNgaD2nUN7I52kbSLiTCJnuRLb/HznAM2oiNAa2c/liiZbHoEZecS/zzPP1hQBc
 s5vWFeHBVbmEhEAB3d8QksRPjdjz2tuofkkK4DsndW5tvKtCpoFCwwcdi0P0R1tzBBhK
 Zlx68m7hSzk1Fu5V+mpzPzkzfMuSgYb5Rlpz3vbJbDedBrJgYh+Ls/XvTNB5X9vCOK5i
 kUG1LEk/4yO6dSwx+LW2SfPstkkFpqzrK+U92RrprZs+ZYzsl54as/wmBYSrbIOvRqiy
 q30ggB4bcuVfvpFTrHdpJm/X8MjGXAh205rV3MBu7mDFWoupQdly5HI89rHhbcegDaxj
 eE+Q==
X-Gm-Message-State: AOAM530XrvFC+j5ple9427xlEInZ2pAoGlF+G9GZMu2j19WRtVvz0xA5
 ceoO1KH8kjQbnzUEViJi5DkpRfud1BU=
X-Google-Smtp-Source: ABdhPJxckUBKZ1i6dYMHyxVrr1ezG9WhmAhLTg+a5+kWk0J+vJAtGDvqW3iEOXVnlBNIdoUd9FtMux/VlVo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:9bc4:: with SMTP id
 w4mr32208884ybo.168.1623188899905; 
 Tue, 08 Jun 2021 14:48:19 -0700 (PDT)
Date: Tue,  8 Jun 2021 21:47:37 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-6-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 05/10] selftests: KVM: Add test cases for physical counter
 offsetting
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Wed, 09 Jun 2021 06:21:47 -0400
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
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

Add support for physical counter offsetting to counter_state_test.
Assert that guest reads of the physical counter are within the expected
bounds.

Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/system_counter_state_test.c | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/system_counter_state_test.c b/tools/testing/selftests/kvm/system_counter_state_test.c
index 059971f6cb87..f537eb7b928c 100644
--- a/tools/testing/selftests/kvm/system_counter_state_test.c
+++ b/tools/testing/selftests/kvm/system_counter_state_test.c
@@ -62,11 +62,34 @@ static struct system_counter_state_test test_cases[] = {
 			.cntvoff = -1
 		}
 	},
+	{
+		.counter = PHYSICAL,
+		.state = {
+			.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET,
+			.cntpoff = 0
+		}
+	},
+	{
+		.counter = PHYSICAL,
+		.state = {
+			.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET,
+			.cntpoff = 1000000
+		}
+	},
+	{
+		.counter = PHYSICAL,
+		.state = {
+			.flags = KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET,
+			.cntpoff = -1
+		}
+	},
 };
 
 static void pr_test(struct system_counter_state_test *test)
 {
-	pr_info("counter: %s, cntvoff: %lld\n", counter_name(test->counter), test->state.cntvoff);
+	pr_info("counter: %s, cntvoff: %lld, cntpoff: %lld\n",
+	       counter_name(test->counter), test->state.cntvoff,
+	       test->state.cntpoff);
 }
 
 static struct kvm_system_counter_state *
@@ -103,6 +126,8 @@ static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
 
 	r = read_cntvct_ordered();
 	switch (test->counter) {
+	case PHYSICAL:
+		r -= test->state.cntpoff;
 	case VIRTUAL:
 		r -= test->state.cntvoff;
 		break;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
