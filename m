Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2235C6FA82
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:52:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49AC94B269;
	Tue, 20 Sep 2022 23:52:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xDtMRXMP7gtC; Tue, 20 Sep 2022 23:52:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F094C4B77F;
	Tue, 20 Sep 2022 23:52:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94B864B62D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:52:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bojgv-iCUnzQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:52:54 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A1BC4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:52:54 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 n85-20020a254058000000b006b0148d96f7so4055622yba.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
 :date; bh=MzLSXN9659oMN46VAD3QaEqmFer6u1utIpA2UG+9EdQ=;
 b=teECItsEgFfiTvj51+jcO1iNDgFfQ1pKS0sNjOrJ004BNZAuTGOtdrc+2SXYPpQEOr
 1WGJ7RS4jjKQewkJMEdGDYCrhjHTEQkp0b9LaLRRapaVhmUbpOUvZpICfzSfIwCunJ4p
 0Q1DUx62655IPzl7V9K7RggL1J+64ahObLuOwj6qQzw1cmFo21eOzv095sOJ+7JiImre
 7XJpq78XYQ4vEYYXAl0QHFuYz97QeOt3GTnT6WqlBwIcNTet16bb1UwBhFLd8JBym/Ir
 T05UcoxEdMMBPXJYC7yvod1Ootxtooo4jVc47DQ7v0TSRG5wWa8MvcH0tTtI8yoA7YI3
 +mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc:subject:date;
 bh=MzLSXN9659oMN46VAD3QaEqmFer6u1utIpA2UG+9EdQ=;
 b=RR2Gv9vAfN+Sk4uR61SVeL6rB3/nWf7T7ddv2a0UIsN883UrmlFpf6djhSeI3/sGcB
 1BVmCR2T4lxPJJLX0E/bvkXMBysRkysUBHNbrJ1Ab4bNCTY2lQV+Y5sN2YFaD+qzZSCy
 yQTTGD2jgmgx0XOsvFBaH28+mu45OsX8Ox/Gmqs3vhwbf4WNdVVHWhgE+tsthXoYkWli
 W8eZTFuTobaSynJL/v5HPLg2wjNFpETPxUT6MUDUayCDSoTY7jwPd+FuvyHQlKgzdWVW
 61jholKx9yJ637Wji5J4acIfJam7MOp/tnmY72mT/uKV53cixUET++sopIck8ligPTAu
 NrfA==
X-Gm-Message-State: ACrzQf1AkoZ1WlhLDXj4XeJMww6TlnvcmzhWJ82CBFbUovtfL9cH1lv/
 5A/l8igwOczDAUPHE5Z06mhV+0o=
X-Google-Smtp-Source: AMsMyM6p1o6DZc1El2WX74JXWnrje6NxwPNf5KdOg0qnIgai24Z40ItJ6/xIIeE3xlynhFeSvJWE/Xs=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a81:910:0:b0:349:b5c1:4086 with SMTP id
 16-20020a810910000000b00349b5c14086mr22866786ywj.98.1663732373777; Tue, 20
 Sep 2022 20:52:53 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:32 -0700
Message-Id: <20220921035140.57513-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
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

I rebased Catalin's tree onto -next and added the proposed userspace
enablement patches after the series. I've tested it on QEMU as well as
on MTE-capable hardware by booting a Linux kernel and userspace under
a crosvm with MTE support [3].

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
 arch/arm64/kernel/mte.c           | 16 ++++----
 arch/arm64/kvm/guest.c            | 18 +++++----
 arch/arm64/kvm/mmu.c              | 55 +++++++++++---------------
 arch/arm64/mm/copypage.c          |  7 +++-
 arch/arm64/mm/fault.c             |  4 +-
 arch/arm64/mm/mteswap.c           | 13 ++++---
 fs/proc/page.c                    |  3 +-
 include/linux/kernel-page-flags.h |  1 +
 include/linux/page-flags.h        |  3 +-
 include/trace/events/mmflags.h    |  9 +++--
 mm/Kconfig                        |  8 ++++
 mm/huge_memory.c                  |  3 +-
 19 files changed, 152 insertions(+), 71 deletions(-)

-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
