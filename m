Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC051A9FBD;
	Fri, 26 Jun 2026 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782494769; cv=none; b=VLYyowxJY+k8YU9GI2HHGTDK2jhGmtz1+/P/p0givPhH/gLGT8G++VTr/9LDucgIZDUa0yeaIeePMY+NEkgphTqGNpALiV2DrGqbby1i/56Pyg125mU3d1X7vzYJfbMbMFA54JRm4HmIAhFZs/SC42+fvUZ0hSLzxzDFnrgg37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782494769; c=relaxed/simple;
	bh=Z6WMdlXFjoqw0Ry9gHWrOwxGPGzFoRmvA1MUQ1HaCY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwR0eVXPRV2ecQik4JNd0NCpBM44AymdtgbtN12ZDuTHPpuBPHabisLkoEu/WUOLO3colSccjFsswKQoJvFdL0N2Z2SeS4kGEfxrQHaK3urdA+PoYg8ukRpUH6OPrfvlrs6Wbf8I9lNPntpYPld4oZwD1e+gLM84ShzKVtMTJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0XolBJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0XolBJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658821F000E9;
	Fri, 26 Jun 2026 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782494768;
	bh=Z6WMdlXFjoqw0Ry9gHWrOwxGPGzFoRmvA1MUQ1HaCY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M0XolBJ6iKqgB0xbRUcRHq/9NqZzYqfwT7Ebfln64CUP5i6D2Pxu5LqN+EgZY3jHC
	 OQItae9CemrhT7FXmpnNPld1yxrZFAeMZ9/Gi8biP0HI32W946+opLg4unWEuNjvpm
	 6y41x21P9XKT//GaGu3gvVuc+fvMZC2dAs80KROXrXf/su2mWoC6ggbMPVTGPwUPqh
	 jsQbU5R74qsQAdeXfKVre8nCVbx3VuiuVVIso9kBghsKKzudWdjjuyrYG3O6ZQC8hD
	 nQ4xpKoYf34HE+uCdu0i4FdTiVGFsbOxCH7Pkq6NiccksQcy/Y+YSYWObp3XRMs8mM
	 C7uTMURqqWgPA==
Date: Fri, 26 Jun 2026 10:26:06 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Make kvm_io_bus_get_dev() filter devices by ops
Message-ID: <aj62LqPZg8yHcDww@kernel.org>
References: <20260626111344.802555-1-maz@kernel.org>
 <20260626114635.82A0B1F00A3A@smtp.kernel.org>
 <86a4shqxsr.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a4shqxsr.wl-maz@kernel.org>

On Fri, Jun 26, 2026 at 01:41:08PM +0100, Marc Zyngier wrote:
> Gniii... I guess the last option is to bite the bullet and make sure
> that any filtering occurs with the SRCU lock held. Something like the
> patch below. Or just move the locking outside of the helper and keep
> it completely inside the caller.

TBH, I think it makes more sense to have locking done in the caller. We
already have this precondition for calling the other kvm_io_bus*()
accessors anyway.

Then we can drop SRCU once we've gotten down to an object which we know
has a durable lifetime, e.g. the vgic_its struct is valid down to the
last reference on struct kvm.

Thanks,
Oliver
