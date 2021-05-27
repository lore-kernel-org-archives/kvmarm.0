Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CC7C4707F
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27C59613CA
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27C59613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9021D4A1A7;
	Thu, 27 May 2021 08:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F8T1f6IfmS7I; Thu, 27 May 2021 08:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C6FD4A19B;
	Thu, 27 May 2021 08:51:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D84C4A023
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5AeglxVw4G0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 08:51:38 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1BF440808
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:37 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 r15-20020a05600c35cfb029017cc4b1e9faso1448689wmq.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 05:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=OFJTCYvTlm44Js7Oh0x+dWK8ho65pfFD2cK8memDcmU=;
 b=QB0AuKgJ00Z+R2vn+s/ZmfmnVBgsEKhuVuQ5GcbOcE0XrgCVuJ6+3mvy4BAzFdXFy2
 1X1e/i9+3FlsRBqEHHm0KtN9SrVPvMu+S2ddDDgER5HsSXUzyEaApDT28GZ26LYc4kLD
 p1S/TVyiTqbLFEKpoN51NO4vJcLb9llEHm1hPXEenjscHufgWUjbLPFWPcVnOrMennnS
 LytX8aVgRwM9l/sQBgnwFzTnBYXKyxIAHjwuyyXS+ZFRIXPHSsnDThBI97VtcTWM2C3e
 MvvORRmCCYIza9KQ6XEe0MOeu9OEXlC/ONYqaxNATER10dOwNAT4jwSKlvDUKeh5IBQO
 +rDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=OFJTCYvTlm44Js7Oh0x+dWK8ho65pfFD2cK8memDcmU=;
 b=Ksday17KBUKtySp+bg2Zulbvh0vnYt2P/8KU1S8+9Z0K/dN0+o+F4F6J+IcHPe/+gW
 qe5tpyUrFASUOp67fKAc8fGTvkdUuuk0MJHk7EfUmPjVWUDv4wzdKyn0my1LfGSH9jwl
 Zhz7ShP1AucTF8Chdf3jsDFEohwM14aQT/XRm2l6uM0rqEuScybNVbH9BUjB67dFEH1M
 16QZtdTpkEltBJBCslu3OuxMUXrmA5lR6m+JFXW9b66mNQUZg0kJvNs+PLRpHDwxOefB
 QXoB4JkP2TF05BLGe4YOa4ueYrXD0Fv8ka6/TTeCsgM4TltTA6Fpl9e8kb75E/D2JAME
 KAAw==
X-Gm-Message-State: AOAM531jOe82niNHu2kCp0za3ITyKmmpUYszU4p8v6Y9pz+tK3usv3M2
 1J3wAmvGIj5If+7LntIZ9QxVVHgUrelO
X-Google-Smtp-Source: ABdhPJyAac0auDLnAIfnc5GbbqU7TodPnilNsvhasp1h2deq/n8uFLQy6e5SlSjZZmZ6iix6pWbwR7ycCt06
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:35cc:: with SMTP id
 r12mr1310535wmq.1.1622119896122; Thu, 27 May 2021 05:51:36 -0700 (PDT)
Date: Thu, 27 May 2021 12:51:27 +0000
Message-Id: <20210527125134.2116404-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 0/7] KVM: arm64: Reduce hyp_vmemmap overhead
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

When running in nVHE protected mode, the hypervisor manages its own
vmemmap and uses it to store page metadata, e.g. refcounts. This series
shrinks the size of struct hyp_page from 32 bytes to 4 bytes without
loss of functionality, hence reducing the cost of the hyp vmemmap from
8MB/GB to 1MB/GB with 4K pages.

The series has two immediate benefits:
  - the memory overhead of the nVHE protected mode is reduced;
  - it refactors the host stage-2 memory pools in a way that allows
    better re-use of pages to map MMIO ranges, allowing more MMIO
    mappings (currently limited to 1GB IPA space) most of the time.

But more importantly, the series reduces the hyp vmemmap overhead enough
that we might consider covering _all_ of memory with it at EL2 in the
future. This would simplify significantly the dynamic admission of
memory into the EL2 allocator, which will be required when the
hypervisor will allocate stage-2 page-tables of guests for instance.
This would also allow the hypervisor to refcount pages it doesn't 'own',
which be useful to track shared pages and such.

The series is split as follows
  - patches 01-03 move the list_head of each page from struct hyp_page
    to the page itself -- the pages are attached to the free lists only
    when they are free by definition;
  - patches 04-05 remove the hyp_pool pointer from struct hyp_page as
    that information can be inferred from the context;
  - patches 06-07 reduce the size of the remaining members of struct
    hyp_page which are currently oversized for the needs of the
    hypervisor.

On a last note, I believe we could actually make hyp_page fit in 16bits
when using 4K pages: limiting the MAX_ORDER to 7 should suffice and
require only 3 bits, and 13bits should be enough for the refcount for
the existing use-cases. I decided not to implement this as we probably
want to keep some room to grow in hyp_page (e.g. add flags, ...), that
might cause issues to make refcounts atomic, and 16bits are not enough
with 64K pages so we'd have to deal with that separately, but that _is_
a possibility.

Thanks!
Quentin

Quentin Perret (7):
  KVM: arm64: Move hyp_pool locking out of refcount helpers
  KVM: arm64: Use refcount at hyp to check page availability
  KVM: arm64: Remove list_head from hyp_page
  KVM: arm64: Unify MMIO and mem host stage-2 pools
  KVM: arm64: Remove hyp_pool pointer from struct hyp_page
  KVM: arm64: Use less bits for hyp_page order
  KVM: arm64: Use less bits for hyp_page refcount

 arch/arm64/kvm/hyp/include/nvhe/gfp.h         | 33 ++-----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  7 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          | 13 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 59 +++++++------
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 87 ++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/setup.c               | 30 ++++---
 arch/arm64/kvm/hyp/reserved_mem.c             |  3 +-
 8 files changed, 123 insertions(+), 111 deletions(-)

-- 
2.31.1.818.g46aad6cb9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
