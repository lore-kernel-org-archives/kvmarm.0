Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8723CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 16:14:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C94BF4B4A5;
	Wed, 22 Jun 2022 12:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 40Kvy0SFLrub; Wed, 22 Jun 2022 12:14:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 661C94B4AC;
	Wed, 22 Jun 2022 12:14:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38BE64B4A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 12:14:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FctkDW9UinrV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 12:14:32 -0400 (EDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBF4D4B490
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 12:14:32 -0400 (EDT)
Received: by mail-ed1-f43.google.com with SMTP id e40so12052981eda.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 09:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=9WjOZvdCTB7Ps/WBVZNvXm3V+edRGPvyOZ6QWomOwFM=;
 b=WfgOYbVJi99Uf4aae+TXkvpjNJKzqWVk0BQ1VERy+oH7Pfj9aCh1r4AWEJV7vAk9sF
 PrYGIBVOKz8sMGGphv4QbTK/ANi7pVovHNEd4YcI5/AVWSwI0baJR0HWqg1kZzSxVZec
 0vxz0jmTXMPInL1/zUGD3zx4hmsXyJY7E+rOQDGUs9omkZU95aiiVdzj6X5ZkysLbnHR
 il5bgk6NWjDE1RparFoBw/vNNc0CaKzEx4lTrMmHwuDH69KOXWVm/Q9pKTWztHlSRQsg
 53MqsWzDsyqFXL99zpjSGKLx1TNY9swWSyXNdHZ3N7oKZKE4pFxLNS68Z0XW2F7geALv
 y0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=9WjOZvdCTB7Ps/WBVZNvXm3V+edRGPvyOZ6QWomOwFM=;
 b=cK/NVLjdlMTL3+PDi4O44yshcJESNhE3Px7BQMKQufnEOZrC5w2ZlclCs1B5NKSgYb
 MuZmPgtjQei3y3a5tPgA98O+cCaaz25T7s4Nm+F1QUm6OcXldWkCDiet860iEyhzJvy5
 Q0+BwkXBBqwmqgUBMOgA1b73zFY86vLqhjzvtKN2A8u08bolR0aBixLo9HivJh51GRTO
 dgjm3ArbS5ik1HV78cgskrtGCc9tZjOQMcf8SUljvGxxLfxnbmI9hMEwpg7dPVoRZoSm
 s2Ogxbtg1bvGFkRfsjZfcSgKQvIz2Pb/v/dvCqMEYUBhh7NcmMwSTCpHn+4YZQ77/9fH
 icZw==
X-Gm-Message-State: AJIora9Jfw5+9ik/J5h66+VUB/GKuaTZSOgffPdJTZLoxN4MnZ/HN0NM
 LGf6GyNXa6oKmcNvM0uM/j4=
X-Google-Smtp-Source: AGRyM1sSylH7Bm+JBs0J+E6rc85AJHG7sjGCqKKXg6ib01R2aWpzXEOJ/VscmDq2T5u7SQzG9Q/ALQ==
X-Received: by 2002:a05:6402:430f:b0:42e:2a86:abaf with SMTP id
 m15-20020a056402430f00b0042e2a86abafmr5027442edc.194.1655914471604; 
 Wed, 22 Jun 2022 09:14:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 kx8-20020a170907774800b006ff802baf5dsm9520007ejc.54.2022.06.22.09.13.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jun 2022 09:14:31 -0700 (PDT)
Message-ID: <4665c87b-4983-7e15-9262-290d2969b10f@redhat.com>
Date: Wed, 22 Jun 2022 18:13:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 20/22] KVM: x86/mmu: Refactor drop_large_spte()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-21-dmatlack@google.com> <Yqy1v59ZDJ7EkCix@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yqy1v59ZDJ7EkCix@google.com>
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

On 6/17/22 19:11, Sean Christopherson wrote:
> since the shortlog is already
> a somewhat vague "do a refactor", I vote to opportunistically:
> 
>    - rename drop_large_spte() to drop_spte_if_huge()
>    - rename __drop_large_spte() to drop_huge_spte()
>    - move "if (!is_large_pte(*sptep))" to drop_spte_if_huge() since the split path
>      should never pass in a non-huge SPTE.
> 
> That last point will also clean up an oddity with with "flush" parameter; given
> the command-like name of "flush", it's a bit weird that __drop_large_spte() doesn't
> flush when the SPTE is large.

Even better, drop_large_spte() is always called right before 
kvm_mmu_get_child_sp(), so:

 From 86a9490972a1e959a4df114678719494b5475720 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 Jun 2022 12:11:44 -0400
Subject: [PATCH] KVM: MMU: pull drop_large_spte into kvm_mmu_get_child_sp

Before allocating a child shadow page table, all callers need to
check whether the parent already points to a huge page and, if so,
drop it.  This is done by drop_large_spte(), but it can be moved
to kvm_mmu_get_child_sp().

To ensure that the shadow page is not linked twice if it was
present, do _not_ opportunistically make kvm_mmu_get_child_sp()
idempotent: instead, return an error value if the shadow page
already existed.  This is a bit more verbose, but clearer than
NULL.

Now that the drop_large_spte() name is not taken anymore,
remove the two underscores in front of __drop_large_spte().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 36bc49f08d60..7f52870ee062 100644
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
@@ -2221,6 +2211,13 @@ static struct kvm_mmu_page 
*kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
  {
  	union kvm_mmu_page_role role;

+	if (is_shadow_present_pte(*sptep)) {
+		if (!is_large_pte(*sptep))
+			return ERR_PTR(-EEXIST);
+
+		drop_large_spte(vcpu->kvm, sptep, true);
+	}
+
  	role = kvm_mmu_child_role(sptep, direct, access);
  	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
  }
@@ -3080,11 +3077,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault)
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
@@ -648,15 +648,13 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault,
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
@@ -685,7 +683,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault,
  		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
  			goto out_gpte_changed;

-		if (sp)
+		if (sp != ERR_PTR(-EEXIST))
  			link_shadow_page(vcpu, it.sptep, sp);
  	}

@@ -709,16 +707,15 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, 
struct kvm_page_fault *fault,

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

with the obvious patch on top to add the flush argument.

The ERR_PTR(-EEXIST) is a bit heavy, but at least conveys what's going 
on.  Thoughts?

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
