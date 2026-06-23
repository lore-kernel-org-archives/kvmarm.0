Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF332030A;
	Tue, 23 Jun 2026 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222087; cv=none; b=d3DDdg/biX/K6a1a0zd8SLBuz6wHfSN11JSgs3+z5j03abNHKH1o5FKXJ3ehAqZSBGAwWj1THui/hRbNtLwKqxuCQWsNfftsajbc/CJlyBAfiEwDiXv8/oxT8E1O1jArvWEn19eOYKi49SuCYfXWHfVp4O4xZLr2YYb03RgjNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222087; c=relaxed/simple;
	bh=Ypha0HlD7gWOuCqOeaDEkQj3QFZ2MURQE+LmNmFfcgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJLPPcOdH1ds/B7H+c06WuYYabZek6KaM2VT2Am/a9kPsGHEQJPZU/qqKkPIBenYqQAoESHxyC+3zPhd9SeiitdpuHhQQGzcslal5Ss54SoMVeXeQ3HkSNpqcm1Swu5DvmDdV6KYY1K67oslMfLnSbWdRe1fng8JGd1miYLvH3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXbopI0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXbopI0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B6D1F000E9;
	Tue, 23 Jun 2026 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782222086;
	bh=kLocRZtgJQrXu8puX2IARJTbaE2vJiBP6Inefq8Js9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XXbopI0WMvFSOjNicyQp1LnWaauZ6NqDakJ+P3eOgS9o3Hz2ORPTemdjngrG9k6gX
	 f+BqBl6JMkIaMmjrsHDa+vD2LlgrT402yrETUBwfGKjULMDZHa0os6w5Ha3bv8eUDT
	 QX4Olm+gSOhh639G74c8wcRSRMCuRkqKrchM+jeQGpQqfe/294UMEy6KjSfwWeTXfL
	 kKCWyqwatfCW9gFEjsyxj05pVCCgYeNmRN0/3L8q1bJm4L8RQu5rSRICGGRC0HB65L
	 ZvLQGL2WXOAbo8+Z8DoSjVlZY+kZNChrFET3Gyt+WELKRzuk5TM1sLscYwhnqnTiD8
	 8CUjY6VN1xTvQ==
Date: Tue, 23 Jun 2026 14:41:20 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Bradley Morgan <include@grrlz.net>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
Message-ID: <ajqNANUBCamSjfHM@willie-the-truck>
References: <20260621213155.6019-1-include@grrlz.net>
 <86zf0nq8ki.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zf0nq8ki.wl-maz@kernel.org>

On Mon, Jun 22, 2026 at 09:32:29AM +0100, Marc Zyngier wrote:
> On Sun, 21 Jun 2026 22:31:55 +0100,
> Bradley Morgan <include@grrlz.net> wrote:
> > 
> > Protected guest faults charge long term pins to the VM's mm. Teardown
> > can run later from file release, where current->mm may be unrelated.
> >
> > Drop the charge from kvm->mm instead.
> > 
> > Fixes: 4e6e03f9eadd ("KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()")
> > Signed-off-by: Bradley Morgan <include@grrlz.net>
> > ---
> >  arch/arm64/kvm/pkvm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 053e4f733e4b..428723b1b0f5 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -352,7 +352,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
> >  		page = pfn_to_page(mapping->pfn);
> >  		WARN_ON_ONCE(mapping->nr_pages != 1);
> >  		unpin_user_pages_dirty_lock(&page, 1, true);
> > -		account_locked_vm(current->mm, 1, false);
> > +		account_locked_vm(kvm->mm, 1, false);
> >  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> >  		kfree(mapping);
> >  	}
> 
> Seems correct to me, as the final mmdrop(kvm->mm) occurs after S2
> teardown.
> 
> Will, what do you think?

Thanks, this looks correct to me.

While I was thinking about it, I also started looking at the use of
'current->mm' in kvm_arch_prepare_memory_region() in case that should
also be 'kvm->mm'. However, I then realised that I don't really grok
that code at all because it does a bunch of checking on the VMAs with
mmap_read_lock(current->mm) held, but then that lock is dropped
immediately after doing the checks so I'm not really sure what they
are protected against. Presumably, the address space could be modified
as soon as the lock is dropped?

But it's hot, so I'm probably missing something here.

Will
