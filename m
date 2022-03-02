Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE30C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:04:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF66949EEF;
	Wed,  2 Mar 2022 09:04:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8i4ySc2oH2PZ; Wed,  2 Mar 2022 09:04:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A52C649ED6;
	Wed,  2 Mar 2022 09:04:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AA3F49ED3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:04:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tLE-mhx3ZrkE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:04:04 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ABC4408F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:04:04 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 f9-20020a5d58e9000000b001f0247e5e96so674928wrd.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 06:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=hPKuRtrZ7FciAHN0houkzwDHAjhc6VOJutEOMHbNfWA=;
 b=jbv65BHk8GqJHm2EmtbEtTPoARICcpi/WQbKKS7FdWkuEKfUHNCM48Q0jsI78A8yES
 4vRerRTJR0n75FIpBbWVkuk/iCG6UzT7EbwwcSveeIB9NRMBrZx/aDW4FQ+GptlpOzp5
 IWo9O9SLj9jKlhLeW7vEVl+Eggj9RlwN+5BElRSd84yMsO2D3T1TUCxrs9QShQOj37fZ
 Fxy7Jn5p3ZHFTXwIRDF5O25joN6L1FttWSE2bitSxTsUbxhjfRhc/BHdM6WVK++qXrq7
 GElNl7Uvw/Dapkyo9GSKF8shRbFBBeYiy9q3uY2udVW8kvAuHnOl4xFwhSOP70f+dx/N
 SoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=hPKuRtrZ7FciAHN0houkzwDHAjhc6VOJutEOMHbNfWA=;
 b=y5W+J2d8EZ4JPcEPfgTNVavsJufzuc9zOSVKK3TvPB/Gu4ZcIDMgc+rhSCBy29fDuD
 avVk4fq/ojwgNG0KjPjztU73UVqDGJ5qknxhWlENFCZ9/lhcAxVMFb762UyfmaNvP8Na
 KbiZL+nCslzqOtxaLfvTd8vwG5Wj/zrsKDfsMTe+M9I0qjKFcFTmWUaQLxbaolOKmps+
 q+0EJ991yo2rdtRKmFPRbJgRkWm1KqkVCuhwzC89rZwyQaMbjSMe+UV+dR8lxoA+Hwbq
 3JBz7H9F+9kmj4kj9IJX6w2si7VWVLKoT9pOAk2GA6MPI5pINKB55eubS+VSa1qmm0jk
 BLoQ==
X-Gm-Message-State: AOAM533vfEBDNgIMgw10TNAsIHFdFxj8r+lypgxtR4JZ/bNf0jG4Y0EL
 aIZmjbf3RHU1fjUzm0bCfzV100CuKD7QGssGGkY=
X-Google-Smtp-Source: ABdhPJwCwe0Ivn4oxuYW85DCZt8LEkoCUulaqDf9S/0R2XreVsB1ACODvonVA/kCsqzYygLXLLlKNtB9xtvojYGmmqM=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:3203:b0:381:b544:7970 with
 SMTP id r3-20020a05600c320300b00381b5447970mr5936255wmp.144.1646229843153;
 Wed, 02 Mar 2022 06:04:03 -0800 (PST)
Date: Wed,  2 Mar 2022 14:03:22 +0000
Message-Id: <20220302140324.1010891-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 0/3] aarch64: Add stolen time support
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

These patches add support for stolen time functionality.

Patch #1 moves the vCPU structure initialisation before the target->init()
call to allow early access to the kvm structure from the vCPU
during target->init().

Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
new MMIO device PVTIME after the RTC region. A new flag is added in
kvm-config.h that will be used to control [enable/disable] the pvtime
functionality. Stolen time is enabled by default when the host
supports KVM_CAP_STEAL_TIME.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

Changelog since v5:
 - propagate the error code from the kvm_cpu__setup_pvtime() when the
   host supports KVM_CAP_STEAL_TIME but if fails to configure it for
   stolen time functionality.

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |   1 +
 arm/aarch64/arm-cpu.c                  |   2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |   1 +
 arm/aarch64/pvtime.c                   | 103 +++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |   6 +-
 arm/kvm-cpu.c                          |  14 ++--
 builtin-run.c                          |   2 +
 include/kvm/kvm-config.h               |   1 +
 8 files changed, 121 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
