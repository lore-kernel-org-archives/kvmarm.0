Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC28C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 10:20:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41F0C6121E
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 10:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41F0C6121E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B19CA4B1D9;
	Wed, 25 Aug 2021 06:20:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ohjEKFV3R5OJ; Wed, 25 Aug 2021 06:20:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F182E4B263;
	Wed, 25 Aug 2021 06:20:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8671A4B277
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 22:50:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hf46PtV3PrPs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Aug 2021 22:50:45 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 563D24B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 22:50:45 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id a5so13461515plh.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 19:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=G+VFbxZv56JqJJvHvZfxmdl5/mMwzz6LNS7nJgyEuFg=;
 b=PuRuwB6GpTZkYLCohD7vc5rbOm294HWMBPOKGiKyMcID0d/cqaUomfm4BIGY/jgOL3
 IGabpTvdWyYabHtI4zlkTEsxa3btaZbdtY8jO5jSGxiFSrKVrc7KOS8a7z3HapC8BNcS
 QGRYo/m43G5PNg6mhJEEn7nooJHKIHnJPb7/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=G+VFbxZv56JqJJvHvZfxmdl5/mMwzz6LNS7nJgyEuFg=;
 b=MwhdVIF5AmYxWEEH7ginOzwfik9MMjmSFB1k+NgF2p95kGLw7ayvzO16gWxJ24KR7D
 iqFlzCvDQuphug82NLigx1vHqZG6ve+kqs72gSo0udPSUsfv6IE0YGS0mHG3MO80xtGe
 FPWjaGoL+ZyhDLFEnMfzJnfrdlpzQPSWlN9q03SzQCuMXAHSdmYn8j8JZQRWxalDBgyU
 lhD45H9RLFaxa4hq4b04P0ME71lJVeEtiOkB1rSnW1Z5fmF/nLcuq53s7eMaoUy/EIyi
 XTrCgII3lzWu5jxwuu1AZC0Jl1zxDZ6l1m1QMpTKPrjpt4DJzaXGT3EpyKENbFdCnosf
 oYrw==
X-Gm-Message-State: AOAM530qk+JpQAPLi6J91t6FuIAjKFt9lgAKyot3kZ5a5THxUp9WuMh2
 qMrrDarLA2pWHKQLy/FRThWexw==
X-Google-Smtp-Source: ABdhPJw71JeKXknXk4vWPDjxlltZQjqQ6fdlXY/CarzMWUi3FciPU9uv5juBIo+m4zTlv2vl32DI8A==
X-Received: by 2002:a17:90a:b00e:: with SMTP id
 x14mr7953567pjq.155.1629859844343; 
 Tue, 24 Aug 2021 19:50:44 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:d273:c78c:fce8:a0e2])
 by smtp.gmail.com with UTF8SMTPSA id j6sm20237041pfn.107.2021.08.24.19.50.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 24 Aug 2021 19:50:44 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/4] KVM: allow mapping non-refcounted pages
Date: Wed, 25 Aug 2021 11:50:05 +0900
Message-Id: <20210825025009.2081060-1-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 25 Aug 2021 06:20:00 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

From: David Stevens <stevensd@chromium.org>

This patch series adds support for mapping non-refcount VM_IO and
VM_PFNMAP memory into the guest.

Currently, the gfn_to_pfn functions require being able to pin the target
pfn, so they will fail if the pfn returned by follow_pte isn't a
ref-counted page.  However, the KVM secondary MMUs do not require that
the pfn be pinned, since they are integrated with the mmu notifier API.
This series adds a new set of gfn_to_pfn_page functions which parallel
the gfn_to_pfn functions but do not pin the pfn. The new functions
return the page from gup if it was present, so callers can use it and
call put_page when done.

The gfn_to_pfn functions should be depreciated, since as they are unsafe
due to relying on trying to obtain a struct page from a pfn returned by
follow_pte. I added new functions instead of simply adding another
optional parameter to the existing functions to make it easier to track
down users of the deprecated functions.

This series updates x86 and arm64 secondary MMUs to the new API.

v2 -> v3:
 - rebase on kvm next branch
v1 -> v2:
 - Introduce new gfn_to_pfn_page functions instead of modifying the
   behavior of existing gfn_to_pfn functions, to make the change less
   invasive.
 - Drop changes to mmu_audit.c
 - Include Nicholas Piggin's patch to avoid corrupting refcount in the
   follow_pte case, and use it in depreciated gfn_to_pfn functions.
 - Rebase on kvm/next

David Stevens (4):
  KVM: mmu: introduce new gfn_to_pfn_page functions
  KVM: x86/mmu: use gfn_to_pfn_page
  KVM: arm64/mmu: use gfn_to_pfn_page
  KVM: mmu: remove over-aggressive warnings

 arch/arm64/kvm/mmu.c            |  26 +++--
 arch/x86/kvm/mmu/mmu.c          |  50 +++++----
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |   6 +-
 include/linux/kvm_host.h        |  17 +++
 virt/kvm/kvm_main.c             | 188 +++++++++++++++++++++++---------
 9 files changed, 220 insertions(+), 103 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
