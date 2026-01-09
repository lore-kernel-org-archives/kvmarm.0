Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5332523EAA0
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969054; cv=none; b=encvdKakOIFfdXbKa0ju+AvmaEd1R4durg/GxHrLZor0WLecvLXAjg5sGmQv9OjFd6XvWWlxPmCmQ1H7dFtiIOtoXaWNqExuuRcwPtKsilDqKbf1UFyTHQy5L670PqEFTb8qcHQ7hJ6IR6bRl4xwZWDv28gKRzakx8bKhlx39kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969054; c=relaxed/simple;
	bh=WRMdRB0WGfKqmMwZE2T0s3rmNl/KXUBkFrpSMhObnwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dA1gX8daVnhC3aWf7UbLfgP+Kupx3Ct5v+Rh0ofw7lXuwWjguR5/4peThYK6/s6WudI3z+00D9Mkn71H7ldZYt5Dm+fq4+eCR0ZHSRZk1dXlCNs0GQr7zC3jc3p515qVRHiSrCeW3YTDSEByv6GEuUqsA8zyzZ3Oj6MiQxG1ZXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUrPBhq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUrPBhq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2301CC4CEF1;
	Fri,  9 Jan 2026 14:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767969053;
	bh=WRMdRB0WGfKqmMwZE2T0s3rmNl/KXUBkFrpSMhObnwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SUrPBhq1CEgxQCSYoCG7gEf6kyj7n6NyJdfnTyJYW2KQu+ya+3jlF4/TRpKzqp1/v
	 UI59BPREbt8kFaFuYpqrxwyXLbEMJ5u4o4QqpDfapdnhZZqkebKhWtoxRxFYgCVIFT
	 4zlXLarv/4zOJ+Uhhz3a8r+mdjUaAUs3x1zi5LM7cKwNErcJysuNob3u62rwjF/jF7
	 CHAexiWjjjTugv59dlY83T1XJOhMYfpB18fsD9Rt9HZaDZAyvekYTNl7GfQ127M3lA
	 CVW6Tt/k1mYBloqNkqPu1o8AuiNWy639+k4yVDM6mNrMO6CS6hfiMfrCOCVzKLstlX
	 6AawgeGxb6aNA==
Date: Fri, 9 Jan 2026 14:30:47 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 10/30] KVM: arm64: Introduce __pkvm_host_donate_guest()
Message-ID: <aWERFx9PwX1yED9H@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-11-will@kernel.org>
 <ocpyeygxhp52jt2mcqq4tmdodubrfdwo4xqvbphmr34x4etrkk@f3ag3a7j5fru>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ocpyeygxhp52jt2mcqq4tmdodubrfdwo4xqvbphmr34x4etrkk@f3ag3a7j5fru>

On Tue, Jan 06, 2026 at 02:48:00PM +0000, Quentin Perret wrote:
> On Monday 05 Jan 2026 at 15:49:18 (+0000), Will Deacon wrote:
> > +static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(u64, pfn, host_ctxt, 1);
> > +	DECLARE_REG(u64, gfn, host_ctxt, 2);
> > +	struct pkvm_hyp_vcpu *hyp_vcpu;
> > +	int ret = -EINVAL;
> > +
> > +	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> > +	if (!hyp_vcpu)
> 
> I guess we should check this is a protected VM here, else a malicious
> host could donate pages to an np-guest. I didn't try to think through
> the implications, perhaps it's fine, but it feels unecessary so I'd say
> let's be restrictive here.

It's definitely harmless to add the check, but it's also hard to justify
in my opinion. Can you think of anything that can actually go wrong it
a malicious host donates memory to a non-protected guest? Generally,
I think the fewer places where we have to distinguish between a
protected and a non-protected guest in the hypervisor, the better.

Will
