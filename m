Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E97255F2D;
	Wed, 22 Apr 2026 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776886152; cv=none; b=d9ug2Q10uum93ZRWiNxmbQpJlYd6M6etBv0KOdaZuT/gwneMNYCUyy2L2pi2zv0JPwsJq8XMu1fhu40E6QA6RNqNPD+/67kRM/cdKemZiKb/mHuGB+JmZ5XdkhPrZVmR4eCO0IXGqbbEj1ZRHIUdrorW7n95zqq/JliCQjYuiWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776886152; c=relaxed/simple;
	bh=HpvvNxwo4hvkfkj8lkwfO/nM0ZonikcVN6WesLfH1Cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dES6CMSihhORYyvQe6Tt3ER/eNu5K7yQRUAZ08qyvgcNGZ9ez+reoVJFyE81JTDcvPLaiS+GWXuoZBrBos8786kuNrnKDqhpFC3fy4QsCorNzqKpY/l1LrfypdIcSR5NiLaxeZdjJhV5xmCRP1ciYNYdhGK34ZJ9GFXERq5cFow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpA0ld7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpA0ld7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31277C19425;
	Wed, 22 Apr 2026 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776886152;
	bh=HpvvNxwo4hvkfkj8lkwfO/nM0ZonikcVN6WesLfH1Cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dpA0ld7thFoosy13RH91YeO2Nlg85BdJqCtKLBkVTKO5oL3L1dzXf5c04hILIghmN
	 VjSWyeUYiWNJoNnt+c3kGGfT/W4ALHCE/hJGMvucLVhPZgibp1Srcn0dwdXbLjJ+0t
	 yTNUvUh+/Tkz8Rp7NRPFwkjfxuO5f044Hksyp0nmyRv24uFCxDt2iO+Z19c5W8JlQ+
	 fNIaUfSpIV/zsNelk0ls2Mn46tB9/SeIFR63prtZq/sKv7HDL7wMmu8muQaLAE65Ko
	 UsnShlwZ37U8pjWQ7XDtwil+Mtpi2Yf4n51c7NPuCImBpBog54HEA3Q0wu5HdQ3brX
	 LdNZwiOly07CA==
Date: Wed, 22 Apr 2026 20:29:06 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, oupton@kernel.org, will@kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, ayrton@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor
 placement
Message-ID: <20260422-jolly-curassow-of-amplitude-25fbaf@sudeepholla>
References: <20260422102540.1433704-1-sebastianene@google.com>
 <86bjfb18v1.wl-maz@kernel.org>
 <aejOu98q1lEZoFfW@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aejOu98q1lEZoFfW@google.com>

On Wed, Apr 22, 2026 at 01:35:55PM +0000, Sebastian Ene wrote:
> On Wed, Apr 22, 2026 at 01:24:02PM +0100, Marc Zyngier wrote:
> > On Wed, 22 Apr 2026 11:25:40 +0100,
> > Sebastian Ene <sebastianene@google.com> wrote:
> > > 
> > > Prevent the pKVM hypervisor from making assumptions that the
> > > endpoint memory access descriptor (EMAD) comes right after the
> > > FF-A memory region header and enforce a strict placement for it
> > > when validating an FF-A memory lend/share transaction.
> 
> Hello Marc,
> 
> > 
> > As I read this, you want to remove a bad assumption...
> > 
> > > 
> > > Prior to FF-A version 1.1 the header of the memory region
> > > didn't contain an offset to the endpoint memory access descriptor.
> > > The layout of a memory transaction looks like this:
> > > 
> > >   Field name				| Offset
> > > 					 -- 0
> > > [ Header (ffa_mem_region)               |__ ep_mem_offset
> > >   EMAD 1 (ffa_mem_region_attributes)	|
> > > ]
> > > 
> > > Reject the host from specifying a memory access descriptor offset
> > > that is different than the size of the memory region header.
> > 
> > And yet you decide that you want to enforce this assumption. I don't
> > understand how you arrive to this conclusion.
> > 
> > Looking at the spec, it appears that the offset is *designed* to allow
> > a gap between the header and the EMAD. Refusing to handle a it seems to be a
> > violation of the spec.
> > 
> > What am I missing?
> 
> While the spec allows the gap to be variable (since version 1.1), the
> arm ff-a driver places it at a fixed position in:
> ffa_mem_region_additional_setup() 
> https://elixir.bootlin.com/linux/v7.0/source/drivers/firmware/arm_ffa/driver.c#L671
> 

That's just the current choice in the driver and can be changed in the future.

> and makes use of the same assumption in: ffa_mem_desc_offset().
> https://elixir.bootlin.com/linux/v7.0/source/include/linux/arm_ffa.h#L448

Again this is just in the transmit path of the message the driver is
constructing and hence it is a simple choice rather than wrong assumption.

> The later one seems wrong IMO. because we should compute the offset
> based on the value stored in ep_mem_offset and not adding it up with
> sizeof(struct ffa_mem_region).
> 

Sorry what am I missing as the driver is building these descriptors to
send it across to SPMC, we are populating the field and it will be 0
before it is initialised

> Maybe this should be the fix instead and not the one in pKVM ? What do
> you think ?
> 

Can you share the diff you have in mind to understand your concern better
or are you referring to this patch itself.

> The current implementation in pKVM makes use of the
> ffa_mem_desc_offset() to validate the first EMAD. If a compromised host
> places an EMAD at a different offset than sizeof(struct ffa_mem_region),
> then pKVM will not validate that EMAD.
>

Calling the host as compromised if it chooses a different offset seems bit
of extreme here. I am no sure if I am missing to understand something here.

-- 
Regards,
Sudeep
