Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCF5C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC9948F99;
	Thu,  3 Nov 2022 21:11:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0QB9xsINRdG2; Thu,  3 Nov 2022 21:11:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4121B4107F;
	Thu,  3 Nov 2022 21:11:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E2141070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDDk58HeBjF9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:00 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B904340FF0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:00 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 186-20020a6301c3000000b0046fa202f720so1710088pgb.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=MD4sMsdZ3Kj9lzVMKTpZ1mSgffrTJwexAbptSvbOBTs=;
 b=KAGDbvUBGRMCwSDrAXBTfRWpNauve+o6eufOssRdV8+ifYozwSybHg4nY9bJPm/KDt
 74XyI+eiTBQmG0nE2ysra4jkAYePQx4ZoS8wiT1TlV0xL01s8tqKePoWJk4W9r4Yo9nx
 Hn1hv2IdqZci+4cKUeAd+aRYtmRQ2qD9wSzI5+/pegF3BAxcWRWNNZcOMs2p+X4Lj36y
 Q6DEOEddA5LiwkUhytRm9r5yvfo8ERcuJtlFm3bNCGkJXMcL5pfFdvTr5U40J8iwDMu/
 Cyve//FTWDMlncsRKNKr4OxEqSFf1F4uq/IHjwwII/bX4GiFocJYFLcWJiDfp1W1Poih
 DyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=MD4sMsdZ3Kj9lzVMKTpZ1mSgffrTJwexAbptSvbOBTs=;
 b=cvcWvJcMxEBSPRqskb8otU+DyWSdbTCD0s7d2Pii5asWwC0Ir2R7CIULvatUtfioMm
 7Phs7oCts9QDl0Oj16a+zuD8GFtU5WCbIEAy/MA59+pzHF3b1ZZKBxE1DReBROD4/EHY
 CHsEeusr3oo3HmMZrKdyuznya7tKqqwloLahr5Q7Ra8EhuSRIzhBh2dVzoP4Mjs4ccwv
 RaTte249IcdAj0dDFlILvU2HVmNMMWAstUEKsVRrEiz0Rx6aSB7SBzi27gwZVTKJauuy
 SxDuC/yHx7btzKON2ZJ5oczDttjcntpya8xnq6MJYwT8YJEyR1d+5aGFpK/QNcMGCOdR
 PXUQ==
X-Gm-Message-State: ACrzQf353/bAVpG7BBeSZUMZwKYwWjWo8RNNj4v4q48okxSq3bIq3Gsf
 q3mu6RRFkG6Sa1T5epSmhqQLr5M=
X-Google-Smtp-Source: AMsMyM41C+IFtgA5t1c+69xBTRkwpvyPxjIzeGnprwRfU+qsGdt/Bl29bDMEYWzWzr8sDSkH76xhnvA=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a17:90a:1287:b0:20a:f469:7307 with SMTP id
 g7-20020a17090a128700b0020af4697307mr220586pja.213.1667524259464; Thu, 03 Nov
 2022 18:10:59 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:33 -0700
Message-Id: <20221104011041.290951-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Hi,

This patch series allows VMMs to use shared mappings in MTE enabled
guests. The first five patches were taken from Catalin's tree [1] which
addressed some review feedback from when they were previously sent out
as v3 of this series. The first patch from Catalin's tree makes room
for an additional PG_arch_3 flag by making the newer PG_arch_* flags
arch-dependent. The next four patches are based on a series that
Catalin sent out prior to v3, whose cover letter [2] I quote from below:

> This series aims to fix the races between initialising the tags on a
> page and setting the PG_mte_tagged flag. Currently the flag is set
> either before or after that tag initialisation and this can lead to CoW
> copying stale tags. The first patch moves the flag setting after the
> tags have been initialised, solving the CoW issue. However, concurrent
> mprotect() on a shared mapping may (very rarely) lead to valid tags
> being zeroed.
>
> The second skips the sanitise_mte_tags() call in kvm_set_spte_gfn(),
> deferring it to user_mem_abort(). The outcome is that no
> sanitise_mte_tags() can be simplified to skip the pfn_to_online_page()
> check and only rely on VM_MTE_ALLOWED vma flag that can be checked in
> user_mem_abort().
>
> The third and fourth patches use PG_arch_3 as a lock for page tagging,
> based on Peter Collingbourne's idea of a two-bit lock.
>
> I think the first patch can be queued but the rest needs some in depth
> review and test. With this series (if correct) we could allos MAP_SHARED
> on KVM guest memory but this is to be discussed separately as there are
> some KVM ABI implications.

In this v5 I rebased Catalin's tree onto -next again. Please double check
my rebase, which resolved the conflict with commit a8e5e5146ad0 ("arm64:
mte: Avoid setting PG_mte_tagged if no tags cleared or restored").

I now have Reviewed-by for all patches except for the last one, which adds
the documentation. Thanks for the reviews so far, and please take a look!

I've tested it on QEMU as well as on MTE-capable hardware by booting a
Linux kernel and userspace under a crosvm with MTE support [3].

[1] git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux devel/mte-pg-flags
[2] https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/
[3] https://chromium-review.googlesource.com/c/crosvm/crosvm/+/3892141

Catalin Marinas (4):
  mm: Do not enable PG_arch_2 for all 64-bit architectures
  arm64: mte: Fix/clarify the PG_mte_tagged semantics
  KVM: arm64: Simplify the sanitise_mte_tags() logic
  arm64: mte: Lock a page for MTE tag initialisation

Peter Collingbourne (4):
  mm: Add PG_arch_3 page flag
  KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
  KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
  Documentation: document the ABI changes for KVM_CAP_ARM_MTE

 Documentation/virt/kvm/api.rst    |  5 ++-
 arch/arm64/Kconfig                |  1 +
 arch/arm64/include/asm/mte.h      | 65 ++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/pgtable.h  |  4 +-
 arch/arm64/kernel/cpufeature.c    |  4 +-
 arch/arm64/kernel/elfcore.c       |  2 +-
 arch/arm64/kernel/hibernate.c     |  2 +-
 arch/arm64/kernel/mte.c           | 21 +++++-----
 arch/arm64/kvm/guest.c            | 18 +++++----
 arch/arm64/kvm/mmu.c              | 55 +++++++++++---------------
 arch/arm64/mm/copypage.c          |  7 +++-
 arch/arm64/mm/fault.c             |  4 +-
 arch/arm64/mm/mteswap.c           | 16 +++-----
 fs/proc/page.c                    |  3 +-
 include/linux/kernel-page-flags.h |  1 +
 include/linux/page-flags.h        |  3 +-
 include/trace/events/mmflags.h    |  9 +++--
 mm/Kconfig                        |  8 ++++
 mm/huge_memory.c                  |  3 +-
 19 files changed, 152 insertions(+), 79 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
