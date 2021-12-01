Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BD7C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F0D04B246;
	Wed,  1 Dec 2021 12:04:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H19PmdCWjD8v; Wed,  1 Dec 2021 12:04:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE97F4B218;
	Wed,  1 Dec 2021 12:04:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1404E4B218
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgig4nXuYL8O for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:14 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 861D44B204
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:14 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 v62-20020a1cac41000000b0033719a1a714so12560634wme.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=P0eoA0nXrvSw+mWn0Ku1VtemJtowvKfJvB6oV4i5/hM=;
 b=Xl37A5npQxuw9iiyYsc4FHymns/CW0PmG++NQLPuDeVsi4MmWz/bMPvvp4mEsPVUj0
 T0jk2qTSFZhs5wn6WsNHgExPEDxnS3PFMt0xMVVfjX6xVZ6zNvFLL/D9ezCdbQEeLeQ4
 iphGPGU87rab27S/flnkUEKsapS1ZvK6BWoUZB8yB+OU+yrxbo+XLBFZc9dT3q/kaigZ
 tsiewXdcXd+CvHl/gELBfFBSdy8pF/zUDCyH2fW+3ss38xN1TLPrqeP4TpgNNGn4ii4E
 sLtTwube/pL8RqZ17DEUDza6tDL3ZxyExPjvLMo5O8P+nB4spC7CGhTvv8sUGWFSHB9g
 a3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=P0eoA0nXrvSw+mWn0Ku1VtemJtowvKfJvB6oV4i5/hM=;
 b=wfRQoCooyY06++M0nTe7riRna2CG6LCWiMglbzxAybr+3BvVhF8DLwomwDWnJp/EYG
 ysDH7bKyumCLS022K5k4UV9+q5q9yu3jwAFr1jDLjQpnY1F8jjUCFCWtvkMEsm919rDk
 zUfe7QKxDHJAbSF7mgCqu3/Mu+wtTR8p0GuuiGqQEtVUoSzfTuK9tgCTjc9vsU2RJBXm
 B6FKq3Sw16PTZkXpUYs9sUHlUI5pk1QU1XT778dVkrjSaeIoixxTIt9dH9jjvS3XFzwx
 KEZ/ABK8c0yCjf/DFpWKImpCKw9Z+dbrAPmZhZb7EjYiJGog8wTnGm0DF+0SWzD+PErD
 2ZbQ==
X-Gm-Message-State: AOAM532+kxPmXGDZVS24QO3ADguoylfp19F9dgxHldd+qFwioZ5GVKy7
 Oi3QWMqF9NzU4XzPEOIcWa3Y3kuCtVha
X-Google-Smtp-Source: ABdhPJztEwjdKWN8+cpw0aKB6OPpL4Crx4EBMVVRzlRSso7hTLSF84evAIJ4EJbP5/t3h2pgTg90YOQYsg6U
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:600c:154f:: with SMTP id
 f15mr8485753wmg.86.1638378253327; Wed, 01 Dec 2021 09:04:13 -0800 (PST)
Date: Wed,  1 Dec 2021 17:03:54 +0000
Message-Id: <20211201170411.1561936-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 00/15] KVM: arm64: Introduce kvm_share_hyp()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

This is v3 of the series previously posted here:

  https://lore.kernel.org/kvmarm/20211019121304.2732332-1-qperret@google.com/

This series implements an unshare hypercall at EL2 in nVHE protected
mode, and makes use of it to unmmap guest-specific data-structures from
EL2 stage-1 during guest tear-down. Crucially, the implementation of the
share and unshare routines use page refcounts in the host kernel to
avoid accidentally unmapping data-structures that overlap a common page.

This series has two main benefits. Firstly it allows EL2 to track the
state of shared pages cleanly, as they can now transition from SHARED
back to OWNED. This will simplify permission checks once e.g. pkvm
implements a donation hcall to provide memory to protected guests, as
there should then be no reason for the host to donate a page that is
currently marked shared. And secondly, it avoids having dangling
mappings in the hypervisor's stage-1, which should be a good idea from
a security perspective as the hypervisor is obviously running with
elevated privileges. And perhaps worth noting is that this also
refactors the EL2 page-tracking checks in a more scalable way, which
should allow to implement other memory transitions (host donating memory
to a guest, a guest sharing back with the host, ...) much more easily in
the future.

Changes since v2:

 - Added a check in kvm_share_hyp() to prevent sharing vmalloc pages;

 - Rebased on kvmarm/next, which contains Marc's rework of FPSIMD/SVE
   tracking [1].

Thanks!
Quentin

[1] https://lore.kernel.org/kvmarm/20211201120436.389756-1-maz@kernel.org/

Quentin Perret (7):
  KVM: arm64: Check if running in VHE from kvm_host_owns_hyp_mappings()
  KVM: arm64: Provide {get,put}_page() stubs for early hyp allocator
  KVM: arm64: Refcount hyp stage-1 pgtable pages
  KVM: arm64: Fixup hyp stage-1 refcount
  KVM: arm64: Introduce kvm_share_hyp()
  KVM: arm64: pkvm: Refcount the pages shared with EL2
  KVM: arm64: pkvm: Unshare guest structs during teardown

Will Deacon (8):
  KVM: arm64: Hook up ->page_count() for hypervisor stage-1 page-table
  KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2
  KVM: arm64: Extend pkvm_page_state enumeration to handle absent pages
  KVM: arm64: Introduce wrappers for host and hyp spin lock accessors
  KVM: arm64: Implement do_share() helper for sharing memory
  KVM: arm64: Implement __pkvm_host_share_hyp() using do_share()
  KVM: arm64: Implement do_unshare() helper for unsharing memory
  KVM: arm64: Expose unshare hypercall to the host

 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_mmu.h              |   2 +
 arch/arm64/include/asm/kvm_pgtable.h          |  21 +
 arch/arm64/kvm/arm.c                          |   6 +-
 arch/arm64/kvm/fpsimd.c                       |  36 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   6 +
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 500 +++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/setup.c               |  22 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  80 ++-
 arch/arm64/kvm/mmu.c                          | 140 ++++-
 arch/arm64/kvm/reset.c                        |  10 +-
 14 files changed, 737 insertions(+), 102 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
