Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F334A3407;
	Thu, 24 Sep 2026 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790264596; cv=none; b=fhxP9nXHuzgxE+p0CsGtV6NfVsWTJ1by9/AqWMl0DHdNAlto5epf58TkPIRPoz+FM4KwLOsUDRhHkOqG1AdbgUomLeePQseHllCxgKg76rr0+8yMKuBOcbT9fprQc/5plqwPnPqz9SZ1iDBNd9oXChv0gvZYM9K6pW6tKg0CjiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790264596; c=relaxed/simple;
	bh=CHYzUrkQMcLRWPgUeFO4PnGKYjBY2rlqkQkNha1Cbug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7yfPUqAsK1fylaSFdU12MuB/kMw4czC6shP3YnrpZil/EtzGNV5oSFBhQLVKxCK4vgK6oH+vJJTJ2sTZKorT7GJzSAemrOoxDRIzcpd1FMYEWQqb27E8TFtmZXSF0pPACHzvCf0O9ENFk7BA68buD01eGDVr4FgD5Yw92In3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HIJqAdNy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HIJqAdNy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D3041E4D;
	Thu, 24 Sep 2026 08:43:07 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF9313F86F;
	Thu, 24 Sep 2026 08:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790264590; bh=CHYzUrkQMcLRWPgUeFO4PnGKYjBY2rlqkQkNha1Cbug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HIJqAdNykH8EhX/o4szrcmNL2hM8vYBQdTMIpdVNJshRaywuATNN5gF4n/QX1BnTg
	 XtsOxiOMg8zogPeJu2NBU17QrQOExbg/hDgGHr4MJN5g6NXyxxN7q+UpuIYN/c81Sg
	 nsEJPj/PyTPKM7HefB3zd3xr+c+qWipNz99kZd3Y=
Date: Thu, 24 Sep 2026 16:43:04 +0100
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
Message-ID: <arVFCCykzWJctPXP@arm.com>
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
> > > However, I'd still keep part of this patch - the reporting and panic but
> > > without the actual exception table recovery. There's some value in
> > > killing user-space and WARN (or pr_ratelimited) without a full panic, it
> > > helps with debugging. That's what do_bad() via arm64_notify_die() gives
> > > us currently anyway.
> > > 
> > > So maybe we can keep it to just:
> > > 
> > > static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > {
> > > 	if (user_mode(regs)) {
> > > 		pr_alert_ratelimited("%s[%d]: granule protection fault at 0x%016lx\n",
> > > 				current->comm, task_pid_nr(current),
> > > 				untagged_addr(far));
> > > 		mem_abort_decode(esr);
> > > 	}
> > > 
> > > 	return 1;
> > > }
> > > 
> > > and we get the SIGBUS or panic via do_mem_abort(). No recovery for
> > > uaccess though, we get the same kernel panic.
> > 
> > But how can this ever occur in user mode?

Only if we have a kernel bug.

> > I'm fine with making that part unconditional.
> 
> Agree, if the user mode can hit this, a page is mapped in the EL0 and
> it can as well cause the Kernel to hit a GPF.
> Also if make the handling unconditional, we end up calling
> die_kernel_fault() and that does the mem_abort_decode() causing
> duplicate logs.

If we just return 1 here without anything printed (or rely on do_bad()),
we don't get any info when the user tripped over such pages. Printing
without the user_mode() check duplicates the mem_abort_decode() for the
kernel.

If we want panic always here even if only the user triggered it, we can
do like do_gpf_ptw() (and keep a single function for both). However,
die_kernel_fault() is a bit confusing as it prints "kernel access" when
it was user.

If we go with forced signal for EL0 faults (only helpful if we want to
continue debugging), I'd keep the warning, maybe as WARN_RATELIMIT() or
a printk. It would be very similar to our current do_bad() behaviour -
kernel => panic, user => kill, but with more information when it
happened in user space.

-- 
Catalin
