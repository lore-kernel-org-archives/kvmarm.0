Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E221D5AE
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740595999; cv=none; b=CjkEBSTwWC3Yq2Llg4y0g7tG0Zb9HjLXgbAEoAUhCEF3v1i/kUvneiXkMc4zq8PgsQz1v4WUHxtu1R9+E4RlqC6VOC+hlDLG5BF/CyB0Br8WIL5U75HM1CnwtFhv89AT4DTtInXhYIh2qWhgBrq6GlTDy6P93K2Q8nOgloh31vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740595999; c=relaxed/simple;
	bh=XywV1jJeqwKdmnyfCuLlfqM48Tpm9uLxnwmmf5xf3lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfYpRWiUYPtblreMgENns0Tk1Wi7wf14v75NpTke3GAjv8h2I+04G6cErhLdRhf+5MNbldmImw7vpSSftiyOCqgKOA4ZkjgWB45cCkhkxqKOnP4CAxkUfooeh9K0JabJuVdzOf15a3CQ3y5jgKXK3c85LlOYsbvnG5EgIxoClcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EqcrrWVo; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EqcrrWVo"
Date: Wed, 26 Feb 2025 10:53:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740595992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5vPC2HRo1hrIvIy3DB6LHP7VD01JSHIUgbDVrdNw5bA=;
	b=EqcrrWVoxCoUqMnePpCuuapSo7K1up9nFdRh5o7LRraeYmF2e9eFtEXs6lPsg2Lo08BQBh
	jam+VEpcklsGqq2VaiO2peoW93UJldoPlwZy7X6E/wuU89skbpNtBjyXt99Y3Ef9aTEYrU
	poRX9YUfRQNJgQUr6Py193bHXDFWjrI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	qperret@google.com, vdonnefort@google.com
Subject: Re: [PATCH v1 1/3] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
Message-ID: <Z79jERSoEvEtZI7k@linux.dev>
References: <20250214150258.464798-1-tabba@google.com>
 <20250214150258.464798-2-tabba@google.com>
 <Z77n_Gv0X0bolONW@linux.dev>
 <86a5a9q90z.wl-maz@kernel.org>
 <CA+EHjTwRNj6z_TTCXR8UNiB0ty=85_VKWDVsFOLke31UGnBE7A@mail.gmail.com>
 <865xkwrai1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xkwrai1.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Feb 26, 2025 at 03:28:22PM +0000, Marc Zyngier wrote:
> On Wed, 26 Feb 2025 12:44:49 +0000, Fuad Tabba <tabba@google.com> wrote:
> > On Wed, 26 Feb 2025 at 02:45, Marc Zyngier <maz@kernel.org> wrote:
> > > This is a copy/paste of what we have in kvm_calculate_traps(), and the
> > > result of the removal of the dreaded HCRX_GUEST_FLAGS.

Ah, I missed that.

We probably should've just tossed it at that point, doing configuration
for features we don't support is a bit confusing.

> > > > Any objection to dropping this bit? I can fix it when applying the
> > > > series, no need to respin.
> > >
> > > Whatever we do, I think we should keep the two side of the trap
> > > configuration in sync, as this is otherwise a cause of bugs.
> > 
> > I could take the initialization of hcrx part from
> > kvm_calculate_traps() and place it in an inline function in
> > kvm_emulate.h. This then would be called by kvm_calculate_traps() and
> > pkvm_vcpu_init_traps().
> > 
> > What do you think?
> 
> That could be a good option indeed, irrespective of the fate of SMPME.
> 

Agreed. Fuad, would you mind taking another pass at this with the shared
helper?

Thanks,
Oliver
