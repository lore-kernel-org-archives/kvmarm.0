Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CA134252C
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 09:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070784; cv=none; b=K5cIvv0v1sT9vhzzVHDIP6DnjQj33Kod0PWkcxoN+Efkx8897iL+xlookwheaZpgb7L9yh7JWe4QdUvWJdQMwPYCfDXetyMpUNkgysKJMX+RMIindz9I25+MY0kzd1rHg7wspAcqLhxclDzNG4KBTl/4YG5gm+jwr34d3WhNQfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070784; c=relaxed/simple;
	bh=4r3qWx8Ds3/hTzzeotmLLuGM39MujgZ6TSswYYw5CB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlALUsmkOU8uJCGMaqZw4A7BYx0geoC230k1wYfXuy/DxtIUh7nVB26DrD5EJg+zNQnYF/JWYoIHCuy2dT5ghoHvt2m6TA+QQwK0Hv45zPg+f7R1NX3hDQG6fOFzwVnXq5vT/DH6gUsYPvpbyD1N1RWmduyBj3Kiaf55K4UG36Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hifszK3F; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hifszK3F"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1153A1EDB;
	Fri,  3 Jul 2026 02:26:17 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 703C73F673;
	Fri,  3 Jul 2026 02:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783070781; bh=4r3qWx8Ds3/hTzzeotmLLuGM39MujgZ6TSswYYw5CB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hifszK3FOqihx8yzRGLCoyv4ym7BMwtkSBVfHsleZsBJyYhwGoO5e7D6UuLuQzH3K
	 +lX9Hc+uNJmEDXeGtAU3M5WxL4QNakdJIEZl4N1GZuwUmyjaD+pKkJXr1VR9VEJKNY
	 BU+a7i+xtk0h9jO6dtFKe8nuQ2WsJS+93LuAV4iA=
Date: Fri, 3 Jul 2026 10:26:03 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Leonardo Bras <leo.bras@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: ptdump: Fix UAF when mmu->pgt is freed
Message-ID: <mffciffp7dx7u3kjvb6scu3tzbur34wkgndc5w2qwhmrqjtgq5@rfxk4apyhv3a>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
 <20260630121005.1130996-4-weilin.chang@arm.com>
 <akUrmfQnKmIXTigs@LeoBrasDK>
 <5yy625c66j3kgoboejg7hagnmxjzp2tvmvvncmqvo444wtpmzl@sufez6t2iy3r>
 <akZEPVJhCcYbyoN2@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZEPVJhCcYbyoN2@LeoBrasDK>

On Thu, Jul 02, 2026 at 11:58:06AM +0100, Leonardo Bras wrote:
> On Wed, Jul 01, 2026 at 06:27:51PM +0100, Wei-Lin Chang wrote:
> > On Wed, Jul 01, 2026 at 04:00:41PM +0100, Leonardo Bras wrote:
> > > Hi Wei Lin,
> > > 
> > > On Tue, Jun 30, 2026 at 01:10:02PM +0100, Wei-Lin Chang wrote:
> > > > ptdump files can still be read after the pgt of the canonical mmu is
> > > > freed, if they are opened before the VM debugfs directory is removed.
> > > > This triggers UAF in places where we cache the pgt pointer or access it
> > > > without checking its validity.
> > > > 
> > > > Check the pgt is still alive under the mmu_lock before accessing the
> > > > pgt.
> > > > 
> > > > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > > Closes: https://sashiko.dev/#/patchset/20260623142443.648972-1-weilin.chang@arm.com?part=1
> > > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > > ---
> > > >  arch/arm64/kvm/ptdump.c | 38 ++++++++++++++++++++++++--------------
> > > >  1 file changed, 24 insertions(+), 14 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > > index d5aa9eff08d1..752d8e0cd25c 100644
> > > > --- a/arch/arm64/kvm/ptdump.c
> > > > +++ b/arch/arm64/kvm/ptdump.c
> > > > @@ -115,13 +115,21 @@ static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
> > > >  static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
> > > >  {
> > > >  	struct kvm_ptdump_guest_state *st;
> > > > -	struct kvm_pgtable *pgtable = kvm->arch.mmu.pgt;
> > > > +	struct kvm_pgtable *pgtable;
> > > >  	int ret;
> > > >  
> > > >  	st = kzalloc_obj(struct kvm_ptdump_guest_state, GFP_KERNEL_ACCOUNT);
> > > >  	if (!st)
> > > >  		return ERR_PTR(-ENOMEM);
> > > >  
> > > > +	guard(write_lock)(&kvm->mmu_lock);
> > > > +	if (!kvm->arch.mmu.pgt) {
> > > > +		kfree(st);
> > > > +		return ERR_PTR(-ENXIO);
> > > > +	}
> > > > +
> > > > +	pgtable = kvm->arch.mmu.pgt;
> > > > +
> > > >  	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> > > >  	if (ret) {
> > > >  		kfree(st);
> > > > @@ -137,7 +145,6 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
> > > >  
> > > >  static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> > > >  {
> > > > -	int ret;
> > > >  	struct kvm_ptdump_guest_state *st = m->private;
> > > >  	struct kvm *kvm = st->kvm;
> > > >  	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> > > > @@ -154,11 +161,11 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> > > >  		.seq		= m,
> > > >  	};
> > > >  
> > > > -	write_lock(&kvm->mmu_lock);
> > > > -	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > > > -	write_unlock(&kvm->mmu_lock);
> > > > +	guard(write_lock)(&kvm->mmu_lock);
> > > > +	if (mmu->pgt)
> > > > +		return kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> > > 
> > > IIUC, that's the same behavior, right?
> > > Just changed to look about the same with the rest of this file?
> > 
> > I'm not too sure what you are referring to, if you mean the
> > write_lock/unlock -> guard(write_lock) change, then yes, mostly. Just
> > also checking mmu->pgt is still not freed.
> 
> I was referring just to lock+unlock -> guard() strategy.
> IIUC this has the same effect, so I was wondering on why you suggested the 
> change.
> 
> I then supposed it was to look the same of the rest of the file.

Yeah, and I believe using guard() is encouraged, since it's less error
prone.

> 
> > 
> > > 
> > > >  
> > > > -	return ret;
> > > > +	return 0;
> > > >  }
> > > 
> > > So if the pgt does not exist anymore, it returns zero. Is that the desired 
> > > behavior?
> > 
> > Good question, so the question is what contract between the ptdump and
> > user do we want to make for this case. I guess returning some error like -EIO
> > could make a little more sense than just printing nothing?
> >
> 
> It depends on what is the behaviour you want to see... see below..
>  
> > > 
> > > I guess it's aligned with the idea of single file mentioned in the cover, 
> > > right?
> > 
> > Sorry, I don't get what you are asking here?
> 
> IIUC you mentioned in the cover letter that you planned to have a file 
> which would, on read, output ptdump for every nested pgtable. Did I get 
> that right? 

Correct.

> 
> If so, I imagine that the user has no idea how many nested pgtables are 
> there, and if the ioctl initially finds N, but ends up printing N-1 
> (because a pgtable was not there anymore), that would not be an error that 
> the user should be worried about.

In kvm_ptdump_guest_nested_show() I acquire the mmu_lock, therefore
"initially finds N but printing N-1" won't happen, the whole operation
of looking at the nested mmu array and printing them out is atomic.

> 
> It could be an issue if you were printing in multiple steps (multiple 
> checks), as a part of that pgtable could be printed while another part 
> could not. Which does not seem to be the case.

Yes, that's one of the problems not taking the lock can introduce.

Thanks,
Wei-Lin Chang

> 
> > 
> > > 
> > > >  
> > > >  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> > > > @@ -206,17 +213,23 @@ static const struct file_operations kvm_ptdump_guest_fops = {
> > > >  
> > > >  static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
> > > >  {
> > > > -	struct kvm_pgtable *pgtable = m->private;
> > > > +	struct kvm *kvm = m->private;
> > > > +
> > > > +	guard(write_lock)(&kvm->mmu_lock);
> > > > +	if (kvm->arch.mmu.pgt)
> > > > +		seq_printf(m, "%2u\n", kvm->arch.mmu.pgt->ia_bits);
> > > >  
> > > > -	seq_printf(m, "%2u\n", pgtable->ia_bits);
> > > >  	return 0;
> > > >  }
> > > >  
> > > >  static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
> > > >  {
> > > > -	struct kvm_pgtable *pgtable = m->private;
> > > > +	struct kvm *kvm = m->private;
> > > > +
> > > > +	guard(write_lock)(&kvm->mmu_lock);
> > > > +	if (kvm->arch.mmu.pgt)
> > > > +		seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - kvm->arch.mmu.pgt->start_level);
> > > >  
> > > > -	seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - pgtable->start_level);
> > > >  	return 0;
> > > >  }
> > > >  
> > > > @@ -224,15 +237,12 @@ static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
> > > >  				    int (*show)(struct seq_file *, void *))
> > > >  {
> > > >  	struct kvm *kvm = m->i_private;
> > > > -	struct kvm_pgtable *pgtable;
> > > >  	int ret;
> > > >  
> > > >  	if (!kvm_get_kvm_safe(kvm))
> > > >  		return -ENOENT;
> > > >  
> > > > -	pgtable = kvm->arch.mmu.pgt;
> > > > -
> > > > -	ret = single_open(file, show, pgtable);
> > > > +	ret = single_open(file, show, kvm);
> > > 
> > > Maybe this change is more related with the previous patch?
> > 
> > I see your point, but I divided it into first fixing mmu UAF, then the
> > pgt UAF, which I also think makes sense.
> > 
> 
> Okay then
> 
> Thanks!
> Leo
