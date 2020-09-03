Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4580C433E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 527AE208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Am4pM3dw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 527AE208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A184B223;
	Thu,  3 Sep 2020 09:53:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HsWPDJzFYHin; Thu,  3 Sep 2020 09:53:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CDC34B238;
	Thu,  3 Sep 2020 09:53:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E39FF4B0FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id srE+HEfhle35 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:11 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE36A4B0C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:11 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id m11so1876728qvv.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=oARo4br58HswRBa/XJtx2f6i8RkRRLNeOBdf/wy5IPE=;
 b=Am4pM3dwLxj0G271v/o7CMB2X/Kt0OI71p6MGo1VcGYDoN0edf/GoOBGZt2wSVyMVC
 2kkskUq7OlW9LQtviHOHIBO+jcnUeqss2FbF+Scszuc1CzOVYcvV7h85fM7GkcY51pU5
 ntuBPWFhFuUswHgMvAXL6ppYrhHhMo842SB9RN1ddvwfn2mdo9BzmyhuHbE0t398ao3M
 4d/DHB/M3q4WHKAyBCXz1xuwsbm67u0vAsjh3hpaR1ht9tyKRdQrue72Q9dR4g1PrCEg
 lwE/JPJw+Uhgzh90LXl+3cj+kbfLsD5yICm6jan7C52ph1qFWZ9EuJ1awxIeeYF/j9Kp
 Zhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=oARo4br58HswRBa/XJtx2f6i8RkRRLNeOBdf/wy5IPE=;
 b=pD5m4prfSl0Yi6/3HME9Mdidgmk/5RrEl3R7gwnOqbFOr6NW0WVb8woMDYqb+xS4g8
 t9kxKu6qNrFVFgkTetpGcxDftx0XV0wk5mn6xZENjIDkqnbmKvdAKycmtkPCNqxE6SoR
 jBNOo7gY13/GcLV7ZBwzZ1hMpWkpQhmGgDMTUdSF8XDb0h5pgNyFXWI75aMfqoxroEf/
 wfC2CUfdpiMx1MoEcpW4HwNU0ycQByngp+9Qax7id4u6abBisX/L5LwdvrhScmuTkQ5a
 nIGk4uKrEL5uHUs9WiFq3/z5khYKGHQRIqdvDRI8yJSsUAVscmfVircfpG2d9a31cKOJ
 8PZQ==
X-Gm-Message-State: AOAM5307L388qCIvxWY2nJ5HdY1eoSKvsKjI5tKvYrahKPstabrjf+IM
 vyiM44f0SyKYh6lT9L9+rlvpIFl+xQfb5+B+pVSjg+NuFnqg7L++V4dH4IXGRwmPIF3R8XJ2RcK
 iubiRrmLGzi0Z7s1cFeFQNDqc5UWj+YzPdFRezZ558RU2jqPzf/Q5uDK/NlkTe+rEhww16A==
X-Google-Smtp-Source: ABdhPJzRKjkOQJpZOgNieiBEmg3ydMZMhOsCCF5jheIUU7hLmGsXYeDZZxPV7z8Y+tAX/0e42AQK4E6EdKQ=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:f887:: with SMTP id
 u7mr1033416qvn.124.1599141191218; 
 Thu, 03 Sep 2020 06:53:11 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:49 +0100
Message-Id: <20200903135307.251331-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 00/18]  Introduce separate nVHE hyp context
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

As a step on the way to isolating hyp from the host on nVHE as part of
Android's "Protected KVM" project, this series introduces a separate
register context. Topic include:

 - RAS for nVHE
 - Panicking from guest vectors with SCS
 - Switching to hyp context
 - Migration hyp interface off of function pointers

First 4 patches are small refactors. Then an exception vector is added
just for the nVHE host to untangle the existing EL2 vector e.g. to
separate the RAS cases.

Hyp panics from the guest context, e.g. from an invalid vector, are
fixed so they have a chance of completely cleanly with features that
depend on register state such as x18 for shadow call stack (SCS) enabled
on VHE.

Finally, hyp is made to switch to its own context rather than borrowing the
host context before migrating the hyp interface from raw function
pointers to SMCCC based functions IDs.

From v2:
 - https://lore.kernel.org/kvmarm/20200820103446.959000-1-ascull@google.com/
 - Rebased onto 5.9-rc3.
 - Removed some of the unused separation of host and hyp.

From v1:
 - https://lore.kernel.org/kvmarm/20200715184438.1390996-1-ascull@google.com/
 - HVC microbenchmark overhead cut from over 15% to under 6%.
 - Abandon the symmetry of a run loop in hyp and treating the host as a
   vCPU as there was little practical benefit for the overhead it
   introduced.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

Andrew Scull (18):
  KVM: arm64: Remove __activate_vm wrapper
  KVM: arm64: Remove hyp_panic arguments
  KVM: arm64: Remove kvm_host_data_t typedef
  KVM: arm64: Restrict symbol aliasing to outside nVHE
  KVM: arm64: Save chosen hyp vector to a percpu variable
  KVM: arm64: nVHE: Use separate vector for the host
  KVM: arm64: nVHE: Don't consume host SErrors with ESB
  KVM: arm64: Introduce hyp context
  KVM: arm64: Update context references from host to hyp
  KVM: arm64: Restore hyp when panicking in guest context
  KVM: arm64: Share context save and restore macros
  KVM: arm64: nVHE: Switch to hyp context for EL2
  KVM: arm64: nVHE: Handle hyp panics
  smccc: Cast arguments to unsigned long
  KVM: arm64: nVHE: Pass pointers consistently to hyp-init
  KVM: arm64: nVHE: Migrate hyp interface to SMCCC
  KVM: arm64: nVHE: Migrate hyp-init to SMCCC
  KVM: arm64: nVHE: Fix pointers during SMCCC convertion

 arch/arm64/include/asm/kvm_asm.h        |  78 ++++++++++
 arch/arm64/include/asm/kvm_host.h       |  26 ++--
 arch/arm64/include/asm/kvm_hyp.h        |   9 +-
 arch/arm64/include/asm/kvm_ptrauth.h    |   6 +-
 arch/arm64/kernel/image-vars.h          |   2 +
 arch/arm64/kvm/Makefile                 |   2 +-
 arch/arm64/kvm/arm.c                    |  34 ++++-
 arch/arm64/kvm/hyp.S                    |  34 -----
 arch/arm64/kvm/hyp/entry.S              |  95 ++++++-------
 arch/arm64/kvm/hyp/hyp-entry.S          |  76 +---------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  15 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S          | 180 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  67 +++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 122 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  37 +++--
 arch/arm64/kvm/hyp/nvhe/tlb.c           |   2 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  18 +--
 arch/arm64/kvm/vgic/vgic-v3.c           |   4 +-
 include/linux/arm-smccc.h               |  20 +--
 20 files changed, 558 insertions(+), 271 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/host.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c

-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
