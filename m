Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2517C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 16:55:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6A54BD3C;
	Thu, 24 Feb 2022 11:55:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n019wWRvSF34; Thu, 24 Feb 2022 11:55:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C794BCAE;
	Thu, 24 Feb 2022 11:55:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A93434BAA5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 20aeIpRWJHJ4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 11:55:21 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E1B94BA9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:21 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 p18-20020adfba92000000b001e8f7697cc7so120699wrg.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 08:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=8eG3BHpM/pHHc3R0ch/z2uogmexgsI2rbr+g5HBXYag=;
 b=XDg+9ijjvQJ8968p7ma+EgrSHPv8bdl0Cs4Wd6KCPT21KVG7X2eJoSMUVJKWrQilIn
 qcBb3OX7yM7Vac5du9WJs1A08yBLwJFJAEepzTsoQzzhUE9YtfVCXSs+LTc4nXZeRq4x
 V2Dm78BNYzIGznFLloWx3Lv8odGkXx+a4LxYrNpuAamMt+WyKJRv8nOZ+mRCSqQ+Dp2k
 tQcmc+TI4c8tzq5UY6gHZ5iQrz/I0UBbpOEt1VQqeCvE/bgwrAiVuP/YF//e9nQZqeUI
 Oiv7tLpSswoxrlS7vyem9XLQo2kOkb99osJhP+sRuPR42II1ixRBgXXIMYqGybLVPHLN
 1vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=8eG3BHpM/pHHc3R0ch/z2uogmexgsI2rbr+g5HBXYag=;
 b=SASxmhftTRgxi4j0V/H88ttO0STU2hbi4ckQ1PIcEzA2sWk1GIAJAUDwCMaxDBVso7
 7CxhJ+XAzZnxgK1VA/rHzaEB1/AKEWwy8BG6N7098m3tawZFOyKi6QI/tuxDaca51Vyh
 EnuuznoC6Y0AB4L7QCRySrYrkz2g2BqSbcMJulQ5Fh18zl8zYKOIxmghReggXfEwPQ+8
 ot5QqUOp3HLYJJ0GndQp7kMLzpt/vCe/oAPoCFb8nHcf5oqosueJ9JAm7YP+RJDCjlP2
 J7bBQYUNlm3aeLaNSicpsLePVAevr30goCv8El9cpc6e3eNVkE/0dith8v4TcaH/9dem
 8J4Q==
X-Gm-Message-State: AOAM533yMELl8PVF4gncZIheSJoX1UFAkYgSoHsjkpljRCw3D4kssMhj
 Pn5JCw7EF+iZdDGOOcgLfNTvsut/VTgQ1IaiI8U=
X-Google-Smtp-Source: ABdhPJwTaBY56IPy5g8BXFs7IGGuJhg6CZOzWvHj9FmXWSTwQINWGl7hsZPpTiBeipVyFPcYOnMmrn6/IEV3NbLyR/I=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a5d:47ac:0:b0:1ed:164f:8ed0 with SMTP
 id 12-20020a5d47ac000000b001ed164f8ed0mr2932127wrb.622.1645721720231; Thu, 24
 Feb 2022 08:55:20 -0800 (PST)
Date: Thu, 24 Feb 2022 16:51:01 +0000
Message-Id: <20220224165103.1157358-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 0/3] aarch64: Add stolen time support
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

Patch #1 modifies the memory layout in arm-common/kvm-arch.h and adds a
new MMIO device, PVTIME after the RTC region. A new flag is added in
kvm-config.h that will be used to control [enable/disable] the pvtime
functionality.

Patch #2 moves the vCPU structure initialisation before the target->init()
call to allow early access to the kvm structure.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

 Changelog sinde v3:
 - Avoid the pvtime overlap with the PCI(AXI) region by moving the
   peripheral in the MMIO zone, after the RTC.
 - Split in a separate patch the change affecting the vCPU structure
   population
 - Added a new command line argument in a separate patch.

 Changelog since v2:
 - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h to
   arm64/pvtime.c as pvtime is only available for arm64.

 Changelog since v1:
 - Removed the pvtime.h header file and moved the definitions to kvm-cpu-arch.h
   Verified if the stolen time capability is supported before allocating
   and mapping the memory.

Sebastian Ene (3):
  aarch64: Add stolen time support
  aarch64: Populate the vCPU struct before target->init()
  Add --no-pvtime command line argument

 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  1 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 94 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 14 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 8 files changed, 112 insertions(+), 8 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
