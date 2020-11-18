Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552B1C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 17:06:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76B212486E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 17:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRwiY3v9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76B212486E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4B3D4BA32;
	Wed, 18 Nov 2020 12:06:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zFv6+bmaNp9d; Wed, 18 Nov 2020 12:06:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BAD44BA0F;
	Wed, 18 Nov 2020 12:06:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 125284B98C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 12:06:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GQEjHizBlvvG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 12:06:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBC4E4B702
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 12:06:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605719168;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=znOvFVbpSljE+gP6YbD+IOXgKYlAvuPgXm75WCYUueE=;
 b=gRwiY3v9DwBkmyipKGGiQpmF13+iJjUTirezmAG9AjJPukvbJkrbP1m1CKvww9IUKKdFxb
 v3HKhXOzYs9Tbs1ExK4QgjF2DfBar6WIkqA9GY4Mt/Cxrb7VaYgHSsH2SBIe/snsMUNZae
 mp2GOJJwzDTstFg4mhkTl60MOMS7O+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-m6xE8JiTMIaZwlzsEo4lGg-1; Wed, 18 Nov 2020 12:06:04 -0500
X-MC-Unique: m6xE8JiTMIaZwlzsEo4lGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BAA86D249;
 Wed, 18 Nov 2020 17:06:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.150])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E972C6091A;
 Wed, 18 Nov 2020 17:05:55 +0000 (UTC)
Date: Wed, 18 Nov 2020 18:05:52 +0100
From: Andrew Jones <drjones@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 2/2] arm64: kvm: Introduce MTE VCPU feature
Message-ID: <20201118170552.cuczyylf34ows5jd@kamzik.brq.redhat.com>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-3-steven.price@arm.com>
 <X7P1VLZhBh045tsr@trantor>
 <f34b3d16-8bc7-af9d-c0e0-fb114d2465aa@arm.com>
 <X7VQua7YO4isMFPU@trantor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <X7VQua7YO4isMFPU@trantor>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: qemu-devel@nongnu.org, Marc Zyngier <maz@kernel.org>,
 Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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

On Wed, Nov 18, 2020 at 04:50:01PM +0000, Catalin Marinas wrote:
> On Wed, Nov 18, 2020 at 04:01:20PM +0000, Steven Price wrote:
> > On 17/11/2020 16:07, Catalin Marinas wrote:
> > > On Mon, Oct 26, 2020 at 03:57:27PM +0000, Steven Price wrote:
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 19aacc7d64de..38fe25310ca1 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -862,6 +862,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >   	if (vma_pagesize == PAGE_SIZE && !force_pte)
> > > >   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> > > >   							   &pfn, &fault_ipa);
> > > > +
> > > > +	/*
> > > > +	 * The otherwise redundant test for system_supports_mte() allows the
> > > > +	 * code to be compiled out when CONFIG_ARM64_MTE is not present.
> > > > +	 */
> > > > +	if (system_supports_mte() && kvm->arch.mte_enabled && pfn_valid(pfn)) {
> > > > +		/*
> > > > +		 * VM will be able to see the page's tags, so we must ensure
> > > > +		 * they have been initialised.
> > > > +		 */
> > > > +		struct page *page = pfn_to_page(pfn);
> > > > +		long i, nr_pages = compound_nr(page);
> > > > +
> > > > +		/* if PG_mte_tagged is set, tags have already been initialised */
> > > > +		for (i = 0; i < nr_pages; i++, page++) {
> > > > +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> > > > +				mte_clear_page_tags(page_address(page));
> > > > +		}
> > > > +	}
> > > 
> > > If this page was swapped out and mapped back in, where does the
> > > restoring from swap happen?
> > 
> > Restoring from swap happens above this in the call to gfn_to_pfn_prot()
> 
> Looking at the call chain, gfn_to_pfn_prot() ends up with
> get_user_pages() using the current->mm (the VMM) and that does a
> set_pte_at(), presumably restoring the tags. Does this mean that all
> memory mapped by the VMM in user space should have PROT_MTE set?
> Otherwise we don't take the mte_sync_tags() path in set_pte_at() and no
> tags restored from swap (we do save them since when they were mapped,
> PG_mte_tagged was set).
> 
> So I think the code above should be similar to mte_sync_tags(), even
> calling a common function, but I'm not sure where to get the swap pte
> from.
> 
> An alternative is to only enable HCR_EL2.ATA and MTE in guest if the vmm
> mapped the memory with PROT_MTE.

This is a very reasonable alternative. The VMM must be aware of whether
the guest may use MTE anyway. Asking it to map the memory with PROT_MTE
when it wants to offer the guest that option is a reasonable requirement.
If the memory is not mapped as such, then the host kernel shouldn't assume
MTE may be used by the guest, and it should even enforce that it is not
(by not enabling the feature).

Thanks,
drew

> 
> Yet another option is to always call mte_sync_tags() from set_pte_at()
> and defer the pte_tagged() or is_swap_pte() checks to the MTE code.
> 
> -- 
> Catalin
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
