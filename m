Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB074C34049
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41BB724672
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41BB724672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DB844AF41;
	Tue, 18 Feb 2020 14:58:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ca9BDvv4DtZ2; Tue, 18 Feb 2020 14:58:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DBE34AF43;
	Tue, 18 Feb 2020 14:58:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C6E4AF32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:58:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXdW+ASSJC3C for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 14:58:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 895B44AF30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 14:58:54 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF38631B;
 Tue, 18 Feb 2020 11:58:53 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60BA93F68F;
 Tue, 18 Feb 2020 11:58:53 -0800 (PST)
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 00/18] arm64: Modernize assembly annotations
Date: Tue, 18 Feb 2020 19:58:24 +0000
Message-Id: <20200218195842.34156-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
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

In an effort to clarify and simplify the annotation of assembly functions
in the kernel new macros have been introduced. These replace ENTRY and
ENDPROC and also add a new annotation for static functions which previously
had no ENTRY equivalent.

This series collects together all the currently pending patches relating
updating the arm64 architecture code to use the modern macros.

Mark Brown (18):
  arm64: crypto: Modernize some extra assembly annotations
  arm64: crypto: Modernize names for AES function macros
  arm64: entry: Annotate vector table and handlers as code
  arm64: entry: Annotate ret_from_fork as code
  arm64: entry: Additional annotation conversions for entry.S
  arm64: entry-ftrace.S: Convert to modern annotations for assembly
    functions
  arm64: ftrace: Correct annotation of ftrace_caller assembly
  arm64: ftrace: Modernise annotation of return_to_handler
  arm64: head.S: Convert to modern annotations for assembly functions
  arm64: head: Annotate stext and preserve_boot_args as code
  arm64: kernel: Convert to modern annotations for assembly data
  arm64: kernel: Convert to modern annotations for assembly functions
  arm64: kvm: Annotate assembly using modern annoations
  arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
  arm64: kvm: Modernize __smccc_workaround_1_smc_start annotations
  arm64: sdei: Annotate SDEI entry points using new style annotations
  arm64: vdso: Convert to modern assembler annotations
  arm64: vdso32: Convert to modern assembler annotations

 arch/arm64/crypto/aes-ce.S                    |   4 +-
 arch/arm64/crypto/aes-modes.S                 |  48 ++++----
 arch/arm64/crypto/aes-neon.S                  |   4 +-
 arch/arm64/crypto/ghash-ce-core.S             |  16 +--
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_mmu.h              |   9 +-
 arch/arm64/include/asm/mmu.h                  |   4 +-
 arch/arm64/kernel/cpu-reset.S                 |   4 +-
 arch/arm64/kernel/cpu_errata.c                |  16 ++-
 arch/arm64/kernel/efi-entry.S                 |   4 +-
 arch/arm64/kernel/efi-rt-wrapper.S            |   4 +-
 arch/arm64/kernel/entry-fpsimd.S              |  20 +--
 arch/arm64/kernel/entry-ftrace.S              |  48 ++++----
 arch/arm64/kernel/entry.S                     | 115 +++++++++---------
 arch/arm64/kernel/head.S                      |  73 +++++------
 arch/arm64/kernel/hibernate-asm.S             |  16 +--
 arch/arm64/kernel/hyp-stub.S                  |  20 +--
 arch/arm64/kernel/probes/kprobes_trampoline.S |   4 +-
 arch/arm64/kernel/reloc_test_syms.S           |  44 +++----
 arch/arm64/kernel/relocate_kernel.S           |   4 +-
 arch/arm64/kernel/sleep.S                     |  12 +-
 arch/arm64/kernel/smccc-call.S                |   8 +-
 arch/arm64/kernel/vdso/sigreturn.S            |   4 +-
 arch/arm64/kernel/vdso32/sigreturn.S          |  23 ++--
 arch/arm64/kvm/hyp-init.S                     |   8 +-
 arch/arm64/kvm/hyp.S                          |   4 +-
 arch/arm64/kvm/hyp/fpsimd.S                   |   8 +-
 arch/arm64/kvm/hyp/hyp-entry.S                |  27 ++--
 28 files changed, 280 insertions(+), 275 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
