Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75442C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 16:55:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CDB4B995;
	Thu, 24 Feb 2022 11:55:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xJzWBEWTHA+L; Thu, 24 Feb 2022 11:55:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D99824BA36;
	Thu, 24 Feb 2022 11:55:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F454BA0E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wj4QYtH77wXT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 11:55:48 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 566DA4B995
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:48 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 f189-20020a1c38c6000000b0037d1bee4847so101014wma.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 08:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3UAm59KDixqFfoef0ljTGT0yrk00dLv4gMpJOzI1zE8=;
 b=UTC9j5VDOPq2RCkEnvcZlXk4MXhXwmAMZJs/aVBFLf5fmnutKqxbr7cAACbP0p6982
 1kg4j3nnGK2yLbodd6JNw+I1GY/kiwJftH1U58qV9wt7R0G2Ut2ATqQ8TzSLtuzDHlmE
 174B/pbRW+jP+nxe1ty0WdxbIexYZ8bPJzELaicucm9Gy5J7DRE2aFLIg8Rp58sMTahU
 mGrYu5xMEEVqDL73Imv22uOR+k07yY5gGya57bZu3YV/EU5w79/yhOASRkJPOGqidqjS
 vJA+6hVMCcp9e7Dclk83Yk+jpYyk9kcyf3chS0/w82Er/nR5m/PqZImESKypMspQkI5K
 B3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3UAm59KDixqFfoef0ljTGT0yrk00dLv4gMpJOzI1zE8=;
 b=Pbh3EDAYGVpmJP/CLofE5PTg6/fLgF/uumSvNFzHjOd4gTLtBIZU293cxXjBLXEduB
 FWcM0HWPstTjBulVpm9pes4HHztAz6SvOlOc3Y5trcDgvU7Otw9yQtM7u9NySFKT1kkf
 dScBCeWCa0JPS1N8nNS6SQ8hhSx2j5KyVhlLS9TAjC+36W2DOrhFhx+O20tQCUpxo6qg
 BAlgE5Dguwtlp66hbcm6ephH6SDJg5cdTSuAE1AxL771wL5Rm2itCFpAhRAPT0bNHqvK
 yo2G5nKQB/R+ek9LXKZz7BdorWkVlq6vXURcQUW9p3kkeMQN6DTGM0ewc3/NgFb499pY
 WjAQ==
X-Gm-Message-State: AOAM533N/K1tGelf+UgGBes7EJDUyUfJUIhErq+2hgKmSWlBi2jxuARp
 /G8NnraOYdLGdk8s7LDTBj8OWn1clHKhG/qiIjA=
X-Google-Smtp-Source: ABdhPJweSypprU2//1adFOt+scXePFLmka+aoQVmYLh6J9nO4iBzaGIi8FFKN/REX4tSGV8l795usgi7UXfG+/iQnnU=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:418b:b0:380:e493:660a with
 SMTP id p11-20020a05600c418b00b00380e493660amr3022320wmh.189.1645721747528;
 Thu, 24 Feb 2022 08:55:47 -0800 (PST)
Date: Thu, 24 Feb 2022 16:51:05 +0000
In-Reply-To: <20220224165103.1157358-1-sebastianene@google.com>
Message-Id: <20220224165103.1157358-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220224165103.1157358-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 3/3] Add --no-pvtime command line argument
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
