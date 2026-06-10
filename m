Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88EE413245
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781099794; cv=none; b=mf7mNtX/r3aXrNaIgrZ7kVjqGcK0K4UaCPB/PWULxNwcb3FA1m1AXyn1H3qf4SQw0ZjItg4GSur6ZyE5MxXNJlMSPSEoEwgh6x9dijbA6/dj71InB83RmjCu3TMMwZR2kO34t7AEey1Ojni+gEDT5aIPfgTUcBweERDttrPgL5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781099794; c=relaxed/simple;
	bh=pSKkvcdgY/elb1Zv2hNLL4Bv9H5QA0QKePDJaPMMupI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5k39Rlh5BiI1pNpSvMkL50dgV0soVrCTWv6s+IZZVZz2D9ESeR9+A4QANQiM95/n6Z46KhE3bo0A4sXAJJVf8W/T8fOZrvLFDbFOTfbg5lIU/qQ5oeJlmoP1QKC/9lid+Kb78+zXf5UMO6PCeNEYBp+OpqvjGwHSlFY55VFUFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PgPLp0un; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PgPLp0un"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so59702955e9.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 06:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781099789; x=1781704589; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uygtCkOWTfgppeg9iSnO+7F/NY50yL00/8USYGKdihE=;
        b=PgPLp0unYnMcl11+7/CBuXyILrnF9rhfkmljNWKho7CoBerVHHdA15A2m7R/pSYnTe
         PCJTjwzTwgxUKQ6WI0t89zGkrmv5aaYhBga4fJj+ltrX79PFtvdRnc3xFgoeKK2Oiyng
         nu1iHaSv/87yDZOkhmKlzpcYxKymrokiShv02mC7dT5ZnolfnQ1yH+H1jAGO+HcHDFJ7
         dono5IjKQ5nX/tTVqL9NQ08vxjYjw00pydFY89Qc06CzjNZKAFMbGE/u6sK0L8nd0Vmx
         ldcR9UvKQAOhtqxNnBBXnx+7ewGpSTrNtHzRTOnDwpFp2eM5lNIy2ixSVftwNhR9iY80
         bXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781099789; x=1781704589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uygtCkOWTfgppeg9iSnO+7F/NY50yL00/8USYGKdihE=;
        b=LFv7Y+muv6B4GDdzDNReyRHjpC0uoNDQtStKgGtRieqKD7zF+ZLeJOguNgtSi4bMva
         EB1/kPWMJkmYG5ZyiRErGy4TwmVG2qm/iTw7GoLwJNqY+h9kU6k+/hwC2t2LsusA214g
         PciDHcg9UQpSh+E1y3BYbwk6Rp5pCvvlyu5I5uZ/wdlKP/Xv78wPcNxho6KXVRx2uTb3
         zQfYtDDgIKsROcvc4aklg5wAU7mJu8pkCovYLRX10a18wmfgsLXJfnd7h0TAxn59yHYY
         qjY2d8NPNWYgJiVWcqHijKvqcWA5CJiY32dcbMcmcCWVsUOoHPN5MJEz/hMWRoBGtb/6
         NG9g==
X-Forwarded-Encrypted: i=1; AFNElJ9nQ/BZk2yPx3DxOo98royvms8ZboEQhqcGKR3Vhuq5B6m0ssJSBYdiRgkxTabzSb6dhFskfTg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4s6OoF/vmOn90jDpcvcH75GLhlLcKjYhv12w7euHU8ULgrBCU
	SeI4Mrlp+smRlpFrCY9izEM2RzQHrq+XZEUyK7C3FHAXy98eSWyie8v/Iecbu8bSkQ==
X-Gm-Gg: Acq92OHAnVLXLaV6gI1n+Zjq8L8XgOKAtjagz9YcaJH+GruhqmkovWF1ss9c/STHRyI
	w+zJKAsSbcTos6wfXMetT8xU8VDGxbA5Hu11yflf9GVVow8NwG5Cpu2V94RcnPHcV+Jgoxbup2y
	GiPa5Gp2tOOLtiXBNTGa1LNGraFY3vF1VNqb3J3v8RvrFf1bgB1TFAaW7WpAMnHjIAwMyHR9RDe
	YNoG58dHfIGaQTvyrzSHNzNCsM+ATz0tZ7l+Vkf7DJGbHJ9NActOtOm3EIbq4E+7pgV0+bQgs2y
	FGIS60N1i7NLVOgOpAqHcQpgXOVncRG7xD7scCtUspTNwpUwT/8I0CwYYx3jJcSe5sJQjZYVSG2
	cU17r2Bhfz4Zfi3YcgEEgd5i77xKGwqwhJYwS6VbcQiYDj1douytP7JGDfWZ/tToQ7W9opd0R7j
	qJ0D2+K/W5zP8ia7fH7AYVhyfwL1ZLbOMSVnC/4oInm3wPScLtTE8KqxIW5x/Aq0hA96eCycKu5
	nWsjw==
X-Received: by 2002:a05:600c:8b6a:b0:490:44eb:c1d9 with SMTP id 5b1f17b1804b1-490c26217damr373581055e9.28.1781099788613;
        Wed, 10 Jun 2026 06:56:28 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3c15cesm548817495e9.5.2026.06.10.06.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 06:56:27 -0700 (PDT)
Date: Wed, 10 Jun 2026 14:56:24 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ailtCAcEaJIgZ5Ap@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
 <ailVcN-bxY30-XBF@google.com>
 <ailXKA1VG8vyKNfV@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ailXKA1VG8vyKNfV@willie-the-truck>

On Wed, Jun 10, 2026 at 01:23:04PM +0100, Will Deacon wrote:
> On Wed, Jun 10, 2026 at 01:15:44PM +0100, Vincent Donnefort wrote:
> > On Wed, Jun 10, 2026 at 11:15:14AM +0100, Will Deacon wrote:
> > > On Wed, Jun 10, 2026 at 10:26:59AM +0100, Vincent Donnefort wrote:
> > > > On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> > > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > > communicate with the secure services.
> > > > > While these calls are markes as optional, there is no reason why the
> > > > > hypervisor proxy would block them because:
> > > > > 
> > > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > > >    Because all forwarded notifications are inherently attributed to
> > > > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > > > >    originating from the Normal World.
> > > > > 
> > > > > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> > > > >    operate strictly via register-based parameters, passing only
> > > > >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> > > > >    not contain memory addresses, offsets, or pointers, forwarding
> > > > >    them doesn't pose a risk of memory-based confused deputy attack
> > > > >    (e.g., tricking the SPMC into overwriting protected memory).
> > > > > 
> > > > > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > > > > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > > > > flow is covered by the spec in the: '10.9 Notification support without
> > > > > a Hypervisor'.
> > > > 
> > > > As it is only a relayer. Is it really important to check SBZ arguments and
> > > > fields on behalf of Trustzone? It doesn't feel it brings any security. If the
> > > > host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 
> > > 
> > > I think the problem would be if an update to FF-A allocated some of the
> > > currently SBZ bits to implement some functionality that we would want
> > > to filter at EL2.
> > 
> > I suppose that would bump the FF-A version and the proxy would reject it?
> 
> Maybe? I don't think they'd _have_ to bump the version number.
> 
> > If we really want to check for those arguments to be 0:
> > 
> >  * Shouldn't we extend this check to other FF-A invocations?
> 
> yes, that's what the diff was doing in the reply here:
> 
> https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
> 
> but, as I said here:
> 
> https://lore.kernel.org/all/ahmxiFXXTupafbXw@willie-the-truck/
> 
> I don't particularly like the table-driven indirection (the checks
> should just be inlined).

Ha, sorry I'm late to the party. 

Perhaps this series should start with adding ffa_check_unused_args_sbz() to the
existing allowed FF-A invocations?

> 
> >  * Do we really want to also look into the !SBZ arguments to verify what we can?
> >    (I'm thinking about the checks on flags)
> 
> For known arguments, we only need to verify things that can affect EL2.
> I suspect we don't care about a bunch of it.
> 
> Will
