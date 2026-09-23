Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF99353F6A3;
	Wed, 23 Sep 2026 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178345; cv=none; b=SDmDMZON07cSy+/ebBO9qzd5rUdYFSqF8Epy5YbFzN8PgQYNqT+2VQ+W8oT+7bfDZM4x+U/wDDli0bPuQy4i2hiwllT/2FWRlwphfbt6g0zR7MCiMYsEvWPZ9PrWV85jcT6Pl4kP7BVd7Gn1NiUXpbkTiQpdyAaP5BvAXvX4jzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178345; c=relaxed/simple;
	bh=oNky5tLCjol95LoJjVzCouM1AqenJcOzo/Hm66wzqaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1ZkbWbOQ/l0cxP3L3xEs80jQjpzJGMjvAVn3rLqAmSbZgHkUoi5Z/wlbzJuUsZFy7IkyLJ9sBMn/pFY+OrOjZ1aEY2OLDCvsb042T9Dmo551FaslRWMrlhCS6CQwSu+MwUuD+T/MP/IOs0ltD25/9FZ0iu90GXaibJy/Oi+/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KapfSIup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KapfSIup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5741F00893;
	Wed, 23 Sep 2026 15:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178343;
	bh=xBhwM6wbqAw5a+cVNgYvlXlXJxCKVG4pNRvbUVKP8IA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KapfSIupahzymrJQOac0ZZru85avmkuCFsYN2BBX6hl8axXNJnffgnyqlm+GAqWFQ
	 xzT7HNgoPLukmPtZQiUBGjAAgsMTd8mBODvU/qvqBoVlLs8WPfPnrRxVZn6ihew8bP
	 vmmMP0HpYQBzSv0xarrSJFoDT0NNFmAVaJN5trYsm/T8kdBaP69tAOT9Jceqe5C9/t
	 LV8Gui+KCanV+FtQ1aix6tIz7u0R/FbAIq7lEskqqpVMZDrB8GsXpeMSh9MekmkAQ3
	 7ZMPHiPPDsji0EEtsNO5GjhuQJSJsjKHq/vLBxDvftss4APctbzOGdwKH6KmH4FoDW
	 ATZpPB7e1lFyQ==
Date: Wed, 23 Sep 2026 16:45:36 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
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
Message-ID: <arP0IF0MjFUv36AP@willie-the-truck>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <arK3tsTV6EDhI-nt@willie-the-truck>
 <arOyp8WUrYBAjrGH@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOyp8WUrYBAjrGH@arm.com>

On Wed, Sep 23, 2026 at 12:06:15PM +0100, Catalin Marinas wrote:
> On Tue, Sep 22, 2026 at 06:15:34PM +0100, Will Deacon wrote:
> > On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
> > > From: Steven Price <steven.price@arm.com>
> > > 
> > > If the host attempts to access granules that have been delegated for use
> > > in a realm these accesses will be caught and will trigger a Granule
> > > Protection Fault (GPF).
> > > 
> > > A fault during a page walk signals a bug in the kernel and is handled by
> > > oopsing the kernel. A non-page walk fault could be caused by user space
> > > having access to a page which has been delegated to the kernel and will
> > > trigger a SIGBUS to allow debugging why user space is trying to access a
> > > delegated page.
> > > 
> > > There is work in progress to unmap the guest_memfd backed private pages from the
> > > linear map. Until we get that support, we could get spurious GPFs from within
> > > the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.
> > > 
> > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > ---
> > > Changes since v17:
> > >  * Pass untagged address to die_kernel_fault() - Sashiko
> > >  * Explicitly check !user_mode() for fixups - Catalin
> > >  * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
> > >  * Clarify the commit description about the upcoming work on
> > >    unmapping guest_memfd backed pages from linear map
> > > Changes since v16:
> > >  * Update the commit description to indicate why we try to fixup GPFs
> > > Changes since v10:
> > >  * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> > > Changes since v2:
> > >  * Include missing "Granule Protection Fault at level -1"
> > > ---
> > >  arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
> > >  1 file changed, 24 insertions(+), 6 deletions(-)
> > 
> > I still don't think we should do this, given that the plan is to unmap
> > the memory from the linear map. If this thing fires, it's a kernel bug
> > and it should be fatal.
> 
> If the linear unmapping gets merged first, I agree, no need to handle
> these faults. I haven't followed that series, so no idea where it is at.
> 
> However, I'd still keep part of this patch - the reporting and panic but
> without the actual exception table recovery. There's some value in
> killing user-space and WARN (or pr_ratelimited) without a full panic, it
> helps with debugging. That's what do_bad() via arm64_notify_die() gives
> us currently anyway.
> 
> So maybe we can keep it to just:
> 
> static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> {
> 	if (user_mode(regs)) {
> 		pr_alert_ratelimited("%s[%d]: granule protection fault at 0x%016lx\n",
> 				current->comm, task_pid_nr(current),
> 				untagged_addr(far));
> 		mem_abort_decode(esr);
> 	}
> 
> 	return 1;
> }
> 
> and we get the SIGBUS or panic via do_mem_abort(). No recovery for
> uaccess though, we get the same kernel panic.

But how can this ever occur in user mode? I'm fine with making that part
unconditional.

Will
