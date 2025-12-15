Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E29133290C
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 11:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765799205; cv=none; b=FsgXMG/b9HIgE87NvvqDfqDx832Ecq3+MqIomLagfSi0WHJeExJaTDM6bAoRnqQdARfzF031n0azfPRpZot6F8VS+4QindWkJBcJeYv1AsDPqOvu5W7WKlyVPpUpqCK7oF1tpViK2I1McW2R+sJzCSGx12aqJtU26e8y59H6hX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765799205; c=relaxed/simple;
	bh=VqfUUx2eslgn7ShVCtIsqJDTLLPiO9ZT85rQqHrBemw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUkVm6tTde+RgNpkYSfYOSZu2i4Narx7SEx1v5CJN5B2Dgh2H272nLR/4WuDReMn8lO2uvTGksph6zTtugaLZxj3QHEfksBaGbi5c/nHc4nd32FexJUiskatCcGSJh0ZJLApSBh2+nW1zbsyXundXjbXMiBZNszEbfytT1Glwcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7322F497;
	Mon, 15 Dec 2025 03:46:36 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F1B63F73B;
	Mon, 15 Dec 2025 03:46:41 -0800 (PST)
Date: Mon, 15 Dec 2025 11:46:38 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Leo Yan <leo.yan@linux.dev>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 05/35] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Message-ID: <aT_1HimOyJk6H1ko@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-6-alexandru.elisei@arm.com>
 <20251214121842.GA16796@debian-dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214121842.GA16796@debian-dev>

Hi Leo,

On Sun, Dec 14, 2025 at 08:18:42PM +0800, Leo Yan wrote:
> On Fri, Nov 14, 2025 at 04:06:46PM +0000, Alexandru Elisei wrote:
> 
> [...]
> 
> > +void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
> > +{
> > +	struct arm_spu_entry *entry;
> > +
> > +	guard(mutex)(&arm_spus_lock);
> > +
> > +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return;
> > +
> > +	entry->arm_spu = arm_spu;
> > +	list_add_tail(&entry->link, &arm_spus);
> > +
> > +	if (list_is_singular(&arm_spus))
> > +		static_branch_enable(&kvm_spe_available);
> 
> We can simply check if list_empty(&arm_spus) in kvm_supports_spe(), thus
> the static key kvm_spe_available is not needed.  Another benefit is this
> is consistent with CPU PMU's virt implementation.

Sure, that makes sense. I think I added a static key because I was thinking
about performance on hot paths, but looking at the series I forgot to actually
make use of it.

Thanks,
Alex
