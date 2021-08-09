Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0800C4320A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:24:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44439610CF
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:24:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44439610CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B39B34B0F4;
	Mon,  9 Aug 2021 11:24:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JpBJyxL-DSJE; Mon,  9 Aug 2021 11:24:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA544B0E9;
	Mon,  9 Aug 2021 11:24:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F434A1A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nv0c91c+9BRS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:24:51 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29C4E4A19B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:24:51 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 v15-20020a0ccd8f0000b0290335f005a486so12506788qvm.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=sfgr1+pjxwO+6iSgebnByF44WjX6kRSHecCaxtQePZ0=;
 b=Xh2kqkwkFE567i2M7PGURzIq6o67p8a8DB6yI8XjMIyueExrM+HKhm+ixlYuCiVWS/
 EumxnwJJ+g6k52kHwJSRi+VRe6hnJ51TCPU7OQLFo+5aXOPS/h1+UCPmuSAJc1DcChA0
 hnQ+ceBk6rBjPvn0djNQajEUDYdAOJhL/4Xirk9E1Zr8Vg9l8k/pStrff+kUD0j9v8RV
 L9VTtxPPs+LjlDVNV+Ekprs4s0YgyKPI9LoUFNWX8OyDWFOuchS1Ej6/W8jQb5nRLyb3
 TdyUD9f77ySFL74U9yk+ZiE7V3wkNqY9pf9OmTyXLY4EYH2biilgza9uDl/nXIhhz8W4
 CpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=sfgr1+pjxwO+6iSgebnByF44WjX6kRSHecCaxtQePZ0=;
 b=LtBxKuIVlUZISPgsJ7Vxsq9lMtQ1PliY5dyRWZN60hPod0Bob1kTBoE+MQ13zmlqMa
 XOLDvPwncdezAVKQHDpBilOfBbFuKwBDWy/HjSrqNa75148cjJjneaXN3vsLNtdXGomg
 eIXuesVi9ihyfgieAcJOmECcPPxBEOr2dRQ+b6zI95RXzAfeeOOvjsdkA9iKsPoVcZFB
 5luo/IcdS9peMeL/eI9M29xNsENsMK5oUY/YM0OIgB4N+JYGq/0/bKVnW3A+qk5goLlr
 PH1BusXp7bg7SEGe48eRclGC16W3Ryutg0l9MfZfaVU763TY/lDOmcygmCXIwju/ZBuO
 z9zg==
X-Gm-Message-State: AOAM530dH9mg5WZvUI+or4nbHRK4KHsTLcGUrypVPSbqzOsTO3cItEpo
 tiU132O+3heL9MCoqtOc1vNRK8fFJULN
X-Google-Smtp-Source: ABdhPJzBn9yhlAu07QtSGQuwxOrZ5MMWw+8/mQ+Vs8NMKruwuhNqXHXVSdp7rqXkm+45IeSKyxkhlT+s0C/r
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6214:f0a:: with SMTP id
 gw10mr23729394qvb.27.1628522690786; Mon, 09 Aug 2021 08:24:50 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:27 +0100
Message-Id: <20210809152448.1810400-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 00/21] Track shared pages at EL2 in protected mode
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

This is v4 of the patch series previously posted here:

https://lore.kernel.org/lkml/20210729132818.4091769-1-qperret@google.com/

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

The series is based on the 5.14-rc5, and has been tested on
AML-S905X-CC (Le Potato) and using various Qemu configurations.

Changes since v3
 - Fixed typos in comments / commit messages;
 - Various small cleanups and refactoring;
 - Rebased on 5.14-rc5.

Marc Zyngier (1):
  KVM: arm64: Introduce helper to retrieve a PTE and its level

Quentin Perret (19):
  KVM: arm64: Introduce hyp_assert_lock_held()
  KVM: arm64: Provide the host_stage2_try() helper macro
  KVM: arm64: Expose page-table helpers
  KVM: arm64: Optimize host memory aborts
  KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
  KVM: arm64: Don't overwrite software bits with owner id
  KVM: arm64: Tolerate re-creating hyp mappings to set software bits
  KVM: arm64: Enable forcing page-level stage-2 mappings
  KVM: arm64: Allow populating software bits
  KVM: arm64: Add helpers to tag shared pages in SW bits
  KVM: arm64: Expose host stage-2 manipulation helpers
  KVM: arm64: Expose pkvm_hyp_id
  KVM: arm64: Introduce addr_is_memory()
  KVM: arm64: Enable retrieving protections attributes of PTEs
  KVM: arm64: Mark host bss and rodata section as shared
  KVM: arm64: Remove __pkvm_mark_hyp
  KVM: arm64: Refactor protected nVHE stage-1 locking
  KVM: arm64: Restrict EL2 stage-1 changes in protected mode
  KVM: arm64: Make __pkvm_create_mappings static

Will Deacon (1):
  KVM: arm64: Add hyp_spin_is_locked() for basic locking assertions at
    EL2

 arch/arm64/include/asm/kvm_asm.h              |   5 +-
 arch/arm64/include/asm/kvm_pgtable.h          | 167 ++++++++----
 arch/arm64/kvm/Kconfig                        |   9 +
 arch/arm64/kvm/arm.c                          |  46 ----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  33 ++-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   3 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  25 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  20 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 225 +++++++++++++---
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  22 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  82 +++++-
 arch/arm64/kvm/hyp/pgtable.c                  | 247 +++++++++---------
 arch/arm64/kvm/mmu.c                          |  28 +-
 13 files changed, 628 insertions(+), 284 deletions(-)

-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
