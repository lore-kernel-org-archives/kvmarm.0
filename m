Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DE8366561;
	Wed, 22 Apr 2026 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776885453; cv=none; b=RNaZI6J6UlEeWmehhwBn1IymD+f5Cb01aCq/djvdD9/Y0u6LZqgRYsrKBXeZ4p4mIBnX7Vy2ziTeQq12v5R6pUNejupaemZcJOhHViFt3IGZvRxGKluYEeTifzkzi8d8z4cp1JxP9sS0O0gCf9cOMm7Q9894cp9BB0yskc2UdJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776885453; c=relaxed/simple;
	bh=E/oc/oHx2u47SGMF8ixt0+90mCKZ9PbyioD8Sq4qFEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0+E+PqMbLKmTrxt9rwfHvw/kzYajnQhzhNvGw32dQwPxYnWiXNh0mnIVZ8wjzY2p/C3wwCU07qLPd7b/5mx7MZ/TWqdbitLRyEvbVy4YIB6LUstq+//0/Wi7GNVrAUGdITUbSc5+SRxewFoUbA4YzKXQ6XM1VMT5rxzIPiLEI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdTWVLNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdTWVLNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76860C2BCB4;
	Wed, 22 Apr 2026 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776885451;
	bh=E/oc/oHx2u47SGMF8ixt0+90mCKZ9PbyioD8Sq4qFEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KdTWVLNAAumgTgdsaXyynxoyzJO0TGaiqIU2nFOJic5/8XwRkXmarkqEDOZEUO187
	 4IQr1VpGNvJa1qdoeHL+HizfWGzI+Iz5DJR9GrFKZg3hvREYXmgslq4gXwS5oXZ/KO
	 9wE+KZcQPUTWxw9ah2zTJ3Arv/HnQzuy2l34Q3sKZ1ctZyY0ae9+Uwls2KHoZ04VrZ
	 QyOmzjH8jwb0ZKMaaxxDuqRlQKgI+5RXoU1hfIHdlGW4CQBfxu3Y4yHark4Kt6ZeuI
	 Gjc8+Y0sYhFmj12qg6UEfukVehmdgwaLxlLienJxyU7Wq/jOktqHNUcF8c5vwfoMWa
	 TXmWIL3IBil0g==
Date: Wed, 22 Apr 2026 20:17:26 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, oupton@kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, will@kernel.org,
	ayrton@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor
 placement
Message-ID: <20260422-spotted-honored-rabbit-a7dc34@sudeepholla>
References: <20260422102540.1433704-1-sebastianene@google.com>
 <86bjfb18v1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjfb18v1.wl-maz@kernel.org>

On Wed, Apr 22, 2026 at 01:24:02PM +0100, Marc Zyngier wrote:
> On Wed, 22 Apr 2026 11:25:40 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Prevent the pKVM hypervisor from making assumptions that the
> > endpoint memory access descriptor (EMAD) comes right after the
> > FF-A memory region header and enforce a strict placement for it
> > when validating an FF-A memory lend/share transaction.
> 
> As I read this, you want to remove a bad assumption...
> 

Indeed, it matches my understanding as well. I got confused with the
code change initially only to realise you want to restrict the choice
of offset.

> > 
> > Prior to FF-A version 1.1 the header of the memory region
> > didn't contain an offset to the endpoint memory access descriptor.
> > The layout of a memory transaction looks like this:
> > 
> >   Field name				| Offset
> > 					 -- 0
> > [ Header (ffa_mem_region)               |__ ep_mem_offset
> >   EMAD 1 (ffa_mem_region_attributes)	|
> > ]
> > 
> > Reject the host from specifying a memory access descriptor offset
> > that is different than the size of the memory region header.
> 
> And yet you decide that you want to enforce this assumption. I don't
> understand how you arrive to this conclusion.
> 
> Looking at the spec, it appears that the offset is *designed* to allow
> a gap between the header and the EMAD. Refusing to handle a it seems to be a
> violation of the spec.
> 

+1

-- 
Regards,
Sudeep
