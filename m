Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161ECC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 21:46:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8191249EF4;
	Mon,  4 Apr 2022 17:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SchynT8kBGhd; Mon,  4 Apr 2022 17:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55F6B4B1CA;
	Mon,  4 Apr 2022 17:46:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B299E4B176
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GWrRO5Jk1Vp6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 17:46:47 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A6C349EF4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:47 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 p3-20020a056a0026c300b004fe25be54ffso569332pfw.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 14:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=vUdWzFrtPhSM1t/d7+UY/dP+cyIa6smY9TFzKXaIHpA=;
 b=V4vwKaWAkxqTgX2AzXs0gs0B3RUKxIy/ZcyRrVX+S2KTcAyTChPxqM8UfpbheoXIlm
 ZtQQ/WOTZ9GtjhPHGtNgZ4X7d/l6AjxO38FTCxUmy8VQ1IZg22h+vdE0YysZkBpfNcB8
 hNb+uI8g2KTOiWfyPpfqUBagNO+5ZvpSpoLoLaX9iOBvUDe7Kkuf4mxrrO9OIuyWFlhG
 wiAFPwEpNFqe0eLAAViQ5rkEaSH+KR1ebfSteZwgzREt46t7200BztrXYeadZ+CVI2jD
 UPZaCiZ+8X3fHIc1pyE2SaFsGNB7qAECecHutAJC+z5L/Fo7jTtrRxRbj5yuK6Q4uVEd
 CqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=vUdWzFrtPhSM1t/d7+UY/dP+cyIa6smY9TFzKXaIHpA=;
 b=b+LrwkLu8gtdxprPKdaxCAZ0J4EUc2e7uKPrfrusg+iHy3NR4mlWpcKiL9IUDqAdZd
 xi9zFTlgnIxOSL6riEKzRQJbsXT//p0MViEwo95Sccgxpo23j7U24XNKTYS8dmZxYeyW
 BRPJYGS0An+I7SY/DKwHC+o6ClOWeUdwM3pyQssMTu2DRHb8K/Tci9ZNqJBlIgR1kF6p
 A84UOv3mjKtOcE9dwoQQkjSv50hErSwMwffrCs3PbSiiRNft91PNJN+4sM10Yv7Uc8tY
 ltlAdjeeV7hzTBC8Hepn0/kwUYDV9BaP6C7H49/iw7Lf2V0C8agBo8v0WEocfyM7VEaZ
 9aiA==
X-Gm-Message-State: AOAM5315X1m5JBEXMMcw2v2uV9AQ3SFnfLOZj+kfqyOuDMWGW8ARygjw
 6qXT1hCzI11IeoP63kqfDbu626l8BJjY1g==
X-Google-Smtp-Source: ABdhPJx3wtgMXfXkSOgJuNWH/gD+BQjjw3/wZz2AUGKgXDMbpUHr5B1iER2pE+Nbz2Hw6rypSj4a9vxSUnkQWw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a65:5c48:0:b0:382:2c7:28e9 with SMTP id
 v8-20020a655c48000000b0038202c728e9mr187143pgr.472.1649108806206; Mon, 04 Apr
 2022 14:46:46 -0700 (PDT)
Date: Mon,  4 Apr 2022 14:46:38 -0700
Message-Id: <20220404214642.3201659-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 0/4] KVM: arm64: selftests: Add edge cases tests for the
 arch timer
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- having the same timer condition firing multiple times.

The tests run while checking the state of the IRQs (e.g., pending when they
are supposed to be) and stressing things a bit by waiting for interrupts
while: re-scheduling the vcpu (with sched_yield()), by migrating the vcpu
between cores, or by sleeping in userspace (with usleep()).

The first commit adds a timer utility function.  The second commit adds
some sanity checks and basic tests for the timer. The third commit adds
the actual edge case tests (like forcing rollovers).

v3 ->v4:
- Fix is_cpu_online to also check whether the cpu is allowed to run the current
  process (on top of being online). Renamed is_cpu_online() to
  is_cpu_eligible_to_run(). [Sean]

v2 -> v3: https://lore.kernel.org/kvmarm/20220322172319.2943101-1-ricarkol@google.com/
- Add missing isb when polling for IRQ being handled. [Oliver, Marc]
- Wait for a counter pass by polling on it (instead of the previous isb).
  [Oliver, Marc]
- Edits in some comments. [Oliver]
- Dropping the msecs_to_usecs macro. [Oliver]
- Skipping test if desired pcpus are not online. This needed adding a
  library function (is_cpu_online). [Oliver]

v1 -> v2: https://lore.kernel.org/kvmarm/20220317045127.124602-1-ricarkol@google.com/
- Remove the checks for timers firing within some margin; only leave the
  checks for timers not firing ahead of time. Also remove the tests that
  depend on timers firing within some margin. [Oliver, Marc]
- Collect R-b tag from Oliver (first commit). [Oliver]
- Multiple nits: replace wfi_ functions with wait_, reduce use of macros,
  drop typedefs, use IAR_SPURIOUS from header, move some comments functions
  to top. [Oliver]
- Don't fail if the test has a single cpu available. [Oliver]
- Don't fail if there's no GICv3 available. [Oliver]

v1: https://lore.kernel.org/kvmarm/20220302172144.2734258-1-ricarkol@google.com/

Ricardo Koller (4):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: selftests: add is_cpu_eligible_to_run() utility function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 904 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  18 +-
 .../testing/selftests/kvm/include/test_util.h |   2 +
 tools/testing/selftests/kvm/lib/test_util.c   |  20 +-
 6 files changed, 944 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
