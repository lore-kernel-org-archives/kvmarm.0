Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E88B49DB8B;
	Wed, 23 Sep 2026 11:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161582; cv=none; b=bXsK2EP3SD8K54Gfqv+P/SAJcA2ulRSs/Wpe1cEM5MW8GzL7jlUIXhSLPeIYqKbEl9U/VJ3NonKlEaApx4SbtvDQpP2r4bsg+zz9zBGzsb04XoQLo649bHrAAIJp2QqCbdHKrz19RMAU9lY8wyxkbgvuMdQ8gTCdGH/VkWu5YtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161582; c=relaxed/simple;
	bh=AiLb+XIqqeogh5YIbkCt/ug3YDrQxWlGcnRvc7/OSzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkHtj2dIHGdA2PVqoE0U2miKFuA1ggrHUl5/REf6dBKaGL5gQ1saesM07QoiW5qywmiKcxT+OQQ+oqu0eUhi/QZJOY4ItLzIu3s529RJ6e03OpiHUrn9/I4KfkwJvI+WBDA0EJNaDDwMi4NJGFQ3c+buMRTUx/2O5ftMvTC+7kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RZd6PDCE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RZd6PDCE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06D531516;
	Wed, 23 Sep 2026 04:06:17 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F314F3F86F;
	Wed, 23 Sep 2026 04:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790161580; bh=AiLb+XIqqeogh5YIbkCt/ug3YDrQxWlGcnRvc7/OSzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZd6PDCElzn8tIotWwrvT9WVNfhaf+E0nsTzPz7biVZvPKwP8gDLv/16qknBwwCeE
	 XZqVX7rtPhnEOmnIpGuocfxi5mPtjFIoFr3VFosboC1I/0xJVnx9XIJolkmsXAj5+B
	 BQkCyZnQEJkrsTacXF5+UJGQn1YF7TiEHuz/UsaY=
Date: Wed, 23 Sep 2026 12:06:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, maz@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
	yuzenghui@huawei.com, linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <arOyp8WUrYBAjrGH@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <arK3tsTV6EDhI-nt@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arK3tsTV6EDhI-nt@willie-the-truck>

On Tue, Sep 22, 2026 at 06:15:34PM +0100, Will Deacon wrote:
> On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
> > From: Steven Price <steven.price@arm.com>
> > 
> > If the host attempts to access granules that have been delegated for use
> > in a realm these accesses will be caught and will trigger a Granule
> > Protection Fault (GPF).
> > 
> > A fault during a page walk signals a bug in the kernel and is handled by
> > oopsing the kernel. A non-page walk fault could be caused by user space
> > having access to a page which has been delegated to the kernel and will
> > trigger a SIGBUS to allow debugging why user space is trying to access a
> > delegated page.
> > 
> > There is work in progress to unmap the guest_memfd backed private pages from the
> > linear map. Until we get that support, we could get spurious GPFs from within
> > the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.
> > 
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Steven Price <steven.price@arm.com>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > ---
> > Changes since v17:
> >  * Pass untagged address to die_kernel_fault() - Sashiko
> >  * Explicitly check !user_mode() for fixups - Catalin
> >  * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
> >  * Clarify the commit description about the upcoming work on
> >    unmapping guest_memfd backed pages from linear map
> > Changes since v16:
> >  * Update the commit description to indicate why we try to fixup GPFs
> > Changes since v10:
> >  * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> > Changes since v2:
> >  * Include missing "Granule Protection Fault at level -1"
> > ---
> >  arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
> >  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> I still don't think we should do this, given that the plan is to unmap
> the memory from the linear map. If this thing fires, it's a kernel bug
> and it should be fatal.

If the linear unmapping gets merged first, I agree, no need to handle
these faults. I haven't followed that series, so no idea where it is at.

However, I'd still keep part of this patch - the reporting and panic but
without the actual exception table recovery. There's some value in
killing user-space and WARN (or pr_ratelimited) without a full panic, it
helps with debugging. That's what do_bad() via arm64_notify_die() gives
us currently anyway.

So maybe we can keep it to just:

static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
{
	if (user_mode(regs)) {
		pr_alert_ratelimited("%s[%d]: granule protection fault at 0x%016lx\n",
				current->comm, task_pid_nr(current),
				untagged_addr(far));
		mem_abort_decode(esr);
	}

	return 1;
}

and we get the SIGBUS or panic via do_mem_abort(). No recovery for
uaccess though, we get the same kernel panic.

-- 
Catalin
