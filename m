Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB19E356771;
	Wed, 16 Sep 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576776; cv=none; b=mh1xvf5diWJ3FoZZen3TpSMD5/CIE3QWMB2mlB3MwdMlym4rJKdw7UExhKJApXcj6fiHOUv77kKmwMFSNGYVyrFmomxZNgZZnN/e9C4j9/FV9/l0s1GneS8TZ3FmVPPeysaHm4ibQKNuu62VdPIrMbhXsQdAT3JJbTu6+cjw4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576776; c=relaxed/simple;
	bh=tpRIZijp9OVz8xJ1EeL+tPf3ChFeQoiLXmvmWlNF4Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+OJo4wK+JYkSEtkdb6zszgCzFrco5ks89wjZClt7oFoP1LzTpStFDLApe4LUaTEmuR+k5DlaXE1IGwQcZDBjeJ8LDcFI3avb2tIx2eQV8yZcONlkF9v3nLs2FwWPze7V/d9V9mDFb6KuPgU/kJEe5/W34PBFI/kBtWxNyTduIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VTTpRpO/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VTTpRpO/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B9A41516;
	Wed, 16 Sep 2026 09:39:26 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E2973F7B4;
	Wed, 16 Sep 2026 09:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789576770; bh=tpRIZijp9OVz8xJ1EeL+tPf3ChFeQoiLXmvmWlNF4Eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VTTpRpO/bXvOGdJEE2whk8i4bgjlyM4Oe4CK8N8HAJRuPmsS+tN8MXN42RXbgm3Sc
	 f6K3/OxKnrKjaSuMPpqKf/X+YxnbfWi+9aQ4r9mef1QEHKjGlliCtpz9+wMnNi2U8l
	 fztfrqPEyKMI4cNjC0OP4zktopb5mSoOGIwd3hPw=
Date: Wed, 16 Sep 2026 17:39:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <aqrGPK0lFBFXL2qY@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913070459.2547407-1-suzuki.poulose@arm.com>

On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> If the host attempts to access granules that have been delegated for use
> in a realm these accesses will be caught and will trigger a Granule
> Protection Fault (GPF).
> 
> A fault during a page walk signals a bug in the kernel and is handled by
> oopsing the kernel. A non-page walk fault could be caused by user space
> having access to a page which has been delegated to the kernel and will
> trigger a SIGBUS to allow debugging why user space is trying to access a
> delegated page.
> 
> There is work in progress to unmap the guest_memfd backed private pages from the
> linear map. Until we get that support, we could get spurious GPFs from within
> the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v17:
>  * Pass untagged address to die_kernel_fault() - Sashiko
>  * Explicitly check !user_mode() for fixups - Catalin
>  * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
>  * Clarify the commit description about the upcoming work on
>    unmapping guest_memfd backed pages from linear map
> Changes since v16:
>  * Update the commit description to indicate why we try to fixup GPFs
> Changes since v10:
>  * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> Changes since v2:
>  * Include missing "Granule Protection Fault at level -1"
> ---
>  arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 75c3e463df2ef..dc3a87902a60c 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -914,6 +914,24 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>  	return 0;
>  }
>  
> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	const struct fault_info *inf = esr_to_fault_info(esr);
> +	unsigned long addr = untagged_addr(far);
> +
> +	die_kernel_fault(inf->name, addr, esr, regs);
> +	return 0;
> +}
> +
> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
> +	    fixup_exception(regs, esr))
> +		return 0;
> +
> +	return 1;
> +}

We discussed briefly offline. With the latest patches around, would we
ever end up with private memory mapped in the VMM and hence the GPF? If
not, I would still keep this handling but add a
WARN_ON_ONCE(user_mode(regs)).

However, can we end up delegating a non-guest_memfd memslot page as
protected?

I played a bit with codex and it reckons it's possible if a guest_memfd
memslot is deleted after its IPA range has been initialised with
RIPAS=RAM. Removing the memslot unmaps and undelegates any data pages
but leaves the RMM state as RAM. The VMM can then install an ordinary
memslot over the same GPA range.

A subsequent private-IPA S2 fault sees the non-guest_memfd slot, takes
user_mem_abort(), GUPs the user page and passes it to
realm_map_protected(). The userspace mapping remains present, so a later
EL0 access can generate a GPF.

What's worse, I think it can even trick the kernel into doing a memcpy()
access (via GUP). Hmm, does such ordinary slot page even remain pinned?
There are other kernel parts that could access it.

I don't think it changes this patch but if the above is possible, we
should definitely get it tightened on the other series (and here we can
add the warning).

-- 
Catalin
