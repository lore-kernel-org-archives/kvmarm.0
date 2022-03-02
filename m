Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF215C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:08:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B66249F00;
	Wed,  2 Mar 2022 09:08:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I6rJEApSbHMO; Wed,  2 Mar 2022 09:08:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58CA449EE7;
	Wed,  2 Mar 2022 09:08:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE20A49B0C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:08:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fgunkod5nCfZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:08:47 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6BB4408F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:08:47 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 z16-20020adff1d0000000b001ef7dc78b23so676035wro.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 06:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=lp9zEaIv1S7ZBdqtPNsd+5mYg9mGXB6Zu8tr2wXg9a4=;
 b=DRaPF5fNY/BernAWTuDUoEGJ+DCvOQP/R6LOZXSoloKXxCxKNTf7P4DIAyXln1G4qT
 fBtxpuEVmqlR74bOGGsqTH+1RellxjU4iM9z8GdjSw9ltdCbeSsCUTJ+tAilJJErt71/
 jy73Nx7nXSIWhT4tbAfblXGAT7pULkeFFFQReA8HKM/9WQBlYlvsbuaMWy09nYmxzCM1
 MtGFpfuAx9r6ACNG5FPKQft5s4ggMv2a284dJnT5Vm2wNo3zsTXFBt5zqLvUrDyJfSzN
 ycGWqFCBCAwPIPpAfjGkcft8kvOva4eLWIxq8vcdHiIvzxxoFmlme9MRkqlx98ZXyQ33
 LKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=lp9zEaIv1S7ZBdqtPNsd+5mYg9mGXB6Zu8tr2wXg9a4=;
 b=zmfNE3sAXV2MtBCs9/lYmKM90EQ7AAAyc7In+TZefSFXbVF4C/8Ncw2jWd5SUZ/VpG
 RRHl/Nx+qz/LAovzuRgCoV7nYioKmXRMCV1wb88zUjijhtk5qs1jHXU7fmGCpAotGWcU
 OYTAw7Y5l0BwwAQKTaCg57+QImMnaLLtnAIYWdxmWcYvoPXfOTEFAr5ErTL8yg2ebYIN
 oKhrGHLC1rEaJ4BR/PMd8X3azpzRDUW0SRbtD3hWpaIl7JV/xF75DUrZ292yTNKu53L/
 9cc9DE0ybY61tAQcE61DgPIDlpEntq6q9ipI+mqoOiurHazgwof9G0trTzWRGsqV5o1r
 LrMA==
X-Gm-Message-State: AOAM533/y92UfjYfeougSgZFHl0V/qMdgJiUcJ8jrdtPI+S7StzuacAW
 6dGj3jYIhFQfIb8wrlLvIglCgTZG8ErjYxWHsfs=
X-Google-Smtp-Source: ABdhPJw6N9e7jtLkHBc4dWy0BeHH2pQI2EHtLYbs8cEU56ynxaYFdF3wbWy63gxs9iGvZsPsey1G4jU0Bh98dAjfmMI=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a1c:4603:0:b0:381:19fe:280b with SMTP
 id t3-20020a1c4603000000b0038119fe280bmr20695290wma.67.1646230126801; Wed, 02
 Mar 2022 06:08:46 -0800 (PST)
Date: Wed,  2 Mar 2022 14:07:32 +0000
Message-Id: <20220302140734.1015958-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v7 0/3] aarch64: Add stolen time support
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

Changelog since v6:
 - fix perror number of arguments

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
