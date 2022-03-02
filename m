Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F22C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:09:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C62B49EE7;
	Wed,  2 Mar 2022 09:09:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8H4wEsD4fJ9j; Wed,  2 Mar 2022 09:09:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3EBB49EF1;
	Wed,  2 Mar 2022 09:09:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E87E49EED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:09:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HX0sGGZCzRqe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:09:10 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7833C49ECE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:09:09 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 h206-20020a1c21d7000000b003552c13626cso1971017wmh.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 06:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
 b=FjxCZDlfXaxRwHfpStekSFRfty5xR39pRWkcjDvKdnGVMygWG5Mwi+p0hhjxdw/RT2
 sZSpglnEdw1J1FLxCmkWlzkjjFqTlgFdneuWtn/VZiz9KrQyDBi3A8C66BXHBQrBQ2NO
 lTfe9Ou0aW1Bw+l71ugkWDjPZbQ/e0aAysoLvMk5o/TH2A6atIOo1ftOQMRMO4PfH5ah
 lybUOWtbbltwTZIn6pMI+i+8lXxQEEqopn5tSgIBSpPBsKTQ9+AV7Fi+TIvm7WPhKXYV
 2UgFKIurGc9dlxk/efmb6yCIQYWiRZbOqkbiiHsB4so1a8yJ8W0vmhOLrjF/hzAMdTR1
 a80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
 b=i4FjZmu3vLhOyFRpqM98xXuiIy0bdiqVZaDk0rF5BrB5a5cSfHT/e5WyBG2pYItv6o
 FUb/RfOloZlLyag5TArCf+G8Io7aQiL50KrTMKFuyWWukRv2cMvqWCnxuxcQkz/GtMGd
 v9OOFMKyPq0Lzy2XVySFA4tCWHw2dknnUc6WBsLknep3hkPRZ2GMG3QWO6WOJqMX+Dl5
 w1AknA1ydHxIlyuACGgQlHFgc2ONcVl7y5VbcoHN5udFQ+L0Zwf/eaLIvDnaB62vX/mP
 ouaAqfwZp7UmYXVtmE6/EGST1wKQqdDYf7jk7k1nziTShW1JyqeqCOEJi1+anAbY608f
 othg==
X-Gm-Message-State: AOAM5316amqg9g8/24pyhjlqY4JYq+sIkhcOPt9Zqud1qgefNy61U1N9
 GYKky1zP34Yw9RLrC45clYlaJlMz43CTPg9wOOQ=
X-Google-Smtp-Source: ABdhPJwb6hZ17w5iUMZyIGJw+t2Y/ZKStR5guKfZp+57tXdK+IVwLkH7uUwCv2Y/UGJ66duGol11rRcqTuqz5sVj3jg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:430c:b0:380:dc2a:b2c1 with
 SMTP id p12-20020a05600c430c00b00380dc2ab2c1mr20010516wme.39.1646230148618;
 Wed, 02 Mar 2022 06:09:08 -0800 (PST)
Date: Wed,  2 Mar 2022 14:07:36 +0000
In-Reply-To: <20220302140734.1015958-1-sebastianene@google.com>
Message-Id: <20220302140734.1015958-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140734.1015958-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v7 3/3] Add --no-pvtime command line argument
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
