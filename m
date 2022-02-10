Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157F8C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 09:28:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D7349F58;
	Fri, 11 Feb 2022 04:28:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eB-d3Hppgqht; Fri, 11 Feb 2022 04:28:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 736294A11C;
	Fri, 11 Feb 2022 04:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07E4749F53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:42:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rHeBf8pl8xRq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 17:42:44 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEC1D49F4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:42:44 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 3-20020a250103000000b0061d99b7d0b8so15074035ybb.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=KKogoV3I1Ztwi08cWi/kskl7f13dMqHnW1NYHFKZhQY=;
 b=MSpmQCaLUVfuj+jaf2QClix5p6yRH8yzpyXKVnUK70zmSq5C6/qdwILNdwUhcYMF8c
 u2hO+qWimnqb+XJXum2CyHU9kaCpP4gkRh47JMce1cQUyDNmevlnXSk/v4J+ibagMpdi
 6SyBC+677sSNAQTgfwfnsoK9hG38S7tJZegaoLmq/yU+PY5VBbjSvEWD5BQFkjDn541W
 0JSNQrorMDSfKK5rlmgt+EWI1MHti2dN4PrYJBbrILg+UvVfff878dBp5MtI/4qmAOqW
 Nc7XlL61zC/1JLJf8Tf3E1Keb7HV2kSiSgcuaOFlOR7BDfv+pCD6q+wH9wLq+bDThuMT
 cAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=KKogoV3I1Ztwi08cWi/kskl7f13dMqHnW1NYHFKZhQY=;
 b=JLqkp0SW1UdhtBNxpUmh/+qdLE25SSMkIP+q+9iLGJTufq4Ev0CltCAjyRCNYafrxR
 X6w9fV+Q5WIYg99/ewp8+5cDlTMMPic4c2DvVYTqcEyeiYdAChFCAtB9+ZhXVAzGgG1D
 EpQqXo3jCKprbRZrR0JFaPLg5nHv0MoRlmK/hu+GAxMe6MRXzXaas34vD7Aa5L36zFZG
 N1r+LeTf7k5XUhfeDZ6pmxZzmcpL0PtBiWpzqUDirRq58TlD8xi8TWd2dwu+X3B6eToI
 xYcpvqSlBV3tsa7LgSHh5LP94ASbGlf2aKEe/AcMdsDkGJz8eZgEfde6JyNP3jUw7inr
 bDbQ==
X-Gm-Message-State: AOAM531dLU7Gv+D25ZMWEOoGvKwCfp4VgNvhF9zC7wU504NLa5lJvjRx
 w5/SnLNd7bJXiIvHVa6Cfrn+M4BP2iR9OkjS9Q==
X-Google-Smtp-Source: ABdhPJyp/KdgRlhbqVTv9Y4bfoAHsHmpgIk8uWR57nT9DX2u71VlcwaE1ajfiRh3Ozy8DknZf9zAjVroiBACXQvDfw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:8f02:232:ad86:2ab2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:5802:: with SMTP id
 m2mr9400424ybb.681.1644532964348; Thu, 10 Feb 2022 14:42:44 -0800 (PST)
Date: Thu, 10 Feb 2022 14:41:41 -0800
Message-Id: <20220210224220.4076151-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH 0/7] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 11 Feb 2022 04:28:10 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, surenb@google.com,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

This series is based on v5.17-rc3 and adds the following stack features to
the KVM nVHE hypervisor:

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


Kalesh Singh (3):
  KVM: arm64: Add Hyp overflow stack
  KVM: arm64: Unwind and dump nVHE HYP stacktrace
  KVM: arm64: Symbolize the nVHE HYP backtrace

Quentin Perret (4):
  KVM: arm64: Map the stack pages in the 'private' range
  KVM: arm64: Factor out private range VA allocation
  arm64: asm: Introduce test_sp_overflow macro
  KVM: arm64: Allocate guard pages near hyp stacks

 arch/arm64/include/asm/assembler.h   |  11 +
 arch/arm64/include/asm/kvm_asm.h     |  17 ++
 arch/arm64/kernel/entry.S            |   9 +-
 arch/arm64/kvm/Makefile              |   1 +
 arch/arm64/kvm/arm.c                 |   2 +-
 arch/arm64/kvm/handle_exit.c         |  14 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h |   1 +
 arch/arm64/kvm/hyp/nvhe/host.S       |  21 ++
 arch/arm64/kvm/hyp/nvhe/mm.c         |  28 ++-
 arch/arm64/kvm/hyp/nvhe/setup.c      |  63 +++++-
 arch/arm64/kvm/hyp/nvhe/switch.c     |  22 ++
 arch/arm64/kvm/stacktrace.c          | 290 +++++++++++++++++++++++++++
 arch/arm64/kvm/stacktrace.h          |  17 ++
 scripts/kallsyms.c                   |   2 +-
 14 files changed, 468 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm64/kvm/stacktrace.c
 create mode 100644 arch/arm64/kvm/stacktrace.h


base-commit: dfd42facf1e4ada021b939b4e19c935dcdd55566
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
