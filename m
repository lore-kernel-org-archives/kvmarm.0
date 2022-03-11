Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8442C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A821F49E48;
	Fri, 11 Mar 2022 03:48:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0xP8md597+-Z; Fri, 11 Mar 2022 03:48:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AEA749F2E;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 647C541016
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WFlMhRfimqeG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:42 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DEC740FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:42 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 p15-20020a17090a748f00b001bf3ba2ae95so4229767pjk.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=E1f7dwVMCTIQxzMxcNwcOjBa8usGSsNkBUA4TV7/K5Q=;
 b=dyFlaYzlo6UILgMHQAlPkaaMWow2Ul4B7LMcFG47WnUc9EGN8o4wI1lMnJ3utbSG7p
 q9GeTDSR1RhxNQy56RSpOC5NArGbG4gGdb7XRaIJJfeqUYsywCbqkmnVbTgkMS9Wau2M
 qeWdDfXmPCEfp84dJU25XOuzordVzgtSPCRymjS7qB1/GTeYHqtXALIOMRi2PQLz5BvD
 AdyrtucZlIf+ZhYFru+CvqSrBIOWiaZHMvEkUi3BaaeFk2pLY6D+IXBbJE9WAoXsMSuR
 A54OuPtVrIT/1g7o3yy9wrm+WFzZFhuIaFAK0CDO/gJBFzmHnhMWGPNd5MLO3oeSADwf
 qhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=E1f7dwVMCTIQxzMxcNwcOjBa8usGSsNkBUA4TV7/K5Q=;
 b=AM8x47HFwvvZPAk/8xrZ0UBt/6uGwGCSFODq79N0Zqgo977pgE+UuWRt82CPFUWuUd
 krpsToupETCC2LJab3WpZe/P02Ig069TSLkFW/xIoYASWdCM90nOdyU74DtLfz51t5JW
 HgPJGUxPX/ZsrB4i7cgJmq4YEixBUY7CmWeqEJcDOl9mfPmTn4yMgh8rng3AtzqegJsu
 aPd9XS9123ndkEIEx2P5KWx6DiHriSONu4wX6sB5H6Ii6WMUotHQC1jOF6rVTBppSqAq
 TbgfktwmT+bLZxAuX9AQBlBO7JK0sMFSNk0JomUUKdk/swEiExPeuB38KCKdv3PzfQ7a
 NDYw==
X-Gm-Message-State: AOAM531D9VcE7gCVTLeyKCJxnfXJw6bToMftmbAKFmhlvOXbFhfILmRQ
 icCWu521/KfDyXSC8/I22ceSHdTJ8eNqng==
X-Google-Smtp-Source: ABdhPJwCJvv1gmlTzqVHHEXadtDnxMhsFf7CFfV0r1s95pboZSQVSEZ+RKGDk2zGMU2B9w5mZno63N0XkT+ONQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:a3c3:b0:151:ec83:d88 with SMTP id
 q3-20020a170902a3c300b00151ec830d88mr8062530plb.9.1646958341309; Thu, 10 Mar
 2022 16:25:41 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:08 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 06/26] KVM: x86/mmu: Pass memslot to
 kvm_mmu_new_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:41 -0500
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

Passing the memslot to kvm_mmu_new_shadow_page() avoids the need for the
vCPU pointer when write-protecting indirect 4k shadow pages. This moves
us closer to being able to create new shadow pages during VM ioctls for
eager page splitting, where there is not vCPU pointer.

This change does not negatively impact "Populate memory time" for ept=Y
or ept=N configurations since kvm_vcpu_gfn_to_memslot() caches the last
use slot. So even though we now look up the slot more often, it is a
very cheap check.

Opportunistically move the code to write-protect GFNs shadowed by
PG_LEVEL_4K shadow pages into account_shadowed() to reduce indentation
and consolidate the code. This also eliminates a memslot lookup.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b6fb50e32291..519910938478 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -793,16 +793,14 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
 	update_gfn_disallow_lpage_count(slot, gfn, -1);
 }
 
-static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void account_shadowed(struct kvm *kvm,
+			     struct kvm_memory_slot *slot,
+			     struct kvm_mmu_page *sp)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
 	gfn_t gfn;
 
 	kvm->arch.indirect_shadow_pages++;
 	gfn = sp->gfn;
-	slots = kvm_memslots_for_spte_role(kvm, sp->role);
-	slot = __gfn_to_memslot(slots, gfn);
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
@@ -810,6 +808,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 						    KVM_PAGE_TRACK_WRITE);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
+
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2127,6 +2128,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 }
 
 static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
+						    struct kvm_memory_slot *slot,
 						    gfn_t gfn,
 						    union kvm_mmu_page_role role)
 {
@@ -2142,11 +2144,8 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
-	if (!role.direct) {
-		account_shadowed(vcpu->kvm, sp);
-		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-	}
+	if (!role.direct)
+		account_shadowed(vcpu->kvm, slot, sp);
 
 	return sp;
 }
@@ -2155,6 +2154,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 						    gfn_t gfn,
 						    union kvm_mmu_page_role role)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
@@ -2163,7 +2163,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 		goto out;
 
 	created = true;
-	sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
 
 out:
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
