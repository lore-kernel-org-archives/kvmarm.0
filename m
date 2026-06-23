Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F96274B2A;
	Tue, 23 Jun 2026 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782225035; cv=none; b=PhlXhwBJnmrkEwnFmapNaFfmpDoQCOkXR7EvOI+jdPdQFKMfkbJZnM2L+CikivgYtSEtPv/wbMG9jl9izUITUNsNzcXM0+PV2KJiINfXwWN0vZ2iTJg278uxc2nDiPaUFOlHQvTOdC9ZcvkCXYjL+d0DG279aqA+z11YheA3sJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782225035; c=relaxed/simple;
	bh=ECqFmYpn1Tvi3Ve6+KghQstgyfmV9tNUx8IpObyj9RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncJ4BlrVoWkbjzZuslg1gopQFxQ+YE9HoZPjUQNtwZMxf+ubEzcW29RbSmEb6bmdOJFz7/NgPQz+F9JxRW6JA1iqoIX3RbivoG7WR93TWNLhSwiVa4pysefwI9LIfL3jnkR+S6Csuxrud6kM0/Gv1tRQNCG6BS2sCLhp7yBRodk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOq6/lfV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOq6/lfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DDB1F000E9;
	Tue, 23 Jun 2026 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782225033;
	bh=EiMUeIi8y+epZU6HAqV2r+psiszsXZEBuLE/WMc5IQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KOq6/lfV8oHFwgOQtqizFAEjGigvyNnrPPPME4rJ7fQBPAT9y43B4VikWd9fOhh15
	 Emasy8nRZyC1mHi65PJVFwzg5HqMoLO7WzdtjCw1mNN0EnciTOZGLinXjJHLuWoo0G
	 8w/JCqCYYdtlVF4dMvmYjFO2Dp6sZLayyMtlKthRwEVLLihq+f9/KBCEvkn1SegSgz
	 K9yUBNzPgfXp7pt4IgPlimzWgvJGQwD4BYm5zQX2Oy8tYD1YfAWGQvrUM6GVkpQjaB
	 +zMJc/KUkgD9W/fTzsrVjEC47zFO3HiWkdUXTqz43hXnGRNfomnFMhuGy8OOVZi/5B
	 JebptHaUkz79Q==
Date: Tue, 23 Jun 2026 15:30:28 +0100
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
Message-ID: <ajqYhOU6A1hdqTxO@willie-the-truck>
References: <20260621213155.6019-1-include@grrlz.net>
 <86zf0nq8ki.wl-maz@kernel.org>
 <ajqNANUBCamSjfHM@willie-the-truck>
 <86se6dqsav.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86se6dqsav.wl-maz@kernel.org>

On Tue, Jun 23, 2026 at 02:50:48PM +0100, Marc Zyngier wrote:
> On Tue, 23 Jun 2026 14:41:20 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Mon, Jun 22, 2026 at 09:32:29AM +0100, Marc Zyngier wrote:
> > > On Sun, 21 Jun 2026 22:31:55 +0100,
> > > Bradley Morgan <include@grrlz.net> wrote:
> > > > 
> > > > Protected guest faults charge long term pins to the VM's mm. Teardown
> > > > can run later from file release, where current->mm may be unrelated.
> > > >
> > > > Drop the charge from kvm->mm instead.
> > > > 
> > > > Fixes: 4e6e03f9eadd ("KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()")
> > > > Signed-off-by: Bradley Morgan <include@grrlz.net>
> > > > ---
> > > >  arch/arm64/kvm/pkvm.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > > index 053e4f733e4b..428723b1b0f5 100644
> > > > --- a/arch/arm64/kvm/pkvm.c
> > > > +++ b/arch/arm64/kvm/pkvm.c
> > > > @@ -352,7 +352,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
> > > >  		page = pfn_to_page(mapping->pfn);
> > > >  		WARN_ON_ONCE(mapping->nr_pages != 1);
> > > >  		unpin_user_pages_dirty_lock(&page, 1, true);
> > > > -		account_locked_vm(current->mm, 1, false);
> > > > +		account_locked_vm(kvm->mm, 1, false);
> > > >  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> > > >  		kfree(mapping);
> > > >  	}
> > > 
> > > Seems correct to me, as the final mmdrop(kvm->mm) occurs after S2
> > > teardown.
> > > 
> > > Will, what do you think?
> > 
> > Thanks, this looks correct to me.
> > 
> > While I was thinking about it, I also started looking at the use of
> > 'current->mm' in kvm_arch_prepare_memory_region() in case that should
> > also be 'kvm->mm'. However, I then realised that I don't really grok
> > that code at all because it does a bunch of checking on the VMAs with
> > mmap_read_lock(current->mm) held, but then that lock is dropped
> > immediately after doing the checks so I'm not really sure what they
> > are protected against. Presumably, the address space could be modified
> > as soon as the lock is dropped?
> > 
> > But it's hot, so I'm probably missing something here.
> 
> I think this is just trying to catch a few obvious issues, such as
> dirty logging on device memory, but that only works for well behaved
> userspace that is making "a honest mistake".
> 
> For the more trying ones, we end-up doing the same checks again at
> fault time anyway.

Got it, so it's a best-effort check. Although it does mean that memslot
changes have to be done by the same mm as kvm->mm, otherwise you could
get a spurious error back from the kernel.

Will
