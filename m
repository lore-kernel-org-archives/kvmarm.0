Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C721C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0DB261261
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D0DB261261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 309C14B0F7;
	Thu, 23 Sep 2021 15:16:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C52muVHukqEL; Thu, 23 Sep 2021 15:16:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1359A4B0E1;
	Thu, 23 Sep 2021 15:16:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E751E4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PU3rHFF2Tbas for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:16 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDF264079A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:16 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 r18-20020ad454b2000000b00380e8260f8eso21862168qvy.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=LbXL/Dv9rCJC+gxT4YME6jBYdFZ2jbPVwuIq+2egvx8=;
 b=iwH8Yy9gm42lUXLdTEoqkurY/9yvkc7WlF6nJHLOpKc9T73O4tHsYnqO1WIt6avtfy
 IZUJeGAImXp9ctfR0Mxk1GJsEPBrtdCBL06fgg7Gt7D3R0HT6cs6sgcB/pNuBn/1u/kS
 lIC0vp+C1iVIW8bnlH7AASFHVtDEXSGUH8aDcupwOLlMBrJz6KvCtRce0QoHFaZb30OT
 RIRRk9urpGMayhlfTRgBhyV6vIIYumGAZifPH3OP6Z0UQE7LCBgvVX3Fccv52W+TT4Xk
 98ATbS17eLwg4a/JA4jXWB1li+4NqtWFoSStpEBMoCkdGeKwXKkKxBYmSSlIyGMeHboF
 6sYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=LbXL/Dv9rCJC+gxT4YME6jBYdFZ2jbPVwuIq+2egvx8=;
 b=HGucQfVIjvQA3YgsEnhFxtMbT8GMqvT+kcO2hy50sXTcKbaAUcUk9E5ckmM0tHRXlU
 W/FO08+dt53xM/PM1BH0MBhf1GZz/ZbU0jElKfCQScLupB2Cob49l2DEnFrGzDzN7IJv
 4kTVJ4UmwP9MXieY3DsIMYDerIssTJDA+k/1S5dDUQcFUmLpYxGFycYjDF2UJEL/N2Wg
 HD5R1AW7ngSOomCmQiBJQpPv5yGI0+QT8aXvb00xBZDzYk0q/+WGALqOI+BWs99jahb1
 qNx9WVyOaUZj4ABifzYl/G3Rt9MIdnmAufSBpFXK8/xF0ilWgc+AgYcV/KJawzjcbHgM
 VPDA==
X-Gm-Message-State: AOAM530odRcT499XcL+XneurnQD00wdhd7JHmtlG8zH3ZJf8cxHY5OwR
 VuNpp5NQXNqUFFI10RGH5siJDo70Rv1LXMonMon+QyHraCoAIrNaLdn790YvbamSgKbJhWu/xso
 27BFP+jU3FfeqMQAz9kMaD/CPwDnxXUXCCmeKTgJ1EsDIbopXvvNOcQYLOxcY45UdUsXzRw==
X-Google-Smtp-Source: ABdhPJzMFhaUdrBGBwJhj49gIQwc0jFu1DRHPojv3gr55rg7HYIG5YEHumJkqbWBVZdPKlWQC145nH+i6pE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:474a:: with SMTP id
 c10mr6025334qvx.54.1632424576315; 
 Thu, 23 Sep 2021 12:16:16 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:15:59 +0000
Message-Id: <20210923191610.3814698-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 00/11] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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
KVM_RUN). If a VMM would like to have KVM emulate the suspend, it can do
so by setting the vCPU's MP state to KVM_MP_STATE_HALTED. Support for
this state has been added in this series.

Patch 1 is an unrelated cleanup, dropping an unused parameter

Patch 2 simplifies how KVM filters SMC64 functions for AArch32 guests.

Patch 3 wraps up the vCPU reset logic used by the PSCI CPU_ON
implementation in KVM for subsequent use, as we must queue up a reset
for the vCPU that requested a system suspend.

Patch 4 is another unrelated cleanup, fixing the naming for the
KVM_REQ_SLEEP handler to avoid confusion and remain consistent with the
handler introduced in this series.

Patch 5 changes how WFI-like events are handled in KVM (WFI instruction,
PSCI CPU_SUSPEND). Instead of directly blocking the vCPU in the
respective handlers, set a request bit and block before resuming the
guest. WFI and PSCI CPU_SUSPEND do not require deferral of
kvm_vcpu_block(), but SYSTEM_SUSPEND does. Rather than adding a deferral
mechanism just for SYSTEM_SUSPEND, it is a bit cleaner to have all
blocking events just request the event.

Patch 6 actually adds PSCI SYSTEM_SUSPEND support to KVM, and adds the
necessary UAPI to pair with the call.

Patch 7 renames the PSCI selftest to something more generic, as we will
test more than just CPU_ON.

Patch 8 creates a common helper for making SMC64 calls in KVM selftests,
rather than having tests open-code their own approach.

Patch 9 makes the PSCI test use KVM_SET_MP_STATE for powering off a vCPU
rather than the vCPU init flag. This change is necessary to separate
generic VM setup from the setup for a particular PSCI test.

Patch 10 reworks psci_test into a bunch of helpers, making it easier to
build additional test cases with the common parts.

Finally, patch 11 adds 2 test cases for the SYSTEM_SUSPEND PSCI call.
Verify that the call succeeds if all other vCPUs have been powered off
and that it fails if more than the calling vCPU is powered on.

This series applies cleanly to v5.15-rc2. Testing was performed on an
Ampere Mt. Jade system.

Oliver Upton (11):
  KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
  KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
  KVM: arm64: Encapsulate reset request logic in a helper function
  KVM: arm64: Rename the KVM_REQ_SLEEP handler
  KVM: arm64: Defer WFI emulation as a requested event
  KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
  selftests: KVM: Rename psci_cpu_on_test to psci_test
  selftests: KVM: Create helper for making SMCCC calls
  selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
  selftests: KVM: Refactor psci_test to make it amenable to new tests
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 Documentation/virt/kvm/api.rst                |   6 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/arm.c                          |  21 +-
 arch/arm64/kvm/handle_exit.c                  |   3 +-
 arch/arm64/kvm/psci.c                         | 138 ++++++++---
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
 .../testing/selftests/kvm/aarch64/psci_test.c | 218 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
 tools/testing/selftests/kvm/steal_time.c      |  13 +-
 13 files changed, 403 insertions(+), 174 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
