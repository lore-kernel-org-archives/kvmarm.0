Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC347C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C71F61360
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C71F61360
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFF654B14D;
	Tue, 19 Oct 2021 08:13:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9nau21Hr-TF5; Tue, 19 Oct 2021 08:13:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F714B10A;
	Tue, 19 Oct 2021 08:13:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5544B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QdzR-ZCcLABE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:07 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2DBD4AC78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:07 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 k2-20020adfc702000000b0016006b2da9bso10082499wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Fy4DNJg+LJGIWoeCxYMWIL1CKlINKgnhRdgDVyd1Xho=;
 b=Nr4MJ1aI7q7w3UdTcVj6uCTcnUI7GEUmwq2F1i25CsIrzLEbTiVmLCgtKGbFFMtnzj
 A0IEcU+/iuEOzhIOixBDn/V6QiT02j8f644HbyG4nVN8ml3f/EdohG6B0Dxq5D0IpiLB
 q8LciAgHkLAV2t3dEYif+bOwdQrTAo0WQ0FPesXnFw1naWLXxBXnVxty6DMhm498g5lv
 4lIDI0hW+WNGf3nm+DqiXlCC7heRmA/GZGmIlGDurd93+jhzyplTOVv/oiHJZz5ZzJso
 vpDCREebQW3sMC78QseUu6Z6tLs7JutRKfuaPJ69qU40glehGG/wmTOkqSjBra3jh4+l
 PgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Fy4DNJg+LJGIWoeCxYMWIL1CKlINKgnhRdgDVyd1Xho=;
 b=k6pf9eJ3gr7h5A5l4viS6ivdF38PwROXv41RRX0isEn7Rqy8Lmz7efw4mLvAnUTPeB
 h9LX9ydOZbFCR3EqucAe5aV5VxJNsYWv+BOrHO/+vb3Zr1sZ7ng7Fv4T8ou2sp2IsU/Q
 hRt8y67oLOWV7NTIFgrABz+/BUBymi4vM6rOpzYFfr+N/HmHGJWpSgDOwvl0wAfVJi5r
 LRbMCTIxew5lm4FqhqKrUc4p5njzCPv1bT/4oUlVwJJ2keTKe8ULgGQZUnv8fZCVRCa/
 2EZyNZ+XD+G8sLAT9Wtuv3Nh/AhIfj1ezRIq6Q0MZ9/6Qp5SuUaAcKECB46ftkAK0Et+
 ermQ==
X-Gm-Message-State: AOAM532IuldZgXgPiG5uRwEzXBMTWUBftSFS3pRtBlohuINJVxwg1LDm
 FVnja8Gyqe9hp3eLjTP+XM9PYNVBXtBX
X-Google-Smtp-Source: ABdhPJyrcmjf8nedcASO5PXz/po0MxrFVu8ZXOjfZXlzQFBuQrME6M29/wyaWdnny2GWZzG1UFy/1PGuR63M
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a05:600c:3b88:: with SMTP id
 n8mr5585459wms.93.1634645586407; Tue, 19 Oct 2021 05:13:06 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:49 +0100
Message-Id: <20211019121304.2732332-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 00/15] KVM: arm64: pkvm: Implement unshare hypercall
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
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

This is v2 of the series previously posted here:

  https://lore.kernel.org/kvmarm/20211013155831.943476-1-qperret@google.com/

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

 - moved the refcounting of pages shared more than once to the host in
   order to simplify and optimize the hyp code;

 - synchronized lifetime of the vcpu and its parent task struct using
   get_task_struct() / put_task_struct();

 - rebased on kvmarm/next

 - rebased on Marc's v2 refactoring of the first vcpu run:
   https://lore.kernel.org/kvmarm/20211018211158.3050779-1-maz@kernel.org

 - small improvements/refactoring throughout;

This has been lightly tested on Qemu, by spawning and powering off a
guest 50 times. You can find a branch with everything applied here:

  https://android-kvm.googlesource.com/linux qperret/hyp-unshare-v2

Thanks!
Quentin


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
 arch/arm64/kvm/fpsimd.c                       |  33 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   6 +
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 500 +++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/setup.c               |  32 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  80 ++-
 arch/arm64/kvm/mmu.c                          | 132 ++++-
 arch/arm64/kvm/reset.c                        |  10 +-
 14 files changed, 733 insertions(+), 105 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
