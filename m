Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54014C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C5E4B1C7;
	Tue,  3 May 2022 23:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EO9kYfmfTw+o; Tue,  3 May 2022 23:24:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6644B0DE;
	Tue,  3 May 2022 23:24:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 430364A100
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qtPMKrt-+swh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:24:56 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D43D349EE1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:55 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 h7-20020a628307000000b0050df7cb563cso15116pfe.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=KgPp4H0NuOXhN/wKLMYd5omlFxsjaCCDTXWIWXRSBbg=;
 b=DmyQSOYJGcco5+Z4OTfOviHTkWkf+fn4I7+QmVo96W+55a7ZQD7pIzftEAC3pnN8ZA
 l9JcBz03PNT7zTv1nUYlVUfKoC4VpY85yltqlsI6Xvd0Lmqep6+thdtV2s31+MT0FwpO
 QGEQ4A0BkecMPTbEqMvp6Bg+K7qJLJjV/zOSNJf03h0nwFjjTIyWhhDSnW3slTH3bsJH
 Y4c3nZYGMB+yKeWutRtXiYPLrYyUfec5ztQc2jKgLOypWbICymKSrVim4l4DL1zPUIiP
 CHdmOTTLgA3y6KADxJGz9tVkJJ5ra4vTG89lT4lG9Vo9O6O5GYBs/0RUyCzDTxEKH6w1
 PRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=KgPp4H0NuOXhN/wKLMYd5omlFxsjaCCDTXWIWXRSBbg=;
 b=ihm9kEHNvkPvIdvmgP4ANfQpLXyRYLnSJMY6DzNlpHXgaGzKP6s98JySuwox5WQOO6
 4PWxPCWtUf+qq8OQmXs5tNNDzhjpJGQTqd/jg9mQEHobwmq4XEKhZ+6jcpRQVCXj89F5
 IHnzaoK68Fn1BCKOCzKJcGQOgr7eElzs3INZlZ4WsIYwhNr/+ZYXf3XN5Z1i8drghGkH
 dvP2kWw2fY93uEtsW87gxJSiE+6HNu4G+G+XdBpxGuqvFqt6WKgLjRb4LUCuncHUm361
 IytxXjeIza9Lgr2w5fA26BGRDThTxAqL5NboWBU9nc1UMBLNUu4IVjZEw/E26a2YyisF
 5HKw==
X-Gm-Message-State: AOAM530V8uzy9h9DfN8dwpzukkcSgTQOU/EA9+SJm4piZ3vyyt4E3z+v
 hQyzLMg3mGJCD/w2i20AaE8Z5iQq/DJP7ncEZW8Ob4zYG700WYZLQm4UMG+sBOQapyul65voDpW
 UukX7mM+WkaD8034Tg2Kv9yR0vTyVLuan/lWcvfdnjb7Tja7bw3fFcw3RV7o+OyLG+lldiQ==
X-Google-Smtp-Source: ABdhPJy0md364rnqqnpBagaJWaE/z1Wg/rNj8Qldyb9Z+17hxkDrPJCpHr8Z5hTe7QOHoLuWhwefh8NqYp8=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr221104pjt.1.1651634693511; Tue, 03 May
 2022 20:24:53 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:34 +0000
Message-Id: <20220504032446.4133305-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 00/12] KVM: arm64: PSCI SYSTEM_SUSPEND support
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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

The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
allows software to request that the system be placed into the lowest
possible power state and await a wakeup event. This call is optional
in v1.0 and v1.1. KVM does not currently support this optional call.

This series adds support for the PSCI SYSTEM_SUSPEND call to KVM/arm64.
For reasons best described in patch 8, it is infeasible to correctly
implement PSCI SYSTEM_SUSPEND (or any system-wide event for that matter)
in a split design between kernel/userspace. As such, this series cheaply
exits to userspace so it can decide what to do with the call. This
series also gives userspace some help to emulate suspension with a new
MP state that awaits an unmasked pending interrupt.

Patches 1-5 are small reworks to more easily shoehorn the new features
into the kernel.

Patch 6 stands up the new suspend MP state, allowing userspace to
emulate the PSCI call.

Patch 7 actually allows userspace to enable the PSCI call, which
requires explicit opt-in for the new KVM_EXIT_SYSTEM_EVENT type.

Patches 8-11 clean up the way PSCI is tested in selftests to more easily
add new test cases.

Finally, the last patch actually tests that PSCI SYSTEM_SUSPEND calls
within the guest result in userspace exits.

Applies cleanly to 5.18-rc5. I'm sure you're already aware of it Marc,
but for the sake of everyone else there's some light conflict with
Raghu's patches that you've got queued up [1].

Tested with the included selftest and a hacked up kvmtool [2] with support
for the new UAPI.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/hcall-selection
[2]: https://lore.kernel.org/all/20220311175717.616958-1-oupton@google.com/

v5: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com

v5 -> v6:
  - Rebase to 5.18-rc5
  - Collect Reiji's R-b's
  - Drop the system_event helper. Since we now have variadic data
    returning to userspace it doesn't make much sense to roll it up into
    a helper. Meh.
  - Put back the pointless kvm_vcpu_request() in kvm_arm_vcpu_suspend().
    We'll rip out the reliance on vCPU requests for power state later
    on. It is entirely benign, even when a vCPU targets itself.

Oliver Upton (12):
  KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
  KVM: arm64: Dedupe vCPU power off helpers
  KVM: arm64: Track vCPU power state using MP state values
  KVM: arm64: Rename the KVM_REQ_SLEEP handler
  KVM: arm64: Return a value from check_vcpu_requests()
  KVM: arm64: Add support for userspace to suspend a vCPU
  KVM: arm64: Implement PSCI SYSTEM_SUSPEND
  selftests: KVM: Rename psci_cpu_on_test to psci_test
  selftests: KVM: Create helper for making SMCCC calls
  selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
  selftests: KVM: Refactor psci_test to make it amenable to new tests
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 Documentation/virt/kvm/api.rst                |  76 ++++++-
 arch/arm64/include/asm/kvm_host.h             |  10 +-
 arch/arm64/kvm/arm.c                          | 104 +++++++--
 arch/arm64/kvm/psci.c                         |  65 ++++--
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
 .../testing/selftests/kvm/aarch64/psci_test.c | 213 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
 tools/testing/selftests/kvm/steal_time.c      |  13 +-
 12 files changed, 480 insertions(+), 177 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
