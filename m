Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBC0C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 19:30:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ED664DA6C;
	Wed, 10 Aug 2022 15:30:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cdI3xftnACxd; Wed, 10 Aug 2022 15:30:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351E04DA49;
	Wed, 10 Aug 2022 15:30:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49D9A4DA4B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:30:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ObqVkmzvw28i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 15:30:37 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDAC64DA3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:30:37 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-329dc6c0d21so63901107b3.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 12:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=1di/tt6ciXP+w3o/5q4XLldJe644DuKYm0Az9ViiC4I=;
 b=AzSz35DDsHcjaP6qfQYWUXAmnpUTMzrq+S9wxbQ6YASgGJtYseIgCVALZTXZLBBh6h
 TlI8UPji2eQtQQDx15SApQOZMsowyWhCJXr5ElbnZqyt+LK01lN5p+hCZ6qEoenAAIDz
 q+OnhuChs9jcmHZkPQdyMp8lm+MgdnNY2m71pkhUYIcfuKr48YUXdx3TUqzmK8aBLnTG
 iqfu++8u/0bPEgzUSjEbVUcXxEoKE4GQctSb/3U7n5tr/b8DgFKFKc2wjZV73qxA6Rq6
 wlU2R3O5jN/lb80Hp8mxAtDf00IzDPcteKaMzuTRhWBhqlsTMSGVlQPSz1iqW45o9U1e
 NxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=1di/tt6ciXP+w3o/5q4XLldJe644DuKYm0Az9ViiC4I=;
 b=yWgjsyjKvJ1cLgBHqTjutRdXekUvOqVBlyh6p3AjiY8qsrHOBLehdCvN+MjE7yHdwq
 tTSuSCbLeqNcARM6JjTnwFVhkKp8HCY0OcMSeQ6YRc+MRCgu4MPzqeHWboqteqihpDYf
 /Meru2/EI0I5IhV+R/BoBpmCRKSUu8//P2o3U83HrYyK4itQgKvH5pfnePXmUcBdGgLt
 XUH1BwrhcgJ8L2PQmS6Px/yniELFzHf4A7q4zPsNT/Qv78nNje+DB2kCtya8X5Pku9/f
 9fewJd/Rfsa6ZbWPYF4/kS+JA3qstrVj58hlcND0xWeLDdiEpYIYqf8chmqy2qrKUAvz
 Sn/w==
X-Gm-Message-State: ACgBeo2XHNwaisGvmtkXtoZ46eN5Qs+nWiV/EZdEX5Tt2RpeiYI7tVQ8
 /P5uU+mC0xhhrLlwXUhSiPBsQZk=
X-Google-Smtp-Source: AA6agR4MYoEAPEEGe/xF/Ddp+XkcPsty64vZpHzAiVCbe2OV1iXIkQhzrbTI7V5lKnz380bWoms/WIc=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a25:790d:0:b0:670:6032:b1df with SMTP id
 u13-20020a25790d000000b006706032b1dfmr25551772ybc.629.1660159837207; Wed, 10
 Aug 2022 12:30:37 -0700 (PDT)
Date: Wed, 10 Aug 2022 12:30:26 -0700
Message-Id: <20220810193033.1090251-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 0/7] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
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
guests. The first four patches are based on the series that Catalin sent
out, whose cover letter [1] I quote from below:

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

I rebased Catalin's series onto -next, addressed the issues that I
identified in the review and added the proposed userspace enablement
patches after the series.

[1] https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/

Catalin Marinas (3):
  arm64: mte: Fix/clarify the PG_mte_tagged semantics
  KVM: arm64: Simplify the sanitise_mte_tags() logic
  arm64: mte: Lock a page for MTE tag initialisation

Peter Collingbourne (4):
  mm: Add PG_arch_3 page flag
  KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
  KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
  Documentation: document the ABI changes for KVM_CAP_ARM_MTE

 Documentation/virt/kvm/api.rst    |  5 ++-
 arch/arm64/include/asm/mte.h      | 62 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h  |  3 +-
 arch/arm64/kernel/cpufeature.c    |  4 +-
 arch/arm64/kernel/elfcore.c       |  2 +-
 arch/arm64/kernel/hibernate.c     |  2 +-
 arch/arm64/kernel/mte.c           | 17 ++++++---
 arch/arm64/kvm/guest.c            | 18 +++++----
 arch/arm64/kvm/mmu.c              | 55 +++++++++++----------------
 arch/arm64/mm/copypage.c          |  6 ++-
 arch/arm64/mm/fault.c             |  4 +-
 arch/arm64/mm/mteswap.c           |  5 ++-
 fs/proc/page.c                    |  1 +
 include/linux/kernel-page-flags.h |  1 +
 include/linux/page-flags.h        |  1 +
 include/trace/events/mmflags.h    |  7 ++--
 mm/huge_memory.c                  |  1 +
 tools/vm/page-types.c             |  2 +
 18 files changed, 137 insertions(+), 59 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
