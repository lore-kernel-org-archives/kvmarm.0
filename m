Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BE270AE6
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 17:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709228237; cv=none; b=PbQc+VOlgab56jvTTrIZ69fP1jXsd3uO20chBNhoUfk8NfXEbpsWi9vciwYlewdnt1In3vUDxEfFb6EQyMHGnV+nBpCSyiT2kGHs3PdZA1OQc529Yca9tnnJC5IX3YwJ20tNrXYm96YUcCgEswH4k0tWXeUw8ggYnKywLSGLkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709228237; c=relaxed/simple;
	bh=zSeSTywi61dvjOnSOkMn9BfYVqbfDy2w4tUnD6UpIWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvjZ9hFxCmV1l2u++VMEKAy/Hw2N7bALbjp8NckMxzgC2XnbxiogxV4ZEQjHeJJakJfDAVj/IBQDifltIfuSCF+eAkg+B+IkfRLxugh43P6AtelNmP1+Yk7TQSCxkyB/F4nPVJQT2+hLxhoR+3p6balw6mtN4OptvCVe0AsG1CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kcMjHD4Z; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kcMjHD4Z"
Date: Thu, 29 Feb 2024 17:37:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709228233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AbLYhSrmn+ej2BrFv+AeMp59GzhSQXfGc9DLMJUhPk0=;
	b=kcMjHD4ZeSb61CCIwcSGVG+8a8CH6NIC5/pnWWKM5dRUmDK1kbFvbghC4Gga9ISSd/oQFt
	UaLBT3coRruqVXcIFDnIwgjm2CZagHNp5/nXagw9cA48jtGd7yFYEHrR/CIy8IW2Sc0yMZ
	UokemPfV9HMnYyEpdRp18b5X4/ofRWA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode
Message-ID: <ZeDAxL9nr_qmYGS9@linux.dev>
References: <20240229145417.3606279-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229145417.3606279-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Thu, Feb 29, 2024 at 02:54:17PM +0000, Marc Zyngier wrote:
> When running in hVHE mode, EL1 accesses are performed with the EL12
> accessor, as we run with HCR_EL2.E2H=1.
> 
> Unfortunately, both PMSCR_EL1 and TRFCR_EL1 are used with the
> EL1 accessor, meaning that we actually affect the EL2 state. Duh.
> 
> Switch to using the {read,write}_sysreg_el1() helpers that will do
> the right thing in all circumstances.

I was wondering if there was a way to surface these screw-ups at compile
time, but there's nothing elegant that comes to mind. Guess we need to
be very careful reviewing "nVHE" changes going forward.

> Note that the 'Fixes:' tag doesn't represent the point where the bug
> was introduced (there is no such point), but the first practical point
> where the hVHE feature is usable.
> 
> Cc: James Clark <james.clark@arm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Fixes: 38cba55008e5 ("KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
