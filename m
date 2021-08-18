Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3557CC432BE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:21:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC281610F7
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC281610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C864B099;
	Wed, 18 Aug 2021 16:21:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hpoes4zgHpgu; Wed, 18 Aug 2021 16:21:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 483DF4B0C3;
	Wed, 18 Aug 2021 16:21:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EAEE4B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 16:21:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V--aDgfHnmif for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 16:21:36 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C6154031F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 16:21:36 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 r5-20020ac85e85000000b0029bd6ee5179so1084685qtx.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 13:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=WXJPnFEjLyNrsHUbWIgf/gvEc1e+fUVAP4iQlBo9KEc=;
 b=KlGbNAIjTWTtbpNpUH6cgKKGcDuIwO8nZx020krswpm9E2TOS02eix5vl7prvpwbSX
 NHoj8cmogcR7oSwJ4dfOcY62zAOxrJ6RDMR55YL7EGiI/rDsqs5i17BdA7APVI0snlS0
 vWJ85Y/vMLoTCUvGvySJYXR8zWNh1sppdCzyFrRMlytwU8h/h1wvZQoHv9f/PmkSH2Zy
 X1HvP+PkN6gsXOKKYQyO2uCTaWSVBiv6/BRxrUgQ/Jhllo3ac2cxJ4CEXaXtCC025TzU
 nkkAfCHr2ohXVb6hzMUZJDC937+n3JrqXDO6Rk+Fo+qEl77Iud0nA83vF865XvThopTI
 pqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=WXJPnFEjLyNrsHUbWIgf/gvEc1e+fUVAP4iQlBo9KEc=;
 b=Ri8MPmQt19BxsCk6WvEqc5etOPJuGtzh4CVIAK/qVvVg5h7AnlGjpy0m5HVGLMG+Eu
 LO45NSEtKAEVyhd9MRlxSQ+RAmIsXshm4lxazl/+/5AyLktoG64J8x1G4T1EVN6gG68a
 9dQRszw1lQovEq2lStEs3i7ceTuACCqeWhb98Ow68HTH+S5jzxFgCuoC8pthr4CjIrzd
 Jfe8I03KPcccS3qYf1LWbeJi6pPL+/4AbIjqp40fXjpOuM/GI4EqTWe5OLjfZ63qGdRq
 xHk18byXBdma+eiaEMmTQDAWLWIPYmXCWgGjJ05vmBVAi1es1DOJPJkOFvK6mhEpQ6JC
 eZIw==
X-Gm-Message-State: AOAM5311jJurx3xL86Nr1tSSBY8D1+tP3rMem6vxniWo0NmIi+rzhcvK
 3e27d6o6BjiZI+2LPlcFhzGqcdWNvVI=
X-Google-Smtp-Source: ABdhPJyXRTZH1sgyNZ0IEvDRpdJZwxkl7akSNB9SJ9fTfbpZBNgTEuZYrRMjNXtfv6RQ63mYOx/KK896CKI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:500b:: with SMTP id
 jo11mr10823569qvb.52.1629318095735; Wed, 18 Aug 2021 13:21:35 -0700 (PDT)
Date: Wed, 18 Aug 2021 20:21:29 +0000
Message-Id: <20210818202133.1106786-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 0/4] KVM: arm64: Fix some races in CPU_ON PSCI call
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

This series cleanly applies to v5.14-rc6

The series was tested with the included KVM selftest on an Ampere Mt.
Jade system. Broken behavior was verified using the same test on
v5.14-rc6, sans this series.

v1: http://lore.kernel.org/r/20210818085047.1005285-1-oupton@google.com

v1 -> v2:
 - avoid memcpy for reading reset state (Marc)
 - promote reset_state.reset = false to WRITE_ONCE() (Marc)
 - rephrase comment, commit msg (Marc)
 - cite the PSCI spec precisely (Marc)
 - drop unnecessary mask-down to 32 bits in CPU_ON (Marc)
 - rebased on top of v5.14-rc6

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
