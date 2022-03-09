Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E95C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 13:34:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511B749E17;
	Wed,  9 Mar 2022 08:34:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6UxiVUC14LQO; Wed,  9 Mar 2022 08:34:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F241649E48;
	Wed,  9 Mar 2022 08:34:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33EB349E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 08:34:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VuT5JMJW8VpH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 08:34:48 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 095D749E17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 08:34:47 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 v67-20020a1cac46000000b00383e71bb26fso810864wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 05:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=dokf1L1DcB0O0VLOB3TkhFW+LY85aXQ0eck+ZVRatB8=;
 b=YpBphMrptWtHb7Tzy/ZX5BIQjBBk41hsObZ38Mb+lx+0WzAaPxube1C8l5QTA0q8QY
 NEMy9cnU/6JNxG+Jg0zDGwbWRKScx0AA4SMChZ6k/qIkYU0r1dL5A5f8kLsRdH7mSRMF
 R4ISB4AUBGDOju1MFcSFG7ldWl3UgvA8NKM0phSYOWt3eOQSVy3NvJMzV7blLzRMgmox
 NzfoMvDwmptvzsWKKGimKoeHoQvNiCZhRlKCEaXoZneKCaN2RjhUPQcZoFdYFJC2r+qd
 pXQM1FyIOSba948R8merQO84LF/zITx7q95YGNzfXpqIYjavHyjPrbCw/pXwJzd3R+xD
 KF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=dokf1L1DcB0O0VLOB3TkhFW+LY85aXQ0eck+ZVRatB8=;
 b=AVa/yI9LdU7+h4UOOxSMEwqAMqcIsyIB4AvOuj2MNNE5cu151Pz2BVe/pOz1phsLJ2
 m0pQp5zFVcdZka5hcgBjok410LpXjdsymmp5F0ACWLwZsiGrh3ZPqBUhQKu6Uxw9n9Ek
 A6UFyJ8uUro6iB+tb+sGgphVgWY2oJXv/iv+FjR/dm8mEXXw6ftc2yWwmv9+NCOhfLLn
 a5FaJh61uRFk5xvGdXthq+k/YmE+f+jY8x1VFay8Qz58fWNWu9rDP546uuvBROrcGEs7
 sUZ8hj4E+G1PTfjPrQXShwC0Du28bS0zOr/uIRkthHBp/54lExNe565kTEVNs8A97Lcf
 +NHw==
X-Gm-Message-State: AOAM53116zCFSQcpni50f0k7u92vbl9ktpRWR6H/jG4Zl4a2/79Fh/z5
 VxweUL4Ly6MSKegQMZ2ANmEZnSzl6NmTOpiUcdE=
X-Google-Smtp-Source: ABdhPJzkoT06S2zRXct/lGgKvjH2V/DC4CxhP4eldTjDyxbrfGwfBjeqyyUvG3t6ZRZCmNMjS24IDOd99cUM43UTK/s=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:3203:b0:381:b544:7970 with
 SMTP id r3-20020a05600c320300b00381b5447970mr3375662wmp.144.1646832886940;
 Wed, 09 Mar 2022 05:34:46 -0800 (PST)
Date: Wed,  9 Mar 2022 13:34:20 +0000
Message-Id: <20220309133422.2432649-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v10 0/3] aarch64: Add stolen time support
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
