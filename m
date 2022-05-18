Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051F0C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 18 May 2022 17:59:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BD464B325;
	Wed, 18 May 2022 13:59:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wd8evTvSvILK; Wed, 18 May 2022 13:59:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5484B31F;
	Wed, 18 May 2022 13:59:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F0D54B309
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T7wxOtqpQ61t for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 13:59:09 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BD024B2B7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:09 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2ff40ee8109so23181587b3.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 10:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=6El377MID7rCecykOPvAUGyvktASztEGQkNHsDo4H6Q=;
 b=JTvJ+pKPh0OV0kWy/CMIAehzpxr1kPLAluvEkkiTGTqb1w3iky98vPxfy4JpyAv15m
 hpxjGgsQiB3GvVjAm2TgBwam4CVhDSrwQ83XeJZEsIaezBOop/ufsUEHi3MUstSEowXA
 nlIp6Q9DzIKMYFWsUvAHwXZAVSfh4ZSyiSCf0SO774QCnOv3HzA+hprAWYzNDIRkl2VI
 LDJIZS2zYibH6SEjLL+5kqd2ZlG+yUswJ9ouj3uz5Vhn8rDaGN1bUgUyr84KmL3tVD1s
 Wu4qOkO54Wa27tIlq61/c86VJrQ83vfObBXPz/M2gfi+URn+b/Uaj/Mss7uq9WlLTpS4
 tJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=6El377MID7rCecykOPvAUGyvktASztEGQkNHsDo4H6Q=;
 b=hH2S1hULcZ6kQmSseQodQSS5o3f0fyuUTBy6nihma6bmS4rLtTxgqncB3hnHgH2oXN
 uW+JAL0BOaLGfuY5vSn5Mq+rNIaoWkYMmhVyBOMVqyJqoMAS4qBZuf2bamXmRjKk4buT
 wfPWFER2l+AGWgCOYfjjxEdcBzJ7bUDbRgrgPLV5q6ARsGcZllLTWg5KqWEGytV7KkWc
 Ryq2IaKEiHVdYB/DB+6Fhw/4nvueFL6mGB8IHRPWYCLoVuHQqnIPEBOOnRhguXVf/+0S
 /yUF91DkB584TJa8DCJJQ+HQ+IOhqIBtGn6PF8a6swrnH+UK+mB+D9q8xvLAykdHwsEG
 ptbg==
X-Gm-Message-State: AOAM5326Tvq6UZDswD15Evv1zOO6Ki1dFEoUYZp/xeRnkzX9fCmwjBnW
 1M0WzFaBhBZ8uLN9u6nQEvxmVzK/3Ws=
X-Google-Smtp-Source: ABdhPJzd/VIgYtDzCdo352e3DSjBzZ/3yJ+2/AXyM2iOJppq/zMlcRJgTF3VMNpFU0YSI03GqRoyktT5vNs=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:8387:0:b0:64d:ddc8:b481 with SMTP id
 t7-20020a258387000000b0064dddc8b481mr847547ybk.644.1652896748601; Wed, 18 May
 2022 10:59:08 -0700 (PDT)
Date: Wed, 18 May 2022 17:58:06 +0000
Message-Id: <20220518175811.2758661-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 0/5] KVM: Clean up debugfs+stats init/destroy
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

The way that KVM handles debugfs init/destroy is somewhat sloppy. Even
though debugfs is stood up after kvm_create_vm(), it is torn down from
kvm_destroy_vm(). There exists a window where we need to tear down a VM
before debugfs is created, requiring delicate handling.

This series cleans up the debugfs lifecycle by fully tying it to the
VM's init/destroy pattern.

First two patches hoist some unrelated stats initialization to a more
appropriate place for kvm and kvm_vcpu.

Second two patches are the meat of the series, changing around the
initialization order to get an FD early and wiring in debugfs
initialization to kvm_create_vm().

Lastly, patch 5 is essentially a revert of Sean's fix [1] for a NULL deref
in debugfs, though I stopped short of an outright revert since that one
went to stable and is still entirely correct.

Applies cleanly to v5.18-rc5, since [1] is currently missing from
kvm/queue or kvm/next. Tested with KVM selftests and the reproducer
mentioned in [1] on an Intel Skylake machine.

[1] 5c697c367a66 ("KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref")

v1: http://lore.kernel.org/r/20220415201542.1496582-1-oupton@google.com

v1 -> v2:
 - Don't conflate debugfs+stats. Initialize stats_id outside of the
   context of debugfs (Sean)
 - Pass around the FD as a string to avoid subsequent KVM changes
   inappropriately using the FD (Sean)

Oliver Upton (5):
  KVM: Shove vm stats_id init into kvm_create_vm()
  KVM: Shove vcpu stats_id init into kvm_vcpu_init()
  KVM: Get an fd before creating the VM
  KVM: Actually create debugfs in kvm_create_vm()
  KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)

 virt/kvm/kvm_main.c | 96 +++++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 47 deletions(-)

-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
