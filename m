Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BB6C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:39:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D29AC4BA2D;
	Fri, 25 Feb 2022 08:39:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id otCdbqkemZ-F; Fri, 25 Feb 2022 08:39:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A64434B9EB;
	Fri, 25 Feb 2022 08:39:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A7C4B972
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:39:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WKidgbhvw2iV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:39:06 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 225344B96F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:39:06 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 i131-20020a1c3b89000000b0037bb9f6feeeso1570077wma.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 05:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
 b=SaLP7VFxlAAUSia04NKVwItE0Qp3jy3z06hhaS2eREtAb5mr5fQwCWzyDOA+oFvIBq
 XJp4dqQy2yi0jDI37+KerSkKj7sPmC3shqY8Iwuh1MHl4P3C+iE2LPtsgSiU1qkdLguN
 HUN/kz1uWommFn626N//gt0SF1rLHQshWsq6gWgSQAsU/slveGGwzko8mZKIgTRE2BZo
 CJD7z2E7BRkWBU2zy/es714usPf9lZLeaFP5Y/Xcn/Dj+xAVokOQsCCOHAk+KXcBaPva
 MuLd/l1BdWGbW1ozOaN4mHRlolXEmygO/tHvospbu3b/tg6GkAjYAu2PLqrdp+j8LVzH
 tEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
 b=Wxl19gLI/M+Lv5SkJ5aAY42XkDYXIYPYgXoTAQ+QXpKH7nJU2udR+5x/RT9+pfpZrc
 IxQYZlL9xX7iExihJOD6PszH0TOI+8iQob6JBdXoFXrXYBa3DW/6O+ectJ5GmrgjP4dj
 tFxN0Do5Ms6OAscBXisCipCl+OVBvJASFVAPJYUOBU9ajG9iKuI+iRItoZTz01GKJAff
 veQYreLHaI09RHsVYQp3brhalv7nCv2b2vHse4QhWqUCsQd6ZZKnk2wJ1v8yUpEoigOH
 gOcWT1+3uED8xvjW9G6rs46tPdyFvG0XNGjGte8BIBZQ2JSOnFhxgPtQvkqE0+jha6ko
 oIZQ==
X-Gm-Message-State: AOAM532M/aiHL7A05xuo4Nf0KxdRPwJ0XhWxANSnf+aIsHaL7OPAQzRQ
 1NqPyko071wdWJcfM1Fa1GlxltX7evzOpVXmUG0=
X-Google-Smtp-Source: ABdhPJy2oC2R+v03jw69Q2wfAhlKqs4s0XFmL1++/WHIYOv2lwosSEHRypfQAewDVOInZXLXHe3u1i2DFny47DUwwBU=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:19c9:b0:352:d507:9e89 with
 SMTP id u9-20020a05600c19c900b00352d5079e89mr2736990wmq.92.1645796345279;
 Fri, 25 Feb 2022 05:39:05 -0800 (PST)
Date: Fri, 25 Feb 2022 13:37:47 +0000
In-Reply-To: <20220225133743.41207-1-sebastianene@google.com>
Message-Id: <20220225133743.41207-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220225133743.41207-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v5 3/3] Add --no-pvtime command line argument
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

The command line argument disables the stolen time functionality when is
specified.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 builtin-run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1..7c8be9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
