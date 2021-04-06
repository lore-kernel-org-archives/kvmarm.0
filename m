Return-Path: <SRS0=ghsx=JD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B83C433ED
	for <kvmarm@archiver.kernel.org>; Tue,  6 Apr 2021 22:44:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61D6C613D4
	for <kvmarm@archiver.kernel.org>; Tue,  6 Apr 2021 22:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61D6C613D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D50B94B72F;
	Tue,  6 Apr 2021 18:44:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8aa8sNeMASa4; Tue,  6 Apr 2021 18:44:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B66774B735;
	Tue,  6 Apr 2021 18:44:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFB324B735
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Apr 2021 18:44:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1-NqIn48nnxr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Apr 2021 18:44:40 -0400 (EDT)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECA954B72F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Apr 2021 18:44:39 -0400 (EDT)
Received: by mail-pl1-f172.google.com with SMTP id y2so8346742plg.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Apr 2021 15:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ydQPVFsDk2iufZP8Pwk0+yoCaEl+JPOZbz8HSe06cBU=;
 b=P9dhD0CQtilqryljLatmB/B3ObijoycWGtgs6GE7UPvcFnjhZGJzwYmEiqz7raJjgv
 e3elELphv/6K2kjkXcQ6US60Zcrtid1gTZkepHhaA0Zar1hw0Tdx0iMtMQ37BaVfrjnK
 AwxsfU8tFep58TDdTO5+xeSXhbtIGcFIzwbg2TKnw8Nr306gHfA6N/FO/8QcdHabZUTu
 ihsamGKwAosVCRCXQbY82Nfh/rK4VGYIygCrvwWKNrjbH7+xirDc3n4rntItRY/eqXIa
 SmgamR4r+Kvvz+yP6/8MCeYreNXg5IowaX+pKGxLW64MIxsKbhtnIpGqi+pGoVwekSis
 V3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ydQPVFsDk2iufZP8Pwk0+yoCaEl+JPOZbz8HSe06cBU=;
 b=pNS1kLgNawhe2qu+slEadeKq7SFmjdg5suLVc6mVNEzoClkgtnzELyKUzrwSj62DRo
 XIXsg3fWmzhG7KxBiy7WCsjVQT7/B6hBAy0+4Gu8deVTnokJhYpcL8LBTU0vlgvIsT4G
 pgiZKSLsei7eSFMv2utJ9xR/mNVKz4HlQiucCKZc1B+QxHsPuJzenOYFIK19JGWqD/nb
 NAkG0OP7x+uuZyj9IqTf6nBHptNWEG5LzYcrRgbr+CBBjtmxxPRzd/4SeQUl97ScXqTd
 FkNqI51aCMDZok38lByQD/E7+uPYTRa5HU0cbOXM0Aw2/Az9Mw+2jwkRUD4uy8HEuG5E
 7k7Q==
X-Gm-Message-State: AOAM531ckcYnpYyekLNTlLJQDfvIRNlAl36OcxGwbvTJenUhAColbxcp
 8rf4GfqF88cUnPYpv0+7uLixtQ==
X-Google-Smtp-Source: ABdhPJwtLtQX7kcsTyuHRf4E/4KZRByEV2n9JQaZBRjQwRoIlWTqjoo6FXFbxpOGb725pX7mCVT+HA==
X-Received: by 2002:a17:90a:66c5:: with SMTP id
 z5mr392494pjl.172.1617749079098; 
 Tue, 06 Apr 2021 15:44:39 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106889e681aac74.cg.shawcable.net.
 [68.147.0.187])
 by smtp.gmail.com with ESMTPSA id g3sm18620914pfk.186.2021.04.06.15.44.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Apr 2021 15:44:38 -0700 (PDT)
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: maz@kernel.org
Subject: [GIT PULL v2] coresight: Add support for ETE and TRBE
Date: Tue,  6 Apr 2021 16:44:37 -0600
Message-Id: <20210406224437.330939-1-mathieu.poirier@linaro.org>
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

The following changes since commit a354a64d91eec3e0f8ef0eed575b480fd75b999c:

  KVM: arm64: Disable guest access to trace filter controls (2021-03-24 17:26:38 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/coresight/linux.git next-ETE-TRBE

for you to fetch changes up to 4fb13790417a7bf726f3867a5d2b9723efde488b:

  dts: bindings: Document device tree bindings for Arm TRBE (2021-04-06 16:05:38 -0600)

----------------------------------------------------------------
Anshuman Khandual (5):
      arm64: Add TRBE definitions
      coresight: core: Add support for dedicated percpu sinks
      coresight: sink: Add TRBE driver
      Documentation: coresight: trbe: Sysfs ABI description
      Documentation: trace: Add documentation for TRBE

Suzuki K Poulose (15):
      perf: aux: Add flags for the buffer format
      perf: aux: Add CoreSight PMU buffer formats
      arm64: Add support for trace synchronization barrier
      KVM: arm64: Handle access to TRFCR_EL1
      KVM: arm64: Move SPE availability check to VCPU load
      arm64: KVM: Enable access to TRBE support for host
      coresight: etm4x: Move ETM to prohibited region for disable
      coresight: etm-perf: Allow an event to use different sinks
      coresight: Do not scan for graph if none is present
      coresight: etm4x: Add support for PE OS lock
      coresight: ete: Add support for ETE sysreg access
      coresight: ete: Add support for ETE tracing
      dts: bindings: Document device tree bindings for ETE
      coresight: etm-perf: Handle stale output handles
      dts: bindings: Document device tree bindings for Arm TRBE

 .../ABI/testing/sysfs-bus-coresight-devices-trbe   |   14 +
 Documentation/devicetree/bindings/arm/ete.yaml     |   75 ++
 Documentation/devicetree/bindings/arm/trbe.yaml    |   49 +
 Documentation/trace/coresight/coresight-trbe.rst   |   38 +
 MAINTAINERS                                        |    2 +
 arch/arm64/include/asm/barrier.h                   |    1 +
 arch/arm64/include/asm/el2_setup.h                 |   13 +
 arch/arm64/include/asm/kvm_arm.h                   |    2 +
 arch/arm64/include/asm/kvm_host.h                  |    8 +
 arch/arm64/include/asm/sysreg.h                    |   50 +
 arch/arm64/kernel/hyp-stub.S                       |    3 +-
 arch/arm64/kvm/arm.c                               |    2 +
 arch/arm64/kvm/debug.c                             |   35 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   56 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |    1 +
 arch/arm64/kvm/sys_regs.c                          |    1 +
 drivers/hwtracing/coresight/Kconfig                |   24 +-
 drivers/hwtracing/coresight/Makefile               |    1 +
 drivers/hwtracing/coresight/coresight-core.c       |   29 +-
 drivers/hwtracing/coresight/coresight-etm-perf.c   |  119 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  161 ++-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   19 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   83 +-
 drivers/hwtracing/coresight/coresight-platform.c   |    6 +
 drivers/hwtracing/coresight/coresight-priv.h       |    3 +
 drivers/hwtracing/coresight/coresight-trbe.c       | 1157 ++++++++++++++++++++
 drivers/hwtracing/coresight/coresight-trbe.h       |  152 +++
 include/linux/coresight.h                          |   13 +
 include/uapi/linux/perf_event.h                    |   13 +-
 29 files changed, 2053 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-trbe
 create mode 100644 Documentation/devicetree/bindings/arm/ete.yaml
 create mode 100644 Documentation/devicetree/bindings/arm/trbe.yaml
 create mode 100644 Documentation/trace/coresight/coresight-trbe.rst
 create mode 100644 drivers/hwtracing/coresight/coresight-trbe.c
 create mode 100644 drivers/hwtracing/coresight/coresight-trbe.h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
