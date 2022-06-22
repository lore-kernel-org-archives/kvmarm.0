Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BF6C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 16:50:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6A84B2DF;
	Wed, 22 Jun 2022 12:50:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id muNqjysrXSzb; Wed, 22 Jun 2022 12:50:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 892B64B2D6;
	Wed, 22 Jun 2022 12:50:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA53A4B2A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 12:50:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9jTM5oZPizOU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 12:50:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 718CD4B28A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 12:50:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655916617;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4XfwMH9ynk+SpvE37AyJRg8bmZJpm/5NDJ42rUcbiSk=;
 b=YRxYAXGa/tNyWH7P0ZJD8p8RK5aLH5r85oF10hYLqpSebsUP2+a3tlbdgxPhL/1QrIZIOB
 1UcVss8+7G1Wq7AWMeMV/BjxBkCv++33eBGRKgJ+UB30q/d10lxhRh7iQ3m/8kfoE52c0R
 JjnQieOAIHY2GHBB5xtxhXzHgLb6pkA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-ODdF87NzMx6s_EvIzkO7DA-1; Wed, 22 Jun 2022 12:50:16 -0400
X-MC-Unique: ODdF87NzMx6s_EvIzkO7DA-1
Received: by mail-ed1-f69.google.com with SMTP id
 y15-20020a056402270f00b004356adb2ab3so10197929edd.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 09:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:from:to:cc:references:in-reply-to
 :content-transfer-encoding;
 bh=4XfwMH9ynk+SpvE37AyJRg8bmZJpm/5NDJ42rUcbiSk=;
 b=sx+anUUl3XNcbA7N+bLSCCxq2CnhgLU35A8iC4AW6c+AupBcgTwXvyl+N3tMBxzeEX
 aOhZlaJgJxgdb5Q+2EpBfajmKr+S+qfrA8eohuIHS/hnCE/keUDyPsGL1XkWiK4ZjHqx
 jArnz+xDY7h9Iryorc2dFpTHOS15w8eJryHmpyfhmQhuxOZj03THk4h9UCmq8aoTOJd5
 Gv2B57Dl4d96At86mPmYoPBjNCgfS3ECoTIlRgsjpTHFDh72PfgDQdEtgEy9dmYvrLdh
 uP9nhqfN09wSEnnL2Gicx+AhnwUJ1rrTXqx6eosc90S4zp5/io/5ioT+3P2BH4VmfTv9
 oTbA==
X-Gm-Message-State: AJIora/orf6PiMf7RWcjTwK6iXY/WjCOzvdCEIfM/7oVMuEHmNKcYW4P
 YYr7qstY6uj2P57e+qdcbRzZpbc1XZx8KKaPHQvGrEL1uHGtLGbyPsVDb/U2BF6S0M95mUQcFyF
 IKbvflTfaSnkc8XrNAaCNcInz
X-Received: by 2002:a17:907:6d83:b0:711:e44b:714 with SMTP id
 sb3-20020a1709076d8300b00711e44b0714mr4016405ejc.392.1655916614781; 
 Wed, 22 Jun 2022 09:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sC/lvr0Tnu4XA3JL6D2PrVVpe51+uh98+vu8rkpMJw7FhS4BWe7E6W+fEXs8AE7M85oBzrWw==
X-Received: by 2002:a17:907:6d83:b0:711:e44b:714 with SMTP id
 sb3-20020a1709076d8300b00711e44b0714mr4016380ejc.392.1655916614537; 
 Wed, 22 Jun 2022 09:50:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 g5-20020a50d5c5000000b004356c0d7436sm12212090edj.42.2022.06.22.09.50.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jun 2022 09:50:12 -0700 (PDT)
Message-ID: <41f1f405-fa2b-0022-c4ba-58a8d0ff3bad@redhat.com>
Date: Wed, 22 Jun 2022 18:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 20/22] KVM: x86/mmu: Refactor drop_large_spte()
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-21-dmatlack@google.com> <Yqy1v59ZDJ7EkCix@google.com>
 <4665c87b-4983-7e15-9262-290d2969b10f@redhat.com>
In-Reply-To: <4665c87b-4983-7e15-9262-290d2969b10f@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 6/22/22 18:13, Paolo Bonzini wrote:
> Even better, drop_large_spte() is always called right before 
> kvm_mmu_get_child_sp(), so:

Actually, we can even include the call from eager page splitting if
__link_shadow_page() is the one that takes care of dropping the large
SPTE:

 From bea344e409bb8329ca69aca0a63f97537a7ec798 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 Jun 2022 12:11:44 -0400
Subject: [PATCH] KVM: MMU: pull call to drop_large_spte() into
  __link_shadow_page()

Before allocating a child shadow page table, all callers check
whether the parent already points to a huge page and, if so, they
drop that SPTE.  This is done by drop_large_spte().

However, the act that requires dropping the large SPTE is the
installation of the sp that is returned by kvm_mmu_get_child_sp(),
which happens in __link_shadow_page().  Move the call there
instead of having it in each and every caller.

To ensure that the shadow page is not linked twice if it was
present, do _not_ opportunistically make kvm_mmu_get_child_sp()
idempotent: instead, return an error value if the shadow page
already existed.  This is a bit more verbose, but clearer than
NULL.

Now that the drop_large_spte() name is not taken anymore,
remove the two underscores in front of __drop_large_spte().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36bc49f08d60..64c1191be4ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1135,26 +1135,16 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
  		rmap_remove(kvm, sptep);
  }
  
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void drop_large_spte(struct kvm *kvm, u64 *sptep)
  {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
-
-	return false;
-}
+	struct kvm_mmu_page *sp;
  
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
  
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+	kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
  			KVM_PAGES_PER_HPAGE(sp->role.level));
-	}
  }
  
  /*
@@ -2221,6 +2211,9 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
  {
  	union kvm_mmu_page_role role;
  
+	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
+		return ERR_PTR(-EEXIST);
+
  	role = kvm_mmu_child_role(sptep, direct, access);
  	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
  }
@@ -2295,6 +2288,13 @@ static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
  
  	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
  
+	/*
+	 * If an SPTE is present already, it must be a leaf and therefore
+	 * a large one.  Drop it and flush the TLB before installing sp.
+	 */
+	if (is_shadow_present_pte(*sptep)
+		drop_large_spte(vcpu->kvm, sptep);
+
  	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
  
  	mmu_spte_set(sptep, spte);
@@ -3080,11 +3080,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
  		if (it.level == fault->goal_level)
  			break;
  
-		drop_large_spte(vcpu, it.sptep);
-		if (is_shadow_present_pte(*it.sptep))
-			continue;
-
  		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;
  
  		link_shadow_page(vcpu, it.sptep, sp);
  		if (fault->is_tdp && fault->huge_page_disallowed &&
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 24f292f3f93f..2448fa8d8438 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -648,15 +648,13 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
  		gfn_t table_gfn;
  
  		clear_sp_write_flooding_count(it.sptep);
-		drop_large_spte(vcpu, it.sptep);
  
-		sp = NULL;
-		if (!is_shadow_present_pte(*it.sptep)) {
-			table_gfn = gw->table_gfn[it.level - 2];
-			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
-						  false, access);
+		table_gfn = gw->table_gfn[it.level - 2];
+		access = gw->pt_access[it.level - 2];
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
+					  false, access);
  
+		if (sp != ERR_PTR(-EEXIST)) {
  			/*
  			 * We must synchronize the pagetable before linking it
  			 * because the guest doesn't need to flush tlb when
@@ -685,7 +683,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
  		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
  			goto out_gpte_changed;
  
-		if (sp)
+		if (sp != ERR_PTR(-EEXIST))
  			link_shadow_page(vcpu, it.sptep, sp);
  	}
  
@@ -709,16 +707,15 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
  
  		validate_direct_spte(vcpu, it.sptep, direct_access);
  
-		drop_large_spte(vcpu, it.sptep);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
+					  true, direct_access);
+		if (sp == ERR_PTR(-EEXIST))
+			continue;
  
-		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
-						  true, direct_access);
-			link_shadow_page(vcpu, it.sptep, sp);
-			if (fault->huge_page_disallowed &&
-			    fault->req_level >= it.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-		}
+		link_shadow_page(vcpu, it.sptep, sp);
+		if (fault->huge_page_disallowed &&
+		    fault->req_level >= it.level)
+			account_huge_nx_page(vcpu->kvm, sp);
  	}
  
  	if (WARN_ON_ONCE(it.level != fault->goal_level))


I'll test the resulting series and then send a v7.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
