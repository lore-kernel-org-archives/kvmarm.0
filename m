Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2B2F3C07;
	Wed, 23 Sep 2026 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187699; cv=none; b=rwmc8B7JuPNyvZz//wgXGKnNuJu9ePueO9orM2S/5QN5U58V2Pfahejbpv4dueJk4LTmVzZ8GaP8sW8RiUeabgwsce+4Eq0Ajs3pI70TwIOrqkElarLT+4gW6nxgcWk3dW6t2vf4UBzcu/K6H3g4K50s7XU5xmj01pcex1+MN5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187699; c=relaxed/simple;
	bh=tx0JmpV+L3986AEm9y0BNikH3eDwtF9ncWw2QL8oB6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TX/UCJQzSq8u/uO2JGoAUGIhK8K2JLs3oog5KQGkLqIikKg8tqb1YsWZtV40/96nxgESRtm7ANNLC6uD7Q49iRn57uyvbIaabRwM6u32cOC5MhlP4CxDFVuzmqS0hrzrUXGLKUfI4DARQI25sYKZJ4yBFxFEDEnwR0vs7cX9jGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXF8Yb2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXF8Yb2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155B71F000FF;
	Wed, 23 Sep 2026 18:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790187698;
	bh=y7x5e4cNgJOvwPHZq1gxskbBwrf19kzv7fbsUAQveJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NXF8Yb2dMfgNXAYpGb5ggcs+STbQkyC8RWU+kyObrFFpNsMdIVvYrAUqeYrNkMHTZ
	 VrPLc2uCPxxFuDXEuy7DT5zIxEwmqn7QnfsDoYvwl0EoMyIIxp3GELE6Xc5+uI92Ha
	 Aq9ldDunnQYQPrkfO8jtYRyFPCbaoVZfV8PqDGkbLY8kg+0Df4PUexrzkQbedWscox
	 EFu20F//vpx7BQ7RJb7ro2gtrHk17iEJjvP//lzOjsCoYpSHoN6aXywRPhwtvh+/qM
	 PXsppXD1RcuGWyrS2FN0GxvHQ0Is1IJGQFWM72qMacB+U/HoYkNIynnY69i2859+DG
	 E5xyH2zxepgMA==
Date: Wed, 23 Sep 2026 11:21:36 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: vgic: Stop the VM when disabling LPIs
Message-ID: <arQYsPRcPBlqSR9L@kernel.org>
References: <20260922214212.3327146-1-maz@kernel.org>
 <20260922214212.3327146-4-maz@kernel.org>
 <20260922220125.91CC01F000FF@smtp.kernel.org>
 <86v77w50us.wl-maz@kernel.org>
 <arQBUZJ_uUDQapbw@kernel.org>
 <86tsnf4zt8.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tsnf4zt8.wl-maz@kernel.org>

On Wed, Sep 23, 2026 at 06:56:03PM +0100, Marc Zyngier wrote:
> On Wed, 23 Sep 2026 17:41:53 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > No issues with this approach but it is worth noting that all other
> > callers of kvm_arm_halt_guest() do so behind the config_lock today. You
> > could probably do the same with the LPI disable path.
> 
> Not quite. The IRQ bypass stuff doesn't know about the lock... But
> maybe we can fix it the same way. I'll investigate.
> 

Ah, right, good point.

On second thought, that'd require we hold the config_lock between
->stop() and ->start() on the irqbypass side of things and I'd prefer we
not externalize config_lock and how it ties into the locking hierarchy.

So ignore my feedback, I'm happy with the refcounting implementation.

Thanks,
Oliver
