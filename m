Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996E5C43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F11294C437;
	Tue, 26 Jul 2022 03:37:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f+sPdVK1haLj; Tue, 26 Jul 2022 03:37:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8674C53B;
	Tue, 26 Jul 2022 03:37:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BDCA4C508
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yT31mVUvfecl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:37:55 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 828D74C437
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:37:55 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m5-20020a2598c5000000b0066faab590c5so10336458ybo.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Zkvbbd71rFcp/5pkrofzfRbxCdOfkUQrx8t07Ja45VM=;
 b=BsTFVNclyw0PgiHpJkckONN5sobCiNVeaNkOuXPQh0z/fr3/H/ZpJq229bQB4WI8wH
 dCpFTOw3hIUtXYetVsnvxEd6YG5AHn3GC9O+CZYb51dySuTzvvd9hatiRjSNtCmolgNA
 Si3A1LZUVDzfouL+qH+feg/jA921FtBlsSRkAGYovsFM4NxbUv3oMIla0duEjjqxL6r0
 s7bYgreKYpay29mjBR55y8DGLtNN0dCEyqqM06vSiUb+3azEzwBIIXw9TMPw1KRlEMKk
 p4pOtC2fNC/gIOzW3GObbQuj0ZXHWwFJ9C8jnjejHVPBGOBuI7Im25Ue5T0JpTeW8OXL
 GgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Zkvbbd71rFcp/5pkrofzfRbxCdOfkUQrx8t07Ja45VM=;
 b=GE+cDXabljtayZvS2dSD55H5h+w9L0WhoSkpYkkZS4PH7sRcq+XFyTsehl1W/G7xgm
 yguJ00uNflR1u6cEtBVs7jVGopUePvo1BkucWjpSLtdAtxC+hPiPoYVe+mfjjgoZ7QCO
 xtjudmnrZ4LR80dx9BzNAfqDvZ8UkN9vvmien6UpKD2Hn6wUxWRwl9amGBbFGUyGGbNx
 6LvWiTqlAYWAX+TFCzSOCpFDw0nWlFVCU1SipefjybNtv90pZBpdc+ebBehaFZB9cHqV
 TVXHo6YDT+TW10mjzXy1dMBsFQCUOtsdupeRKL4c4nHNxqlgL9aH3RVjCca6Id1NebpW
 8+rw==
X-Gm-Message-State: AJIora+i9b3YIeHRXfchD9rwxWRstRaWTJ5A4gFTFxbvfKsfNUYkLX5V
 avA2vLTYMoQij6pCVr4oWOVu0kVtbVwMU32grA==
X-Google-Smtp-Source: AGRyM1uW7EiXw04g/GMZdlvtloDg+5FYArnZQtp3GXa1FArDhRIL+bj0E4vzJyxfIMxiB2DYEOAxlDmRYc2uFTHy1A==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:706:b0:670:a469:6efb with
 SMTP id k6-20020a056902070600b00670a4696efbmr13007602ybt.410.1658821075048;
 Tue, 26 Jul 2022 00:37:55 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:33 -0700
Message-Id: <20220726073750.3219117-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 00/17] KVM nVHE Hypervisor stack unwinder
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

This is v6 of nVHE stacktrace support. The series is based on
arm64 for-next/stacktrace.

The previous versions were posted at:
v5: https://lore.kernel.org/r/20220721055728.718573-1-kaleshsingh@google.com/
v4: https://lore.kernel.org/r/20220715061027.1612149-1-kaleshsingh@google.com/
v3: https://lore.kernel.org/r/20220607165105.639716-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220502191222.4192768-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/

This version mainly reorganizes the order of to patches into more coherent
groups, along with addressing the other feedback in v5.

Patches 1 to 6 factor out the common unwinding logic into
into arch/arm64/include/asm/stacktrace/common.h, for reuse by the nVHE
unwinder. No functional change is introduced by these:

  [01/17] arm64: stacktrace: Add shared header for common stack unwinding code
  [02/17] arm64: stacktrace: Factor out on_accessible_stack_common()
  [03/17] arm64: stacktrace: Factor out unwind_next_common()
  [04/17] arm64: stacktrace: Handle frame pointer from different address spaces
  [05/17] arm64: stacktrace: Factor out common unwind()
  [06/17] arm64: stacktrace: Add description of stacktrace/common.h

Patches 7 to 11 implement stacktraces for conventional nVHE (non-protected
mode):

  [07/17] KVM: arm64: On stack overflow switch to hyp overflow_stack
  [08/17] KVM: arm64: Stub implementation of non-protected nVHE HYP stack
    unwinder
  [09/17] KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
  [10/17] KVM: arm64: Implement non-protected nVHE hyp stack unwinder
  [11/17] KVM: arm64: Introduce hyp_dump_backtrace()

Patches 12 to 17 implement stacktraces for protected-nVHE (pKVM):

  [12/17] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
  [13/17] KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
  [14/17] KVM: arm64: Stub implementation of pKVM HYP stack unwinder
  [15/17] KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
  [16/17] KVM: arm64: Implement protected nVHE hyp stack unwinder
  [17/17] KVM: arm64: Introduce pkvm_dump_backtrace()

The updated cover letter is copied below for convenience.

Thanks,
Kalesh

============

KVM nVHE Stack unwinding.
===

nVHE has two modes of operation: protected (pKVM) and unprotected
(conventional nVHE). Depending on the mode, a slightly different approach
is used to dump the hypervisor stacktrace but the core unwinding logic
remains the same.

Protected nVHE (pKVM) stacktraces
====

In protected nVHE mode, the host cannot directly access hypervisor memory.

The hypervisor stack unwinding happens in EL2 and is made accessible to
the host via a shared buffer. Symbolizing and printing the stacktrace
addresses is delegated to the host and happens in EL1.

Non-protected (Conventional) nVHE stacktraces
====

In non-protected mode, the host is able to directly access the hypervisor
stack pages.

The hypervisor stack unwinding and dumping of the stacktrace is performed
by the host in EL1, as this avoids the memory overhead of setting up
shared buffers between the host and hypervisor.

Resuing the Core Unwinding Logic
====

Since the hypervisor cannot link against the kernel code in proteced mode.
The common stack unwinding code is moved to a shared header to allow reuse
in the nVHE hypervisor.

Reducing the memory footprint
====

In this version the below steps were taken to reduce the memory usage of
nVHE stack unwinding:

    1) The nVHE overflow stack is reduced from PAGE_SIZE to 4KB; benificial
       for configurations with non 4KB pages (16KB or 64KB pages).
    2) In protected nVHE mode (pKVM), the shared stacktrace buffers with the
       host are reduced from PAGE_SIZE to the minimum size required.
    3) In systems other than Android, conventional nVHE makes up the vast
       majority of use case. So the pKVM stack tracing is disabled by default
       (!CONFIG_PROTECTED_NVHE_STACKTRACE), which avoid the memory usage for
       setting up shared buffers.
    4) In non-protected nVHE mode (conventional nVHE), the stack unwinding
       is done directly in EL1 by the host and no shared buffers with the
       hypervisor are needed.

Sample Output
====

The below shows an example output from a simple stack overflow test:

[  111.623091] kvm [367]: nVHE call trace:
[  111.623215] kvm [367]:  [<ffff8000090a6570>] __kvm_nvhe_hyp_panic+0xac/0xf8
[  111.623448] kvm [367]:  [<ffff8000090a65cc>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[  111.623642] kvm [367]:  [<ffff8000090a61e4>] __kvm_nvhe_recursive_death+0x24/0x34
. . .
[  111.640366] kvm [367]:  [<ffff8000090a61e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  111.640467] kvm [367]:  [<ffff8000090a61e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  111.640574] kvm [367]:  [<ffff8000090a5de4>] __kvm_nvhe___kvm_vcpu_run+0x30/0x40c
[  111.640676] kvm [367]:  [<ffff8000090a8b64>] __kvm_nvhe_handle___kvm_vcpu_run+0x30/0x48
[  111.640778] kvm [367]:  [<ffff8000090a88b8>] __kvm_nvhe_handle_trap+0xc4/0x128
[  111.640880] kvm [367]:  [<ffff8000090a7864>] __kvm_nvhe___host_exit+0x64/0x64
[  111.640996] kvm [367]: ---[ end nVHE call trace ]---

============

Kalesh Singh (17):
  arm64: stacktrace: Add shared header for common stack unwinding code
  arm64: stacktrace: Factor out on_accessible_stack_common()
  arm64: stacktrace: Factor out unwind_next_common()
  arm64: stacktrace: Handle frame pointer from different address spaces
  arm64: stacktrace: Factor out common unwind()
  arm64: stacktrace: Add description of stacktrace/common.h
  KVM: arm64: On stack overflow switch to hyp overflow_stack
  KVM: arm64: Stub implementation of non-protected nVHE HYP stack
    unwinder
  KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
  KVM: arm64: Implement non-protected nVHE hyp stack unwinder
  KVM: arm64: Introduce hyp_dump_backtrace()
  KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
  KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
  KVM: arm64: Stub implementation of pKVM HYP stack unwinder
  KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
  KVM: arm64: Implement protected nVHE hyp stack unwinder
  KVM: arm64: Introduce pkvm_dump_backtrace()

 arch/arm64/include/asm/kvm_asm.h           |  16 ++
 arch/arm64/include/asm/memory.h            |   8 +
 arch/arm64/include/asm/stacktrace.h        |  92 +++++----
 arch/arm64/include/asm/stacktrace/common.h | 230 +++++++++++++++++++++
 arch/arm64/include/asm/stacktrace/nvhe.h   | 176 ++++++++++++++++
 arch/arm64/kernel/stacktrace.c             | 157 --------------
 arch/arm64/kvm/Kconfig                     |  15 ++
 arch/arm64/kvm/arm.c                       |   2 +-
 arch/arm64/kvm/handle_exit.c               | 102 +++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S             |   9 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c       | 109 ++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           |   6 +
 13 files changed, 720 insertions(+), 204 deletions(-)
 create mode 100644 arch/arm64/include/asm/stacktrace/common.h
 create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c


base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
