Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64534C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 15:58:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D91DA64E60
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 15:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D91DA64E60
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CEDE4B1EC;
	Tue, 23 Feb 2021 10:58:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qO-994jbu8Fy; Tue, 23 Feb 2021 10:58:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82AC34B1D7;
	Tue, 23 Feb 2021 10:58:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADCC4B1A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 10:58:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kcSUBvqnFrxR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 10:58:10 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2702D4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 10:58:09 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id v130so1381317wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 07:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=6MyHeS31EL7bb0VItKWbX1lwx1Ls4GM48RMPtv0hqg4=;
 b=sHwtQ4UiQgGx7PNngBOxhHH0QJvSlwMJAiVMluP2MC/J9jQqXygpnJgWGeWeWK7mhh
 DPlqCq2RV+vZ6YFXQDv8WIymY0p2uwiS67hLx+Wiy5T78lsZZLGNvHFNKx0N/aUzW8hY
 1XItvuBNhoFciEiklvIDniZc2Z4mxn1IxY9cXewGZ92PcNss8ZIe3kBzREkDt+PWHco2
 h/tpjbVMefbbOgfdnXL76/m0V7qngItsVjELey+wNZ+08VU2O16QDwWvByAmHIoIG1QI
 HNMxN/AzvSrbNIw+LHRGjAExCnQ/zXtLqKZcRgB6HlIV7L+TREQ/Gh4ERCmbfrwjj+2a
 Tpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6MyHeS31EL7bb0VItKWbX1lwx1Ls4GM48RMPtv0hqg4=;
 b=YBOc4rGHVZlVsbf/+SHMy2DGnHSvFnnsZHD4IxtwS/orEZ9s7KwMrY7K1ih0kD255T
 dNThEBqiM45w9/mTooD9TGZWJ4knFUqerH9tIVzH4lV58hlCMzIEJ+Vfk43wLJArYvKG
 MXccy0FhB3wwy8YA09dGcuF9BcPlNOmOYAnJn+HQSNgnZGoSExQk69sFqmkNZSdxXIDi
 vgP8s6mbCh+13jIADEpaaeLZTv4QW9VzNh58ISTnqx62UkiwrwkKC3u9gxAEn+3AxjN3
 f1oYIkK0yPqap880iJokbHk+5JxISuMUfQmVx7+UTbfs5RK4LtIurQOeKT9bpn8caKe4
 ZsKA==
X-Gm-Message-State: AOAM532Lr9GHvXdPR8lqAzK4WTKil/eSKk7FJw5fCCFK34F6yalPaWhv
 SMaYEwBzUFttyXfydD1/wMLO0LhTrOJ1w+LnEGcWfR2vGWUTvf6dWeD2gfNODFCVIIx95Ar+997
 InoJFYz58uwBlZXhWsMPKUTj7fVa5mBMGYsFTNzZbkEpB4GFouVicifNk80VYsc4WGs9M0w==
X-Google-Smtp-Source: ABdhPJyi1NEYRySQoJ9bCKgZ87lgzwQsxEV6eju9zsWcd4dPWKkzJgwL2iSidbgzKw+k31pCnQRJ/zgWfME=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:2e90:: with SMTP id
 u138mr30106wmu.0.1614095887853; 
 Tue, 23 Feb 2021 07:58:07 -0800 (PST)
Date: Tue, 23 Feb 2021 15:57:57 +0000
In-Reply-To: <20210223155759.3495252-1-ascull@google.com>
Message-Id: <20210223155759.3495252-3-ascull@google.com>
Mime-Version: 1.0
References: <20210223155759.3495252-1-ascull@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH v2 2/4] bug: Factor out a getter for a bug's file line
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, Peter Zijlstra <peterz@infradead.org>,
 maz@kernel.org, linux-kernel@vger.kernel.org,
 "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>, catalin.marinas@arm.com,
 will@kernel.org
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

There is some non-trivial config-based logic to get the file name and
line number associated with a bug. Factor this out to a getter that can
be resused.

Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
---
 include/linux/bug.h |  3 +++
 lib/bug.c           | 27 +++++++++++++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index f639bd0122f3..e3841bee4c8d 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -36,6 +36,9 @@ static inline int is_warning_bug(const struct bug_entry *bug)
 	return bug->flags & BUGFLAG_WARNING;
 }
 
+void bug_get_file_line(struct bug_entry *bug, const char **file,
+		       unsigned int *line);
+
 struct bug_entry *find_bug(unsigned long bugaddr);
 
 enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);
diff --git a/lib/bug.c b/lib/bug.c
index 4ab398a2de93..f936615176b8 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -130,6 +130,22 @@ static inline struct bug_entry *module_find_bug(unsigned long bugaddr)
 }
 #endif
 
+void bug_get_file_line(struct bug_entry *bug, const char **file,
+		       unsigned int *line)
+{
+	*file = NULL;
+	*line = 0;
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
+	*file = bug->file;
+#else
+	*file = (const char *)bug + bug->file_disp;
+#endif
+	*line = bug->line;
+#endif
+}
+
 struct bug_entry *find_bug(unsigned long bugaddr)
 {
 	struct bug_entry *bug;
@@ -156,17 +172,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
 	disable_trace_on_warning();
 
-	file = NULL;
-	line = 0;
+	bug_get_file_line(bug, &file, &line);
 
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
-	file = bug->file;
-#else
-	file = (const char *)bug + bug->file_disp;
-#endif
-	line = bug->line;
-#endif
 	warning = (bug->flags & BUGFLAG_WARNING) != 0;
 	once = (bug->flags & BUGFLAG_ONCE) != 0;
 	done = (bug->flags & BUGFLAG_DONE) != 0;
-- 
2.30.0.617.g56c4b15f3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
