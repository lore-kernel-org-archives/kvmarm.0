Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3ACC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 532C149EE8;
	Sat, 14 May 2022 06:09:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qNpRbX4i7z3B; Sat, 14 May 2022 06:09:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D84C04B200;
	Sat, 14 May 2022 06:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC1D4B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AfYySpG-0aT8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:31 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C331149F5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:31 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 j21-20020a170902c3d500b0015cecdddb3dso4826117plj.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=X4uCUUh1rGfmOD3/lWwoQuwN7ClE8CziC7hFPLNCRtY=;
 b=D+SqHN8mdRc8BL1rfGtiekRaSJl3f0YnaNXNdnFgl1ETHNpYxoGN5Kuo+1V2x/byIN
 1THOBeRRMM1zoYJwvw9u+wIldGQs8IuK7mR7B9torY0FsExnkwks6TxEqaSnWjT/NvHI
 Hm27XGxIrCJRT66NrEDN8zpTavZ+IdfY4bLYRsznH4FaxFfZGZRdebnJN49+PYibFfQp
 9hE98DfIiUW5591QIxsQ5wOwZam050l45UcMYxlKpn6kxACsv8krs+MmqfQHZ6IqAKgO
 UX4hMR8H48v8JGBzc1tnMpzVaf5QgcJkc5UCGRBUMbDRHGKZNAgGgEHNi8UY3eXby53U
 p8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=X4uCUUh1rGfmOD3/lWwoQuwN7ClE8CziC7hFPLNCRtY=;
 b=i4R9KMo7YabNx8qKr19N4qDskXUfs11YbTPoX0rtVsiOvfzGgJRP2cIisAVYkXtaOr
 xHtaWO1lYpGOVgLD0qxRcO8qM21JHiI4yZMclbNFBHzT4+KzBlVqALYbPnzOMc/rqCkL
 gw3Of9HzU4uiVZh634usWLyj2XArbu2uwzHXfPg/HQn2m8wqqNrsM5kcqJEawGXHASdw
 gF8zYuMRnZsmm+LmGdZQ461izZ/ZY+ZQa8PCgDs425NlHLJJn3W8FKw+K8UOfhdRMa82
 yaU75ZLAm1cuMu7kQv79tXY1ci/g5tjhpeixyvmjK+IVyQkX6n9qtcZyGfsfhUsiWYKH
 iy9w==
X-Gm-Message-State: AOAM530rCHr+jkToo278Ps1xCOwu+vO2njT9hq+WHHl7/dso1w4R3wUg
 bdKg9SpFRPjnsTlBSvcrqYPOIVm5b2ZQ/A==
X-Google-Smtp-Source: ABdhPJx0ATiV54nUGtkWD0IQzoJ65BdVb90HAJIfXF6d3Rj+J9RZCZbycBpEb2AXQ0VGCPF6D/fUa0OxUbxRZQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:dac2:b0:15e:c69c:d2fb with SMTP
 id q2-20020a170902dac200b0015ec69cd2fbmr6215793plx.135.1652473710888; Fri, 13
 May 2022 13:28:30 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:00 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 02/21] KVM: x86/mmu: Use a bool for direct
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

The parameter "direct" can either be true or false, and all of the
callers pass in a bool variable or true/false literal, so just use the
type bool.

No functional change intended.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 774810d8a2ed..34fb0cddff2b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1690,7 +1690,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2023,7 +2023,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
