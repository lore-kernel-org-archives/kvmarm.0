Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD817C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Apr 2022 20:12:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B924B0B4;
	Mon, 11 Apr 2022 16:12:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bp7XRRmTXxMK; Mon, 11 Apr 2022 16:12:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A294B1A3;
	Mon, 11 Apr 2022 16:12:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5312549EB4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 16:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n3Av57ipzkG7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2022 16:12:47 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DD5A49E57
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 16:12:47 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id n18so14823776plg.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 13:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wLQzPAe6pyjRg5XiF99tjyaUc0WTeJb+T6qbrWIkFcE=;
 b=teoNyc2n+lT+vKWWF2jxuNeY7aDRxPR5rtXU+q3Xz9/jFG/UyVkzNoyfhjL0v6T/6s
 NKILWL8dLo4S/a3Cyh5GoUmQJFvHFaT22JqolFQ/R9aXE0WCkjMKjKFnJPAQtXr2FKCr
 SaAkB9lDGUm85hO6A0CilBbr+m/RRHArTZ0RYPsMeyztw07h/yhoY/2zjYzP4XTuNbov
 Hb41Va996j+uUx/75VOCNdkwL3s22dDpx3u4+A1J13GB0alNEdAzSVMVZEVVGOo+36P9
 vvnT8ulduwaI2VneasObplDiF0D0hr6bu+x7NHpJPBGc/vp8rPDsRIzL44UCah9Zxd6Z
 4Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wLQzPAe6pyjRg5XiF99tjyaUc0WTeJb+T6qbrWIkFcE=;
 b=75MnlaLgMtiFiwZKVIlb6zaLzu9pwJcp6p4lg9+GUpZ9K7Jgd2Cx3i//UVb84tRx0u
 ugwlWMmc8nrIBhyUqVubjrmrH8i8BxZRvI9ZXl0AWvCwrziefYiKQcFJawarbG2MdD25
 mnv2ZFssdTlaDIxS8KYnn6dKCCBOA/KyvE5qZh5mfg6gM2c9/5utnlPt1wmjYUctxdPT
 gBUbAOKHFqIlEtJ3FFYjHkC/QNX4KPtDzomY1xJEFScEFH1IXxVpc9+a0njo6KfrP7XQ
 RbE1H4qURl8s+4iizzZIcGvj9kpgNlKkOo15xWfU5V5cvvuBJMWTFT+HRRdVggpGsZKU
 u6Kw==
X-Gm-Message-State: AOAM533Zrg1+TywK9KIcE0BV+UeywfWePpmFTcr8kuPwmRdxTJXjt3a5
 LqZEH0fiJ7FMq8hFBMAw+r0ThA==
X-Google-Smtp-Source: ABdhPJyMwroHdQl0yrQRu74auN6bH8pc+j1ezfBTcqbjfSeirt4m78ErqrMT+UGt7bh8fX/aSvc+sQ==
X-Received: by 2002:a17:902:ef46:b0:153:81f7:7fc2 with SMTP id
 e6-20020a170902ef4600b0015381f77fc2mr34277650plx.26.1649707966168; 
 Mon, 11 Apr 2022 13:12:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 t69-20020a637848000000b0039831d6dc23sm495967pgc.94.2022.04.11.13.12.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Apr 2022 13:12:45 -0700 (PDT)
Date: Mon, 11 Apr 2022 20:12:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlSLuZphElMyF2sG@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
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

On Mon, Apr 11, 2022, David Matlack wrote:
> On Mon, Apr 11, 2022 at 10:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > Circling back to eager page splitting, this series could be reworked to take the
> > first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
> > order to provide the necessary path for reworking nested MMU page faults.  Then it
> > can remove unsync and shrinker support for nested MMUs.  With those gone,
> > dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
> > than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
> > some of the complexity/churn.
> 
> These sound like useful improvements but I am not really seeing the
> value of sequencing them before this series:
> 
>  - IMO the "churn" in patches 1-14 are a net improvement to the
> existing code. They improve readability by decomposing the shadow page
> creation path into smaller functions with better names, reduce the
> amount of redundant calculations, and reduce the dependence on struct
> kvm_vcpu where it is not needed. Even if eager page splitting is
> completely dropped I think they would be useful to merge.

I definitely like some of patches 1-14, probably most after a few read throughs.
But there are key parts that I do not like that are motivated almost entirely by
the desire to support page splitting.  Specifically, I don't like splitting the
logic of finding a page, and I don't like having a separate alloc vs. initializer
(though I'm guessing this will be needed somewhere to split huge pages for nested
MMUs).

E.g. I'd prefer the "get" flow look like the below (completely untested, for
discussion purposes only).  There's still churn, but the core loop is almost
entirely unchanged.

And it's not just this series, I don't want future improvements nested TDP to have
to deal with the legacy baggage.

Waaaay off topic, why do we still bother with stat.max_mmu_page_hash_collision?
I assume it was originally added to tune the hashing logic?  At this point is it
anything but wasted cycles?

static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
						     gfn_t gfn,
						     unsigned int gfn_hash,
						     union kvm_mmu_page_role role)
{
	struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];
	struct kvm_mmu_page *sp;
	LIST_HEAD(invalid_list);

	int collisions = 0;

	for_each_valid_sp(kvm, sp, sp_list) {
		if (sp->gfn != gfn) {
			collisions++;
			continue;
		}

		if (sp->role.word != role.word) {
			/*
			 * If the guest is creating an upper-level page, zap
			 * unsync pages for the same gfn.  While it's possible
			 * the guest is using recursive page tables, in all
			 * likelihood the guest has stopped using the unsync
			 * page and is installing a completely unrelated page.
			 * Unsync pages must not be left as is, because the new
			 * upper-level page will be write-protected.
			 */
			if (role.level > PG_LEVEL_4K && sp->unsync)
				kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);

			continue;
		}

		/* unsync and write-flooding only apply to indirect SPs. */
		if (sp->role.direct)
			goto out;

		if (sp->unsync) {
			/*
			 * The page is good, but is stale.  kvm_sync_page does
			 * get the latest guest state, but (unlike mmu_unsync_children)
			 * it doesn't write-protect the page or mark it synchronized!
			 * This way the validity of the mapping is ensured, but the
			 * overhead of write protection is not incurred until the
			 * guest invalidates the TLB mapping.  This allows multiple
			 * SPs for a single gfn to be unsync.
			 *
			 * If the sync fails, the page is zapped.  If so, break
			 * in order to rebuild it.
			 */
			if (!kvm_sync_page(vcpu, sp, &invalid_list))
				break;

			WARN_ON(!list_empty(&invalid_list));
			kvm_flush_remote_tlbs(vcpu->kvm);
		}

		__clear_sp_write_flooding_count(sp);
		goto out;
	}

	sp = NULL;

out:
	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
		kvm->stat.max_mmu_page_hash_collisions = collisions;

	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
	return sp;
}

static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
						      gfn_t gfn,
						      unsigned int gfn_hash,
						      union kvm_mmu_page_role role)
{
	struct kvm_mmu_page *sp = __kvm_mmu_alloc_shadow_page(vcpu, role.direct);
	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
	struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];

	++kvm->stat.mmu_cache_miss;

	sp->gfn = gfn;
	sp->role = role;
	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;

	/*
	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
	 * depends on valid pages being added to the head of the list.  See
	 * comments in kvm_zap_obsolete_pages().
	 */
	list_add(&sp->link, &kvm->arch.active_mmu_pages);
	kvm_mod_used_mmu_pages(kvm, 1);

	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
	hlist_add_head(&sp->hash_link, sp_list);

	if (!role.direct)
		account_shadowed(kvm, slot, sp);
}


static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
						    gfn_t gfn,
						    union kvm_mmu_page_role role)
{
	unsigned int gfn_hash = kvm_page_table_hashfn(gfn);
	struct kvm_mmu_page *sp;
	bool created = false;

	sp = kvm_mmu_find_shadow_page(vcpu, gfn, gfn_hash, role);
	if (!sp) {
		created = true;
		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, gfn_hash, role);
	}

	trace_kvm_mmu_get_page(sp, created);
	return sp;
}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
