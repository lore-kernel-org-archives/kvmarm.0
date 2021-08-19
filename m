Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB7AC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:36:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ECE3610CF
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6ECE3610CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6FF04B0D7;
	Thu, 19 Aug 2021 18:36:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R4Ug1wYqFGYR; Thu, 19 Aug 2021 18:36:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B00064B0E9;
	Thu, 19 Aug 2021 18:36:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2727F4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XScPRf2ZSTXS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:36:44 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23ED84B087
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:44 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso7957042ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=hVLqpfJyik/aNFUVhgkn5ayQKvTB31kCk1HpemlZ0PQ=;
 b=GVin9ZIo8I4PynVJRsVMmAXOcqMyYaVqEzH+8z/eUNoXN8UG91sa6EC9fkjEn9xBre
 wLjfmlUSr8AV0SDnhLLG9ol7IzYBlmwUnaSNmrKYc1QMYSRym9e7tdOebKRJwJEbR7v2
 lGKnctauKMxPl/EOy2QEc5Z9H0574kKfbqEm34EZxFaTiZDXTN88HVvge8Fi0L+dNi+i
 Sjb+nyFuGATdY799YV0IcFKzfhmf9H7Z20kFjrJazV36ANC5jOYSF49koRxq71br307U
 y5u60XEsDL6BiTI0Ye/mugeKEYHrpvKyIkn2FfiAj9JWl5pjekralsIP9C+3TytPlQbV
 GeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=hVLqpfJyik/aNFUVhgkn5ayQKvTB31kCk1HpemlZ0PQ=;
 b=K5mAeSNuLlpErdOYPV6amKPa8Vi/MtCia4kptnr5OKKFz3i8hoGWV9hpKvIYqYBLaF
 YD0WyBgttJU7VQh/f/KyUoYegmlfyz3ReWvQJwb+t90+O/1vVsKYazXc+GijnXgFjd0v
 Uf7H61lSWl7JbvPu9ep6hcEvLUXE7tj2XXpnk0Rdxc8o4WhoUSmwXiY3bbnrmIt547MJ
 +8NiA8XqjUL1cWs8Yxrzn3+DPRVm3gjjiHH1BdrNcq/13iQuxmLVox0kC0oAcML4Obd2
 1l0jYtBPwhv0wcrrRnSxLjj3830jKYD94VfWJyJE+1KwfMzTjcMUGZjX2DvL9cUGThGf
 5ZfA==
X-Gm-Message-State: AOAM530nZBXtUyueuALqqsFdgxptKEYkbhfxz7y4gCj8czChTTy0OOhP
 sQJDXNaRIN1zFWcak94NjrQdZfhvuus=
X-Google-Smtp-Source: ABdhPJwSrjQerrU1uikVnLI3vJ2z24wtkGEFdI8gQO/BHJSju1355boZQO0W8F52k/AIOIKPAb3ocFx1CF8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:dfd5:: with SMTP id
 w204mr18198187ybg.78.1629412603603; 
 Thu, 19 Aug 2021 15:36:43 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:36:34 +0000
Message-Id: <20210819223640.3564975-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
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

Certain VMMs/operators may wish to give their guests the ability to
initiate a system suspend that could result in the VM being saved to
persistent storage to be resumed at a later time. The PSCI v1.0
specification describes an SMC, SYSTEM_SUSPEND, that allows a kernel to
request a system suspend. This call is optional for v1.0, and KVM
elected to not support the call in its v1.0 implementation.

This series adds support for the SYSTEM_SUSPEND PSCI call to KVM/arm64.
Since this is a system-scoped event, KVM cannot quiesce the VM on its
own. We add a new system exit type in this series to clue in userspace
that a suspend was requested. Per the KVM_EXIT_SYSTEM_EVENT ABI, a VMM
that doesn't care about this event can simply resume the guest without
issue (we set up the calling vCPU to come out of reset correctly on next
KVM_RUN).

Patch 1 is unrelated, and is a fix for "KVM: arm64: Enforce reserved
bits for PSCI target affinities" on the kvmarm/next branch. Nothing
particularly hairy, just an unused param.

Patch 2 simplifies the function to check if KVM allows a particular PSCI
function. We can generally disallow any PSCI function that sets the
SMC64 bit in the PSCI function ID.

Patch 3 wraps up the PSCI reset logic used for CPU_ON, which will be
needed later to queue up a reset on the vCPU that requested the system
suspend.

Patch 4 brings in the new UAPI and PSCI call, guarded behind a VM
capability for backwards compatibility.

Patch 5 is indirectly related to this series, and avoids compiler
reordering on PSCI calls in the selftest introduced by "selftests: KVM:
Introduce psci_cpu_on_test".

Finally, patch 6 extends the PSCI selftest to verify the
SYSTEM_SUSPEND PSCI call behaves as intended.

These patches apply cleanly to kvmarm/next at the following commit:

f2267b87ecd5 ("Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next")

The series is intentionally based on kvmarm/next for the sake of fixing
patches only present there in [1/6] and [5/6]. Tested on QEMU (ick)
since my Mt. Jade box is out to lunch at the moment and for some unknown
reason the toolchain on my work computer doesn't play nice with the FVP.

Oliver Upton (6):
  KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
  KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
  KVM: arm64: Encapsulate reset request logic in a helper function
  KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
  selftests: KVM: Promote PSCI hypercalls to asm volatile
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/psci.c                         | 134 +++++++++++++-----
 include/uapi/linux/kvm.h                      |   2 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 126 +++++++++++-----
 5 files changed, 202 insertions(+), 68 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
