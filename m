Return-Path: <SRS0=Uj0Q=JC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76312C433B4
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 19:18:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5FA5613AD
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 19:18:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5FA5613AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37CD64BC5C;
	Mon,  5 Apr 2021 15:18:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lDUZIBgGOcLO; Mon,  5 Apr 2021 15:18:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F352C4BA8C;
	Mon,  5 Apr 2021 15:18:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3387D4BA8C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 15:18:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i42UuFSslHP8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Apr 2021 15:18:00 -0400 (EDT)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com
 [209.85.166.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 062484BA26
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 15:18:00 -0400 (EDT)
Received: by mail-il1-f177.google.com with SMTP id r17so3246102ilt.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Apr 2021 12:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=YHLstFl2ku4bYCzz1WZkvX4oaw4PKWZ3DbDRoWQ+a5o=;
 b=gs7g7FNLclp85jxf6NJG2V2V4pjlyLLa6zhzNVE2zUDb4nZsY7AbQpqaurjeuM4FNW
 slAwYc/fSlBNYY7JmeHErixM0AavtryxP/2K/7ET9GLoMKkdsl4A7YBbdXr+el6Qditn
 /WjHUlF0wwiKqCVWpyVS3d/Gab5vBaC64ZFLie0pvzdvcDD45+svFQCzPCRJIWcnb6lZ
 wVZLPXEqq0aW9LG6dxALFfSEhsh/EZJTbGTa/yJr2bx8eU2cN8GzfqWJCGnpZwcx6kN+
 Bn7wVPwrEjz8xzJlHkzD8B6fesZj9i33Yb4xfl8qZMUn6EZnqrWNBVbjffoeCzYdlIDO
 podg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=YHLstFl2ku4bYCzz1WZkvX4oaw4PKWZ3DbDRoWQ+a5o=;
 b=tQgoEzd/Zl4TnHD07EExbOIkj+Pz536OLnxkMADCOHq6sIQjSoEpkNszXzOPprKPeX
 A3VLV77YpXsuJj4wz0AaOeekQR2SLRjq7yj9S1Bj0hlK6JjWrso2qB3d5RFxIy3AVuOi
 CRfoUIPTvV62m5iOxeZBDLymDWp1Qa/5/IaZ+WoR6xHR7C7+r1nktXL6DBjHFSXjnPS1
 BOTL3IS3YKF03AEAejeZxyqSJ+bvnfz8o3Pq5Rd0LQveKg92RJGNmTBzSu0rcsHLX4Lj
 agVWJcxRX95t8sHpT53SBlHtYj45XNM32uydKIbjjEAW+qlXwTwU2FGLz/aRffhl4QS2
 qfVg==
X-Gm-Message-State: AOAM531XEVQgpL+k1dhwLgWF+MZTm7dnj7nPMJ+Og++fOVJZOshu9e9d
 oNDGB4UlLCP16HHBsZMZeRsadA==
X-Google-Smtp-Source: ABdhPJyI2ULQNtPuXaK5HRHUd17HveUSE+nrgkCeFiECbb6TP1xMihwUNeTtfQoHtCe+DEH63AcTKQ==
X-Received: by 2002:a92:c989:: with SMTP id y9mr5101467iln.173.1617650279473; 
 Mon, 05 Apr 2021 12:17:59 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106889e681aac74.cg.shawcable.net.
 [68.147.0.187])
 by smtp.gmail.com with ESMTPSA id h12sm2510760ilh.32.2021.04.05.12.17.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Apr 2021 12:17:59 -0700 (PDT)
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: maz@kernel.org
Subject: [GIT PULL] coresight: Add support for ETE and TRBE
Date: Mon,  5 Apr 2021 13:17:57 -0600
Message-Id: <20210405191757.283122-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: anshuman.khandual@arm.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/coresight/linux.git next-ETE-TRBE

for you to fetch changes up to 7885b4e43231048654c5a80c0a18844ce3185e64:

  dts: bindings: Document device tree bindings for Arm TRBE (2021-04-05 11:38:04 -0600)

----------------------------------------------------------------
Hi Marc,

As previously agreed, here are the changes to support CoreSight
ETE and TRBE components submitted here[1].

I draw your attention to these:

[PATCH v6 05/20] kvm: arm64: Handle access to TRFCR_EL1
[PATCH v6 06/20] kvm: arm64: Move SPE availability check to VCPU load
[PATCH v6 07/20] arm64: kvm: Enable access to TRBE support for host

They are KVM specific and will need an SoB tag.

Thanks,
Mathieu

[1]. https://lore.kernel.org/linux-arm-kernel/20210405164307.1720226-1-suzuki.poulose@arm.com/T/#t

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
      kvm: arm64: Handle access to TRFCR_EL1
      kvm: arm64: Move SPE availability check to VCPU load
      arm64: kvm: Enable access to TRBE support for host
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
