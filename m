Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E31C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A3F4B0F5;
	Sat, 23 Apr 2022 04:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id suti2YMG4WTH; Sat, 23 Apr 2022 04:57:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0837D4B278;
	Sat, 23 Apr 2022 04:57:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6CC4A11C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:05:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1jzuAEQ3Eyw9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:05:52 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FA8840C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:05:52 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 l14-20020a63f30e000000b0039cc65bdc47so5648845pgh.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zNWYQ7iy7Yr89sIEde3cCb/Lt3WEldLKJ8vXDlDeSiQ=;
 b=Ppu58rFHVoI6iW5s1gyFZJw/q+6CTvIq3bwkrX6Bfha1v9ELmxlhB6kBdaxuhU8ALA
 oZJOS2zzPK79Cbz2PaFtDvWjGOXqa3Vag3MWGfOPw2XmGt9fNogG4PyBnIzfzwu0Cr2Z
 Z9Yd3xVeeD1MsLLmQbE33yT6gDJNnLmzjIhiqgCNEusUBTkk2ljA7jNZeivTms/fsolS
 8ruvMsny7ijFMPJnejhTGx2b5qhO8OcB3N+OLEFjJPIKmS4RB11u8nQzg8mef19nDz4C
 hY7FnXWyO5/aoBz1LUQ06kXu09Mes4okVgaK01vet3BEhu0IBB9fZXiQPVzHWDrd/mUO
 dnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zNWYQ7iy7Yr89sIEde3cCb/Lt3WEldLKJ8vXDlDeSiQ=;
 b=OkXsMgwGNqHIAmcouSGNIM7n165+vCBgbo2HfJ5mnvoYFfPFtwpLebX1jux0PQi8hj
 13AOixFDapryrmULHcNNV2JbdvfQqHB8XeFQgQDx19HnRirc1YkZ47tAsBIs4IpdYWUx
 UESeg8idDshrEWF5pYdcfulbWOVpZA3rZK8kShQPvwuWTctXT4vFW1//He8Opn31Ub4A
 IV1x07dA/PVDLoWgZD7l1lE9jTy3b2bRLyrRT174TCX43Dvhf2CNdJ/NChoBaUJgqXEV
 0RX2ZGJ7lgN7H0iGvZuXpDXIsbbaD6RGJPkpO2Af0Y5rUa39vQNaDAUSMfZYlU9zhF3G
 bN1A==
X-Gm-Message-State: AOAM5305eTN5RNcTgJLz7pLqKjpNsQ9u7QxzbIsoC69pipxMcyGhOnQq
 59X7/61PqCRSpakJb0hvPc4ijdeVGwHyFA==
X-Google-Smtp-Source: ABdhPJyWKXLx2/uwe0ElKVg7hOGiMwOVxhtzWi1NrbfYjD0XJGhsQ6VUWZmhsGO7iXcdNSRimP+xg/0T9I02hg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:18f:b0:15a:d3e:1e47 with SMTP id
 z15-20020a170903018f00b0015a0d3e1e47mr6631600plg.54.1650661551615; Fri, 22
 Apr 2022 14:05:51 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:28 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 02/20] KVM: x86/mmu: Use a bool for direct
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 23 Apr 2022 04:57:06 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
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

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3de4cce317e4..dc20eccd6a77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1703,7 +1703,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2025,7 +2025,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int direct,
+					     bool direct,
 					     unsigned int access)
 {
 	union kvm_mmu_page_role role;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
