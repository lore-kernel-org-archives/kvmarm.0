Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B2273FD
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 06:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721284556; cv=none; b=tIovCsWCK06PuFlN9xFs6CqMxpyCs9Ag4qWC4KpwuLPLrYW2sv4JftyHLPj74a7PNdDxT7Y9lhTdX4jqToRX/z+1kaXajbvqTxqbeA4EU8hgCrPscfBXAQD0nht8mHkdwO0f/vkXI2HzR/GIVLu13vw2h8pE5qSc3MhJRvVwleo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721284556; c=relaxed/simple;
	bh=WEoI/jlO1KNksYFzMJK3ximHdWWunHC33aWhhJ1R06o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/7sRGUp0ohZABbbIOwLxWKacHYsWxKCjU5vntvTWb9RkbRr7pcfe9i1Guv7lIk+1HrAx41YqTLl5V20zGcxys+0X0vcfygspojGBs7dz8ljj/cd2T7rlrYxV+PIBhwTciEk1jF1WOU/z1f/xmaX6HCOqq+5jZTZSuJe7oZ15uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LprSzpdR; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LprSzpdR"
X-Envelope-To: shahuang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721284552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=edZsUsnY1AwRV/5CHltQ1IFyYB5NPQx9b++gCTSIpio=;
	b=LprSzpdRtRT9DCGiydEuvgSPYHe2Ka398bazDSoOOsO9uSreab4fgj+2pmcdYJ2YNMwILM
	1WiY9czoycY1q5c7okzZQ5H2RR+NnJG3+lpTOBVCksWnAcr1n8UWUbt7WChdWZCorrCbgp
	6Ad5ERGii8Bj1M5cF4wKf4Z61fTzvh4=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: broonie@kernel.org
X-Envelope-To: eauger@redhat.com
X-Envelope-To: sebott@redhat.com
X-Envelope-To: cohuck@redhat.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2024 23:35:42 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] KVM: arm64: Allow userspace to change
 ID_AA64PFR1_EL1
Message-ID: <Zpi3vjxLQ37Q_8OV@linux.dev>
References: <20240718035017.434996-1-shahuang@redhat.com>
 <20240718035017.434996-3-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718035017.434996-3-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 17, 2024 at 11:50:15PM -0400, Shaoqin Huang wrote:
> Allow userspace to change the guest-visible value of the register with
> different way of handling:
> 
>   - Since the RAS and MPAM is not writable in the ID_AA64PFR0_EL1
>     register, RAS_frac and MPAM_frac are also not writable in the
>     ID_AA64PFR1_EL1 register.
> 
>   - The MTE is controlled by an internal flag (KVM_ARCH_FLAG_MTE_ENABLED),
>     so it's not writable.

The flag isn't the relevant part, what's important about MTE is that it
already has a separate UAPI for controlling it (KVM_CAP_ARM_MTE).

>   - For those fields which KVM doesn't know how to handle, they have
>     are not exposed to the guest (being disabled in the register read
>     accessor), those fields value will always be 0. Allow those fields
>     writable is fine, since the userspace can only write 0 into those
>     fields. Maybe in the future KVM know how to handle some of the
>     fields, then they can be written into other value.
>     So let them writable.
>     Those fields include SME, RNDR_trap, NMI, GCS, THE, DF2, PFAR,
>     MTE_frac, MTEX.

This doesn't seem right. We're committing to a UAPI behavior the moment
these fields are advertised to userspace, which is rather difficult to
do for features that we don't even implement.

Please only advertise the fields known to KVM and leave the others
unadvertised.

>   - The BT, SSBS, CSV2_frac don't introduce any new registers which KVM
>     doesn't know how to handle, they can be written without ill effect.
>     So let them writable.

I think the handling of ARM_SMCCC_ARCH_WORKAROUND_2 needs to be updated
to consider the presence of FEAT_SSBS in the guest's ID registers.
Otherwise we'll wind up returning NOT_SUPPORTED and the guest will
conclude it is in a vulnerable state.

-- 
Thanks,
Oliver
