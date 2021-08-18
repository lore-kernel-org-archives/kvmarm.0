Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06341C432BE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 08:51:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 744A161075
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 08:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 744A161075
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E26B1402C0;
	Wed, 18 Aug 2021 04:51:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J4VYmSUZHHgH; Wed, 18 Aug 2021 04:50:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F31214B0BD;
	Wed, 18 Aug 2021 04:50:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D7A405A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 04:50:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKUwHqmoaJNU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 04:50:56 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCB83402C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 04:50:56 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 y8-20020a92c748000000b00224811cb945so842889ilp.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 01:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=SFFBjk6fBfzTLeFLGMERukTfXI4cB+XvM9PLOmI8ffA=;
 b=q72p8Z4Um676qw+5B767IOnYYDKK3/aifELNlK2Nx7ieNC7tChONoMx6HgmB8Vl+L3
 sptokUlysxY8fuChZK2Y9wCz6tKf72GCX8UPtaUdaArzZ7pxjlP8Uomp8IoCXmVBym6K
 1sDbX+Sjq8UQMFzJAJy8XIiGI57lSQsHhQ5MIJR4EJX0xfiDQLdhjv9fheqlrosBktSZ
 bA4U/0nAosKE+vM2qZcXZE9J4nIrd2nIKdlvSERoGS9zoKWWH2cu0RK8g82kg9Trvb4y
 EKP8L7FVI1sMEhelj9xASjAE6RkMfYHdib8/FeA10BND3Jdo5TvM14x58WGa8aDawf01
 FCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=SFFBjk6fBfzTLeFLGMERukTfXI4cB+XvM9PLOmI8ffA=;
 b=R2GYbMDuRmBR5JdSXtxJtYQ55zuu7siLuSEACxzSzwmVqHXnPh/Ch0AoetdUypBejS
 laPbB6eSff33wQXXVIYRpdeTBcl4h0mYqSE+yfhYvUzhCcy+sRmsKUV7tULiHGDfTPW7
 HOcNuWe5OnzvOZwpTW/+JAfXXhckKFtUD/Lpf+PhCBTN475KuB/VZsu4+34y5yHNDpe8
 77HWUAtDc0/hLWyYSElx+KInK0L//3USenCP2bnsIO2WQZdWRKOKJAHc7tRZfowrK9LK
 PlvpewtrRCbaYETG2bU1FiiGC2HDDHh6uhNo89ZlFygBDJnAiSn0hgi61sJgfJ8CV2sw
 ccmQ==
X-Gm-Message-State: AOAM530D8imV+DFCH3FL9veHa7Cx7wSInQbOwYsmPxLjIh+eHEdOXZnt
 EyeKQxUDOeyXEdJWn4kiJSONnRbeR7M=
X-Google-Smtp-Source: ABdhPJwp3MbNRnUFgUnmbFferx21vJX38gpSFXR8tLXbf1G2rfJlZ4+PcXRuGotHHSYcgebHCnnN3cdBS4M=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:dd88:: with SMTP id
 g8mr5675929iln.158.1629276656060; 
 Wed, 18 Aug 2021 01:50:56 -0700 (PDT)
Date: Wed, 18 Aug 2021 08:50:43 +0000
Message-Id: <20210818085047.1005285-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 0/4] KVM: arm64: Fix some races in CPU_ON PSCI call
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

The CPU_ON PSCI call requires careful coordination between vCPUs in KVM,
as it allows callers to send a payload (pc, context id) to another vCPU
to start execution. There are a couple of races in the handling of
CPU_ON:

 - KVM uses the kvm->lock to serialize the write-side of a vCPU's reset
   state. However, kvm_vcpu_reset() doesn't take the lock on the
   read-size, meaning the vCPU could be reset with interleaved state
   from two separate CPU_ON calls.

 - If a targeted vCPU never enters the guest again (say, the VMM was
   getting ready to migrate), then the reset payload is never actually
   folded in to the vCPU's registers. Despite this, the calling vCPU has
   already made the target runnable. Migrating the target vCPU at this
   time will result in execution from its old PC, not execution coming
   out of the reset state at the requested address.

Patch 1 addresses the read-side race in KVM's CPU_ON implementation.

Patch 2 fixes the KVM/VMM race by resetting a vCPU (if requested)
whenever the VMM tries to read out its registers. Gross, but it avoids
exposing the vcpu_reset_state structure through some other UAPI. That is
undesirable, as we really are only trying to paper over the
implementation details of PSCI in KVM.

Patch 3 is unrelated, and is based on my own reading of the PSCI
specification. In short, if you invoke PSCI_ON from AArch64, then you
must set the Aff3 bits. This is impossible if you use the 32 bit
function, since the arguments are only 32 bits. Just return
INVALID_PARAMS to the guest in this case.

This series cleanly applies to kvm-arm/next at the following commit:

ae280335cdb5 ("Merge branch kvm-arm64/mmu/el2-tracking into kvmarm-master/next")

The series was tested with the included KVM selftest on an Ampere Mt.
Jade system. Broken behavior was verified using the same test on
kvm-arm/next, sans this series.

Oliver Upton (4):
  KVM: arm64: Fix read-side race on updates to vcpu reset state
  KVM: arm64: Handle PSCI resets before userspace touches vCPU state
  KVM: arm64: Enforce reserved bits for PSCI target affinities
  selftests: KVM: Introduce psci_cpu_on_test

 arch/arm64/kvm/arm.c                          |   9 ++
 arch/arm64/kvm/psci.c                         |  20 ++-
 arch/arm64/kvm/reset.c                        |  16 ++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   3 +
 7 files changed, 162 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
