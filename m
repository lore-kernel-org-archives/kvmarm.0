Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CE8C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFB64C487;
	Wed, 23 Feb 2022 06:02:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mdwSqgZleTEn; Wed, 23 Feb 2022 06:02:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC27F4C482;
	Wed, 23 Feb 2022 06:02:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4BB549EC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:52:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a7bt7utg5aHB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:52:43 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97B0749EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:52:43 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d07ae11462so146883247b3.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=FUZhxNiWpTBuv/yo6aC9br7WFC740z5ipvXijUNB1uM=;
 b=rl7DGr9SKCJXXULyQIrNMfWNqV8X0uSCbZhx5bKPP42G9Onx9lq+GQAIBvFAcYM0KR
 Yud0tbtBDX9beTd1+sjFvWoFwk5t88qg3J8PAorzHjj5DCnaTGLU11aui2kWTwEwa6xW
 99/fFQPBB69uHXZRrLMnY8mskRUSa+VgfrimpGhCICIeOSjegQMfKYPl8tb+QwDyI4ED
 lb2YHKrWGQYam0vicFHUYcE7//ShpkJZAnf2Z1mqkqoEvEPITOq8clnVfeWptecNU6Za
 DrkwL6jDl0jULxJGn0RHx0MH8eTOkdkY0DSoUVak546uIUpSPco/QgZ6eFu6kAr1RrKr
 S/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=FUZhxNiWpTBuv/yo6aC9br7WFC740z5ipvXijUNB1uM=;
 b=Xj4YawV8GDJOgRY6ltVg38J3AfJhrxr3Fx+tyGwlSQMy/BEZuYukwdqKYr9sD1BRo3
 nsGruIXIwriys607a81+cHRF/HT4bj1GJ97t9RLJWmnJ5MnliTXB9KjuMBcLd+ipXBb+
 /hDrgFzypIF6ztbB4D6kPG0X/8Vtt4tycVk+2Ya006D4ERmf1nlYLp3pp0TsPwP+TJhZ
 jjoXpWmWInYoz2OMLuQZSewo6BfMSH0XCyQq7dXP5yfk5WY3xirtsJ6T9HCyNePvXuCC
 mPHIZnuMAKhAEwjKqUqPLHd17zSk7xaPdDjJVyYddO4SQ1VRELzzO/K+F1d8KFgRW1Iw
 l7kQ==
X-Gm-Message-State: AOAM531YEZEexEqqpEP38/+pcgLD+kvItZUD0OWuRiRunZgoo7u6ldpt
 GePMMfjcm8bXvixWEEloM0HKm8HNryhHjK0RBA==
X-Google-Smtp-Source: ABdhPJyDNYxSumcySMKx9aBNsuewfhPBBIWRyZkgKwWzEZsy+dn6LQiZfsn1zFM7NhoOIoZ+FkhSFT8MYUoWd1pNFw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a81:4bcd:0:b0:2d0:a61f:6b5a with SMTP
 id y196-20020a814bcd000000b002d0a61f6b5amr23695338ywa.477.1645548763067; Tue,
 22 Feb 2022 08:52:43 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:01 -0800
Message-Id: <20220222165212.2005066-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 0/9] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Kalesh Singh <kaleshsingh@google.com>,
 surenb@google.com, linux-arm-kernel@lists.infradead.org
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

This is v2 of the nVHE hypervisor stack enhancements. v1 can be found at:
https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

This version has been updated to work for 'classic' KVM in nVHE mode in
addition to pKVM, per Marc; and rebased on 5.17-rc5.

The cover letter has been copied below for convenience.

Thanks,
Kalesh

-----

This series adds the following stack features to the KVM nVHE hypervisor:

== Hyp Stack Guard Pages ==

Based on the technique used by arm64 VMAP_STACK to detect overflow.
i.e. the stack is aligned to twice its size which ensure that the 
'stack shift' bit of any valid SP is 0. The 'stack shift' bit can be
tested in the exception entry to detect overflow without corrupting GPRs.

== Hyp Stack Unwinder ==

Based on the arm64 kernel stack unwinder
(See: arch/arm64/kernel/stacktrace.c)

The unwinding and dumping of the hyp stack is not enabled by default and
depends on CONFIG_NVHE_EL2_DEBUG to avoid potential information leaks.

When CONFIG_NVHE_EL2_DEBUG is enabled the host stage 2 protection is
disabled, allowing the host to read the hypervisor stack pages and unwind
the stack from EL1. This allows us to print the hypervisor stacktrace
before panicking the host; as shown below:

kvm [408]: nVHE hyp panic at: \
           [<ffffffc01161460c>] __kvm_nvhe_overflow_stack+0x10/0x34!
kvm [408]: nVHE HYP call trace:
kvm [408]: [<ffffffc011614974>] __kvm_nvhe_hyp_panic_bad_stack+0xc/0x10
kvm [408]: [<ffffffc01160fa48>] __kvm_nvhe___kvm_hyp_host_vector+0x248/0x794
kvm [408]: [<ffffffc01161461c>] __kvm_nvhe_overflow_stack+0x20/0x34
. . .
kvm [408]: [<ffffffc01161461c>] __kvm_nvhe_overflow_stack+0x20/0x34
kvm [408]: [<ffffffc01161421c>] __kvm_nvhe___kvm_vcpu_run+0x2c/0x40c
kvm [408]: [<ffffffc011615e14>] __kvm_nvhe_handle___kvm_vcpu_run+0x1c8/0x36c
kvm [408]: [<ffffffc0116157c4>] __kvm_nvhe_handle_trap+0xa4/0x124
kvm [408]: [<ffffffc01160f060>] __kvm_nvhe___host_exit+0x60/0x64
kvm [408]: ---- end of nVHE HYP call trace ----


Kalesh Singh (8):
  KVM: arm64: Introduce hyp_alloc_private_va_range()
  KVM: arm64: Introduce pkvm_alloc_private_va_range()
  KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
  KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
  KVM: arm64: Detect and handle hypervisor stack overflows
  KVM: arm64: Add hypervisor overflow stack
  KVM: arm64: Unwind and dump nVHE HYP stacktrace
  KVM: arm64: Symbolize the nVHE HYP backtrace

Quentin Perret (1):
  arm64: asm: Introduce test_sp_overflow macro

 arch/arm64/include/asm/assembler.h   |  11 +
 arch/arm64/include/asm/kvm_asm.h     |  18 ++
 arch/arm64/include/asm/kvm_mmu.h     |   4 +
 arch/arm64/kernel/entry.S            |   7 +-
 arch/arm64/kvm/Kconfig               |   5 +-
 arch/arm64/kvm/Makefile              |   1 +
 arch/arm64/kvm/arm.c                 |  34 +++-
 arch/arm64/kvm/handle_exit.c         |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  21 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |   5 +-
 arch/arm64/kvm/hyp/nvhe/mm.c         |  49 +++--
 arch/arm64/kvm/hyp/nvhe/setup.c      |  25 ++-
 arch/arm64/kvm/hyp/nvhe/switch.c     |  29 +++
 arch/arm64/kvm/mmu.c                 |  61 ++++--
 arch/arm64/kvm/stacktrace.c          | 290 +++++++++++++++++++++++++++
 arch/arm64/kvm/stacktrace.h          |  17 ++
 scripts/kallsyms.c                   |   2 +-
 18 files changed, 533 insertions(+), 65 deletions(-)
 create mode 100644 arch/arm64/kvm/stacktrace.c
 create mode 100644 arch/arm64/kvm/stacktrace.h


base-commit: cfb92440ee71adcc2105b0890bb01ac3cddb8507
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
