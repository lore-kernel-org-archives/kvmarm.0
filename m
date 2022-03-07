Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354E9C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:49:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A28FA4B0C2;
	Mon,  7 Mar 2022 13:49:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9tq4hn6wYqIk; Mon,  7 Mar 2022 13:49:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A54F4B0B4;
	Mon,  7 Mar 2022 13:49:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 733764B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:49:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wgZwrlPgqZRi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:49:41 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3731E4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:49:41 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2dcd6a5e4b6so24474597b3.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=sfVUTk2MbhVgy0tKug84HjGTAODI0KpG5JNI6LdeG5Q=;
 b=mBD7jDE9tctzEwd05BghFMrXysPRXZH49psJdvMCVo1LFKJuoybPLYv+zm28CPjdAn
 FHmAenInSI30NtCmPkisWjlUYl1Phey3TlDGp11Ea9klFHmkRnvORexyuov/tZ/YAsES
 hhML8NfQLEIQc8mEK1/wQ3Ysoecxd1/NHjlfNnZKK3DpJAiuh2A4Ll9UUt3PonjBaMfZ
 9vIYC/bEKiOtXeNtZ6ktkA+fRw7AXbd/l7Awawerz2ZENW2plzW+EHM3y5NO+kkV+T9P
 ZLxsM1wmsAwhlwsDPVdTzWm373LE7elz/RpRUxHQyeuB3enAKW5BwS3y6YuHQERPfZtj
 YnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=sfVUTk2MbhVgy0tKug84HjGTAODI0KpG5JNI6LdeG5Q=;
 b=tctg7kVwocOG9GOrh+6eRzgitPx9Bv/2SfdHZJXfESmUWvzdGUk0H6fWlcOz3AlE3b
 bGsAL/Y4P5Car8J0DaQj5hh2SC8w6lNVjuCavB38/Gkq7dJKVG4nBpYRXPSFdBPebFvn
 uesBHyqynjY+2BhCmBHAeOzoYGNENpOfhvMvmJeFk7dXFHRTEAJmGjKffXxrDg0vG/eu
 kceoY8fdmFsucrdzt+KOwHUGOfC8OFathBJoZtNlS9qtfYHsNr+l7jI983ML+ZK5PSXe
 HGvbcvAXHUBK6dquzW8NRt8IEppN3A7lFNdChIOdw1YQ9yTdSMFhUKAnjYHFotjqYSza
 vH3Q==
X-Gm-Message-State: AOAM531C4bYWjGh8iXK/jwbSSEZBvxJDHraSY28mAG94cZwHeOPyQIvY
 DThj0Vp/aDL+6VKD8zIWyv3j1Ko9xnLcnYVsRA==
X-Google-Smtp-Source: ABdhPJwYR1ukUuK1X0gGG2I3YVw+cUKejD8V8+q6qNTMpKaEru/j9GxQIUP2JpqPwd8HWu9c/k22KViOLRx7I/V8ow==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a25:e645:0:b0:628:8f2b:ef2 with SMTP
 id d66-20020a25e645000000b006288f2b0ef2mr9304216ybh.475.1646678980575; Mon,
 07 Mar 2022 10:49:40 -0800 (PST)
Date: Mon,  7 Mar 2022 10:48:58 -0800
Message-Id: <20220307184935.1704614-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 0/8] KVM: arm64: Hypervisor stack enhancements
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

This is v5 of the nVHE hypervisor stack enhancements. The main changes in this
version are:
  - Align private allocations on based the order of their size
  - Allocate single private VA range for both stack and guard page
    (Don't rely on allocator providing separate allocations that are contiguous)
  - Rebase series on 5.17-rc7

Previous versions can be found at:
v4: https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/
v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

The previous cover letter has been copied below for convenience.

Thanks,
Kalesh

-----

This series is based on 5.17-rc7 and adds the following stack features to
the KVM nVHE hypervisor:

== Hyp Stack Guard Pages ==

Based on the technique used by arm64 VMAP_STACK to detect overflow.
i.e. the stack is aligned such that the 'stack shift' bit of any valid
SP is 1. The 'stack shift' bit can be tested in the exception entry to
detect overflow without corrupting GPRs.

== Hyp Stack Unwinder ==

Based on the arm64 kernel stack unwinder
(See: arch/arm64/kernel/stacktrace.c)

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
 arch/arm64/kvm/arm.c                 |  42 +++++-
 arch/arm64/kvm/handle_exit.c         |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h |   1 +
 arch/arm64/kvm/hyp/nvhe/host.S       |  29 ++++
 arch/arm64/kvm/hyp/nvhe/mm.c         |  56 ++++---
 arch/arm64/kvm/hyp/nvhe/setup.c      |  31 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c     |  30 +++-
 arch/arm64/kvm/mmu.c                 |  67 ++++++---
 scripts/kallsyms.c                   |   2 +-
 14 files changed, 440 insertions(+), 86 deletions(-)


base-commit: ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
