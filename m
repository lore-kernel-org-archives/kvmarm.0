Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E56C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 09:03:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 097F5207DE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 09:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsDw5AKj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 097F5207DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE9F4B9AA;
	Wed, 19 Aug 2020 05:03:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4xKSL08rt+-Z; Wed, 19 Aug 2020 05:03:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6064E4B993;
	Wed, 19 Aug 2020 05:03:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C9D4B993
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 05:03:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id reb50lAkGikL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 05:03:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8C644B990
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 05:03:25 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9FAC62072D;
 Wed, 19 Aug 2020 09:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597827804;
 bh=8kMWMJqJUJqNeM/ruIfhFAMr0aImeONy4Dxz30p1h+k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=QsDw5AKjG2Ub121PVC7oJ2IZHerVgrzG6ds/tRSZtWbMP36/uoAF7wLu5getqMiDt
 8Gq/fPoNCj8tmvzUB7+rHLajdSvO/3h5FYmvC4+TpHmbTAHrqHDqeDvZb4tF3PINH8
 zMVh5xcJ7rdAPaF5ULeMz4SGzLedvY2FQxYbVvkg=
Date: Wed, 19 Aug 2020 10:03:20 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 01/22] KVM: arm64: Don't free memcache pages in
 kvm_phys_addr_ioremap()
Message-ID: <20200819090320.GA17517@willie-the-truck>
References: <20200818132818.16065-1-will@kernel.org>
 <20200818132818.16065-2-will@kernel.org>
 <47f7bfc2-1880-908f-4345-b25da500b0ff@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <47f7bfc2-1880-908f-4345-b25da500b0ff@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

Hi Gavin,

Cheers for taking a look.

On Wed, Aug 19, 2020 at 02:38:39PM +1000, Gavin Shan wrote:
> On 8/18/20 11:27 PM, Will Deacon wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 662b0c99a63d..4a24ebdc6fc6 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1489,19 +1489,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >   		ret = kvm_mmu_topup_memory_cache(&cache,
> >   						 kvm_mmu_cache_min_pages(kvm));
> >   		if (ret)
> > -			goto out;
> > +			break;
> >   		spin_lock(&kvm->mmu_lock);
> >   		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
> >   				     KVM_S2PTE_FLAG_IS_IOMAP);
> >   		spin_unlock(&kvm->mmu_lock);
> >   		if (ret)
> > -			goto out;
> > +			break;
> >   		pfn++;
> >   	}
> > -out:
> > -	kvm_mmu_free_memory_cache(&cache);
> >   	return ret;
> >   }
> 
> It seems incorrect. The cache is tracked by local variable (@cache),
> meaning the cache is only visible to kvm_phys_addr_ioremap() and its
> callee. So it's correct to free unused pages in two cases: (1) error
> is returned (2) high level of page tables were previously populated
> and not all pre-allocated pages are used. Otherwise, this leads to
> memory leakage.

Well spotted, you're completely right. I was _sure_ this was the vCPU
memcache and I even said as much in the commit meesage, but it's not, and it
never was, so I can drop this patch. If there are any other patches I can
drop in the series, please let me know! I did test with kmemleak enabled,
but I guess that doesn't track page allocations into the memcache.

It _might_ be an idea to have a per-VM memcache to handle these allocations,
as that might offer some reuse over sticking one on the stack each time, but
then again kvm_phys_addr_ioremap() is hardly a fastpath.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
