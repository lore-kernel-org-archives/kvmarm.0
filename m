Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742A0390239;
	Tue, 23 Jun 2026 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782238232; cv=none; b=ghpQxUcq2J6b+vbNqQ1o3CywpAWNPi+d2veHn80kOyhqAnnyXq4oV21VgPeXwKwtoMUgQCPH3ZuKr7qFsSmBwC02UwKPkjjElPy/AqLpwTaRMeXRPRZr7vQhFUkZ4jo+B0zBjRcnM7LDZdV7+/SgQyB/azKhqa/KlKrxG28Ym9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782238232; c=relaxed/simple;
	bh=iQcOJX9HH4cEJulaKgZgAFvfa3GW/KlOaXXDMdc5y5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cB2etK9JyDsiT2XxK/ULMGQ1wLcJsKvYeybQJDCgPYL0H3f3lqIyzx1oTMJGGxfH7r1SKBoGuuPr9QR4L85GEPOt7zL+sQUu4WqnEC8Z8UYKPKiM6YevPmxRIIs9fOpjfFRRpQDBAh5vDl+1wNC5uvEjZN0phFh+hf+PCWwSLFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Loq16k12; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Loq16k12"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03760175D;
	Tue, 23 Jun 2026 11:10:26 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 652003F632;
	Tue, 23 Jun 2026 11:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782238230; bh=iQcOJX9HH4cEJulaKgZgAFvfa3GW/KlOaXXDMdc5y5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Loq16k12IB0IT8CbwsIGk96HxLOeHSzaa53+QlbPaI5gl7KZEAWTmIJ8fgYpDn7GE
	 kDHJy6oq5+QIT0l9SunLxHcqzx1RDU7VenSBzuKh/Uql3rdbAr5TvNAGdBlRDwmCSU
	 QSGIyDO7Qh2YzOR+GRYE1mRc/kQ7UCve16aj2ctw=
Date: Tue, 23 Jun 2026 19:10:22 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Move to per nested mmu ptdump files
Message-ID: <7jmgyrjdfep3jmyva2owu5pw435pcl76cfddnuiyxt5gkciqry@5n74ctjqewdw>
References: <20260623142443.648972-1-weilin.chang@arm.com>
 <20260623142443.648972-4-weilin.chang@arm.com>
 <20260623144102.4C4C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260623144102.4C4C81F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 02:41:01PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Kernel panic on error path due to kvm_free_stage2_pgd() being called on uninitialized kvm_s2_mmu elements.
> --
> 
> commit b126bbf9b1139c4e5f8f15f1b55bdfca981c84c3
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
> KVM: arm64: nv: Move to per nested mmu ptdump files
> 
> Move the creation of shadow page table debugfs files to be per-nested-mmu
> instance instead of recreating them on context binding, avoiding sleeping
> operations while holding the mmu_lock.
> 
> Link: https://lore.kernel.org/kvmarm/aiuF0KSvvv-ZozI1@sm-arm-grace07/
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index fb54f6dad995c..07f94b8b82365 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> 
> [ ... ]
> 
> > @@ -125,6 +130,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> >  		return ret;
> >  	}
> >  
> 
> [Severity: High]
> This is a pre-existing issue, but does the error path cleanup loop just
> above this return in kvm_vcpu_init_nested() cause a kernel panic if
> init_nested_s2_mmu() fails?
> 
> The cleanup loop unconditionally calls kvm_free_stage2_pgd() on array
> elements from kvm->arch.nested_mmus_size to num_mmus - 1:
> 
> 	if (ret) {
> 		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
> 			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
> 
> For any element that failed initialization or wasn't visited yet, the
> kvm_s2_mmu element remains zero-initialized, meaning mmu->arch is NULL.
> Inside arch/arm64/kvm/mmu.c:kvm_free_stage2_pgd(), it calls
> kvm_s2_mmu_to_kvm(mmu) which derives the kvm pointer via container_of()
> on mmu->arch. This yields an invalid pointer, and the subsequent
> write_lock(&kvm->mmu_lock) dereferences it, crashing the kernel.

Yes, this can also happen. Reproduced by simulating an allocation error
(-ENOMEM) return from kvm_init_stage2_mmu() for a nested mmu.

I'll work on it.

Thanks,
Wei-Lin Chang

> 
> > +	for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
> > +		kvm_nested_s2_ptdump_create_debugfs(&kvm->arch.nested_mmus[i]);
> > +
> >  	kvm->arch.nested_mmus_size = num_mmus;
> >  
> >  	return 0;
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260623142443.648972-1-weilin.chang@arm.com?part=3
