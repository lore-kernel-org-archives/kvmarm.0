Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F90C07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 443FD60FF4
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 443FD60FF4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0604B086;
	Mon, 19 Jul 2021 06:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id atB9gxPIiG8U; Mon, 19 Jul 2021 06:47:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7FE4A319;
	Mon, 19 Jul 2021 06:47:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 342EF4A193
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pNEwWaLHFb-0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:47:42 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CB3749DE7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:42 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 j141-20020a1c23930000b0290212502cb19aso5288577wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=6r6SQ5Sfe1ngDPnI/RzrWml59LLxArWehQBwowrYG0g=;
 b=TT8gWUbNyJACYMfSgAbkMfXL/hIgt2K4TeYX1798Z+RVovD7a9k8A+Ys5fdzbqZULc
 4B4P7CHpNEvod4gaq/gLeRGehtUvM3mqYd9uMnL6DvHv5ac9mTltH59uNuqNUJ6+FHMX
 6K7zECMso0T+Ls2KaIQrVCU5PlKH3Im0K9x845PYuGR0Nlijm9kVeTa9AlAEx7TlHy++
 FyexRWmDWWzgBlUDElyQiNQ2vKbRBh1YBi4tObrK7iEB5+Mq/UlRniB4sw1uIdHbZRAw
 uZ575TJO1dEKtWRybLGfWQSPoqEwTr4VkbdKWgYrBmrVd1j9JN+rBwgxonbrMZJ4fnJM
 80Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=6r6SQ5Sfe1ngDPnI/RzrWml59LLxArWehQBwowrYG0g=;
 b=o4dE1dyPgKYgcBEG6Tx2uTacedXXeujssFWki+C4dLFb2vO5Sdu59+gO8GrZtjSrHO
 2yQSvdvVjW33rzsCrwn51D1UwnaBko74Jd3fTc9Zn6teglmoUWt4SpbPRbUqnnlYaNT9
 KlEy50hFzg2irwoxP2XOYBXM3q11os9Dm3iWL0otTvT61KG5cw+evhUqUd1I/xGr7wxv
 milqz3eWCHRIOBbEVZQbsgZDCG80p1Mav/vVm0DGu7MvWG1TTw3AZpk+16GU4vyqSeBZ
 waOMlfRL1PJNBIjB/n7PaIaSgHy9eCgnqDBIc0pnc0Qs/TedYou8lGZxs4geBs6yuByG
 ubqA==
X-Gm-Message-State: AOAM530bWu5vDEBIzwxb9RsTiThsNyYV533tBhVBGUBzSgHBKFbqjvyB
 +BZL8lvj2F+RdBtK8lBYKjqjWjm2DJII
X-Google-Smtp-Source: ABdhPJyapMlzacXUANT8CGyWjaSfGRj8ZkKY3ZV1NxaiDQ/d+WmxKezlFsiAVAsdL+q2omGDMLjGV6nnVEbo
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a5d:6846:: with SMTP id
 o6mr29073942wrw.326.1626691660737; Mon, 19 Jul 2021 03:47:40 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:21 +0100
Message-Id: <20210719104735.3681732-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 00/14] Track shared pages at EL2 in protected mode
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

This series aims to improve how the nVHE hypervisor tracks ownership of memory
pages when running in protected mode ("kvm-arm.mode=protected" on the kernel
command line).

The main issue with the existing ownership tracking code is that it is
completely binary: a page is either owned by an entity (e.g. the host) or not.
However, we'll need something smarter to track shared pages, as is needed for
virtio, or even just host/hypervisor communications.

This series introduces a few changes to the kvm page-table library to allow
annotating shared pages in ignored bits (a.k.a. software bits) of leaf entries,
and makes use of that infrastructure to track all pages that are shared between
the host and the hypervisor. We will obviously want to apply the same treatment
to guest stage-2 page-tables, but that is not really possible to do until EL2
manages them directly, so I'll keep that for another series.

The series is split as follows:

 - patches 01-04 are essentially cleanups and optimizations of existing code
   paths that might be relevant on their own, but also prepare the ground for
   the rest of the series;

 - patches 05-08 introduce support in the page-table library for annotating
   shared pages with software bits;

 - patches 09-14 make use of the previously introduced infrastructure to
   annotate all pages shared between the host and the hypervisor;

The series is based on the latest kvmarm/fixes branch, and has been tested
on AML-S905X-CC (Le Potato) and using various Qemu configurations.

Thanks!
Quentin

Quentin Perret (14):
  KVM: arm64: Provide the host_stage2_try() helper macro
  KVM: arm64: Optimize kvm_pgtable_stage2_find_range()
  KVM: arm64: Continue stage-2 map when re-creating mappings
  KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
  KVM: arm64: Don't overwrite ignored bits with owner id
  KVM: arm64: Tolerate re-creating hyp mappings to set ignored bits
  KVM: arm64: Enable forcing page-level stage-2 mappings
  KVM: arm64: Add support for tagging shared pages in page-table
  KVM: arm64: Mark host bss and rodata section as shared
  KVM: arm64: Enable retrieving protections attributes of PTEs
  KVM: arm64: Expose kvm_pte_valid() helper
  KVM: arm64: Refactor pkvm_pgtable locking
  KVM: arm64: Restrict hyp stage-1 manipulation in protected mode
  KVM: arm64: Prevent late calls to __pkvm_create_private_mapping()

 arch/arm64/include/asm/kvm_asm.h              |   2 +-
 arch/arm64/include/asm/kvm_pgtable.h          | 109 ++++++---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  17 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 156 +++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                  |  20 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |  52 ++++-
 arch/arm64/kvm/hyp/pgtable.c                  | 219 +++++++++++++-----
 arch/arm64/kvm/mmu.c                          |  14 +-
 10 files changed, 454 insertions(+), 140 deletions(-)

-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
