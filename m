Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E73B356A37;
	Wed, 12 Aug 2026 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542698; cv=none; b=qwuBuTA9v8Cfsi/gwe9P1Ux9k/S6dmmORxp6GseWqCCgMn11ubOwRpP6t8IqOJ8AsR+gwfijzb5EgeAgsDXvuO6xnP5cH6cenQNoR2h60bodSMtgv6lWa6NK/w+vmRuxPcAzcmY2SDbozpEWTwQKRbqi6qs2i080gAeyLOipe4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542698; c=relaxed/simple;
	bh=7nCoc+Gd4dBqkVM3L9DgfcWFTtT0Go8fgXf2EaF6ryw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BA20NWmnCBbCOjkVhRwFvM8kSyM36HQSg04VoH75qvkhxC0Q3iIIO1UOtWRIFGS9b2gzeG1GgEK2UdQWUzDCsu6xFZc5WqkPAVeBlQgpyj0ybJCcHAZNDzD5HKsBF2TSu8KZSzx1/xiwa00sc6rjgXwAHwShBMuhH/W8FbIo+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mdhIzOxU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mdhIzOxU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95556153B;
	Wed, 12 Aug 2026 06:51:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B3253F66F;
	Wed, 12 Aug 2026 06:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786542695; bh=7nCoc+Gd4dBqkVM3L9DgfcWFTtT0Go8fgXf2EaF6ryw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mdhIzOxU4DrVBTfWu9sQVemCRyfbINm+gJGsobbhcHm6RT2xmNZhB26+0R9dosOlZ
	 xJoZ5cz12TtS+PoAC7Z6fjscj7CPeR3vEFkFy0T4SY9x7smJreqT9+FtH5Fyd4YiTR
	 1YAp2YSqYL4igzdFr1iNMh6k+hMv25AjPvBXLAdU=
Date: Wed, 12 Aug 2026 14:51:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavan Kondeti <pavan.kondeti@oss.qualcomm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 07/45] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Message-ID: <anx6YbPMVz3OlpA5@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
 <ans1ZSwMEKeT9Gfz@arm.com>
 <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
 <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d4e5920-aa20-40cd-954e-037631bd0d6c@quicinc.com>

On Wed, Aug 12, 2026 at 06:12:09PM +0530, Pavan Kondeti wrote:
> On Tue, Aug 11, 2026 at 04:11:13PM +0100, Suzuki K Poulose wrote:
> > On 11/08/2026 15:44, Catalin Marinas wrote:
> > > On Mon, Aug 03, 2026 at 02:43:23PM +0100, Steven Price wrote:
> > > > If the host attempts to access granules that have been delegated for use
> > > > in a realm these accesses will be caught and will trigger a Granule
> > > > Protection Fault (GPF).
> > > > 
> > > > A fault during a page walk signals a bug in the kernel and is handled by
> > > > oopsing the kernel. A non-page walk fault could be caused by user space
> > > > having access to a page which has been delegated to the kernel and will
> > > > trigger a SIGBUS to allow debugging why user space is trying to access a
> > > > delegated page.
> > > > 
> > > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > > ---
> > > > Changes since v10:
> > > >   * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> > > > Changes since v2:
> > > >   * Include missing "Granule Protection Fault at level -1"
> > > > ---
> > > >   arch/arm64/mm/fault.c | 28 ++++++++++++++++++++++------
> > > >   1 file changed, 22 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > > > index 85e23388f9bb..ea3ae0ca7dba 100644
> > > > --- a/arch/arm64/mm/fault.c
> > > > +++ b/arch/arm64/mm/fault.c
> > > > @@ -909,6 +909,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
> > > >   	return 0;
> > > >   }
> > > > +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > > +{
> > > > +	const struct fault_info *inf = esr_to_fault_info(esr);
> > > > +
> > > > +	die_kernel_fault(inf->name, far, esr, regs);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > > +{
> > > > +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
> > > > +		return 0;
> > > > +
> > > > +	return 1;
> > > > +}
> > > 
> > > Is there a valid case for fixup_exception() here? IOW, do we ever have a
> > > valid user mapping of the pages delegated to a guest? If the above is
> > > considered a kernel bug, I'd not silently ignore this (like return less
> > > bytes copied or -EFAULT to user) but rather warn, potentially
> > > rate-limited.
> > 
> > Good question. This shouldn't be a valid case. We expect the VMM to use
> > guest_memfd and that should prevent any mmaps and thus fixups shouldn't
> > be required. That said, this series doesn't enforce that the VMM uses
> > GMEM backed memslots for Guest RAM. We should probably do that while
> > mapping things in.
> > 
> > With that, we could drop that fixup and scream a bit.
> 
> There is a valid case for fixup_exception() to be needed here in GPF
> handling.
> 
> -000 |load_unaligned_zeropad(inline)
> -000 |hash_name(inline)
> -000 |link_path_walk()
> -001 |path_lookupat()
> -002 |filename_lookup()
> -003 |vfs_statx()
> -004 |vfs_fstatat()
> 
> We observed this in Android running Gunyah when the page is mapped in
> EL1 but unmapped at EL2. path_lookupat() can actually handle this
> via fixup_exeption() when a word load crosses the page boundary.
> However, Gunyah injects a Synchronous External Abort and we have
> a downstream patch [1] that adds fixup_exception() in do_sea(). pKVM
> injects [2] such faults back to EL1 and fixup_exception() is taken care.

Ah, good point, completely forgot about load_unaligned_zeropad(). Since
we don't unmap the linear map for delegated pages, we'll need the
fixup_exception(). And I guess warning in this case is not desirable
either. We could limit it to EX_TYPE_KACCESS_ERR_ZERO and
EX_TYPE_LOAD_UNALIGNED_ZEROPAD, though not sure it's worth it.

-- 
Catalin
