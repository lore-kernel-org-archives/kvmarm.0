Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145DCC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 31 May 2022 16:46:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 669574B332;
	Tue, 31 May 2022 12:46:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2BnrbfDzB4Gh; Tue, 31 May 2022 12:46:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD424B38D;
	Tue, 31 May 2022 12:46:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C2B4B24F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 12:46:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id avMVRCtEZx+2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2022 12:46:01 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F14A749F3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 12:46:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 89CBFB80E71;
 Tue, 31 May 2022 16:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06729C385A9;
 Tue, 31 May 2022 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654015558;
 bh=UgFmzqyIOVV3Z6q57AM1Z6rN2JFZWxu+WYJ+ydi4GkY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=NbQCV3E8FhGa58tJhMBnjaAXMeC48imlaJ31TzT5+bXbjsrJuqOdVdO/yoQxjT0ZP
 O+NW8rdwGmQiFL+mp6RcYPRakJtSeVCU3AwPNt0cFTsoro0HZOm5S36NnneSF/Ez4q
 zUQqsEKZ3u4NHgdiOT5PPpETtrAuN4rKCY7fyyh6g9DDlNv4SEhAP3HmmztGzhYkdR
 o4KnJde+DdVBmSny/sG0cRpK14FwC+LHRi94BaXlOQcZh75Kt/3eqUirVuxoDf7zRv
 nec8h/tFY/kwWhaMuY1dV4UyRJTyaYChVLcGVbedt1V39CshsIGmNo1zegPx+F9C7b
 x+VOb6X9oGUmQ==
Date: Tue, 31 May 2022 17:45:51 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 33/89] KVM: arm64: Handle guest stage-2 page-tables
 entirely at EL2
Message-ID: <20220531164550.GA25631@willie-the-truck>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-34-will@kernel.org>
 <Yoe70WC0wJg0Vcon@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yoe70WC0wJg0Vcon@monolith.localdoman>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, May 20, 2022 at 05:03:29PM +0100, Alexandru Elisei wrote:
> On Thu, May 19, 2022 at 02:41:08PM +0100, Will Deacon wrote:
> > Now that EL2 is able to manage guest stage-2 page-tables, avoid
> > allocating a separate MMU structure in the host and instead introduce a
> > new fault handler which responds to guest stage-2 faults by sharing
> > GUP-pinned pages with the guest via a hypercall. These pages are
> > recovered (and unpinned) on guest teardown via the page reclaim
> > hypercall.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> [..]
> > +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +			  unsigned long hva)
> > +{
> > +	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
> > +	struct mm_struct *mm = current->mm;
> > +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> > +	struct kvm_pinned_page *ppage;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct page *page;
> > +	u64 pfn;
> > +	int ret;
> > +
> > +	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(kvm));
> > +	if (ret)
> > +		return -ENOMEM;
> > +
> > +	ppage = kmalloc(sizeof(*ppage), GFP_KERNEL_ACCOUNT);
> > +	if (!ppage)
> > +		return -ENOMEM;
> > +
> > +	ret = account_locked_vm(mm, 1, true);
> > +	if (ret)
> > +		goto free_ppage;
> > +
> > +	mmap_read_lock(mm);
> > +	ret = pin_user_pages(hva, 1, flags, &page, NULL);
> 
> When I implemented memory pinning via GUP for the KVM SPE series, I
> discovered that the pages were regularly unmapped at stage 2 because of
> automatic numa balancing, as change_prot_numa() ends up calling
> mmu_notifier_invalidate_range_start().
> 
> I was curious how you managed to avoid that, I don't know my way around
> pKVM and can't seem to find where that's implemented.

With this series, we don't take any notice of the MMU notifiers at EL2
so the stage-2 remains intact. The GUP pin will prevent the page from
being migrated as the rmap walker won't be able to drop the mapcount.

It's functional, but we'd definitely like to do better in the long term.
The fd-based approach that I mentioned in the cover letter gets us some of
the way there for protected guests ("private memory"), but non-protected
guests running under pKVM are proving to be pretty challenging (we need to
deal with things like sharing the zero page...).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
