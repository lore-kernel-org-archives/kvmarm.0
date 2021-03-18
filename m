Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EC8C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E7E064F38
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E7E064F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4484F4B765;
	Thu, 18 Mar 2021 10:33:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k+Jf0KGvDD1l; Thu, 18 Mar 2021 10:33:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 572334B773;
	Thu, 18 Mar 2021 10:33:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C82C14B67C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HUdSE0C4IOnP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:33:21 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E61B14B75C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:21 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id b21so27438810qtr.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 07:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4yorTKVSopArcwmappZzIDRC5qqOoR8zuzElFyZZIHU=;
 b=mMKV8WLfrdZq00b2Nriw3Yu5oEsTLN7bIxE9EusaguOePq4u3LAZgz68BLWbArnd3H
 Mz6CFG1LXfL8zCxSXjUCxA9zVgzipI0IJcjshI7CEnz3U9lqx58sc9MMfXi6lxKJSZvZ
 STJydzKt3/ESu1kRwTKOgL5nNii4PAAJhZz+FPiI6gOzQT93tCEaOTUOsv3BbaztiChi
 4a+LXXmiZYMkZnkiyBUlDVXyzl+m510pTSnlkIG/9qUlV76Ga/nC9CEMUH9IFvgVdJAQ
 MeUsxhoFKCneNp2Ljz//b6AZmJTKeVL9qJLldoQo1Ug/RE41ys29znBfCQFwCpz1WG43
 pndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4yorTKVSopArcwmappZzIDRC5qqOoR8zuzElFyZZIHU=;
 b=aCRYzOwzCZIagD1u1Fh5jPshspUQ8MLOC1ooIFaXE0kjHl9rfGn9wL5PQFOufDH/88
 Eq/xHXm9jovQuvY5GNUUVZhlVvDXkuQe+LqsjBB39NKxLafmZsIABm/Y8ILoH0/N9MA0
 WRSkpK7lAVZRfavNFEEmllHeOSLsJy1QVXVpjikTNPZEnH1xuc5vbZcanZSNC/GwtrtY
 vIvJ3nX9+vT6pWP6rgPSl5Iu+VbPGrrI7oIPOqD6piMBrCFs2qr/saH6S8V+RQ7Sh3yL
 oxkQOqdyfpgYzNTp4uMI7VBk+LQ4I+uHj2MgNzw7uetSDdVBVWxRJWfTlxyD0VknHuK+
 hRXQ==
X-Gm-Message-State: AOAM5312BPXm8APt5EOOeGV9sAUUA2jc1KCOnn3jrnNivDgIA7gLDUZ4
 bDHb7mWnyeJp4AzmUbyjCj8Nbjc3Pmtu01C47H925/pcXed+tTQhdEY6jSNyxtFdfa7tUkPm4c7
 KEmZrpzhQxqp7ZEO+MKUUrHO34zhU08Kfzs8Y5NS8ougW7yGDOFICTiXe+PPjT36BvZtKkA==
X-Google-Smtp-Source: ABdhPJwCWURno1lYmEfjBcgXnCbqWFna5ZZGJ7FjVnDsQvqqDMmiCr+QJYEpbqbv2sdVbdI5Dy5dArnXI7k=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a05:6214:d6d:: with SMTP id
 13mr4551673qvs.60.1616078001448; Thu, 18 Mar 2021 07:33:21 -0700 (PDT)
Date: Thu, 18 Mar 2021 14:33:09 +0000
In-Reply-To: <20210318143311.839894-1-ascull@google.com>
Message-Id: <20210318143311.839894-4-ascull@google.com>
Mime-Version: 1.0
References: <20210318143311.839894-1-ascull@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 3/5] bug: Assign values once in bug_get_file_line()
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

Set bug_get_file_line()'s output parameter values directly rather than
first nullifying them and then conditionally setting new values.

Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
---
 lib/bug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index e65398082cbc..45a0584f6541 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -130,9 +130,6 @@ static inline struct bug_entry *module_find_bug(unsigned long bugaddr)
 void bug_get_file_line(struct bug_entry *bug, const char **file,
 		       unsigned int *line)
 {
-	*file = NULL;
-	*line = 0;
-
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 #ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
 	*file = bug->file;
@@ -140,6 +137,9 @@ void bug_get_file_line(struct bug_entry *bug, const char **file,
 	*file = (const char *)bug + bug->file_disp;
 #endif
 	*line = bug->line;
+#else
+	*file = NULL;
+	*line = 0;
 #endif
 }
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
