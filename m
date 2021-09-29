Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA21C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA178613C8
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DA178613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 862204B0C5;
	Wed, 29 Sep 2021 03:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id as4sbXEllSvR; Wed, 29 Sep 2021 03:12:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55BBB4B16E;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB3D4B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 00:29:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o0scm3KjDyAx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 00:29:32 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DE004A98B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 00:29:32 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id u7so847860pfg.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 21:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=QkzreDQI8QXcNj6KF3HsvP+QbXFPHw1Mmnt63rKUKkA=;
 b=SUgnMZX/AWTndTbWHhZMsZ/Q8rq2mha6o26G7OvAkCmtpgykvlWgC91PFYQimoCXyV
 v8PubmTDiQJMqehVuvd15V+PbUnLDyYAlOhEqLeGTkimABHe/8DNH5GMjyR3wqkwUf4N
 LrwHmT0opEc0XBq0yUrUiNhN23ksP4p5EJqgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=QkzreDQI8QXcNj6KF3HsvP+QbXFPHw1Mmnt63rKUKkA=;
 b=CknlR17ZMyTZrD/ytBPQe4s52qXou4jN5G6UACxieaRXIDEJJaEQoxZD1rCWgvTMm3
 WNiYbYujRn0WfZ0BlLdO5giy5kWOhYQTCYYGB+pb3qdksJKAxcirAg8YCSEgigtomcqc
 zkTd6P0Pe+fg6LXs1QrLFofyv+yorJTjwTwCrjrty6hixD+zXV/naZ8N6Mhcod2jr/0Q
 tpTfJS9qCzg+r9h/eSTugCoqD0OwuqBH0po56+xicDhHLstgDHmy1zf3Oi2GjzB1aCoY
 Id9+4gR5xaVLfaCXljivlSe1JWX2fP57xAw/tDnonBLR0D4cZwlXlWPwGoklzCUyhuAR
 Rx6A==
X-Gm-Message-State: AOAM530ezAzfzgFJH5j/LMmGJtGMZsilHuMzzfdbXvJuQf9x0M96kWSC
 Zbl3Osx9b8lUMAUnjeXk8+1BSg==
X-Google-Smtp-Source: ABdhPJwdVPiqe25K8PElzE9sWsXwBxyck9GIaCUbQQkjXlHvGKR9mvFoORzocViMa6RYiKVWceOf5A==
X-Received: by 2002:a63:e741:: with SMTP id j1mr7938740pgk.86.1632889771324;
 Tue, 28 Sep 2021 21:29:31 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:f818:368:93ef:fa36])
 by smtp.gmail.com with UTF8SMTPSA id b5sm261924pjk.18.2021.09.28.21.29.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Sep 2021 21:29:30 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 0/4] KVM: allow mapping non-refcounted pages
Date: Wed, 29 Sep 2021 13:29:04 +0900
Message-Id: <20210929042908.1313874-1-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

v3 -> v4:
 - rebase on kvm next branch again
 - Add some more context to a comment in ensure_pfn_ref
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

 arch/arm64/kvm/mmu.c            |  27 +++--
 arch/x86/kvm/mmu/mmu.c          |  50 ++++----
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  23 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |   6 +-
 include/linux/kvm_host.h        |  17 +++
 virt/kvm/kvm_main.c             | 198 +++++++++++++++++++++++---------
 9 files changed, 231 insertions(+), 103 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
