Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05460C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 780F360F42
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 780F360F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8BC24B0CE;
	Thu, 29 Jul 2021 09:28:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jD-L+3ieOVf2; Thu, 29 Jul 2021 09:28:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AE624B0BA;
	Thu, 29 Jul 2021 09:28:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 585724B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S6zIxEsQV0pP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:22 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3AE240256
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:22 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 o32-20020a0c85a30000b0290328f91ede2bso3944484qva.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=uCsDvrfcUF+1HjCy/5u0lXgukkeSpeNSQPNFAPtE5Og=;
 b=TwUGuSD9qt0RaCZOS9MqYshAwbluPWeQnV47t4m6fl1LT4Bu8aMFJPgR4wel2mQ/0d
 VMq3hAK+GBdhK0pDqqszgH6EjWtt0g+gsttm5me4V/4bLlmdJtY8xDdSkXQhD2+kh7En
 APBRNllYpK/w+G4htTFazfyOkcJT2CNzdRflI8pGflgUvStmidwaEZJ1ISLDNIz8XHkE
 I8TAGDAGu8wQRDYBI3LsbMZm8DvGc5Yhi05TnDxDgHirqn7QwkGG9pUJKe1iAk3KJ5ST
 nrE4ll47uKL1HWghtXbFmGP9rQo/7u9BGNvZD5e4hpV4BN1enHUmTMlPD1rE19y/oH2I
 Rzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=uCsDvrfcUF+1HjCy/5u0lXgukkeSpeNSQPNFAPtE5Og=;
 b=s+a/Z7tUXbhMvII15yZ0YsnybGEMvRse/uaY9B/H0jegB7/ORuLxcmST+My7Y8fgiB
 aqb68hm2dD9cpbQPu25mTmUm+RQtFqa1kf/1hhtaPSJb5LCv36sKYwcF2dJQ1AfMRX0+
 WBgESBS45pvPXMhmK2Xzavn0gK0ItN1pTtNjENqgIpMiEP/zVWvv1obwqqOquPNEfrwu
 wBvyiUrjA2uaBTd6WruneXISNVtL8aIWh2jD8ZjOEpE6X9PDnSVwVtIVVbev1lAGZYV6
 vFgLzWcKCyH6ImNf4TWgvHFQ3gLDGDMxpKvLRBFVRLXZjdqHzbNRXkFRRj26uu4nAiyR
 5fdA==
X-Gm-Message-State: AOAM531kxlrS1V4qDsuyNREobY/crB4bzVVLz9BjMap2fquHyy4FhmXd
 mR7NkYOHf4biHnKUMvOZoCOry69vDUEV
X-Google-Smtp-Source: ABdhPJwFLu6UzIEWRzj8e8yAxcsgzIxAgdeYD1x+wnn2xqD3UBVZS+HjIyhzCZDdD20gs2aUkHHEOqy6y/hY
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:27e7:: with SMTP id
 jt7mr5278007qvb.28.1627565302295; Thu, 29 Jul 2021 06:28:22 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:27:57 +0100
Message-Id: <20210729132818.4091769-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 00/21] Track shared pages at EL2 in protected mode
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

This is v3 of the patch series previously posted here:

https://lore.kernel.org/kvmarm/20210726092905.2198501-1-qperret@google.com/

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

The series is based on the kvmarm/fixes branch, and has been tested on
AML-S905X-CC (Le Potato) and using various Qemu configurations.

Changes since v2:
 - Renamed and refactored the find_range() path for host memory aborts;
 - Added hyp_assert_lock_held() using Will's hyp_spin_is_locked()
   helper, and sprinkled a few of them throughout the series;
 - Changed how host stage-2 mappings are adjusted after __pkvm_init() by
   walking the hyp stage-1 instead of relying on the host calling
   __pkvm_mark_hyp.

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
 arch/arm64/include/asm/kvm_pgtable.h          | 166 ++++++++----
 arch/arm64/kvm/Kconfig                        |   9 +
 arch/arm64/kvm/arm.c                          |  46 ----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  33 ++-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   3 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  25 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  20 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 221 ++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  22 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  82 +++++-
 arch/arm64/kvm/hyp/pgtable.c                  | 247 +++++++++---------
 arch/arm64/kvm/mmu.c                          |  28 +-
 13 files changed, 625 insertions(+), 282 deletions(-)

-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
