Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6404BC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:50:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B444C83D;
	Thu, 21 Jul 2022 21:50:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vq2FTrYPdaCZ; Thu, 21 Jul 2022 21:50:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EA694C70C;
	Thu, 21 Jul 2022 21:50:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FBD04C6CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:50:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HkUvSgOa8STA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:50:54 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDD4D4C6C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:50:54 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 x8-20020a5b0948000000b006707a126318so2622961ybq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Rhs+4jBfg1QM5n7eWG2/LdEIc5IyIGfWAsCL7NyPRwQ=;
 b=EPu9cfSmX3DAmdVD3SXg5Chipd7twxc2aYzKZWGdt9qqZYcXxOhVbYsm2Q4w3Keblq
 iOOY371rfBqvXTY6NybNQWreMp53L+rUZ1LTcNZne4JJDGcvaPks3Ru8OFBCCz30Qmwx
 4WD270XRYhRv/GvT+dVV1awsfHaNxwtD37r68MFhp9ELCmrImgLiyWRhaKkWDXkBoZnH
 s78qnShu3Azqth50MftuCULbQDS0/sGtGm8g1LRAArzgephpOZ9rxfyCLFfTxD4ZvsHo
 W0x7N5i+Yoy5MqKgYCuj6TnY2HyvX9xkkG6z1rNzJUm68C/cjwlYxsZY/ACE2sHzBlDO
 jhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Rhs+4jBfg1QM5n7eWG2/LdEIc5IyIGfWAsCL7NyPRwQ=;
 b=3GeqjUzIUw85zcg2PPm4wWxTC2uTVrUaKa3FfZ0OLoG2/7zmg11/8V/XoX6mpdfTf2
 Q/EpSSY08tRDg6WnXb91Y0IFgNBbvc4cVNhTY5r+tUYhByzFNSz66DSeeHiHpHONvkkM
 7p7ejYVyAy4pTQuEQnpU6VNMtb1WYXeOhcNI5oWul/uTiR6L8XAOUF5Fl+FbdB5ppQJB
 ynSe6uDg7a8/eOodzYY6ZYuNmJDnrx/Rnb3tnZmTv2LS5+7/13aC/CCf9VTb4I82pbyQ
 SDOeeJAzcDayghoKXNTI23glf1NLvmAQgKW4GQBY8aR6NOx/SFLQfhmPZQ38jCjtwRSa
 Wa+Q==
X-Gm-Message-State: AJIora+q4M1zoFv9Y5rZ2OXP0gRJsqYkGKKL8K+WVb7x/sTJCHqPB33a
 4599XuPDeRTxjr25aLPSI1ddzqQ=
X-Google-Smtp-Source: AGRyM1s/pmWLb7/RVeSHgBd1PqQYRVoHVPsujzJ6L2UtPXkGfO1tJ3J+fcjlJoTgQYjpaF7llAnRI+U=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a5b:890:0:b0:670:8312:a52f with SMTP id
 e16-20020a5b0890000000b006708312a52fmr1197181ybq.139.1658454654329; Thu, 21
 Jul 2022 18:50:54 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:26 -0700
Message-Id: <20220722015034.809663-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 0/7] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
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

 Documentation/virt/kvm/api.rst   |  5 +--
 arch/arm64/include/asm/mte.h     | 62 ++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  3 +-
 arch/arm64/kernel/cpufeature.c   |  4 ++-
 arch/arm64/kernel/elfcore.c      |  2 +-
 arch/arm64/kernel/hibernate.c    |  2 +-
 arch/arm64/kernel/mte.c          | 17 +++++----
 arch/arm64/kvm/guest.c           | 18 ++++++----
 arch/arm64/kvm/mmu.c             | 55 ++++++++++++----------------
 arch/arm64/mm/copypage.c         |  6 ++--
 arch/arm64/mm/fault.c            |  4 ++-
 arch/arm64/mm/mteswap.c          |  5 ++-
 fs/proc/page.c                   |  1 +
 include/linux/page-flags.h       |  1 +
 include/trace/events/mmflags.h   |  7 ++--
 mm/huge_memory.c                 |  1 +
 16 files changed, 134 insertions(+), 59 deletions(-)

-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
