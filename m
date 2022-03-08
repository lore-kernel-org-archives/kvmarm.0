Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C84C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Mar 2022 15:33:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 352B549EBA;
	Tue,  8 Mar 2022 10:33:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id glg7u1aMlmLw; Tue,  8 Mar 2022 10:33:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FF349EBF;
	Tue,  8 Mar 2022 10:33:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B419A49EBA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 10:33:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id THsgbSU9lbYi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 10:33:29 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BA1949EC3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 10:33:29 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 l2-20020a1ced02000000b0038482a47e7eso1306185wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2022 07:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
 b=pddi0OSiiw8dazmXtcwiTq02d0DXNRhXP19P0GEVAifH0Ov4Ygmouk8WLBNsu9/q+v
 Dj9KRSeqnZVQ7vnXFR5DjUv4Fk1xnfLYZ1cTi0r8sesB5VhXx6UA+PAhnDj/YuljOv+k
 tdGjM5YV/zTBAxZegz2pex89Qls2gA7Q6Md36Yu2vtwXZEHH0ylU0J9GZ4MXfqEuKMZr
 qxp+lvB07oZK+8N1oa7Rk6CiX5jp+cHL0j2i2xyZ8scfVf3tzCiGROaKUfaYC3bi/iWk
 H1tjc54tOH3qeYPD4OsY2+qmUO+jQ+5URHgCDXEhGIt9Kiue8pjF+MrBsm0zWe7F2Yxl
 QF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
 b=J+j5DMK2UXNADM4Yvk7PhHEj9ndXFR5ADr/hGZSd9lfGAwrxrnk/xLCu9j4iye0OW7
 J1iGwbZwvWR7eg+RLDsBNVpfgoxy3no4Ft9w0ULTQj2W+fLMjXGO3wiCjP0zzJAHP/Lk
 JqacilShqbKe/qiUPicgWsw1jy33v6CaRrq5/eXuB3bm85Hkm/TenFjddq59+Ec6tQhP
 1yqZStbInfI4kYUHCDnJ4inXbubiChe/EwrHIWBcojcZCC0XYqUNX7tkC/d8A4ueZhqD
 ov78oYFgY2Vm2yTnrCGAxCIWMtEGXO/cdGh0U0PUiCVtTcB+Zp4JE655NAVkBvNdj4NA
 5hFA==
X-Gm-Message-State: AOAM533YIGLJgJhgypX6XjegNZKy5rXSQieXwZbDwF0JiuDsOsl1fdAR
 YWZe0h+KPojbvrp1AMbS3Jzx5Nn+Y7lQBDT/DsU=
X-Google-Smtp-Source: ABdhPJz9IthMw6tJSFg3E2QKBXXnsfAhoYP/pCCNOHYFKDxtU/RBheveh/HjrORqAbwIF/t6jLK8FonxU9aCB67mCdI=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:27cb:b0:381:400d:3bba with
 SMTP id l11-20020a05600c27cb00b00381400d3bbamr4165855wmb.60.1646753608731;
 Tue, 08 Mar 2022 07:33:28 -0800 (PST)
Date: Tue,  8 Mar 2022 15:32:30 +0000
In-Reply-To: <20220308153227.2238533-1-sebastianene@google.com>
Message-Id: <20220308153227.2238533-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220308153227.2238533-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 3/3] Add --no-pvtime command line argument
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

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
