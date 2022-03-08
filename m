Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B23C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Mar 2022 15:33:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F5D49EC5;
	Tue,  8 Mar 2022 10:33:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9sRprM9093Nn; Tue,  8 Mar 2022 10:33:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B370449EB1;
	Tue,  8 Mar 2022 10:33:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AEBC49EB1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 10:33:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o+VZceiYVkPS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 10:33:05 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BECB49E08
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 10:33:05 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 l13-20020a7bcf0d000000b0038982c6bf8fso1248883wmg.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2022 07:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=pFCZMIKsmv1NgfuYif6jC89cFJGtwVMy/ZQFUs6rUg4=;
 b=Og4X5EgvD6ZGnF9GYC/nSoXWWIbI4ubeynG4LVZBHsNwEt4N7WDD3JAnr/aGH1N+Or
 20btxSIx1YnatFPfC1Nb43bQhN9YFnTy/nFjuM+SebBb+LFTPUFDfJdP5U8WIqju5nF/
 eCHZ7ylSKeqIxFi+A94QL848mgzxpx+aoIa3tkNNJQxmKmDy+znXZOfcJel212hss7F/
 Fi3B2zqr3X48oXAcFKaFp0QqhZxPuEVe0+6/LEV6BQoE4DDIhsKkIlFiTMP1WP7eVC3O
 6oBI+ym/FWJ8MVxOhuj0USkRJw4fId7JXtvGetAdqEIkeLvpiZtFiHhV/+ObaTg1fyKA
 9NIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=pFCZMIKsmv1NgfuYif6jC89cFJGtwVMy/ZQFUs6rUg4=;
 b=XXKtf2ryVEfL6w6IaeFdCBX8tM+yfFEGbyTcg8JYV4yZ7ed7kXx+cpvgi+5Et1kvfv
 UydjbcDVrlgicWTjV3bg+YbU4J1GCHM5S1FMmVX9CppVPhwxDrA2aDW2se7PD5UGanu0
 M2eVZXuFCi5ImTDK8O3z3NxzCdyjjxChGD7aaQjg/F1/6TNJ6kWVfoBiLX5GugZcwEfq
 6DhAsJJ1mobtP6ygmMSj865lLqkHhfIN59Ipom9amimzqR9o65uMj2uK3ydt0jD5Jrnk
 a5nuwRaedyXBFdpsU4rBFIYy3D5Kh7ZkgQFvuRTWIrfHBxXCczcBB9Jo6BI7sWba3QPL
 CDtA==
X-Gm-Message-State: AOAM532DH2kB8uFPUwx5N5Itx4m+7uRhYQrDzOZVUsAvAy6IRGR8Slff
 CsHjwG0utGBqjf3pV2DCC6+yme+/KCFz0gJqpmU=
X-Google-Smtp-Source: ABdhPJx+g3OUSF7ALEGrRok8o/uMoGiAUjj9sAb9rq2nfBww3UXx3vC6KKRHWk18QkFJyTvY1IYcyHhcvw2iFZPUTJU=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:35cf:b0:389:b5f1:ce68 with
 SMTP id r15-20020a05600c35cf00b00389b5f1ce68mr4042505wmq.149.1646753584000;
 Tue, 08 Mar 2022 07:33:04 -0800 (PST)
Date: Tue,  8 Mar 2022 15:32:25 +0000
Message-Id: <20220308153227.2238533-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 0/3] aarch64: Add stolen time support
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
 arm/aarch64/pvtime.c                   | 96 ++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h      |  6 +-
 arm/kvm-cpu.c                          | 15 ++--
 builtin-run.c                          |  2 +
 include/kvm/kvm-config.h               |  1 +
 9 files changed, 121 insertions(+), 9 deletions(-)
 create mode 100644 arm/aarch64/pvtime.c

-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
