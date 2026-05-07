Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B677B366542
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 08:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778143562; cv=none; b=d7t0bmif2/+bqx7BcspI7NB+RAh/TiYRtvUmfCtNBDNEvObm8RVGyEz/KyZFlEkFj2wfpPuOlCc6qjQMCzoDsbqUh7POgLKChUyLuLQDpX2uwD+A9J44us7pYxw543T6m+bTzSbIp3OlX4Ai1djbJf97mT90t83fvL5Bp+aA6Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778143562; c=relaxed/simple;
	bh=OOppSG08L/KO4ewNhuiOGUn8DWyo80ypF6cLMLTTsYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p377iCnlMrvI2HW0KVPaZxaCj1WHyujhXz3mhbJsllwWfyi9NF05k7SCpCaWBNFsaJHQQ8WyMsLaE6GQJMr05ic+EwYnZTzjYsApKyULDB5NFhDLlP7dK8LBtOWkAzFeFjX4Szh38nF5/edyS1rjZEYBycAt1lrV0ggVv2xyinE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ufrmHspj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ufrmHspj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C24422F8;
	Thu,  7 May 2026 01:45:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DC2D3F836;
	Thu,  7 May 2026 01:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778143553; bh=OOppSG08L/KO4ewNhuiOGUn8DWyo80ypF6cLMLTTsYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufrmHspjVCl4Wzf0NQBsG9zpogPjmvRIN1w+ESiaSlDExzghg2rqd8dhdsCqAR69g
	 8hZG8qjjFi6QLj+2oPUa2khfsO2MREpvN3a0jiv3RWVVv/UzdDsvHNrl+0TdcjdGQg
	 wyLfzq6PWCP3Ivvzk4azYH5V3T7Jw1ERbkYc1EVw=
Date: Thu, 7 May 2026 09:45:46 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	tabba@google.com, David.Hildenbrand@arm.com
Subject: Re: [RFC PATCH] KVM: arm64: Align KVM_EXIT_MEMORY_FAULT error codes
 with documentation
Message-ID: <afxROjBUVzeQQNfg@raptor>
References: <20260506105053.107404-1-alexandru.elisei@arm.com>
 <afs3wp7xBUf2jYK4@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afs3wp7xBUf2jYK4@google.com>

Hi Sean,

(Resending this because I managed to mess up the headers, sorry for the
duplicate).

Thanks for the explanations!

On Wed, May 06, 2026 at 05:44:50AM -0700, Sean Christopherson wrote:
> On Wed, May 06, 2026, Alexandru Elisei wrote:
> > The documentation for KVM_EXIT_MEMORY_FAULT states:
> > 
> > 'Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
> > it accompanies a return code of '-1', not '0'!  errno will always be set to
> > EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace
> > should assume kvm_run.exit_reason is stale/undefined for all other error
> > numbers'.
> > 
> > where a return code of '-1' is special because according to man 2 ioctl:
> > 
> > 'On error, -1 is returned, and errno is set to indicate the error'.
> > 
> > Putting the two together means that the ioctl KVM_RUN must 1) complete with
> > an error and 2) that error must must be either EFAULT or EHWPOISON for
> > userspace to detect a KVM_EXIT_MEMORY_FAULT VCPU exit.
> 
> Yes and no.  The key escape valve we (very deliberately) gave ourselves is this:
> 
>   userspace should assume kvm_run.exit_reason is stale/undefined for all other
>   error numbers.
> 
> As arm64 already does, that clause allows KVM to "speculatively" set exit_reason
> to KVM_EXIT_MEMORY_FAULT.  Which is by design.  The userspace flow is intended
> to be "if KVM_RUN returns EFAULT or EHWPOISON, then check for KVM_EXIT_MEMORY_FAULT
> to see if KVM provided more information about why the EFAULT/EHWPOISON error was
> returned".

Hm... In general, "speculatively" populating exit_reason with
KVM_EXIT_MEMORY_FAULT when userspace is not intended to use that information
looks a bit dubious to me. Why do the work if userspace is not supposed to use
the information?

Regarding gmem_abort(). As I see it, if today someone writes userspace that
relies on any of the undocumented error codes propagated from kvm_gmem_get_pfn()
to handle KVM_EXIT_MEMORY_FAULT, that means that KVM can never use those error
codes for any other exit_reason in the future, because that userspace will
break.

I'm sure this was all carefully considered when designing the interface, I was
just curious how this particular problem has been solved.

> 
> > On a kvm_gmem_get_pfn() error, gmem_abort() prepares the
> > KVM_EXIT_MEMORY_FAULT exit_reason and propagates the error back to
> > userspace. kvm_gmem_get_pfn() does not massage the error code, and if the
> > error is not -EFAULT or -EHWPOISON, userspace implementing the ABI fails to
> > detect the memory fault exit.
> > 
> > Things get more complicated with kvm_handle_vncr_abort().
> > kvm_translate_vncr(), similar to gmem_abort(), prepares the VCPU to exit
> > with KVM_EXIT_MEMORY_FAULT and propagates the error code from
> > kvm_gmem_get_pfn(). Then kvm_handle_vncr_abort() does a number of things
> > based on this specific error code:
> > 
> > - If it's -EAGAIN, KVM resumes the guest. Note that KVM, when handling a
> >   *host* fault on a guest_memfd backed VMA, retries the fault handling if
> >   kvm_gmem_get_pfn() returns -EAGAIN.
> 
> Totally fine.
> 
> > - If it's -ENOMEM, -EFAULT, -EIO or -EHWPOISON, it returns to userspace
> >   with 0 (success), meaning that, according to the documentation, userspace
> >   will not detect the memory fault exit.
> 
> Also totally fine, and working as intended.  KVM_EXIT_MEMORY_FAULT is provided
> for scenarios where (a) the issue is likely related to the GPA and (b) userspace
> can remedy the underlying issue using the information provided in kvm_run.memory_fault.

If KVM_RUN always returns 0 when exit_reason = KVM_EXIT_MEMORY_FAULT, which is what
kvm_handle_vncr_abort() does, how will userspace ever be able to handle the
fault?

Thanks,
Alex
