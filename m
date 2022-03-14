Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9617DC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:02:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31057404CD;
	Mon, 14 Mar 2022 16:02:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9+vRL6kDrTsm; Mon, 14 Mar 2022 16:02:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF3F949EBD;
	Mon, 14 Mar 2022 16:02:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4F949EB2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:02:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 90Jhh8RF9P5o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:02:02 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C17D14045D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:02:02 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d7eaa730d9so141792927b3.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=xEuR5NAbPKTc90nTUG2UpVDsPT4/g7gJ4EIuKy2M61Y=;
 b=ry7DrS+DzmCoBuS+N3t8KJPneqxZpyjWKhm0hi4UrJVtWocUiLGratH7dA7vGH64X7
 Qg/sE6ZP+ZQuX6cKWQqNcZW6E9FfL8kpyZVAoWnG+B5DO6fQiwivmN8fNnXVY0N6Ixvf
 bMOIdm00KmvyWI9+z3twtaJ6QG9adpXzf7D7r2LWmUXxnDLf73lL12Lok43SuXanyQop
 KBwSkd7sD4mFizm5xQ53F43xhYn9dXjcZk0+drkMZbmDDYN3Y4hmCBytmO7wv8ywRXdB
 b8p8OtiKMvR67lAOiIZx034Nf/fJoa1ZehmUA2wp5KusaqdbU77O+LKpVeykEIpNS6GY
 fuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=xEuR5NAbPKTc90nTUG2UpVDsPT4/g7gJ4EIuKy2M61Y=;
 b=kGCdVS5HlpAFG7jKeVGvvEmwR8JKeubDNlDfMkg4r0QQuMK+iW9Whw6w5e1Xu6QJiw
 NzPTumvMPL7fYwiuCSyVLs0rTKuKw7Y57iN6N1alt6FFDgnciMThkrazmn3jh+S60jCP
 iCkugojtiW1kU97uLJnkc/n1cNicuwUivy+7W/S2boYcqEi2u9noLH3ttOasQ+W9wvUp
 ocxEsgnHrVHVcp1f7/Ab7rMjnr86t4RDuQO9fR1olFk0Q2YW2sfAd7jd+W8NvPP+MT+X
 9wYnFjSaTGbuScfTRmRc60Y/fH5GsHIdFOvu/A1XrlzcC8Fz0dEnc4pNgvClxQebP7fG
 /2NQ==
X-Gm-Message-State: AOAM531UCYhM5IQGjEox3L6yj7ECV7IIuu2lyhd733kb3sBnqY88G+VO
 c3HnTlAJyf+vOKvVh57go5dPEvirL0uisYcYPQ==
X-Google-Smtp-Source: ABdhPJxifXiV2IwBShgAldnOtAN44f4qB6zmnPyH/IJw/7BkXZPOJKxYCtAxbJk4yN0V7cgS+dlxUhTFe/JmaJ6gOg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:500a:9ac2:e73e:69e3])
 (user=kaleshsingh job=sendgmr) by 2002:a25:7b85:0:b0:628:beb3:d877 with SMTP
 id w127-20020a257b85000000b00628beb3d877mr19510073ybc.8.1647288122059; Mon,
 14 Mar 2022 13:02:02 -0700 (PDT)
Date: Mon, 14 Mar 2022 13:01:09 -0700
Message-Id: <20220314200148.2695206-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 0/8] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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

Hi all,

This is v6 of the nVHE hypervisor stack enhancements. Addresses some
refactoring/cleanup and documentation improvments from Stephen,
and rebased on 5.17-rc8.

Previous versions can be found at:
v5: https://lore.kernel.org/r/20220307184935.1704614-1-kaleshsingh@google.com/
v4: https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/
v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

The previous cover letter has been copied below for convenience.

Thanks,
Kalesh

-----

This series is based on 5.17-rc8 and adds the following stack features to
the KVM nVHE hypervisor:

== Hyp Stack Guard Pages ==

Based on the technique used by arm64 VMAP_STACK to detect overflow.
i.e. the stack is aligned such that the 'stack shift' bit of any valid
SP is 1. The 'stack shift' bit can be tested in the exception entry to
detect overflow without corrupting GPRs.

== Hyp Stack Unwinder ==

The unwinding and dumping of the hyp stack is not enabled by default and
depends on CONFIG_NVHE_EL2_DEBUG to avoid potential information leaks.

When CONFIG_NVHE_EL2_DEBUG is enabled the host stage 2 protection is
disabled, allowing the host to read the hypervisor stack pages and unwind
the stack from EL1. This allows us to print the hypervisor stacktrace
before panicking the host; as shown below.

Example call trace:

[   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!
[   98.918360][  T426] nVHE HYP call trace:
[   98.918692][  T426] kvm [426]: [<ffffffc009615aac>] __kvm_nvhe_cpu_prepare_nvhe_panic_info+0x4c/0x68
[   98.919545][  T426] kvm [426]: [<ffffffc0096159a4>] __kvm_nvhe_hyp_panic+0x2c/0xe8
[   98.920107][  T426] kvm [426]: [<ffffffc009615ad8>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[   98.920665][  T426] kvm [426]: [<ffffffc009610a4c>] __kvm_nvhe___kvm_hyp_host_vector+0x24c/0x794
[   98.921292][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
. . .

[   98.973382][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
[   98.973816][  T426] kvm [426]: [<ffffffc0096152f4>] __kvm_nvhe___kvm_vcpu_run+0x38/0x438
[   98.974255][  T426] kvm [426]: [<ffffffc009616f80>] __kvm_nvhe_handle___kvm_vcpu_run+0x1c4/0x364
[   98.974719][  T426] kvm [426]: [<ffffffc009616928>] __kvm_nvhe_handle_trap+0xa8/0x130
[   98.975152][  T426] kvm [426]: [<ffffffc009610064>] __kvm_nvhe___host_exit+0x64/0x64
[   98.975588][  T426] ---- end of nVHE HYP call trace ----




Kalesh Singh (8):
  KVM: arm64: Introduce hyp_alloc_private_va_range()
  KVM: arm64: Introduce pkvm_alloc_private_va_range()
  KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
  KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
  KVM: arm64: Detect and handle hypervisor stack overflows
  KVM: arm64: Add hypervisor overflow stack
  KVM: arm64: Unwind and dump nVHE HYP stacktrace
  KVM: arm64: Symbolize the nVHE HYP backtrace

 arch/arm64/include/asm/kvm_asm.h     |  21 +++
 arch/arm64/include/asm/kvm_mmu.h     |   4 +
 arch/arm64/include/asm/stacktrace.h  |  12 ++
 arch/arm64/kernel/stacktrace.c       | 210 ++++++++++++++++++++++++---
 arch/arm64/kvm/Kconfig               |   5 +-
 arch/arm64/kvm/arm.c                 |  41 +++++-
 arch/arm64/kvm/handle_exit.c         |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h |   6 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  29 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  18 ++-
 arch/arm64/kvm/hyp/nvhe/mm.c         |  78 ++++++----
 arch/arm64/kvm/hyp/nvhe/setup.c      |  31 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c     |  30 +++-
 arch/arm64/kvm/mmu.c                 |  70 ++++++---
 scripts/kallsyms.c                   |   2 +-
 15 files changed, 477 insertions(+), 96 deletions(-)


base-commit: 09688c0166e76ce2fb85e86b9d99be8b0084cdf9
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
