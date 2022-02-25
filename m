Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D004C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:38:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85A754086D;
	Fri, 25 Feb 2022 08:38:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DIdbzutXYQKO; Fri, 25 Feb 2022 08:38:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1549B40A84;
	Fri, 25 Feb 2022 08:38:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CCB140A84
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:37:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X6EvKRwElIgl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:37:57 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F2584086D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:37:57 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 w8-20020a5d4b48000000b001ef708e7f71so411818wrs.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 05:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=lRlQkk/1FSOqAzIUi1czdjgNvITE2xn5+VNcHfuDD5Y=;
 b=jlI2EM7HSlyX4dSYqNmsyrFd9+NFAD4FVNu1xxOXa3WHMWckhd4lnGBA2GsI1YGkza
 EzZBMbpMFm36wcuDn0mw+CeEypUG8gH7ZKYko/ahL2cqaMWg71YIHpN2VUBDDXzyH0zn
 97Ch9EU7TgYImdQWAtqxrm+hn5Q9PQcc7MyPZgJyElFBCHVNRT2j+uq27ycs9eJgY7S+
 of2NHcJ+ZjG0FCPODgoosiJoM1kF9VNQUIEAzZM6LK6rlLRaOznUfrrh/dmToA+TvhET
 LvujdBM5wREjhh9kR4vSYUSUo9ZC2IATQ8FK5sy/PgzbJ2UoOJetuX2nOnYarbejNhrR
 hc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=lRlQkk/1FSOqAzIUi1czdjgNvITE2xn5+VNcHfuDD5Y=;
 b=J2n2wPL2NI4Cauf84zBK64PYxMA4wZcWUyAqSDtc8CIntwT1NZdYr/GCR2V1NGH0Mu
 c+0ED/kiyuHf748UtDy6WpOpHqE0KBxkMCntlWnSK5s7gGDMhEKjx4aWFxMRfs+cTd7q
 Lst8D59LXTD2nqxQKQbnOct5GNfqOAY29e01pa1AfUTtXwNRGe1iKOaFd103uMJI3UKl
 HaAFSiV9gjoSFE1p+QOoDIvb7NL/Y8KgYScBxG/AkZ11lrtrP8IVQBWZlDM4YV9Cdp89
 ZxA+g6L78zVBiT2yPWpND7ORr4h3xppy/YP7RrWSPvm83OlD3wHNFEm5uc5v44YXaFL0
 Q/0g==
X-Gm-Message-State: AOAM532gJokq5PyofQhmalTUwfvpNV7oHbtgzCyJMUS8AmslRnI7bJ3Y
 J8PRZsgd8j9cK/DJPOe79ZxPnC1kWycu6Ikvpd0=
X-Google-Smtp-Source: ABdhPJwfwchkdTKFsc11KLrjn8H+lwQn8CWI0f5dbYvQx5QSMn7mF8EoUBRhpLgnEozNKNffOPpBzSzHScSBxPC0OU0=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a7b:cb44:0:b0:37c:4e2d:3bb2 with SMTP
 id v4-20020a7bcb44000000b0037c4e2d3bb2mr2810750wmj.96.1645796276423; Fri, 25
 Feb 2022 05:37:56 -0800 (PST)
Date: Fri, 25 Feb 2022 13:37:41 +0000
Message-Id: <20220225133743.41207-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v5 0/3] aarch64: Add stolen time support
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
functionality.

Patch #3 adds a new command line argument to disable the stolen time
functionality(by default is enabled).

Changelog since v4:
 - Propagate a return code from kvm_cpu__setup_pvtime to target->init(vcpu)
 - Change the order of the patches as the vCPU structure initialisation
   needs to be done before the PVTIME setup
 - Return -errno from pvtime__alloc_region(..)
 - Verify if the system supports KVM_CAP_STEAL_TIME

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |  1 +
 arm/aarch64/arm-cpu.c                  |  2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
 arm/aarch64/pvtime.c                   | 98 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 14 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 8 files changed, 116 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
