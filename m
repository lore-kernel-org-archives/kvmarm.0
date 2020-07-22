Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A1BC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5D2A2084D
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="uicjnXpH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5D2A2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E214B2BC;
	Wed, 22 Jul 2020 12:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9FoInB7Xu8xF; Wed, 22 Jul 2020 12:45:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF3C4B2A9;
	Wed, 22 Jul 2020 12:45:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6084B2A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MLAVjxadFWPf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:45:00 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A9D4B297
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:00 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id a15so2539141wrh.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=uK8JM1EQn953l4hGDn7zKBHviQV8WaFyoUu/xfhEpC4=;
 b=uicjnXpHLyBycUGbJeXW1bnB5AdLJ1vIB5qSpkXxiiI0/QNUiM2C/tpeHlrOE1EsZW
 aYvVDSXzKs6F/PWWDz+eCkjv/alvVv8dpbsda0R9i3ZWyQdHh6OUTSKx0uG8uaq0E7Xc
 KeejKt/rn73e0BYz8UDnVX79SoUII3hDUDVVuUxuFDN+uBYJeKOeMmXMy4Ytimhaejil
 p7t0h/y68w3BjV9hhkphxrH3yBNiCjlrtyHfwKwGwjrx1P5gC6DlBWVRIH1SgPR8kx4b
 bOx5jIJM2pIUODErYnMEhS7zO/hOhG1NC1m8HlpCdo8FNK7fH/XWc8DkGZ5kiSLTc7eh
 nIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=uK8JM1EQn953l4hGDn7zKBHviQV8WaFyoUu/xfhEpC4=;
 b=VSxIuNUHI9qTHoQh+PzgnJjxSfBuEtnqNvdFUC1mMVTDfgjzcVGHO+qD1jn1CV+1oa
 IqucqbKcP0UyyCEL/1qjb5cejrBKoa5MNN02VG2zgp1/x6rBsUJAqL4xGvWMZhdLS3SE
 70Co/6sVThcFLOznTMu0qJjQOXQL6MGnEH4pqEy58rZiDPNPKzWLvfc2N8WkB0mMTj+P
 Lx1I95osjaF/qfbcfBpsYx7sZGJbTn4hD7dxRMSxhesnghygqyT1nAmqzBRUGimQKEXi
 G7uUc7MoYLrvIluw4SF/PnCNYkjCnf54cAVFnrJT3k3FFapYDl1AiLSgOx+yRlDbPG96
 Ny8A==
X-Gm-Message-State: AOAM532rVNFuUwkSxy2+oubkujHBn0U3MWqp/SGMycdr3EiZfGY7m1t+
 5PFjiCBGI0m1FgwAe3FQA/Sn/Q==
X-Google-Smtp-Source: ABdhPJz2GhTgbxEm97Jbg+actM1Hl9ijg1JYz6533hzpsH9VeShzXrQ2seUMjDFp65Edaw0F/0nFQg==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr389718wrs.270.1595436299200;
 Wed, 22 Jul 2020 09:44:59 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b0ee:900a:e004:b9d0])
 by smtp.gmail.com with ESMTPSA id p14sm517283wrx.90.2020.07.22.09.44.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jul 2020 09:44:58 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/9] Independent per-CPU data section for nVHE
Date: Wed, 22 Jul 2020 17:44:15 +0100
Message-Id: <20200722164424.42225-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@google.com, kvmarm@lists.cs.columbia.edu,
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

Introduce '.hyp.data..percpu' as part of ongoing effort to make nVHE
hyp code self-contained and independent of the rest of the kernel.

The series builds on top of the "Split off nVHE hyp code" series which
used objcopy to rename '.text' to '.hyp.text' and prefix all ELF
symbols with '__kvm_nvhe' for all object files under kvm/hyp/nvhe.

The series is structured as follows:

 - patch 1: Modify generic PERCPU_* linker script macros to make it
     possible to define multiple per-CPU ELF sections with prefixed
     section and symbol names.

 - patches 2-3: Replace hyp helpers for accessing per-CPU variables
     with common helpers modified to work correctly in hyp. Per-CPU
     variables can now be accessed with one API anywhere.

 - patches 4-6: Where VHE and nVHE use per-CPU variables defined in
     kernel proper, move their definitions to hyp/ where they are
     duplicated and owned by VHE/nVHE, respectively. Non-VHE hyp code
     now refers only to per-CPU variables defined in its source files.
     Helpers are added so that kernel proper can continue to access
     nVHE hyp variables, same way as it does with other nVHE symbols.

 - patches 7-9: Introduce '.hyp.data..percpu' ELF section and allocate
     memory for every CPU core during KVM init. All nVHE per-CPU state
     is now grouped together in ELF and in memory. Introducing a new
     per-CPU variable does not require adding new memory mappings any
     more. nVHE hyp code cannot accidentally refer to kernel-proper
     per-CPU data as it only has the pointer to its own per-CPU memory.

The patches are rebased on current kvmarm/next (commit b72eb1f6813)
and are available in branch 'topic/percpu' at:
    https://android-kvm.googlesource.com/linux

David Brazdil (9):
  Macros to override naming of percpu symbols and sections
  kvm: arm64: Remove __hyp_this_cpu_read
  kvm: arm64: Remove hyp_adr/ldr_this_cpu
  kvm: arm64: Add helpers for accessing nVHE hyp per-cpu vars
  kvm: arm64: Duplicate arm64_ssbd_callback_required for nVHE hyp
  kvm: arm64: Create separate instances of kvm_host_data for VHE/nVHE
  kvm: arm64: Mark hyp stack pages reserved
  kvm: arm64: Set up hyp percpu data for nVHE
  kvm: arm64: Remove unnecessary hyp mappings

 arch/arm64/include/asm/assembler.h        |  27 ++++--
 arch/arm64/include/asm/kvm_asm.h          |  74 ++++++++-------
 arch/arm64/include/asm/kvm_host.h         |   2 +-
 arch/arm64/include/asm/kvm_mmu.h          |  23 ++---
 arch/arm64/include/asm/percpu.h           |  33 ++++++-
 arch/arm64/include/asm/sections.h         |   1 +
 arch/arm64/kernel/image-vars.h            |   2 -
 arch/arm64/kernel/vmlinux.lds.S           |  10 ++
 arch/arm64/kvm/arm.c                      | 110 ++++++++++++++++++----
 arch/arm64/kvm/hyp/hyp-entry.S            |   2 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |   6 +-
 arch/arm64/kvm/hyp/nvhe/Makefile          |   2 +
 arch/arm64/kvm/hyp/nvhe/switch.c          |   8 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |   5 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |   4 +-
 arch/arm64/kvm/pmu.c                      |  13 ++-
 include/asm-generic/vmlinux.lds.h         |  40 +++++---
 18 files changed, 257 insertions(+), 109 deletions(-)

-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
