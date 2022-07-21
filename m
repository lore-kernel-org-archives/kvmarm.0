Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8024CCA479
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD064D821;
	Thu, 21 Jul 2022 01:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5+6dHl38rNpG; Thu, 21 Jul 2022 01:57:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98464D1C2;
	Thu, 21 Jul 2022 01:57:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18A514CFCD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fxUT41bIP8G1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:33 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E0DD4CB66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:33 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 t10-20020a5b07ca000000b0066ec1bb6e2cso576137ybq.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=BPi3qwuzd4uNNwfj2R89YHgRbeVMrSv9BZ2KBqzg268=;
 b=tG2AiAzk/hBl2O6tmEa9KXqrG32m8BukA+9pPC0PoHo350s5LZXw91AZQWgYaGiK9S
 9a3SrwIHBduydbnYPJSwdU/i1OqNblGiEjN+MXpN0Yr6O2vE71gfcYzMtmheQkIJUadB
 Dn83bf59xPnIuvwHeH28SoE/o8CdTn3rOTdpkEOIgr5xmkdoIiQLqCZ/8vd862qLhYNH
 b5/rAXwx7z+nFzYqg6gQRCU5VYpsAN8+JTY5fQcnCNX924hGVF5HfzVtZYPo6pQGOdSG
 x3svkpuHtDvgGOb14n5Lwq5DbOQK1qKF1s/IS9orcdtrckCIjFyzbRP4ZB/1x1Ud318R
 LyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=BPi3qwuzd4uNNwfj2R89YHgRbeVMrSv9BZ2KBqzg268=;
 b=kEGSQggGqV1LxnNLn765x9gHAukrlMybXFBaa822HG49mlrx6/d4VnOtMrs41wglbX
 eBzhQjNRolpsZmaGWfAJ+tMGBbQTMrl9KQwzenIjiAph3AkFhQ2dxpdQKPN2fXfmGkSr
 YtYnujcyYKqCm1Fa599F4dVE4Bcb8p2oH5CoiWTjOcnRN6eJo9GaZnPwAPIeUiWKxS4E
 S+r5sEgVlQzuJDwnXvzOVgz4hR7kTgauzcuilMRCiQDPRqRNwrGM8SzPz7r9NkKAQ5Cn
 4hiHYocST9uE3gyyeSZwqmmPzgYhz8OLlSmuiKS29tP4wiNDUuZwC67zC7W4cnVciw5A
 aQIQ==
X-Gm-Message-State: AJIora+hDfszkbOu1hTsKqkQSskp+tAgJQnJfk6WrAVLCU+aRgw1PQ7C
 WCAsbnb0e+UyZK1gl6WCbLd2e57ShDAvTLVNFw==
X-Google-Smtp-Source: AGRyM1ugD/Bixs0rFCRjcHLoj52ZlDFliAzUFihzsKdSwFhIYUosVFoGEBcJCZTwlPY+7/o1AzYOe539+3NQqJLo2g==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:1107:b0:670:b5f2:2214 with
 SMTP id o7-20020a056902110700b00670b5f22214mr1578472ybu.565.1658383053036;
 Wed, 20 Jul 2022 22:57:33 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:11 -0700
Message-Id: <20220721055728.718573-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 00/17] KVM nVHE Hypervisor stack unwinder
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

This is v5 of nVHE hypervisor stacktraces support. The series is based on
arm64 for-next/stacktrace.

The previous versions were posted at:
v4: https://lore.kernel.org/r/20220715061027.1612149-1-kaleshsingh@google.com/
v3: https://lore.kernel.org/r/20220607165105.639716-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220502191222.4192768-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/

The main updates in this version are some refactoring to move stuff out of
stacktrace/nvhe.h (leaving only the unwinder implementation in the header);
and fixing the symbolization of the hyp stacktrace when KASLR is enabled;
along with the addressing the other minor comments.

Patch 18 (KVM: arm64: Dump nVHE hypervisor stack on panic) was also squashed
into earlier patches.

The previous cover letter is copied below for convenience.

Thanks all for your feedback.

--Kalesh

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

[  126.862960] kvm [371]: nVHE hyp panic at: [<ffff8000090a51d0>] __kvm_nvhe_recursive_death+0x10/0x34!
[  126.869920] kvm [371]: Protected nVHE HYP call trace:
[  126.870528] kvm [371]:  [<ffff8000090a5570>] __kvm_nvhe_hyp_panic+0xac/0xf8
[  126.871342] kvm [371]:  [<ffff8000090a55cc>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
[  126.872174] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  126.872971] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
   . . .

[  126.927314] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  126.927727] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
[  126.928137] kvm [371]:  [<ffff8000090a4de4>] __kvm_nvhe___kvm_vcpu_run+0x30/0x40c
[  126.928561] kvm [371]:  [<ffff8000090a7b64>] __kvm_nvhe_handle___kvm_vcpu_run+0x30/0x48
[  126.928984] kvm [371]:  [<ffff8000090a78b8>] __kvm_nvhe_handle_trap+0xc4/0x128
[  126.929385] kvm [371]:  [<ffff8000090a6864>] __kvm_nvhe___host_exit+0x64/0x64
[  126.929804] kvm [371]: ---- End of Protected nVHE HYP call trace ----

============

Kalesh Singh (17):
  arm64: stacktrace: Add shared header for common stack unwinding code
  arm64: stacktrace: Factor out on_accessible_stack_common()
  arm64: stacktrace: Factor out unwind_next_common()
  arm64: stacktrace: Handle frame pointer from different address spaces
  arm64: stacktrace: Factor out common unwind()
  arm64: stacktrace: Add description of stacktrace/common.h
  KVM: arm64: On stack overflow switch to hyp overflow_stack
  KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
  KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
  KVM: arm64: Stub implementation of pKVM HYP stack unwinder
  KVM: arm64: Stub implementation of non-protected nVHE HYP stack
    unwinder
  KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
  KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
  KVM: arm64: Implement protected nVHE hyp stack unwinder
  KVM: arm64: Implement non-protected nVHE hyp stack unwinder
  KVM: arm64: Introduce pkvm_dump_backtrace()
  KVM: arm64: Introduce hyp_dump_backtrace()

 arch/arm64/include/asm/kvm_asm.h           |  16 ++
 arch/arm64/include/asm/memory.h            |   8 +
 arch/arm64/include/asm/stacktrace.h        |  92 +++++----
 arch/arm64/include/asm/stacktrace/common.h | 230 +++++++++++++++++++++
 arch/arm64/include/asm/stacktrace/nvhe.h   | 199 ++++++++++++++++++
 arch/arm64/kernel/stacktrace.c             | 157 --------------
 arch/arm64/kvm/Kconfig                     |  15 ++
 arch/arm64/kvm/arm.c                       |   2 +-
 arch/arm64/kvm/handle_exit.c               | 101 +++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S             |   9 +-
 arch/arm64/kvm/hyp/nvhe/stacktrace.c       | 116 +++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           |   6 +
 13 files changed, 749 insertions(+), 204 deletions(-)
 create mode 100644 arch/arm64/include/asm/stacktrace/common.h
 create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c


base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
