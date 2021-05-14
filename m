Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9889BC43460
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 08:56:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30772613AA
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 08:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30772613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D398B4B954;
	Fri, 14 May 2021 04:56:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c6+kdzea9ZuA; Fri, 14 May 2021 04:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F097C4B95A;
	Fri, 14 May 2021 04:56:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99E44B57A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 04:56:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X1w2LoM5p3Ps for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 04:56:48 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 228974B943
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 04:56:48 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 1-20020aed31010000b029019d1c685840so19805206qtg.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 01:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=aopnk//SDnpJ5AImMYx3P4ml1ZmWNW5dd1IRRC1FNlM=;
 b=nI4SXmDFVjSF9mM3IederM47sMiWX+txfXxTqhNHm6MZP6//wiRIXTUWP15j3t6c7g
 SW1mvz+bz4wGSqtNzTuMM974e1MRvxIWI5N7g5uVQLOtTdRnzbh+PBdeEMgRBo0SUju2
 qid+zl/aK68pSqXHErdgIyTjb4W23as0rzyH/R6WQ1tRv1orJxf2591OVpqmqy9TUEh+
 r+FGcH/IZSLZddNbyOWTHzvVIFHwApuKrog9ja9cnHkBVj06qVqz6eEwuih6rKne7Kgy
 PMe5KoGy9DGhXvs0q/zPdwx0kMuhQhpaWamjaKrUM0xRC7lzA/nvJD9q9FQ0SZSVn5wK
 VmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=aopnk//SDnpJ5AImMYx3P4ml1ZmWNW5dd1IRRC1FNlM=;
 b=N43vMaUZxJq0sNRGiHoP8hcGhvLXQC25eBWUpdQrdza5MRaX3bL+AX+o/UbNGX9aaR
 3IDde2rXMxg9jV+Nm9yBqyhSKfQ12WOdMt8vAhHtr8yjAh2KNt9GOL3dJxCEjd4Z9Pab
 nVFZfY4dfwICYDgXsxn67KxNr8XcvFY+aMAWyCKHAXKPXPxS0AR2JayrW6toDkKmUT9z
 lARPySIQKozPBWRlG7QJzpXsZ+3Z7jxtv1DibQ1Ug2oQSzmCUgfQqq0fGmpN90bCgvw0
 RoSr0Fm1aVKLAmW0xZq5ZYF0MDrjbYp9s3Rq/s2r1RgRnuJ4cEgZBwOsQvN29RwI95PC
 T0GA==
X-Gm-Message-State: AOAM533v2ShTYjXaVyTpy5DuGi/XqsW4k5bXq7C2N5hTnAWwIAVyCB5n
 9WBwjxh7Oyjw9DigJsPtb6yiD7J/knInohZuTB9tSyo/dr5QFumA4egEq+8sGg9pqfP4/5eefnD
 Lm57gHAQoTuVEiIV+bBMvwlBniEoQ/3IdB5oUVbZe+54ToDYWER7ybFeZEksZIVCdC2pgnHH7
X-Google-Smtp-Source: ABdhPJzPWoeSZzr7z92gxGJs4PrD0quy8AiZx0TtXjO919SkiyI5AZ655jUqn7tUMiwM5AhVE7/YC0emj6/O
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:4634:: with SMTP id
 x20mr45517840qvv.49.1620982607504; Fri, 14 May 2021 01:56:47 -0700 (PDT)
Date: Fri, 14 May 2021 08:56:40 +0000
In-Reply-To: <20210514085640.3917886-1-qperret@google.com>
Message-Id: <20210514085640.3917886-3-qperret@google.com>
Mime-Version: 1.0
References: <20210514085640.3917886-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 2/2] KVM: arm64: Mark the host stage-2 memory pools static
From: Quentin Perret <qperret@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, will@kernel.org, kbuild-all@lists.01.org
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

The host stage-2 memory pools are not used outside of mem_protect.c,
mark them static.

Fixes: 1025c8c0c6ac ("KVM: arm64: Wrap the host with a stage 2")
Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e342f7f4f4fb..4b60c0056c04 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -23,8 +23,8 @@
 extern unsigned long hyp_nr_cpus;
 struct host_kvm host_kvm;
 
-struct hyp_pool host_s2_mem;
-struct hyp_pool host_s2_dev;
+static struct hyp_pool host_s2_mem;
+static struct hyp_pool host_s2_dev;
 
 /*
  * Copies of the host's CPU features registers holding sanitized values.
-- 
2.31.1.751.gd2f1c929bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
