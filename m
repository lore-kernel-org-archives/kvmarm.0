Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBC2C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:20:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C51D4B282;
	Fri,  1 Apr 2022 14:20:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id whzHwjq4kQJZ; Fri,  1 Apr 2022 14:20:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F09D44B2D0;
	Fri,  1 Apr 2022 14:20:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A4B84B219
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id geMxCvfIKjna for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:11 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFF2F4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:11 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 c78-20020a624e51000000b004fadac38f65so1984241pfb.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IyIPSk2/EaBUB0UobyNpb06WjR6I1O9i3ZizvW3fhmY=;
 b=diK+NDVVMnH1euNmcgNZkZR+RNe+RtbEPnphRRHdwnohQBdcNG3DKV2+OalZZ9dtiO
 4U1BmQRB9ltXsq1iribzjEnPiYHQfyjaB/RIv7u3RQME2nqt4UISDss9FwhaKRI73n2M
 bMU+zTqvPQzdMjCfjifjO/HgM4CjFbg0oko4cVui9/LHWSrFQKcR1tLhe7lbcKG+MY6Q
 lj9/alcDyXKJ/nW3dpp0m5fF9issvOVGtIPN401aoBG2OVH4cv2Xqlye/tg/RF+3/hn7
 WxjoFGMkrlclU9nEnzQJ5GSO36yNskFztCeAocXYe1LYhR2jSCTTrWpJUtyLXPUObvDR
 s/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IyIPSk2/EaBUB0UobyNpb06WjR6I1O9i3ZizvW3fhmY=;
 b=dm0Pm6AFzxDOxIiyV1IyxcItJA7iRbkD7B7oMBPESn6lDFDjpT0x0Q9lVolLwWpa+6
 2D12aUptsOWW9qNwULQ2MUhloJp6lbua5RUcFWtHiZI0ZtxDk47Lsod30EqV7nSzVQuW
 0+C6qeLUtF/TCUvBv3DDRldOLjFb35PRzHIL70cNFflmmYq7LzkbfLzgc+ZEMtWbozrE
 2wzSceIlg6rKz9rvccOGcMv7u6BlAnsKWB4/UsPBHMIZC/HabMOpnVyLW8InXaCvnQJN
 1hpTtmYoQyhZiNUZaFE042giH4FC/xMbm27dszw6vmIfgj44nUVbuKCvgC1SZRH2KW9S
 6YYg==
X-Gm-Message-State: AOAM531uifFIN2b8h/ejOA6vu8Q/O7/XbHeobtBBhAw/dz4HVhkYacMB
 CHuZBxjlyDCXGG4pRsAWitj9siQJ0toeSA==
X-Google-Smtp-Source: ABdhPJw+3njlRranWemDGRAFfxcGs6Z7lxR+Q6odwZANW7lQMpZ7k6xIEK9JVJtusBFO1h+uHnsiH7sfkuQYbQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2d0:b0:4f4:1f34:e39d with SMTP
 id b16-20020a056a0002d000b004f41f34e39dmr12123192pft.14.1648835771030; Fri,
 01 Apr 2022 10:56:11 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:37 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 06/23] KVM: x86/mmu: Pass memslot to
 kvm_mmu_new_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
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

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc1825de0752..abfb3e5d1372 100644
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
@@ -2123,6 +2124,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 }
 
 static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
+						    struct kvm_memory_slot *slot,
 						    gfn_t gfn,
 						    union kvm_mmu_page_role role)
 {
@@ -2138,11 +2140,8 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
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
@@ -2151,13 +2150,15 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 						    gfn_t gfn,
 						    union kvm_mmu_page_role role)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+		sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
