Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F0938B135;
	Mon,  6 Jul 2026 10:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334786; cv=none; b=umNlSX2iGTqh16SGaM5OsMp9JE8LN11tu3zANpmXO1bxF/xIiyK9nH01cNykC6CUP0+EJ37Dkg7yK6Kr4YA9JwMzYp8eeBpOgAaGMQM0uICzHPTYy9YDa7hXIy6Du8xTiuXsbvikhmFMK9OSPBlbCbfFO6e6vPJK/fxs2bzmYss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334786; c=relaxed/simple;
	bh=XdOvIcJDvYNN59TDeC+CmGQoKKW8Jy07SXmQ4jels5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVQtxZTq5OC2TTJGEMJYQrqLMquKroaGasI+XovP7JwEKD4WAn1EdxXP8tzDJqgicy+56vQqpkMPDFM04ovJVE+SwwbCxpKJEQ3l6WUumD5Y1vFzSexWenuqL6X1nDax67DkZqM1qL+yZ6hCDionVAZAWJCs4MzEZ+WSFijhI9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joXajwEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joXajwEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8371F000E9;
	Mon,  6 Jul 2026 10:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783334784;
	bh=Q0opQoS7LHouo4X8kWJMOcPRwM7gL3N7mCozAIRuEK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=joXajwEQ93eXlwcY5m5J0bSr2gQjeK19Qcs/EjhbyqHHo7q5NWD6d3l0xi4Uy9U7g
	 WvmqnL7k853iiX2Dxr7pWfMoZk3mk6F88eiwLtjYBp9Esc0dSUKW01pY+4Xa0AY6TG
	 Moxf8ktDY4PiXbLh+dh9u+Xy2XOqHC9Lu0m883mqNX9s5/SeOGB3psM0RwOL03qvHc
	 lpyRwqYwBeRKBE7p4HVlupR9LAxwGaDOM1MZu+1dTKsSt6rnVub1tbswZCimht5lIW
	 cD8p94Uin45cfu0xiqnVut5l/j6dY/gjokyBFGhbs+qZR4HXcyxclLGCuyw9YvH5J/
	 S4VUuGX4yheBQ==
Date: Mon, 6 Jul 2026 11:46:19 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all
 memory registration
Message-ID: <akuHe3-51jYs_bbP@willie-the-truck>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-4-fuad.tabba@linux.dev>
 <556ab72c-f440-434b-a24d-84200bd25842@arm.com>
 <CA+EHjTwA1w3eE-mn2r9DCCduFQuoRn_usPO0pxGf1k-jzLsDyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwA1w3eE-mn2r9DCCduFQuoRn_usPO0pxGf1k-jzLsDyw@mail.gmail.com>

On Mon, Jul 06, 2026 at 11:41:21AM +0100, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Mon, 6 Jul 2026 at 11:25, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> >
> > Hi Fuad
> >
> > On 06/07/2026 09:35, Fuad Tabba wrote:
> > > Switch kvm__register_mem() and kvm__destroy_mem() from
> > > kvm_userspace_memory_region to kvm_userspace_memory_region2 and
> > > KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
> > > superset; when the extra fields are zero, the ioctl behaves
> > > identically to v1.
> >
> > Doesn't this break using this on older KVM implementations ? Not that I
> > care, but do others care ?
> 
> KVM_SET_USER_MEMORY_REGION2 goes back to 6.8, so this would break
> kernels older than that. I can gate it so that REGION2 is only used
> when --guest-memfd is requested, keeping REGION for the default path.
> But like you said, do others care for kernels that old?

v6.8 isn't that old, please don't break it ;)

Will
