Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9A7576ED3;
	Tue, 22 Sep 2026 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790097344; cv=none; b=ijNzjTDOWixmwZwWMA6w2YR445aB+j4OJWpBbFf0r0V8vUQBQfDOnNdFzNic+E9dQW3R0kNwTrunBXMCQUAr80r1IdhkddaIa90rjQEm+KNxCvE0Asr5YWTUUlPqq+ImKxcImOd9IfT0hORmvfQ+znKjrRyGiwtIytvZ1I1ybwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790097344; c=relaxed/simple;
	bh=m8JfzfQ/K7ynxAP+mIg5GPu1v2WwEh4hWVjoye9kaWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+kaOGbsxq+jozG616ZClrjzKyVjHhY58+f0NiaSPTh23obnHO/8QMm+dzDNuvV62WZxYFvwcxEzPVwc3nWPa5pP9RHsCFwtIee8THrOJ9H3/Rv8VA3/3qRlgWEtmURgxOLkwobEaYAR5EyAQmtmn0GxFglCvgjrPZV6B5Kxg3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGRoPx0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGRoPx0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A21F00893;
	Tue, 22 Sep 2026 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790097342;
	bh=KwQN7WVhANwtG21qRW2cXhG1KlqZnmnqp3LyL8PiblQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MGRoPx0gFeoZ620M+h6hVml1cmstZ36RtqWY65JVSsUD5TMarzlFWrri8h+HdC4fV
	 tb3O2T8Z9k0tiACSeV/L/YdcNDoDkcmo5S6d+2gsXo1v7ZuLSr6xYIWNvegc6TufBK
	 eg5RUuFKBcIK0G2An7KcyBk/RLadzP4pFEQw7yeQhdN3ofhyFPBi93dJvIyWDpuwMP
	 BcOeNuR4b1fXl7ZVbsnBNPnyMtaoynBi4uhbqvKUdD5haCJvQJoEPoyLcnb3iFhxCW
	 iU1VzelR+8iiGNSduR4hDUo+gQfKMHArnhh/H9uEoLVkrxlwAexfAEyPfNAZrT7A4z
	 VbqQwSaYdEhQQ==
Date: Tue, 22 Sep 2026 18:15:34 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <arK3tsTV6EDhI-nt@willie-the-truck>
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

I still don't think we should do this, given that the plan is to unmap
the memory from the linear map. If this thing fires, it's a kernel bug
and it should be fatal.

Will
