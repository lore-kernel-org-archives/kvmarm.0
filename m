Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62ACC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B83A61411
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B83A61411
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F244B152;
	Fri, 24 Sep 2021 08:54:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PsPG90TMiwKQ; Fri, 24 Sep 2021 08:54:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4B64B16E;
	Fri, 24 Sep 2021 08:54:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 449574B187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8S2bPVrStsWI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:07 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D8AC4B16F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:07 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 k2-20020adfc702000000b0016006b2da9bso7995804wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mlMa5h5NI5jeUNwNwY7Kha/NGSkd/By+lOHKgGZzb0o=;
 b=SWEU9RA66/WxWXSbnVeHag8LsLPsWo8oCMibTA60uonOa2NMI7kIs3aQaiEtrgWRHO
 DkA5OZF8LVYzQT/cr+FTPum/wkwXOpSGn6mBFh8390Hiu7bF6dK1T2mmYPopzXIWmMyg
 ByH+xHvE1XIot1qXxE5Yurw1SAV9R/bSIpEHsErE6bNWq+FTIeI0q3cHMP95HMCchKHy
 /07xpwd4F+PMcWHR7BQjwKn6vitYvJfybxPNVHcL9VT68KII8o60yJbc7fP7HXCzKda3
 0SaLPyDqoC4Fh2pYJUv7rcuaRI3FlofdyqHQc/x/5vPvpDmPLw8FioGLue3WQ2c6a5dA
 5IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mlMa5h5NI5jeUNwNwY7Kha/NGSkd/By+lOHKgGZzb0o=;
 b=kwFz/T3e5sAR47LMVBr/L9UXtX1mkoT+qtL62Vs8tkNv3OoKV1YETYQVBDiqFMECN/
 KumbYrkuC/8zw+PzLNfe3it8sKGUWEeIl+zk80QG6YWbYHjc2slQb0ezpwLDjkKPRczE
 /yfzbBlJI5FjAoEH5phe4xwaVEYnI/mko8qFBLv4CaIdMpNPXfP7ZZUpe0gzzrElTnAq
 MK2usOlDJsgNT8UGaBaolXG5aSVsKtd49DQYr7Baw96+PlE/L6YiBmtypGlseQVDTj3i
 J5tW8jRWhkL36KolKajTZmcszZ7EB3c6ILGCxiWuMdOIoIP4Sh5MugU+cZJD6tnyhOA1
 PSmg==
X-Gm-Message-State: AOAM533W+4kBxFoOsjMmmN7nZ9oLkN2aoTCYbhKZCfdOu3zHzLlJ7F9Y
 BnxoYKB0Z+NYbTUYeEWxE4uO9r3OoO8SlJ7EXVCSfU8dXTEapD9/ojjKpIhpHfPBOeoo7ohtdXc
 isRldHMpkUtndE/XX1BgKya/1rm++/fTHAPCCfgbJ1f1jSg90/uOcZYJg48cAhFhXfPg=
X-Google-Smtp-Source: ABdhPJx6zVX5jtlMJbOyL+BbcPj3DUM9DjQf7WdSun6TSGOTKmjY7ZrgMDMtNn5ZOQ8+TC/ja/ahR0SWWQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:598f:: with SMTP id
 n15mr11204398wri.74.1632488046306; 
 Fri, 24 Sep 2021 05:54:06 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:31 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-3-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 02/30] [DONOTMERGE] Temporarily disable unused variable
 warning
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Later patches add variables and functions that won't be used
immediately.  Disable the warnings until the variables are used.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ed669b2d705d..0278bd28bd97 100644
--- a/Makefile
+++ b/Makefile
@@ -504,7 +504,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
 		   -Werror=implicit-function-declaration -Werror=implicit-int \
 		   -Werror=return-type -Wno-format-security \
-		   -std=gnu89
+		   -std=gnu89 -Wno-unused-variable -Wno-unused-function
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
