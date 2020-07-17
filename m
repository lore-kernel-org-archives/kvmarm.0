Return-Path: <SRS0=EkBd=A4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867BDC433E1
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 20:52:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34F832070E
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 20:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34F832070E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36A74B15A;
	Fri, 17 Jul 2020 16:52:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id guAgtayvBxG7; Fri, 17 Jul 2020 16:52:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B8674B15C;
	Fri, 17 Jul 2020 16:52:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C26254B13C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 16:52:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v1kQ5gYpFjUO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2020 16:52:35 -0400 (EDT)
Received: from mail-io1-f66.google.com (mail-io1-f66.google.com
 [209.85.166.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B64444B146
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 16:52:35 -0400 (EDT)
Received: by mail-io1-f66.google.com with SMTP id v8so11801461iox.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 13:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=mhs5FFai87Ig296v3TqrQxrtuK3e2ENuVof1kjV7dWA=;
 b=hWIDvpTcnL4RwR5P8D9LJvdIg26ZyAUrjAyn8D3vJKh+uB22q8TnuE+mGGsVGUdBu9
 wec/pq+Hzxm+ra4tKWO8qhQGlxB3aUe7d5f+1Hn9v2mDsxhg833Jc++RoSqzR7OdkONE
 Ag3WHkpLGVjU1LxiUYJ4AsQO5ugv4F83GGbEEee3bwmW675TahVuILMNRpLfUUWPsVhk
 LVkQpEun+WlR3ULGpXl/Ofz/vnzAVTpgJreG6crnq9j0qXYNc7+bkM/j0U+85syMpIZx
 FquJ5fHP/aPH7+MFyzeeksq8S9sXzhM6fzlGnzLhg94VsNNxuxCwDPhcjys2mTSpUBAs
 PA+w==
X-Gm-Message-State: AOAM5303yfcczVqWvzEQY8QSigHk7DepeJlk1wncPlqC7nhBwU+cQdKO
 +k9sdEsT5NX2+7sbHpT2jw==
X-Google-Smtp-Source: ABdhPJykbjET3b/SbtFLSHBP8S5wWN1jyjxTFrVnyhE4WKqweYLocoTBilT3/POJRVbrAlfFyG5H7A==
X-Received: by 2002:a05:6602:2c08:: with SMTP id
 w8mr9219239iov.129.1595019155142; 
 Fri, 17 Jul 2020 13:52:35 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.252])
 by smtp.googlemail.com with ESMTPSA id 136sm4737492iou.50.2020.07.17.13.52.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jul 2020 13:52:34 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v3 0/3] Cortex-A77 erratum 1508412 workaround
Date: Fri, 17 Jul 2020 14:52:30 -0600
Message-Id: <20200717205233.903344-1-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

This series implements the work-around for Cortex-A77 erratum 1508412.
KVM guests which don't implement the workaround can still deadlock the
system. This is also the case with the existing Cortex-A57 erratum 832075,
so we add a warning message if an erratum can cause deadlock.

Changes detailed in patches.

Rob

v2: https://lore.kernel.org/linux-arm-kernel/20200701215308.3715856-1-robh@kernel.org/
v1: https://lore.kernel.org/linux-arm-kernel/20200629213321.2953022-1-robh@kernel.org/

Rob Herring (3):
  KVM: arm64: Print warning when cpu erratum can cause guests to
    deadlock
  arm64: Add part number for Arm Cortex-A77
  arm64: Add workaround for Arm Cortex-A77 erratum 1508412

 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 19 +++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/include/asm/kvm_hyp.h       | 11 +++++++++++
 arch/arm64/kernel/cpu_errata.c         | 10 ++++++++++
 arch/arm64/kvm/arm.c                   |  5 +++++
 arch/arm64/kvm/hyp/switch.c            |  7 ++++---
 arch/arm64/kvm/hyp/sysreg-sr.c         |  2 +-
 arch/arm64/kvm/sys_regs.c              |  8 +++++++-
 arch/arm64/mm/fault.c                  | 10 ++++++++++
 11 files changed, 73 insertions(+), 6 deletions(-)

--
2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
