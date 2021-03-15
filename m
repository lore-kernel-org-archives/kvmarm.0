Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97D0C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:35:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A70064F5C
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A70064F5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1854B4F3;
	Mon, 15 Mar 2021 10:35:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EaBIpoj5iCEF; Mon, 15 Mar 2021 10:35:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CC2E4B54B;
	Mon, 15 Mar 2021 10:35:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 820564B48E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yRXCtLpPybqo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:35:41 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28D704B48A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:41 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id l16so4440214wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=J3KTBHZZUPRc8/rc4HMjQwCiQA139xnQaWCjBIZ8now=;
 b=iBIMxwBxo/6zVj6QTVW3Ka82x67XtsdxzHlu/K1yUTToHujGTw51pjAcdp3v0K3m/I
 vMJlKwV+sh2AzQz9UKQ2rp5rdk3QeBPp9AtZZqbAQwXnO++noOOGowL7uvGh5TXLVD4b
 h9q/uYn4Vc7O18+XfVf6vSCoeypohEMCjqj88629Rh+YGVV0973YX59TcMcoyDIJUHU0
 WPk2kks278pptxfuc8NmjYD3GOxbhSYWXm/RM7bZgUYabEzubmBXQgG9aXCGHsFKMqKk
 AApWwuzBgYlHTTL0jRDKXHgdpS+7lXq/3x5Qan459HupqX4BWeF8rEi+gOC5yIyzK7OE
 M1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=J3KTBHZZUPRc8/rc4HMjQwCiQA139xnQaWCjBIZ8now=;
 b=nb1DLX6L6MElzH5JdcHBwTz1L5cTCeNZ1agNXSGOGheYcpFu7Tzc3pleZr0Ydg5UjP
 PILC6srUuj7JrvBT7/lbeSYQ/qMriisHMkoZhTkpG97Jn7HNUbmOoj7a6XyytFlN/ai7
 PySJbQf3O4mX3QXLJ1xv/60kxf6wXO0lYZkxsM2SeM7SSfCmxACFNVr3r/TGt0K4ax/O
 fo2oHhrv4QGfOiR0lPFFCm4tR+kdQhbNt+fE9vyGUZ+G0HtRYM4k2odV6L1C6vXaJwVk
 0QVEELqxxNCLFUaTIendGREBLS5Qy4a0l3EFbQLqMlXtZjVocvP7b1fx222fcR/kS0IT
 1lWg==
X-Gm-Message-State: AOAM5330hqMzGL1aN9djBKCFEp19EzoKbIHSas3e63gLo7uxeZYyTfN5
 icyY7+l3V6qpPbnSfMWFE8hKatgM+YWL
X-Google-Smtp-Source: ABdhPJzA7RpXq+URIl3fcSewaYhyFCtYLPrMLTmL6pMDgy9BM/OGrlmKXnmSZFcMqO80MB4a83HXlJ/zUpPG
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:608:: with SMTP id
 o8mr38548wmm.42.1615818939972; Mon, 15 Mar 2021 07:35:39 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:00 +0000
Message-Id: <20210315143536.214621-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 00/36] KVM: arm64: A stage 2 for the host
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi all,

This is the v5 of the series previously posted here:

  https://lore.kernel.org/kvmarm/20210310175751.3320106-1-qperret@google.com/

This basically allows us to wrap the host with a stage 2 when running in
nVHE, hence paving the way for protecting guest memory from the host in
the future (among other use-cases). For more details about the
motivation and the design angle taken here, I would recommend to have a
look at the cover letter of v1, and/or to watch these presentations at
LPC [1] and KVM forum 2020 [2].

Changes since v3:

 - simplified the infrastructure allowing to copy feature registers for
   use at EL2;

 - reworked the page-ownership path in the pgtable code to use an
   invalid PA instead of setting a valid bit upfront in the map() path;

 - refactored hyp_map_set_prot_attr() to match its stage-2 counterpart;

 - and a handful of small cleanups / comestic changes.

This series depends on Will's vCPU context fix ([3]) and Marc's PMU
fixes ([4]). And here's a branch with all the goodies applied:

  https://android-kvm.googlesource.com/linux qperret/host-stage2-v5

Thanks,
Quentin

[1] https://youtu.be/54q6RzS9BpQ?t=10859
[2] https://youtu.be/wY-u6n75iXc
[3] https://lore.kernel.org/kvmarm/20210226181211.14542-1-will@kernel.org/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-undef-NV

Quentin Perret (33):
  KVM: arm64: Initialize kvm_nvhe_init_params early
  KVM: arm64: Avoid free_page() in page-table allocator
  KVM: arm64: Factor memory allocation out of pgtable.c
  KVM: arm64: Introduce a BSS section for use at Hyp
  KVM: arm64: Make kvm_call_hyp() a function call at Hyp
  KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
  KVM: arm64: Introduce an early Hyp page allocator
  KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
  KVM: arm64: Introduce a Hyp buddy page allocator
  KVM: arm64: Enable access to sanitized CPU features at EL2
  KVM: arm64: Provide __flush_dcache_area at EL2
  KVM: arm64: Factor out vector address calculation
  arm64: asm: Provide set_sctlr_el2 macro
  KVM: arm64: Prepare the creation of s1 mappings at EL2
  KVM: arm64: Elevate hypervisor mappings creation at EL2
  KVM: arm64: Use kvm_arch for stage 2 pgtable
  KVM: arm64: Use kvm_arch in kvm_s2_mmu
  KVM: arm64: Set host stage 2 using kvm_nvhe_init_params
  KVM: arm64: Refactor kvm_arm_setup_stage2()
  KVM: arm64: Refactor __load_guest_stage2()
  KVM: arm64: Refactor __populate_fault_info()
  KVM: arm64: Make memcache anonymous in pgtable allocator
  KVM: arm64: Reserve memory for host stage 2
  KVM: arm64: Sort the hypervisor memblocks
  KVM: arm64: Always zero invalid PTEs
  KVM: arm64: Use page-table to track page ownership
  KVM: arm64: Refactor the *_map_set_prot_attr() helpers
  KVM: arm64: Add kvm_pgtable_stage2_find_range()
  KVM: arm64: Provide sanitized mmfr* registers at EL2
  KVM: arm64: Wrap the host with a stage 2
  KVM: arm64: Page-align the .hyp sections
  KVM: arm64: Disable PMU support in protected mode
  KVM: arm64: Protect the .hyp sections from the host

Will Deacon (3):
  arm64: lib: Annotate {clear,copy}_page() as position-independent
  KVM: arm64: Link position-independent string routines into .hyp.text
  arm64: kvm: Add standalone ticket spinlock implementation for use at
    hyp

 arch/arm64/include/asm/assembler.h            |  14 +-
 arch/arm64/include/asm/cpufeature.h           |   1 +
 arch/arm64/include/asm/hyp_image.h            |   7 +
 arch/arm64/include/asm/kvm_asm.h              |   9 +
 arch/arm64/include/asm/kvm_cpufeature.h       |  19 +
 arch/arm64/include/asm/kvm_host.h             |  19 +-
 arch/arm64/include/asm/kvm_hyp.h              |   8 +
 arch/arm64/include/asm/kvm_mmu.h              |  23 +-
 arch/arm64/include/asm/kvm_pgtable.h          | 128 +++++-
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/kernel/asm-offsets.c               |   3 +
 arch/arm64/kernel/cpufeature.c                |  13 +
 arch/arm64/kernel/image-vars.h                |  30 ++
 arch/arm64/kernel/vmlinux.lds.S               |  74 ++--
 arch/arm64/kvm/arm.c                          | 199 +++++++--
 arch/arm64/kvm/hyp/Makefile                   |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  34 +-
 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h |  14 +
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  68 ++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  36 ++
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  52 +++
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  96 +++++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  92 +++++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   9 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  13 +
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |  54 +++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |  42 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  69 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   7 +
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 279 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 173 ++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 195 +++++++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |   4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 214 ++++++++++
 arch/arm64/kvm/hyp/nvhe/stub.c                |  22 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  12 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                  | 378 ++++++++++++++----
 arch/arm64/kvm/hyp/reserved_mem.c             | 113 ++++++
 arch/arm64/kvm/mmu.c                          | 115 +++++-
 arch/arm64/kvm/perf.c                         |   3 +-
 arch/arm64/kvm/pmu.c                          |   8 +-
 arch/arm64/kvm/reset.c                        |  42 +-
 arch/arm64/kvm/sys_regs.c                     |  22 +
 arch/arm64/lib/clear_page.S                   |   4 +-
 arch/arm64/lib/copy_page.S                    |   4 +-
 arch/arm64/mm/init.c                          |   3 +
 48 files changed, 2488 insertions(+), 244 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/memory.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/early_alloc.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/page_alloc.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/setup.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
 create mode 100644 arch/arm64/kvm/hyp/reserved_mem.c

-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
