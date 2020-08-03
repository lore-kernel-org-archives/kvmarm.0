Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF53DC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 19:31:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D49D322B45
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 19:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D49D322B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC99F4B6AA;
	Mon,  3 Aug 2020 15:31:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oZpYD+I32-0D; Mon,  3 Aug 2020 15:31:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0FDB4B6A1;
	Mon,  3 Aug 2020 15:31:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D63694B6A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 15:31:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rbKP-Xke3zTR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 15:31:29 -0400 (EDT)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C89334B5F0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 15:31:29 -0400 (EDT)
Received: by mail-io1-f67.google.com with SMTP id v6so24487907iow.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2020 12:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=UdBaePAIB9P/sNSZqXX7ZM1kjahKFZoeLOxBQjWLtkA=;
 b=CYI1zGogGP3qdUwY6UbZeV9H00kn/1sGcVb//tThcMbI/TKo56Ft8pGFdC18WCkRRV
 ttJ5Z3FG0KD7ivN3i2qpN4VclZzptjKc4PPA95Qmo4UteiOLjDxLfSDtoaiAOR8SiEd+
 Fb1r0scMm2yPyzZ3N6MfI0BMhqu0M3A3+wBJf+vKND5vGX2euFTNlajv0ft+r4dng80H
 fupnWoGp9VE8mKNcPdHV5IHoamFeFHXFqMAPKr5HYrCZqovq2b9FW+2mQ0+x0dZTlxAm
 OGkGabBvGRhduRhe5Xs8YVukfYvFA4wzPTSeT38UWay6O307POOinEBM3DIIoEJkVbFm
 P5Vg==
X-Gm-Message-State: AOAM532Ane9ei1KHi4yiZ18HL2Os/r/XnYEx3jTzRcE8G8ZreLeBhlCC
 DIUcvkK8I21nlJQ30ByXIg==
X-Google-Smtp-Source: ABdhPJwf6xlxOG4KBbtKiHnDTG3EEs4p6tr0qUav18Ic8FxOtIr4LyuCTaRug7Sl8HEYeaFt/D3p8w==
X-Received: by 2002:a05:6602:228e:: with SMTP id
 d14mr1432099iod.33.1596483089208; 
 Mon, 03 Aug 2020 12:31:29 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.252])
 by smtp.googlemail.com with ESMTPSA id j79sm11254738ilg.42.2020.08.03.12.31.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 Aug 2020 12:31:28 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 0/3] Cortex-A77 erratum 1508412 workaround
Date: Mon,  3 Aug 2020 13:31:24 -0600
Message-Id: <20200803193127.3012242-1-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

v3: https://lore.kernel.org/linux-arm-kernel/20200717205233.903344-1-robh@kernel.org/
v2: https://lore.kernel.org/linux-arm-kernel/20200701215308.3715856-1-robh@kernel.org/
v1: https://lore.kernel.org/linux-arm-kernel/20200629213321.2953022-1-robh@kernel.org/


Rob Herring (3):
  KVM: arm64: Print warning when cpu erratum can cause guests to
    deadlock
  arm64: Add part number for Arm Cortex-A77
  arm64: Add workaround for Arm Cortex-A77 erratum 1508412

 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 20 ++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/include/asm/kvm_hyp.h       |  1 -
 arch/arm64/include/asm/sysreg.h        |  9 +++++++++
 arch/arm64/kernel/cpu_errata.c         | 10 ++++++++++
 arch/arm64/kvm/arm.c                   |  5 +++++
 arch/arm64/kvm/hyp/switch.c            |  7 ++++---
 arch/arm64/kvm/hyp/sysreg-sr.c         |  2 +-
 arch/arm64/kvm/sys_regs.c              |  2 +-
 arch/arm64/mm/fault.c                  |  2 +-
 12 files changed, 57 insertions(+), 8 deletions(-)

--
2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
