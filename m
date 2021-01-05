Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAA6C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:05:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71DD522CF7
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:05:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71DD522CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C195B4B20F;
	Tue,  5 Jan 2021 13:05:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K0fFyXuOJJ3w; Tue,  5 Jan 2021 13:05:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 310A74B2E6;
	Tue,  5 Jan 2021 13:05:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A81914B275
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:05:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k-4Ge2BKNCh4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:05:51 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36DAD4B20F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:05:51 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id r3so115088wrt.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=hlENDTIUol+EdN5VnNheWvF9f4CyJQRs2PzF8BBX3kg=;
 b=ekLy75Tx+nSo0ogvhMaVAY8BSdgyBJVQYLbNWQJtFMIw1d8REekvcR0P2SSbZgpjWq
 5N5G5BKx4y0+C+jgql8evb9s+764J/xZGnwf2ubC3hrwRiu80A+I+7kMMWzDRwhSFEXG
 YDQTIvMfqZFQrrBABGuKu02ZFfnrMolhcaM/yNzWD1RZMrBOc9wta1h+G0G5aplpepEZ
 L89uKV+jC6ib+YdkUEQrU2kqZaOgu6C/yUbs0tzprKGRgsJoByHd+BaiAQRTDAKQX77P
 GUZdEP94V4DfWGv3/oMnqDV1hmhxUF6razvUh1ocEByCXH9vdz9n1w6DPgmx9K7SQBuL
 pzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=hlENDTIUol+EdN5VnNheWvF9f4CyJQRs2PzF8BBX3kg=;
 b=Czhzwo2D3BRl/7T8pRBKV9g1KFv1zLem+tSFOCBRbaTKzidsasiYiyF7/MXAYJ5Z96
 73C+gKHbOfsjDU5Sg5VXcg3hSA2Q3y7Agy0Pr5BEkoe8SN1StuHVpc354k92Du1L1ERK
 Mtnvc8Vmtk2r3/nXLs2MJU4Y6fGN4JKRLGvSbOCh1Ovtu0ZxZaAslM8XfmDbJ33NbcPy
 BnP0ZI/L9H0vjsQSM8HhOnS71iXR06tNRykBYP4JDwyrb/Qfl3E9AhHJGitVwE4+uVR0
 vqIEaQDXudw9J+BaD5tdvM8jAmUYnHz+ZZKyTX/xZke+SAUwOuw3jHmwHHWLtaHWUK6C
 eQTg==
X-Gm-Message-State: AOAM533Qk4nC2B7dPGMX/u/CbH4xRybfeZqSBliGVGrnie1WOhnP2G/Y
 x9SvwN8zKH2ZuKNs+pfz7GXHEyZmVX1BiA==
X-Google-Smtp-Source: ABdhPJzzI0r9N+4/GiWQj8jGCkL+Dm2s32peLrs/YvGf/0LqboOlGOCfcaXZq5RT/gNiTgtdV2/ABg==
X-Received: by 2002:adf:fbc5:: with SMTP id d5mr775813wrs.82.1609869949626;
 Tue, 05 Jan 2021 10:05:49 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id t16sm374514wmi.3.2021.01.05.10.05.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:05:48 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/8] arm64: Relocate absolute hyp VAs
Date: Tue,  5 Jan 2021 18:05:33 +0000
Message-Id: <20210105180541.65031-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

nVHE hyp code is linked into the same kernel binary but executes under
different memory mappings. If the compiler of hyp code chooses absolute
addressing for accessing a symbol, the kernel linker will relocate that
address to a kernel image virtual address, causing a runtime exception.

So far the strategy has been to force PC-relative addressing by wrapping
all symbol references with the hyp_symbol_addr macro. This is error
prone and developer unfriendly.

The series adds a new build-time step for nVHE hyp object file where
positions targeted by R_AARCH64_ABS64 relocations are enumerated and
the information stored in a separate ELF section in the kernel image.
At runtime, the kernel first relocates all absolute addresses to their
actual virtual offset (eg. for KASLR), and then addresses listed in this
section are converted to hyp VAs.

The RFC of this series did not have a build-time step and instead relied
on filtering dynamic relocations at runtime. That approach does not work
if the kernel is built with !CONFIG_RELOCATABLE, hence an always-present
set of relocation positions was added.

The series is based on 5.11-rc2 + kvmarm/next and structured as follows:
  * patches 1-2 make sure that all sections referred to by hyp code are
    handled by the hyp linker script and prefixed with .hyp so they can
    be identified by the build-time tool
  * patches 3-5 contain the actual changes to identify and relocate VAs
  * patches 6-7 fix existing code that assumes kernel VAs
  * patch 8 removes the (now redundant) hyp_symbol_addr

The series is also available at:
  https://android-kvm.googlesource.com/linux topic/hyp-reloc_v2

Changes since v1:
  * fix for older linkers: declare hyp section symbols in hyp-reloc.S
  * fix for older host glibc: define R_AARCH64_ constants if missing
  * add generated files to .gitignore

-David

David Brazdil (8):
  KVM: arm64: Rename .idmap.text in hyp linker script
  KVM: arm64: Set up .hyp.rodata ELF section
  KVM: arm64: Add symbol at the beginning of each hyp section
  KVM: arm64: Generate hyp relocation data
  KVM: arm64: Apply hyp relocations at runtime
  KVM: arm64: Fix constant-pool users in hyp
  KVM: arm64: Remove patching of fn pointers in hyp
  KVM: arm64: Remove hyp_symbol_addr

 arch/arm64/include/asm/hyp_image.h       |  29 +-
 arch/arm64/include/asm/kvm_asm.h         |  26 --
 arch/arm64/include/asm/kvm_mmu.h         |  61 +---
 arch/arm64/include/asm/sections.h        |   3 +-
 arch/arm64/kernel/image-vars.h           |   1 -
 arch/arm64/kernel/smp.c                  |   4 +-
 arch/arm64/kernel/vmlinux.lds.S          |  18 +-
 arch/arm64/kvm/arm.c                     |   7 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h  |   4 +-
 arch/arm64/kvm/hyp/nvhe/.gitignore       |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile         |  28 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c     | 413 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/host.S           |  29 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S       |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c       |  11 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S        |   9 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  24 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
 arch/arm64/kvm/va_layout.c               |  34 +-
 20 files changed, 578 insertions(+), 135 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c

--
2.29.2.729.g45daf8777d-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
