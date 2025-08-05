Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D651BCA07;
	Tue,  5 Aug 2025 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754405353; cv=none; b=nH0/aRX9tdYBjal7g8AGrD6witM6N2+W5SwEsK7gxGqXoZTphiOs6QMOIIH6PRuQ3kOm9kVNJGFbY43QhJqbg5XEPGuZ0FhQDA5ujcYNuPI4/ypY6m8EADr227Ytya6sgsl+68bhxpQLoPHOhCX8Db6ikW/3buXgiHnbuy8B0vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754405353; c=relaxed/simple;
	bh=g7knE9ug0EmLDYjRKXiNJuFaF+Il11QTq54rtre3QTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg5tot1UorUYzVIbkDNqeqwB1zCfvcREY3hkO/odcmICnXsQrkQX+AyJTJxmIfUz2rkYFlMBDMf3P32wNUgFg5thUGA/9sNdknIVXb9tQVEhasuOmGh5dTt5PD8pE//dMHc54LDlvzlgEe1uTXoKDeqOaUcBbReHtUWSo5RCvok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upqPGit0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upqPGit0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8177C4CEF0;
	Tue,  5 Aug 2025 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754405353;
	bh=g7knE9ug0EmLDYjRKXiNJuFaF+Il11QTq54rtre3QTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=upqPGit0HxC6HEwZVDb3Jwfamg/tWADYMK0T14l0IR9HlXFGJpNC2chDD/mhZDOkR
	 HlFXfopKreQpfgX8X6nWJchIqjBu34biQCrNW8JdVBPOWLhoMPkK5ruHkVlDOWDxAT
	 soY3A4nMlhLEzZhEPAHgH9dnFasI4ICkNLEocDubp9zeCZP1tWE3e7mvivP6d2Da8M
	 +C98jjOQ6ijGd1CgTXx/9Ku8iw+w9yKXeg9f3zMpm4UmtA4IkGUEvTQ/ll9ZLEQhtf
	 EQUYapC684MPbPXqeNlNy++nANFWsk+a/XaYoRZjYottBvy129CEIQq1wPphQRh6cR
	 CzLEqHlqqskLg==
Date: Tue, 5 Aug 2025 15:49:06 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: perlarsen@google.com, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v7 4/5] KVM: arm64: Bump the supported version of FF-A to
 1.2
Message-ID: <aJIZ4v0X74zox1xZ@willie-the-truck>
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-4-995afc3d385e@google.com>
 <aHpP7fntDQ7SMPAC@willie-the-truck>
 <86zfck7pys.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zfck7pys.wl-maz@kernel.org>

Hey Marc,

(we discussed this very briefly offline but I wanted to reply for the
benefit of everybody else and also because I don't recall quite where we
ended up)

On Thu, Jul 31, 2025 at 08:56:59AM +0100, Marc Zyngier wrote:
> On Fri, 18 Jul 2025 14:45:17 +0100,
> Will Deacon <will@kernel.org> wrote:
> > On Tue, Jul 01, 2025 at 10:06:37PM +0000, Per Larsen via B4 Relay wrote:
> > > From: Per Larsen <perlarsen@google.com>
> > > @@ -734,7 +741,10 @@ static int hyp_ffa_post_init(void)
> > >  	if (res.a0 != FFA_SUCCESS)
> > >  		return -EOPNOTSUPP;
> > >  
> > > -	switch (res.a2) {
> > > +	if ((res.a2 & GENMASK(15, 2)) != 0 || res.a3 != 0)
> > > +		return -EINVAL;
> > 
> > Why are you checking bits a2[15:2] and a3? The spec says they MBZ,
> > so we shouldn't care about enforcing that. In fact, adding the check
> > probably means we'll fail if those bits get allocated in future.
> 
> I have the exact opposite approach. If we don't check that they are 0
> for v1.2 and previous versions, we won't be able to tell what they
> mean when they are finally allocated to mean something in version
> 1.337.
> 
> Until we support such version, MBZ should be enforced, because we
> otherwise don't understand what the "client" is trying to say. And we
> don't understand, we're guaranteed to do the wrong thing.

We've lost a bunch of context in the diff here, but there are two
important things to keep in mind at this point:

  1. We've negotiated a known version of FF-A, so it won't be v1.337 and
     we _should_ be able rely on the spec authors not breaking stuff
     retrospectively (famous last words...)

  2. The response we're parsing here is something that has come back
     from TZ after we (the hypervisor) have called FFA_FEATURES. If
     those MBZ bits are non-zero, I think should just ignore them.

Cheers,

Will
