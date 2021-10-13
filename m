Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC1FC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C948611B0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C948611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CABD24B120;
	Wed, 13 Oct 2021 11:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UbNlEHpfCGVA; Wed, 13 Oct 2021 11:58:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BFE4B108;
	Wed, 13 Oct 2021 11:58:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92BA14B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mifkMcvwVjM3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:35 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 737CE4B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:35 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 l8-20020a5d6d88000000b001611b5de796so2356624wrs.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Eht9NEYnyeNXZ9GC0V0N+PJToFUkivNq3A15CtLZoHQ=;
 b=MmrT+s8muELqT2L44AG8+lk0AywU/F2urJDOsAWd0K9der7aYqNb7QeEmpJr61jjDJ
 ktPaVPfr9Um/DkE+sBzpnuPozNyp6CQ+MtznYTvTt4wDgqSdOkw9M3DVjAPywJYCv8V/
 zflAJefyFMKPyYkjOQMiINYeddoxDo7z6hdWUMN0HOvwQHdW00FFAeG+92esLUP8C1E+
 zneGPi2fokr5vos/ibfeJwBKG8GSSV9xYqTD3faz8aL7hRURTFEOjeGJufrj7gWmhW2u
 pYfTxgeNY741mtX6j+fZtTb7vRXRx4KkLWMdK5IbhZnKd9AIAIS/+TedR6F/JZd1rqzO
 v0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Eht9NEYnyeNXZ9GC0V0N+PJToFUkivNq3A15CtLZoHQ=;
 b=v2wZMPlJzNK31ZFOOSTeRdNKLMz/pAASRe8Ea7wCT+miKQmEi2ZU8tuzrU+Q6yg/V6
 DGwgm12xcBr+4e9ePIbzT0qamgIILL2qQ+2D5KIOvlSBhTzqqCIn72TVVafSohmyxzyR
 o1dA6PzmViGLkFo7lEMHckl5s9BJLlw3JVDE+jDqwFmZs6quBb9XSpoZ2WCRPbLxTNTR
 GjkLN20GQqko0pAwo5BPJQHx2WCGgOjZOfSHlbMsQAzSJCwrMr9RWQ46XbE6dxMq7Zkm
 8ST/RlOAovS4wH25IJUtToFqg7fSq8zrJQ0fwM4Sy4+W06jCtylOFM/Rfra22eW9h3L8
 dVAQ==
X-Gm-Message-State: AOAM5319k8Ztn99OHEdhY0pc4HOHhduAeu1yWh9a/ickqlTWXnF0ana5
 oCwoeRUxB5gZoWpq3Fw/sWLudEeDXbA2
X-Google-Smtp-Source: ABdhPJwUVK1oAUnrbwA0NBbH6MgXKCoPORRCUhS/cSQ3NHCwSOfsKuOk9OgrZX4VXp9Bg29A4CFrD6RFznFb
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:600c:1c05:: with SMTP id
 j5mr141830wms.1.1634140714059; Wed, 13 Oct 2021 08:58:34 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:15 +0100
Message-Id: <20211013155831.943476-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 00/16] KVM: arm64: Implement unshare hypercall for pkvm
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
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

This series implements an unshare hypercall at EL2 in nVHE protected
mode, and makes use of it to unmmap guest-specific data-structures from
EL2 stage-1 during guest tear-down. Crucially, the implementation of the
share and unshare hypercall implements page refcounts at EL2 to avoid
accidentally unmapping data-structures that overlap a common page.

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

The series is organized as follows:

 - patches 01-05 refactor the implementation of the existing share
   hypercall;

 - patches 06-10 introduce infrastructure to allow unmapping pages from
   EL2 stage-1;

 - patches 11-14 allow to refcount pages that are shared more than once
   with EL2;

 - patches 15-16 add the unshare hypercall, and make use of it when
   tearing down guests.

This has been lightly tested on Qemu, by spawning and powering off a
guest 50 times.

Feedback welcome :) !

Thanks,
Quentin

Quentin Perret (11):
  KVM: arm64: Avoid remapping the SVE state in the hyp stage-1
  KVM: arm64: Introduce kvm_share_hyp()
  KVM: arm64: Accept page ranges in pkvm share hypercall
  KVM: arm64: Provide {get,put}_page() stubs for early hyp allocator
  KVM: arm64: Refcount hyp stage-1 pgtable pages
  KVM: arm64: Fixup hyp stage-1 refcount
  KVM: arm64: Back hyp_vmemmap for all of memory
  KVM: arm64: Move hyp refcount helpers to header files
  KVM: arm64: Refcount shared pages at EL2
  KVM: arm64: pkvm: Introduce an unshare hypercall
  KVM: arm64: pkvm: Unshare guest structs during teardown

Will Deacon (5):
  KVM: arm64: Introduce do_share() helper for memory sharing between
    components
  KVM: arm64: Implement __pkvm_host_share_hyp() using do_share()
  KVM: arm64: Hook up ->page_count() for hypervisor stage-1 page-table
  KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2
  KVM: arm64: Move double-sharing logic into hyp-specific function

 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_mmu.h              |   2 +
 arch/arm64/include/asm/kvm_pgtable.h          |  21 +
 arch/arm64/kvm/arm.c                          |  17 +-
 arch/arm64/kvm/fpsimd.c                       |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  18 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  29 +-
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  12 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 596 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  31 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  22 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  39 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  80 ++-
 arch/arm64/kvm/hyp/reserved_mem.c             |  17 +-
 arch/arm64/kvm/mmu.c                          |  48 +-
 arch/arm64/kvm/reset.c                        |  13 +-
 19 files changed, 814 insertions(+), 172 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
