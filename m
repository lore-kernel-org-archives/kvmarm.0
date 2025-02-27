Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4885C225408
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740664673; cv=none; b=rrjXnKAscRRbPQtG+oB40QizcU8BqbXtry53x0ridk+KfQydSlwBic8wIQ0wtDERN3qNQoa92UFF3eT9+NTb8vXDKG33eSG9jMIiyS4OL0ouzkbezFPHwxBXdgjC1381BssFgo2lKQaY17Uum8VgNAR+AaSVN/zxjQWOeMvraNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740664673; c=relaxed/simple;
	bh=BAdV/9ccLGW1KnbvOleStaQNMaEsn3aEmiKd37wh5Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dInCq1fM0ZZ9bn6Qq+JS0nsJuGA08qlYAxpT+9YKo+gmoZG3Gc90JB5Zt7JmkY5VtCqq5BgCZTka7ff9uQRopq+RUgQjOQASrp52NkqE9bOacR6mYOjjDIhno00pABHok63BdSI5BSAHJTMnzRV3Qi6UlkLyi1zx5elJoOz1F+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C08AF2BCA;
	Thu, 27 Feb 2025 05:58:05 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C7E93F673;
	Thu, 27 Feb 2025 05:57:49 -0800 (PST)
Date: Thu, 27 Feb 2025 13:57:38 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, andrew.jones@linux.dev,
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3] arm64: Add basic MTE test
Message-ID: <Z8BvUkBIETJvRiln@raptor>
References: <20250102111020.130788-1-vladimir.murzin@arm.com>
 <Z4aHBrpgiyWNXac2@arm.com>
 <53d73ed1-567a-4428-b4ac-3c4741218ce3@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53d73ed1-567a-4428-b4ac-3c4741218ce3@arm.com>

Hi Vladimir,

Sorry for getting back to this so late, I got swamped by something else and
I totally forgot :(

On Wed, Jan 29, 2025 at 01:51:23PM +0000, Vladimir Murzin wrote:
> Hi,
> 
> On 1/14/25 15:47, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Thu, Jan 02, 2025 at 11:10:20AM +0000, Vladimir Murzin wrote:
> >> Test tag storage access and tag mismatch for different MTE modes.
> >>
> >> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> >> ---
> >>  v2 -> v3
> >>     - Use non-zero tag by default
> >>     - Explicitly clear TCR_EL1.TCMA0 (per Alexandru)
> >>     - Drop $MACHINE_PROPS  (per Alexandru)
> >>     - Moved tests under mte group (per Alexandru)
> >>     - Perform mte_init() from main() (per Nikos)
> >>     - Free allocated memory after the test (per Nikos)
> >>
> >>  v1 -> v2
> >>     - Addressed comments (I hope I did not miss any) from Alexandru
> >>

[..]

> >> +static inline void mte_memset(void *addr, int val, size_t size)
> > Would you mind explaining why you opted to memset the entire page instead
> > of doing *mem = 0xffffffff?
> > 
> 
> I think is matter of taste how to initialize memory, so I do not understand
> what kind of expalnation you are expecting... memset was present since V1 and
> was not questioned. Anything wrong with using memset here?

Ok, I see, I noticed it this review round and I thought maybe there was
something else that I wasn't seeing.

> 
> >> +{
> >> +	unsigned long old = mte_set_tcf(MTE_TCF_SYNC);
> >> +
> >> +	memset(addr, val, size);
> >> +	mte_set_tcf(old);
> >> +}
> > I don't like having the check for writes to tagged addresses hidden behind
> > memsetting the memory. There's also no test for successfully reading from
> > tagged addresses.
> > 
> > I would have expected that, for each test, there would be a check that
> > reads and writes work with the corresponding configuration; for example,
> > for the asymmetric test:
> > 
> > diff --git a/arm/mte.c b/arm/mte.c
> > index 3a9eb411c4f4..37e125039b48 100644
> > --- a/arm/mte.c
> > +++ b/arm/mte.c
> > @@ -100,6 +100,12 @@ static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
> >  {
> >         pteval_t *p_pte = follow_pte(pgtable, untagged(vaddr));
> > 
> > +       /*
> > +        * Wait for writes to the address to complete before changing the memory
> > +        * type to MT_NORMAL_TAGGED.
> > +        */
> > +       dsb(ish);
> > +
> >         if (p_pte) {
> >                 pteval_t entry = *p_pte;
> > 
> > @@ -213,24 +219,46 @@ static void mte_sync_test(void)
> > 
> >  static void mte_asymm_test(void)
> >  {
> > -       unsigned int *mem = tagged(alloc_page(), 2);
> > -       unsigned int val = 0;
> > +       unsigned int *mem = alloc_page();
> > +       unsigned int val;
> > +
> > +       if (!mem)
> > +               report_abort("alloc_page() failed");
> > +       *mem = 0xffffffff;
> > 
> >         mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> > +       mem = tagged(mem, 2);
> >         mte_set_tag(mem, PAGE_SIZE, 2);
> > -       mte_memset(mem, 0xff, PAGE_SIZE);
> > +
> > +       write_sysreg_s(0, TFSR_EL1);
> >         mte_set_tcf(MTE_TCF_ASYMM);
> > -       mte_exception = false;
> > 
> > +       mte_exception = false;
> >         install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> > 
> > +       val = 0;
> > +       mem_read(mem, &val);
> > +       if (!report((val == 0xffffffff) && !mte_exception && (get_clear_tfsr() == 0),
> > +                   "successful read"))
> > +               return;
> > +
> > +       mte_exception = false;
> > +       mem_write(mem, 0);
> > +       if (!report((*mem == 0) && !mte_exception && (get_clear_tfsr() == 0),
> > +                   "successful write"))
> > +               return;
> > +
> > +       val = 0;
> > +       *mem = 0xffffffff;
> > +       mte_exception = false;
> >         mem_read(tagged(mem, 3), &val);
> > -       report((val == 0) && mte_exception, "read");
> > +       report((val == 0) && mte_exception && (get_clear_tfsr() == 0),
> > +              "failed read");
> > 
> >         install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
> > 
> >         mem_write(tagged(mem, 4), 0xaaaaaaaa);
> > -       report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "write");
> > +       report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == TFSR_EL1_TF0), "failed write");
> > 
> >         free_page(untagged(mem));
> >  }
> > 
> > What do you think?
> > 
> 
> I think we better add features incrementally. So I'll rollback to original
> idea of testing failed access only and let you submit patches implementing
> your ideas on top.

Sounds good to me!

> 
> >> +
> >> +static inline unsigned long get_clear_tfsr(void)
> >> +{
> >> +	unsigned long r;
> >> +
> >> +	dsb(nsh);
> >> +	isb();
> >> +
> >> +	r = read_sysreg_s(TFSR_EL1);
> >> +	write_sysreg_s(0, TFSR_EL1);
> >> +
> >> +	return r;
> >> +}
> >> +
> >> +static void mte_sync_test(void)
> >> +{
> >> +	unsigned int *mem = tagged(alloc_page(), 1);
> > alloc_page() can fail.
> > 
> 
> I check the sources and it seems it is common theme not to check result
> of alloc_page(). So I suspect there is expectation that alloc_page()
> doesn't fail... in any case we are probably safe since subseqent mmu_set_tagged()
> won't be able to find PTE and report_abort().

Not finding the PTE can be caused by several issues:

- Bug in follow_pte() (happened before).
- Bug in the page allocator.
- Bug in the arm64 memory mapping code.
- alloc_page() returned NULL.

But yeah, since most of the tests don't check for a NULL return value from
the page allocator I guess it doesn't happen too often. This test is really
useful and it has been on the list for quite some time, so I don't consider
this a blocker.

Thanks,
Alex
