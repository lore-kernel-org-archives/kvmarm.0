Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F2040FDAD
	for <kvmarm@lists.linux.dev>; Wed, 29 Apr 2026 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777480333; cv=none; b=FUem1oLWpHwVsxO18t4C50lbQZhep7aSYoFp2ydZr48LpKLtCnXc0Yhzh1pyagY0uEcJEl1Op9y53cpvr55XcGrOOwgwPD+XIgEBEgOWp+vhp8em3q9hWVjK8UdAmX2ZdfJMXkglyyTB2RLpR1XHwAkWqSDwjo7dtrQhNJSHKXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777480333; c=relaxed/simple;
	bh=7gqu4PQqrn1R8ym/Xqh26xdxHzA5cS34NP+aRH2NwN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXHAmVZcXrNUerl28KBFQQOgPJwer0wsJbQnyvM600x7UHqOs5zz8vpkGn7DS/fB9LyjNqF1KNJT3n6b4kNF9cwCB7LsNxCxls/ZebFdflfG60TXyEupDI0v+6h6W0kw8CC87P0mT+az5QfeQJR5BQXnhnuNVX0e7lWy/SF1mtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mu78sIiA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mu78sIiA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCE6F1650;
	Wed, 29 Apr 2026 09:32:02 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20EC43F62B;
	Wed, 29 Apr 2026 09:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777480328; bh=7gqu4PQqrn1R8ym/Xqh26xdxHzA5cS34NP+aRH2NwN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mu78sIiAkW97lmiEfkR9ZCKhkxNbAXzEchGuyoL2kvFLavGBWoVPKFdf/i3cVERcQ
	 QDP+dpEPcDhIUhlYoS/W3LXt9Yuw1J8ewLE3adt9m8YTEO9v5LgF2S1r6lrRlo+p5u
	 C8iqSmm5BYzyxDqUMKxKw+Hgg0j6qww3darcFKd8=
Date: Wed, 29 Apr 2026 17:31:57 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/1] KVM: arm64: nv: Avoid full shadow s2 unmap
Message-ID: <eedvu6ejufv6hstymyh4atnfynjolfyabkxqtgffoudiz26nxy@rbhpc22apzei>
References: <20260411125024.3735989-1-weilin.chang@arm.com>
 <20260411125024.3735989-2-weilin.chang@arm.com>
 <86eckg39eo.wl-maz@kernel.org>
 <tozhyzmwfddgx5fgfejracv6tskgs7xhs4fs6yvmvff74m7gwy@eq3oh35tokj4>
 <867bq72n7l.wl-maz@kernel.org>
 <n4v252jehdq4sn2ux26twudmvmfwjltxkvv6sa6rxtwbvqa2en@xp2oaodm7uqc>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n4v252jehdq4sn2ux26twudmvmfwjltxkvv6sa6rxtwbvqa2en@xp2oaodm7uqc>

On Fri, Apr 24, 2026 at 08:45:24PM +0100, Wei-Lin Chang wrote:
> On Thu, Apr 16, 2026 at 11:50:38AM +0100, Marc Zyngier wrote:
> > On Thu, 16 Apr 2026 00:05:40 +0100,
> > Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > > 
> > > On Wed, Apr 15, 2026 at 09:38:55AM +0100, Marc Zyngier wrote:
> > 
> > [...]
> > 
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index 851f6171751c..a97bd461c1e1 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
> > > > >  	 */
> > > > >  	bool	nested_stage2_enabled;
> > > > >  
> > > > > +	/* canonical IPA to nested IPA range lookup */
> > > > > +	struct maple_tree nested_revmap_mt;
> > > > > +	bool	nested_revmap_broken;
> > > > > +
> > > > 
> > > > Consider moving this boolean next to the other ones so that you don't
> > > > create too many holes in the kvm_s2_mmu structure (use pahole to find out).
> > > > 
> > > > But I have some misgivings about the way things are structured
> > > > here. Only NV needs a revmap, yet this is present irrelevant of the
> > > > nature of the VM and bloats the data structure a bit.
> > > > 
> > > > My naive approach would have been to only keep a pointer to the
> > > > revmap, and make that pointer NULL when the tree is "broken", and
> > > > freed under RCU if the context isn't the correct one.
> > > 
> > > Can you explain what you mean by "if the context isn't the correct one"?
> > > If this refers to when selecting a specific kvm_s2_mmu instance for
> > > another context, then IIUC refcnt would already be 0 and there would be
> > > no other user of the tree.
> > 
> > Sorry, "context" is an overloaded word. I meant a situation in which
> > you couldn't immediately free the maple-tree because you're holding
> > locks and freeing (hypothetically) requires a sleeping "context". in
> > this case, freeing under RCU, purely as a deferring mechanism, might
> > be useful.
> 
> I experimented using RCU to free the tree as a deferring mechanism.
> Here are a few observations:
> 
>   - At reverse map record time, if maple tree store fails, we have to
>     change the maple tree pointer to a NULL, which is an RCU write
>     operation. Therefore we need to either take another lock, or use a
>     xchg(ptr, NULL) to avoid the lock.
> 
>   - Because we're holding the read-side mmu_lock, we shouldn't block
>     during reverse map record. Therefore we should use call_rcu()
>     instead of synchronize_rcu() to free the "broken" tree. This implies
>     a pointer to a maple tree in kvm_s2_mmu will not suffice, an
>     additional structure with both the maple tree and an rcu_head have
>     to be created.
> 
> IMO looking at RCU calls mixed with mtree_{, un}lock(), and having a new
> wrapper struct to make this dynamic allocation scheme work is not very
> attractive to me.
> 
> Instead, what do you think if I aggregate all strictly NV-related
> fields in kvm_s2_mmu i.e. tlb_vttbr, tlb_vtcr, nested_stage2_enabled,
> shadow_pt_debugfs_dentry, pending_unmap, into a struct maybe called
> kvm_s2_mmu_nested, add a maple tree in it, and have a pointer to this
> struct in kvm_s2_mmu? kvm_s2_mmu_nested can then be allocated only if we
> init a nested s2 mmu.
> 
> Do you think this can work and is better than the current approaches?

After a discussion with Marc, we think making the maple tree a pointer
generates too much complexity from the reasons given above. For the
kvm_s2_mmu_nested idea, it creates churn and the same RCU problem
persists if we want to dynamically allocate and free the structure. On
the other hand, if we allocated kvm_s2_mmu_nested at init-time and reuse
the struct, then it's not much difference than just placing the maple
tree in kvm_s2_mmu, the only benefit will be keeping kvm_s2_mmu smaller
for non nested MMUs.

I'll stick with just adding the maple tree instance in kvm_s2_mmu for
the next version.

Thanks,
Wei-Lin Chang

[...]
