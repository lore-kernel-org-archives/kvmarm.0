Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31299426438;
	Tue, 11 Aug 2026 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786459502; cv=none; b=BoHwciSaAPLAtP6wIcdJ98s2HEPOx3vEHIQALtHdhcgBB7dksx+SH7HwZXYkIR6fobaVbEDu4RjRhLxi6f9pSRBiJx7NhXpa6xd0oBcesllS+1N9+OSqR+dGFqXh3uud3WfuypmYxX8a2Va1Poa1t57ALZgBk7TJwvSg58zzM2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786459502; c=relaxed/simple;
	bh=/LPEH55R6LClPqeXnYARvDZU8XDKgr9ZBtZUHbi7ZdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tq389bv5KnGt/yxb0BWFgdXHhLDDNKTY2I+QI2XycVRgh491eK6FkHnCnDCUcr8WBX9FhC2pDmXey/kChm++04bezg5it9OJxP8hXOWlyIArjUOha5jCbYVHDST/ZE55af+pxJ6v7KXzcGA2DA0xecpIRbmSP9iGIspeOfl04J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UhMkyTJN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UhMkyTJN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E97BB1682;
	Tue, 11 Aug 2026 07:44:54 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF9DA3F86F;
	Tue, 11 Aug 2026 07:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786459498; bh=/LPEH55R6LClPqeXnYARvDZU8XDKgr9ZBtZUHbi7ZdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UhMkyTJN6nwQPPoHojp2Lj90fCxYgfZoPQnlFeUfUA7QykLZDiF4BKo9sc5b4f8Cu
	 tgVMWQsawjcyUgRgg0Bm7XS/nBDFtj0Sesm5suAVALsIGilMsDyBy47x0YNQEeI5bh
	 5ONfXUPbgnRx3kWP8wbSZ0K3W95SrAy0Gy8N9cpw=
Date: Tue, 11 Aug 2026 15:44:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
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
Message-ID: <ans1ZSwMEKeT9Gfz@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803134403.80630-8-steven.price@arm.com>

On Mon, Aug 03, 2026 at 02:43:23PM +0100, Steven Price wrote:
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
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v10:
>  * Don't call arm64_notify_die() in do_gpf() but simply return 1.
> Changes since v2:
>  * Include missing "Granule Protection Fault at level -1"
> ---
>  arch/arm64/mm/fault.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 85e23388f9bb..ea3ae0ca7dba 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -909,6 +909,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>  	return 0;
>  }
>  
> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	const struct fault_info *inf = esr_to_fault_info(esr);
> +
> +	die_kernel_fault(inf->name, far, esr, regs);
> +	return 0;
> +}
> +
> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
> +		return 0;
> +
> +	return 1;
> +}

Is there a valid case for fixup_exception() here? IOW, do we ever have a
valid user mapping of the pages delegated to a guest? If the above is
considered a kernel bug, I'd not silently ignore this (like return less
bytes copied or -EFAULT to user) but rather warn, potentially
rate-limited.

If there is a real use-case for this, what's preventing GUP + memcpy()
from triggering a similar fault with no fixup available?

-- 
Catalin
