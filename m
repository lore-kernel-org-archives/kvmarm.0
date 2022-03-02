Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FCCC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:04:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB00D49EFE;
	Wed,  2 Mar 2022 09:04:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w2lF0QiYknlk; Wed,  2 Mar 2022 09:04:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B03849F10;
	Wed,  2 Mar 2022 09:04:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B85B840BD3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:04:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXUDONXDstmD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:04:14 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A303408F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:04:14 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 a16-20020adff7d0000000b001f0473a6b25so383252wrq.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 06:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
 b=o82nPL0gjuRITu2Bpvs73uaFUhovxw6j9Yj+PwDYqJVsUrJl8yGIqUHkLQEbjbZGuj
 musFv7EoafDf3+YQUZh1aClP174TK1/Fw246qwJF/2Xjg9ZzeXxv/t6qjBzDnxSXfLSB
 TlWck78RV+WJhh+fRYwBWnTqc7PHznX3qV1dNWH+ZjZ423onbPqKfE8SHqAqisRqPh/V
 qskswbtXL9ZLVbsuz81ckiZh8IxZRCY6OiyRItCZjLu9zG2eQzMRUpGv9+yHt7TU81Wc
 bCJeOT1u7DMko70QurcxhI+OX5xY1Pn4D/0msQgy7sdBeRTgG1FsMZFwn/HBUDCm1iMO
 amRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
 b=OMvmegbu9+YH1ZFNMDGABQBcuZAkUiru+mODMKs+1GMqIQbQw10T8jPSGqbsvFM4P1
 eB/BJAJlAtO7PT6YVFg/ijA9/EZ7w/TPEqGIG3dN+kYqsUOfiqSiBfJVMycL9rU6waEF
 hidb7IqzlTHon/DHy3dSeW4QY6dAz+M2dQVmirh2tWE6dMl7dxJbFbGOQbVfhPXhAIxE
 XXKGaIqg9zRPPrA1qGAj5Bz5KnLHF/tuIor2wV5NABX1Fqgb1dycediJOdlMQKRhjDsn
 O3g1gL516MbckHWbab6XkKLE3PHokdl6+lQN7VDnyMtLY2AoKf3Nnz7YkTQiFbJLN2Su
 FeJw==
X-Gm-Message-State: AOAM531jRyNBa4uwTBTre47i+aCySKzvWfO7pi+pQ16Fjr5LqbGgaZ4w
 s5FZuaqIbhDq+38Wslz4VCbLuIfWe6nekBz8+Uo=
X-Google-Smtp-Source: ABdhPJycryaeuYs8h0GXiIUO1a3dPk719+zggvGmtMKCP/FVfX3wD6UQPMkWO3x74478oMpaY38LQr8H34MwKJcEff8=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:adf:f201:0:b0:1ed:c254:c1a2 with SMTP
 id p1-20020adff201000000b001edc254c1a2mr22939127wro.106.1646229853496; Wed,
 02 Mar 2022 06:04:13 -0800 (PST)
Date: Wed,  2 Mar 2022 14:03:25 +0000
In-Reply-To: <20220302140324.1010891-1-sebastianene@google.com>
Message-Id: <20220302140324.1010891-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140324.1010891-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 3/3] Add --no-pvtime command line argument
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
