Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65C0C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 13 Mar 2022 16:20:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38D8B40BD3;
	Sun, 13 Mar 2022 12:20:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LWtUJpD2vkB9; Sun, 13 Mar 2022 12:20:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F43049E37;
	Sun, 13 Mar 2022 12:20:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0599F40BC2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EUeYetJES6KI for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Mar 2022 12:20:49 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 929584086C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:49 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 z9-20020a7bc7c9000000b00389bd375677so5777385wmk.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=7Wuv74yKEdjvXwkDK4Px5jJ6apmvoxE3JexOVM2IrlA=;
 b=iY3hG+5rhqP1jTbLxBqEjg7UKqAVd3z1+Xn1s989OYEoEP58Mt06JFjWzVY9NaHdvx
 UYKBUJeJBjZMNIv4z1pwHDUuGgRrEn78BScFyF3hRQjsSUQu9wqB/C+y61zUYUGP4A1P
 hh1/8TMy633VEWtNzhec4Y5CtClTWkv1ADQjYxCDIBOQyb96WN4GXMJflCNxJw1R+/s+
 oBDvqgblv75f2euQZLZtk1YJUoS+jL3mj8xX/0iB6VYPi0q3KeJT6TWqwPuPrklBih55
 o7S5ZlQig3NOqekLUo2GEDjpPAONDx/QJrhS+q0pTixqVuFGTKIDHc6ixnMAwaGDFAGy
 p4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=7Wuv74yKEdjvXwkDK4Px5jJ6apmvoxE3JexOVM2IrlA=;
 b=ExKPUUymXIK+nq/YWuaWWD/yAcRfMe57nngkDIbKSpEtbpNgA+Ry/Zjx84j7jGx7B7
 ZrxegCC7m/NCbVULIm6KPrFOd0T4nyZ13XWcUjU2j0WqV4n12I8mo55RTlHEFmKJlXWc
 BarJKsvWCuy1vbn0dbSTFb0XWM+jz2nPNKGcE9KrUylFrd+OqRRBqGwS8haMsAFL2QgI
 qqAo+Pl/MJlLeCslCrSZL20TcLDVCwmZZiteeIP0UOlt4x851zmHE6+dQiZSm4AcV4b1
 NYAz0utGCjs3zt9Xm3Gkqh+MW+Daik1OBVIOMeKAGxB4VtVg+Lb5REI1T1l5be0LBv5h
 0/KQ==
X-Gm-Message-State: AOAM531K1TNh8NMNJ2MXtIXTso25gOQ6LFxThpB4AEn96vVzb/B2vbHc
 CbZ1oBH4ip3kRouo4w5rOopJQWEVlwXBgOFW/WA=
X-Google-Smtp-Source: ABdhPJzhl0gG4Adi0f1C2JUggqNP47tmOd8Uoc7ehQMllk4ZVnR5xcuRb7esdtvPuDku6DzyyiErK0ckKl/qUiNOx2w=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:3589:b0:389:cf43:da61 with
 SMTP id p9-20020a05600c358900b00389cf43da61mr17863422wmq.203.1647188448234;
 Sun, 13 Mar 2022 09:20:48 -0700 (PDT)
Date: Sun, 13 Mar 2022 16:19:47 +0000
Message-Id: <20220313161949.3565171-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
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

This series adds support for stolen time functionality.

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

Changelog since v10:
 - set the return value to -errno on failed exit path from
   'kvm_cpu__setup_pvtime' 

Changelog since v9:
 - use the `attr` field for the 'struct kvm_device_attr' initialisation
   with KVM_ARM_VCPU_PVTIME_IPA instead of the `addr` field

Changelog since v8:
 - fix an error caused by kvm_cpu__teardown_pvtime() not beeing defined
   for aarch32
 - cleanup the pvtime setup by removing the flag 'is_failed_cfg' and
   drop the 'pvtime_data_priv' definition
 - add missing Review-by tag 

The patch has been tested on qemu-system-aarch64.

Sebastian Ene (3):
  aarch64: Populate the vCPU struct before target->init()
  aarch64: Add stolen time support
  Add --no-pvtime command line argument

 Makefile                               |  1 +
 arm/aarch32/include/kvm/kvm-cpu-arch.h |  5 ++
 arm/aarch64/arm-cpu.c                  |  2 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h |  2 +
 arm/aarch64/pvtime.c                   | 98 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 15 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 9 files changed, 123 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
