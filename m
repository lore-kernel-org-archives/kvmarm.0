Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68216C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A374B2EE;
	Tue, 17 May 2022 03:02:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZsptuLHpNyVt; Tue, 17 May 2022 03:02:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE7A4B319;
	Tue, 17 May 2022 03:02:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23D44B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w44YaPf5BUPc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:13 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2A084B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:13 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r14-20020a17090a1bce00b001df665a2f8bso374466pjr.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pOEpw0U33jr850+hJHIZzPyg7hTIgQtXSLis/i9XW2k=;
 b=Xnun/wU2caTw/TxytZw8C9PSMZVLpb/VyRFu9noez6eaQwaXPIj0voai+u3SrfupAL
 tP5/68go2tx/JL6YYh00U0kUNwS4PgBrY+jFy91J+yf6yDzRikismgT8ytU+bWiZwOMD
 H82NvsF6117s1fVl5CE9EceBQAbMUpO4iBiKZlBlW6Q/ZqRi93hpNNBO0nyyyVFEjSz2
 vIcOaJ+EmqapsNP8M806ZHqZphJjZQk/lcJKZWO+f8o4XXFOWGFyjZGIDY3e6xqPI7Hs
 O72sKJDdIDLNTAI1//4vvfnI/CyvRfgOoG4K4GQjO2GKr68kjxK/vwA1xJirWnp9W+Ef
 VU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pOEpw0U33jr850+hJHIZzPyg7hTIgQtXSLis/i9XW2k=;
 b=jHn+696tzt3a9p4+la66/jQJMCv15zLdfKk1MVqqIRLAwMWVtlJ4mbhw6djZUU1h8a
 XRWAX5U1u1Y8mQ+TFhpG6dImUcNsZH+L08qottIatQZuQuxeKUer/0xxRYlAv9eOUZ1Y
 qRW3Fy5vIZApUwZo0g8JijUzeYgSBJm8EsHWzr6htOyWoTm6YOxIrC+4yIU2ft+N5mgp
 ePxL3KVPTJvbCQHBeYvicfnwBQYEt1xJTR6zcOdqcyjuzvXL56x7Av8t8INZE9lethCu
 1b7waeaeNYq86yhFeBstqQxzbd/Pu+J56B2+FnDp9xfo+ZjZfDGMAsESMr/cmsdQ+/nm
 0afA==
X-Gm-Message-State: AOAM533HzIjEaVTmJ0nrif8qK90j961mZX0FE7juX5kvKgfcZOFF/Kwb
 /q3fczKEut9gOyKowqY4dUx33M5Vr9GxGg==
X-Google-Smtp-Source: ABdhPJz0ymAkSZMwmu2LJ3LS8G7Tkc01yfF7lgaeQlHMPPCk+C7g1qkIdP9NE7LK1ED0+F/WsKGsJCum8ZRNqg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e80d:b0:15e:b27b:931c with SMTP
 id u13-20020a170902e80d00b0015eb27b931cmr19808069plg.5.1652743333371; Mon, 16
 May 2022 16:22:13 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:36 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-21-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 20/22] KVM: x86/mmu: Refactor drop_large_spte()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5d96d452f42..964a8fa63e1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1161,26 +1161,26 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
+	if (!is_large_pte(*sptep))
+		return;
+
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
+
+	drop_spte(kvm, sptep);
+
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
+			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 {
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
-
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
+	return __drop_large_spte(vcpu->kvm, sptep, true);
 }
 
 /*
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
