Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DDE62FB97D;
	Tue, 23 Jun 2026 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782237969; cv=none; b=D+qLLbkdvJTTHUUl2xYxmz7EA9HskhsKLvQ3w5x+nv/JtnblE7ySUIbOLTv9CMZ3gBSzVcfoMPqhC/eKQJBBIXbaKTnwYSLScYdpEHAQf/9ycLYlmlSYlekwxs5dK8Jx55uZiB4FQbMIen4hqMY4gy7YJ3VEPa10DLwx1hMKHDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782237969; c=relaxed/simple;
	bh=Tuvz71pHY3CmXGxnNEKjZJFrNbzU+iKTcWwYIjhrdYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/yi/jOXvXhwP51pZ6FIMnPMCwj+tDRNj7bNLmOKcuttulJC4Z82qWQDz1yxepq8QRTlvAhILBk4fOyWos33AsqsZ6lLy9bLm61wUFdILZtNNEVhfLobkbo7SQ8W4sOPbvxqdOkE7J30+uU+YeZ/pcLMiMs+mNIuXeHA9I4+pY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FncEJ90k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FncEJ90k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AD53175D;
	Tue, 23 Jun 2026 11:06:01 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE6DD3F632;
	Tue, 23 Jun 2026 11:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782237966; bh=Tuvz71pHY3CmXGxnNEKjZJFrNbzU+iKTcWwYIjhrdYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FncEJ90kAvJ9NLtvRWqX/EggsPciNqlc+TMRXQ3wcmE0jT4OKbD4Cmazj9UZiFNY1
	 oYUhZw8W98a1gW7BYWtHfHpwGymaXl1zE+ZqvsQO8RcQkHinCjuPG2Ut/rBQDPv4kH
	 4qtR+aj3V1aX3vHW8ObUoXzPUf4kwyr03dx7fR9c=
Date: Tue, 23 Jun 2026 19:05:39 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/3] KVM: arm64: nv: Print nested mmu info in
 kvm_ptdump_guest_show()
Message-ID: <nj6bps35nrytud2iegkhpsl45ptl26tdvczoahtvch2gmqxnfb@2rtrlvlsetu4>
References: <20260623142443.648972-1-weilin.chang@arm.com>
 <20260623142443.648972-2-weilin.chang@arm.com>
 <20260623144054.B91D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260623144054.B91D21F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 02:40:54PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Pre-existing Use-After-Free and NULL pointer dereference in debugfs handlers due to concurrent MMU teardown.
> --
> 
> commit 09a8b839f22b6806feaaf12ccca901b340acd24f
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
> KVM: arm64: nv: Print nested mmu info in kvm_ptdump_guest_show()
> 
> This commit extends kvm_ptdump_guest_show() to print VTCR, VTTBR, and s2
> enabled information for valid nested MMUs. It also converts the MMU lock usage
> to use a lock guard.
> 
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index c9140e22abcf1..2a6afe67646af 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -155,9 +155,16 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
> >  		.seq		= m,
> >  	};
> >  
> > -	write_lock(&kvm->mmu_lock);
> > +	guard(write_lock)(&kvm->mmu_lock);
> > +	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
> > +		if (!kvm_s2_mmu_valid(mmu)) {
> > +			seq_puts(m, "invalid nested mmu\n");
> > +			return 0;
> > +		}
> > +		seq_printf(m, "0x%016llx 0x%016llx %d\n", mmu->tlb_vttbr,
> > +			   mmu->tlb_vtcr, mmu->nested_stage2_enabled ? 1 : 0);
> > +	}
> >  	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> 
> [Severity: High]
> This is a pre-existing issue, but can this dereference of mmu->pgt cause a
> NULL pointer dereference or a Use-After-Free?
> 
> If the process holding the VM dies, kvm_mmu_notifier_release() is triggered.
> This uninitializes the stage-2 MMU and sets mmu->pgt = NULL for the canonical
> MMU. However, the KVM struct can be kept alive by open file descriptors for
> debugfs files, so kvm_destroy_vm() is not called yet.
> 
> If a concurrent reader accesses the stage2_page_tables debugfs file and
> invokes kvm_ptdump_guest_show(), could it blindly evaluate
> BIT(mmu->pgt->ia_bits) here and trigger a NULL pointer dereference?
> 
> Similarly, in kvm_pgtable_debugfs_open() for other debugfs files like range
> or levels, the mmu->pgt pointer is cached at open time without synchronization:
> 
> 	pgtable = mmu->pgt;
> 
> 	ret = single_open(file, show, pgtable);
> 
> Could this lead to a Use-After-Free in the show handlers if the page tables
> are freed by concurrent MMU teardown before a read occurs?

Yes, this can happen. Just reproduced it by open stage2_page_tables ->
kill VM -> read file.

I'll work on it.

Thanks,
Wei-Lin Chang

> 
> > -	write_unlock(&kvm->mmu_lock);
> >  
> >  	return ret;
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260623142443.648972-1-weilin.chang@arm.com?part=1
