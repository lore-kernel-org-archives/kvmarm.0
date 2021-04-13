Return-Path: <SRS0=w1us=JK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6867DC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 13 Apr 2021 16:19:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D18456135C
	for <kvmarm@archiver.kernel.org>; Tue, 13 Apr 2021 16:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D18456135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4078E4B721;
	Tue, 13 Apr 2021 12:19:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SUUxNT0PboEP; Tue, 13 Apr 2021 12:19:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 249884B5E8;
	Tue, 13 Apr 2021 12:19:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB2C24B6C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 12:19:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0bq+YxobnC5x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Apr 2021 12:19:54 -0400 (EDT)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF9534B47F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 12:19:54 -0400 (EDT)
Received: by mail-pf1-f174.google.com with SMTP id w8so8272628pfn.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Apr 2021 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=VAnLORvlHA0CqhWSiodUxhmbW4p+mlvry+H7OH+CbM8=;
 b=jkoKZqeVIYBjCxInSCYoqSg0XQ8Pbkd85pgdZVfgriZ3+PtrG6vMzyERgsyDYVR0Rz
 N+ygGl/63+WJjWzlJkMhAinycxSYkctyxOz60d2KAL8Ky0aVrdGE9EGExwLLR6+b8ER2
 ByaeDBLWwQMAzmm7dFaYBvMkGmHz1PBdF94wh4XM45OwdzuQIhRpIqZXxOsIcy+oUpl/
 SJbkATsW2YHWO5ctZdCbJDe8HAuCucGS6odzRhBvr3c+y4JOZf1wGcjzyVyI3g2cHVFH
 idFnV3Z67WlQcWMA8wPrdxF489fIFJBgcthrL8e6n0UadnUf7o1u011q9LriqTASXr8t
 JXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=VAnLORvlHA0CqhWSiodUxhmbW4p+mlvry+H7OH+CbM8=;
 b=SeRmP+csTwJk/ZxMhT40R6GW6TvFX4uJZpaafGALKGnniYG4ZprPKRp3UfL6zlyXi5
 UPGHAljntJiSs/g/q0hLgSns+ZRYK7WP0imAP3CKxqUlaQZN06bO2ggNgnE/r3HB6qFa
 +Ii+WwGzzv9l72+qh86nyOBM5pBBK3NlscvJ9lRE0OhV4xrL4E3QIOyvNCVUf5PwskNs
 B++xzuFWoHAn98AnMO7nMtBE/7g302TcEOFQX6MiPsBUWvC6le5cHtVfQV+MY2myQ5ln
 qxJdUMnoiK/w5W/Yt5Ou45AtvkNYudaCijMjw1l3SXHYutQis54TANJjGn2fo6+RIyjE
 GyQg==
X-Gm-Message-State: AOAM532p8Il8VqUgEUpZCfRT6hD9YIoXv0N5Tza9C6zzK9+/8E2/JggF
 ss1RdSRK78470q+xoqMCeGU4cQ==
X-Google-Smtp-Source: ABdhPJz8SAQ/o/1a7/grAkz4uQOp6weGn0EjgYR/mhwyip2GjzJeZ2A2HlSdnlBLwWS/wRs+FLWmvQ==
X-Received: by 2002:aa7:86c9:0:b029:245:1c62:3499 with SMTP id
 h9-20020aa786c90000b02902451c623499mr24759311pfo.74.1618330793766; 
 Tue, 13 Apr 2021 09:19:53 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106889e681aac74.cg.shawcable.net.
 [68.147.0.187])
 by smtp.gmail.com with ESMTPSA id s16sm9718172pfw.94.2021.04.13.09.19.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Apr 2021 09:19:53 -0700 (PDT)
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: maz@kernel.org
Subject: [GIT PULL] coresight: Fixes for ETE and TRBE
Date: Tue, 13 Apr 2021 10:19:52 -0600
Message-Id: <20210413161952.750262-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: anshuman.khandual@arm.com, gregkh@linuxfoundation.org,
 coresight@lists.linaro.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The following changes since commit 4fb13790417a7bf726f3867a5d2b9723efde488b:

  dts: bindings: Document device tree bindings for Arm TRBE (2021-04-06 16:05:38 -0600)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/coresight/linux.git next-ETE-TRBE

for you to fetch changes up to 68d400c079978f649e7f63aba966d219743edd64:

  coresight: trbe: Fix return value check in arm_trbe_register_coresight_cpu() (2021-04-13 09:46:27 -0600)

----------------------------------------------------------------
Hi Marc,

Please consider these two patches, they are ETE/TRBE fixes found by bots.

Let me know if you want me to rebase on your next branch and send the
pull request from that.

Thanks,
Mathieu

----------------------------------------------------------------

Wei Yongjun (2):
      coresight: core: Make symbol 'csdev_sink' static
      coresight: trbe: Fix return value check in arm_trbe_register_coresight_cpu()

 drivers/hwtracing/coresight/coresight-core.c | 2 +-
 drivers/hwtracing/coresight/coresight-trbe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
