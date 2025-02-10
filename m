Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2CE25E444
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739213870; cv=none; b=HZxQKvJ3ex0c41NvkRyxmx8jNBqADMSwQotf39TCZ2367mWRuPs5YCuxmAhqfdlvYrA6RHfjXBRex785jNXp38SE6sbhsB6kBJ7APePzFhHMV2x7hCaytuTvnL1nbg5QAD/IH2V0YoI9cnqgTuLSBrNJkrp79kNb9AjG67OeKU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739213870; c=relaxed/simple;
	bh=LDkLwRZBz5JQTbd5kIuwDMkDJpCXUMRyqPPywnxTO6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A74DSFjaXz9S4zF8Nrl/qrVKuIN9pOj5Nt84XqNwBiPdTfKsjmMmz7TxSt041m3XS2dJAV/xFfuAbY+tFMEwxrHz4ppNGVLS3b7+zqX1q4gH3tB3IXAhMzaE/HY50lLfHTeAAs3Dbr81pGG7yuG4bgrqnwuzdqvJCRxYz4/lYIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gJJoxMAy; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gJJoxMAy"
Date: Mon, 10 Feb 2025 10:57:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739213866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GLBZiQvoRWMve47ekFMA9aPN96SiIqRBTIRflJ/8Sbk=;
	b=gJJoxMAyjiATeKiLm/wKcBUg9+9nnXnXljH2/X8Xst7RlqsrqjY/v0Bkpn8cFxhnY4ayJw
	fDm+JdfSdjKMLgutx9xwcHqG7PDcjzHbe4380kJfDubp5RUMlraLLLPRCeL2ofzsp1DuFH
	LqsgsjppM/2hcYe5j83a9DVUp/dF5D8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"sebott@redhat.com" <sebott@redhat.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	jiangkunkun <jiangkunkun@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH v6 3/4] KVM: arm64: Report all the KVM/arm64-specific
 hypercalls
Message-ID: <Z6pMJIbcuPR4AXtE@linux.dev>
References: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
 <20250205132222.55816-4-shameerali.kolothum.thodi@huawei.com>
 <Z6ZPDml0JKuSjLIO@linux.dev>
 <Z6ZPyKK7HLHTtxYu@linux.dev>
 <a9a696009f8e47e0bac9e2d9289ebb0d@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a696009f8e47e0bac9e2d9289ebb0d@huawei.com>
X-Migadu-Flow: FLOW_OUT

> > > This isn't right, vendor_hyp_bmap is very much load bearing. We have a
> > > documented UAPI that allows userspace to control the hypercalls exposed
> > > to the guest.
> > >
> > > The idea being a user wants kernel rollback safety and doesn't expose
> > > hypercalls that could potentially be revoked.
> > >
> > > https://docs.kernel.org/virt/kvm/arm/fw-pseudo-registers.html#bitmap-
> > feature-firmware-registers
> > 
> > To add:
> > 
> > KVM cannot advertise the DISCOVER_IMPL* stuff unconditionally, since the
> > expectation is that userspace implements these hypercalls. These bits
> > may need to be writable from userspace but have a reset value of 0.
> > 
> 
> Ok. So IIUC, vendor_hyp_bmap actually holds the information which Vendor Hyp
> services  are available to the user space and can be get/set using GET/SET _ONE_REG
> interfaces.

Right.

> Currently this bitmap is a 64 bit one and if we have to have a one to one mapping
> between these bitmap and the hypercall function numbers, then that requires
> some changes.
> 
> Because function numbers 2-63 are now reserved for pKVM and the new ones
> introduced in this series take 64 & 65.
> 
> May be we can have KVM_REG_ARM_VENDOR_HYP_BMAP_2  which represents
> 64-127?
> 
> Or can we take the next available bits(2 & 3) for KVM_REG_ARM_VENDOR_HYP_BMAP
> and then map it to the function number appropriately (64 & 65) when
> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID is handled?
> 
> Thoughts?

Adding a second register seems reasonable so we can preserve the mapping
of bit position / hypercall #.

-- 
Thanks,
Oliver
