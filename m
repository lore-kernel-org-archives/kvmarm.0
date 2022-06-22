Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67535CCA479
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 19:27:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CDE44B445;
	Wed, 22 Jun 2022 15:27:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fPmFMuJekaBG; Wed, 22 Jun 2022 15:27:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B457C4B511;
	Wed, 22 Jun 2022 15:27:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4BFB4B285
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 15:27:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CP7NwKUVHywE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 15:27:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F784B322
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 15:27:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655926037;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=Xf2w4YFMBo/KqjwPtBP8STHhW74PSmVHW8ZoSdl5DBs=;
 b=XJd3G40MHVBMCKX5NvffUUpBA8NPfJg0jcfwTAMEkNRQHEPCRYH2cptZNl6NQ3Xq/89pi+
 PStYusUa/e2mRIxqiUcNZ0BNs92NIkCBcLz3MQ4Qd9lI73p02oG1DYN8dwLM8lkoj0jqb/
 267BZpVHqtjN0+Tl9LYB88G0NEJxR7E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-gprVsIPsOwqRQYeDQd_oYA-1; Wed, 22 Jun 2022 15:27:12 -0400
X-MC-Unique: gprVsIPsOwqRQYeDQd_oYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E4E18001EA;
 Wed, 22 Jun 2022 19:27:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com
 (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B71791121315;
 Wed, 22 Jun 2022 19:27:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 00/23] KVM: Extend Eager Page Splitting to the shadow MMU
Date: Wed, 22 Jun 2022 15:26:47 -0400
Message-Id: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: maz@kernel.org, jiangshanlai@gmail.com, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, bgardon@google.com, dmatlack@google.com,
 maciej.szmigiero@oracle.com, kvmarm@lists.cs.columbia.edu, pfeiner@google.com
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

For the description of the "why" of this patch, I'll just direct you to
David's excellent cover letter from v6, which can be found at
https://lore.kernel.org/r/20220516232138.1783324-1-dmatlack@google.com.

This version mostly does the following:

- apply the feedback from Sean and other reviewers, which is mostly
  aesthetic

- replace the refactoring of drop_large_spte()/__drop_large_spte()
  with my own version.  The insight there is that drop_large_spte()
  is always followed by {,__}link_shadow_page(), so the call is
  moved there

- split the TLB flush optimization into a separate patch, mostly
  to perform the previous refactoring independent of the optional
  TLB flush

- rename a few functions from *nested_mmu* to *shadow_mmu*

David Matlack (21):
  KVM: x86/mmu: Optimize MMU page cache lookup for all direct SPs
  KVM: x86/mmu: Use a bool for direct
  KVM: x86/mmu: Stop passing "direct" to mmu_alloc_root()
  KVM: x86/mmu: Derive shadow MMU page role from parent
  KVM: x86/mmu: Always pass 0 for @quadrant when gptes are 8 bytes
  KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
  KVM: x86/mmu: Consolidate shadow page allocation and initialization
  KVM: x86/mmu: Rename shadow MMU functions that deal with shadow pages
  KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
  KVM: x86/mmu: Pass memory caches to allocate SPs separately
  KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
  KVM: x86/mmu: Pass kvm pointer separately from vcpu to
    kvm_mmu_find_shadow_page()
  KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
  KVM: x86/mmu: Pass const memslot to rmap_add()
  KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
  KVM: x86/mmu: Update page stats in __rmap_add()
  KVM: x86/mmu: Cache the access bits of shadowed translations
  KVM: x86/mmu: Extend make_huge_page_split_spte() for the shadow MMU
  KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at all possible
    levels
  KVM: Allow for different capacities in kvm_mmu_memory_cache structs
  KVM: x86/mmu: Extend Eager Page Splitting to nested MMUs

Paolo Bonzini (2):
  KVM: x86/mmu: pull call to drop_large_spte() into __link_shadow_page()
  KVM: x86/mmu: Avoid unnecessary flush on eager page split

 .../admin-guide/kernel-parameters.txt         |   3 +-
 arch/arm64/kvm/mmu.c                          |   2 +-
 arch/riscv/kvm/mmu.c                          |   5 +-
 arch/x86/include/asm/kvm_host.h               |  24 +-
 arch/x86/kvm/mmu/mmu.c                        | 719 ++++++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h               |  17 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  43 +-
 arch/x86/kvm/mmu/spte.c                       |  15 +-
 arch/x86/kvm/mmu/spte.h                       |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 include/linux/kvm_host.h                      |   1 +
 include/linux/kvm_types.h                     |   6 +-
 virt/kvm/kvm_main.c                           |  33 +-
 13 files changed, 666 insertions(+), 208 deletions(-)

-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
