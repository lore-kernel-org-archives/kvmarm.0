Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628FF3D9549;
	Fri, 25 Sep 2026 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790356040; cv=none; b=ghEmQ7gpZ5ZXvWp86rfb9MQtiq6AH3H5ANuq8OLxxafpKNesSoeehWFRFn7xc98rpmfbfVeAVps8HZ6D2rc90qH7wnVunOr+CUuG4ye62uAfHxaQJ/uNHrIaUKyF0jU2XEoHLg/ZqiEePuglMI9SOtsG5w4uvucC2y6NfVwzdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790356040; c=relaxed/simple;
	bh=ixzfrU8lMEsDTomOcbMGSENbu/A9XPEY12QX9G9g3I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSUEjpcZ5SGlYp13ID5+wj0M9iJNwIrMWvIQw7rckN1Tx2aGZJyFZprS/Dgl2srf/w7HeTlRj7C5M/fgDGNtZJnoCVtjcwThE+4lVteX2tq8NpI9gnhQoUK297QJIRx1qMJAnjfpJzZE+8cekK7Xqhxh2d9dbRHA2HrvrEx9xus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EHpt1dnk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EHpt1dnk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B9EF169C;
	Fri, 25 Sep 2026 10:07:11 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F93D3F86F;
	Fri, 25 Sep 2026 10:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790356034; bh=ixzfrU8lMEsDTomOcbMGSENbu/A9XPEY12QX9G9g3I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EHpt1dnkgmEtCXRicfI03eywssdpZdbGJitm2LyU3/txbYynDGJW9GXrNQawbZEyw
	 3QDLIL1w9E0vjFWl3xfYaRKn3caSX1J1hyvAayOZ7OCj9NKUhHV57vPR+0QirXYeeJ
	 MOzJAeppFl24SLREnFIB5jWlehs2ggbnYJhv2Z8s=
Date: Fri, 25 Sep 2026 18:07:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, maz@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
	yuzenghui@huawei.com, linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <araqPCdcSnqZqPWz@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <arK3tsTV6EDhI-nt@willie-the-truck>
 <arOyp8WUrYBAjrGH@arm.com>
 <arP0IF0MjFUv36AP@willie-the-truck>
 <49dcab27-1d03-4df2-b7cb-4df4eda6d909@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49dcab27-1d03-4df2-b7cb-4df4eda6d909@arm.com>

On Wed, Sep 23, 2026 at 05:04:06PM +0100, Suzuki K Poulose wrote:
> On 23/09/2026 16:45, Will Deacon wrote:
> > On Wed, Sep 23, 2026 at 12:06:15PM +0100, Catalin Marinas wrote:
> > > On Tue, Sep 22, 2026 at 06:15:34PM +0100, Will Deacon wrote:
> > > > On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
> > > > > From: Steven Price <steven.price@arm.com>
> > > > > 
> > > > > If the host attempts to access granules that have been delegated for use
> > > > > in a realm these accesses will be caught and will trigger a Granule
> > > > > Protection Fault (GPF).
> > > > > 
> > > > > A fault during a page walk signals a bug in the kernel and is handled by
> > > > > oopsing the kernel. A non-page walk fault could be caused by user space
> > > > > having access to a page which has been delegated to the kernel and will
> > > > > trigger a SIGBUS to allow debugging why user space is trying to access a
> > > > > delegated page.
> > > > > 
> > > > > There is work in progress to unmap the guest_memfd backed private pages from the
> > > > > linear map. Until we get that support, we could get spurious GPFs from within
> > > > > the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.
> > > > > 
> > > > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > ---
> > > > > Changes since v17:
> > > > >   * Pass untagged address to die_kernel_fault() - Sashiko
> > > > >   * Explicitly check !user_mode() for fixups - Catalin
> > > > >   * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
> > > > >   * Clarify the commit description about the upcoming work on
> > > > >     unmapping guest_memfd backed pages from linear map
> > > > > Changes since v16:
> > > > >   * Update the commit description to indicate why we try to fixup GPFs
> > > > > Changes since v10:
> > > > >   * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> > > > > Changes since v2:
> > > > >   * Include missing "Granule Protection Fault at level -1"
> > > > > ---
> > > > >   arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
> > > > >   1 file changed, 24 insertions(+), 6 deletions(-)
> > > > 
> > > > I still don't think we should do this, given that the plan is to unmap
> > > > the memory from the linear map. If this thing fires, it's a kernel bug
> > > > and it should be fatal.
> > > 
> > > If the linear unmapping gets merged first, I agree, no need to handle
> > > these faults. I haven't followed that series, so no idea where it is at.
> 
> There doesn't seem to be much progress on that series. Brendan
> volunteered to resurrect the series, taking over from Nikita [0].
> But looks like Brendan is not working on this anymore. Will see
> if someone is really planning to look at it.
> 
> [0] https://lore.kernel.org/all/DJJ35VLH2PE5.DFD8OYXEOH97@linux.dev

I just realised that this only solves part of the problem. Normal kernel
allocations are delegated RMM metadata and they'll also trigger GPF
faults. Kdump is another point raised here:

https://lore.kernel.org/all/a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com/

I think rmi_delegate_range() covers the non-kdump cases, both for
metadata and realm memory, we could unmap the linear map there (map it
back in rmi_undelegate_range()).

For kdump, we have /proc/vmcore that may be mmap'ed or read() syscalls.
I think Alper proposed an idea to use copy_from_kernel_nofault() (with
exception recovery in do_gpf()) but we'd still need to block
mmap_vmcore() or somehow handle SIGBUS in makedumpfile unless it does
this already.

So, I think we should revisit the GPF handling. If we manage to unmap
all delegated pages, we could limit the exception handling to
is_kdump_kernel(). Otherwise we keep the exception handling as proposed
earlier, maybe with some warnings like EL0 access.

-- 
Catalin
