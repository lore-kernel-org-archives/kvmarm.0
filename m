Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DE3C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1AC32245F
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vGAU2kWR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1AC32245F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 339144B4E9;
	Wed, 16 Sep 2020 13:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cMvodcdXmGWK; Wed, 16 Sep 2020 13:34:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D694B449;
	Wed, 16 Sep 2020 13:34:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 665794B3AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Q-bvg-r2J6m for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:34:47 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2075A4B3AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:47 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id a17so7773639wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=7mFDfLRc/4coa4w4PmVZiF39D3EbfTO0poh1JSaf3tg=;
 b=vGAU2kWRhekFoBDT7sUBYbd7AQ/0NP8rSF7wCZ5cc1mqJHfnkU2LjdxpqgvLSzC8C6
 HgK02bdPHtLbqtZn4q0RnS1+zmNXG6b9m/TES+lyBYb2TqNi/8kRzN7/jf0y7NjX7EpS
 pt6qAOuPo6oyK//jwyuGbT6kcxGnovcDDEppAUOdKxofvqiqaZmpGbz73Jb0jc5ytCne
 Elp8PtK3xec2AV24MDV0HI1V2eP53YwAN77CLySTA5Lm1UefJnEEepbtf3Ad6NktHs8V
 rKpZjaC58ODG5D60rOWatOiXUAirqTD58E++PKgCBvPwbwpXA3sRP3PQRGW3dcAiasL/
 Fqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=7mFDfLRc/4coa4w4PmVZiF39D3EbfTO0poh1JSaf3tg=;
 b=lhUTn1O/lGCbUjqutAj0T8plZAndMFAQ5xTLI2UdG7c2FMwzpDjviIuc0izwm8u9dk
 XG/RQttulZRPxKNAYDh+NYjKjZQzDSbc9p2zMUrOrWDXn4uDINXct8er++/V6C8n+ev5
 U99wlLyJdwdN3XMZNCMnGJCN4LCDHRB1E8tdKz4HJ+CWxbLaQ39vGHS20PaPFGgZiq/Y
 UDDwDLLnBuHPdiWpjmukCEzeZxELIO68b6DbEpZeub0q5su7hmedvrRaHOSioUgtWFyA
 L3efXuGzyoDQSu6My0TIzswU9KJpYb/GcIo2xLKjUdvmXH4wluqT4/cvf8Q2dkrRyynm
 KEww==
X-Gm-Message-State: AOAM532H15Zbd2flioO7rvIBnRvnSWVuE1CAfKdtDaBlDWDPovLhZN2c
 K4otKRwmL6X/jlw80+PTqmZ1b/1fVmvQ7hD7
X-Google-Smtp-Source: ABdhPJzmjFCynjgBuUkJ+b5Puz0KOw8KtSCoG1vuE4eR8lKjcBVC8JI8uRWOwLM4nzTsOVZRlwYx+A==
X-Received: by 2002:adf:d845:: with SMTP id k5mr26012928wrl.285.1600277685420; 
 Wed, 16 Sep 2020 10:34:45 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id a5sm246603wrp.37.2020.09.16.10.34.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:34:44 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 00/10] Independent per-CPU data section for nVHE
Date: Wed, 16 Sep 2020 18:34:28 +0100
Message-Id: <20200916173439.32265-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Introduce '.hyp.data..percpu' as part of ongoing effort to make nVHE
hyp code self-contained and independent of the rest of the kernel.

Main benefits:
 * independent nVHE per-CPU data section that can be unmapped from host,
 * more robust linking of nVHE hyp code,
 * no need for hyp-specific macros to access per-CPU variables.

The series is structured as follows:

 - patch 1: Improve existing hyp build rules. This could be sent and merged
    independently of per-CPU but this series builds on it.

 - patches 2-3: Minor cleanups.

 - patches 4-5: Replace hyp helpers for accessing per-CPU variables
     with common helpers modified to work correctly in hyp. Per-CPU
     variables can now be accessed with one API anywhere.

 - patches 6-8: Where VHE and nVHE use per-CPU variables defined in
     kernel proper, move their definitions to hyp/ where they are
     duplicated and owned by VHE/nVHE, respectively. Non-VHE hyp code
     now refers only to per-CPU variables defined in its source files.
     Helpers are added so that kernel proper can continue to access
     nVHE hyp variables, same way as it does with other nVHE symbols.

 - patches 9-11: Introduce '.hyp.data..percpu' ELF section and allocate
     memory for every CPU core during KVM init. All nVHE per-CPU state
     is now grouped together in ELF and in memory. Introducing a new
     per-CPU variable does not require adding new memory mappings any
     more. nVHE hyp code cannot accidentally refer to kernel-proper
     per-CPU data as it only has the pointer to its own per-CPU memory.

Patches are rebased on v5.9-rc5 and available in branch 'topic/percpu-v3' at:
    https://android-kvm.googlesource.com/linux

For maintainers: In case of interest, there are patches that remove the need
for redefining macros under DEBUG_PREEMPT available at the same repo, branch
'topic/percpu-v3-debug-preempt'. Since they are non-trivial, I am not going
to post them here so late in the 5.10 window. I plan to post them for 5.11
when they will also be useful for other patches.

Changes v2 -> v3:
 * Use PERCPU_INPUT in hyp.ld instead of modifying PERCPU_SECTION
 * Only pass linker script once to LD (fix error message)
 * Renamed '.hyp.o' to '.nvhe.o'
 * Use __KVM_VHE_HYPERVISOR__ to select TPIDR_EL2 instead of alternatives
 * Move all prefixing-related macros to hyp_image.h

Changes v1 -> v2:
 * partially link hyp code, add linker script

David Brazdil (11):
  kvm: arm64: Partially link nVHE hyp code, simplify HYPCOPY
  kvm: arm64: Move nVHE hyp namespace macros to hyp_image.h
  kvm: arm64: Only define __kvm_ex_table for CONFIG_KVM
  kvm: arm64: Remove __hyp_this_cpu_read
  kvm: arm64: Remove hyp_adr/ldr_this_cpu
  kvm: arm64: Add helpers for accessing nVHE hyp per-cpu vars
  kvm: arm64: Duplicate arm64_ssbd_callback_required for nVHE hyp
  kvm: arm64: Create separate instances of kvm_host_data for VHE/nVHE
  kvm: arm64: Mark hyp stack pages reserved
  kvm: arm64: Set up hyp percpu data for nVHE
  kvm: arm64: Remove unnecessary hyp mappings

 arch/arm64/include/asm/assembler.h        |  27 ++++--
 arch/arm64/include/asm/hyp_image.h        |  36 +++++++
 arch/arm64/include/asm/kvm_asm.h          |  82 ++++++++--------
 arch/arm64/include/asm/kvm_host.h         |   2 +-
 arch/arm64/include/asm/kvm_mmu.h          |  19 ++--
 arch/arm64/include/asm/percpu.h           |  33 ++++++-
 arch/arm64/include/asm/sections.h         |   1 +
 arch/arm64/kernel/image-vars.h            |   4 -
 arch/arm64/kernel/vmlinux.lds.S           |  13 +++
 arch/arm64/kvm/arm.c                      | 109 +++++++++++++++++++---
 arch/arm64/kvm/hyp/hyp-entry.S            |   2 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |   8 +-
 arch/arm64/kvm/hyp/nvhe/Makefile          |  60 ++++++------
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S         |  19 ++++
 arch/arm64/kvm/hyp/nvhe/switch.c          |   8 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |   5 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |   4 +-
 arch/arm64/kvm/pmu.c                      |  13 ++-
 19 files changed, 320 insertions(+), 129 deletions(-)
 create mode 100644 arch/arm64/include/asm/hyp_image.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S

-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
