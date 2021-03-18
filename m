Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FCFC4332B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BECF564F40
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BECF564F40
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1724B750;
	Thu, 18 Mar 2021 10:33:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5gCFH3ObawcM; Thu, 18 Mar 2021 10:33:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 322CE4B766;
	Thu, 18 Mar 2021 10:33:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B00E24B767
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B1H3GQ-egggS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:33:20 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45ECE4B76F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:20 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id r6so6944903wrt.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Vcjkzbqq0DIh2YJxrcQtSaFwk3LR7PDa4wFQHNf0SwY=;
 b=eD3f54QPpEd8CLWVkhZ+EBBg4e6Px3k6fecoy3bHN41UX3Q9tPF1zgG872cN2Cnc6t
 e2bKXEnJO6EgJ77IjWSGJVtFij/gCaubvJcMXUACwcMiRxTQfqmeT7P49/UZ2tx2xXKI
 umFZZbEICo0wmS6xFL+TQGZy46zC44H2JaXgyhCVTrQ0rGGn4wID0BR4phgyg3czvqen
 LBYMmvTnEmaoN0wUQ/TuoyP/jxCGX+fTl7yQKC/o7iO9wsaPUxdN5fihw4k8/5cJz37N
 IoLeTsSg4F0WDqG61xiXH3MMZKjEQ8224HUBJPOfq9fuzk+h/KKB75e14sfMBODEvuHO
 M50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Vcjkzbqq0DIh2YJxrcQtSaFwk3LR7PDa4wFQHNf0SwY=;
 b=U3xzMG4lpQAggG692Sr5/LdN2711uq8+UX9HGGZACRQakXsvBT8I+84BJoMEfDWnN3
 ZnHKxOC+NFndhpUX+azLYfy3hezY85/vr39erAI86NXV4IFJ1HquX9whUq9WYaiwYu6h
 6TviTPPBxhAQXenKyaH74Ic1s40jSPU68SPp9QroYKbkV+UAkI+PrgfFBQ9nHGn9Fjwg
 F7ZaA9px2SP1Olw0b4LVAutD1+3dhall/cWAOge5Z+IooWdb9MoZ6PrtkXObevVlyJ6Q
 xtR6UBR1C3kDqORm0SiuNuDKrsr0L/KR0smTk44ZKkrTjXAtqUgmx4xIbL2XxvE0zrqJ
 z/Eg==
X-Gm-Message-State: AOAM531q5EJpF9YIxUtbXRvRhgZ5fD1gX+5C8pySIJqwfHMz89kr2efJ
 jC83W+BagV+SJkS0fFAGjN7nbamVlDpKgLzsIc9GhXVOmMIz5UDQB042keo7Q3atgfL0Z8EwKOY
 JSDF3wcdS2hRf2mmpWvOQC5CvJHVq7KtVGE+sVIRtxI/FUtkU75tPe+3n914Cvkn+MEkb6A==
X-Google-Smtp-Source: ABdhPJyuFfoLOw6DpsksNFOuAKZF7Zq1yTYRjd9IQ+1KbNTlUiwEVZjqBoxv6wG2R24+7Xq8IctfKmK/INc=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:f614:: with SMTP id
 w20mr3937594wmc.70.1616077999257; 
 Thu, 18 Mar 2021 07:33:19 -0700 (PDT)
Date: Thu, 18 Mar 2021 14:33:08 +0000
In-Reply-To: <20210318143311.839894-1-ascull@google.com>
Message-Id: <20210318143311.839894-3-ascull@google.com>
Mime-Version: 1.0
References: <20210318143311.839894-1-ascull@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 2/5] bug: Factor out a getter for a bug's file line
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, Peter Zijlstra <peterz@infradead.org>,
 maz@kernel.org, "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>,
 catalin.marinas@arm.com, will@kernel.org
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
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
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
index b92da1f6e21b..e65398082cbc 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -127,6 +127,22 @@ static inline struct bug_entry *module_find_bug(unsigned long bugaddr)
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
@@ -153,17 +169,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
