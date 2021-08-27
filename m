Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA7AC4320E
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 21:58:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67B5260FD9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 21:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 67B5260FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB74E4B0D1;
	Fri, 27 Aug 2021 17:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uHcTWXR-Lnib; Fri, 27 Aug 2021 17:58:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCDA04B12C;
	Fri, 27 Aug 2021 17:58:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44CC94B10F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 17:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ff6P7k1LQqUJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 17:58:34 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13F474B0D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 17:58:34 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 c22-20020a5d9a960000b029059c9e04cd63so4815675iom.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zEqo65HFDniYflruEifCzsGz9EVUlfE1N13W9ndiFw8=;
 b=Kf5wvNW/F8mZENQSvB6E0t62gx2c13xS9fZ7bvLOY/uUK3eG29DV9WfFReAeHMMBM6
 uUIfykSV6VJY80Hh2Z4401C4axUd3T1FM1WgeyixkrnoOfVlrFTia4IqSCo9VNRR2JSf
 IhWdS3onWejDsQ+4rvGuHBdvmHdVj9gdHdOFTvU6U7r65c5ICMAFOZ9iMMmz9J93v5s7
 PQ4TCjXWljFu7DI7EuSpYQwq/0P9KKzBuoy0lJw85BNlwCd+aVFGymOad//ol+aX/457
 wiBbeBSWej8la76YXEOxRQqW5sP8X7MjRQXfoV5C2eReoKsOR2rdng0BFMInfbi6wV0h
 iWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zEqo65HFDniYflruEifCzsGz9EVUlfE1N13W9ndiFw8=;
 b=OJgxVVszg4qL1xiGsd6mLark62925OCbOUFtq1G7Cfmf/sk/R6V7NOhLkNMECngW6I
 cBbI0oZ8VH8DqBTxu7VFgAaj6gEiS8oACig9vOLos6PSMEOJEZgXuomycoK+K6z4i5YS
 5TELS00BNzlk5UnOqKLJO20XPGGjCiLEm8Vz+XIre84GZZ5U4XGurxXKSKXLhO54dGj/
 kJRYEEWVG1XZVBkcpFE6qDAXe7j1ii7VbO0yLJrrfJwmDY6rMwdQ3HHf348+o+gdN8rU
 zs9nBdZPE12hU7WvG9CN8Zw/qxOEkvZdbKkhhTPZ7vEuyWsaym3nZPJFZZ7zXJeFJAs2
 vBLA==
X-Gm-Message-State: AOAM533FDDmRkNmDsOJkma2Y82owgCT5tAwxe8sEqrmcHygo8jBESi5B
 MJFJgKCZbhxiG7OwH0Wp1JCHbRP2R0I=
X-Google-Smtp-Source: ABdhPJwffoNQdD/D+ASti6AvwuymHnK3xqKzLwLel1ZYsRFrWbbSuNMVpIKrlgv4Bqgz/Bcn4un7QeXuqUQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:cbb0:: with SMTP id
 v16mr10001890jap.114.1630101513235; 
 Fri, 27 Aug 2021 14:58:33 -0700 (PDT)
Date: Fri, 27 Aug 2021 21:58:25 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210827215827.3774670-1-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [RFC kvmtool PATCH 0/2] PSCI SYSTEM_SUSPEND support
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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

This series was developed to test support for PSCI SYSTEM_SUSPEND
currently proposed for KVM/arm64 [1]. Since there isn't much for kvmtool
to do for a suspend (we don't have save/restore), just restart the guest
immediately.

Tested on kvm-arm/next kernel with the aforementioned series applied.

[1] https://lore.kernel.org/r/20210819223640.3564975-1-oupton@google.com

Oliver Upton (2):
  TESTONLY: KVM: Update KVM headers
  KVM/arm64: Add support for KVM_CAP_ARM_SYSTEM_SUSPEND

 arm/kvm.c           |  12 ++
 include/kvm/kvm.h   |   1 +
 include/linux/kvm.h | 414 +++++++++++++++++++++++++++++++++++++++++++-
 kvm-cpu.c           |   5 +
 kvm.c               |   7 +
 5 files changed, 432 insertions(+), 7 deletions(-)

-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
