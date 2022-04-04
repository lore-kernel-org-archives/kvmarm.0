Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0531BC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 21:46:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 816B74B176;
	Mon,  4 Apr 2022 17:46:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DjliN7QYNu7o; Mon,  4 Apr 2022 17:46:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76E254B2B5;
	Mon,  4 Apr 2022 17:46:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0BF4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EOV02ZfRKzYF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 17:46:49 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2DDB4B176
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:48 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 b7-20020aa79507000000b004fa88200f15so6638768pfp.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=X0Eqwo1ZquA6BfDuIBc3jv4V/VhgN11Hle1bIEmosEc=;
 b=RvR9/xm2sTOKqL4Ey7mY8e6IBFYpDTDkZb7nMkyCptp6xczgVBQJ0GHp1KQBqXMea0
 AyMVPgW60UGoArOqgkLM5AmUn2GD8ry6vw5en7ZWwNLm9ti0rqfYNWh6kS6FSaa6hU8N
 TMYHlznwFItOJZruV0bSzznwi0bwcDqXIyTnT+vDYRsABnXLq1TrTyrnln4xFtIYlPhc
 cKn5Pw+jseSynJMMw9dFe089573EY5dCWvPpiZvr3IAKrri7OfIx50hd6rYhjOjBRQtJ
 0CD0FN0fE+O31HR83627xsCqft1PBWqn9TIx3h2o9r3eopjBUI5AO+KeIawNcX22WXWg
 h93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=X0Eqwo1ZquA6BfDuIBc3jv4V/VhgN11Hle1bIEmosEc=;
 b=hfTDDicyZfVb/EKr4zYefTGFXhNtCL6Q+fxmSI4HfSmUxcYlm9ltt2zZfGUf/J6wwT
 vP0IeOUDy5AjnahhMuCI3UuqKqrSBqOd3k4B2+8zt6RdBO6YEy1eLAou3ycapX2/m1St
 +Kwo56bYwv1i3v24uXAj5bpHRcEGe+QMjHbl4ZNX0T+kAuuc3Qd0YPPNupIWm/eqEedP
 rYuCEZnainkb9Q9eERrNHasp7BgTr+5+AIQSlA79PKH0snOnJCxynNqElxjwjcug0hKy
 ySgCAlMXL1PkZOEdSy1RvqqnrNnuollXpZqz1EXpoK/naTXaHBGIzzWovi1i0LcondSe
 4Vvw==
X-Gm-Message-State: AOAM531RJkaTlupzGGe72AZHewEdPfl4RVDxaHp7DO9qzZfxxopOx9zX
 W2RsSSRLW8RyCTEjAMJ+J+x0cQ4IXL+E3w==
X-Google-Smtp-Source: ABdhPJzWUiVyZnp4hJzDOKmy+w+tHcRBborB+zzQYM4y5M3UwVHtIXcVRL7fth5SAn7e2ZEZ0Y91i+LtJoj5/Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bd95:b0:14f:40ab:270e with SMTP
 id q21-20020a170902bd9500b0014f40ab270emr215490pls.101.1649108807930; Mon, 04
 Apr 2022 14:46:47 -0700 (PDT)
Date: Mon,  4 Apr 2022 14:46:39 -0700
In-Reply-To: <20220404214642.3201659-1-ricarkol@google.com>
Message-Id: <20220404214642.3201659-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220404214642.3201659-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 1/4] KVM: arm64: selftests: add timer_get_tval() lib
 function
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add timer_get_tval() into the arch timer library functions in
selftests/kvm. Bonus: change the set_tval function to get an int32_t
(tval is signed).

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..93f35a4fc1aa 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 	isb();
 }
 
+static inline int32_t timer_get_tval(enum arch_timer timer)
+{
+	isb();
+	switch (timer) {
+	case VIRTUAL:
+		return (int32_t)read_sysreg(cntv_tval_el0);
+	case PHYSICAL:
+		return (int32_t)read_sysreg(cntp_tval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
 static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 {
 	switch (timer) {
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
