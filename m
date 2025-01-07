Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A41E2603
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736246107; cv=none; b=Qr4iY3dS5duEHg8QKLj4Js6BdVbb2UAOdA6UMMjqOOcayZnis8sKGB1vR/gBsQFhDHFkjvMq+Soytntnnqr3YBogGduZKrZ8JK8E/B5x7rGPjRMzSK9TOTxXHYr6YyHsReA4A2FaMepVcn3fzMw6x9PNnPi6fnALosewqfqeww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736246107; c=relaxed/simple;
	bh=wQeSZAP35xkhp9rjereOD9f1rGGpi+mzp5s1cCeG5Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCVetB8MasYKDTs1toNN09TMdQZDJC2n97xoMGvrpR+fE+joh8kYAih6XGE6DDhQPRwTe2yA4nidhprxWYGvrnuHX/W3bfY7dE1AljHAIyWCE/wOLVrx8HTJUni2/DFNozFoFU/Tey+d2YNmBA22NwaucFmz7KdIQZ0UE3ZMHWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/6sSNNK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/6sSNNK"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43625c4a50dso105770145e9.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 02:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736246103; x=1736850903; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QeceS72pNS9/lhTTXITmJ9WqibUxqQk+B8pi9KsGlEI=;
        b=M/6sSNNKP88p9zsZLqK5UIOWHH04Bcnnoa4KbFXXGwO0CQ8tPIluBLz+64bbjkvI7w
         sP7cbFs3FR4D3EjOmcVPeS5nHcyHTdoUqz8srE8PJ/6/WCjyVKzXJQ6NPwOI1eXn8HY0
         YC1SYq/ZvZH5Pnm8v6cyqD7k0R1gKXJ6gCTCbRzYlOd0l5xYz1D34jerXIgI+rflqCWR
         zCq65OjGy8euaZis9PfIMWj8cYwcc5HSZrixm6pH6jD/8ebfEwunsV/QtyqsX1p3K3ZU
         mxL/XvFRn4t0j3GHUOiVXMOmKDnjk/IL5DMM3DmttQ9YAu76UO9/X8dyAECssdV5J128
         waWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736246103; x=1736850903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QeceS72pNS9/lhTTXITmJ9WqibUxqQk+B8pi9KsGlEI=;
        b=jI0WIgUbruCXLFY18IaSXu9dhufEy0Gy5AVHGSyYYxbznPMK8Rva3pMU4fAMeWTSbh
         MoaYojLCK1vWIpXYj4OGUXf1kn4lozjeQl32wDzJ/wDJ5QYI3LKqVoxgBmLsylyMv+AQ
         FIuw18BqiOGvE3PxLVHln6NvMQ4UzrSR62t6p7CJEvzlZ00GW8dR6K2YYWN4HR4sAE3z
         4Cj16eFXs/bcQTHsrVoe797tGh17lj3LXoHDpxCgIRVgcGLtgq9A26wimBBez1QIzxTI
         4reINGEhjci15VhOecYzEVGUfeE89zTfnG/3VYv1PJjlgrqTzasCo480ut8Ztr2iI220
         OzQA==
X-Forwarded-Encrypted: i=1; AJvYcCW668XNCzPzru5WcRaThv5CMGctRJRkitqlknOaOfLzqCud8N4nc6AgZWXpEVEdmeRlNDoXcAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeM7U/tBkgfAZtMh7/h57k7ZcJSskMVQl4YRFv/RZMNzFWf4yD
	7Al1D5OeztDHh4NYbK3S6JaDgSWKxMAu6dg2nkO1BTvCDIkVgJ1zq0yzjeFgHg==
X-Gm-Gg: ASbGncsu0re/t9ICXcpyn1e6v3Qes+YI/OCdC7bu3CNTzBfvPq2fOq0men68EMgAiNe
	owfuFA60kvlIuzJ95Fi/gQdCyIrbW11Y0Ye2R9yiujOcmRdgfUqo4MaeSOsvl/y4FsZK6Mw+ZEV
	ejotrfWegr9bcEED+kCNglj/zRGYIo7IOzQb2XQdd0EIe0uoOztLR8Zzp1WY6J+s8WoTi8bazbQ
	ycbJLg/tQqXuOIKkZqfqENd8Juii2/oeXnoxEovCwiKKN9+TFx+nygpXNaeRYqQYNzrN9ibcPcb
	N4rMkLj0IsW4rh3O3/+pkA==
X-Google-Smtp-Source: AGHT+IGHiQ/5R0oXTPP19YJ7NE1BQsHEpwZF7WlJK5SBOue63vxyjYDaDhToA8Z190S3cgs28JINOg==
X-Received: by 2002:a05:600c:138d:b0:434:ff08:202b with SMTP id 5b1f17b1804b1-43668643173mr547315115e9.12.1736246103409;
        Tue, 07 Jan 2025 02:35:03 -0800 (PST)
Received: from google.com (202.88.205.35.bc.googleusercontent.com. [35.205.88.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43661219611sm599479635e9.23.2025.01.07.02.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 02:35:03 -0800 (PST)
Date: Tue, 7 Jan 2025 10:34:58 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, kvmarm@lists.linux.dev, kernel-team@android.com,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <zenghui.yu@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Fix nVHE stacktrace VA bits mask
Message-ID: <Z30DUhWWMZurEu33@google.com>
References: <20250106183213.4094616-1-vdonnefort@google.com>
 <86zfk3nf6j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zfk3nf6j.wl-maz@kernel.org>

On Tue, Jan 07, 2025 at 09:31:16AM +0000, Marc Zyngier wrote:
> Vincent,
> 
> Please add all the KVM/arm64 reviewers in the future (I added them
> this time).

Ack, apologies for the missing recipients.

> 
> On Mon, 06 Jan 2025 18:32:13 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > The hypervisor VA space size depends on both the ID map's
> > (IDMAP_VA_BITS) and the kernel stage-1 (VA_BITS). When VA_BITS is
> > smaller than IDMAP_VA_BITS (i.e. 39-bit), the stacktrace can contain
> > addresses bigger than the current VA_BITS mask.
> > 
> > As the hyp_va_bits value needs to be used outside of the init code now,
> > use a global variable, shared by all the kvm users in mmu.c, arm.c and
> > now stacktrace.c.
> 
> I tend to dislike this approach for at least three reasons:
> 
> - it makes it hard to follow *when* hyp_va_bits is made valid, while
>   passing the value as a parameter is self explanatory. Specially
>   given how convoluted the nVHE/pKVM init is these days.
> 
> - it prevents the eventual use of *multiple* VA bit values (one for
>   TTBR0, one for TTBR1) once the grand plan for hVHE is completed
>   (right after full NV support is merged! ;-)
> 
> - it makes the change larger than it should be, specially for
>   something that should be backported.

I was myself not completely convinced because of that last point. I'll send a v2
with a shorter version.

Thanks for your swift review! 

> 
> So I'd rather you keep the general shape of the code as it, and simply
> publish this 'hyp_va_bits' for the purpose of the backtrace code.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
