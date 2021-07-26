Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C656C4320A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B5C360F4D
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B5C360F4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FFD94A49C;
	Mon, 26 Jul 2021 05:29:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gJgDoAbo9Scz; Mon, 26 Jul 2021 05:29:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A08E4A19B;
	Mon, 26 Jul 2021 05:29:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A52149E5F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t9efON1WBplP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:12 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3353F49DE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:12 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id
 w17-20020a50fa910000b02903a66550f6f4so3180421edr.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=DCvP66qXTBgcdbjyYQwVaIHGbmeDnGwgmndjPCUFZv0=;
 b=LszyL0ac2kAjWuiZPWogQnvnhJe8WWxuAssQ2tOcCSO63Y+EpNy9srxlU7ETxbVzrL
 jsonb/tmICqfScnrKqzEL/v8OaT5iihwGykqbQrXqhuDK/KoyT05kQEkJ4gfuxm8uT7j
 /wrabJ7Jxqvl6MMAKROuFiCwv0wFJ9occQnnfhptzoDPo+r+B3Y5kM3YnLjY0QwHyqus
 o0xsGG19XNfNfD/0CnhjCwgUkyr+o9ob7e79XzMQazCTd9XpcKWiFBxx+h40mnAvon9b
 I+bghqZiBtUczZE4qs3TIgu+PJWesXlNkAl4m+wsv+rpDdItgjfW8vt2g4EwKpuOEHXU
 G3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=DCvP66qXTBgcdbjyYQwVaIHGbmeDnGwgmndjPCUFZv0=;
 b=LXX5bOYMwOYK63kROkBuT2sJF7oDCYdao6Q/4wT30+6wJ/8YA1BUnFM3fivheOUTcC
 XyFMB8dRi4eCSi3QetqOng9DUOm0a0JXpook4eYCIc5h638y4p31SdzzT7cw4YZY3HZ5
 c8qiG/mLf3V1WNFZiHQI63SdoOhQlky4UnhA4Cgz1Z9SuAkswJ1Rdaa+X492pgqc5Eyo
 IqDWzqX7es2VHK5h7T9jJo8nXH9WqShwXrOEXTxJ8gg69fGQGophSCzRo1KmTyml/QX/
 TntcunSDIA4fh4iXx1B527YGDN8QrvJE3smAL/QSynvW4U62yYlqPIyigR/c1zy2XwQt
 NCiQ==
X-Gm-Message-State: AOAM531qKIKmGjPbI1cf/CsPSVNQ8EWDRe2/U7OUQhn+M82rDsSVF13X
 NswrTlVNP4ACqhq98H3efxcQsHN7oVfP
X-Google-Smtp-Source: ABdhPJzYf6PYxoyOLxQsDMRWgbQljCu/i20aLfGHMDpPArbaJdKVDGYqVf1Kcrk75PpRPPEhGP1AhJYC5bQR
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a17:906:b89a:: with SMTP id
 hb26mr16162211ejb.492.1627291750860; Mon, 26 Jul 2021 02:29:10 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:49 +0100
Message-Id: <20210726092905.2198501-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 00/16] Track shared pages at EL2 in protected mode
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

This is v2 of the patch series first posted here:

https://lore.kernel.org/kvmarm/20210719104735.3681732-1-qperret@google.com/

This series aims to improve how the nVHE hypervisor tracks ownership of
memory pages when running in protected mode ("kvm-arm.mode=protected" on
the kernel command line).

The main issue with the existing ownership tracking code is that it is
completely binary: a page is either owned by an entity (e.g. the host)
or not. However, we'll need something smarter to track shared pages, as
is needed for virtio, or even just host/hypervisor communications.

This series introduces a few changes to the kvm page-table library to
allow annotating shared pages in ignored bits (a.k.a. software bits) of
leaf entries, and makes use of that infrastructure to track all pages
that are shared between the host and the hypervisor. We will obviously
want to apply the same treatment to guest stage-2 page-tables, but that
is not really possible to do until EL2 manages them directly, so I'll
keep that for another series.

The series is based on the latest kvmarm/fixes branch, and has been
tested on AML-S905X-CC (Le Potato) and using various Qemu configurations.

Changes since v1:
 - Changed the 'share' hypercall to accept a single page at a time;
 - Dropped the patch allowing to continue stage-2 map when hitting the
   EAGAIN case;
 - Dropped some of the custom pgtable walkers and used Marc's get_leaf()
   patch instead;
 - Changed pgtable API to manipulate SW bits directly rather than
   specifying shared pages;
 - Added comments and documentations all over;
 - Cleanups and small refactoring.

Thanks,
Quentin

Marc Zyngier (1):
  KVM: arm64: Introduce helper to retrieve a PTE and its level

Quentin Perret (15):
  KVM: arm64: Provide the host_stage2_try() helper macro
  KVM: arm64: Expose page-table helpers
  KVM: arm64: Optimize host memory aborts
  KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
  KVM: arm64: Don't overwrite software bits with owner id
  KVM: arm64: Tolerate re-creating hyp mappings to set software bits
  KVM: arm64: Enable forcing page-level stage-2 mappings
  KVM: arm64: Allow populating software bits
  KVM: arm64: Add helpers to tag shared pages in SW bits
  KVM: arm64: Introduce and export host_stage2_idmap_locked()
  KVM: arm64: Mark host bss and rodata section as shared
  KVM: arm64: Enable retrieving protections attributes of PTEs
  KVM: arm64: Refactor protected nVHE stage-1 locking
  KVM: arm64: Restrict EL2 stage-1 changes in protected mode
  KVM: arm64: Make __pkvm_create_mappings static

 arch/arm64/include/asm/kvm_asm.h              |   2 +-
 arch/arm64/include/asm/kvm_pgtable.h          | 153 ++++++++----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  29 +++
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 188 ++++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  21 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  52 +++-
 arch/arm64/kvm/hyp/pgtable.c                  | 234 ++++++++++--------
 arch/arm64/kvm/mmu.c                          |  28 ++-
 10 files changed, 525 insertions(+), 196 deletions(-)

-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
